<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>ASUS Wireless Router <#Web_Title#> - <#menu5_5_1#></title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" language="JavaScript" src="/help.js"></script>
<script type="text/javascript" language="JavaScript" src="/detect.js"></script>
<script>
    var $j = jQuery.noConflict();

    $j(document).ready(function() {
        $j('#fw_enable_x_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#fw_enable_x_fake").attr("checked", "checked").attr("value", 1);
                $j("#fw_enable_x_1").attr("checked", "checked");
                $j("#fw_enable_x_0").removeAttr("checked");
                change_common_radio(this, 'FirewallConfig', 'fw_enable_x', '1');
            },
            onClickOff: function(){
                $j("#fw_enable_x_fake").removeAttr("checked").attr("value", 0);
                $j("#fw_enable_x_0").attr("checked", "checked");
                $j("#fw_enable_x_1").removeAttr("checked");
                change_common_radio(this, 'FirewallConfig', 'fw_enable_x', '0');
            }
        });
        $j("#fw_enable_x_on_of label.itoggle").css("background-position", $j("input#fw_enable_x_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#fw_dos_x_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                change_common_radio(this, 'FirewallConfig', 'fw_dos_x', '1');
                $j("#fw_dos_x_fake").attr("checked", "checked").attr("value", 1);
                $j("#fw_dos_x_1").attr("checked", "checked");
                $j("#fw_dos_x_0").removeAttr("checked");
            },
            onClickOff: function(){
                change_common_radio(this, 'FirewallConfig', 'fw_dos_x', '0');
                $j("#fw_dos_x_fake").removeAttr("checked").attr("value", 0);
                $j("#fw_dos_x_0").attr("checked", "checked");
                $j("#fw_dos_x_1").removeAttr("checked");
            }
        });
        $j("#fw_dos_x_on_of label.itoggle").css("background-position", $j("input#fw_dos_x_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#fw_syn_cook_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#fw_syn_cook_fake").attr("checked", "checked").attr("value", 1);
                $j("#fw_syn_cook_1").attr("checked", "checked");
                $j("#fw_syn_cook_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#fw_syn_cook_fake").removeAttr("checked").attr("value", 0);
                $j("#fw_syn_cook_0").attr("checked", "checked");
                $j("#fw_syn_cook_1").removeAttr("checked");
            }
        });
        $j("#fw_syn_cook_on_of label.itoggle").css("background-position", $j("input#fw_syn_cook_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#misc_ping_x_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                change_common_radio(this, 'FirewallConfig', 'misc_ping_x', '1');
                $j("#misc_ping_x_fake").attr("checked", "checked").attr("value", 1);
                $j("#misc_ping_x_1").attr("checked", "checked");
                $j("#misc_ping_x_0").removeAttr("checked");
            },
            onClickOff: function(){
                change_common_radio(this, 'FirewallConfig', 'misc_ping_x', '0');
                $j("#misc_ping_x_fake").removeAttr("checked").attr("value", 0);
                $j("#misc_ping_x_0").attr("checked", "checked");
                $j("#misc_ping_x_1").removeAttr("checked");
            }
        });
        $j("#misc_ping_x_on_of label.itoggle").css("background-position", $j("input#misc_ping_x_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#misc_http_x_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                change_common_radio(this, 'FirewallConfig', 'misc_http_x', '1');
                $j("#misc_http_x_fake").attr("checked", "checked").attr("value", 1);
                $j("#misc_http_x_1").attr("checked", "checked");
                $j("#misc_http_x_0").removeAttr("checked");
            },
            onClickOff: function(){
                change_common_radio(this, 'FirewallConfig', 'misc_http_x', '0');
                $j("#misc_http_x_fake").removeAttr("checked").attr("value", 0);
                $j("#misc_http_x_0").attr("checked", "checked");
                $j("#misc_http_x_1").removeAttr("checked");
            }
        });
        $j("#misc_http_x_on_of label.itoggle").css("background-position", $j("input#misc_http_x_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#sshd_wopen_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#sshd_wopen_fake").attr("checked", "checked").attr("value", 1);
                $j("#sshd_wopen_1").attr("checked", "checked");
                $j("#sshd_wopen_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#sshd_wopen_fake").removeAttr("checked").attr("value", 0);
                $j("#sshd_wopen_0").attr("checked", "checked");
                $j("#sshd_wopen_1").removeAttr("checked");
            }
        });
        $j("#sshd_wopen_on_of label.itoggle").css("background-position", $j("input#sshd_wopen_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#ftpd_wopen_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#ftpd_wopen_fake").attr("checked", "checked").attr("value", 1);
                $j("#ftpd_wopen_1").attr("checked", "checked");
                $j("#ftpd_wopen_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#ftpd_wopen_fake").removeAttr("checked").attr("value", 0);
                $j("#ftpd_wopen_0").attr("checked", "checked");
                $j("#ftpd_wopen_1").removeAttr("checked");
            }
        });
        $j("#ftpd_wopen_on_of label.itoggle").css("background-position", $j("input#ftpd_wopen_fake:checked").length > 0 ? '0% -27px' : '100% -27px');

        $j('#trmd_ropen_on_of').iToggle({
            easing: 'linear',
            speed: 70,
            onClickOn: function(){
                $j("#trmd_ropen_fake").attr("checked", "checked").attr("value", 1);
                $j("#trmd_ropen_1").attr("checked", "checked");
                $j("#trmd_ropen_0").removeAttr("checked");
            },
            onClickOff: function(){
                $j("#trmd_ropen_fake").removeAttr("checked").attr("value", 0);
                $j("#trmd_ropen_0").attr("checked", "checked");
                $j("#trmd_ropen_1").removeAttr("checked");
            }
        });
        $j("#trmd_ropen_on_of label.itoggle").css("background-position", $j("input#trmd_ropen_fake:checked").length > 0 ? '0% -27px' : '100% -27px');
    });
