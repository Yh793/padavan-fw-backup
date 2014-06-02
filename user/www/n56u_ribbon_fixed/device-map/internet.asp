<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<title></title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="formcontrol.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script>

<% wanlink(); %>

var $j = jQuery.noConflict();
var id_update_wanip = 0;
var status_code = wanlink_status();

function initial(){
	flash_button();
	id_update_wanip = setTimeout("update_wanip();", 2000);

	if(sw_mode == "4"){
		$j("#domore")[0].remove(4);
		$j("#domore")[0].remove(3);
		$j("#domore")[0].remove(2);
	}

	var wantime = wanlink_time();
	if (wantime > 0){
		var updays, uphours, upminutes;
		updays = Math.floor(wantime / 86400);
		upminutes = Math.floor(wantime / 60);
		uphours = (Math.floor(upminutes / 60)) % 24;
		upminutes = upminutes % 60;
		uphours = uphours < 10 ? ('0'+uphours) : uphours;
		upminutes = upminutes < 10 ? ('0'+upminutes) : upminutes;
		$("WANTime").innerHTML = updays + "<#Day#>".substring(0,1) + " " + uphours+"<#Hour#>".substring(0,1) + " " + upminutes+"<#Minute#>".substring(0,1);
		$("row_ppp_time").style.display = "";
	}

	var status_text = "Unknown";
	if (status_code == 0)
		status_text = "<#InetState0#>";
	else if (status_code == 1)
		status_text = "<#InetState1#>";
	else if (status_code == 2)
		status_text = "<#InetState2#>";
	else if (status_code == 3)
		status_text = "<#InetState3#>";
	else if (status_code == 4)
		status_text = "<#InetState4#>";
	else if (status_code == 5)
		status_text = "<#InetState5#>";
	else if (status_code == 6)
		status_text = "<#InetState6#>";
	else if (status_code == 7)
		status_text = "<#InetState7#>";
	else if (status_code == 8)
		status_text = "<#InetState8#>";
	$("wan_status").innerHTML = status_text;

	if (status_code != 0)
		$("wan_status").style.color = "#F75";

	var wantype = wanlink_type();
	if(wantype == 'Automatic IP')
		$("WANType").innerHTML = 'IPoE: <#BOP_ctype_title1#>';
	else if(wantype == 'Static IP')
		$("WANType").innerHTML = 'IPoE: <#BOP_ctype_title5#>';
	else
		$("WANType").innerHTML = wantype;

	var ether_link = wanlink_etherlink();
	var apcli_link = wanlink_apclilink();
	$("WANEther").innerHTML = ether_link;
	$("WANAPCli").innerHTML = apcli_link;
	$("WANIP4").innerHTML   = wanlink_ip4_wan();
	$("WANGW4").innerHTML   = wanlink_gw4_wan();
	$("WANDNS").innerHTML   = wanlink_dns();
	$("WANMAC").innerHTML   = wanlink_mac();

	if (ether_link != '')
		$("row_link_ether").style.display = "";

	if (apcli_link != '')
		$("row_link_apcli").style.display = "";

	if (wanlink_ip4_man() != ''){
		$("MANIP4").innerHTML = wanlink_ip4_man();
		$("MANGW4").innerHTML = wanlink_gw4_man();
		$("row_man_ip4").style.display = "";
		$("row_man_gw4").style.display = "";
	}

	if (wanlink_ip6_wan() != ''){
		$("WANIP6").innerHTML = wanlink_ip6_wan();
		$("LANIP6").innerHTML = wanlink_ip6_lan();
		$("row_wan_ip6").style.display = "";
		$("row_lan_ip6").style.display = "";
	}
}

function update_wanip() {
	clearTimeout(id_update_wanip);
	$j.ajax({
		url: '/status_wanlink.asp',
		dataType: 'script',
		cache: true,
		error: function(xhr) {
			;
		},
		success: function(response) {
			if(wanlink_status() != status_code)
				refreshpage();
			else
				id_update_wanip = setTimeout("update_wanip();", 2000);
		}
	});
}

function submitWANAction(status){
	switch(status){
		case 0:
			parent.showLoading();
			setTimeout('location.href = "/device-map/wan_action.asp?wanaction=Connect";', 1);
			break;
		case 1:
			parent.showLoading();
			setTimeout('location.href = "/device-map/wan_action.asp?wanaction=Disconnect";', 1);
			break;
		default:
			alert("No change!");
	}
}

</script>
</head>

<body class="body_iframe" onload="initial();">
<br>
<form method="post" name="internetForm">
<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
  <tr>
    <th width="50%" style="border-top: 0 none;"><#InetControl#></th>
    <td style="border-top: 0 none;">
    <div style="display:none"></div>
      <input type="button" id="connectbutton_link" class="btn btn-info" value="<#Connect#>" onclick="submitWANAction(0);">
      <input type="button" id="connectbutton_nolink" class="btn btn-danger" value="<#Disconnect#>" onclick="submitWANAction(1);">
    </td>
  </tr>
  <tr id="row_link_ether" style="display:none">
    <th><#SwitchState#></th>
    <td><span id="WANEther"></span></td>
  </tr>
  <tr id="row_link_apcli" style="display:none">
    <th><#InetStateWISP#></th>
    <td><span id="WANAPCli"></span></td>
  </tr>
  <tr>
    <th><#ConnectionStatus#></th>
    <td><span id="wan_status"></span></td>
  </tr>
  <tr>
    <th><#Connectiontype#>:</th>
    <td><span id="WANType"></span></td>
  </tr>
  <tr id="row_ppp_time" style="display:none">
    <th><#PPP_Uptime#></th>
    <td><span id="WANTime"></span></td>
  </tr>
  <tr>
    <th><#IP4_Addr#> WAN:</th>
    <td><span id="WANIP4"></span></span></td>
  </tr>
  <tr id="row_man_ip4" style="display:none">
    <th><#IP4_Addr#> MAN:</th>
    <td><span id="MANIP4"></span></td>
  </tr>
  <tr id="row_wan_ip6" style="display:none">
    <th><#IP6_Addr#> WAN:</th>
    <td><span id="WANIP6"></span></td>
  </tr>
  <tr id="row_lan_ip6" style="display:none">
    <th><#IP6_Addr#> LAN:</th>
    <td><span id="LANIP6"></span></td>
  </tr>
  <tr>
    <th><#Gateway#> WAN:</th>
    <td><span id="WANGW4"></span></td>
  </tr>
  <tr id="row_man_gw4" style="display:none">
    <th><#Gateway#> MAN:</th>
    <td><span id="MANGW4"></span></td>
  </tr>
  <tr>
    <th>DNS:</th>
    <td><span id="WANDNS"></span></td>
  </tr>
  <tr>
    <th><#MAC_Address#></th>
    <td><span id="WANMAC"></span></td>
  </tr>
</table>
</form>

<table width="100%" align="center" class="table">
    <tr>
        <td width="50%">&nbsp;</td>
        <td>
            <select id="domore" class="domore" onchange="domore_link(this);">
              <option selected="selected"><#MoreConfig#>...</option>
              <option value="../Advanced_WAN_Content.asp"><#menu5_3_1#></option>
              <option value="../Advanced_VirtualServer_Content.asp"><#menu5_3_4#></option>
              <option value="../Advanced_Exposed_Content.asp"><#menu5_3_5#></option>
              <option value="../Advanced_ASUSDDNS_Content.asp"><#menu5_3_6#></option>
            </select>
        </td>
    </tr>
</table>
</body>
</html>

