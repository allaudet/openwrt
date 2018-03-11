#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

SUBTARGET:=cortexa9
BOARDNAME:=Freescale i.MX 6 Cortex-A9 based boards
CPU_TYPE:=cortex-a9
CPU_SUBTYPE:=neon

define Target/Description
	Build firmware image for Freescale i.MX 6 Cortex-A9 SoC devices.
endef
