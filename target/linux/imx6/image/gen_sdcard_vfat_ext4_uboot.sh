#!/usr/bin/env bash
#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

set -x
[ $# -eq 7 ] || {
    echo "SYNTAX: $0 <file> <bootfs image> <rootfs image> <bootfs size> <rootfs size> <bin dir> <u-boot pkg name>"
    exit 1
}

OUTPUT="$1"
BOOTFS="$2"
ROOTFS="$3"
BOOTFS_SIZE="$4"
ROOTFS_SIZE="$5"
BIN_DIR="$6"
UBOOT_PKG_NAME="$7"

UBOOT_SPL="$BIN_DIR/$UBOOT_PKG_NAME/SPL"
UBOOT_IMG="$BIN_DIR/$UBOOT_PKG_NAME/u-boot.img"

if [ ! -f "$UBOOT_SPL" ] || [ ! -f "$UBOOT_IMG" ]; then
	echo "
¡U-Boot binaries not found!
===========================
Use the command 'make menuconfig',
navegate into the 'Boot Loaders' section
and make sure to select <$UBOOT_PKG_NAME>."
	exit 1
fi

head=4
sect=63

set `ptgen -o $OUTPUT -h $head -s $sect -l 1024 -t c -p ${BOOTFS_SIZE}M -t 83 -p ${ROOTFS_SIZE}M`

BOOT_OFFSET="$(($1 / 512))"
BOOT_SIZE="$(($2 / 512))"
ROOTFS_OFFSET="$(($3 / 512))"
ROOTFS_SIZE="$(($4 / 512))"

dd bs=512 if="$BOOTFS" of="$OUTPUT" seek="$BOOT_OFFSET" conv=notrunc
dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS_OFFSET" conv=notrunc

UBOOT_SPL_OFFSET=1
UBOOT_IMG_OFFSET=69

dd bs=1K if="$UBOOT_SPL" of="$OUTPUT" seek="$UBOOT_SPL_OFFSET" conv=notrunc
dd bs=1K if="$UBOOT_IMG" of="$OUTPUT" seek="$UBOOT_IMG_OFFSET" conv=notrunc

exit 0
