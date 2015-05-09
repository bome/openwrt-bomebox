#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/BOMEBOX
        NAME:=BomeBox config
        PACKAGES:=kmod-usb-core kmod-usb2
endef

define Profile/BOMEBOX/Description
        Package set optimized for the BomeBox.
endef

$(eval $(call Profile,BOMEBOX))
