#
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

INPUT_MODULES_MENU:=Input modules

define KernelPackage/hid
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=HID Devices
  KCONFIG:=CONFIG_HID CONFIG_HIDRAW=y
  FILES:=$(LINUX_DIR)/drivers/hid/hid.ko
  AUTOLOAD:=$(call AutoLoad,61,hid)
  $(call AddDepends/input,+kmod-input-evdev)
endef

define KernelPackage/hid/description
 Kernel modules for HID devices
endef

$(eval $(call KernelPackage,hid))

define KernelPackage/hid-generic
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Generic HID device support
  KCONFIG:=CONFIG_HID_GENERIC
  FILES:=$(LINUX_DIR)/drivers/hid/hid-generic.ko
  AUTOLOAD:=$(call AutoProbe,hid-generic)
  $(call AddDepends/hid)
endef

define KernelPackage/hid-generic/description
 Kernel modules for generic HID device (e.g. keyboards and mice) support
endef

$(eval $(call KernelPackage,hid-generic))

#$$fb
define KernelPackage/hid-bome
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=More HID device drivers (bome)
  KCONFIG:=\
CONFIG_HID_A4TECH \
CONFIG_HID_APPLE \
CONFIG_HID_AUREAL \
CONFIG_HID_BELKIN \
CONFIG_HID_CHERRY \
CONFIG_HID_CHICONY \
CONFIG_HID_CYPRESS \
CONFIG_HID_DRAGONRISE \
CONFIG_HID_ELECOM \
CONFIG_HID_EMS_FF=n \
CONFIG_HID_EZKEY \
CONFIG_HID_GREENASIA \
CONFIG_HID_GYRATION \
CONFIG_HID_HOLTEK \
CONFIG_HOLTEK_FF=n \
CONFIG_HID_KENSINGTON \
CONFIG_HID_KEYTOUCH \
CONFIG_HID_KYE \
CONFIG_HID_LCPOWER \
CONFIG_HID_LOGITECH \
CONFIG_HID_LOGITECH_DJ=y \
CONFIG_LOGIG940_FF=n \
CONFIG_LOGIWHEELS_FF=n \
CONFIG_LOGIRUMBLEPAD2_FF=n \
CONFIG_HID_MAGICMOUSE \
CONFIG_HID_MICROSOFT \
CONFIG_HID_MONTEREY \
CONFIG_HID_ORTEK \
CONFIG_HID_PRIMAX \
CONFIG_HID_ROCCAT \
CONFIG_HID_SAITEK \
CONFIG_HID_SAMSUNG \
CONFIG_HID_SONY \
CONFIG_HID_SPEEDLINK \
CONFIG_HID_STEELSERIES \
CONFIG_HID_SUNPLUS \
CONFIG_HID_THINGM \
CONFIG_HID_THRUSTMASTER \
CONFIG_HID_TOPSEED \
CONFIG_HID_TWINHAN \
CONFIG_HID_UCLOGIC \
CONFIG_HID_WACOM \
CONFIG_HID_WALTOP \
CONFIG_HID_ZEROPLUS \
CONFIG_HID_ZYDACRON

# disable these for now
#CONFIG_HID_ACRUX \
#CONFIG_HID_APPLEIR \
#CONFIG_HID_ICADE \
#CONFIG_HID_LENOVO_TPKBD \
#CONFIG_HID_PANTHERLORD \
#CONFIG_HID_PETALYNX \
#CONFIG_HID_PID=y \
#CONFIG_HID_PS3REMOTE \
#CONFIG_HID_SENSOR_HUB \
#CONFIG_HID_SMARTJOYPLUS \
#CONFIG_HID_WIIMOTE \
#CONFIG_HID_WIIMOTE_EXT=y \

  FILES:=\
