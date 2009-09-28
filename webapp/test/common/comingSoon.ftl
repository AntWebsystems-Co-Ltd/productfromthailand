<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>Product From Thailand :Coming Soon</title>
 <#if layoutSettings.javaScripts?has_content>
    <#--layoutSettings.javaScripts is a list of java scripts. -->
    <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
    <#assign javaScriptsSet = Static["org.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
    <#list layoutSettings.javaScripts as javaScript>
      <#if javaScriptsSet.contains(javaScript)>
        <#assign nothing = javaScriptsSet.remove(javaScript)/>
        <script type="text/javascript" src="<@ofbizContentUrl>${javaScript}</@ofbizContentUrl>" type="text/javascript"></script>
      </#if>
    </#list>
  </#if>
  <link type="text/css" href="/flatgrey/maincss.css" rel="stylesheet">
<style type="text/css">
body {background: url("../pfdimages/coming_soon.jpg") left top;} 
.comingSoon{
position: absolute;
top: 375px;
padding:0px;
margin:0px;
width: 100%;

}
#subscribeButton{
border:outset 1px #ccc;
background:#ccc;
color:#666;
font-weight:bold;
padding: 1px 2px;}
.comingSoon p{margin-left:400px;margin-top:0px;font-size:14px;font-weight:bold;color:white;}
.comingSoon a:link,a:visited{text-decoration: none;color:#c7b815;}

.comingSoon #captchaImage{margin-left:450px;padding-left:95px;padding-bottom:3px;}
</style>
</head>
<body>
<br>
<div class="comingSoon">
<p>A marketplace to buy but also to sell products orginated in Thailand.</p>
<p>Please Register if you like to be notified when we go online.</p>
<form name="signUpForContactListForm" action="signUpForContactList" method="post">
 <input type="hidden" name="reload"/>
 <div id="captchaCode"><input type="hidden" value="${parameters.ID_KEY}" name="captchaCode"/></div>
<select class="selectBox" name="contactListId" style="visibility:hidden;">
<option value="9000" >New Product Announcements</option>
</select>
<p><span style="padding:1px;">Your E-mail : <input class="inputBox" value="" id="subscribeForm_email" name="email" maxlength="255" size="20" type="text"></span></p>
<div style="display:inline;position:relative;">
	<div id="captchaImage"><img src="${parameters.captchaFileName}"/></div>
<#--a href="javascript:reloadCaptcha();"><img src="../images/reload.png" width="22" height="22" alt="Reload Code"/></a-->	
</div>
 <script type="text/javascript" language="JavaScript">
                        <!--
                            dojo.require("dojo.widget.*");
                            dojo.require("dojo.event.*");
                            dojo.require("dojo.io.*");
                            
                            function reloadCaptcha(){
                                var submitToUri = "<@ofbizUrl>reloadCaptchaImage</@ofbizUrl>";
                                dojo.io.bind({url: submitToUri,
                                    load: function(type, data, evt){
                                    if(type == "load"){
                                        document.getElementById("captchaImage").innerHTML = data;
                                           reloadCaptchaCode();
                                    }
                                },mimetype: "text/html"});
                            }
                            function submitNewCustForm(){
                                var nform = document.newuserform;
                                nform.captcha.value = document.captchaform.captcha.value;
                                nform.submit();
                            }
                            function reloadCaptchaCode(){
                                var submitToUri = "<@ofbizUrl>reloadCaptchaCode</@ofbizUrl>";
                                dojo.io.bind({url: submitToUri,
                                    load: function(type, data, evt){
                                    if(type == "load"){
                                        document.getElementById("captchaCode").innerHTML = data;
                                    }
                                },mimetype: "text/html"});
                            }
                        //-->
                    </script>
                   
                  <p>Verify Captcha Code : <input type="text" autocomplete="off" id="subscribeForm_captcha" maxlength="30" size="10" class="required false" name="captcha"/>
<input id="subscribeButton" value="Subscribe" type="submit"></p>
</form><br>
<p><span style="color:#c7b815;font-size:11px;">${uiLabelMap.PartyPhoneNumber}: +66-53 483245, ${uiLabelMap.PartyFaxNumber} : +66-53 483246, ${uiLabelMap.PartyEmailAddress}:<a href="mailto:info@productfromthailand.com">info@productfromthailand.com</a></span></p>
<p ><span style="color:#c7b815;font-size:11px;"><a href="http://www.antwebsystems.com">${uiLabelMap.PFTCompanyName}</a> ${uiLabelMap.PFTCompanyAddress}</span></p>
</div>

</body></html>