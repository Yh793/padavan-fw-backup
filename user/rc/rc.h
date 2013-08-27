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

#ifndef _rc_h_
#define _rc_h_

#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#include <shutils.h>
#include <netutils.h>
#include <usb_info.h>
#include <boards.h>

#define IFUP				(IFF_UP | IFF_RUNNING | IFF_BROADCAST | IFF_MULTICAST)

#define sin_addr(s)			(((struct sockaddr_in *)(s))->sin_addr)

#define SCRIPT_UDHCPC_LAN		"/tmp/udhcpc_lan.script"
#define SCRIPT_UDHCPC_WAN		"/tmp/udhcpc.script"
#define SCRIPT_UDHCPC_VIPTV		"/tmp/udhcpc_viptv.script"
#define SCRIPT_ZCIP_WAN			"/tmp/zcip.script"
#define SCRIPT_ZCIP_VIPTV		"/tmp/zcip_viptv.script"
#define SCRIPT_WPACLI_WAN		"/tmp/wpacli.script"
#define SCRIPT_DHCP6C_WAN		"/tmp/dhcp6c.script"

#define SCRIPT_POST_WAN			"/etc/storage/post_wan_script.sh"
#define SCRIPT_POST_FIREWALL		"/etc/storage/post_iptables_script.sh"

#define SCRIPT_OPENVPN			"openvpn.script"

#define VPN_SERVER_LEASE_FILE		"/tmp/vpns.leases"
#define VPN_SERVER_SUBNET_MASK		"255.255.255.0"

#define VPN_SERVER_PPPD_OPTIONS		"/tmp/ppp/options.vpns"
#define VPN_CLIENT_PPPD_OPTIONS		"/tmp/ppp/options.vpnc"

#define MODEM_NODE_DIR			"/tmp/modem"
#define PPP_PEERS_DIR			"/tmp/ppp/peers"

#define QMI_CLIENT_ID			"/tmp/qmi-client-id"
#define QMI_HANDLE_OK			"/tmp/qmi-handle"

#define DDNS_CONF_FILE			"/etc/inadyn.conf"
#define DDNS_CACHE_FILE			"/tmp/ddns.cache"
#define DDNS_DONE_SCRIPT		"/sbin/ddns_updated"
#define DDNS_FORCE_DAYS			(7)

#define SR_PREFIX_LAN			"LAN"
#define SR_PREFIX_MAN			"MAN"
#define SR_PREFIX_WAN			"WAN"

#define MAX_CLIENTS_NUM			(50)

/* rc.c */
void setenv_tz(void);
void setkernel_tz(void);
void init_router(void);
void shutdown_router(void);
void handle_notifications(void);
void LED_CONTROL(int led, int flag);

/* init.c */
void init_main_loop(void);
void sys_exit(void);
int  is_system_down(void);

/* auth.c */
int  wpacli_main(int argc, char **argv);
int  start_auth_eapol(const char *ifname);
void stop_auth_eapol(void);
int  start_auth_kabinet(void);
void stop_auth_kabinet(void);

/* common_ex.c */
long uptime(void);
void nvram_commit_safe(void);
int rand_seed_by_time(void);
in_addr_t inet_addr_(const char *cp);
void wan_netmask_check(void);
void logmessage(char *logheader, char *fmt, ...);
void restart_all_sysctl(void);
void convert_asus_values(int skipflag);
void init_router_mode();
void update_router_mode();
char *mac_conv(char *mac_name, int idx, char *buf);
char *mac_conv2(char *mac_name, int idx, char *buf);
void getsyspara(void);
char *trim_r(char *str);
void char_to_ascii(char *output, char *input);
int fput_string(const char *name, const char *value);
int fput_int(const char *name, int value);
int is_module_loaded(char *module_name);
int module_smart_load(char *module_name);
int module_smart_unload(char *module_name, int recurse_unload);
void kill_services(char* svc_name[], int wtimeout, int forcekill);
int kill_process_pidfile(char *pidfile, int wtimeout, int forcekill);