$(LINUX_DIR)/drivers/hid/hid-a4tech.ko \
$(LINUX_DIR)/drivers/hid/hid-apple.ko \
$(LINUX_DIR)/drivers/hid/hid-aureal.ko \
$(LINUX_DIR)/drivers/hid/hid-belkin.ko \
$(LINUX_DIR)/drivers/hid/hid-cherry.ko \
$(LINUX_DIR)/drivers/hid/hid-chicony.ko \
$(LINUX_DIR)/drivers/hid/hid-cypress.ko \
$(LINUX_DIR)/drivers/hid/hid-dr.ko \
$(LINUX_DIR)/drivers/hid/hid-elecom.ko \
$(LINUX_DIR)/drivers/hid/hid-ezkey.ko \
$(LINUX_DIR)/drivers/hid/hid-gaff.ko \
$(LINUX_DIR)/drivers/hid/hid-gyration.ko \
$(LINUX_DIR)/drivers/hid/hid-holtekff.ko \
$(LINUX_DIR)/drivers/hid/hid-holtek-kbd.ko \
$(LINUX_DIR)/drivers/hid/hid-kensington.ko \
$(LINUX_DIR)/drivers/hid/hid-keytouch.ko \
$(LINUX_DIR)/drivers/hid/hid-kye.ko \
$(LINUX_DIR)/drivers/hid/hid-lcpower.ko \
$(LINUX_DIR)/drivers/hid/hid-logitech-dj.ko \
$(LINUX_DIR)/drivers/hid/hid-logitech.ko \
$(LINUX_DIR)/drivers/hid/hid-magicmouse.ko \
$(LINUX_DIR)/drivers/hid/hid-microsoft.ko \
$(LINUX_DIR)/drivers/hid/hid-monterey.ko \
$(LINUX_DIR)/drivers/hid/hid-ortek.ko \
$(LINUX_DIR)/drivers/hid/hid-primax.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-arvo.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-common.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-isku.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-kone.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-koneplus.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-konepure.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-kovaplus.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-lua.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-pyra.ko \
$(LINUX_DIR)/drivers/hid/hid-roccat-savu.ko \
$(LINUX_DIR)/drivers/hid/hid-saitek.ko \
$(LINUX_DIR)/drivers/hid/hid-samsung.ko \
$(LINUX_DIR)/drivers/hid/hid-sony.ko \
$(LINUX_DIR)/drivers/hid/hid-speedlink.ko \
$(LINUX_DIR)/drivers/hid/hid-steelseries.ko \
$(LINUX_DIR)/drivers/hid/hid-sunplus.ko \
$(LINUX_DIR)/drivers/hid/hid-thingm.ko \
$(LINUX_DIR)/drivers/hid/hid-tmff.ko \
$(LINUX_DIR)/drivers/hid/hid-topseed.ko \
$(LINUX_DIR)/drivers/hid/hid-twinhan.ko \
$(LINUX_DIR)/drivers/hid/hid-uclogic.ko \
$(LINUX_DIR)/drivers/hid/hid-wacom.ko \
$(LINUX_DIR)/drivers/hid/hid-waltop.ko \
$(LINUX_DIR)/drivers/hid/hid-zpff.ko \
$(LINUX_DIR)/drivers/hid/hid-zydacron.ko

#$(LINUX_DIR)/drivers/hid/hid-appleir.ko \
#$(LINUX_DIR)/drivers/hid/hid-axff.ko \
#$(LINUX_DIR)/drivers/hid/hid-emsff.ko \
#$(LINUX_DIR)/drivers/hid/hid-icade.ko \
#$(LINUX_DIR)/drivers/hid/hid-lenovo-tpkbd.ko \
#$(LINUX_DIR)/drivers/hid/hid-pl.ko \
#$(LINUX_DIR)/drivers/hid/hid-petalynx.ko \
#$(LINUX_DIR)/drivers/hid/hid-ps3remote.ko \
#$(LINUX_DIR)/drivers/hid/hid-sensor-hub.ko \
#$(LINUX_DIR)/drivers/hid/hid-sjoy.ko \
#$(LINUX_DIR)/drivers/hid/hid-wiimote.ko \

  AUTOLOAD:=$(call AutoProbe,\
hid-a4tech \
hid-apple \
hid-aureal \
hid-belkin \
hid-cherry \
hid-chicony \
hid-cypress \
hid-dr \
hid-elecom \
hid-emsff \
hid-ezkey \
hid-gaff \
hid-gyration \
hid-holtekff \
hid-holtek-kbd \
hid-kensington \
hid-keytouch \
hid-kye \
hid-lcpower \
hid-logitech-dj \
hid-logitech \
hid-magicmouse \
hid-microsoft \
hid-monterey \
hid-ortek \
hid-primax \
hid-roccat-arvo \
hid-roccat-common \
hid-roccat-isku \
hid-roccat \
hid-roccat-kone \
hid-roccat-koneplus \
hid-roccat-konepure \
hid-roccat-kovaplus \
hid-roccat-lua \
hid-roccat-pyra \
hid-roccat-savu \
hid-saitek \
hid-samsung \
hid-sjoy \
hid-sony \
hid-speedlink \
hid-steelseries \
hid-sunplus \
hid-thingm \
hid-tmff \
hid-topseed \
hid-twinhan \
hid-uclogic \
hid-wacom \
hid-waltop \
hid-zpff \
hid-zydacron \
)
  $(call AddDepends/input,+kmod-usb-core +kmod-hid)
endef

define KernelPackage/hid-bome/description
 Kernel modules for additional HID devices (bome added)
endef

$(eval $(call KernelPackage,hid-bome))

define KernelPackage/input-core
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Input device core
  KCONFIG:=CONFIG_INPUT
  FILES:=$(LINUX_DIR)/drivers/input/input-core.ko
endef

define KernelPackage/input-core/description
 Kernel modules for support of input device
endef

$(eval $(call KernelPackage,input-core))


define KernelPackage/input-evdev
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Input event device
  KCONFIG:=CONFIG_INPUT_EVDEV
  FILES:=$(LINUX_DIR)/drivers/input/evdev.ko
  AUTOLOAD:=$(call AutoLoad,60,evdev)
  $(call AddDepends/input)
