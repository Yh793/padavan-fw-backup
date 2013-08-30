<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">

<title>ASUS Wireless Router <#Web_Title#> - 2.4G <#menu5_1_2#></title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/wireless_2g.js"></script>
<script type="text/javascript" src="/help_2g.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/md5.js"></script>

<script>
    var $j = jQuery.noConflict();

    $j(document).ready(function() {
        $j('#rt_guest_enable_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_guest_enable_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_guest_enable_1").attr("checked", "checked");
                $j("#rt_guest_enable_0").removeAttr("checked");
                change_guest_enabled(1);
            },
            onClickOff: function(){
                $j("#rt_guest_enable_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_guest_enable_0").attr("checked", "checked");
                $j("#rt_guest_enable_1").removeAttr("checked");
                change_guest_enabled(1);
            }
        });
        $j("#rt_guest_enable_on_of label.itoggle").css("background-position", $j("input#rt_guest_enable_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#rt_guest_closed_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_guest_closed_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_guest_closed_1").attr("checked", "checked");
                $j("#rt_guest_closed_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_guest_closed_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_guest_closed_0").attr("checked", "checked");
                $j("#rt_guest_closed_1").removeAttr("checked");
            }
        });
        $j("#rt_guest_closed_on_of label.itoggle").css("background-position", $j("input#rt_guest_closed_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#rt_guest_ap_isolate_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_guest_ap_isolate_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_guest_ap_isolate_1").attr("checked", "checked");
                $j("#rt_guest_ap_isolate_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_guest_ap_isolate_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_guest_ap_isolate_0").attr("checked", "checked");
                $j("#rt_guest_ap_isolate_1").removeAttr("checked");
            }
        });
        $j("#rt_guest_ap_isolate_on_of label.itoggle").css("background-position", $j("input#rt_guest_ap_isolate_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#rt_guest_lan_isolate_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_guest_lan_isolate_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_guest_lan_isolate_1").attr("checked", "checked");
                $j("#rt_guest_lan_isolate_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_guest_lan_isolate_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_guest_lan_isolate_0").attr("checked", "checked");
                $j("#rt_guest_lan_isolate_1").removeAttr("checked");
            }
        });
        $j("#rt_guest_lan_isolate_on_of label.itoggle").css("background-position", $j("input#rt_guest_lan_isolate_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#rt_guest_macrule_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_guest_macrule_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_guest_macrule_1").attr("checked", "checked");
                $j("#rt_guest_macrule_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_guest_macrule_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_guest_macrule_0").attr("checked", "checked");
                $j("#rt_guest_macrule_1").removeAttr("checked");
            }
        });
        $j("#rt_guest_macrule_on_of label.itoggle").css("background-position", $j("input#rt_guest_macrule_fake:checked").length > 0 ? '0% -27px' : '100% -27px');
    });
</script>

<script>

<% login_state_hook(); %>

function initial(){
	show_banner(1);
	show_menu(5,1,2);
	show_footer();
	
	document.form.rt_guest_date_x_Sun.checked = getDateCheck(document.form.rt_guest_date_x.value, 0);
	document.form.rt_guest_date_x_Mon.checked = getDateCheck(document.form.rt_guest_date_x.value, 1);
	document.form.rt_guest_date_x_Tue.checked = getDateCheck(document.form.rt_guest_date_x.value, 2);
	document.form.rt_guest_date_x_Wed.checked = getDateCheck(document.form.rt_guest_date_x.value, 3);
	document.form.rt_guest_date_x_Thu.checked = getDateCheck(document.form.rt_guest_date_x.value, 4);
	document.form.rt_guest_date_x_Fri.checked = getDateCheck(document.form.rt_guest_date_x.value, 5);
	document.form.rt_guest_date_x_Sat.checked = getDateCheck(document.form.rt_guest_date_x.value, 6);
	document.form.rt_guest_time_x_starthour.value = getTimeRange(document.form.rt_guest_time_x.value, 0);
	document.form.rt_guest_time_x_startmin.value = getTimeRange(document.form.rt_guest_time_x.value, 1);
	document.form.rt_guest_time_x_endhour.value = getTimeRange(document.form.rt_guest_time_x.value, 2);
	document.form.rt_guest_time_x_endmin.value = getTimeRange(document.form.rt_guest_time_x.value, 3);
	document.form.rt_guest_time2_x_starthour.value = getTimeRange(document.form.rt_guest_time2_x.value, 0);
	document.form.rt_guest_time2_x_startmin.value = getTimeRange(document.form.rt_guest_time2_x.value, 1);
	document.form.rt_guest_time2_x_endhour.value = getTimeRange(document.form.rt_guest_time2_x.value, 2);
	document.form.rt_guest_time2_x_endmin.value = getTimeRange(document.form.rt_guest_time2_x.value, 3);
	
	document.form.rt_guest_ssid.value = decodeURIComponent(document.form.rt_guest_ssid_org.value);
	document.form.rt_guest_wpa_psk.value = decodeURIComponent(document.form.rt_guest_wpa_psk_org.value);
	
	load_body();
	
	change_guest_enabled(0);
	change_guest_auth_mode(0);
}

