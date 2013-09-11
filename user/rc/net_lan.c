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

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <errno.h>
#include <syslog.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>

#include <nvram/bcmnvram.h>

#include "rc.h"
#include "rtl8367.h"

#include <ralink.h>
#include <linux/rtl8367_ioctl.h>

static char udhcpc_lan_state[16] = {0};

in_addr_t get_lan_ipaddr(void)
{
	return get_ipv4_addr(IFNAME_BR);
}

int
add_static_lan_routes(char *lan_ifname)
{
	return control_static_routes(SR_PREFIX_LAN, lan_ifname, 1);
}

int
del_static_lan_routes(char *lan_ifname)
{
	return control_static_routes(SR_PREFIX_LAN, lan_ifname, 0);
}

void
init_loopback(void)
{
	/* Bring up loopback interface */
	ifconfig("lo", IFUP, "127.0.0.1", "255.0.0.0");

	/* Add to routing table */
	route_add("lo", 0, "127.0.0.0", "0.0.0.0", "255.0.0.0");
}

void
init_bridge(void)
{
	int ap_mode = get_ap_mode();
	int wl_radio_on = get_enabled_radio_wl();
	int rt_radio_on = get_enabled_radio_rt();
	int wl_mode_x = nvram_get_int("wl_mode_x");
#if !defined(USE_RT3352_MII)
	int rt_mode_x = nvram_get_int("rt_mode_x");
#endif
	char *lan_hwaddr = nvram_safe_get("lan_hwaddr");

	if (!ap_mode)
	{
		/* set switch bridge mode and vlan isolation */
		switch_config_vlan(1);
	}
	else
	{
		/* set switch bridge mode to LLLLL */
		phy_bridge_mode(RTL8367_WAN_BRIDGE_DISABLE_WAN, RTL8367_WAN_BWAN_ISOLATION_NONE);
	}

	switch_config_base();
	switch_config_storm();
	switch_config_link();
	
	/* power up all switch PHY */
	phy_ports_power(1);

	doSystem("ifconfig %s hw ether %s", IFNAME_MAC, lan_hwaddr);
	ifconfig(IFNAME_MAC, IFUP, NULL, NULL);

#ifdef USE_SINGLE_MAC
	if (!ap_mode)
	{
		/* create VLAN1/2 */
		doSystem("vconfig add %s %d", IFNAME_MAC, 1);
		doSystem("vconfig add %s %d", IFNAME_MAC, 2);
		doSystem("ifconfig %s hw ether %s", IFNAME_LAN, lan_hwaddr);
		ifconfig(IFNAME_LAN, IFUP, NULL, NULL);
	}
#endif

#if defined(USE_RT3352_MII)
	if (!ap_mode)
	{
		/* create VLAN3 for guest AP */
		doSystem("vconfig add %s %d", IFNAME_MAC, INIC_GUEST_VLAN_VID);
		ifconfig(IFNAME_INIC_GUEST_VLAN, IFUP, NULL, NULL);
	}
#endif

	if (!wl_radio_on || (wl_mode_x == 1 || wl_mode_x == 3))
	{
		/* workaround for create all pseudo interfaces and fix iNIC issue (common PLL config) */
		gen_ralink_config_wl(1);
		ifconfig(IFNAME_5G_MAIN, IFUP, NULL, NULL);
	}

#if !defined(USE_RT3352_MII)
	if (!rt_radio_on || (rt_mode_x == 1 || rt_mode_x == 3))
	{
		/* workaround for create all pseudo interfaces */
		gen_ralink_config_rt(1);
		ifconfig(IFNAME_2G_MAIN, IFUP, NULL, NULL);
	}
#endif

	doSystem("brctl addbr %s", IFNAME_BR);
	doSystem("brctl stp %s %d", IFNAME_BR, 0);
	doSystem("brctl setfd %s %d", IFNAME_BR, 2);
	doSystem("ifconfig %s hw ether %s", IFNAME_BR, lan_hwaddr);

	if (!ap_mode)
	{
		/* add eth2 (or eth2.1) to bridge */
		doSystem("brctl addif %s %s", IFNAME_BR, IFNAME_LAN);
	}
	else
	{
		/* add only eth2 to bridge */
		doSystem("brctl addif %s %s", IFNAME_BR, IFNAME_MAC);
	}

	start_wifi_ap_wl(wl_radio_on);
	start_wifi_wds_wl(wl_radio_on);
	start_wifi_apcli_wl(wl_radio_on);

	if (!wl_radio_on || (wl_mode_x == 1 || wl_mode_x == 3))
	{
		/* close after workaround */
		sleep(1);
		ifconfig(IFNAME_5G_MAIN, 0, NULL, NULL);
	}

#if defined(USE_RT3352_MII)
	doSystem("modprobe iNIC_mii miimaster=%s mode=%s syncmiimac=%d bridge=%d max_fw_upload=%d", IFNAME_MAC, "ap", 0, 1, 10);
#endif

	start_wifi_ap_rt(rt_radio_on);
	start_wifi_wds_rt(rt_radio_on);
	start_wifi_apcli_rt(rt_radio_on);

#if !defined(USE_RT3352_MII)
	if (!rt_radio_on || (rt_mode_x == 1 || rt_mode_x == 3))
	{
		/* close after workaround */
		ifconfig(IFNAME_2G_MAIN, 0, NULL, NULL);
	}
#endif

	ifconfig(IFNAME_BR, IFUP, nvram_safe_get("lan_ipaddr"), nvram_safe_get("lan_netmask"));

	restart_guest_lan_isolation();

	nvram_set_int_temp("reload_svc_wl", 0);
	nvram_set_int_temp("reload_svc_rt", 0);
}

