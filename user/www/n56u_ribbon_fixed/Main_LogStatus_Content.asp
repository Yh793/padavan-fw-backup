<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>ASUS Wireless Router <#Web_Title#> - <#menu5_7_2#></title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();

wan_route_x = '<% nvram_get_x("IPConnection", "wan_route_x"); %>';
wan_nat_x = '<% nvram_get_x("IPConnection", "wan_nat_x"); %>';
wan_proto = '<% nvram_get_x("Layer3Forwarding",  "wan_proto"); %>';

function showclock(){
	JS_timeObj.setTime(systime_millsec);
	systime_millsec += 1000;
	
	JS_timeObj2 = JS_timeObj.toString();	
	JS_timeObj2 = JS_timeObj2.substring(0,3) + ", " +
	              JS_timeObj2.substring(4,10) + "  " +
				  checkTime(JS_timeObj.getHours()) + ":" +
				  checkTime(JS_timeObj.getMinutes()) + ":" +
				  checkTime(JS_timeObj.getSeconds()) + "  " +
				  JS_timeObj.getFullYear() + " GMT" +
				  timezone;
	$("system_time").innerHTML = JS_timeObj2;
	setTimeout("showclock()", 1000);
}

function clearLog(){
	document.form1.target = "hidden_frame";
	document.form1.action_mode.value = " Clear ";
	document.form1.submit();
	location.href = location.href;
}
</script>
<style>
    .nav-tabs > li > a {
          padding-right: 6px;
          padding-left: 6px;
    }
</style>
</head>

<body onload="show_banner(2); show_menu(5,8,1); show_footer();load_body();showclock();" onunLoad="return unload_body();">

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

    <iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0" style="position: absolute;"></iframe>

    <form method="post" name="form" action="apply.cgi" >
    <input type="hidden" name="current_page" value="Main_LogStatus_Content.asp">
    <input type="hidden" name="next_page" value="Main_LogStatus_Content.asp">
    <input type="hidden" name="next_host" value="">
    <input type="hidden" name="sid_list" value="FirewallConfig;">
    <input type="hidden" name="group_id" value="">
    <input type="hidden" name="modified" value="0">
    <input type="hidden" name="action_mode" value="">
    <input type="hidden" name="first_time" value="">
    <input type="hidden" name="action_script" value="">
    <input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("LANGUAGE", "preferred_lang"); %>">
    <input type="hidden" name="wl_ssid2" value="<% nvram_get_x("WLANConfig11b",  "wl_ssid2"); %>">
    <input type="hidden" name="firmver" value="<% nvram_get_x("",  "firmver"); %>">
    </form>

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
                            <h2 class="box_head round_top"><#menu5_7#> - <#menu5_7_2#></h2>
                            <div class="round_bottom">
                                <div class="row-fluid">
                                    <div id="tabMenu" class="submenuBlock"></div>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <td colspan="2" style="border-top: 0 none;"><b><#General_x_SystemTime_itemname#>:</b><span class="alert alert-info" style="margin-left: 10px; padding-top: 4px; padding-bottom: 4px;" id="system_time"></span></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="padding-bottom: 0px;">
                                                <textarea rows="23" wrap="off" class="span12" style="font-family:'Courier New', Courier, mono; font-size:13px;" readonly="readonly" id="textarea"><% nvram_dump("syslog.log","syslog.sh"); %></textarea>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                        <tr>
                                            <td width="15%" style="text-align: left">
                                                <form method="post" name="form1" action="apply.cgi">
                                                    <input type="hidden" name="current_page" value="Main_LogStatus_Content.asp">
                                                    <input type="hidden" name="action_mode" value=" Clear ">
                                                    <input type="hidden" name="next_host" value="">
                                                    <input type="submit" onClick="document.form1.next_host.value = location.host; onSubmitCtrl(this, ' Clear ')" value="<#CTL_clear#>" class="btn btn-info" style="width: 170px">
                                                </form>
                                            </td>

                                            <td width="15%" style="text-align: left">
                                                <form method="post" name="form2" action="syslog.cgi">
                                                    <input type="hidden" name="next_host" value="">
                                                    <input type="submit" onClick="document.form2.next_host.value = location.host; onSubmitCtrl(this, ' Save ')" value="<#CTL_onlysave#>" class="btn btn-success" style="width: 170px">
                                                </form>
                                            </td>

                                            <td style="text-align: right">
                                                <form method="post" name="form3" action="apply.cgi">
                                                    <input type="hidden" name="current_page" value="Main_LogStatus_Content.asp">
                                                    <input type="hidden" name="action_mode" value=" Refresh ">
                                                    <input type="hidden" name="next_host" value="">
                                                    <!--input type="submit" onClick="document.form3.next_host.value = location.host; onSubmitCtrl(this, ' Refresh ')" value="<#CTL_refresh#>" class="button"-->
                                                    <input type="button" onClick="location.href=location.href" value="<#CTL_refresh#>" class="btn btn-primary" style="width: 219px">
                                                </form>
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

    <div id="footer"></div>
</div>
</body>
<script type="text/javascript">
	jQuery.noConflict();
	(function($){
		var textArea = document.getElementById('textarea');
		textArea.scrollTop = textArea.scrollHeight;
	})(jQuery);
</script>
</html>
