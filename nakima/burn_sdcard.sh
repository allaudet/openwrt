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

IMG_NAME="openwrt-ext4-sdcard-v2.9.3.img"

BURN_SDCARD=0

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

	sudo sed -i "s/option enabled '1'/option enabled '0'/" \
		/mnt/etc/config/autossh

	sudo cp "$ROOT_DIR/nakima/custom-sd-files/wireless" \
		/mnt/etc/config/wireless

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
# Options
#------------------------------------------------------------------------------#

USAGE="Usage: $0 [OPTION]...
Prepares the sdcard image with all required u-boot raw files.

Options:
  -b                          also burns the sdcard
  -h                          display this help and exit
"

while getopts ":bh:" opt; do
    case "${opt}" in
        b)
            BURN_SDCARD=1
            ;;
        h)
            echo "${USAGE}" 1>&2
            exit 0
            ;;
        *)
            echo "${USAGE}" 1>&2
            exit 1
            ;;
    esac
done

#------------------------------------------------------------------------------#
# Core
#------------------------------------------------------------------------------#

echo "Extracting the image..."
gunzip_sdcard_img

echo "Preparing the image..."
prepare_sdcard

if [ "${BURN_SDCARD}" -eq 1 ]; then
    echo "Burning the image..."
    burn_sdcard
fi

exit 0