void 
switch_config_link(void)
{
	int i_flow_mode;
	int i_link_mode;
	
	// WAN
	i_flow_mode = nvram_get_int("ether_flow_wan");
	if (i_flow_mode < 0 || i_flow_mode > 2)
		i_flow_mode = 0;
	i_link_mode = nvram_get_int("ether_link_wan");
	if (i_link_mode < 0 || i_link_mode > 5)
		i_link_mode = 0;
	
	phy_link_port_wan(i_link_mode, i_flow_mode);
	
	// LAN1
	i_flow_mode = nvram_get_int("ether_flow_lan1");
	if (i_flow_mode < 0 || i_flow_mode > 2)
		i_flow_mode = 0;
	i_link_mode = nvram_get_int("ether_link_lan1");
	if (i_link_mode < 0 || i_link_mode > 5)
		i_link_mode = 0;
	
	phy_link_port_lan1(i_link_mode, i_flow_mode);
	
	// LAN2
	i_flow_mode = nvram_get_int("ether_flow_lan2");
	if (i_flow_mode < 0 || i_flow_mode > 2)
		i_flow_mode = 0;
	i_link_mode = nvram_get_int("ether_link_lan2");
	if (i_link_mode < 0 || i_link_mode > 5)
		i_link_mode = 0;
	
	phy_link_port_lan2(i_link_mode, i_flow_mode);
	
	// LAN3
	i_flow_mode = nvram_get_int("ether_flow_lan3");
	if (i_flow_mode < 0 || i_flow_mode > 2)
		i_flow_mode = 0;
	i_link_mode = nvram_get_int("ether_link_lan3");
	if (i_link_mode < 0 || i_link_mode > 5)
		i_link_mode = 0;
	
	phy_link_port_lan3(i_link_mode, i_flow_mode);
	
	// LAN4
	i_flow_mode = nvram_get_int("ether_flow_lan4");
	if (i_flow_mode < 0 || i_flow_mode > 2)
		i_flow_mode = 0;
	i_link_mode = nvram_get_int("ether_link_lan4");
	if (i_link_mode < 0 || i_link_mode > 5)
		i_link_mode = 0;
	
	phy_link_port_lan4(i_link_mode, i_flow_mode);
}

void 
switch_config_base(void)
{
#if (ETH_PHY_LEDS > 0)
	phy_led_mode_green(nvram_get_int("ether_led0"));
#else
	phy_led_mode_green(RTL8367_LED_OFF);
	phy_led_mode_yellow(RTL8367_LED_OFF);
#endif
#if (ETH_PHY_LEDS > 1)
	phy_led_mode_yellow(nvram_get_int("ether_led1"));
#endif
	phy_jumbo_frames(nvram_get_int("ether_jumbo"));
	phy_green_ethernet(nvram_get_int("ether_green"));
#if defined(USE_RTL8367_IGMP_SNOOPING)
	phy_igmp_snooping(nvram_get_int("ether_igmp"));
#endif
}

