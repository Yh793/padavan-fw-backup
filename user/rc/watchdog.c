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
#include <signal.h>
#include <time.h>
#include <errno.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdarg.h>

#include <syslog.h>
#include <nvram/bcmnvram.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <math.h>
#include <string.h>
#include <sys/wait.h>

#include <sys/ioctl.h>

#include <shutils.h>
#include <notify_rc.h>

#include "rc.h"
#include "ralink.h"
#include "rtl8367.h"


#define RESET_WAIT		5		/* seconds */
#define RESET_WAIT_COUNT	RESET_WAIT * 10 /* 10 times a second */

#define NORMAL_PERIOD		1		/* second */
#define URGENT_PERIOD		100 * 1000	/* microsecond */

#if defined(BTN_WPS)
#define WPS_WAIT		3
#define WPS_WAIT_COUNT		WPS_WAIT * 10
#endif

enum 
{
	RADIO5_ACTIVE = 0,
	GUEST5_ACTIVE,
	RADIO2_ACTIVE,
	GUEST2_ACTIVE,
	ACTIVEITEMS
};

static int svcStatus[ACTIVEITEMS] = {-1, -1, -1, -1};

static int watchdog_period = 0;
static int ntpc_timer = -1;
static int nmap_timer = 1;
static int ntpc_server_idx = 0;

struct itimerval itv;

static int btn_pressed_reset = 0;
static int btn_count_reset = 0;

#if defined(BTN_WPS)
static int btn_pressed_wps = 0;
static int btn_count_wps = 0;
#endif

static int ez_radio_state = 0;
static int ez_radio_state_2g = 0;
static int ez_radio_manual = 0;
static int ez_radio_manual_2g = 0;

void ez_event_short();
void ez_event_long();


static void
alarmtimer(unsigned long sec, unsigned long usec)
{
	itv.it_value.tv_sec  = sec;
	itv.it_value.tv_usec = usec;
	itv.it_interval = itv.it_value;
	setitimer(ITIMER_REAL, &itv, NULL);
}

#ifdef HTTPD_CHECK
#define DETECT_HTTPD_FILE "/tmp/httpd_check_result"

static int
httpd_check_v2()
{
#if (!defined(W7_LOGO) && !defined(WIFI_LOGO))
	int i, httpd_live, http_port;
	FILE *fp = NULL;
	char line[80];
	time_t now;
	static int check_count_down = 3;
	static int httpd_timer = 0;
	
	// skip 30 seconds after start watchdog
	if (check_count_down)
	{
		check_count_down--;
		return 1;
	}
	
	// check every 30 seconds
	httpd_timer = (httpd_timer + 1) % 3;
	if (httpd_timer) return 1;
	
	now = uptime();
	if (nvram_get("login_timestamp") && ((unsigned long)(now - strtoul(nvram_safe_get("login_timestamp"), NULL, 10)) < 60))
	{
		return 1;
	}
	
	remove(DETECT_HTTPD_FILE);
	
	http_port = nvram_get_int("http_lanport");
	
	/* httpd will not count 127.0.0.1 */
	doSystem("wget -q http://127.0.0.1:%d/httpd_check.htm -O %s &", http_port, DETECT_HTTPD_FILE);
	
	httpd_live = 0;
	for (i=0; i < 3; i++)
	{
		if ((fp = fopen(DETECT_HTTPD_FILE, "r")) != NULL)
		{
			if ( fgets(line, sizeof(line), fp) != NULL )
			{
				if (strstr(line, "ASUSTeK"))
				{
					httpd_live = 1;
				}
			}
			
			fclose(fp);
		}
		
		if (httpd_live)
			break;
		
		/* check port changed */
		if (nvram_get_int("http_lanport") != http_port) 
		{
			if (pids("wget"))
				system("killall wget");
			return 1;
		}
		
		sleep(1);
	}
	
	if (!httpd_live)
	{
		if (pids("wget"))
			system("killall wget");
		
		dbg("httpd is so dead!!!\n");
		
		return 0;
	}
	
	return 1;
#else
	return 1;
#endif
}

