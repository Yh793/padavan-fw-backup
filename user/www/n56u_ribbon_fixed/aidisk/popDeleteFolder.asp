﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<title>Del Folder</title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="../state.js"></script>
<script type="text/javascript">
var selectedPool = parent.getSelectedPool();
var selectedFolder = parent.getSelectedFolder();

function initial(){
	showtext($("selected_Folder"), showhtmlspace(showhtmland(selectedFolder)));
	document.deleteFolderForm.Cancel.focus();
	clickevent();
}

function clickevent(){
	$("Submit").onclick = function(){
			$("pool").value = selectedPool;
			$("folder").value = selectedFolder;
			
			parent.showLoading();
			document.deleteFolderForm.submit();
			parent.hidePop("apply");
		};
}
</script>
</head>

<body style="background: 0 none;" onLoad="initial();">
<form method="post" name="deleteFolderForm" action="delete_sharedfolder.asp" target="hidden_frame">
<input type="hidden" name="pool" id="pool" value="">
<input type="hidden" name="folder" id="folder" value="">
  <table width="100%" class="table well aidisk_table" cellpadding="0" cellspacing="0">
  <thead>
    <tr>
      <td width="95%">
          <b><#DelFolderTitle#> <span id="selected_account"></span> </b>
      </td>
      <td style="text-align: right">
          <a href="javascript:void(0)" onclick="parent.hidePop('OverlayMask');"><i class="icon icon-remove"></i></a>
      </td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="2" valign="middle"><#DelFolderAlert#> <b><span id="selected_Folder" ></span></b></td>
	</tr>

    <tr>
      <td width="30%" style="text-align: left;">
        <input id="Cancel" type="button" class="btn" onClick="parent.hidePop('OverlayMask');" value="<#CTL_Cancel#>">
      </td>
      <td style="text-align: center">
        <input id="Submit" type="button" class="btn btn-primary" value="<#CTL_del#>">
      </td>
    </tr>
	</tbody>
  </table>
</form>  
</body>
</html>
