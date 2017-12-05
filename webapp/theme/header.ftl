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

<!doctype html>
<#assign docLangAttr = locale.toString()?replace("_", "-")>
<#assign langDir = "ltr">
<#if "ar.iw"?contains(docLangAttr?substring(0, 2))>
    <#assign langDir = "rtl">
</#if>
<html lang="${docLangAttr}" dir="${langDir}" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>${(productStore.storeName)!} : <#if title?has_content>${title}<#elseif titleProperty?has_content>${uiLabelMap.get(titleProperty)}</#if></title>

    <#if layoutSettings.VT_SHORTCUT_ICON?has_content>
        <#assign shortcutIcon = layoutSettings.VT_SHORTCUT_ICON.get(0)/>
    <#elseif layoutSettings.shortcutIcon?has_content>
        <#assign shortcutIcon = layoutSettings.shortcutIcon/>
    </#if>
    <#if shortcutIcon?has_content>
        <link rel="shortcut icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)}</@ofbizContentUrl>"/>
    </#if>
    <#if layoutSettings.styleSheets?has_content>
    <#--layoutSettings.styleSheets is a list of style sheets. So, you can have a user-specified "main" style sheet,
        AND a component style sheet.-->
        <#list layoutSettings.styleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>"
                type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_STYLESHEET?has_content>
        <#list layoutSettings.VT_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>"
                type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.rtlStyleSheets?has_content && langDir == "rtl">
        <#--layoutSettings.rtlStyleSheets is a list of rtl style sheets.-->
        <#list layoutSettings.rtlStyleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>"
                type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_RTL_STYLESHEET?has_content && langDir == "rtl">
        <#list layoutSettings.VT_RTL_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>"
                type="text/css"/>
        </#list>
    </#if>
    <#-- Append CSS for catalog -->
    <#if catalogStyleSheet??>
        <link rel="stylesheet" href="${StringUtil.wrapString(catalogStyleSheet)}" type="text/css"/>
    </#if>
    <#-- Append CSS for tracking codes -->
    <#if sessionAttributes.overrideCss??>
        <link rel="stylesheet" href="${StringUtil.wrapString(sessionAttributes.overrideCss)}" type="text/css"/>
    </#if>
    <#if layoutSettings.VT_HDR_JAVASCRIPT?has_content>
        <#list layoutSettings.VT_HDR_JAVASCRIPT as javaScript>
            <script type="text/javascript"
            src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>"></script>
        </#list>
    </#if>
    <#if layoutSettings.javaScripts?has_content>
        <#--layoutSettings.javaScripts is a list of java scripts. -->
        <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
        <#assign javaScriptsSet = Static["org.apache.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
        <#list layoutSettings.javaScripts as javaScript>
            <#if javaScriptsSet.contains(javaScript)>
                <#assign nothing = javaScriptsSet.remove(javaScript)/>
                <script type="text/javascript"
                    src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>"></script>
            </#if>
        </#list>
    </#if>
    ${layoutSettings.extraHead!}
    <#if layoutSettings.VT_EXTRA_HEAD?has_content>
        <#list layoutSettings.VT_EXTRA_HEAD as extraHead>
            ${extraHead}
        </#list>
    </#if>

    <#-- Meta tags if defined by the page action -->
    <meta name="generator" content="Apache OFBiz - eCommerce"/>
    <#if metaDescription??>
        <meta name="description" content="${metaDescription}"/>
    </#if>
    <#if metaKeywords??>
        <meta name="keywords" content="${metaKeywords}"/>
    </#if>
    <#if webAnalyticsConfigs?has_content>
        <script language="JavaScript" type="text/javascript">
            <#list webAnalyticsConfigs as webAnalyticsConfig>
                <#if  webAnalyticsConfig.webAnalyticsTypeId != "BACKEND_ANALYTICS">
                    ${StringUtil.wrapString(webAnalyticsConfig.webAnalyticsCode!)}
                </#if>
            </#list>
        </script>
    </#if>
    <meta charset="utf-8">
    <#--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
    <![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>${layoutSettings.companyName!}: <#if (titleProperty)?has_content>${uiLabelMap[titleProperty]}<#else>${title!}</#if></title>

    <#if layoutSettings.styleSheets?has_content>
        <#list layoutSettings.styleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" media="screen,projection" type="text/css" charset="UTF-8"/>
        </#list>
    </#if>
    <script>
    <#-- wishlist script -->
        function addToWishlist(form,productName) {
        <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
            $.ajax({
                url: form.action,
                type: 'POST',
                data: $(form).serialize(),
                async: false,
                success: function(data) {
                    alert(" \""+productName+"\" ${StringUtil.wrapString(uiLabelMap.PFTThisProductAddedToWishListSuccessful)}");
                }
            });
        <#else>
            alert("${uiLabelMap.CommonRequired} ${uiLabelMap.CommonLogin}");
        </#if>
        }
        function setCurrency(currency) {
            $.ajax({
                url: '<@ofbizUrl>setSessionCurrencyUom</@ofbizUrl>',
                type: 'POST',
                data: {currencyUom : currency},
                async: false,
                success: function(data) {
                    location.reload();
                }
            });
        }
     </script>
     <!-- Global site tag (gtag.js) - Google Analytics -->
     <script async src="https://www.googletagmanager.com/gtag/js?id=UA-109836501-1"></script>
     <script>
       window.dataLayer = window.dataLayer || [];
       function gtag(){dataLayer.push(arguments);}
       gtag('js', new Date());
       gtag('config', 'UA-109836501-1');
     </script>
</head>
<body>
<div id="wait-spinner" style="display: none; left: 0px; top: 1057px;">
    <div id="wait-spinner-image"></div>
</div>
<#-- Header Section Starts -->
    <header id="header-area">
    <#-- Header Top Starts -->
        <div class="header-top">
            <div class="container">
            <#-- Header Links Starts -->
                <div class="col-sm-10 col-xs-12">
                    <div class="header-links">
                        <ul class="nav navbar-nav pull-left">
                            <li>
                                <a href="<@ofbizUrl>main</@ofbizUrl>">
                                    <i class="fa fa-home" title="${uiLabelMap.PFTHome}"></i>
                                    <span class="hidden-sm hidden-xs">${uiLabelMap.PFTHome}</span>
                                </a>
                            </li>
                            <li>
                                <a href="<@ofbizUrl>WishList</@ofbizUrl>">
                                    <i class="fa fa-heart" title="" data-original-title="Wish List"></i>
                                    <span class="hidden-sm hidden-xs">${uiLabelMap.PFTWishList}</span>
                                </a>
                            </li>
                            <li>
                                <a href="<@ofbizUrl>view/showcart</@ofbizUrl>">
                                    <i class="fa fa-shopping-cart" title="${uiLabelMap.PageTitleShoppingCart}"></i>
                                    <span class="hidden-sm hidden-xs">
                                        ${uiLabelMap.PageTitleShoppingCart}
                                    </span>
                                </a>
                            </li>
                            <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
                                <li>
                                    <a href="<@ofbizUrl>viewprofile</@ofbizUrl>">
                                        <i class="fa fa-user-circle" title="${uiLabelMap.PFTMyAccount}"></i>
                                        <span class="hidden-sm hidden-xs">
                                            <#if loginName.groupName?has_content>
                                                <#if parameters.locale == "th">
                                                    ${uiLabelMap.PFTHeaderAccount} ${loginName.groupName}
                                                <#else>
                                                    ${loginName.groupName} ${uiLabelMap.PFTHeaderAccount}
                                                </#if>
                                            <#elseif loginName.firstName?has_content>
                                                <#if parameters.locale == "th">
                                                    ${uiLabelMap.PFTHeaderAccount} ${loginName.firstName}  ${loginName.lastName}
                                                <#else>
                                                    ${loginName.firstName}  ${loginName.lastName} ${uiLabelMap.PFTHeaderAccount}
                                                </#if>
                                            <#else>
                                                ${uiLabelMap.PFTMyAccount}
                                            </#if>
                                        </span>
                                    </a>
                                </li>
                                <#if supplierRole?has_content>
                                    <li>
                                        <a href="<@ofbizUrl>StoreManagement?partyId=${userLogin.partyId!}</@ofbizUrl>">
                                            <i class="fa fa-cube" title="${uiLabelMap.PFTStoreManagement}"></i>
                                            <span class="hidden-sm hidden-xs">
                                                ${uiLabelMap.PFTStoreManagement}
                                            </span>
                                        </a>
                                    </li>
                                </#if>
                                <li>
                                    <a href="<@ofbizUrl>logout</@ofbizUrl>">
                                        <i class="fa fa-lock" title="${uiLabelMap.CommonLogout}"></i>
                                        <span class="hidden-sm hidden-xs">
                                            ${uiLabelMap.CommonLogout}
                                        </span>
                                    </a>
                                </li>
                            <#else/>
                                <li>
                                    <a href="<@ofbizUrl>register</@ofbizUrl>">
                                        <i class="fa fa-unlock" title="${uiLabelMap.PFTRegister}"></i>
                                        <span class="hidden-sm hidden-xs">
                                            ${uiLabelMap.PFTRegister}
                                        </span>
                                    </a>
                                </li>
                                <li>
                                    <a href="<@ofbizUrl>checkLogin</@ofbizUrl>">
                                        <i class="fa fa-lock" title="${uiLabelMap.PFTSignIn}"></i>
                                        <span class="hidden-sm hidden-xs">
                                            ${uiLabelMap.PFTSignIn}
                                        </span>
                                    </a>
                                </li>
                            </#if>
                        </ul>
                    </div>
                </div>
            <#-- Header Links Ends -->
            <#-- Currency & Languages Starts -->
                <div class="col-sm-2 col-xs-12">
                    <div class="pull-right">
                    <#-- Currency Starts -->
                        <div class="btn-group">
                            <button class="btn btn-link dropdown-toggle" data-toggle="dropdown">
                                <#if currencyUom == "THB">${uiLabelMap.PFTCurrency} : ฿
                                <#elseif currencyUom == "USD">${uiLabelMap.PFTCurrency} : $
                                <#elseif currencyUom == "EUR">${uiLabelMap.PFTCurrency} : €
                                </#if>
                                <i class="fa fa-caret-down"></i>
                            </button>
                            <ul class="pull-right dropdown-menu">
                                <li><a tabindex="-1" href="javascript: setCurrency('THB');">${uiLabelMap.CurrencyNameThaiBaht}</a></li>
                                <li><a tabindex="-1" href="javascript: setCurrency('USD');">${uiLabelMap.CurrencyNameUSDollar}</a></li>
                                <li><a tabindex="-1" href="javascript: setCurrency('EUR');">${uiLabelMap.CurrencyNameEuro}</a></li>
                            </ul>
                        </div>
                    <#-- Currency Ends -->
                    <#-- Languages Starts -->
                        <div class="btn-group" style="padding-top: 10px; padding-bottom: 10px">
                            <span><a href="<@ofbizUrl>setSessionLocale?newLocale=en</@ofbizUrl>"><img src="<@ofbizContentUrl>/pft-default/pftimages/flags/en.jpg</@ofbizContentUrl>" alt="English"/></a></span>
                            <span><a href="<@ofbizUrl>setSessionLocale?newLocale=th</@ofbizUrl>"><img src="<@ofbizContentUrl>/pft-default/pftimages/flags/th.png</@ofbizContentUrl>" alt="Thai"/></a></span>
                        </div>
                    <#-- Languages Ends -->
                    </div>
                </div>
            <#-- Currency & Languages Ends -->
            </div>
        </div>
    <#-- Header Top Ends -->
    <#-- Starts -->
        <div class="container">
        <#-- Main Header Starts -->
            <div class="main-header">
                <div class="row">
                <#-- Logo Starts -->
                    <div class="col-md-4">
                        <div id="logo">
                            <a href="<@ofbizUrl>main</@ofbizUrl>">
                                <img src="<@ofbizContentUrl>${layoutSettings.VT_HDR_IMAGE_URL.get(0)}</@ofbizContentUrl>" title="Product From Thailand" alt="Logo" class="img-responsive"/>
                            </a>
                        </div>
                    </div>
                <#-- Logo Starts -->
                <#-- Shopping Cart Starts -->
                    <#assign shoppingCart = sessionAttributes.shoppingCart!>
                    <#if shoppingCart?has_content>
                      <#assign shoppingCartSize = shoppingCart.size()>
                    <#else>
                      <#assign shoppingCartSize = 0>
                    </#if>
                    <div class="col-md-4">
                        ${screens.render("component://productfromthailand/widget/CartScreens.xml#cartontop")}
                    </div>
                <#-- Shopping Cart Ends -->
                <#-- Search Starts -->
                    <div class="col-md-4">
                        <div id="search">
                            <div class="input-group">
                                <form name="keywordsearchform" id="keywordsearchform" method="post" action="<@ofbizUrl>keywordsearch</@ofbizUrl>" style="margin: 0;">
                                    <input type="hidden" name="VIEW_SIZE" value="5"/>
                                    <input type="hidden" name="PAGING" value="Y"/>
                                    <input type="hidden" name="SEARCH_OPERATOR" value="OR"/>
                                    <input type="text" name="SEARCH_STRING" class="form-control input-lg" placeholder="${uiLabelMap.CommonSearch}" value="${requestParameters.SEARCH_STRING!}">
                                </form>
                                <span class="input-group-btn">
                                    <button class="btn btn-lg" type="button" onclick="document.getElementById('keywordsearchform').submit()">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </span>
                            </div>
                        </div>
                    </div>
                <#-- Search Ends -->
                </div>
            </div>
        <#-- Main Header Ends -->
        <#-- Main Menu Starts -->
            <nav id="main-menu" class="navbar" role="navigation">
            <#-- Nav Header Starts -->
                <div class="navbar-header">
                    <button type="button" class="btn btn-navbar navbar-toggle" data-toggle="collapse" data-target=".navbar-cat-collapse">
                        <span class="sr-only">Toggle Navigation</span>
                        <i class="fa fa-bars"></i>
                    </button>
                </div>
            <#-- Nav Header Ends -->
            <#-- Navbar Cat collapse Starts -->
                <div class="collapse navbar-collapse navbar-cat-collapse">
                    <ul class="nav navbar-nav">
                        <#if (completedTree?has_content)>
                            <#list completedTree?sort_by("productCategoryId") as root>
                                <#if !root.child?has_content>
                                   <#if parameters.category_id?has_content>
                                          <li <#if root.productCategoryId == parameters.category_id> class="selected"</#if> >
                                       <#else>
                                       <li>
                                    </#if>
                                        <a href="<@ofbizUrl>categorylist?productCategoryId=${root.productCategoryId!}</@ofbizUrl>"><#if root.categoryName??>${root.categoryName?js_string}<#elseif root.categoryDescription??>${root.categoryDescription?js_string}<#else>${root.productCategoryId?js_string}</#if></a>
                                    </li>
                                <#else>
                                    <li class="dropdown">
                                        <a href="<@ofbizUrl>categorylist?productCategoryId=${root.productCategoryId!}</@ofbizUrl>" class="dropdown-toggle" data-hover="dropdown" data-delay="10">
                                        <#if root.categoryName??>${root.categoryName?js_string}<#elseif root.categoryDescription??>${root.categoryDescription?js_string}<#else>${root.productCategoryId?js_string}</#if>
                                        </a>
                                        <ul class="dropdown-menu" role="menu">
                                        <#list root.child as childRoot>
                                            <li><a tabindex="-1" href="<@ofbizUrl>categorylist?productCategoryId=${childRoot.productCategoryId!}</@ofbizUrl>">
                                                <#if childRoot.categoryName??>${childRoot.categoryName?js_string}<#elseif childRoot.categoryDescription??>${childRoot.categoryDescription?js_string}<#else>${childRoot.productCategoryId?js_string}</#if>
                                            </a></li>
                                        </#list>
                                        </ul>
                                    </li>
                                </#if>
                            </#list>
                        </#if>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-delay="10">
                                ${uiLabelMap.PFTPages}
                            </a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a tabindex="-1" href="<@ofbizUrl>main</@ofbizUrl>">${uiLabelMap.PFTHome}</a></li>
                                <li><a tabindex="-1" href="<@ofbizUrl>partner</@ofbizUrl>">${uiLabelMap.PFTPartner}</a></li>
                                <li><a tabindex="-1" href="<@ofbizUrl>aboutus</@ofbizUrl>">${uiLabelMap.PFTAboutUs}</a></li>
                                <li><a tabindex="-1" href="<@ofbizUrl>trackingShipment</@ofbizUrl>">${uiLabelMap.PFTTrackingShipment}</a></li>
                                <li><a tabindex="-1" href="<@ofbizUrl>AnonContactus</@ofbizUrl>">${uiLabelMap.PFTContact}</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            <#-- Navbar Cat collapse Ends -->
            </nav>
        <#-- Main Menu Ends -->
        </div>
    <#-- Ends -->
    </header>
<#-- Header Section Ends -->
