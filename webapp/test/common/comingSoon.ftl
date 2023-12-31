<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<meta name="google-site-verification" content="sFXpi9FNKTEvzYqKvAyhF3j8jdVMb0B97p5M9Y6S81U" />
<title>Product From Thailand :Coming Soon</title>
 <#if layoutSettings.javaScripts?has_content>
    <#--layoutSettings.javaScripts is a list of java scripts. -->
    <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
    <#assign javaScriptsSet = Static["org.apache.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
    <#list layoutSettings.javaScripts as javaScript>
      <#if javaScriptsSet.contains(javaScript)>
        <#assign nothing = javaScriptsSet.remove(javaScript)/>
        <script type="text/javascript" src="<@ofbizContentUrl>${javaScript}</@ofbizContentUrl>" type="text/javascript"></script>
      </#if>
    </#list>
  </#if>
<link type="text/css" href="../pfdimages/styles.css" rel="stylesheet"-->
</head>
<body>
<div class="header">
    <div class="lang">
        <#--${uiLabelMap.CommonLanguageTitle} :-->
            <#if locale.toString()?has_content>
            <#assign currentlang = locale.toString()>
            <#else>
            <#assign currentlang = "en_US">
        </#if> 
        <#if currentlang == "en_US" || currentlang == "en" || currentlang == "en_IE" || currentlang == "en_GB">
        <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=th"><img src="../pfdimages/ThaiFlag.jpg" alt="Thai"/></a>
        <#elseif currentlang =="th"> 
        <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=en_US"><img src="../pfdimages/EngFlag.jpg"  alt="English"/></a>
        </#if>
    </div>
    <div class="logo"><a href="<@ofbizUrl>main</@ofbizUrl>"><img src="../pfdimages/logo.gif"/></a></div>
    <div style="font-size:4em;font-weight:bold;padding: 0 0 10px 0">Coming Soon</div>
    <div class="content">
        ${uiLabelMap.PFTIntroMarketPlace}
        ${uiLabelMap.PFTPleaseRegister}
        <div style="margin:10px 0 0 0;padding: 10px 0 15px 0;background:url(../pfdimages/preview.gif) no-repeat top center">
                <a href="<@ofbizUrl>../pft</@ofbizUrl>" target="_blank" alt="${uiLabelMap.PFTPreview}" id="preview">
                ${uiLabelMap.PFTPreview}
                </a>
        </div>
         <form name="signUpForContactListForm" action="signUpForContactList" method="post">
        <input type="hidden" name="reload"/>
        <div id="captchaCode"><input type="hidden" value="${parameters.ID_KEY}" name="captchaCode"/></div>
            <input type="hidden" value="PFT0001" name="contactListId"/>
        <div class="floatleft">${uiLabelMap.PFTYourEmail} :</div>
        <div class="floatright"> <input class="inputBox" value="${parameters.email?default("")}" id="subscribeForm_email" name="email" maxlength="255" size="20" type="text"></div>
        <div class="floatleft">&nbsp;</div>
        <div class="floatright">
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
        <div class="floatleft">${uiLabelMap.MyPortalVerifyCaptcha} :</div>
        <div class="floatright">
            <input type="text" autocomplete="off" id="subscribeForm_captcha" maxlength="30" size="10" class="required false" name="captcha"/>
        </div>
        <div class="submit"><input id="subscribeButton" value="Subscribe" type="submit">
    </form>
    </div>
    <div class="footer">
        ${uiLabelMap.PFTTel}: +66-53-483245, ${uiLabelMap.PFTFax} : +66-53-483246, ${uiLabelMap.PFTEmail}:<a href="mailto:info@productfromthailand.com">info@productfromthailand.com</a></span></p>
        <br/>${uiLabelMap.PFTCompanyAddress}
    </div>
</div>
</body></html>