#endif

static void 
btn_check_reset(void)
{
	unsigned int i_button_value = 1;

#if defined(BTN_WPS)
	// check WPS pressed
	if (btn_pressed_wps != 0) return;
#endif

	if (cpu_gpio_get_pin(BTN_RESET, &i_button_value) < 0)
		return;

	// reset button is on low phase
	if (!i_button_value)
	{
		// "RESET" pressed
		if (!btn_pressed_reset)
		{
			btn_pressed_reset = 1;
			btn_count_reset = 0;
			alarmtimer(0, URGENT_PERIOD);
		}
		else
		{	/* Whenever it is pushed steady */
			if (++btn_count_reset > RESET_WAIT_COUNT)
			{
				dbg("You can release RESET button now!\n");
				btn_pressed_reset = 2;
			}
			
			if (btn_pressed_reset == 2)
			{
				if (btn_count_reset % 2)
					cpu_gpio_set_pin(LED_POWER, LED_OFF);
				else
					cpu_gpio_set_pin(LED_POWER, LED_ON);
			}
		}
	}
	else
	{
		// "RESET" released
		if (btn_pressed_reset == 1)
		{
			// pressed < 5sec, cancel
			btn_count_reset = 0;
			btn_pressed_reset = 0;
			LED_CONTROL(LED_POWER, LED_ON);
			alarmtimer(NORMAL_PERIOD, 0);
		}
		else if (btn_pressed_reset == 2)
		{
			// pressed >= 5sec, reset!
			LED_CONTROL(LED_POWER, LED_OFF);
			alarmtimer(0, 0);
			erase_nvram();
			erase_storage();
			sys_exit();
		}
	}
}

static void 
btn_check_ez(void)
{
#if defined(BTN_WPS)
	int i_front_leds, i_led0, i_led1;
	unsigned int i_button_value = 1;

	// check RESET pressed
	if (btn_pressed_reset != 0) return;

	if (cpu_gpio_get_pin(BTN_WPS, &i_button_value) < 0)
		return;

	if (!i_button_value)
	{
		// WPS pressed
		
		i_front_leds = nvram_get_int("front_leds");
		if (i_front_leds == 2 || i_front_leds == 4)
		{
			// POWER always OFF
			i_led0 = LED_ON;
			i_led1 = LED_OFF;
		}
		else
		{
			// POWER always ON
			i_led0 = LED_OFF;
			i_led1 = LED_ON;
		}
		
		if (btn_pressed_wps == 0)
		{
			btn_pressed_wps = 1;
			btn_count_wps = 0;
			alarmtimer(0, URGENT_PERIOD);
			
			// toggle power LED
			cpu_gpio_set_pin(LED_POWER, i_led0);
		}
		else
		{
			if (++btn_count_wps > WPS_WAIT_COUNT)
			{
				btn_pressed_wps = 2;
			}
			
			if (btn_pressed_wps == 2)
			{
				// flash power LED
				if (btn_count_wps % 2)
					cpu_gpio_set_pin(LED_POWER, i_led1);
				else
					cpu_gpio_set_pin(LED_POWER, i_led0);
			}
		}
	}
	else
	{
		// WPS released
		if (btn_pressed_wps == 1)
		{
			btn_pressed_wps = 0;
			btn_count_wps = 0;
			
			// pressed < 3sec
			ez_event_short();
		}
		else if (btn_pressed_wps == 2)
		{
			btn_pressed_wps = 0;
			btn_count_wps = 0;
			
			// pressed >= 3sec
			ez_event_long();
		}
	}
#endif
}

static void 
refresh_ntp(void)
{
	char *ntp_server;
	char* svcs[] = { "ntpd", NULL };

	kill_services(svcs, 3, 1);

	if (ntpc_server_idx)
		ntp_server = nvram_safe_get("ntp_server1");
	else
		ntp_server = nvram_safe_get("ntp_server0");
	
	ntpc_server_idx = (ntpc_server_idx + 1) % 2;
	
	if (!(*ntp_server))
		ntp_server = "pool.ntp.org";

	logmessage("NTP Scheduler", "Synchronizing time to %s ...", ntp_server);

	eval("/usr/sbin/ntpd", "-qt", "-p", ntp_server);
}

