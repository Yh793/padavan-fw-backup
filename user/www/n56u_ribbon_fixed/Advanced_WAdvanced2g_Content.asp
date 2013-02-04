﻿<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>ASUS Wireless Router <#Web_Title#> - <#menu5_1_6#></title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general_2g.js"></script>
<script type="text/javascript" src="/help_2g.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/detect.js"></script>

<script>
    var $j = jQuery.noConflict();
    $j(document).ready(function() {
        $j('#rt_ap_isolate_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_ap_isolate_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_ap_isolate_1").attr("checked", "checked");
                $j("#rt_ap_isolate_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_ap_isolate_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_ap_isolate_0").attr("checked", "checked");
                $j("#rt_ap_isolate_1").removeAttr("checked");
            }
        });
        $j("#rt_ap_isolate_on_of label.itoggle").css("background-position", $j("input#rt_ap_isolate_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#rt_mbssid_isolate_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_mbssid_isolate_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_mbssid_isolate_1").attr("checked", "checked");
                $j("#rt_mbssid_isolate_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_mbssid_isolate_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_mbssid_isolate_0").attr("checked", "checked");
                $j("#rt_mbssid_isolate_1").removeAttr("checked");
            }
        });
        $j("#rt_mbssid_isolate_on_of label.itoggle").css("background-position", $j("input#rt_mbssid_isolate_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#rt_IgmpSnEnable_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#rt_IgmpSnEnable_fake").attr("checked", "checked").attr("value", 1);
                $j("#rt_IgmpSnEnable_1").attr("checked", "checked");
                $j("#rt_IgmpSnEnable_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#rt_IgmpSnEnable_fake").removeAttr("checked").attr("value", 0);
                $j("#rt_IgmpSnEnable_0").attr("checked", "checked");
                $j("#rt_IgmpSnEnable_1").removeAttr("checked");
            }
        });
        $j("#rt_IgmpSnEnable_on_of label.itoggle").css("background-position", $j("input#rt_IgmpSnEnable_fake:checked").length > 0 ? '0% -27px' : '100% -27px');
    });
</script>

<script>

<% login_state_hook(); %>

function initial(){

	show_banner(1);
	
	show_menu(5,1,6);
	
	show_footer();
	
	enable_auto_hint(3, 20);
	
	load_body();
	
	change_wmm();
}

function change_wmm() {
	var gmode = document.form.rt_gmode.value;
	if (document.form.rt_wme.value == "0") {
		$("row_wme_no_ack").style.display = "none";
		$("row_apsd_cap").style.display = "none";
		$("row_dls_cap").style.display = "none";
	}
	else {
		if (gmode == "5" || gmode == "3" || gmode == "2") { // G/N, N, B/G/N
			$("row_wme_no_ack").style.display = "none";
		} else {
			$("row_wme_no_ack").style.display = "";
		}
		$("row_apsd_cap").style.display = "";
		if (gmode == "4" || gmode == "1" || gmode == "0") { // B or G or B/G
			$("row_dls_cap").style.display = "none";
		} else {
			$("row_dls_cap").style.display = "";
		}
	}
	if(gmode == "3") { // N only
		$("row_greenfield").style.display = "";
	}else{
		$("row_greenfield").style.display = "none";
	}
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_WAdvanced2g_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	if(!validate_range(document.form.rt_frag, 256, 2346)
		|| !validate_range(document.form.rt_rts, 0, 2347)
		|| !validate_range(document.form.rt_dtim, 1, 255)
		|| !validate_range(document.form.rt_bcn, 20, 1000))
		return false;

	return true;
}

function done_validating(action){
    refreshpage();
}

</script>
</head>

