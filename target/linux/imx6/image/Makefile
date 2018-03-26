#
# Copyright (C) 2013-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_BOOTFS_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

#################################################
# Images
#################################################

DEVICE_VARS += MKUBIFS_OPTS

define Build/boot-overlay
	rm -rf $@.boot
	mkdir -p $@.boot

	$(CP) $@ $@.boot/$(IMG_PREFIX)$(KERNEL_SUFFIX)
	ln -sf $(IMG_PREFIX)$(KERNEL_SUFFIX) $@.boot/$(subst -,,$(KERNEL_SUFFIX))

	$(foreach dts,$(DEVICE_DTS), \
		$(CP) \
			$(KDIR)/image-$(dts).dtb \
			$@.boot/$(IMG_PREFIX)-$(dts).dtb; \
		ln -sf \
			$(IMG_PREFIX)-$(dts).dtb \
			$@.boot/$(dts).dtb; \
	)

	test ! -f ./bootscript-$(DEVICE_NAME) || \
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
		-n '$(DEVICE_ID) OpenWrt bootscript' \
		-d ./bootscript-$(DEVICE_NAME) \
		$@.boot/6x_bootscript-$(DEVICE_NAME)

	$(STAGING_DIR_HOST)/bin/mkfs.ubifs \
		--space-fixup --compr=zlib --squash-uids \
		$(MKUBIFS_OPTS) -c 8124 \
		-o $@.boot.ubifs -d $@.boot

	$(TAR) -C $@.boot -cf $@.boot.tar .
endef

define Build/bootfs.tar.gz
	rm -rf $@.boot
	mkdir -p $@.boot

	$(TAR) -C $@.boot -xf $(IMAGE_KERNEL).boot.tar
	$(TAR) -C $@.boot \
		--numeric-owner --owner=0 --group=0 --transform "s,./,./boot/," \
		-czvf $@ .
endef

# $(1): U-BOOT package that will be burned on the sdcard
define Build/sdcard.img
	rm -rf $@.boot.img
	mkfs.fat $@.boot.img -C $(FAT32_BLOCKS)

	rm -rf $@.boot
	mkdir -p $@.boot

	$(TAR) -C $@.boot -xf $(IMAGE_KERNEL).boot.tar
	$(foreach file,$(wildcard $@.boot/*), mcopy -i $@.boot.img $(file) ::;)

	./gen_sdcard_vfat_ext4_uboot.sh \
		$@ \
		$@.boot.img \
		$(word 2,$^) \
		$(CONFIG_TARGET_BOOTFS_PARTSIZE) \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) \
		$(BIN_DIR) \
		$(1)
endef

#################################################
# Devices
#################################################

KERNEL_LOADADDR=0x10008000

define Device/Default
  PROFILES := Generic
  FILESYSTEMS := squashfs ext4
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  KERNEL_NAME := zImage
  KERNEL_PREFIX := $$(IMAGE_PREFIX)
  KERNEL := kernel-bin | uImage none
  IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
  IMAGES :=
endef

include cortex-a7.mk
include cortex-a9.mk

$(eval $(call BuildImage))