static void 
ntpc_handler(void)
{
	time_t now;
	int ntp_period;
	struct tm local;
	static int ntp_first_tryes = 12; // try 12 times every 10 sec

	ntp_period = nvram_get_int("ntp_period");
	if (ntp_period < 1) ntp_period = 1;
	if (ntp_period > 336) ntp_period = 336; // two weeks
	ntp_period = ntp_period * 360;

	// update ntp every period time
	ntpc_timer = (ntpc_timer + 1) % ntp_period;
	if (ntpc_timer == 0)
	{
		refresh_ntp();
	}
	else if (ntp_first_tryes > 0)
	{
		time(&now);
		localtime_r(&now, &local);
		
		/* Less than 2012 */
		if (local.tm_year < (2012-1900))
		{
			refresh_ntp();
			ntp_first_tryes--;
		}
		else
		{
			ntp_first_tryes = 0;
			logmessage("NTP Scheduler", "System time changed.");
		}
	}
}

static void 
inet_handler(void)
{
	if (nvram_match("wan_route_x", "IP_Routed"))
	{
		if (nvram_invmatch("wan_gateway_t", "") && has_wan_ip(0))
		{
			/* sync time to ntp server if necessary */
			ntpc_handler();
		}
	}
	else
	{
		if (nvram_invmatch("lan_gateway_t", ""))
			ntpc_handler();
	}
}

static void 
nmap_handler(void)
{
	// update network map every 3 hours
	nmap_timer = (nmap_timer + 1) % 1080;
	if (nmap_timer == 0)
	{
		// update network map
		restart_networkmap();
	}
}

/* Check for time-dependent service */
static int 
svc_timecheck(void)
{
	int activeNow;

	if (!nvram_match("wl_radio_x", "0"))
	{
		/* Initialize */
		if (nvram_match("reload_svc_wl", "1"))
		{
			nvram_set("reload_svc_wl", "0");
			ez_radio_manual = 0;
			svcStatus[RADIO5_ACTIVE] = -1;
			svcStatus[GUEST5_ACTIVE] = -1;
		}
		
		if (!ez_radio_manual)
		{
			activeNow = is_radio_allowed_wl();
			if (activeNow != svcStatus[RADIO5_ACTIVE])
			{
				svcStatus[RADIO5_ACTIVE] = activeNow;
				
				if (activeNow)
					notify_rc("control_wifi_radio_wl_on");
				else
					notify_rc("control_wifi_radio_wl_off");
			}
		}
		
		if (svcStatus[RADIO5_ACTIVE] > 0)
		{
			activeNow = is_guest_allowed_wl();
			if (activeNow != svcStatus[GUEST5_ACTIVE])
			{
				svcStatus[GUEST5_ACTIVE] = activeNow;
				
				if (activeNow)
					notify_rc("control_wifi_guest_wl_on");
				else
					notify_rc("control_wifi_guest_wl_off");
			}
		}
		else
		{
			if (svcStatus[GUEST5_ACTIVE] >= 0)
				svcStatus[GUEST5_ACTIVE] = -1;
		}
	}

	if (!nvram_match("rt_radio_x", "0"))
	{
		/* Initialize */
		if (nvram_match("reload_svc_rt", "1"))
		{
			nvram_set("reload_svc_rt", "0");
			ez_radio_manual_2g = 0;
			svcStatus[RADIO2_ACTIVE] = -1;
			svcStatus[GUEST2_ACTIVE] = -1;
		}
		
		if (!ez_radio_manual_2g)
		{
			activeNow = is_radio_allowed_rt();
			if (activeNow != svcStatus[RADIO2_ACTIVE])
			{
				svcStatus[RADIO2_ACTIVE] = activeNow;
				
				if (activeNow)
					notify_rc("control_wifi_radio_rt_on");
				else
					notify_rc("control_wifi_radio_rt_off");
			}
		}
		
		if (svcStatus[RADIO2_ACTIVE] > 0)
		{
			activeNow = is_guest_allowed_rt();
			if (activeNow != svcStatus[GUEST2_ACTIVE])
			{
				svcStatus[GUEST2_ACTIVE] = activeNow;
				
				if (activeNow)
					notify_rc("control_wifi_guest_rt_on");
				else
					notify_rc("control_wifi_guest_rt_off");
			}
		}
		else
		{
			if (svcStatus[GUEST2_ACTIVE] >= 0)
				svcStatus[GUEST2_ACTIVE] = -1;
		}
	}

	return 0;
}