void 
switch_config_storm(void)
{
	int controlrate_unknown_unicast;
	int controlrate_unknown_multicast;
	int controlrate_multicast;
	int controlrate_broadcast;

	if (get_ap_mode())
		return;

	/* unknown unicast storm control */
	controlrate_unknown_unicast = nvram_get_int("controlrate_unknown_unicast");
	if (controlrate_unknown_unicast <= 0 || controlrate_unknown_unicast > 1024)
		controlrate_unknown_unicast = 1024;
	
	/* unknown multicast storm control */
	controlrate_unknown_multicast = nvram_get_int("controlrate_unknown_multicast");
	if (controlrate_unknown_multicast <= 0 || controlrate_unknown_multicast > 1024)
		controlrate_unknown_multicast = 1024;

	/* multicast storm control */
	controlrate_multicast = nvram_get_int("controlrate_multicast");
	if (controlrate_multicast <= 0 || controlrate_multicast > 1024)
		controlrate_multicast = 1024;

	/* broadcast storm control */
	controlrate_broadcast = nvram_get_int("controlrate_broadcast");
	if (controlrate_broadcast <= 0 || controlrate_broadcast > 1024)
		controlrate_broadcast = 1024;
	
	phy_storm_unicast_unknown(controlrate_unknown_unicast);
	phy_storm_multicast_unknown(controlrate_unknown_multicast);
	phy_storm_multicast(controlrate_multicast);
	phy_storm_broadcast(controlrate_broadcast);
}