/* net.c */
int  control_static_routes(char *ift, char *ifname, int is_add);
int  route_add(char *name, int metric, char *dst, char *gateway, char *genmask);
int  route_del(char *name, int metric, char *dst, char *gateway, char *genmask);
int  ifconfig(char *ifname, int flags, char *addr, char *netmask);
int  is_interface_up(const char *ifname);
int  is_valid_hostname(const char *name);
char* get_our_hostname(void);
int  is_same_subnet(char *ip1, char *ip2, char *msk);
int  is_same_subnet2(char *ip1, char *ip2, char *msk1, char *msk2);
#if defined(APP_XUPNPD)
void stop_xupnpd(void);
void start_xupnpd(char *wan_ifname);
#endif
void stop_igmpproxy(char *wan_ifname);
void start_igmpproxy(char *wan_ifname);
void restart_iptv(void);
int  is_ap_mode(void);
int  preset_wan_routes(char *ifname);
void flush_conntrack_caches(void);
void flush_route_caches(void);
void clear_if_route4(char *ifname);
int  is_hwnat_allow(void);
int  is_hwnat_loaded(void);
int  is_fastnat_allow(void);
int  is_ftp_conntrack_loaded(int ftp_port0, int ftp_port1);
int  is_interface_exist(const char *ifname);
int  found_default_route(int only_broadband_wan);
void hwnat_load(void);
void hwnat_unload(void);
void hwnat_configure(void);
void reload_nat_modules(void);
void restart_firewall(void);
in_addr_t get_ipv4_addr(char* ifname);

/* net_lan.c */
in_addr_t get_lan_ipaddr(void);
int add_static_lan_routes(char *lan_ifname);
int del_static_lan_routes(char *lan_ifname);
void reset_lan_vars(void);
void start_lan(void);
void stop_lan(void);
void lan_up_manual(char *lan_ifname);
void lan_up_auto(char *lan_ifname);
void lan_down_auto(char *lan_ifname);
void update_lan_status(int isup);
void full_restart_lan(void);
void init_loopback(void);
void init_bridge(void);
void switch_config_base(void);
void switch_config_storm(void);
void switch_config_link(void);
void switch_config_vlan(int first_call);
int  is_vlan_vid_inet_valid(int vlan_vid_inet);
int  is_vlan_vid_iptv_valid(int vlan_vid_inet, int vlan_vid_iptv);
int  start_udhcpc_lan(const char *lan_ifname);
int  stop_udhcpc_lan();
int  udhcpc_lan_main(int argc, char **argv);

/* net_wan.c */
void reset_wan_vars(int full_reset);
void set_man_ifname(char *man_ifname, int unit);
char*get_man_ifname(int unit);
int  get_vlan_vid_wan(void);
void start_wan(void);
void stop_wan(void);
void stop_wan_ppp(void);
void wan_up(char *ifname);
void wan_down(char *ifname);
void select_usb_modem_to_wan(void);
void full_restart_wan(void);
void try_wan_reconnect(int try_use_modem);
void add_dhcp_routes(char *rt, char *rt_rfc, char *rt_ms, char *ifname, int metric);
void add_dhcp_routes_by_prefix(char *prefix, char *ifname, int metric);
int  add_static_wan_routes(char *wan_ifname);
int  del_static_wan_routes(char *wan_ifname);
int  add_static_man_routes(char *wan_ifname);
int  del_static_man_routes(char *wan_ifname);
int  update_resolvconf(int is_first_run, int do_not_notify);
int  update_hosts(void);
int  wan_ifunit(char *ifname);
int  wan_primary_ifunit(void);
int  is_wan_ppp(char *wan_proto);
int  wan_prefix(char *ifname, char *prefix);
void get_wan_ifname(char wan_ifname[16]);
void update_wan_status(int isup);
in_addr_t get_wan_ipaddr(int only_broadband_wan);
int  has_wan_ip(int only_broadband_wan);
int  is_ifunit_modem(char *wan_ifname);
int  is_dns_static(void);
int  is_physical_wan_dhcp(void);
int udhcpc_main(int argc, char **argv);
int udhcpc_viptv_main(int argc, char **argv);
int zcip_main(int argc, char **argv);
int zcip_viptv_main(int argc, char **argv);
int start_udhcpc_wan(const char *wan_ifname, int unit, int wait_lease);
int renew_udhcpc_wan(int unit);
int release_udhcpc_wan(int unit);
int stop_udhcpc_wan(int unit);
int start_udhcpc_viptv(const char *man_ifname);
int stop_udhcpc_viptv(void);
int start_zcip_wan(const char *wan_ifname);
int start_zcip_viptv(const char *man_ifname);

