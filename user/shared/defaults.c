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

#include "nvram/bcmnvram.h"
#include <ralink_boards.h>
#include "netutils.h"

#define STR1(x) #x
#define STR(x) STR1(x)

struct nvram_pair router_defaults[] = {
	/* Restore defaults */
	{ "restore_defaults", "0" },		/* Set to 0 to not restore defaults on boot */
	{ "nvram_manual", "0" },		/* Manual commit mode: 1: manual, 0: auto */

	/* Miscellaneous parameters */
	{ "time_zone", "GMT0" },
	{ "log_level", "0" },			/* Bitmask 0:off 1:denied 2:accepted */
	{ "stats_server", "" },			/* URL for posting stats */
	{ "console_loglevel", "7" },		/* Kernel panics only */

	/* Big switches */
	{ "fw_enable_x", "1"},
	{ "log_ipaddr", "" },			/* syslog recipient */

	/* LAN H/W parameters */
	{ "lan_ifname", "br0" },		/* LAN interface name */
	{ "lan_hwaddr", "" },			/* LAN interface MAC address */

	/* LAN TCP/IP parameters */
	{ "lan_proto_x", "0" },			/* DHCP client [static|dhcp] */
	{ "lan_ipaddr", "192.168.1.1" },	/* LAN IP address */
	{ "lan_netmask", "255.255.255.0" },	/* LAN netmask */
	{ "lan_gateway", "192.168.1.1" },	/* LAN gateway */
	{ "lan_dns_x", "1" },			/* LAN DNS [static|dhcp] */
	{ "lan_dns1", "" },			/* LAN DNS1 */
	{ "lan_dns2", "" },			/* LAN DNS2 */
	{ "lan_domain", "" },			/* LAN domain name */
	{ "lan_stp", "1" },			/* LAN spanning tree protocol */

	/* WAN H/W parameters */
	{ "wan_ifname", "eth3" },		/* WAN interface name */
	{ "wan_hwname", "" },			/* WAN driver name (e.g. et1) */
	{ "wan_hwaddr", "" },			/* WAN interface MAC address */

	/* WAN TCP/IP parameters */
	{ "wan_proto", "dhcp" },		/* [static|dhcp|pppoe|disabled] */
	{ "wan_ipaddr", "0.0.0.0" },		/* WAN IP address */
	{ "wan_netmask", "0.0.0.0" },		/* WAN netmask */
	{ "wan_gateway", "0.0.0.0" },		/* WAN gateway */
	{ "wan_dns", "" },			/* x.x.x.x x.x.x.x ... */
	{ "wan_wins", "" },			/* x.x.x.x x.x.x.x ... */
	{ "wan_hostname", "" },			/* WAN hostname */
	{ "wan_domain", "" },			/* WAN domain name */
	{ "wan_lease", "86400" },		/* WAN lease time in seconds */

	/* PPP VPN parameters */
	{ "wan_pppoe_ifname", IFNAME_PPP },	/* PPPoE enslaved interface */
	{ "wan_pppoe_username", "" },		/* PPP username */
	{ "wan_pppoe_passwd", "" },		/* PPP password */
	{ "wan_pppoe_idletime", "0" },		/* PPP idle time */
	{ "wan_pppoe_demand", "0" },		/* Dial on demand */
	{ "wan_pppoe_service", "" },		/* PPPoE service name */
	{ "wan_pppoe_ac", "" },			/* PPPoE access concentrator name */
	{ "wan_pppoe_mtu", "1492" },		/* Negotiate MTU to the smaller of this value or the peer MRU */
	{ "wan_pppoe_mru", "1492" },		/* Negotiate MRU to this value */
	{ "wan_pptp_mtu", "1400" },		/* Negotiate MTU to the smaller of this value or the peer MRU */
	{ "wan_pptp_mru", "1400" },		/* Negotiate MRU to this value */
	{ "wan_l2tp_mtu", "1460" },		/* Negotiate MTU to the smaller of this value or the peer MRU */
	{ "wan_l2tp_mru", "1460" },		/* Negotiate MRU to this value */
	{ "wan_l2tpd", "0" },			/* L2TP control daemon (xL2TPD/RP-L2TP) */
	{ "wan_ppp_peer", "" },			/* VPN server address */
	{ "wan_ppp_auth", "0" },		/* PPP authentication */
	{ "wan_ppp_mppe", "0" },		/* MPPE encryption */
	{ "wan_ppp_alcp", "0" },		/* Adaptive LCP Echo */
	{ "wan_ppp_pppd", "" },			/* Custom PPPD options */

