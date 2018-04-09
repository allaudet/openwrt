#!/usr/bin/env bash
# This script is intended to automate the deployment process

#------------------------------------------------------------------------------#
# Set options
#------------------------------------------------------------------------------#

# Make the script exit when a command fails.
set -e

# Make the script exit when it tries to use undeclared variables.
set -u

#------------------------------------------------------------------------------#
# Global Variables
#------------------------------------------------------------------------------#

SOURCE="${BASH_SOURCE[0]}"
REL_DIR="$(dirname "$SOURCE")"
ROOT_DIR="$(cd "$REL_DIR/.." && pwd)"

BIN_DIR="$ROOT_DIR/bin/targets/imx6/cortexa7"

SDCARD_IMG="openwrt-imx6-cortexa7-var-6ulcustomboard-ext4-sdcard.img"
UBI_IMG="openwrt-imx6-cortexa7-var-6ulcustomboard-squashfs-nand.ubi"

PHY_DEV="sdc"

IMG_NAME="openwrt-ext4-sdcard-v5.1.img"

#------------------------------------------------------------------------------#
# Functions
#------------------------------------------------------------------------------#

gunzip_sdcard_img() {
	if [ -f "${BIN_DIR}/${SDCARD_IMG}.gz" ]; then
		rm -rf "${BIN_DIR:?}/${SDCARD_IMG}"
		gunzip "${BIN_DIR}/${SDCARD_IMG}.gz"
		mv "${BIN_DIR}/${SDCARD_IMG}" "${BIN_DIR}/${IMG_NAME}"
	fi
}

prepare_sdcard() {
	# partition 1: 2048 * 512 = 1048576
	# partition 2: 20480 * 512 = 10485760
	sudo mount -o loop,offset=10485760 "${BIN_DIR}/${IMG_NAME}" /mnt

	sudo cp "${BIN_DIR}/${UBI_IMG}" /mnt/etc/nand_firmware/openwrt.ubi
	for file in ${BIN_DIR}/u-boot-mx6ul_var_dart_nand/*; do
		sudo cp "$file" /mnt/etc/nand_firmware
	done

	sync
	sudo umount /mnt
	sync
}

burn_sdcard() {
	umount -l /dev/${PHY_DEV}1
	umount -l /dev/${PHY_DEV}2
	sync
	sudo dd if="${BIN_DIR}/${IMG_NAME}" of=/dev/${PHY_DEV} conv=fsync
	sync
}

#------------------------------------------------------------------------------#
# Core
#------------------------------------------------------------------------------#

echo "Extracting the image..."
gunzip_sdcard_img
echo "Preparing the image..."
prepare_sdcard
echo "Burning the image..."
burn_sdcard

exit 0