/* net_ppp.c */
int start_pppd(char *prefix);
int safe_start_xl2tpd(void);
void set_ipv4_forward(void);
void set_pppoe_passthrough(void);
void disable_all_passthrough(void);
int ipup_main(int argc, char **argv);
int ipdown_main(int argc, char **argv);
int ppp_ifunit(char *ifname);

#if defined (USE_IPV6)
/* net6.c */
void init_ipv6(void);
void control_if_ipv6_all(int enable);
void control_if_ipv6(char *ifname, int enable);
void control_if_ipv6_autoconf(char *ifname, int enable);
void control_if_ipv6_radv(char *ifname, int enable);
void control_if_ipv6_dad(char *ifname, int enable);
void full_restart_ipv6(int ipv6_type_old);
void clear_if_addr6(char *ifname);
void clear_if_route6(char *ifname);
void clear_if_neigh6(char *ifname);
void clear_all_addr6(void);
void clear_all_route6(void);
int ipv6_from_string(const char *str, struct in6_addr *addr6);
int ipv6_to_net(struct in6_addr *addr6, int prefix);
int ipv6_to_host(struct in6_addr *addr6, int prefix);
int ipv6_to_ipv4_map(struct in6_addr *addr6, int size6, struct in_addr *addr4, int size4);

/* net_lan6.c */
int is_lan_addr6_static(void);
int is_lan_radv_on(void);
int is_lan_dhcp6s_on(void);
int store_lan_addr6(char *lan_addr6_new);
void reload_lan_addr6(void);
void clear_lan_addr6(void);
void reset_lan6_vars(void);
char *get_lan_addr6_host(char *p_addr6s);
char *get_lan_addr6_prefix(char *p_addr6s);
int reload_radvd(void);
void stop_radvd(void);
void restart_radvd(void);

/* net_wan6.c */
int is_wan_dns6_static(void);
int is_wan_addr6_static(void);
int is_wan_ipv6_type_sit(void);
int is_wan_ipv6_if_ppp(void);
int  store_wan_dns6(char *dns6_new);
void reset_wan6_vars(void);
void store_ip6rd_from_dhcp(const char *env_value, const char *prefix);
void start_sit_tunnel(int ipv6_type, char *wan_addr4, char *wan_addr6);
void stop_sit_tunnel(void);
void wan6_up(char *wan_ifname);
void wan6_down(char *wan_ifname);
int dhcp6c_main(int argc, char **argv);
int start_dhcp6c(char *wan_ifname);
void stop_dhcp6c(void);

/* net_ppp.c */
int ipv6up_main(int argc, char **argv);
int ipv6down_main(int argc, char **argv);

/* firewall_ex.c */
void ip6t_filter_default(void);
#endif

/* vpn_server.c */
int start_vpn_server(void);
void stop_vpn_server(void);
void restart_vpn_server(void);
int ipup_vpns_main(int argc, char **argv);
int ipdown_vpns_main(int argc, char **argv);

/* vpn_client.c */
int start_vpn_client(void);
void stop_vpn_client(void);
void restart_vpn_client(void);
int ipup_vpnc_main(int argc, char **argv);
int ipdown_vpnc_main(int argc, char **argv);

#if defined(APP_OPENVPN)
/* openvpn.c */
int start_openvpn_server(void);
int start_openvpn_client(void);
void stop_openvpn_server(void);
void stop_openvpn_client(void);
int openvpn_script_main(int argc, char **argv);
#endif

