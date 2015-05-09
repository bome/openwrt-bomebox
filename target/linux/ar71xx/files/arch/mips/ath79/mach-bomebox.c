/*
 *  BomeBox support
 *  Copyright (C) 2014 Bome Software GmbH & Co. KG
 *
 *  Based on:
 *  8devices Carambola2 board support
 *
 *  Copyright (C) 2013 Darius Augulis <darius@8devices.com>
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License version 2 as published
 *  by the Free Software Foundation.
 */

#include <asm/mach-ath79/ath79.h>
#include <asm/mach-ath79/ar71xx_regs.h>
#include "common.h"
#include "dev-eth.h"
#include "dev-gpio-buttons.h"
#include "dev-leds-gpio.h"
#include "dev-m25p80.h"
#include "dev-spi.h"
#include "dev-usb.h"
#include "dev-wmac.h"
#include "machtypes.h"
#include "linux/i2c-gpio.h"
#include "linux/platform_device.h"

#include <linux/spinlock.h>
#include <linux/io.h>
#include <linux/ioport.h>
#include <linux/gpio.h>

#define BOME_HAS_I2C  0

#define PROTO2

#ifdef PROTO2
#define BOMEBOX_GPIO_LED_WIFI		1
#define BOMEBOX_GPIO_LED_PAIRING	0
#define BOMEBOX_GPIO_LED_POWER		15
#else
#define BOMEBOX_GPIO_LED_WIFI		0
#define BOMEBOX_GPIO_LED_PAIRING	15
#define BOMEBOX_GPIO_LED_POWER		1
#endif

#define BOMEBOX_GPIO_LED_ETH0		14
#define BOMEBOX_GPIO_LED_ETH1		13

#define BOMEBOX_GPIO_BTN_PAIRING	11
#define BOMEBOX_GPIO_BTN_WIFI		23

#define BOMEBOX_KEYS_POLL_INTERVAL		20	/* msecs */
#define BOMEBOX_KEYS_DEBOUNCE_INTERVAL	(3 * BOMEBOX_KEYS_POLL_INTERVAL)

#define BOMEBOX_MAC0_OFFSET			0x0000
#define BOMEBOX_MAC1_OFFSET			0x0006
#define BOMEBOX_CALDATA_OFFSET		0x1000
#define BOMEBOX_WMAC_MAC_OFFSET		0x1002

static struct gpio_led bomebox_leds_gpio[] __initdata = {
	{
		.name		= "bomebox:green:pairing",
		.gpio		= BOMEBOX_GPIO_LED_PAIRING,
		.active_low	= 0,
	},
	{
		.name		= "bomebox:green:wifi",
		.gpio		= BOMEBOX_GPIO_LED_WIFI,
#ifdef PROTO2
		.active_low	= 0,
#else
		.active_low	= 0,
#endif
	},
	{
		.name		= "bomebox:green:eth0",
		.gpio		= BOMEBOX_GPIO_LED_ETH0,
		.active_low	= 0,
	},
	{
		.name		= "bomebox:green:eth1",
		.gpio		= BOMEBOX_GPIO_LED_ETH1,
		.active_low	= 0,
	},
	{
		.name		= "bomebox:green:power",
		.gpio		= BOMEBOX_GPIO_LED_POWER,
#ifdef PROTO2
		.active_low	= 0,
#else
		.active_low	= 0,
#endif
		.default_trigger = "timer",
	}
};

static struct gpio_keys_button bomebox_gpio_keys[] __initdata = {
	{
		.desc		= "Pairing button",
		.type		= EV_KEY,
		.code		= BTN_0,
		.debounce_interval = BOMEBOX_KEYS_DEBOUNCE_INTERVAL,
		.gpio		= BOMEBOX_GPIO_BTN_PAIRING,
		.active_low	= 1,
	},
	{
		.desc		= "WiFi button",
		.type		= EV_KEY,
		.code		= BTN_1,
		.debounce_interval = BOMEBOX_KEYS_DEBOUNCE_INTERVAL,
		.gpio		= BOMEBOX_GPIO_BTN_WIFI,
		.active_low	= 1,
	}
};

#if BOME_HAS_I2C
static struct i2c_gpio_platform_data bomebox_i2c_gpio_data = {
	.sda_pin        = 18,
	.scl_pin        = 19,
};

static struct platform_device bomebox_i2c_gpio = {
	.name           = "i2c-gpio",
	.id             = 0,
	.dev     = {
		.platform_data  = &bomebox_i2c_gpio_data,
	},
};

static struct platform_device *bomebox_devices[] __initdata = {
        &bomebox_i2c_gpio
};
#endif //BOME_HAS_I2C

// $$fb not defined in ar71xx_regs.h
#define AR933X_GPIO_REG_FUNC2            0x30