endef

define KernelPackage/input-evdev/description
 Kernel modules for support of input device events
endef

$(eval $(call KernelPackage,input-evdev))


define KernelPackage/input-gpio-keys
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=GPIO key support
  DEPENDS:= @GPIO_SUPPORT
  KCONFIG:= \
	CONFIG_KEYBOARD_GPIO \
	CONFIG_INPUT_KEYBOARD=y
  FILES:=$(LINUX_DIR)/drivers/input/keyboard/gpio_keys.ko
  AUTOLOAD:=$(call AutoProbe,gpio_keys)
  $(call AddDepends/input)
endef

define KernelPackage/input-gpio-keys/description
 This driver implements support for buttons connected
 to GPIO pins of various CPUs (and some other chips).
endef

$(eval $(call KernelPackage,input-gpio-keys))


define KernelPackage/input-gpio-keys-polled
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Polled GPIO key support
  DEPENDS:=@GPIO_SUPPORT +kmod-input-polldev
  KCONFIG:= \
	CONFIG_KEYBOARD_GPIO_POLLED \
	CONFIG_INPUT_KEYBOARD=y
  FILES:=$(LINUX_DIR)/drivers/input/keyboard/gpio_keys_polled.ko
  AUTOLOAD:=$(call AutoProbe,gpio_keys_polled,1)
  $(call AddDepends/input)
endef

define KernelPackage/input-gpio-keys-polled/description
 Kernel module for support polled GPIO keys input device
endef

$(eval $(call KernelPackage,input-gpio-keys-polled))


define KernelPackage/input-gpio-encoder
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=GPIO rotay encoder
  KCONFIG:=CONFIG_INPUT_GPIO_ROTARY_ENCODER
  FILES:=$(LINUX_DIR)/drivers/input/misc/rotary_encoder.ko
  AUTOLOAD:=$(call AutoProbe,rotary_encoder)
  $(call AddDepends/input,@GPIO_SUPPORT)
endef

define KernelPackage/gpio-encoder/description
 Kernel module to use rotary encoders connected to GPIO pins
endef

$(eval $(call KernelPackage,input-gpio-encoder))


define KernelPackage/input-joydev
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Joystick device support
  KCONFIG:=CONFIG_INPUT_JOYDEV
  FILES:=$(LINUX_DIR)/drivers/input/joydev.ko
  AUTOLOAD:=$(call AutoProbe,joydev)
  $(call AddDepends/input)
endef

define KernelPackage/input-joydev/description
 Kernel module for joystick support
endef

$(eval $(call KernelPackage,input-joydev))


define KernelPackage/input-polldev
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Polled Input device support
  KCONFIG:=CONFIG_INPUT_POLLDEV
  FILES:=$(LINUX_DIR)/drivers/input/input-polldev.ko
  $(call AddDepends/input)
endef

define KernelPackage/input-polldev/description
 Kernel module for support of polled input devices
endef

$(eval $(call KernelPackage,input-polldev))


define KernelPackage/input-matrixkmap
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=Input matrix devices support
  KCONFIG:=CONFIG_INPUT_MATRIXKMAP
  DEPENDS:=@!LINUX_3_3
  FILES:=$(LINUX_DIR)/drivers/input/matrix-keymap.ko
  AUTOLOAD:=$(call AutoProbe,matrix-keymap)
  $(call AddDepends/input)
endef

define KernelPackage/input-matrix/description
 Kernel module support for input matrix devices
endef

$(eval $(call KernelPackage,input-matrixkmap))


define KernelPackage/acpi-button
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=ACPI Button Support
  DEPENDS:=@(TARGET_x86_generic||TARGET_x86_kvm_guest||TARGET_x86_xen_domu) +kmod-input-evdev
  KCONFIG:=CONFIG_ACPI_BUTTON
  FILES:=$(LINUX_DIR)/drivers/acpi/button.ko
  AUTOLOAD:=$(call AutoLoad,06,button)
endef

define KernelPackage/acpi-button/description
 Kernel module for ACPI Button support
endef

$(eval $(call KernelPackage,acpi-button))


define KernelPackage/keyboard-imx
  SUBMENU:=$(INPUT_MODULES_MENU)
  TITLE:=IMX keypad support
  DEPENDS:=@(TARGET_mxs||TARGET_imx6) +kmod-input-matrixkmap
  KCONFIG:= \
	CONFIG_KEYBOARD_IMX \
	CONFIG_INPUT_KEYBOARD=y
  FILES:=$(LINUX_DIR)/drivers/input/keyboard/imx_keypad.ko
  AUTOLOAD:=$(call AutoProbe,imx_keypad)
endef

define KernelPackage/keyboard-imx/description
 Enable support for IMX keypad port.
endef

$(eval $(call KernelPackage,keyboard-imx))