	/* Misc WAN parameters */
	{ "wan_primary", "0" },			/* Primary wan connection */
	{ "wan_unit", "0" },			/* Last configured connection */

	/* Exposed station */
	{ "dmz_ip", "" },

	/* Web server parameters */
	{ "http_username", "admin" },		/* Username */
	{ "http_passwd", "admin" },		/* Password */
	{ "http_proto", "0" },			/* HTTP proto (0: HTTP, 1: HTTPS, 2: Both) */
	{ "http_lanport", "80" },		/* HTTP LAN port to listen on */
	{ "https_lport", "443" },		/* HTTPS LAN port to listen on */
	{ "https_clist", "DH+AESGCM:DH+AES256:DH+AES:DH+3DES:RSA+AES:RSA+3DES:!ADH:!MD5:!DSS" },	/* HTTPS SSL cipher list */
	{ "fw_dos_x", "0" },			// oleg patch
	{ "dr_enable_x", "1" },			// oleg patch
	{ "mr_enable_x", "0" },			// oleg patch
	{ "mr_ttl_fix", "0" },

#if BOARD_HAS_5G_RADIO
	/* 5G Wireless parameters */
	{ "wl_country_code", "GB" },		/* Country Code (default obtained from driver) */
	{ "wl_ssid", "ASUS_5G" },		/* Service set ID (network name) */
	{ "wl_gmode", "2" },			/* 54g mode */
	{ "wl_channel", "0" },			/* Channel number */
	{ "wl_bcn", "100" },			/* Beacon interval */
	{ "wl_dtim", "1" },			/* DTIM period */
	{ "wl_gmode_protection", "off" },	/* 802.11g RTS/CTS protection (off|auto) */
	{ "wl_rts", "2347" },			/* RTS threshold */
	{ "wl_frag", "2346" },			/* Fragmentation threshold */
	{ "wl_ap_isolate", "0" },		/* AP isolate mode */
	{ "wl_mbssid_isolate", "1" },		/* Isolate between AP and Guests AP */
	{ "wl_closed", "0" },			/* Closed (hidden) network */
	{ "wl_macmode", "disabled" },		/* "allow" only, "deny" only, or "disabled"(allow all) */
	{ "wl_maclist", "" },			/* xx:xx:xx:xx:xx:xx ... */
	{ "wl_wme", "1" },			/* WME mode (off|on) */
	{ "wl_wme_no_ack", "off" },		/* WME No-Acknowledgment mode */
	{ "wl_auth_mode", "open" },		/* Network authentication mode Open System */
	{ "wl_key", "1" },			/* Current WEP key */
	{ "wl_key1", "" },			/* 5/13 char ASCII or 10/26 char hex */
	{ "wl_key2", "" },			/* 5/13 char ASCII or 10/26 char hex */
	{ "wl_key3", "" },			/* 5/13 char ASCII or 10/26 char hex */
	{ "wl_key4", "" },			/* 5/13 char ASCII or 10/26 char hex */
	{ "wl_key_type", "0" } ,		/* WEP key format (HEX/ASCII)*/
	{ "wl_mcastrate", "1" },		/* Mcast Rate (bps) */
	{ "wl_crypto", "aes" },			/* WPA data encryption */
	{ "wl_wpa_psk", "" },			/* WPA pre-shared key */
	{ "wl_wpa_gtk_rekey", "3600" },		/* GTK rotation interval */
	{ "wl_radius_ipaddr", ""},		/* RADIUS server IP address */
	{ "wl_radius_port", "1812" },		/* RADIUS server UDP port */
	{ "wl_radius_key", "" },		/* RADIUS shared secret */
	{ "wl_lazywds", "0" },			/* Enable "lazy" WDS mode (0|1) */
	{ "wl_radio_x", "1" },			/* Enable (1) or disable (0) radio */
	{ "wl_IgmpSnEnable", "1" },
	{ "wl_TxPower", "100" },
	{ "wl_TxBurst", "1" },
	{ "wl_PktAggregate", "1" },
	{ "wl_APSDCapable", "0" },
	{ "wl_DLSCapable", "0" },
	{ "wl_HT_OpMode", "0" },
	{ "wl_HT_BW", "1" },
	{ "wl_txbf", "0" },
	{ "wl_ssid2", "ASUS_5G" },
	{ "wl_mode_x", "0" },
	{ "wl_wdsapply_x", "0" },
	{ "wl_wdsnum_x", "0" },
	{ "wl_wep_x", "0" },
	{ "wl_phrase_x", "" },
	{ "wl_radio_date_x", "1111111" },
	{ "wl_radio_time_x", "00002359" },
	{ "wl_radio_time2_x", "00002359" },
	{ "wl_macnum_x", "0" },
	{ "wl_wdslist_x", "" },
	{ "wl_maclist_x", "" },
	{ "wl_wpa_mode", "0" },
	{ "wl_stream_tx", STR(BOARD_NUM_ANT_5G_TX) },
	{ "wl_stream_rx", STR(BOARD_NUM_ANT_5G_RX) },
	{ "wl_preamble", "0" },
	{ "wl_greenap", "0" },
	{ "wl_HT_RDG", "0" },
	{ "wl_HT_AMSDU", "0" },
	{ "wl_HT_MpduDensity", "5" },
	{ "wl_HT_BAWinSize", "64" },
	{ "wl_HT_AutoBA", "1" },