static void 
ez_action_toggle_wifi24(void)
{
	if (!nvram_match("rt_radio_x", "0"))
	{
		// block time check
		ez_radio_manual_2g = 1;
		
		if (svcStatus[RADIO2_ACTIVE] >= 0)
		{
			ez_radio_state_2g = svcStatus[RADIO2_ACTIVE];
		}
		
		ez_radio_state_2g = !ez_radio_state_2g;
		svcStatus[RADIO2_ACTIVE] = ez_radio_state_2g;
		
		logmessage("watchdog", "Perform ez-button toggle 2.4GHz radio: %s", (ez_radio_state_2g) ? "ON" : "OFF");
		
		control_radio_rt(ez_radio_state_2g, 1);
	}
}

static void 
ez_action_toggle_wifi5(void)
{
	if (!nvram_match("wl_radio_x", "0"))
	{
		// block time check
		ez_radio_manual = 1;
		
		if (svcStatus[RADIO5_ACTIVE] >= 0)
		{
			ez_radio_state = svcStatus[RADIO5_ACTIVE];
		}
		
		ez_radio_state = !ez_radio_state;
		svcStatus[RADIO5_ACTIVE] = ez_radio_state;
		
		logmessage("watchdog", "Perform ez-button toggle 5GHz radio: %s", (ez_radio_state) ? "ON" : "OFF");
		
		control_radio_wl(ez_radio_state, 1);
	}
}

static void 
ez_action_force_toggle_wifi24(void)
{
	if (!nvram_match("rt_radio_x", "0"))
	{
		nvram_set("rt_radio_x", "0");
		
		ez_radio_state_2g = 0;
	}
	else
	{
		nvram_set("rt_radio_x", "1");
		
		ez_radio_state_2g = 1;
	}
	
	svcStatus[RADIO2_ACTIVE] = ez_radio_state_2g;
	
	nvram_set("reload_svc_rt", "0");
	
	// block time check
	ez_radio_manual_2g = 1;
	
	logmessage("watchdog", "Perform ez-button force toggle 2.4GHz radio: %s", (ez_radio_state_2g) ? "ON" : "OFF");
	
	control_radio_rt(ez_radio_state_2g, 1);
}

static void 
ez_action_force_toggle_wifi5(void)
{
	if (!nvram_match("wl_radio_x", "0"))
	{
		nvram_set("wl_radio_x", "0");
		
		ez_radio_state = 0;
	}
	else
	{
		nvram_set("wl_radio_x", "1");
		
		ez_radio_state = 1;
	}
	
	svcStatus[RADIO5_ACTIVE] = ez_radio_state;
	
	nvram_set("reload_svc_wl", "0");
	
	// block time check
	ez_radio_manual = 1;
	
	logmessage("watchdog", "Perform ez-button force toggle 5GHz radio: %s", (ez_radio_state) ? "ON" : "OFF");
	
	control_radio_wl(ez_radio_state, 1);

}

static void 
ez_action_usb_saferemoval(void)
{
	logmessage("watchdog", "Perform ez-button safe-removal USB...");
	
	safe_remove_usb_device(0, NULL);
}

static void 
ez_action_wan_down(void)
{
	if (is_ap_mode())
		return;
	
	logmessage("watchdog", "Perform ez-button WAN down...");
	
	stop_wan();
}