function applyRule(){
	if(validForm()){
		document.form.rt_guest_date_x.value = setDateCheck(
		    document.form.rt_guest_date_x_Sun,
		    document.form.rt_guest_date_x_Mon,
		    document.form.rt_guest_date_x_Tue,
		    document.form.rt_guest_date_x_Wed,
		    document.form.rt_guest_date_x_Thu,
		    document.form.rt_guest_date_x_Fri,
		    document.form.rt_guest_date_x_Sat);
		document.form.rt_guest_time_x.value = setTimeRange(
		    document.form.rt_guest_time_x_starthour,
		    document.form.rt_guest_time_x_startmin,
		    document.form.rt_guest_time_x_endhour,
		    document.form.rt_guest_time_x_endmin);
		document.form.rt_guest_time2_x.value = setTimeRange(
		    document.form.rt_guest_time2_x_starthour,
		    document.form.rt_guest_time2_x_startmin,
		    document.form.rt_guest_time2_x_endhour,
		    document.form.rt_guest_time2_x_endmin);
		
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_WGuest2g_Content.asp";
		document.form.next_page.value = "";
		document.form.submit();
	}
}

function validForm(){
	var a = rcheck(document.form.rt_guest_enable);
	var mode = document.form.rt_guest_auth_mode.value;
	
	if (a != "0")
	{
		if(!validate_string_ssid(document.form.rt_guest_ssid))
			return false;
		
		if(!validate_timerange(document.form.rt_guest_time_x_starthour, 0)
				|| !validate_timerange(document.form.rt_guest_time_x_startmin, 1)
				|| !validate_timerange(document.form.rt_guest_time_x_endhour, 2)
				|| !validate_timerange(document.form.rt_guest_time_x_endmin, 3)
				)
			return false;
		
		var starttime = eval(document.form.rt_guest_time_x_starthour.value + document.form.rt_guest_time_x_startmin.value);
		var endtime = eval(document.form.rt_guest_time_x_endhour.value + document.form.rt_guest_time_x_endmin.value);
		if(starttime == endtime){
			alert("<#FirewallConfig_URLActiveTime_itemhint2#>");
				document.form.rt_guest_time_x_starthour.focus();
				document.form.rt_guest_time_x_starthour.select;
			return false;
		}
		
		if(!validate_timerange(document.form.rt_guest_time2_x_starthour, 0)
				|| !validate_timerange(document.form.rt_guest_time2_x_startmin, 1)
				|| !validate_timerange(document.form.rt_guest_time2_x_endhour, 2)
				|| !validate_timerange(document.form.rt_guest_time2_x_endmin, 3)
				)
			return false;
		
		var starttime2 = eval(document.form.rt_guest_time2_x_starthour.value + document.form.rt_guest_time2_x_startmin.value);
		var endtime2 = eval(document.form.rt_guest_time2_x_endhour.value + document.form.rt_guest_time2_x_endmin.value);
		if(starttime2 == endtime2){
			alert("<#FirewallConfig_URLActiveTime_itemhint2#>");
				document.form.rt_guest_time2_x_starthour.focus();
				document.form.rt_guest_time2_x_starthour.select;
			return false;
		}
		
		if(document.form.rt_guest_ssid.value == "") {
			document.form.rt_guest_ssid.focus();
			return false;
		}
		
		if(mode == "psk"){
			if(!validate_psk(document.form.rt_guest_wpa_psk))
				return false;
		}
	}
	return true;
}

