#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

ifeq ($(SUBTARGET),cortexa7)

define Device/var-6ulcustomboard
  KERNEL_SUFFIX := -zImage
  KERNEL := kernel-bin
  DEVICE_TITLE := VAR-6ULCustomBoard
  DEVICE_DTS_DIR := ../dts
  DTS_DIR := ../dts
  DEVICE_DTS := \
	imx6ul-var-dart-emmc_wifi \
	imx6ul-var-dart-nand_wifi \
	imx6ul-var-dart-sd_emmc \
	imx6ul-var-dart-sd_nand
  DEVICE_PACKAGES := \
	kmod-sky2 kmod-sound-core kmod-sound-soc-imx kmod-sound-soc-imx-sgtl5000 \
	kmod-can kmod-can-flexcan kmod-can-raw \
	kmod-hwmon-gsc \
	kmod-leds-gpio kmod-pps-gpio \
	kmod-brcmfmac \
		brcmfmac-firmware-4329-sdio \
		brcmfmac-firmware-43362-sdio \
		brcmfmac-firmware-43430-sdio \
	kobs-ng nand-utils \
	ip-full \
	u-boot-mx6ul_var_dart_mmc u-boot-mx6ul_var_dart_nand
  KERNEL += | boot-overlay
  IMAGES := nand.ubi sdcard.img
  UBINIZE_PARTS = boot=$$(KDIR_KERNEL_IMAGE).boot.ubifs=15
  IMAGE/nand.ubi := append-ubi
  IMAGE/sdcard.img := sdcard.img u-boot-mx6ul_var_dart_mmc
  IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1)-$$(2)
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  MKUBIFS_OPTS := -m $$(PAGESIZE) -e 124KiB
endef

TARGET_DEVICES += var-6ulcustomboard

endif
