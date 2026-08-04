#
# Copyright (C) 2021-2026 The RisingOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from dodge device
$(call inherit-product, device/oneplus/dodge/device.mk)

# Include Lineage BoardConfig for kernel variables (KERNEL_BUILD_OUT_PREFIX, etc.)
TARGET_KERNEL_SOURCE := kernel/oneplus/sm8750
TARGET_KERNEL_ARCH := arm64
include vendor/lineage/config/BoardConfigLineage.mk

# Inherit some common RisingOS stuff.
$(call inherit-product, vendor/rising/config/rising.mk)

PRODUCT_NAME := rising_dodge
PRODUCT_DEVICE := dodge
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := CPH2653

TARGET_HAS_UDFPS := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_DISABLE_EPPE := true
DISABLE_DEXPREOPT_CHECK := true
WITH_GMS := true
TARGET_INCLUDE_LIVE_WALLPAPERS := true
TARGET_CUSTOM_UDFPS := true
SURFACE_FLINGER_BOOST := true

# VINTF: Disable kernel requirement enforcement (CONFIG_MODULE_FORCE_UNLOAD=y and CONFIG_SYSVIPC=y are intentional)
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Display soong config (required for qtidisplay_defaults → display_headers)
SOONG_CONFIG_NAMESPACES += qtidisplay
SOONG_CONFIG_qtidisplay := default headless gralloc4 drmpp llvmsa smmu_proxy ubwcp_headers neo var3 composer_version
SOONG_CONFIG_qtidisplay_default := true
SOONG_CONFIG_qtidisplay_gralloc4 := true
SOONG_CONFIG_qtidisplay_drmpp := true
SOONG_CONFIG_qtidisplay_headless := false
SOONG_CONFIG_qtidisplay_llvmsa := false
SOONG_CONFIG_qtidisplay_smmu_proxy := false
SOONG_CONFIG_qtidisplay_ubwcp_headers := false
SOONG_CONFIG_qtidisplay_neo := false
SOONG_CONFIG_qtidisplay_var3 := false
SOONG_CONFIG_qtidisplay_composer_version := v3_3

TARGET_SUPPORTED_REFRESH_RATES := 60,90,120
BYPASS_CHARGE_SUPPORTED := true

PRODUCT_GMS_CLIENTID_BASE := android-oneplus

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="qssi_64-user 16 BP2A.250605.015 1775048494038 release-keys" \
    BuildFingerprint=OnePlus/CPH2653EEA/OP5D55L1:16/BP2A.250605.015/V.R4T3.535a14b-3024561-302455e:user/release-keys \
    DeviceName=OP5D55L1 \
    DeviceProduct=CPH2653 \
    SystemDevice=OP5D55L1 \
    SystemName=CPH2653
