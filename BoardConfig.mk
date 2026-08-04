#
# Copyright (C) 2021-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Partitions
BOARD_SUPER_PARTITION_SIZE := 13329498112

# Include the common OEM chipset BoardConfig.
include device/oneplus/sm8750-common/BoardConfigCommon.mk

DEVICE_PATH := device/oneplus/dodge

# Assert
TARGET_OTA_ASSERT_DEVICE := OP5D0DL1,OP5D55L1

# Display
TARGET_SCREEN_DENSITY := 640

# Kernel
TARGET_KERNEL_ADDITIONAL_FLAGS += CONFIG_DODGE_DTB=y

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/system_ext.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# VINTF
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    $(DEVICE_PATH)/vintf/lineage_framework_matrix.xml

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 103

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
BOARD_VENDOR_SEPOLICY_DIRS += vendor/oplus/fusionlight/sepolicy/vendor
BOARD_SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private

# SEPolicy (mirrors device/lineage/sepolicy/common/sepolicy.mk)
BOARD_SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += device/lineage/sepolicy/common/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/lineage/sepolicy/common/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += device/lineage/sepolicy/mosey/system_ext/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/lineage/sepolicy/mosey/system_ext/private
BOARD_VENDOR_SEPOLICY_DIRS += device/lineage/sepolicy/common/vendor
BOARD_VENDOR_SEPOLICY_DIRS += device/lineage/sepolicy/common/dynamic
BOARD_VENDOR_SEPOLICY_DIRS += device/lineage/sepolicy/common/system
BOARD_VENDOR_SEPOLICY_DIRS += device/lineage/sepolicy/mosey/vendor

# Include the proprietary files BoardConfig.
include vendor/oneplus/dodge/BoardConfigVendor.mk

BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

# Fusion light sensor
TARGET_USES_OPLUS_FUSIONLIGHT := true
TARGET_FUSIONLIGHT_ENABLE := true