void
switch_config_vlan(int first_call)
{
	int bridge_mode, bwan_isolation, is_vlan_filter;
	int vlan_vid[6];
	int vlan_pri[6];
	int vlan_tag[6];
	unsigned int vrule;

	if (get_ap_mode())
		return;

	bridge_mode = nvram_get_int("wan_stb_x");
	if (bridge_mode < 0 || bridge_mode > 7)
		bridge_mode = RTL8367_WAN_BRIDGE_DISABLE;
	
	bwan_isolation = nvram_get_int("wan_stb_iso");
	if (bwan_isolation < 0 || bwan_isolation > 2)
		bwan_isolation = RTL8367_WAN_BWAN_ISOLATION_NONE;
	
	is_vlan_filter = (nvram_match("vlan_filter", "1")) ? 1 : 0;
	if (is_vlan_filter)
	{
		bwan_isolation = RTL8367_WAN_BWAN_ISOLATION_FROM_CPU;
		
		vlan_vid[RTL8367_VLAN_RULE_WAN_INET] = nvram_get_int("vlan_vid_cpu");
		vlan_vid[RTL8367_VLAN_RULE_WAN_IPTV] = nvram_get_int("vlan_vid_iptv");
		vlan_vid[RTL8367_VLAN_RULE_WAN_LAN1] = nvram_get_int("vlan_vid_lan1");
		vlan_vid[RTL8367_VLAN_RULE_WAN_LAN2] = nvram_get_int("vlan_vid_lan2");
		vlan_vid[RTL8367_VLAN_RULE_WAN_LAN3] = nvram_get_int("vlan_vid_lan3");
		vlan_vid[RTL8367_VLAN_RULE_WAN_LAN4] = nvram_get_int("vlan_vid_lan4");
		
		vlan_pri[RTL8367_VLAN_RULE_WAN_INET] = nvram_get_int("vlan_pri_cpu")  & 0x07;
		vlan_pri[RTL8367_VLAN_RULE_WAN_IPTV] = nvram_get_int("vlan_pri_iptv") & 0x07;
		vlan_pri[RTL8367_VLAN_RULE_WAN_LAN1] = nvram_get_int("vlan_pri_lan1") & 0x07;
		vlan_pri[RTL8367_VLAN_RULE_WAN_LAN2] = nvram_get_int("vlan_pri_lan2") & 0x07;
		vlan_pri[RTL8367_VLAN_RULE_WAN_LAN3] = nvram_get_int("vlan_pri_lan3") & 0x07;
		vlan_pri[RTL8367_VLAN_RULE_WAN_LAN4] = nvram_get_int("vlan_pri_lan4") & 0x07;
		
		vlan_tag[RTL8367_VLAN_RULE_WAN_INET] = 0;
		vlan_tag[RTL8367_VLAN_RULE_WAN_IPTV] = 0;
		vlan_tag[RTL8367_VLAN_RULE_WAN_LAN1] = nvram_get_int("vlan_tag_lan1");
		vlan_tag[RTL8367_VLAN_RULE_WAN_LAN2] = nvram_get_int("vlan_tag_lan2");
		vlan_tag[RTL8367_VLAN_RULE_WAN_LAN3] = nvram_get_int("vlan_tag_lan3");
		vlan_tag[RTL8367_VLAN_RULE_WAN_LAN4] = nvram_get_int("vlan_tag_lan4");
		
		if(is_vlan_vid_inet_valid(vlan_vid[RTL8367_VLAN_RULE_WAN_INET]))
			vlan_tag[RTL8367_VLAN_RULE_WAN_INET] = 1;
		else
			vlan_vid[RTL8367_VLAN_RULE_WAN_INET] = 0;
		
		if (is_vlan_vid_iptv_valid(vlan_vid[RTL8367_VLAN_RULE_WAN_INET], vlan_vid[RTL8367_VLAN_RULE_WAN_IPTV]))
			vlan_tag[RTL8367_VLAN_RULE_WAN_IPTV] = 1;
		else
			vlan_vid[RTL8367_VLAN_RULE_WAN_IPTV] = 0;
	}
	else
	{
		memset(vlan_vid, 0, sizeof(vlan_vid));
		memset(vlan_pri, 0, sizeof(vlan_pri));
		memset(vlan_tag, 0, sizeof(vlan_tag));
	}
	
	/* set vlan rule before change bridge mode! */
	for (vrule = 0; vrule <= RTL8367_VLAN_RULE_WAN_LAN4; vrule++)
		phy_vlan_rule_set(vrule, vlan_vid[vrule], vlan_pri[vrule], vlan_tag[vrule]);
	
	phy_bridge_mode(bridge_mode, bwan_isolation);
	
#if defined(USE_RT3352_MII)
	if (!first_call)
	{
		// clear isolation iNIC port from all LAN ports
		if (is_interface_up(IFNAME_INIC_MAIN) && get_mlme_radio_rt())
			phy_isolate_inic(0);
	}
#endif
}

int
is_vlan_vid_inet_valid(int vlan_vid_inet)
{
	return (vlan_vid_inet >= MIN_EXT_VLAN_VID && vlan_vid_inet < 4095) ? 1 : 0;
}

int
is_vlan_vid_iptv_valid(int vlan_vid_inet, int vlan_vid_iptv)
{
	return (vlan_vid_iptv >= MIN_EXT_VLAN_VID && vlan_vid_iptv < 4095 && vlan_vid_iptv != vlan_vid_inet) ? 1 : 0;
}

void 
reset_lan_temp(void)
{
	nvram_set_temp("lan_ipaddr_t", "");
	nvram_set_temp("lan_netmask_t", "");
	nvram_set_temp("lan_gateway_t", "");
	nvram_set_temp("lan_dns_t", "");
}

void 
reset_lan_vars(void)
{
	nvram_set("lan_hwaddr", nvram_safe_get("il0macaddr"));
}