function done_validating(action){
	refreshpage();
}

function change_guest_enabled(mflag) {
	var a = rcheck(document.form.rt_guest_enable);
	
	if (a == "0")
	{
		$("row_guest_1").style.display = "none";
		$("row_guest_2").style.display = "none";
		$("row_guest_3").style.display = "none";
		$("row_guest_4").style.display = "none";
		$("row_guest_5").style.display = "none";
		$("row_guest_6").style.display = "none";
		$("row_guest_lan_iso").style.display = "none";
		$("row_guest_8").style.display = "none";
		$("row_guest_9").style.display = "none";
		$("row_guest_10").style.display = "none";
		$("row_guest_11").style.display = "none";
		$("row_guest_12").style.display = "none";
	}
	else
	{
		$("row_guest_1").style.display = "";
		$("row_guest_2").style.display = "";
		$("row_guest_3").style.display = "";
		$("row_guest_4").style.display = "";
		$("row_guest_5").style.display = "";
		$("row_guest_6").style.display = "";
		if(sw_mode == "3"){
			$("row_guest_lan_iso").style.display = "none";
		}else{
			$("row_guest_lan_iso").style.display = "";
		}
		$("row_guest_8").style.display = "";
		$("row_guest_9").style.display = "";
		$("row_guest_10").style.display = "";
		$("row_guest_11").style.display = "";
		$("row_guest_12").style.display = "";
	}
}

