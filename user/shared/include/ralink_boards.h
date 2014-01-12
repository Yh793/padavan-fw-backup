/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#ifndef _RALINK_BOARDS_H_
#define _RALINK_BOARDS_H_

////////////////////////////////////////////////////////////////////////////////
// BOARD DEPENDENCIES
////////////////////////////////////////////////////////////////////////////////

#if defined(BOARD_N56U)
 #define BOARD_PID		"RT-N56U"
 #define BOARD_NAME		"RT-N56U"
 #define BOARD_GPIO_BTN_RESET	13
 #define BOARD_GPIO_BTN_WPS	26
 #undef  BOARD_GPIO_LED_ALL
 #undef  BOARD_GPIO_LED_WIFI
 #define BOARD_GPIO_LED_POWER	0
 #define BOARD_GPIO_LED_LAN	19
 #define BOARD_GPIO_LED_WAN	27
 #define BOARD_GPIO_LED_USB	24
 #define BOARD_HAS_5G_RADIO	1
 #define BOARD_5G_IN_SOC	1
 #define BOARD_2G_IN_SOC	0
 #define BOARD_NUM_ANT_5G_TX	2
 #define BOARD_NUM_ANT_5G_RX	3
 #define BOARD_NUM_ANT_2G_TX	2
 #define BOARD_NUM_ANT_2G_RX	2
 #define BOARD_NUM_ETH_LEDS	2
 #define BOARD_NUM_USB_PORTS	2
 #define BOARD_HAS_EPHY_1000	1
#elif defined(BOARD_N65U)
 #define BOARD_PID		"RT-N65U"
 #define BOARD_NAME		"RT-N65U"
 #define BOARD_GPIO_BTN_RESET	13
 #define BOARD_GPIO_BTN_WPS	26
 #define BOARD_GPIO_LED_ALL	10
 #undef  BOARD_GPIO_LED_WIFI
 #define BOARD_GPIO_LED_POWER	0
 #define BOARD_GPIO_LED_LAN	19
 #define BOARD_GPIO_LED_WAN	27
 #define BOARD_GPIO_LED_USB	24
 #define BOARD_HAS_5G_RADIO	1
 #define BOARD_5G_IN_SOC	1
 #define BOARD_2G_IN_SOC	0
 #define BOARD_NUM_ANT_5G_TX	3
 #define BOARD_NUM_ANT_5G_RX	3
 #define BOARD_NUM_ANT_2G_TX	2
 #define BOARD_NUM_ANT_2G_RX	2
 #define BOARD_NUM_ETH_LEDS	2
 #define BOARD_NUM_USB_PORTS	2
 #define BOARD_HAS_EPHY_1000	1
#elif defined(BOARD_N14U)
 #define BOARD_PID		"RT-N14U"
 #define BOARD_NAME		"RT-N14U"
 #define BOARD_GPIO_BTN_RESET	1
 #define BOARD_GPIO_BTN_WPS	2
 #undef  BOARD_GPIO_LED_ALL
 #define BOARD_GPIO_LED_WIFI	72
 #define BOARD_GPIO_LED_POWER	43
 #define BOARD_GPIO_LED_LAN	41
 #define BOARD_GPIO_LED_WAN	40
 #define BOARD_GPIO_LED_USB	42
 #define BOARD_HAS_5G_RADIO	0
 #define BOARD_5G_IN_SOC	0
 #define BOARD_2G_IN_SOC	1
 #define BOARD_NUM_ANT_5G_TX	2
 #define BOARD_NUM_ANT_5G_RX	2
 #define BOARD_NUM_ANT_2G_TX	2
 #define BOARD_NUM_ANT_2G_RX	2
 #define BOARD_NUM_ETH_LEDS	0
 #define BOARD_NUM_USB_PORTS	1
 #define BOARD_HAS_EPHY_1000	0
#elif defined(BOARD_SWR1100)
 #define BOARD_PID		"SWR1100"
 #define BOARD_NAME		"SWR-1100"
 #define BOARD_GPIO_BTN_RESET	6
 #define BOARD_GPIO_BTN_WPS	3
 #undef  BOARD_GPIO_LED_ALL
 #undef  BOARD_GPIO_LED_WIFI
 #define BOARD_GPIO_LED_POWER	0
 #undef  BOARD_GPIO_LED_LAN
 #undef  BOARD_GPIO_LED_WAN
 #define BOARD_GPIO_LED_USB	25
 #define BOARD_HAS_5G_RADIO	1
 #define BOARD_5G_IN_SOC	1
 #define BOARD_2G_IN_SOC	0
 #define BOARD_NUM_ANT_5G_TX	2
 #define BOARD_NUM_ANT_5G_RX	2
 #define BOARD_NUM_ANT_2G_TX	2
 #define BOARD_NUM_ANT_2G_RX	2
 #define BOARD_NUM_ETH_LEDS	1
 #define BOARD_NUM_USB_PORTS	1
 #define BOARD_HAS_EPHY_1000	1
#elif defined(BOARD_BN750DB)
 #define BOARD_PID		"F9K1103"
 #define BOARD_NAME		"BL-N750DB"
 #define BOARD_GPIO_BTN_RESET	25
 #define BOARD_GPIO_BTN_WPS	26
 #undef  BOARD_GPIO_LED_ALL
 #undef  BOARD_GPIO_LED_WIFI
 #define BOARD_GPIO_LED_POWER	0
 #define BOARD_GPIO_LED_LAN	13
 #define BOARD_GPIO_LED_WAN	12
 #define BOARD_GPIO_LED_USB	9
 #define BOARD_HAS_5G_RADIO	1
 #define BOARD_5G_IN_SOC	1
 #define BOARD_2G_IN_SOC	0
 #define BOARD_NUM_ANT_5G_TX	3
 #define BOARD_NUM_ANT_5G_RX	3
 #define BOARD_NUM_ANT_2G_TX	2
 #define BOARD_NUM_ANT_2G_RX	2
 #define BOARD_NUM_ETH_LEDS	0
 #define BOARD_NUM_USB_PORTS	2
 #define BOARD_HAS_EPHY_1000	1
#endif

#define BTN_PRESSED	0
#define LED_ON		0
#define LED_OFF		1

#define FW_MTD_NAME	"Firmware_Stub"
#define FW_IMG_NAME	"/tmp/linux.trx"

#endif