</script>

<script>

<% login_state_hook(); %>

<% usb_apps_check(); %>

function initial(){
	show_banner(1);
	show_menu(5,6,1);
	show_footer();
	enable_auto_hint(8, 6);
	
	load_body();
	
	if(found_app_torr() == '1')
		$("row_torrent").style.display = "";
	
	if (sw_mode == "4"){
		$("row_http_wport").style.display = "none";
		$("row_sshd_wport").style.display = "none";
		$("row_ftpd_wport").style.display = "none";
	}
	else{
		$("row_http_wport").style.display = "";
		$("row_sshd_wport").style.display = "";
		$("row_ftpd_wport").style.display = "";
	}
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		inputRCtrl1(document.form.misc_http_x, 1);
		
		if(isModel() != "WL520gc" && isModel() != "SnapAP"){
			inputRCtrl1(document.form.misc_ping_x, 1);
		}
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_BasicFirewall_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	if(!validate_range(document.form.misc_httpport_x, 80, 65535))
		return false;

	if(!validate_range(document.form.sshd_wport, 22, 65535))
		return false;

	if(!validate_range(document.form.ftpd_wport, 21, 65535))
		return false;

	return true;
}

function done_validating(action){
	refreshpage();
}
</script>
<style>
    .nav-tabs > li > a {
          padding-right: 6px;
          padding-left: 6px;
    }
</style>
</head>

