#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=cortexa7
BOARDNAME:=Freescale i.MX 6 Cortex-A7 based boards
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=neon
FEATURES += ext4

define Target/Description
	Build firmware image for Freescale i.MX 6 Cortex-A7 SoC devices.
endef
