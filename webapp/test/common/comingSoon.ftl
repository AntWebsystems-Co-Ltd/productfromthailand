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
    color:#666;http://localhost:8080/control/main
    font-weight:bold;
    padding: 1px 2px;}
.comingSoon p{margin-left:400px;margin-top:0px;font-size:14px;font-weight:bold;color:white;}
.comingSoon a:link,a:visited{text-decoration: none;color:#c7b815;}
.comingSoon #captchaImage{margin-left:450px;padding-left:95px;padding-bottom:3px;}
</style>
</head>
<body>
<br>
    <table cellspacing="0" cellpadding="0" border="0" height="80" width="100%" style="float:right; color:white;">
        <tbody>
            <tr>
                <td align="right"><h3>${uiLabelMap.CommonLanguageTitle} : </h3></td>
                <td align="right" width="100" valign="top">
                     <form method="post" name="chooseLanguage" action="<@ofbizUrl>setSessionLocale</@ofbizUrl>">
                      <select name="newLocale" class="selectBox" style="width:100" onchange="submit()">
                        <#assign availableLocales = Static["org.ofbiz.base.util.UtilMisc"].availableLocales()/>
                        <#list availableLocales as availableLocale>
                          <#assign langAttr = availableLocale.toString()?replace("_", "-")>
                          <#assign langDir = "ltr">
                          <#if "ar.iw"?contains(langAttr?substring(0, 2))>
                             <#assign langDir = "rtl">
                          </#if>
                          <option lang="${langAttr}" dir="${langDir}" value="${availableLocale.toString()}"<#if locale.toString() = availableLocale.toString()> selected="selected"</#if>>${availableLocale.getDisplayName(availableLocale)}</option>
                        </#list>
                      </select>
                    </form>
                </td>
            </tr>
        </tbody>
    </table>
<div class="comingSoon">
    <p>${uiLabelMap.PFTIntroMarketPlace}</p>
    <p>${uiLabelMap.PFTPleaseRegister}</p>
    <form name="signUpForContactListForm" action="signUpForContactList" method="post">
        <input type="hidden" name="reload"/>
        <div id="captchaCode"><input type="hidden" value="${parameters.ID_KEY}" name="captchaCode"/></div>
            <select class="selectBox" name="contactListId" style="visibility:hidden;">
              <option value="9000" >New Product Announcements</option>
            </select>
        <p><span style="padding:1px;">${uiLabelMap.PFTYourEmail} : <input class="inputBox" value="" id="subscribeForm_email" name="email" maxlength="255" size="20" type="text"></span></p>
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

        <p>${uiLabelMap.MyPortalVerifyCaptcha} : <input type="text" autocomplete="off" id="subscribeForm_captcha" maxlength="30" size="10" class="required false" name="captcha"/>
        <input id="subscribeButton" value="Subscribe" type="submit"></p>
    </form><br>
    <p><span style="color:#c7b815;font-size:11px;">${uiLabelMap.PartyPhoneNumber}: +66-53 483245, ${uiLabelMap.PartyFaxNumber} : +66-53 483246, ${uiLabelMap.PartyEmailAddress}:<a href="mailto:info@productfromthailand.com">info@productfromthailand.com</a></span></p>
    <p ><span style="color:#c7b815;font-size:11px;"><a href="http://www.antwebsystems.com">${uiLabelMap.PFTCompanyName}</a> ${uiLabelMap.PFTCompanyAddress}</span></p>
</div>
</body></html>