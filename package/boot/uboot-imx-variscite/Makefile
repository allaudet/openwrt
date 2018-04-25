#
# Copyright (C) 2013-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_SOURCE_URL:=https://github.com/varigit/uboot-imx.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=9749eb94da26fe536ccb470b4fd6f7f1f88ff495
PKG_SOURCE_DATE:=2017-05-11

PKG_RELEASE:=1

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx6
  UBOOT_IMAGE:=SPL u-boot.img
endef

define U-Boot/mx6ul_var_dart_mmc
  NAME:=MMC DART-6UL-VAR i.MX6 UltraLite board
endef

define U-Boot/mx6ul_var_dart_nand
  NAME:=NAND DART-6UL-VAR i.MX6 UltraLite board
endef

UBOOT_TARGETS := \
	mx6ul_var_dart_mmc \
	mx6ul_var_dart_nand

$(eval $(call BuildPackage/U-Boot))
