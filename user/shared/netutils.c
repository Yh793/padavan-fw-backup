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
#include <fcntl.h>
#include <limits.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/ioctl.h>

#include <net/ethernet.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>

#include "nvram/bcmnvram.h"
#include "netutils.h"
#include "shutils.h"

#if defined (HAVE_GETIFADDRS)
#include <ifaddrs.h>
#endif

static const struct ifname_desc_t {
	const char *ifname;
	const char *ifdesc;
} ifname_descs[] = {
	{ IFNAME_LAN,     IFDESC_LAN      },
	{ IFNAME_2G_MAIN, IFDESC_WLAN_2G  },
#if BOARD_HAS_5G_RADIO
	{ IFNAME_5G_MAIN, IFDESC_WLAN_5G  },
#endif
	{ IFNAME_WAN,     IFDESC_WAN      },
	{ IFNAME_RAS,     IFDESC_WWAN     },
	{ IFNAME_USBNET1, IFDESC_WWAN     },
	{ IFNAME_USBNET2, IFDESC_WWAN     },
	{ NULL, NULL }
};

const char* get_ifname_descriptor(const char* ifname)
{
	struct ifname_desc_t *ifd;

	for (ifd = (struct ifname_desc_t *)&ifname_descs[0]; ifd->ifname; ifd++) {
		if (strcmp(ifname, ifd->ifname) == 0)
			return ifd->ifdesc;
	}

	return NULL;
}

int get_ap_mode(void)
{
	if (nvram_match("wan_route_x", "IP_Bridged"))
		return 1;
	
	return 0;
}

int get_usb_modem_wan(int unit)
{
	char tmp[100];
	char prefix[16];

	snprintf(prefix, sizeof(prefix), "wan%d_", unit);
	if (nvram_get_int(strcat_r(prefix, "modem_dev", tmp)) != 0)
		return 1;
	else
		return 0;
}

int get_usb_modem_dev_wan(int unit, int devnum)
{
	char tmp[100];
	char prefix[16];

	snprintf(prefix, sizeof(prefix), "wan%d_", unit);
	if (nvram_get_int(strcat_r(prefix, "modem_dev", tmp)) == devnum)
		return 1;
	else
		return 0;
}

void set_usb_modem_dev_wan(int unit, int devnum)
{
	char tmp[100];
	char prefix[16];

	snprintf(prefix, sizeof(prefix), "wan%d_", unit);
	nvram_set_int_temp(strcat_r(prefix, "modem_dev", tmp), devnum);
}

int get_wan_phy_connected(void)
{
	int ret = 0;

	if (nvram_match("link_wan", "1"))
		ret |= 1;

	if ((nvram_get_int("modem_rule") > 0) && get_usb_modem_wan(0))
		ret |= 1<<1;

	return ret;
}


int get_ipv6_type(void)
{
#if defined(USE_IPV6)
	int i;
	const char *ipv6_svc_type;
	const char *ipv6_svc_names[] = {
		"static",	// IPV6_NATIVE_STATIC
		"dhcp6",	// IPV6_NATIVE_DHCP
		"6in4",		// IPV6_6IN4
		"6to4",		// IPV6_6TO4
		"6rd",		// IPV6_6RD
		NULL
	};

	ipv6_svc_type = nvram_safe_get("ip6_service");
	if (!(*ipv6_svc_type))
		return IPV6_DISABLED;
	
	for (i = 0; ipv6_svc_names[i] != NULL; i++) {
		if (strcmp(ipv6_svc_type, ipv6_svc_names[i]) == 0) return i + 1;
	}
#endif
	return IPV6_DISABLED;
}

#if defined(USE_IPV6)
static int get_prefix6_len(struct sockaddr_in6 *mask6)
{
	int i, j, prefix = 0;
	unsigned char *netmask = (unsigned char *) &(mask6)->sin6_addr;

	for (i = 0; i < 16; i++, prefix += 8)
		if (netmask[i] != 0xff)
			break;

	if (i != 16 && netmask[i])
		for (j = 7; j > 0; j--, prefix++)
			if ((netmask[i] & (1 << j)) == 0)
				break;

	return prefix;
}

char *get_ifaddr6(char *ifname, int linklocal, char *p_addr6s)
#if defined (HAVE_GETIFADDRS)
{
	char *ret = NULL;
	int prefix;
	struct ifaddrs *ifap, *ife;
	const struct sockaddr_in6 *addr6;

	if (getifaddrs(&ifap) < 0)
		return NULL;

	for (ife = ifap; ife; ife = ife->ifa_next)
	{
		if (strcmp(ifname, ife->ifa_name) != 0)
			continue;
		if (ife->ifa_addr == NULL)
			continue;
		if (ife->ifa_addr->sa_family == AF_INET6)
		{
			addr6 = (const struct sockaddr_in6 *)ife->ifa_addr;
			if (IN6_IS_ADDR_LINKLOCAL(&addr6->sin6_addr) ^ linklocal)
				continue;
			if (inet_ntop(ife->ifa_addr->sa_family, &addr6->sin6_addr, p_addr6s, INET6_ADDRSTRLEN) != NULL) {
				prefix = get_prefix6_len((struct sockaddr_in6 *)ife->ifa_netmask);
				if (prefix > 0 && prefix < 128)
					sprintf(p_addr6s, "%s/%d", p_addr6s, prefix);
				ret = p_addr6s;
				break;
			}
		}
	}
	freeifaddrs(ifap);
	return ret;
}
#else
/* getifaddrs replacement */
{
	FILE *fp;
	char *ret = NULL;
	char addr6s[INET6_ADDRSTRLEN], addr6p[8][8], devname[32];
	int if_idx, plen, scope, scope_need, dad_status;
	struct in6_addr addr6;

	scope_need = (linklocal) ? 0x20 : 0x00;

	fp = fopen("/proc/net/if_inet6", "r");
	if (!fp)
		return NULL;
	while (fscanf(fp, "%4s%4s%4s%4s%4s%4s%4s%4s %08x %02x %02x %02x %20s\n",
		addr6p[0], addr6p[1], addr6p[2], addr6p[3], addr6p[4],
		addr6p[5], addr6p[6], addr6p[7], &if_idx, &plen, &scope,
		&dad_status, devname) != EOF)
	{
		if (strcmp(ifname, devname) != 0)
			continue;
		scope = scope & 0x00f0;
		if (scope != scope_need)
			continue;
		sprintf(addr6s, "%s:%s:%s:%s:%s:%s:%s:%s",
			addr6p[0], addr6p[1], addr6p[2], addr6p[3],
			addr6p[4], addr6p[5], addr6p[6], addr6p[7]);
		if (inet_pton(AF_INET6, addr6s, &addr6) > 0 &&
		    inet_ntop(AF_INET6, &addr6, p_addr6s, INET6_ADDRSTRLEN) != NULL) {
			if (plen > 0 && plen < 128)
				sprintf(p_addr6s, "%s/%d", p_addr6s, plen);
			ret = p_addr6s;
			break;
		}
	}
	fclose(fp);
	return ret;
}
#endif
#endif