	// guest AP 5Ghz
	{ "wl_guest_enable", "0" },
	{ "wl_guest_date_x", "1111111" },
	{ "wl_guest_time_x", "00002359" },
	{ "wl_guest_time2_x", "00002359" },
	{ "wl_guest_ssid", "ASUS_GUEST_5G" },
	{ "wl_guest_closed", "0" },
	{ "wl_guest_ap_isolate", "1" },
	{ "wl_guest_lan_isolate", "1" },
	{ "wl_guest_auth_mode", "open" },
	{ "wl_guest_wpa_mode", "2" },
	{ "wl_guest_crypto", "aes" },
	{ "wl_guest_wpa_psk", "" },
	{ "wl_guest_macrule", "0" },

	// ApCli 5Ghz
	{ "wl_sta_ssid", "" },
	{ "wl_sta_auth_mode", "open" },
	{ "wl_sta_wpa_mode", "2" },
	{ "wl_sta_crypto", "aes" },
	{ "wl_sta_wpa_psk", "" },
#endif

	/* 2G Wireless parameters */
	{ "rt_TxPower", "100" },
	{ "rt_TxBurst", "1" },
	{ "rt_PktAggregate", "1" },
	{ "rt_country_code", "GB" },
	{ "rt_ssid", "ASUS" },
	{ "rt_gmode", "2" },
	{ "rt_channel", "0" },
	{ "rt_bcn", "100" },
	{ "rt_dtim", "1" },
	{ "rt_gmode_protection", "auto" },
	{ "rt_rts", "2347" },
	{ "rt_frag", "2346" },
	{ "rt_ap_isolate", "0" },
	{ "rt_mbssid_isolate", "1" },		/* Isolate between AP and Guests AP */
	{ "rt_closed", "0" },
	{ "rt_macmode", "disabled" },
	{ "rt_mcastrate", "6" },
	{ "rt_mode", "ap" },
	{ "rt_HT_BW", "1" },
	{ "rt_HT_EXTCHA", "1" },
	{ "rt_HT_OpMode", "0" },
	{ "rt_wsc_config_state", "0" },
	{ "rt_secret_code", "0" },
	{ "rt_DLSCapable", "0" },
	{ "rt_APSDCapable", "0" },
	{ "rt_wme", "1" },
	{ "rt_wme_no_ack", "off" },
	{ "rt_IgmpSnEnable", "1" },
	{ "rt_auth_mode", "open" },
	{ "rt_crypto", "aes" },
	{ "rt_wpa_psk", "" },
	{ "rt_wpa_gtk_rekey", "3600" },
	{ "rt_key", "1" },
	{ "rt_key_type", "0" } ,
	{ "rt_key1", "" },
	{ "rt_key2", "" },
	{ "rt_key3", "" },
	{ "rt_key4", "" },
	{ "rt_lazywds", "0" },
	{ "rt_radius_ipaddr", "" },
	{ "rt_radius_port", "1812" },
	{ "rt_radius_key", "" },
	{ "rt_radio_x", "1" },
	{ "rt_ssid2", "ASUS" },
	{ "rt_mode_x", "0" },
	{ "rt_wdsapply_x", "0" },
	{ "rt_wdsnum_x", "0" },
	{ "rt_wep_x", "0" },
	{ "rt_phrase_x", "" },
	{ "rt_radio_date_x", "1111111" },
	{ "rt_radio_time_x", "00002359" },
	{ "rt_radio_time2_x", "00002359" },
	{ "rt_macnum_x", "0" },
	{ "rt_wdslist_x", "" },
	{ "rt_maclist_x", "" },
	{ "rt_wpa_mode", "0" },
	{ "rt_stream_tx", STR(BOARD_NUM_ANT_2G_TX) },
	{ "rt_stream_rx", STR(BOARD_NUM_ANT_2G_RX) },
	{ "rt_preamble", "0" },
	{ "rt_greenap", "0" },
	{ "rt_HT_RDG", "0" },
	{ "rt_HT_AMSDU", "0" },
	{ "rt_HT_MpduDensity", "5" },
	{ "rt_HT_BAWinSize", "64" },
	{ "rt_HT_AutoBA", "1" },

