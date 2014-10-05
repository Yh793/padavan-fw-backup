<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - <#menu5_6_5#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('telnetd');
	init_itoggle('wins_enable');
	init_itoggle('lltd_enable');
	init_itoggle('adsc_enable');
	init_itoggle('watchdog_cpu');
});

</script>
<script>

function initial(){
	show_banner(1);
	show_menu(5,7,2);
	show_footer();

	load_body();

	if(!found_app_sshd()){
		showhide_div('row_sshd', 0);
		textarea_sshd_enabled(0);
	}else
		sshd_auth_change();

	if(found_app_nmbd())
		showhide_div('row_wins', 1);

	if(!support_http_ssl()) {
		document.form.http_proto.value = "0";
		showhide_div('row_http_proto', 0);
		showhide_div('row_https_lport', 0);
		showhide_div('row_https_clist', 0);
		textarea_https_enabled(0);
	}else
		http_proto_change();
}

function applyRule(){
	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_Services_Content.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
	}
}

function validForm(){
	if(!validate_range(document.form.http_lanport, 80, 65535))
		return false;

	if (support_http_ssl()){
		var mode = document.form.http_proto.value;
		if (mode == "0" || mode == "2"){
			if(!validate_range(document.form.http_lanport, 80, 65535))
				return false;
		}
		if (mode == "1" || mode == "2"){
			if(!validate_range(document.form.https_lport, 81, 65535))
				return false;
		}
		if (mode == "2"){
			if (document.form.http_lanport.value == document.form.https_lport.value){
				alert("HTTP and HTTPS ports is equal!");
				document.form.https_lport.focus();
				document.form.https_lport.select();
				return false;
			}
		}
	}else{
		if(!validate_range(document.form.http_lanport, 80, 65535))
			return false;
	}

	return true;
}

function done_validating(action){
	refreshpage();
}

function textarea_https_enabled(v){
	inputCtrl(document.form['httpssl.ca.crt'], v);
	inputCtrl(document.form['httpssl.dh1024.pem'], v);
	inputCtrl(document.form['httpssl.server.crt'], v);
	inputCtrl(document.form['httpssl.server.key'], v);
}

function textarea_sshd_enabled(v){
	inputCtrl(document.form['scripts.authorized_keys'], v);
}

function http_proto_change(){
	var proto = document.form.http_proto.value;
	var v1 = (proto == "0" || proto == "2") ? 1 : 0;
	var v2 = (proto == "1" || proto == "2") ? 1 : 0;

	showhide_div('row_http_lport', v1);
	showhide_div('row_https_lport', v2);
	showhide_div('row_https_clist', v2);
	showhide_div('tbl_https_certs', v2);
	textarea_https_enabled(v2);
}