void
start_lan(void)
{
	char *lan_ipaddr;
	char *lan_netmsk;
	char *lan_ifname = nvram_safe_get("lan_ifname");
	if (!lan_ifname[0])
	{
		lan_ifname = IFNAME_BR;
	}
	
	if (nvram_match("lan_ipaddr", ""))
	{
		nvram_set("lan_ipaddr", "192.168.1.1");
		nvram_set("lan_netmask", "255.255.255.0");
	}
	else if (nvram_match("lan_netmask", ""))
	{
		nvram_set("lan_netmask", "255.255.255.0");
	}
	
	doSystem("hostname %s", get_our_hostname());
	
	lan_ipaddr = nvram_safe_get("lan_ipaddr");
	lan_netmsk = nvram_safe_get("lan_netmask");
	
	/* 
	* Configure DHCP connection. The DHCP client will run 
	* 'udhcpc bound'/'udhcpc deconfig' upon finishing IP address 
	* renew and release.
	*/
	if (get_ap_mode())
	{
		if (nvram_match("lan_proto_x", "1"))
		{
			/* bring up and configure LAN interface */
			ifconfig(lan_ifname, IFUP, lan_ipaddr, lan_netmsk);
			
			symlink("/sbin/rc", SCRIPT_UDHCPC_LAN);
			
			/* early fill XXX_t fields */
			update_lan_status(0);
			
			/* start dhcp daemon */
			start_udhcpc_lan(lan_ifname);
		}
		else
		{
			/* bring up and configure LAN interface */
			ifconfig(lan_ifname, IFUP, lan_ipaddr, lan_netmsk);
			
			/* manual config lan gateway and dns */
			lan_up_manual(lan_ifname);
		}
	}
	else
	{
		/* bring up and configure LAN interface */
		ifconfig(lan_ifname, IFUP, lan_ipaddr, lan_netmsk);
		
		/* install lan specific static routes */
		add_static_lan_routes(lan_ifname);
		
		/* fill XXX_t fields */
		update_lan_status(0);
	}

#if defined (USE_IPV6)
	if (get_ipv6_type() != IPV6_DISABLED)
		reload_lan_addr6();
#endif
}

void
stop_lan(void)
{
	char *svcs[] = { "udhcpc", "detect_wan", NULL };

	if (get_ap_mode())
	{
		kill_services(svcs, 3, 1);
	}
	else
	{
		/* Remove static routes */
		clear_if_route4(IFNAME_BR);
	}

#if defined (USE_IPV6)
	clear_lan_addr6();
#endif

	/* Bring down LAN interface */
	ifconfig(IFNAME_BR, 0, NULL, NULL);
}

void 
full_restart_lan(void)
{
	int ap_mode = get_ap_mode();
	int lan_stp = nvram_match("lan_stp", "0") ? 0 : 1;
	int log_remote = nvram_invmatch("log_ipaddr", "");

	// Stop logger if remote
	if (log_remote)
		stop_logger();

	stop_networkmap();
	stop_upnp();
	stop_vpn_server();
	stop_dns_dhcpd();
	stop_lan();

	reset_lan_vars();

	if (!ap_mode)
	{
		doSystem("brctl stp %s %d", IFNAME_BR, 0);
		doSystem("brctl setfd %s %d", IFNAME_BR, 2);
	}

	start_lan();

	sleep(1);

	// Start logger if remote
	if (log_remote)
	{
		start_logger(0);
	}

	if (!ap_mode)
	{
		if (lan_stp) {
			doSystem("brctl stp %s %d", IFNAME_BR, 1);
			doSystem("brctl setfd %s %d", IFNAME_BR, 15);
		}
		
		/* restart vpn server, firewall and miniupnpd */
		restart_vpn_server();
		
		/* restart dns relay and dhcp server */
		start_dns_dhcpd();
		
		/* restart igmpproxy, udpxy, xupnpd */
		restart_iptv();
	}

#if defined(APP_NFSD)
	// Reload NFS server
	if (pids("nfsd"))
		run_nfsd();
#endif

	/* start ARP network scanner */
	start_networkmap();

	/* force httpd logout */
	doSystem("killall %s %s", "-SIGUSR1", "httpd");
}