function change_guest_auth_mode(mflag) {
	var mode = document.form.rt_guest_auth_mode.value;
	var opts = document.form.rt_guest_auth_mode.options;
	
	if (mode == "psk")
	{
		inputCtrl(document.form.rt_guest_crypto, 1);
		inputCtrl(document.form.rt_guest_wpa_psk, 1);
		
		if(opts[opts.selectedIndex].text == "WPA2-Personal")
		{
			if (mflag == 1) {
				document.form.rt_guest_crypto.options[2].selected = 0;
				document.form.rt_guest_crypto.options[0].selected = 0;
				document.form.rt_guest_crypto.options[1].selected = 1;
				document.form.rt_guest_wpa_mode.value = "2";
			}
		}
		else if(opts[opts.selectedIndex].text == "WPA-Personal")
		{
			if (mflag == 1) {
				document.form.rt_guest_crypto.options[2].selected = 0;
				document.form.rt_guest_crypto.options[1].selected = 0;
				document.form.rt_guest_crypto.options[0].selected = 1;
				document.form.rt_guest_wpa_mode.value = "1";
			}
		}
		else
		{
			if (mflag == 1) {
				document.form.rt_guest_crypto.options[1].selected = 0;
				document.form.rt_guest_crypto.options[0].selected = 0;
				document.form.rt_guest_crypto.options[2].selected = 1;
				document.form.rt_guest_wpa_mode.value = "0";
			}
		}
	}
	else
	{
		inputCtrl(document.form.rt_guest_crypto, 0);
		inputCtrl(document.form.rt_guest_wpa_psk, 0);
	}
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
    <div class="container-fluid" style="padding-right: 0px">
        <div class="row-fluid">
            <div class="span3"><center><div id="logo"></div></center></div>
            <div class="span9" >
                <div id="TopBanner"></div>
            </div>
        </div>
    </div>

    <div id="Loading" class="popup_bg"></div>
    <iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" action="/start_apply.htm" target="hidden_frame">

    <input type="hidden" name="current_page" value="Advanced_WGuest2g_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="WLANConfig11b;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="modified" value="0">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="rt_country_code" value="<% nvram_get_x("","rt_country_code"); %>">

    <input type="hidden" name="rt_guest_ssid_org" value="<% nvram_char_to_ascii("WLANConfig11b", "rt_guest_ssid"); %>">
    <input type="hidden" name="rt_guest_wpa_mode" value="<% nvram_get_x("WLANConfig11b","rt_guest_wpa_mode"); %>">
    <input type="hidden" name="rt_guest_wpa_psk_org" value="<% nvram_char_to_ascii("WLANConfig11b", "rt_guest_wpa_psk"); %>">
    <input type="hidden" name="rt_guest_date_x" value="<% nvram_get_x("WLANConfig11b","rt_guest_date_x"); %>">
    <input type="hidden" name="rt_guest_time_x" value="<% nvram_get_x("WLANConfig11b","rt_guest_time_x"); %>">
    <input type="hidden" name="rt_guest_time2_x" value="<% nvram_get_x("WLANConfig11b","rt_guest_time2_x"); %>">

    <div class="container-fluid">
        <div class="row-fluid">
            <div class="span3">
                <!--Sidebar content-->
                <!--=====Beginning of Main Menu=====-->
                <div class="well sidebar-nav side_nav" style="padding: 0px;">
                    <ul id="mainMenu" class="clearfix"></ul>
                    <ul class="clearfix">
                        <li>
                            <div id="subMenu" class="accordion"></div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="span9">
                <!--Body content-->
                <div class="row-fluid">
                    <div class="span12">
                        <div class="box well grad_colour_dark_blue">
                            <h2 class="box_head round_top"><#menu5_1#> - <#menu5_1_2#> (2.4GHz)</h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                          <tr>
                                                <th width="50%" style="border-top: 0 none;"><#WIFIGuestEnable#></th>
                                                <td style="border-top: 0 none;">
                                                    <div class="main_itoggle">
                                                        <div id="rt_guest_enable_on_of">
                                                            <input type="checkbox" id="rt_guest_enable_fake" <% nvram_match_x("WLANConfig11b", "rt_guest_enable", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b", "rt_guest_enable", "0", "value=0"); %>>
                                                        </div>
                                                    </div>

                                                    <div style="position: absolute; margin-left: -10000px;">
                                                        <input type="radio" value="1" id="rt_guest_enable_1" name="rt_guest_enable" class="input" onClick="change_guest_enabled(1);" <% nvram_match_x("WLANConfig11b","rt_guest_enable", "1", "checked"); %>/><#checkbox_Yes#>
                                                        <input type="radio" value="0" id="rt_guest_enable_0" name="rt_guest_enable" class="input" onClick="change_guest_enabled(1);" <% nvram_match_x("WLANConfig11b","rt_guest_enable", "0", "checked"); %>/><#checkbox_No#>
                                                    </div>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_1" style="display:none;">
                                              <th><#WIFIGuestDate#></th>
                                              <td>
                                                  <div class="controls">
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Mon" onChange="return changeDate();"/><#DAY_Mon#></label>
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Tue" onChange="return changeDate();"/><#DAY_Tue#></label>
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Wed" onChange="return changeDate();"/><#DAY_Wed#></label>
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Thu" onChange="return changeDate();"/><#DAY_Thu#></label>
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Fri" onChange="return changeDate();"/><#DAY_Fri#></label>
                                                  </div>
                                              </td>
                                          </tr>
                                          <tr id="row_guest_2" style="display:none;">
                                              <th style="border-top: 0 none;"><#WIFIGuestTime#></th>
                                              <td style="border-top: 0 none;">
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time_x_starthour" onKeyPress="return is_number(this)">:
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time_x_startmin" onKeyPress="return is_number(this)">&nbsp;-&nbsp;
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time_x_endhour" onKeyPress="return is_number(this)">:
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time_x_endmin" onKeyPress="return is_number(this)">
                                              </td>
                                          </tr>
                                          <tr id="row_guest_3" style="display:none;">
                                              <th><#WIFIGuestDate2#></th>
                                              <td>
                                                  <div class="controls">
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Sat" onChange="return changeDate();"/><#DAY_Sat#></label>
                                                      <label class="checkbox inline"><input type="checkbox" class="input" name="rt_guest_date_x_Sun" onChange="return changeDate();"/><#DAY_Sun#></label>
                                                  </div>
                                              </td>
                                          </tr>
                                          <tr id="row_guest_4" style="display:none;">
                                              <th style="border-top: 0 none;"><#WIFIGuestTime2#></th>
                                              <td style="border-top: 0 none;">
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time2_x_starthour" onKeyPress="return is_number(this)">:
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time2_x_startmin" onKeyPress="return is_number(this)">&nbsp;-&nbsp;
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time2_x_endhour" onKeyPress="return is_number(this)">:
                                                  <input type="text" maxlength="2" style="width: 20px;" size="2" name="rt_guest_time2_x_endmin" onKeyPress="return is_number(this)">
                                              </td>
                                          </tr>
                                          <tr id="row_guest_5" style="display:none;">
                                                <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 0, 1);"><#WIFIGuestSSID#></a></th>
                                                <td><input type="text" maxlength="32" class="input" size="32" name="rt_guest_ssid" value="" onkeypress="return is_string(this)"/></td>
                                          </tr>
                                          <tr id="row_guest_6" style="display:none;">
                                                <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 0, 2);"><#WLANConfig11b_x_BlockBCSSID_itemname#></a></th>
                                                <td>
                                                    <div class="main_itoggle">
                                                        <div id="rt_guest_closed_on_of">
                                                            <input type="checkbox" id="rt_guest_closed_fake" <% nvram_match_x("WLANConfig11b", "rt_guest_closed", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b", "rt_guest_closed", "0", "value=0"); %>>
                                                        </div>
                                                    </div>

                                                    <div style="position: absolute; margin-left: -10000px;">
                                                        <input type="radio" value="1" id="rt_guest_closed_1" name="rt_guest_closed" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_closed", "1", "checked"); %>/><#checkbox_Yes#>
                                                        <input type="radio" value="0" id="rt_guest_closed_0" name="rt_guest_closed" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_closed", "0", "checked"); %>/><#checkbox_No#>
                                                    </div>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_lan_iso" style="display:none;">
                                                <th><#WIFIGuestIsoLAN#></th>
                                                <td>
                                                    <div class="main_itoggle">
                                                        <div id="rt_guest_lan_isolate_on_of">
                                                            <input type="checkbox" id="rt_guest_lan_isolate_fake" <% nvram_match_x("WLANConfig11b", "rt_guest_lan_isolate", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b", "rt_guest_lan_isolate", "0", "value=0"); %>>
                                                        </div>
                                                    </div>

                                                    <div style="position: absolute; margin-left: -10000px;">
                                                        <input type="radio" value="1" id="rt_guest_lan_isolate_1" name="rt_guest_lan_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_lan_isolate", "1", "checked"); %>/><#checkbox_Yes#>
                                                        <input type="radio" value="0" id="rt_guest_lan_isolate_0" name="rt_guest_lan_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_lan_isolate", "0", "checked"); %>/><#checkbox_No#>
                                                    </div>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_8" style="display:none;">
                                                <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 5);"><#WLANConfig11b_x_IsolateAP_itemname#></a></th>
                                                <td>
                                                    <div class="main_itoggle">
                                                        <div id="rt_guest_ap_isolate_on_of">
                                                            <input type="checkbox" id="rt_guest_ap_isolate_fake" <% nvram_match_x("WLANConfig11b", "rt_guest_ap_isolate", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b", "rt_guest_ap_isolate", "0", "value=0"); %>>
                                                        </div>
                                                    </div>

                                                    <div style="position: absolute; margin-left: -10000px;">
                                                        <input type="radio" value="1" id="rt_guest_ap_isolate_1" name="rt_guest_ap_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_ap_isolate", "1", "checked"); %>/><#checkbox_Yes#>
                                                        <input type="radio" value="0" id="rt_guest_ap_isolate_0" name="rt_guest_ap_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_ap_isolate", "0", "checked"); %>/><#checkbox_No#>
                                                    </div>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_9" style="display:none;">
                                                <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 0, 5);"><#WLANConfig11b_AuthenticationMethod_itemname#></a></th>
                                                <td>
                                                  <select name="rt_guest_auth_mode" class="input" onChange="change_guest_auth_mode(1);">
                                                    <option value="open" <% nvram_match_x("WLANConfig11b", "rt_guest_auth_mode", "open", "selected"); %>>Open System</option>
                                                    <option value="psk" <% nvram_double_match_x("WLANConfig11b", "rt_guest_auth_mode", "psk", "WLANConfig11b", "rt_guest_wpa_mode", "1", "selected"); %>>WPA-Personal</option>
                                                    <option value="psk" <% nvram_double_match_x("WLANConfig11b", "rt_guest_auth_mode", "psk", "WLANConfig11b", "rt_guest_wpa_mode", "2", "selected"); %>>WPA2-Personal</option>
                                                    <option value="psk" <% nvram_double_match_x("WLANConfig11b", "rt_guest_auth_mode", "psk", "WLANConfig11b", "rt_guest_wpa_mode", "0", "selected"); %>>WPA-Auto-Personal</option>
                                                  </select>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_10" style="display:none;">
                                                <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 0, 6);"><#WLANConfig11b_WPAType_itemname#></a></th>
                                                <td>
                                                  <select name="rt_guest_crypto" class="input">
                                                    <option value="tkip" <% nvram_match_x("WLANConfig11b", "rt_guest_crypto", "tkip", "selected"); %>>TKIP</option>
                                                    <option value="aes" <% nvram_match_x("WLANConfig11b", "rt_guest_crypto", "aes", "selected"); %>>AES</option>
                                                    <option value="tkip+aes" <% nvram_match_x("WLANConfig11b", "rt_guest_crypto", "tkip+aes", "selected"); %>>TKIP+AES</option>
                                                  </select>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_11" style="display:none;">
                                                <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 0, 7);"><#WLANConfig11b_x_PSKKey_itemname#></a></th>
                                                <td>
                                                    <div class="input-append">
                                                        <input type="password" name="rt_guest_wpa_psk" id="rt_guest_wpa_psk" maxlength="64" size="32" value="" style="width: 175px;">
                                                        <button style="margin-left: -5px;" class="btn" type="button" onclick="passwordShowHide('rt_guest_wpa_psk')"><i class="icon-eye-close"></i></button>
                                                    </div>
                                                </td>
                                          </tr>
                                          <tr id="row_guest_12" style="display:none;">
                                                <th><#WIFIGuestMAC#></th>
                                                <td>
                                                    <div class="main_itoggle">
                                                        <div id="rt_guest_macrule_on_of">
                                                            <input type="checkbox" id="rt_guest_macrule_fake" <% nvram_match_x("WLANConfig11b", "rt_guest_macrule", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b", "rt_guest_macrule", "0", "value=0"); %>>
                                                        </div>
                                                    </div>

                                                    <div style="position: absolute; margin-left: -10000px;">
                                                        <input type="radio" value="1" id="rt_guest_macrule_1" name="rt_guest_macrule" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_macrule", "1", "checked"); %>/><#checkbox_Yes#>
                                                        <input type="radio" value="0" id="rt_guest_macrule_0" name="rt_guest_macrule" class="input" <% nvram_match_x("WLANConfig11b","rt_guest_macrule", "0", "checked"); %>/><#checkbox_No#>
                                                    </div>
                                                </td>
                                          </tr>
                                    </table>

                                    <table width="100%" style="margin: 8px 8px 10px 0px;">
                                        <tr>
                                            <td width="50%">
                                                <input type="button" class="btn btn-info" style="margin-left: 5px;" value="<#GO_5G#>" onclick="location.href='Advanced_WGuest_Content.asp';">
                                            </td>
                                            <td align="left">
                                                <input type="button" id="applyButton" class="btn btn-primary" style="margin-left: 8px; width: 219px" value="<#CTL_apply#>" onclick="applyRule();">
                                            </td>
                                        </tr>
                                    </table>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </form>

    <div id="footer"></div>
</div>
</body>
</html>