<body onload="initial();" onunLoad="disable_auto_hint(3, 16);return unload_body();">

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

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="productid" value="<% nvram_get_f("general.log","productid"); %>">
    <input type="hidden" name="current_page" value="Advanced_WAdvanced2g_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="WLANAuthentication11b;WLANConfig11b;LANHostConfig;PrinterStatus;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="modified" value="0">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="first_time" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("LANGUAGE", "preferred_lang"); %>">
    <input type="hidden" name="firmver" value="<% nvram_get_x("",  "firmver"); %>">

    <input type="hidden" name="rt_gmode" value="<% nvram_get_x("WLANConfig11b","rt_gmode"); %>">

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
                            <h2 class="box_head round_top"><#menu5_1#> - <#menu5_1_6#> (2.4GHz)</h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#WLANConfig11b_display5_sectiondesc#></div>

                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th width="50%"><#WIFIStreamTX#></th>
                                            <td>
                                                <select name="rt_stream_tx" class="input">
                                                    <option value="1" <% nvram_match_x("WLANConfig11b", "rt_stream_tx", "1", "selected"); %>>1T (150Mbps)</option>
                                                    <option value="2" <% nvram_match_x("WLANConfig11b", "rt_stream_tx", "2", "selected"); %>>2T (300Mbps)</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#WIFIStreamRX#></th>
                                            <td>
                                                <select name="rt_stream_rx" class="input">
                                                    <option value="1" <% nvram_match_x("WLANConfig11b", "rt_stream_rx", "1", "selected"); %>>1R (150Mbps)</option>
                                                    <option value="2" <% nvram_match_x("WLANConfig11b", "rt_stream_rx", "2", "selected"); %>>2R (300Mbps)</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 5);"><#WLANConfig11b_x_IsolateAP_itemname#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="rt_ap_isolate_on_of">
                                                        <input type="checkbox" id="rt_ap_isolate_fake" <% nvram_match_x("WLANConfig11b","rt_ap_isolate", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b","rt_ap_isolate", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" id="rt_ap_isolate_1" name="rt_ap_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_ap_isolate", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" id="rt_ap_isolate_0" name="rt_ap_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_ap_isolate", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 5);"><#WIFIGuestIsolate#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="rt_mbssid_isolate_on_of">
                                                        <input type="checkbox" id="rt_mbssid_isolate_fake" <% nvram_match_x("WLANConfig11b","rt_mbssid_isolate", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b","rt_mbssid_isolate", "0", "value=0"); %>>
                                                    </div>
                                                    <div style="position: absolute; margin-left: -10000px;">
                                                        <input type="radio" value="1" id="rt_mbssid_isolate_1" name="rt_mbssid_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_mbssid_isolate", "1", "checked"); %>/><#checkbox_Yes#>
                                                        <input type="radio" value="0" id="rt_mbssid_isolate_0" name="rt_mbssid_isolate" class="input" <% nvram_match_x("WLANConfig11b","rt_mbssid_isolate", "0", "checked"); %>/><#checkbox_No#>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#SwitchIgmp#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="rt_IgmpSnEnable_on_of">
                                                        <input type="checkbox" id="rt_IgmpSnEnable_fake" <% nvram_match_x("WLANConfig11b", "rt_IgmpSnEnable", "1", "value=1 checked"); %><% nvram_match_x("WLANConfig11b", "rt_IgmpSnEnable", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="rt_IgmpSnEnable" id="rt_IgmpSnEnable_1" class="input" <% nvram_match_x("WLANConfig11b", "rt_IgmpSnEnable", "1", "checked"); %>><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="rt_IgmpSnEnable" id="rt_IgmpSnEnable_0" class="input" <% nvram_match_x("WLANConfig11b", "rt_IgmpSnEnable", "0", "checked"); %>><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 7);"><#WLANConfig11b_MultiRateAll_itemname#></a></th>
                                            <td>
                                                <select name="rt_mcastrate" class="input">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "0", "selected"); %>>HTMIX (1S) 15 Mbps</option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "1", "selected"); %>>HTMIX (1S) 30 Mbps</option>
                                                    <option value="2" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "2", "selected"); %>>HTMIX (1S) 45 Mbps</option>
                                                    <option value="3" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "3", "selected"); %>>HTMIX (2S) 30 Mbps</option>
                                                    <option value="4" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "4", "selected"); %>>HTMIX (2S) 60 Mbps</option>
                                                    <option value="5" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "5", "selected"); %>>OFDM 9 Mbps</option>
                                                    <option value="6" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "6", "selected"); %>>OFDM 12 Mbps (*)</option>
                                                    <option value="7" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "7", "selected"); %>>OFDM 18 Mbps</option>
                                                    <option value="8" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "8", "selected"); %>>OFDM 24 Mbps</option>
                                                    <option value="9" <% nvram_match_x("WLANConfig11b", "rt_mcastrate", "9", "selected"); %>>CCK 11 Mbps</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 8);"><#WLANConfig11b_DataRate_itemname#></a></th>
                                            <td>
                                                <select name="rt_rateset" class="input" onChange="return change_common(this, 'WLANConfig11b', 'rt_rateset')">
                                                    <option value="default" <% nvram_match_x("WLANConfig11b","rt_rateset", "default","selected"); %>>Default</option>
                                                    <option value="all" <% nvram_match_x("WLANConfig11b","rt_rateset", "all","selected"); %>>All</option>
                                                    <option value="12" <% nvram_match_x("WLANConfig11b","rt_rateset", "12","selected"); %>>1, 2 Mbps</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 4);"><#WLANConfig11n_PremblesType_itemname#></a></th>
                                            <td>
                                                <select name="rt_preamble" class="input">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b","rt_preamble", "0","selected"); %>>Long</option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b","rt_preamble", "1","selected"); %>>Short</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 9);"><#WLANConfig11b_x_Frag_itemname#></a></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="rt_frag" class="input" value="<% nvram_get_x("WLANConfig11b", "rt_frag"); %>" onKeyPress="return is_number(this)" onChange="page_changed()" onBlur="validate_range(this, 256, 2346)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 10);"><#WLANConfig11b_x_RTS_itemname#></a></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="rt_rts" class="input" value="<% nvram_get_x("WLANConfig11b", "rt_rts"); %>" onKeyPress="return is_number(this)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip"  href="javascript:void(0);" onmouseover="openTooltip(this, 3, 11);"><#WLANConfig11b_x_DTIM_itemname#></a></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="rt_dtim" class="input" value="<% nvram_get_x("WLANConfig11b", "rt_dtim"); %>" onKeyPress="return is_number(this)"  onBlur="validate_range(this, 1, 255)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 12);"><#WLANConfig11b_x_Beacon_itemname#></a></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="rt_bcn" class="input" value="<% nvram_get_x("WLANConfig11b", "rt_bcn"); %>" onKeyPress="return is_number(this)" onBlur="validate_range(this, 20, 1000)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 13);"><#WLANConfig11b_x_TxBurst_itemname#></a></th>
                                            <td>
                                                <select name="rt_TxBurst" class="input" onChange="return change_common(this, 'WLANConfig11b', 'rt_TxBurst')">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b","rt_TxBurst", "0","selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b","rt_TxBurst", "1","selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 16);"><#WLANConfig11b_x_PktAggregate_itemname#></a></th>
                                            <td>
                                                <select name="rt_PktAggregate" class="input" onChange="return change_common(this, 'WLANConfig11b', 'rt_PktAggregate')">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b","rt_PktAggregate", "0","selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b","rt_PktAggregate", "1","selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#WIFIRDG#></th>
                                            <td>
                                                <select name="rt_HT_RDG" class="input">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b","rt_HT_RDG", "0","selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b","rt_HT_RDG", "1","selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="row_greenfield">
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 19);"><#WLANConfig11b_x_HT_OpMode_itemname#></a></th>
                                            <td>
                                                <select class="input" id="rt_HT_OpMode" name="rt_HT_OpMode" onChange="return change_common(this, 'WLANConfig11b', 'rt_HT_OpMode')">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b","rt_HT_OpMode", "0","selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b","rt_HT_OpMode", "1","selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                          <th><a class="help_tooltip"  href="javascript:void(0);" onmouseover="openTooltip(this, 3, 14);"><#WLANConfig11b_x_WMM_itemname#></a></th>
                                          <td>
                                            <select name="rt_wme" id="rt_wme" class="input" onChange="change_wmm();">
                                              <option value="0" <% nvram_match_x("WLANConfig11b", "rt_wme", "0", "selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                              <option value="1" <% nvram_match_x("WLANConfig11b", "rt_wme", "1", "selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr id="row_wme_no_ack">
                                          <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 15);"><#WLANConfig11b_x_NOACK_itemname#></a></th>
                                          <td>
                                            <select name="rt_wme_no_ack" id="rt_wme_no_ack" class="input" onChange="return change_common(this, 'WLANConfig11b', 'rt_wme_no_ack')">
                                              <option value="off" <% nvram_match_x("WLANConfig11b","rt_wme_no_ack", "off","selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                              <option value="on" <% nvram_match_x("WLANConfig11b","rt_wme_no_ack", "on","selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr id="row_apsd_cap">
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 17);"><#WLANConfig11b_x_APSD_itemname#></a></th>
                                            <td>
                                              <select name="rt_APSDCapable" class="input" onchange="return change_common(this, 'WLANConfig11b', 'rt_APSDCapable')">
                                                <option value="0" <% nvram_match_x("WLANConfig11b","rt_APSDCapable", "0","selected"); %> ><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                                <option value="1" <% nvram_match_x("WLANConfig11b","rt_APSDCapable", "1","selected"); %> ><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                              </select>
                                            </td>
                                        </tr>
                                        <tr id="row_dls_cap">
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this, 3, 18);"><#WLANConfig11b_x_DLS_itemname#></a></th>
                                            <td>
                                                <select name="rt_DLSCapable" class="input" onChange="return change_common(this, 'WLANConfig11b', 'rt_DLSCapable')">
                                                    <option value="0" <% nvram_match_x("WLANConfig11b","rt_DLSCapable", "0","selected"); %>><#WLANConfig11b_WirelessCtrl_buttonname#></option>
                                                    <option value="1" <% nvram_match_x("WLANConfig11b","rt_DLSCapable", "1","selected"); %>><#WLANConfig11b_WirelessCtrl_button1name#></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="margin-top: 10px;">
                                                <br />
                                                <input class="btn btn-info" type="button"  value="<#GO_5G#>" onclick="location.href='Advanced_WAdvanced_Content.asp';">
                                            </td>
                                            <td>
                                                <br />
                                                <input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" />
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

    <!--==============Beginning of hint content=============-->
    <div id="help_td" style="position: absolute; margin-left: -10000px" valign="top">
        <form name="hint_form"></form>
        <div id="helpicon" onClick="openHint(0,0);"><img src="images/help.gif" /></div>

        <div id="hintofPM" style="display:none;">
            <table width="100%" cellpadding="0" cellspacing="1" class="Help" bgcolor="#999999">
            <thead>
                <tr>
                    <td>
                        <div id="helpname" class="AiHintTitle"></div>
                        <a href="javascript:;" onclick="closeHint()" ><img src="images/button-close.gif" class="closebutton" /></a>
                    </td>
                </tr>
            </thead>

                <tr>
                    <td valign="top" >
                        <div class="hint_body2" id="hint_body"></div>
                        <iframe id="statusframe" name="statusframe" class="statusframe" src="" frameborder="0"></iframe>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <!--==============Ending of hint content=============-->

    <div id="footer"></div>
</div>
</body>
</html>
