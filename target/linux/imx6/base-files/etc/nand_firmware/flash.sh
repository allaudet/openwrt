#!/usr/bin/env sh

#Creating 5 MTD partitions on "gpmi-nand":
#0x000000000000-0x000000200000 : "spl"
#0x000000200000-0x000000400000 : "uboot"
#0x000000400000-0x000000600000 : "uboot-env"
#0x000000600000-0x000040000000 : "openwrt"

# Global Variables
# =============================================================================
ROOT_PATH="/etc/nand_firmware"

UBOOT_SPL="${ROOT_PATH}/SPL"
UBOOT_IMG="${ROOT_PATH}/u-boot.img"
UBI_IMG="${ROOT_PATH}/openwrt.ubi"

UBI_PAGESIZE="2048"

# 1. install_bootloader (spl + uboot + uboot-env)
# =============================================================================
flash_erase /dev/mtd0 0 0 2>/dev/null;sync
kobs-ng init -x "${UBOOT_SPL}" --search_exponent=1 -v > /dev/null
sync

flash_erase /dev/mtd1 0 0 2>/dev/null;sync
nandwrite -p /dev/mtd1 "${UBOOT_IMG}"
sync

flash_erase /dev/mtd2 0 0 2>/dev/null;sync

# 2. install_ubi_openwrt_filesystem (boot + rootfs + rootfs_data)
# =============================================================================
flash_erase  /dev/mtd3 0 0 2>/dev/null;sync
ubiformat /dev/mtd3 -f "${UBI_IMG}" -s "${UBI_PAGESIZE}" -O "${UBI_PAGESIZE}"
sync

exit 0