/* net_wifi.c */
void mlme_state_wl(int is_on);
void mlme_state_rt(int is_on);
void mlme_radio_wl(int is_on);
void mlme_radio_rt(int is_on);
int  get_mlme_radio_wl(void);
int  get_mlme_radio_rt(void);
int  get_enabled_radio_wl(void);
int  get_enabled_radio_rt(void);
void start_wifi_ap_wl(int radio_on);
void start_wifi_ap_rt(int radio_on);
void start_wifi_wds_wl(int radio_on);
void start_wifi_wds_rt(int radio_on);
void start_wifi_apcli_wl(int radio_on);
void start_wifi_apcli_rt(int radio_on);
int  is_radio_on_wl(void);
int  is_radio_on_rt(void);
int  is_radio_allowed_wl(void);
int  is_radio_allowed_rt(void);
int  is_guest_allowed_wl(void);
int  is_guest_allowed_rt(void);
int  control_radio_wl(int radio_on, int manual);
int  control_radio_rt(int radio_on, int manual);
int  control_guest_wl(int guest_on, int manual);
int  control_guest_rt(int guest_on, int manual);
void restart_wifi_wl(int radio_on, int need_reload_conf);
void restart_wifi_rt(int radio_on, int need_reload_conf);
void stop_wifi_all_wl(void);
void stop_wifi_all_rt(void);
void restart_guest_lan_isolation(void);
int  manual_toggle_radio_rt(int radio_on);
int  manual_toggle_radio_wl(int radio_on);
int  manual_forced_radio_rt(int radio_on);
int  manual_forced_radio_wl(int radio_on);
int  timecheck_wifi(char *nv_date, char *nv_time1, char *nv_time2);

/* services.c */
void stop_telnetd(void);
void run_telnetd(void);
void start_telnetd(void);
#if defined(APP_SSHD)
int is_sshd_run(void);
void stop_sshd(void);
void start_sshd(void);
#endif
void restart_term(void);
void start_httpd(int restart_fw);
void stop_httpd(void);
void restart_httpd(void);
int is_upnp_run(void);
int start_upnp(void);
void stop_upnp(void);
void smart_restart_upnp(void);
void update_upnp(void);
int start_lltd(void);
void stop_lltd(void);
void stop_rstats(void);
void start_rstats(void);
int start_services(void);
void stop_services(int stopall);
void stop_services_lan_wan(void);
void write_storage_to_mtd(void);
void erase_storage(void);
void erase_nvram(void);
int start_logger(int showinfo);
void stop_logger(void);
void set_pagecache_reclaim(void);

/* services_ex.c */
int mkdir_if_none(char *dir);
void start_infosvr(void);
void stop_infosvr(void);
#if defined(SRV_U2EC)
void start_u2ec(void);
void stop_u2ec(void);
#endif
#if defined(SRV_LPRD)
void start_lpd(void);
void stop_lpd(void);
#endif
void start_p910nd(char *devlp);
void stop_p910nd(void);
#if defined(APP_SMBD)
void stop_samba(void);
void run_samba(void);
#endif
#if defined(APP_FTPD)
int is_ftp_run(void);
void stop_ftp(void);
void run_ftp(void);
void control_ftp_fw(int is_run_before);
void restart_ftp(void);
#endif
#if defined(APP_NFSD)
void stop_nfsd(void);
void run_nfsd(void);
#endif
#if defined(APP_MINIDLNA)
int is_dms_run(void);
void update_minidlna_conf(const char *link_path, const char *conf_path);
void stop_dms(void);
void run_dms(void);
void restart_dms(void);
#endif
#if defined(APP_FIREFLY)
int is_itunes_run(void);
void stop_itunes(void);
void run_itunes(void);
void restart_itunes(void);
#endif
#if defined(APP_TRMD)
int is_torrent_run(void);
int is_torrent_support(void);
void stop_torrent(void);
void run_torrent(int no_restart_firewall);
void restart_torrent(void);
#endif
#if defined(APP_ARIA)
int is_aria_run(void);
int is_aria_support(void);
void stop_aria(void);
void run_aria(int no_restart_firewall);
void restart_aria(void);
#endif
void stop_networkmap(void);
void restart_networkmap(void);
int start_dns_dhcpd(void);
void stop_dns_dhcpd(void);
int try_start_dns_dhcpd(void);
int ddns_updated_main(int argc, char *argv[]);
int update_ddns(void);
int start_ddns(void);
void stop_ddns(void);
void stop_misc(int stop_watchdog);
void stop_usb(void);
void restart_usb_printer_spoolers(void);
void try_start_usb_printer_spoolers(void);
void stop_usb_printer_spoolers(void);
void on_deferred_hotplug_usb(void);
void umount_ejected(void);
int count_sddev_mountpoint(void);
int count_sddev_partition(void);
void start_usb_apps(void);
void stop_usb_apps(void);
void try_start_usb_apps(void);
void umount_sddev_all(void);

