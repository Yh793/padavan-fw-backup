﻿<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>ASUS Wireless Router <#Web_Title#> - <#menu5_6_3#></title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<style>
/*.Bar_container{
	width:85%;
	height:21px;
	border:2px inset #999;
	margin:0 auto;
	background-color:#FFFFFF;
	z-index:100;
}
#proceeding_img_text{
	position:absolute; z-index:101; font-size:11px; color:#000000; margin-left:110px; line-height:21px;
}
#proceeding_img{
 	height:21px;
	background:#C0D1D3 url(/images/proceeding_img.gif);
}*/
</style>

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script type="text/javascript" language="JavaScript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script>
wan_route_x = '<% nvram_get_x("IPConnection", "wan_route_x"); %>';
wan_nat_x = '<% nvram_get_x("IPConnection", "wan_nat_x"); %>';
wan_proto = '<% nvram_get_x("Layer3Forwarding",  "wan_proto"); %>';

var varload = 0;

function initial(){
	show_banner(1);
	show_menu(5,6,3);
	show_footer();
	disableCheckChangedStatus();
}

function beforeUpload(o, s)
{
    $('LoadingBar').style.visibility = 'visible';
    onSubmitCtrlOnly(o, s);
}

</script>
<style>
    .table th, .table td{vertical-align: middle;}
    .table input, .table select {margin-bottom: 0px;}
</style>
</head>

<body onload="initial();">

<div id="LoadingBar" class="popup_bg">
    <center>
    <div class="container-fluid" style="margin-top: 150px;">
        <div class="well" style="background-color: #212121; width: 60%;">
            <div class="progress" style="max-width: 450px; text-align: left;">
                <div class="bar" id="proceeding_img"><span id="proceeding_img_text"></span></div>
            </div>
            <div class="alert alert-danger" style="max-width: 400px;"><#FIRM_ok_desc#></div>
        </div>
    </div>
    </center>

    <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" style="position: absolute; margin-left: -10000px;" align="center">
        <tr>
            <td height="80">
                <div class="progress">
                </div>
                <div class="alert alert-info"><#FIRM_ok_desc#></div>
            </td>
        </tr>
    </table>

</div>
<div id="Loading" class="popup_bg"></div><!--for uniform show, useless but have exist-->

<div class="container-fluid" style="padding-right: 0px">
    <div class="row-fluid">
        <div class="span2"><center><div id="logo"></div></center></div>
        <div class="span10" >
            <div id="TopBanner"></div>
        </div>
    </div>
</div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

<form method="post" action="upgrade.cgi" name="form" target="hidden_frame" enctype="multipart/form-data">
<input type="hidden" name="current_page" value="Advanced_FirmwareUpgrade_Content.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("LANGUAGE", "preferred_lang"); %>">
<input type="hidden" name="wl_ssid2" value="<% nvram_get_x("WLANConfig11b",  "wl_ssid2"); %>">

<div class="container-fluid">
    <div class="row-fluid">
        <div class="span2">
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

        <div class="span10">
            <!--Body content-->
            <div class="row-fluid">
                <div class="span12">
                    <div class="box well grad_colour_dark_blue">
                        <h2 class="box_head round_top"><#menu5_6#> - <#menu5_6_3#></h2>
                        <div class="round_bottom">
                            <div class="row-fluid">
                                <div id="tabMenu" class="submenuBlock"></div>
                                <div class="alert alert-info" style="margin: 10px;">
                                    <#FW_desc1#>
                                    <ol>
                                        <li><#FW_desc2#></li>
                                        <li><#FW_desc3#></li>
                                        <li><#FW_desc4#></li>
                                        <li><#FW_desc5#></li>
                                        <li><#FW_desc6#></li>
                                    </ol>
                                </div>

                                <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                    <tr>
                                        <th width="50%"><#FW_item1#></th>
                                        <td><input type="text" class="input" value="<% nvram_get_f("general.log","productid"); %>" readonly="1"></td>
                                    </tr>
                                    <tr>
                                        <th><#FW_item2#></th>
                                        <!--Viz modify for "1.0.1.4j"  td><input type="text" name="firmver" class="input" value="<% nvram_get_f("general.log","firmver"); %>" readonly="1"></td-->
                                        <td><input type="text" name="firmver" class="input" value="<% nvram_get_x("",  "firmver_sub"); %>" readonly="1"></td>
                                    </tr>
                                    <tr>
                                        <th><#FW_item5#></th>
                                        <td>
                                            <input type="file" name="file" class="input" size="40">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <center><input type="button" name="button" class="btn btn-primary" style="width: 219px;" onclick="beforeUpload(this, 'Upload1');" value="<#CTL_upload#>" /></center>
                                        </td>
                                    </tr>
                                </table>

                                <div class="alert alert-info" style="margin-left: 10px; margin-right: 10px;">
                                    <strong><#FW_note#></strong>
                                    <ol>
                                        <li><#FW_n1#></li>
                                        <li><#FW_n2#></li>
                                    </ol>
                                </div>

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
<form name="hint_form"></form>
</body>
</html>