#define AR933X_GPIO_FUNC2_XLNA_EN       BIT(12) // Enables control to the external LNA on GPIO28
#define AR933X_GPIO_FUNC2_WLAN_LED2_EN  BIT(11) // Enables the second WLAN LED function on GPIO1
#define AR933X_GPIO_FUNC2_WLAN_LED1_EN  BIT(10) // Enables the first WLAN LED function on GPIO0
#define AR933X_GPIO_FUNC2_JUMPSTART_DISABLE BIT(9) // Disables Jumpstart input function on GPIO11
#define AR933X_GPIO_FUNC2_WPS_DISABLE    BIT(8)  // Disables the WPS input function on GPIO12
#define AR933X_GPIO_FUNC2_I2SD_ON_12     BIT(5)  // Enables I2S_SD output signal on GPIO_12
#define AR933X_GPIO_FUNC2_EN_I2SWS_ON_0  BIT(4)  // Enables I2S_WS on GPIO_0
#define AR933X_GPIO_FUNC2_EN_I2SCK_ON_1  BIT(3)  // Enables I2S_CK Out on GPIO_1
#define AR933X_GPIO_FUNC2_SPDIF_ON23     BIT(2)  // Enables the SPDIF output on GPIO23
#define AR933X_GPIO_FUNC2_I2S_ON_LED     BIT(1)  // Brings out I2S related signals on pins GPIO_14, GPIO_15 and GPIO_16
#define AR933X_GPIO_FUNC2_DIS_MIC        BIT(0)  // Disables MIC


static DEFINE_SPINLOCK(ath79_gpio2_lock);

static void __init ath79_gpio_function2_enable(u32 mask)
{
	void __iomem *ath79_gpio_base = ioremap_nocache(AR71XX_GPIO_BASE, AR71XX_GPIO_SIZE);
        void __iomem *reg = ath79_gpio_base + AR933X_GPIO_REG_FUNC2;
        unsigned long flags;

        spin_lock_irqsave(&ath79_gpio2_lock, flags);

        __raw_writel(__raw_readl(reg) | mask, reg);
        /* flush write */
        __raw_readl(reg);

        spin_unlock_irqrestore(&ath79_gpio2_lock, flags);
}

#if 0
static void __init ath79_gpio_function2_disable(u32 mask)
{
        void __iomem *reg = (void __iomem *) (AR933X_GPIO_BASE + AR933X_GPIO_REG_FUNC2);
        unsigned long flags;

        spin_lock_irqsave(&ath79_gpio2_lock, flags);

        __raw_writel(__raw_readl(reg) & ~mask, reg);
        /* flush write */
        __raw_readl(reg);

        spin_unlock_irqrestore(&ath79_gpio2_lock, flags);
}
#endif


static void __init bomebox_common_setup(void)
{
	u8 *art = (u8 *) KSEG1ADDR(0x1fff0000);

	ath79_register_m25p80(NULL);
	ath79_register_wmac(art + BOMEBOX_CALDATA_OFFSET,
			    art + BOMEBOX_WMAC_MAC_OFFSET);

	ath79_setup_ar933x_phy4_switch(true, true);

	ath79_init_mac(ath79_eth0_data.mac_addr, art + BOMEBOX_MAC0_OFFSET, 0);
	ath79_init_mac(ath79_eth1_data.mac_addr, art + BOMEBOX_MAC1_OFFSET, 0);

	ath79_register_mdio(0, 0x0);

	/* LAN ports */
	ath79_register_eth(1);

	/* WAN port */
	ath79_register_eth(0);
}

static void __init bomebox_setup(void)
{
	bomebox_common_setup();

	ath79_gpio_function_disable(
				AR933X_GPIO_FUNC_ETH_SWITCH_LED0_EN |
				AR933X_GPIO_FUNC_ETH_SWITCH_LED1_EN |
				AR933X_GPIO_FUNC_ETH_SWITCH_LED2_EN |
				AR933X_GPIO_FUNC_ETH_SWITCH_LED3_EN |
				AR933X_GPIO_FUNC_ETH_SWITCH_LED4_EN |
				AR933X_GPIO_FUNC_I2SO_22_18_EN |
				AR933X_GPIO_FUNC_I2SO_EN
				);
	ath79_gpio_function_enable(AR933X_GPIO_FUNC_JTAG_DISABLE);

	ath79_gpio_function2_enable(
				AR933X_GPIO_FUNC2_JUMPSTART_DISABLE |
				AR933X_GPIO_FUNC2_WPS_DISABLE |
				AR933X_GPIO_FUNC2_DIS_MIC);

#if BOME_HAS_I2C
    platform_add_devices(bomebox_devices, ARRAY_SIZE(bomebox_devices));
#endif //BOME_HAS_I2C

	ath79_register_leds_gpio(-1, ARRAY_SIZE(bomebox_leds_gpio),
				 bomebox_leds_gpio);
	ath79_register_gpio_keys_polled(-1, BOMEBOX_KEYS_POLL_INTERVAL,
					ARRAY_SIZE(bomebox_gpio_keys),
					bomebox_gpio_keys);
	ath79_register_usb();
}

MIPS_MACHINE(ATH79_MACH_BOMEBOX, "BOMEBOX", "BomeBox", bomebox_setup);
