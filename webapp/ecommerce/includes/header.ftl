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
                <li id="header-bar-sitemap"><a href="<@ofbizUrl>main</@ofbizUrl>"><h2>${uiLabelMap.PFTSitemap}</h2></a></li>
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
      <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
              <tr>
                  <td background="/pft/images/bg01.gif" width="955px" align="center">
                      <br>
                      <div id="menubar">
                        <ul id="right-links">
                          <!-- NOTE: these are in reverse order because they are stacked right to left instead of left to right -->
                          <li id="header-bar-home"><a href="<@ofbizUrl>main</@ofbizUrl>"><h1>${uiLabelMap.PFTHome}</h1></a></li>
                          <li id="header-bar-product"><a href="<@ofbizUrl>main</@ofbizUrl>"><h1>${uiLabelMap.PFTProducts}</h1></a></li>
                          <li id="header-bar-service"><a href="<@ofbizUrl>main</@ofbizUrl>"><h1>${uiLabelMap.PFTServices}</h1></a></li>
                          <li id="header-bar-partner"><a href="<@ofbizUrl>partner</@ofbizUrl>"><h1>${uiLabelMap.PFTPartner}</h1></a></li>
                          <li id="header-bar-aboutus"><a href="<@ofbizUrl>main</@ofbizUrl>"><h1>${uiLabelMap.PFTAboutUs}</h1></a></li>
                          <li id="header-bar-contact"><a href="<@ofbizUrl>contactus</@ofbizUrl>"><h1>${uiLabelMap.PFTContact}</h1></a></li>
                          <#--if !userLogin?has_content || (userLogin.userLoginId)?if_exists != "anonymous">
                            <li id="header-bar-viewprofile"><a href="<@ofbizUrl>viewprofile</@ofbizUrl>"><h1>${uiLabelMap.CommonProfile}</h1></a></li>
                            <li id="header-bar-ListQuotes"><a href="<@ofbizUrl>ListQuotes</@ofbizUrl>"><h1>${uiLabelMap.OrderOrderQuotes}</h1></a></li>
                            <li id="header-bar-ListRequests"><a href="<@ofbizUrl>ListRequests</@ofbizUrl>"><h1>${uiLabelMap.OrderRequests}</h1></a></li>
                            <li id="header-bar-editShoppingList"><a href="<@ofbizUrl>editShoppingList</@ofbizUrl>"><h1>${uiLabelMap.EcommerceShoppingLists}</h1></a></li>
                            <li id="header-bar-orderhistory"><a href="<@ofbizUrl>orderhistory</@ofbizUrl>"><h1>${uiLabelMap.EcommerceOrderHistory}</h1></a></li>
                          </#if-->
                          
                        </ul>
                        <ul id="left-links">
                            <li id="header-bar-showcart"><a href="<@ofbizUrl>view/showcart</@ofbizUrl>"><h1>${uiLabelMap.OrderViewCart}</h1></a></li>
                        </ul>
                      </div>
                      <#if requestAttributes._CURRENT_VIEW_?has_content>
                        <#if requestAttributes._CURRENT_VIEW_ == "main"><#assign startleft= "25px"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "contactus"><#assign startleft= "400px"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "partner"><#assign startleft= "250px"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "showcart"><#assign startleft= "880px"></#if>
                      </#if>
                      <div id="selected" style="margin-left:${startleft?default("25px")}"></div>
                      <div id="searchbar">
                         <table align="left" valign="bottom">
                              <tbody>
                                  <tr>
                                      <td width="250px" height="50px">
                                        <div id="searchbartitle">${uiLabelMap.PFTSearchYourProducts}</div>
                                      </td>
                                  </tr>
                              </tbody>
                          </table>
                          <table align="left" valign="top">
                              <tbody>
                                  <tr>
                                      <td width="650px">${screens.render("component://productfromthailand/widget/CatalogScreens.xml#keywordsearchbox")}</td>
                                  </tr>
                              </tbody>
                          </table>
                      </div>
                  </td>
              </tr>
              <#--tr>
                  <td bgcolor="white" width="800" height="40" align="right">
                      <div id="right">
                      ${screens.render("component://productfromthailand/widget/CartScreens.xml#microcart")}
                    </div>
                </td>
              </tr-->
          </tbody>
      </table>
    </div>
    <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
              <tr>
                  <td bgcolor="white" width="955px">