	// guest AP 2.4Ghz
	{ "rt_guest_enable", "0" },
	{ "rt_guest_date_x", "1111111" },
	{ "rt_guest_time_x", "00002359" },
	{ "rt_guest_time2_x", "00002359" },
	{ "rt_guest_ssid", "ASUS_GUEST" },
	{ "rt_guest_closed", "0" },
	{ "rt_guest_ap_isolate", "1" },
	{ "rt_guest_lan_isolate", "1" },
	{ "rt_guest_auth_mode", "open" },
	{ "rt_guest_wpa_mode", "2" },
	{ "rt_guest_crypto", "aes" },
	{ "rt_guest_wpa_psk", "" },
	{ "rt_guest_macrule", "0" },

	// ApCli 2.4Ghz
	{ "rt_sta_ssid", "" },
	{ "rt_sta_auth_mode", "open" },
	{ "rt_sta_wpa_mode", "2" },
	{ "rt_sta_crypto", "aes" },
	{ "rt_sta_wpa_psk", "" },

	// USB related
	{ "acc_num", "0" },
	{ "enable_ftp", "0" },
	{ "enable_samba", "1" },
	{ "st_samba_mode", "1" },
	{ "st_samba_lmb", "1" },
	{ "st_ftp_mode", "1" },
	{ "st_ftp_log", "0" },
	{ "st_max_user", "10" },
	{ "st_samba_workgroup", "WORKGROUP" },
	{ "apps_dms", "0" },
	{ "apps_itunes", "0"},
	{ "sh_num", "0" },
	{ "machine_name", BOARD_NAME },
	{ "computer_name", BOARD_NAME },

	{ "pcache_reclaim", "0" },
#if defined(BOARD_N65U)
	{ "pcie_aspm", "0" },
#endif
	{ "ehci_ports", "1-1 1-2" },
	{ "ohci_ports", "2-1 2-2" },

#if defined (USE_IPV6)
	{ "ip6_service", "" },
	{ "ip6_ppe_on", "0" },
	{ "ip6_wan_if", "0" },

	{ "ip6_6in4_remote", "" },
	{ "ip6_6to4_relay", "192.88.99.1" },
	{ "ip6_6rd_relay", "" },
	{ "ip6_6rd_size", "0" },
	{ "ip6_6rd_dhcp", "1" },
	{ "ip6_sit_mtu", "1280" },
	{ "ip6_sit_ttl", "64" },

	{ "ip6_wan_dhcp", "0" },
	{ "ip6_wan_addr", "" },
	{ "ip6_wan_size", "64" },
	{ "ip6_wan_gate", "" },

	{ "ip6_dns_auto", "0" },
	{ "ip6_dns1", "" },
	{ "ip6_dns2", "" },
	{ "ip6_dns3", "" },

	{ "ip6_lan_auto", "0" },
	{ "ip6_lan_addr", "" },
	{ "ip6_lan_size", "64" },
	{ "ip6_lan_radv", "1" },
	{ "ip6_lan_dhcp", "1" },
#endif

