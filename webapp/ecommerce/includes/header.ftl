<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#--<#include "component://productfromthailand/webapp/ecommerce/includes/headerHead.ftl"/>-->
<#include "component://ecommerce/webapp/ecommerce/includes/headerHead.ftl"/>

<body>
<center>
<div id="ecom-header">
    <div id="left">
        <a href="<@ofbizUrl>main</@ofbizUrl>">
          <#if sessionAttributes.overrideLogo?exists>
            <img src="<@ofbizContentUrl>${sessionAttributes.overrideLogo}</@ofbizContentUrl>" alt="Logo"/>
          <#elseif catalogHeaderLogo?exists>
            <img src="<@ofbizContentUrl>${catalogHeaderLogo}</@ofbizContentUrl>" alt="Logo"/>
          <#elseif layoutSettings.VT_HDR_IMAGE_URL?has_content>
            <img src="<@ofbizContentUrl>${layoutSettings.VT_HDR_IMAGE_URL.get(0)}</@ofbizContentUrl>" alt="Logo"/>
          </#if>
        </a>
    </div>
    <div id="right">
        <div id="welcome-message">
            <#if sessionAttributes.autoName?has_content>
            ${uiLabelMap.CommonWelcome}&nbsp;${sessionAttributes.autoName?html}!
            (${uiLabelMap.CommonNotYou}?&nbsp;<a href="<@ofbizUrl>autoLogout</@ofbizUrl>" class="linktext">${uiLabelMap.CommonClickHere}</a>)
            <#else/>
            ${uiLabelMap.CommonWelcome}!
            </#if>&nbsp;&nbsp;
            <#assign availableLocales = Static["org.ofbiz.base.util.UtilMisc"].availableLocales()/>
            <#list availableLocales as availableLocale>
                <#if locale.toString() == availableLocale.toString()>
                    <#if locale.toString() == "en">
                        <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=th"><img src="<@ofbizContentUrl>/pfdimages/ThaiFlag.jpg</@ofbizContentUrl>" alt="Thai" width="25"/></a>
                    <#elseif locale.toString() == "th">
                        <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=en"><img src="<@ofbizContentUrl>/pfdimages/EngFlag.jpg</@ofbizContentUrl>"  alt="English" width="25"/></a>
                    </#if>
                </#if>
            </#list>
            <#if locale.toString() == "en_US">
                <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=th"><img src="<@ofbizContentUrl>/pfdimages/ThaiFlag.jpg</@ofbizContentUrl>" alt="Thai" width="25"/></a>
            </#if>
        </div>
        <div>
            <ul id="right-links">
                <li id="header-bar-sitemap"><a href="<@ofbizUrl>sitemap</@ofbizUrl>"><h2>${uiLabelMap.PFTSitemap}</h2></a></li>
                <li id="header-bar-help"><a href="<@ofbizUrl>main</@ofbizUrl>"><h2>${uiLabelMap.PFTHelpAndInstruction}</h2></a></li>
              <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
                <li id="header-bar-logout"><a href="<@ofbizUrl>logout</@ofbizUrl>"><h2>${uiLabelMap.CommonLogout}</h2></a></li>
              <#else/>
                <li id="header-bar-login"><a href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>"><h2>${uiLabelMap.PFTSignInOrRegister}</h2></a></li>
              </#if>
            </ul>
        </div>
    </div>
  </div>
<div id="main">
  <div id="ecom-header-bar">
      <div class="leftcorner">&nbsp;</div>
      <div class="rightcorner">&nbsp;</div><br class="bothclear"/>
      <div style="padding:5px 0 2px 0;background-color:white;">
            <#if requestAttributes._CURRENT_VIEW_?has_content>
                        <#if requestAttributes._CURRENT_VIEW_ == "main"><#assign headerId= "home"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "products"><#assign headerId= "products"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "service"><#assign headerId= "services"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "partner"><#assign headerId= "partner"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "aboutus"><#assign headerId= "aboutus"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "contactus"><#assign headerId= "contactus"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "showcart"><#assign headerId= "showcart"></#if>
           </#if>
      <div id="menubar">
            <ul id="right-links">
              <!-- NOTE: these are in reverse order because they are stacked right to left instead of left to right -->
              <li class="headermenu" <#if headerId?if_exists == "home">id="${headerId}"</#if> ><a href="<@ofbizUrl>main</@ofbizUrl>">${uiLabelMap.PFTHome}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "products">id="${headerId}"</#if> ><a href="<@ofbizUrl>main</@ofbizUrl>">${uiLabelMap.PFTProducts}</a></li>
              <li class="headermenu" <#if headerId?if_exists  == "services">id="${headerId}"</#if> ><a href="<@ofbizUrl>main</@ofbizUrl>">${uiLabelMap.PFTServices}</a></li>
              <li class="headermenu" <#if headerId?if_exists  == "partner">id="${headerId}"</#if> ><a href="<@ofbizUrl>partner</@ofbizUrl>">${uiLabelMap.PFTPartner}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "aboutus">id="${headerId}"</#if> ><a href="<@ofbizUrl>aboutus</@ofbizUrl>">${uiLabelMap.PFTAboutUs}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "contactus">id="${headerId}"</#if> ><a href="<@ofbizUrl>contactus</@ofbizUrl>">${uiLabelMap.PFTContact}</a></li>
            </ul>
            <ul id="left-links">
                <li class="headermenu" <#if headerId?if_exists == "showcart">id="${headerId}"</#if> ><a href="<@ofbizUrl>view/showcart</@ofbizUrl>">${uiLabelMap.OrderViewCart}</a></li>
            </ul>
     </div>
  
     <div id="searchbar">
          
           ${screens.render("component://productfromthailand/widget/CatalogScreens.xml#keywordsearchbox")}
    </div>
    </div>
</div>
    
    <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
              <tr>
                  <td bgcolor="white" width="955px">