<body onload="initial();" onunLoad="disable_auto_hint(8, 6);return unload_body();">

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

    <input type="hidden" name="current_page" value="Advanced_BasicFirewall_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="FirewallConfig;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="modified" value="0">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="first_time" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("LANGUAGE", "preferred_lang"); %>">
    <input type="hidden" name="firmver" value="<% nvram_get_x("",  "firmver"); %>">

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
                            <h2 class="box_head round_top"><#menu5_5#> - <#menu5_5_1#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#FirewallConfig_display2_sectiondesc#></div>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#menu5_5#></th>
                                        </tr>
                                        <tr>
                                            <th width="50%"><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,6);"><#FirewallConfig_FirewallEnable_itemname#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="fw_enable_x_on_of">
                                                        <input type="checkbox" id="fw_enable_x_fake" <% nvram_match_x("FirewallConfig", "fw_enable_x", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "fw_enable_x", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="fw_enable_x" id="fw_enable_x_1" onClick="return change_common_radio(this, 'FirewallConfig', 'fw_enable_x', '1')" <% nvram_match_x("FirewallConfig","fw_enable_x", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="fw_enable_x" id="fw_enable_x_0" onClick="return change_common_radio(this, 'FirewallConfig', 'fw_enable_x', '0')" <% nvram_match_x("FirewallConfig","fw_enable_x", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,7);"><#FirewallConfig_DoSEnable_itemname#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="fw_dos_x_on_of">
                                                        <input type="checkbox" id="fw_dos_x_fake" <% nvram_match_x("FirewallConfig", "fw_dos_x", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "fw_dos_x", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="fw_dos_x" id="fw_dos_x_1" class="input" onClick="return change_common_radio(this, 'FirewallConfig', 'fw_dos_x', '1')" <% nvram_match_x("FirewallConfig", "fw_dos_x", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="fw_dos_x" id="fw_dos_x_0" class="input" onClick="return change_common_radio(this, 'FirewallConfig', 'fw_dos_x', '0')" <% nvram_match_x("FirewallConfig", "fw_dos_x", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,7);"><#FirewallConfigSynFlood#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="fw_syn_cook_on_of">
                                                        <input type="checkbox" id="fw_syn_cook_fake" <% nvram_match_x("FirewallConfig", "fw_syn_cook", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "fw_syn_cook", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="fw_syn_cook" id="fw_syn_cook_1" class="input" <% nvram_match_x("FirewallConfig", "fw_syn_cook", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="fw_syn_cook" id="fw_syn_cook_0" class="input" <% nvram_match_x("FirewallConfig", "fw_syn_cook", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,1);"><#FirewallConfig_WanLanLog_itemname#></a></th>
                                            <td>
                                                <select name="fw_log_x" class="input" onchange="return change_common(this, 'FirewallConfig', 'fw_log_x')">
                                                    <option value="none" <% nvram_match_x("FirewallConfig","fw_log_x", "none","selected"); %>>None</option>
                                                    <option value="drop" <% nvram_match_x("FirewallConfig","fw_log_x", "drop","selected"); %>>Dropped</option>
                                                    <option value="accept" <% nvram_match_x("FirewallConfig","fw_log_x", "accept","selected"); %>>Accepted</option>
                                                    <option value="both" <% nvram_match_x("FirewallConfig","fw_log_x", "both","selected"); %>>Both</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="row_misc_ping">
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,5);"><#FirewallConfig_x_WanPingEnable_itemname#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="misc_ping_x_on_of">
                                                        <input type="checkbox" id="misc_ping_x_fake" <% nvram_match_x("FirewallConfig", "misc_ping_x", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "misc_ping_x", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="misc_ping_x" id="misc_ping_x_1" class="input" onClick="return change_common_radio(this, 'FirewallConfig', 'misc_ping_x', '1')" <% nvram_match_x("FirewallConfig","misc_ping_x", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="misc_ping_x" id="misc_ping_x_0" class="input" onClick="return change_common_radio(this, 'FirewallConfig', 'misc_ping_x', '0')" <% nvram_match_x("FirewallConfig","misc_ping_x", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table" id="access_section">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Adm_Access_WAN#></th>
                                        </tr>
                                        <tr>
                                            <th width="50%"><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,2);"><#FirewallConfig_x_WanWebEnable_itemname#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="misc_http_x_on_of">
                                                        <input type="checkbox" id="misc_http_x_fake" <% nvram_match_x("FirewallConfig", "misc_http_x", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "misc_http_x", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" value="1" name="misc_http_x" id="misc_http_x_1" class="input" onClick="return change_common_radio(this, 'FirewallConfig', 'misc_http_x', '1')" <% nvram_match_x("FirewallConfig","misc_http_x", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" value="0" name="misc_http_x" id="misc_http_x_0" class="input" onClick="return change_common_radio(this, 'FirewallConfig', 'misc_http_x', '0')" <% nvram_match_x("FirewallConfig","misc_http_x", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="row_http_wport">
                                            <th><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,8,3);"><#FirewallConfig_x_WanWebPort_itemname#></a></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="misc_httpport_x" class="input" value="<% nvram_get_x("FirewallConfig", "misc_httpport_x"); %>" onkeypress="return is_number(this)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#Adm_System_sshd_wopen#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="sshd_wopen_on_of">
                                                        <input type="checkbox" id="sshd_wopen_fake" <% nvram_match_x("FirewallConfig", "sshd_wopen", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "sshd_wopen", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="sshd_wopen" id="sshd_wopen_1" class="input" value="1" <% nvram_match_x("FirewallConfig", "sshd_wopen", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="sshd_wopen" id="sshd_wopen_0" class="input" value="0" <% nvram_match_x("FirewallConfig", "sshd_wopen", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="row_sshd_wport">
                                            <th><#Adm_System_sshd_wport#></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="sshd_wport" class="input" value="<% nvram_get_x("FirewallConfig","sshd_wport"); %>" onkeypress="return is_number(this)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#Adm_System_ftpd_wopen#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="ftpd_wopen_on_of">
                                                        <input type="checkbox" id="ftpd_wopen_fake" <% nvram_match_x("FirewallConfig", "ftpd_wopen", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "ftpd_wopen", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="ftpd_wopen" id="ftpd_wopen_1" class="input" value="1" <% nvram_match_x("FirewallConfig", "ftpd_wopen", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="ftpd_wopen" id="ftpd_wopen_0" class="input" value="0" <% nvram_match_x("FirewallConfig", "ftpd_wopen", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="row_ftpd_wport">
                                            <th><#Adm_System_ftpd_wport#></th>
                                            <td>
                                                <input type="text" maxlength="5" size="5" name="ftpd_wport" class="input" value="<% nvram_get_x("FirewallConfig","ftpd_wport"); %>" onkeypress="return is_number(this)"/>
                                            </td>
                                        </tr>
                                        <tr id="row_torrent" style="display:none;">
                                            <th><#Adm_System_trmd_ropen#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="trmd_ropen_on_of">
                                                        <input type="checkbox" id="trmd_ropen_fake" <% nvram_match_x("FirewallConfig", "trmd_ropen", "1", "value=1 checked"); %><% nvram_match_x("FirewallConfig", "trmd_ropen", "0", "value=0"); %>>
                                                    </div>
                                                </div>

                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="trmd_ropen" id="trmd_ropen_1" class="input" value="1" <% nvram_match_x("FirewallConfig", "trmd_ropen", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="trmd_ropen" id="trmd_ropen_0" class="input" value="0" <% nvram_match_x("FirewallConfig", "trmd_ropen", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;"><center><input name="button" type="button" class="btn btn-primary" style="width: 219px" onclick="applyRule();" value="<#CTL_apply#>"/></center></td>
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