function sshd_auth_change(){
	var auth = document.form.sshd_enable.value;
	var v = (auth != "0") ? 1 : 0;

	showhide_div('row_ssh_keys', v);
	textarea_sshd_enabled(v);
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

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
    <form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
    <input type="hidden" name="current_page" value="Advanced_Services_Content.asp">
    <input type="hidden" name="next_page" value="">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="LANHostConfig;General;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="modified" value="0">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="first_time" value="">
    <input type="hidden" name="action_script" value="">

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
                            <h2 class="box_head round_top"><#menu5_6#> - <#menu5_6_5#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>
                                    <div class="alert alert-info" style="margin: 10px;"><#Adm_Svc_desc#></div>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Adm_System_webs#></th>
                                        </tr>
                                        <tr id="row_http_proto">
                                            <th><#Adm_System_http_proto#></th>
                                            <td>
                                                <select name="http_proto" class="input" onchange="http_proto_change();">
                                                    <option value="0" <% nvram_match_x("", "http_proto", "0","selected"); %>>HTTP</option>
                                                    <option value="1" <% nvram_match_x("", "http_proto", "1","selected"); %>>HTTPS</option>
                                                    <option value="2" <% nvram_match_x("", "http_proto", "2","selected"); %>>HTTP & HTTPS</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="row_http_lport">
                                            <th><#Adm_System_http_lport#></th>
                                            <td>
                                                <input type="text" maxlength="5" size="15" name="http_lanport" class="input" value="<% nvram_get_x("", "http_lanport"); %>" onkeypress="return is_number(this)"/>
                                                &nbsp;<span style="color:#888;">[80..65535]</span>
                                            </td>
                                        </tr>
                                        <tr id="row_https_lport" style="display:none">
                                            <th><#Adm_System_https_lport#></th>
                                            <td>
                                                <input type="text" maxlength="5" size="15" name="https_lport" class="input" value="<% nvram_get_x("", "https_lport"); %>" onkeypress="return is_number(this)"/>
                                                &nbsp;<span style="color:#888;">[81..65535]</span>
                                            </td>
                                        </tr>
                                        <tr id="row_https_clist" style="display:none">
                                            <th><#Adm_System_https_clist#></th>
                                            <td>
                                                <input type="text" maxlength="256" size="15" name="https_clist" class="input" style="width: 286px;" value="<% nvram_get_x("", "https_clist"); %>" onkeypress="return is_string(this)"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="50%"><#Adm_System_http_access#></th>
                                            <td>
                                                <select name="http_access" class="input">
                                                    <option value="0" <% nvram_match_x("", "http_access", "0","selected"); %>><#checkbox_No#> (*)</option>
                                                    <option value="1" <% nvram_match_x("", "http_access", "1","selected"); %>>Wired clients only</option>
                                                    <option value="2" <% nvram_match_x("", "http_access", "2","selected"); %>>Wired and MainAP clients</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table" id="tbl_https_certs" style="display:none">
                                        <tr>
                                            <th style="background-color: #E3E3E3;"><#Adm_System_https_certs#></th>
                                        </tr>
                                        <tr>
                                            <td style="padding-bottom: 0px; border-top: 0 none;">
                                                <a href="javascript:spoiler_toggle('ca.crt')"><span>Root CA Certificate (optional)</span></a>
                                                <div id="ca.crt" style="display:none;">
                                                    <textarea rows="8" wrap="off" spellcheck="false" maxlength="8192" class="span12" name="httpssl.ca.crt" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("httpssl.ca.crt",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-bottom: 0px; border-top: 0 none;">
                                                <a href="javascript:spoiler_toggle('dh1024.pem')"><span>Diffie-Hellman PEM (optional)</span></a>
                                                <div id="dh1024.pem" style="display:none;">
                                                    <textarea rows="8" wrap="off" spellcheck="false" maxlength="8192" class="span12" name="httpssl.dh1024.pem" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("httpssl.dh1024.pem",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-bottom: 0px; border-top: 0 none;">
                                                <a href="javascript:spoiler_toggle('server.crt')"><span>Server Certificate (required)</span></a>
                                                <div id="server.crt" style="display:none;">
                                                    <textarea rows="8" wrap="off" spellcheck="false" maxlength="8192" class="span12" name="httpssl.server.crt" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("httpssl.server.crt",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding-bottom: 0px; border-top: 0 none;">
                                                <a href="javascript:spoiler_toggle('server.key')"><span>Server Private Key (required)</span></a>
                                                <div id="server.key" style="display:none;">
                                                    <textarea rows="8" wrap="off" spellcheck="false" maxlength="8192" class="span12" name="httpssl.server.key" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("httpssl.server.key",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Adm_System_term#></th>
                                        </tr>
                                        <tr>
                                            <th width="50%"><#Adm_System_telnetd#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="telnetd_on_of">
                                                        <input type="checkbox" id="telnetd_fake" <% nvram_match_x("", "telnetd", "1", "value=1 checked"); %><% nvram_match_x("", "telnetd", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="telnetd" id="telnetd_1" class="input" value="1" <% nvram_match_x("", "telnetd", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="telnetd" id="telnetd_0" class="input" value="0" <% nvram_match_x("", "telnetd", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="row_sshd">
                                            <th><#Adm_System_sshd#></th>
                                            <td>
                                                <select name="sshd_enable" class="input" onchange="sshd_auth_change();">
                                                    <option value="0" <% nvram_match_x("", "sshd_enable", "0","selected"); %>><#checkbox_No#> (*)</option>
                                                    <option value="1" <% nvram_match_x("", "sshd_enable", "1","selected"); %>><#checkbox_Yes#></option>
                                                    <option value="2" <% nvram_match_x("", "sshd_enable", "2","selected"); %>><#checkbox_Yes#> (authorized_keys only)</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="row_ssh_keys" style="display:none">
                                            <td colspan="2" style="padding-bottom: 0px;">
                                                <a href="javascript:spoiler_toggle('authorized_keys')"><span><#Adm_System_sshd_keys#> (authorized_keys)</span></a>
                                                <div id="authorized_keys" style="display:none;">
                                                    <textarea rows="8" wrap="off" spellcheck="false" maxlength="8192" class="span12" name="scripts.authorized_keys" style="font-family:'Courier New'; font-size:12px;"><% nvram_dump("scripts.authorized_keys",""); %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <th colspan="2" style="background-color: #E3E3E3;"><#Adm_System_misc#></th>
                                        </tr>
                                        <tr id="row_wins" style="display:none">
                                            <th><#Adm_Svc_wins#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="wins_enable_on_of">
                                                        <input type="checkbox" id="wins_enable_fake" <% nvram_match_x("", "wins_enable", "1", "value=1 checked"); %><% nvram_match_x("", "wins_enable", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="wins_enable" id="wins_enable_1" class="input" value="1" <% nvram_match_x("", "wins_enable", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="wins_enable" id="wins_enable_0" class="input" value="0" <% nvram_match_x("", "wins_enable", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#Adm_Svc_lltd#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="lltd_enable_on_of">
                                                        <input type="checkbox" id="lltd_enable_fake" <% nvram_match_x("", "lltd_enable", "1", "value=1 checked"); %><% nvram_match_x("", "lltd_enable", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="lltd_enable" id="lltd_enable_1" class="input" value="1" <% nvram_match_x("", "lltd_enable", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="lltd_enable" id="lltd_enable_0" class="input" value="0" <% nvram_match_x("", "lltd_enable", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th><#Adm_Svc_adsc#></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="adsc_enable_on_of">
                                                        <input type="checkbox" id="adsc_enable_fake" <% nvram_match_x("", "adsc_enable", "1", "value=1 checked"); %><% nvram_match_x("", "adsc_enable", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="adsc_enable" id="adsc_enable_1" class="input" value="1" <% nvram_match_x("", "adsc_enable", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="adsc_enable" id="adsc_enable_0" class="input" value="0" <% nvram_match_x("", "adsc_enable", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="50%"><a class="help_tooltip" href="javascript:void(0);" onmouseover="openTooltip(this,23,1);"><#TweaksWdg#></a></th>
                                            <td>
                                                <div class="main_itoggle">
                                                    <div id="watchdog_cpu_on_of">
                                                        <input type="checkbox" id="watchdog_cpu_fake" <% nvram_match_x("", "watchdog_cpu", "1", "value=1 checked"); %><% nvram_match_x("", "watchdog_cpu", "0", "value=0"); %>>
                                                    </div>
                                                </div>
                                                <div style="position: absolute; margin-left: -10000px;">
                                                    <input type="radio" name="watchdog_cpu" id="watchdog_cpu_1" class="input" value="1" <% nvram_match_x("", "watchdog_cpu", "1", "checked"); %>/><#checkbox_Yes#>
                                                    <input type="radio" name="watchdog_cpu" id="watchdog_cpu_0" class="input" value="0" <% nvram_match_x("", "watchdog_cpu", "0", "checked"); %>/><#checkbox_No#>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                    <table class="table">
                                        <tr>
                                            <td style="border: 0 none;">
                                                <center><input class="btn btn-primary" style="width: 219px" onclick="applyRule();" type="button" value="<#CTL_apply#>" /></center>
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