	{ "x_DHCPClient", "1" },
	{ "wan_mode_x", "2" },
	{ "wan_route_x", "IP_Routed" },
	{ "wan_nat_x", "1" },
	{ "wan_dnsenable_x", "1" },
	{ "wan_dns1_x", "" },
	{ "wan_dns2_x", "" },
	{ "wan_pppoe_txonly_x", "0" },
	{ "wan_hwaddr_x", "" },
	{ "wan_proto_t", "" },
	{ "wan_ipaddr_t", "" },
	{ "wan_netmask_t", "" },
	{ "wan_gateway_t", "" },
	{ "wan_dns_t", "" },
	{ "wan_status_t", "" },
	{ "upnp_enable_x", "1" },
	{ "upnp_proto", "0" },
	{ "upnp_secure", "1" },
	{ "upnp_clean_min", "10" },
	{ "upnp_clean_int", "600" },
	{ "vts_enable_x", "0" },
	{ "vts_num_x", "0" },
	{ "sp_battle_ips", "0" },
	{ "fw_log_x", "none" },
	{ "misc_http_x", "0" },
	{ "misc_httpport_x", "8080" },
	{ "https_wopen", "0" },
	{ "https_wport", "8443" },
	{ "misc_lpr_x", "0" },
	{ "misc_ping_x", "0" },
	{ "fw_lw_enable_x", "0" },
	{ "fw_lw_enable_x_1", "0" },
	{ "filter_lw_date_x", "1111111" },
	{ "filter_lw_time_x", "00002359" },
	{ "filter_lw_time_x_1", "00002359" },
	{ "filter_lw_default_x", "ACCEPT" },
	{ "filter_lw_icmp_x", "" },
	{ "filter_lw_num_x", "0" },
	{ "url_enable_x", "0" },
	{ "url_enable_x_1", "0" },
	{ "url_date_x", "1111111" },
	{ "url_time_x", "00002359" },
	{ "url_time_x_1", "00002359" },
	{ "url_num_x", "0" },
	{ "macfilter_enable_x", "0" },
	{ "macfilter_num_x", "0" },
	{ "sr_enable_x", "0" },
	{ "sr_rip_x", "0" },
	{ "sr_num_x", "0" },
	{ "dr_static_rip_x", "0" },
	{ "dr_static_matric_x", "1" },
	{ "dr_default_x", "1" },
	{ "dr_staticnum_x", "0" },
	{ "dr_staticipaddr_x", "" },
	{ "dr_staticnetmask_x", "0" },
	{ "dr_staticgateway_x", "" },

	/* DHCP server parameters */
	{ "dhcp_start", "192.168.1.2" },	/* First assignable DHCP address */
	{ "dhcp_end", "192.168.1.244" },	/* Last assignable DHCP address */
	{ "dhcp_enable_x", "1" },
	{ "dhcp_lease", "86400" },
	{ "dhcp_gateway_x", "" },
	{ "dhcp_dns1_x", "" },
	{ "dhcp_dns2_x", "" },
	{ "dhcp_dns3_x", "" },
	{ "dhcp_wins_x", "" },
	{ "dhcp_verbose", "0" },		/* 0 : quiet, 1: verbose DHCP, 2: verbose DHCPv6, 3: verbose all */
	{ "dhcp_static_x", "0" },
	{ "dhcp_staticnum_x", "0" },

	/* NTP client parameters */
	{ "ntp_period", "24" },
	{ "ntp_server0", "pool.ntp.org" },
	{ "ntp_server1", "time.nist.gov" },

	/* DDNS parameters */
	{ "ddns_enable_x", "0" },
	{ "ddns_server_x", "" },
	{ "ddns_username_x", "" },
	{ "ddns_passwd_x", "" },
	{ "ddns_hostname_x", "" },
	{ "ddns_hostname2_x", "" },
	{ "ddns_hostname3_x", "" },
	{ "ddns_wildcard_x", "0" },
	{ "ddns_period", "12" },
	{ "ddns_verbose", "1" },
	{ "ddns_source", "0" },
	{ "asusddns_tos_agreement", "0" },

	{ "preferred_lang", "" },