static void 
ez_action_wan_reconnect(void)
{
	if (is_ap_mode())
		return;
	
	logmessage("watchdog", "Perform ez-button WAN reconnect...");
	
	full_restart_wan();
}

static void 
ez_action_wan_toggle(void)
{
	if (is_ap_mode())
		return;
	
	if (is_interface_up(get_man_ifname(0)))
	{
		logmessage("watchdog", "Perform ez-button WAN down...");
		
		stop_wan();
	}
	else
	{
		logmessage("watchdog", "Perform ez-button WAN reconnect...");
		
		full_restart_wan();
	}
}

static void 
ez_action_shutdown(void)
{
	logmessage("watchdog", "Perform ez-button shutdown...");
	
	notify_rc("shutdown_prepare");
}

static void 
ez_action_user_script(int script_param)
{
	char* opt_user_script = "/opt/bin/on_wps.sh";
	
	if (check_if_file_exist(opt_user_script))
	{
		logmessage("watchdog", "Perform ez-button script: %s %d", opt_user_script, script_param);
		
		doSystem("%s %d &", opt_user_script, script_param);
	}
}

#if defined(LED_ALL)
 #define LED_FULL_OFF 4
#else
 #define LED_FULL_OFF 2
#endif

static void 
ez_action_led_toggle(void)
{
	int i_front_leds = nvram_get_int("front_leds");
	if (i_front_leds != LED_FULL_OFF)
		i_front_leds = LED_FULL_OFF;
	else
		i_front_leds = 0;
	nvram_set_int("front_leds", i_front_leds);
	system("killall -SIGALRM detect_link");
}

void 
ez_event_short(void)
{
	int ez_action = nvram_get_int("ez_action_short");
	
	alarmtimer(NORMAL_PERIOD, 0);
	LED_CONTROL(LED_POWER, LED_ON);
	
	switch (ez_action)
	{
	case 1: // WiFi radio ON/OFF trigger
		ez_action_toggle_wifi24();
		ez_action_toggle_wifi5();
		break;
	case 2: // WiFi 2.4GHz force ON/OFF trigger
		ez_action_force_toggle_wifi24();
		break;
	case 3: // WiFi 5GHz force ON/OFF trigger
		ez_action_force_toggle_wifi5();
		break;
	case 4: // WiFi 2.4 and 5GHz force ON/OFF trigger
		ez_action_force_toggle_wifi24();
		ez_action_force_toggle_wifi5();
		break;
	case 5: // Safe removal all USB
		ez_action_usb_saferemoval();
		break;
	case 6: // WAN down
		ez_action_wan_down();
		break;
	case 7: // WAN reconnect
		ez_action_wan_reconnect();
		break;
	case 8: // WAN up/down toggle
		ez_action_wan_toggle();
		break;
	case 9: // Run user script (/opt/bin/on_wps.sh 1)
		ez_action_user_script(1);
		break;
	case 10: // Front LED toggle
		ez_action_led_toggle();
		break;
	}
}

void 
ez_event_long(void)
{
	int ez_action = nvram_get_int("ez_action_long");
	switch (ez_action)
	{
	case 7:
	case 8:
		alarmtimer(0, 0);
		LED_CONTROL(LED_POWER, LED_OFF);
		break;
	default:
		alarmtimer(NORMAL_PERIOD, 0);
		LED_CONTROL(LED_POWER, LED_ON);
		break;
	}
	
	switch (ez_action)
	{
	case 1: // WiFi 2.4GHz force ON/OFF trigger
		ez_action_force_toggle_wifi24();
		break;
	case 2: // WiFi 5GHz force ON/OFF trigger
		ez_action_force_toggle_wifi5();
		break;
	case 3: // WiFi 2.4 and 5GHz force ON/OFF trigger
		ez_action_force_toggle_wifi24();
		ez_action_force_toggle_wifi5();
		break;
	case 4: // Safe removal all USB
		ez_action_usb_saferemoval();
		break;
	case 5: // WAN down
		ez_action_wan_down();
		break;
	case 6: // WAN reconnect
		ez_action_wan_reconnect();
		break;
	case 7: // Router reboot
		sys_exit();
		break;
	case 8: // Router shutdown prepare
		ez_action_shutdown();
		break;
	case 9: // WAN up/down toggle
		ez_action_wan_toggle();
		break;
	case 10: // Run user script (/opt/bin/on_wps.sh 2)
		ez_action_user_script(2);
		break;
	case 11: // Front LED toggle
		ez_action_led_toggle();
		break;
	}
}

