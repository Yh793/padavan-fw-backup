<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<title>Del New Account</title>
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="../state.js"></script>
<script type="text/javascript">
var selectedAccount = parent.getSelectedAccount();

function initial(){
	showtext($("selected_account"), selectedAccount);
	document.deleteAccountForm.Cancel.focus();	
	clickevent();
}

function clickevent(){
	$("Submit").onclick = function(){
			$("account").value = selectedAccount;
			
			parent.showLoading();
			document.deleteAccountForm.submit();
			parent.hidePop("apply");
		};
	
	$("Cancel").onclick = function(){
			parent.hidePop('OverlayMask');
		};
}

</script>
<style>
    .table th, .table td{vertical-align: middle;}
    .table input, .table select {margin-bottom: 0px;}
</style>
</head>

<body style="background: 0 none;"  onLoad="initial();">
<form method="post" name="deleteAccountForm" action="delete_account.asp" target="hidden_frame">
<input name="account" id="account" type="hidden" value="">
  <table width="90%" class="table well aidisk_table" cellpadding="0" cellspacing="0">
  <thead>
    <tr>
      <td width="95%">
          <h4><#DelAccountTitle#></h4> <span id="selected_account"></span>
      </td>
      <td style="text-align: right">
          <a href="javascript:void(0)" onclick="parent.hidePop('OverlayMask');"><i class="icon icon-remove"></i></a>
      </td>
    </tr>
  </thead>
  <tbody>
    <tr>
	  <td colspan="2" class="hint_word"><#DelAccountAlert#></td>
	</tr>
  </tbody>	
    <tr>
      <td width="30%" style="text-align: left;">
  	    <input id="Cancel" type="button" class="btn" value="<#CTL_Cancel#>">
	  </td>
	  <td style="text-align: center">
        <input id="Submit" type="button" class="btn btn-primary" value="<#CTL_del#>">
      </td>
    </tr>
  </table>
</form>
</body>
</html>