	{ "modem_rule", "0" },
	{ "modem_type", "0" },
	{ "modem_country", "" },
	{ "modem_isp", "" },
	{ "modem_apn", "" },
	{ "modem_dialnum", "" },
	{ "modem_user", "" },
	{ "modem_pass", "" },
	{ "modem_pin", "" },
	{ "modem_dnsa", "1" },
	{ "modem_node", "0" },
	{ "modem_nets", "0" },
	{ "modem_arun", "2" },
	{ "modem_zcd", "0" },
	{ "modem_cmd", "" },
	{ "modem_mtu", "1500" },

	{ "udpxy_enable_x", "0" },
	{ "xupnpd_enable_x", "0" },
	{ "xupnpd_udpxy", "0" },

	{ "rstats_enable", "1" },
	{ "rstats_stored", "1" },
	{ "rstats_colors", "" },
	{ "http_id", "TIDe855a6487043d70a" },
	{ "controlrate_unknown_unicast", "0" },
	{ "controlrate_unknown_multicast", "0" },
	{ "controlrate_multicast", "0" },
	{ "controlrate_broadcast", "10" },
	{ "asus_debug", "0" },
	{ "di_debug", "0" },
	{ "telnetd", "1" },

	{ "fw_pt_pptp", "1" },
	{ "fw_pt_l2tp", "1" },
	{ "fw_pt_ipsec", "1" },
	{ "fw_pt_pppoe", "0" },

	{ "wan_src_phy", "0" },
	{ "wan_stb_x", "0" },
	{ "wan_stb_iso", "0" },
	{ "vlan_filter", "0" },
	{ "vlan_vid_cpu", "" },
	{ "vlan_pri_cpu", "0" },
	{ "vlan_vid_iptv", "" },
	{ "vlan_pri_iptv", "0" },
	{ "vlan_vid_lan1", "" },
	{ "vlan_pri_lan1", "0" },
	{ "vlan_tag_lan1", "0" },
	{ "vlan_vid_lan2", "" },
	{ "vlan_pri_lan2", "0" },
	{ "vlan_tag_lan2", "0" },
	{ "vlan_vid_lan3", "" },
	{ "vlan_pri_lan3", "0" },
	{ "vlan_tag_lan3", "0" },
	{ "vlan_vid_lan4", "" },
	{ "vlan_pri_lan4", "0" },
	{ "vlan_tag_lan4", "0" },

	{ "pppoe_dhcp_route", "1" },
	{ "sw_mode", "1" },

	{ "u2ec_enable", "1" },
	{ "lprd_enable", "1" },
	{ "rawd_enable", "1" },
	{ "achk_enable", "0" },
	{ "nfsd_enable", "0" },
	{ "ftpd_wopen", "0" },
	{ "ftpd_wport", "21" },
	{ "sshd_enable", "0" },
	{ "sshd_wopen", "0" },
	{ "sshd_wport", "10022" },
	{ "optw_enable", "0" },
	{ "dlna_disc", "90" },
	{ "dlna_root", "0" },
	{ "dlna_src1", "A,/media/AiDisk_a1/Audio" },
	{ "dlna_src2", "V,/media/AiDisk_a1/Video" },
	{ "dlna_src3", "P,/media/AiDisk_a1/Photo" },
	{ "dlna_rescan", "0"},
	{ "trmd_enable", "0" },
	{ "trmd_pport", "51413" },
	{ "trmd_rport", "9091" },
	{ "trmd_ropen", "0" },
	{ "aria_enable", "0" },
	{ "aria_pport", "16888" },
	{ "aria_rport", "6800" },
	{ "aria_ropen", "0" },
	{ "hdd_spindt", "0" },
	{ "hdd_apmoff", "0" },
	{ "stb_cpu_iso", "0" },

	{ "wan_auth_mode", "0" },
	{ "wan_auth_user", "" },
	{ "wan_auth_pass", "" },
	{ "wan_auth_host", "10.0.0.1" },

