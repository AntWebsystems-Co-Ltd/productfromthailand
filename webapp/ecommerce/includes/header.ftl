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
    <table cellspacing="0" cellpadding="0" border="0" height="80">
        <tbody>
            <tr>
                <td align="left" width="200" valign="top">
                    <div id="left">
                          <#if sessionAttributes.overrideLogo?exists>
                            <img src="<@ofbizContentUrl>${sessionAttributes.overrideLogo}</@ofbizContentUrl>" alt="Logo"/>
                          <#elseif catalogHeaderLogo?exists>
                            <img src="<@ofbizContentUrl>${catalogHeaderLogo}</@ofbizContentUrl>" alt="Logo"/>
                          <#elseif layoutSettings.VT_HDR_IMAGE_URL?has_content>
                            <img src="<@ofbizContentUrl>${layoutSettings.VT_HDR_IMAGE_URL.get(0)}</@ofbizContentUrl>" alt="Logo"/>
                          </#if>
                    </div>
                </td>
                <td align="right" width="600" valign="bottom">
                    <div id="ecom-header-bar">
                      <table align="right">
                        <tbody>
                            <tr>
                                <td>
                                    <table align="right">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <ul id="left-links">
                                                      <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
                                                        <li id="header-bar-logout"><a href="<@ofbizUrl>logout</@ofbizUrl>"><h2>${uiLabelMap.CommonLogout}</h2></a></li>
                                                      <#else/>
                                                        <li id="header-bar-login"><a href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>"><h2>${uiLabelMap.CommonLogin}</h2></a></li>
                                                        <li id="header-bar-login"><a href="<@ofbizUrl>newcustomer</@ofbizUrl>"><h2>${uiLabelMap.PFTRegister}</h2></a></li>
                                                      </#if>
                                                      <li id="header-bar-contactus"><a href="<@ofbizUrl>contactus</@ofbizUrl>"><h2>${uiLabelMap.CommonContactUs}</h2></a></li>
                                                      <li id="header-bar-main"><a href="<@ofbizUrl>main</@ofbizUrl>"><h2>${uiLabelMap.CommonMain}</h2></a></li>
                                                    </ul>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="right">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div id="welcome-message">
                                                        <#if sessionAttributes.autoName?has_content>
                                                        ${uiLabelMap.CommonWelcome}&nbsp;${sessionAttributes.autoName?html}!
                                                        (${uiLabelMap.CommonNotYou}?&nbsp;<a href="<@ofbizUrl>autoLogout</@ofbizUrl>" class="linktext">${uiLabelMap.CommonClickHere}</a>)
                                                        <#else/>
                                                        ${uiLabelMap.CommonWelcome}!
                                                        </#if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
<div id="main">
  <div id="ecom-header">
      <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
              <tr>
                  <td background="/pft/images/bg01.gif" width="800" align="center">
                      <br>
                      <div id="menubar">
                        <ul id="right-links">
                          <!-- NOTE: these are in reverse order because they are stacked right to left instead of left to right -->
                          <#if !userLogin?has_content || (userLogin.userLoginId)?if_exists != "anonymous">
                            <li id="header-bar-viewprofile"><a href="<@ofbizUrl>viewprofile</@ofbizUrl>"><h1>${uiLabelMap.CommonProfile}</h1></a></li>
                            <li id="header-bar-ListQuotes"><a href="<@ofbizUrl>ListQuotes</@ofbizUrl>"><h1>${uiLabelMap.OrderOrderQuotes}</h1></a></li>
                            <li id="header-bar-ListRequests"><a href="<@ofbizUrl>ListRequests</@ofbizUrl>"><h1>${uiLabelMap.OrderRequests}</h1></a></li>
                            <li id="header-bar-editShoppingList"><a href="<@ofbizUrl>editShoppingList</@ofbizUrl>"><h1>${uiLabelMap.EcommerceShoppingLists}</h1></a></li>
                            <li id="header-bar-orderhistory"><a href="<@ofbizUrl>orderhistory</@ofbizUrl>"><h1>${uiLabelMap.EcommerceOrderHistory}</h1></a></li>
                          </#if>
                          <#if catalogQuickaddUse>
                            <li id="header-bar-quickadd"><a href="<@ofbizUrl>quickadd</@ofbizUrl>"><h1>${uiLabelMap.CommonQuickAdd}</h1></a></li>
                          </#if>
                        </ul>
                      </div>
                      <div id="searchbar">
                         <table align="left"  valign="bottom">
                              <tbody>
                                  <tr>
                                      <td width="190" height="50"><h3>Search Your Products</h3></td>
                                  </tr>
                              </tbody>
                          </table>
                          <table align="right">
                              <tbody>
                                  <tr>
                                      <td>${screens.render("component://productfromthailand/widget/CatalogScreens.xml#choosecatalog")}</td>
                                      <td>${screens.render("component://productfromthailand/widget/CatalogScreens.xml#keywordsearchbox")}</td>
                                  </tr>
                              </tbody>
                          </table>
                      </div>
                  </td>
              </tr>
              <tr>
                  <td bgcolor="white" width="800" height="40" align="right">
                      <div id="right">
                      ${screens.render("component://productfromthailand/widget/CartScreens.xml#microcart")}
                    </div>
                </td>
              </tr>
          </tbody>
      </table>
    </div>
    <table cellspacing="0" cellpadding="0" border="0">
          <tbody>
              <tr>
                  <td bgcolor="white" width="800">