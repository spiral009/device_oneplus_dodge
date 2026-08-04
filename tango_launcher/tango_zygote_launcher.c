// tango_zygote_launcher — stands up a 32-bit "zygote_secondary" without init.
//
// On a stock device, init creates the zygote_secondary socket and passes its fd
// to app_process32 via $ANDROID_SOCKET_zygote_secondary. On this ARM64-only
// device we can't get init to define that service, so this helper replicates it:
//   1. create AF_UNIX SOCK_STREAM sockets /dev/socket/{zygote_secondary,
//      usap_pool_secondary} (0660 root:system), listen()
//   2. export ANDROID_SOCKET_<name>=<fd> (fds left non-CLOEXEC so they survive)
//   3. exec app_process32 in --zygote mode, FORWARDING our own argv as VM args
//      so flags (e.g. -Xgc:CMS -Xint, both required under tango) can be tuned
//      without recompiling: tango_zygote_launcher <vmarg1> <vmarg2> ...
//
// Required tango flags: -Xgc:CMS (no userfaultfd GC) and -Xint (no JIT: tango is
// a static translator, runtime-JIT'd arm32 code isn't translated -> SIGSEGV).

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>

#define SYSTEM_GID 1000  /* AID_SYSTEM */
#define APP_PROCESS32 "/data/local/tmp/a32/bin/app_process32"

static int make_listen_socket(const char *path) {
    unlink(path);
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) { fprintf(stderr, "socket(%s): %s\n", path, strerror(errno)); return -1; }
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, path, sizeof(addr.sun_path) - 1);
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        fprintf(stderr, "bind(%s): %s\n", path, strerror(errno)); close(fd); return -1;
    }
    chmod(path, 0660);
    chown(path, 0, SYSTEM_GID);
    if (listen(fd, 8) < 0) {
        fprintf(stderr, "listen(%s): %s\n", path, strerror(errno)); close(fd); return -1;
    }
    int flags = fcntl(fd, F_GETFD);
    if (flags >= 0) fcntl(fd, F_SETFD, flags & ~FD_CLOEXEC);
    return fd;
}

static void export_socket_fd(const char *sockname, int fd) {
    char var[128], val[16];
    snprintf(var, sizeof(var), "ANDROID_SOCKET_%s", sockname);
    snprintf(val, sizeof(val), "%d", fd);
    setenv(var, val, 1);
}

int main(int argc, char **argv) {
    int zfd = make_listen_socket("/dev/socket/zygote_secondary");
    if (zfd < 0) return 1;
    export_socket_fd("zygote_secondary", zfd);

    int ufd = make_listen_socket("/dev/socket/usap_pool_secondary");
    if (ufd >= 0) export_socket_fd("usap_pool_secondary", ufd);

    setenv("LD_LIBRARY_PATH", "/data/local/tmp/a32/lib", 1);
    setenv("ANDROID_ROOT", "/system", 1);
    setenv("ANDROID_DATA", "/data", 1);
    /* BOOTCLASSPATH / DEX2OATBOOTCLASSPATH inherited from service.sh. */

    /* Build: app_process32 -Xzygote <forwarded VM args...> /system/bin
       --zygote --socket-name=zygote_secondary --enable-lazy-preload */
    int nfwd = (argc > 1) ? (argc - 1) : 0;
    int n = 0;
    char **args = (char **)calloc(2 + nfwd + 5, sizeof(char *));
    args[n++] = (char *)APP_PROCESS32;
    args[n++] = (char *)"-Xzygote";
    for (int j = 1; j < argc; j++) args[n++] = argv[j];
    args[n++] = (char *)"/system/bin";
    args[n++] = (char *)"--zygote";
    args[n++] = (char *)"--socket-name=zygote_secondary";
    args[n++] = (char *)"--enable-lazy-preload";
    args[n] = NULL;

    execv(APP_PROCESS32, args);
    fprintf(stderr, "execv(%s): %s\n", APP_PROCESS32, strerror(errno));
    return 1;
}