void manual_wan_disconnect(void);
void manual_wan_connect(void);
void manual_ddns_hostname_check(void);
void try_start_usb_modem_to_wan(void);
int restart_dhcpd(void);
int restart_dns(void);
int safe_remove_usb_device(int port, const char *dev_name);
int check_if_file_exist(const char *filepath);
int check_if_dir_exist(const char *dirpath);
int check_if_dev_exist(const char *devpath);
void umount_dev(char *sd_dev);
void umount_dev_all(char *sd_dev);
void umount_sddev_all(void);
int stop_service_main(int argc, char *argv[]);
void start_8021x_wl(void);
void stop_8021x_wl(void);
void start_8021x_rt(void);
void stop_8021x_rt(void);
int start_networkmap(void);
void stop_syslogd();
void stop_klogd();
int start_syslogd();
int start_klogd();

/* firewall_ex.c */
void ipt_nat_default(void);
void ipt_filter_default(void);
void fill_static_routes(char *buf, int len, const char *ift);
void ip2class(char *lan_ip, char *netmask, char *buf);
int start_firewall_ex(char *wan_if, char *wan_ip);

/* ralink.c */
int get_wireless_mac(int is_5ghz);
int set_wireless_mac(int is_5ghz, const char *mac);
int get_wireless_cc(void);
int set_wireless_cc(const char *cc);
int gen_ralink_config_wl(int disable_autoscan);
int gen_ralink_config_rt(int disable_autoscan);
int getPIN(void);
int setPIN(const char *pin);
int getBootVer(void);
int getCountryRegion(const char *str);
int getCountryRegionABand(const char *str);

/* watchdog.c */
int  watchdog_main(int argc, char *argv[]);
int  start_watchdog(void);
void notify_watchdog_time(void);
void notify_watchdog_nmap(void);
void notify_watchdog_wifi(int is_5ghz);

#if defined(USE_RT3352_MII)
/* inicd */
int inicd_main(int argc, char *argv[]);
int start_inicd(void);
int stop_inicd(void);
#endif

/* rstats.c */
int  rstats_main(int argc, char *argv[]);
void notify_rstats_time(void);

/* detect_link.c */
int detect_link_main(int argc, char *argv[]);
int start_detect_link(void);
void stop_detect_link(void);
void reset_detect_link(void);
void start_flash_usbled(void);
void stop_flash_usbled(void);

/* detect_internet.c */
int detect_internet_main(int argc, char *argv[]);
int start_detect_internet(void);
void stop_detect_internet(void);

/* detect_wan.c */
int detect_wan_main(int argc, char *argv[]);

/* usb_modem.c */
int  is_ready_modem_ras(int* devnum_out);
int  is_ready_modem_ndis(int* devnum_out);
int  connect_ndis(int devnum);
int  disconnect_ndis(int devnum);
void stop_modem_ras(void);
void stop_modem_ndis(void);
int  get_modem_ndis_ifname(char ndis_ifname[16], int *devnum_out);
void safe_remove_usb_modem(void);
void unload_modem_modules(void);
void reload_modem_modules(int modem_type, int reload);
int  launch_modem_ras_pppd(int unit);
int  perform_usb_modeswitch(char *vid, char *pid);

/* usb_devices.c */
#if defined(BOARD_N65U)
void set_pcie_aspm(void);
#endif
void detach_swap_partition(char *part_name);
int  usb_port_module_used(const char *mod_usb);
int  mdev_sg_main(int argc, char **argv);
int  mdev_sd_main(int argc, char **argv);
int  mdev_sr_main(int argc, char **argv);
int  mdev_lp_main(int argc, char **argv);
int  mdev_net_main(int argc, char **argv);
int  mdev_tty_main(int argc, char **argv);
int  mdev_wdm_main(int argc, char **argv);

// for log message title
#define ERR		"err"
#define LOGNAME		BOARD_NAME


#define varkey_nvram_set(key, value, args...)({ \
        char nvram_word[64]; \
        memset(nvram_word, 0x00, sizeof(nvram_word)); \
        sprintf(nvram_word, key, ##args); \
        nvram_set(nvram_word, value); \
})

#define varval_nvram_set(key, value, args...)({ \
        char nvram_value[64]; \
        memset(nvram_value, 0x00, sizeof(nvram_value)); \
        sprintf(nvram_value, value, ##args); \
        nvram_set(key, nvram_value); \
})

#define MACSIZE 12
#endif /* _rc_h_ */