void
lan_up_manual(char *lan_ifname)
{
	FILE *fp;
	int lock;
	int dns_count = 0;
	char *dns_ip, *gateway_ip;

	gateway_ip = nvram_safe_get("lan_gateway");

	/* Set default route to gateway if specified */
	if (inet_addr_(gateway_ip) != INADDR_ANY)
		route_add(lan_ifname, 0, "0.0.0.0", gateway_ip, "0.0.0.0");

	lock = file_lock("resolv");

	/* Open resolv.conf */
	fp = fopen("/etc/resolv.conf", "w+");
	if (fp) {
		dns_ip = nvram_safe_get("lan_dns1");
		if (inet_addr_(dns_ip) != INADDR_ANY) {
			fprintf(fp, "nameserver %s\n", dns_ip);
			dns_count++;
		}
		
		dns_ip = nvram_safe_get("lan_dns2");
		if (inet_addr_(dns_ip) != INADDR_ANY) {
			fprintf(fp, "nameserver %s\n", dns_ip);
			dns_count++;
		}
		
		if (!dns_count && inet_addr_(gateway_ip) != INADDR_ANY)
			fprintf(fp, "nameserver %s\n", gateway_ip);
		
		fclose(fp);
	}

	file_unlock(lock);

	/* sync time */
	notify_watchdog_time();

	/* fill XXX_t fields */
	update_lan_status(0);
}

void
lan_up_auto(char *lan_ifname)
{
	FILE *fp;
	int dns_count = 0;
	char word[100], *next, *dns_ip, *gateway_ip;

	gateway_ip = nvram_safe_get("lan_gateway_t");

	/* Set default route to gateway if specified */
	if (inet_addr_(gateway_ip) != INADDR_ANY)
		route_add(lan_ifname, 0, "0.0.0.0", gateway_ip, "0.0.0.0");

	/* Open resolv.conf */
	fp = fopen("/etc/resolv.conf", "w+");
	if (fp) {
		if (nvram_get_int("lan_dns_x") == 0)
		{
			dns_ip = nvram_safe_get("lan_dns1");
			if (inet_addr_(dns_ip) != INADDR_ANY) {
				fprintf(fp, "nameserver %s\n", dns_ip);
				dns_count++;
			}
			
			dns_ip = nvram_safe_get("lan_dns2");
			if (inet_addr_(dns_ip) != INADDR_ANY) {
				fprintf(fp, "nameserver %s\n", dns_ip);
				dns_count++;
			}
		}
		else
		{
			foreach(word, nvram_safe_get("lan_dns_t"), next) {
				if (inet_addr_(word) != INADDR_ANY) {
					fprintf(fp, "nameserver %s\n", word);
					dns_count++;
				}
			}
		}
		
		if (!dns_count && inet_addr_(gateway_ip) != INADDR_ANY)
			fprintf(fp, "nameserver %s\n", gateway_ip);
		
		fclose(fp);
	}

#if (!defined(W7_LOGO) && !defined(WIFI_LOGO))
	if (!pids("detect_wan"))
	{
		eval("detect_wan");
	}
#endif

	/* sync time */
	notify_watchdog_time();

	/* fill XXX_t fields */
	update_lan_status(1);
}

void
lan_down_auto(char *lan_ifname)
{
	FILE *fp;
	
	/* Remove default route to gateway if specified */
	route_del(lan_ifname, 0, "0.0.0.0", 
			nvram_safe_get("lan_gateway_t"),
			"0.0.0.0");

	/* Clear resolv.conf */
	fp = fopen("/etc/resolv.conf", "w+");
	if (fp)
		fclose(fp);
	
	/* fill XXX_t fields */
	update_lan_status(0);
}

void 
update_lan_status(int isup)
{
	char lan_subnet[32];

	if (!isup) {
		nvram_set_temp("lan_ipaddr_t", nvram_safe_get("lan_ipaddr"));
		nvram_set_temp("lan_netmask_t", nvram_safe_get("lan_netmask"));
		
		if (!get_ap_mode()) {
			if (nvram_match("dhcp_enable_x", "1")) {
				if (nvram_invmatch("dhcp_gateway_x", ""))
					nvram_set_temp("lan_gateway_t", nvram_safe_get("dhcp_gateway_x"));
				else
					nvram_set_temp("lan_gateway_t", nvram_safe_get("lan_ipaddr"));
			}
			else
				nvram_set_temp("lan_gateway_t", nvram_safe_get("lan_ipaddr"));
		}
		else
			nvram_set_temp("lan_gateway_t", nvram_safe_get("lan_gateway"));
	}
	
	snprintf(lan_subnet, sizeof(lan_subnet), "0x%x", 
		inet_network(nvram_safe_get("lan_ipaddr_t"))&inet_network(nvram_safe_get("lan_netmask_t")));

	nvram_set_temp("lan_subnet_t", lan_subnet);
}