/* Sometimes, httpd becomes inaccessible, try to re-run it */
static void httpd_processcheck(void)
{
	int httpd_is_missing = !pids("httpd");

	if (httpd_is_missing 
#ifdef HTTPD_CHECK
	    || !httpd_check_v2()
#endif
	)
	{
		printf("## restart httpd ##\n");
		stop_httpd();
#ifdef HTTPD_CHECK
		system("killall -9 httpd");
		sleep(1);
		remove(DETECT_HTTPD_FILE);
#endif
		start_httpd(0);
	}
}

int start_watchdog(void)
{
	return eval("/sbin/watchdog");
}

void notify_watchdog_time(void)
{
	doSystem("killall %s %s", "-SIGHUP", "watchdog");
}

void notify_watchdog_nmap(void)
{
	doSystem("killall %s %s", "-SIGUSR2", "watchdog");
}

static void catch_sig(int sig)
{
	if (sig == SIGTERM)
	{
		alarmtimer(0, 0);
		remove("/var/run/watchdog.pid");
		exit(0);
	}
	else if (sig == SIGHUP)
	{
		setenv_tz();
		ntpc_timer = -1; // want call now
	}
	else if (sig == SIGUSR1)
	{
	}
	else if (sig == SIGUSR2)
	{
		nmap_timer = 1;
	}
}

/* wathchdog is runned in NORMAL_PERIOD, 1 seconds
 * check in each NORMAL_PERIOD
 *	1. button
 *
 * check in each NORAML_PERIOD*10
 *
 *      1. ntptime 
 *      2. time-dependent service
 *      3. http-process
 */
static void watchdog(int sig)
{
	/* handle button */
	btn_check_reset();
	btn_check_ez();

	/* if timer is set to less than 1 sec, then bypass the following */
	if (itv.it_value.tv_sec == 0) return;

	if (nvram_match("reboot", "1")) return;

	// watchdog interval = 10s
	watchdog_period = (watchdog_period + 1) % 10;
	if (watchdog_period) return;

	/* check for time-dependent services */
	svc_timecheck();

	/* http server check */
	httpd_processcheck();

	nmap_handler();
	inet_handler();
}

int 
watchdog_main(int argc, char *argv[])
{
	FILE *fp;
	sigset_t sigs_to_catch;

	/* set the signal handler */
	sigemptyset(&sigs_to_catch);
	sigaddset(&sigs_to_catch, SIGHUP);
	sigaddset(&sigs_to_catch, SIGTERM);
	sigaddset(&sigs_to_catch, SIGUSR1);
	sigaddset(&sigs_to_catch, SIGUSR2);
	sigaddset(&sigs_to_catch, SIGALRM);
	sigprocmask(SIG_UNBLOCK, &sigs_to_catch, NULL);

	signal(SIGHUP,  catch_sig);
	signal(SIGTERM, catch_sig);
	signal(SIGUSR1, catch_sig);
	signal(SIGUSR2, catch_sig);
	signal(SIGALRM, watchdog);

	if (daemon(0, 0) < 0) {
		perror("daemon");
		exit(errno);
	}

	/* write pid */
	if ((fp = fopen("/var/run/watchdog.pid", "w")) != NULL)
	{
		fprintf(fp, "%d", getpid());
		fclose(fp);
	}

	/* set timer */
	alarmtimer(NORMAL_PERIOD, 0);

	/* Most of time it goes to sleep */
	while (1)
	{
		pause();
	}

	return 0;
}