	{ "wol_mac_last", "" },
	{ "gw_arp_ping", "0" },
	{ "ez_action_short", "0" },
	{ "ez_action_long", "0" },
	{ "watchdog_cpu", "0" },
	{ "front_leds", "0" },
	{ "ether_led0", "3" },
	{ "ether_led1", "0" },
	{ "ether_igmp", "1" },
	{ "ether_jumbo", "1" },
	{ "ether_green", "1" },
	{ "ether_link_wan",  "0" },
	{ "ether_link_lan1", "0" },
	{ "ether_link_lan2", "0" },
	{ "ether_link_lan3", "0" },
	{ "ether_link_lan4", "0" },
	{ "ether_flow_wan",  "0" },
	{ "ether_flow_lan1", "0" },
	{ "ether_flow_lan2", "0" },
	{ "ether_flow_lan3", "0" },
	{ "ether_flow_lan4", "0" },
	{ "hw_nat_mode", "1" },
	{ "sw_nat_mode", "0" },
	{ "fw_syn_cook", "0" },
	{ "fw_mac_drop", "0" },
	{ "nf_nat_type", "2" },
	{ "nf_nat_loop", "1" },
	{ "nf_max_conn", "16384" },
	{ "nf_alg_ftp0", "21" },
	{ "nf_alg_ftp1", "" },
	{ "nf_alg_pptp", "0" },
	{ "nf_alg_h323", "0" },
	{ "nf_alg_rtsp", "0" },
	{ "nf_alg_sip", "0" },
	{ "help_enable", "1" },

	{ "vpns_enable", "0" },
	{ "vpns_type", "0" },
	{ "vpns_cast", "0" },
	{ "vpns_auth", "0" },
	{ "vpns_mppe", "1" },
	{ "vpns_mtu", "1450" },
	{ "vpns_mru", "1450" },
	{ "vpns_vuse", "0" },
	{ "vpns_vnet", "10.8.0.0" },
	{ "vpns_cli0", "245" },
	{ "vpns_cli1", "254" },
	{ "vpns_num_x", "0" },

	{ "vpnc_enable", "0" },
	{ "vpnc_type", "0" },
	{ "vpnc_peer", "" },
	{ "vpnc_user", "" },
	{ "vpnc_pass", "" },
	{ "vpnc_auth", "0" },
	{ "vpnc_mppe", "0" },
	{ "vpnc_pppd", "" },
	{ "vpnc_rnet", "" },
	{ "vpnc_rmsk", "" },
	{ "vpnc_pdns", "0" },
	{ "vpnc_mtu", "1450" },
	{ "vpnc_mru", "1450" },
	{ "vpnc_sfw", "0" },
	{ "vpns_ov_mode", "1" },
	{ "vpns_ov_prot", "0" },
	{ "vpns_ov_port", "1194" },
	{ "vpns_ov_atls", "0" },
	{ "vpns_ov_rdgw", "0" },
	{ "vpnc_ov_mode", "1" },
	{ "vpnc_ov_cnat", "0" },
	{ "vpnc_ov_prot", "0" },
	{ "vpnc_ov_port", "1194" },
	{ "vpnc_ov_auth", "0" },
	{ "vpnc_ov_atls", "0" },

	{ 0, 0 }
};

struct nvram_pair tables_defaults[] = {

	{ "vts_port_x", "" },
	{ "vts_ipaddr_x", "" },
	{ "vts_lport_x", "" },
	{ "vts_proto_x", "" },
	{ "vts_protono_x", "" },
	{ "vts_desc_x", "" },

	{ "filter_lw_srcip_x", "" },
	{ "filter_lw_srcport_x", "" },
	{ "filter_lw_dstip_x", "" },
	{ "filter_lw_dstport_x", "" },
	{ "filter_lw_proto_x", "" },
	{ "filter_lw_desc_x", "" },

	{ "macfilter_list_x", "" },
	{ "macfilter_date_x", "" },
	{ "macfilter_time_x", "" },

	{ "url_keyword_x", "" },

	{ "acc_username", "" },
	{ "acc_password", "" },

	{ "sr_ipaddr_x", "" },
	{ "sr_netmask_x", "" },
	{ "sr_gateway_x", "" },
	{ "sr_matric_x", "" },
	{ "sr_if_x", "" },

	{ "dhcp_staticmac_x", "" },
	{ "dhcp_staticip_x", "" },
	{ "dhcp_staticname_x", "" },

	{ "vpns_user_x", "" },
	{ "vpns_pass_x", "" },
	{ "vpns_addr_x", "" },
	{ "vpns_rnet_x", "" },
	{ "vpns_rmsk_x", "" },

	{ "wl_maclist_x", "" },
	{ "wl_macdesc_x", "" },

	{ "rt_maclist_x", "" },
	{ "rt_macdesc_x", "" },

	{ "wl_wdslist_x", "" },
	{ "rt_wdslist_x", "" },

	{ 0, 0 }
};