static int 
udhcpc_lan_deconfig(char *lan_ifname)
{
	ifconfig(lan_ifname, IFUP,
		 nvram_safe_get("lan_ipaddr"),
		 nvram_safe_get("lan_netmask"));

	lan_down_auto(lan_ifname);

	logmessage("DHCP LAN Client", "%s: lease is lost", udhcpc_lan_state);

	return 0;
}

static int 
udhcpc_lan_bound(char *lan_ifname)
{
	char *value;
	char tmp[100], prefix[16];

	snprintf(prefix, sizeof(prefix), "lan_");
	
	if ((value = getenv("ip")))
		nvram_set_temp(strcat_r(prefix, "ipaddr_t", tmp), value);
	if ((value = getenv("subnet")))
		nvram_set_temp(strcat_r(prefix, "netmask_t", tmp), value);
        if ((value = getenv("router")))
		nvram_set_temp(strcat_r(prefix, "gateway_t", tmp), value);
	if ((value = getenv("dns")))
		nvram_set_temp(strcat_r(prefix, "dns_t", tmp), value);
	if ((value = getenv("wins")))
		nvram_set_temp(strcat_r(prefix, "wins_t", tmp), value);
#if 0
	if ((value = getenv("hostname")))
		sethostname(value, strlen(value) + 1);
#endif
	if ((value = getenv("domain")))
		nvram_set_temp(strcat_r(prefix, "domain_t", tmp), value);
	if ((value = getenv("lease")))
		nvram_set_temp(strcat_r(prefix, "lease_t", tmp), value);

	ifconfig(lan_ifname, IFUP,
		 nvram_safe_get(strcat_r(prefix, "ipaddr_t", tmp)),
		 nvram_safe_get(strcat_r(prefix, "netmask_t", tmp)));

	lan_up_auto(lan_ifname);

	logmessage("DHCP LAN Client", "%s IP : %s from %s", 
		udhcpc_lan_state, 
		nvram_safe_get(strcat_r(prefix, "ipaddr_t", tmp)), 
		nvram_safe_get(strcat_r(prefix, "gateway_t", tmp)));

	return 0;
}

static int 
udhcpc_lan_renew(char *lan_ifname)
{
	return udhcpc_lan_bound(lan_ifname);
}

static int 
udhcpc_lan_leasefail(char *lan_ifname)
{
	return 0;
}

int
udhcpc_lan_main(int argc, char **argv)
{
	int ret = 0;
	char *lan_ifname;

	if (argc<2 || !argv[1])
		return EINVAL;

	lan_ifname = safe_getenv("interface");
	strncpy(udhcpc_lan_state, argv[1], sizeof(udhcpc_lan_state));

	umask(0000);

	if (!strcmp(argv[1], "deconfig"))
		ret = udhcpc_lan_deconfig(lan_ifname);
	else if (!strcmp(argv[1], "bound"))
		ret = udhcpc_lan_bound(lan_ifname);
	else if (!strcmp(argv[1], "renew"))
		ret = udhcpc_lan_renew(lan_ifname);
	else if (!strcmp(argv[1], "leasefail"))
		ret = udhcpc_lan_leasefail(lan_ifname);
	else
		ret = udhcpc_lan_deconfig(lan_ifname);

	return ret;
}

int 
start_udhcpc_lan(const char *lan_ifname)
{
	char *lan_hostname = get_our_hostname();
	char *dhcp_argv[] = {
		"/sbin/udhcpc",
		"-i", (char *)lan_ifname,
		"-s", SCRIPT_UDHCPC_LAN,
		"-p", "/var/run/udhcpc_lan.pid",
		"-t4",
		"-T4",
		"-d", /* Background after run (new patch for udhcpc) */
		"-H", lan_hostname,
		NULL
	};
	
	logmessage("DHCP LAN Client", "starting on %s ...", lan_ifname);
	
	return _eval(dhcp_argv, NULL, 0, NULL);
}

int 
stop_udhcpc_lan()
{
	return kill_pidfile("/var/run/udhcpc_lan.pid");
}
