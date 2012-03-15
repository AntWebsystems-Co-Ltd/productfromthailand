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
<script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
    try {
        var pageTracker = _gat._getTracker("UA-11027029-1");
        pageTracker._trackPageview();
    } catch(err) {}
</script>

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
            <ul id="right-links">
            <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
                  <#if security.hasEntityPermission("MYPORTAL", "_SUPPLIER", session)>
                    <li id="header-bar-store"><a href="<@ofbizUrl>../../myportal</@ofbizUrl>"><div class="menu-right">${uiLabelMap.PFTStoreManagement}</div></a></li>
                  <#else>
                    <li id="header-bar-account"><a href="<@ofbizUrl>viewprofile</@ofbizUrl>"><div class="menu-right">${uiLabelMap.PFTYourAccount}</div></a></li>
                  </#if>
                <li id="header-bar-logout"><a href="<@ofbizUrl>logout</@ofbizUrl>"><div class="menu-right">${uiLabelMap.CommonLogout}</div></a></li>
            <#else/>
                <li id="header-bar-login">
                <a href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>"><div class="menu-right">${uiLabelMap.PFTSignIn}</div></a><div class="menu-right"> ${uiLabelMap.PFTOr}</div> <a href="<@ofbizUrl>register</@ofbizUrl>"><div class="menu-right"> ${uiLabelMap.PFTRegister}</div></a>
                </li>
            </#if>
            <#if sessionAttributes.autoName?has_content>
            ${uiLabelMap.CommonWelcome}&nbsp;${sessionAttributes.autoName?html}!
            (${uiLabelMap.CommonNotYou}?&nbsp;<a href="<@ofbizUrl>autoLogout</@ofbizUrl>" class="linktext">${uiLabelMap.CommonClickHere}</a>)
            <#else/>
            ${uiLabelMap.CommonWelcome}!
            </#if>&nbsp;&nbsp;
            <#if parameters.locale?default("en")=="th">
                <a href="<@ofbizUrl>setSessionLocale?newLocale=en</@ofbizUrl>"><img class="top-menu" src="<@ofbizContentUrl>/pft-default/pftimages/flags/en.jpg</@ofbizContentUrl>" alt="English"/></a>
            <#else>
                <a href="<@ofbizUrl>setSessionLocale?newLocale=th</@ofbizUrl>"><img class="top-menu" src="<@ofbizContentUrl>/pft-default/pftimages/flags/th.png</@ofbizContentUrl>" alt="Thai"/></a>
            </#if>
            </ul>
            <#--assign availableLocales = Static["org.ofbiz.base.util.UtilMisc"].availableLocales()/>
            <#list availableLocales as availableLocale>
                <#if locale.toString() == availableLocale.toString()>
                    <#if locale.toString() == "en">
                        <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=th"><img src="<@ofbizContentUrl>/pft-default/pftimages/ThaiFlag.jpg</@ofbizContentUrl>" alt="Thai" width="25"/></a>
                    <#elseif locale.toString() == "th">
                        <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=en"><img src="<@ofbizContentUrl>/pft-default/pftimages/EngFlag.jpg</@ofbizContentUrl>"  alt="English" width="25"/></a>
                    </#if>
                </#if>
            </#list>
            <#if locale.toString() == "en_US">
                <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=th"><img  src="<@ofbizContentUrl>/pft-default/pftimages/ThaiFlag.jpg</@ofbizContentUrl>" alt="Thai" width="25"/></a>
            </#if-->
        </div>
        <#-- Twitter share  -->
        <div id="google-plus-top">
            <iframe allowtransparency="true" frameborder="0" scrolling="no"
            src="http://platform.twitter.com/widgets/follow_button.html?screen_name=Product_Thai&link_color=BCB104"
            style="width:150px; height:20px;">Follow @Product_Thai</iframe>
            <span class="twitter-share">
                <a href="http://twitter.com/share" class="twitter-share-button" data-count="none" data-via="Product_Thai">Tweet</a>
                <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
                <script type="text/javascript">
                    jQuery(".twitter-share-button").each(function(index) {
                        iframeSrc = jQuery(jQuery(".twitter-share-button")[index]).attr("src");
                        if (iframeSrc) {
                            if (iframeSrc.substring(0, 5) == "https") {
                                iframeSrc = "http" + iframeSrc.substring(5, iframeSrc.length);
                                jQuery(jQuery(".twitter-share-button")[index]).attr("src", iframeSrc);
                            }
                        }
                    });
                </script>
            </span>
            <span class="google-one-ck">
                <g:plusone size="medium" count="false"></g:plusone>
            </span>
            <script type="text/javascript">
              (function() {
                var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                po.src = 'https://apis.google.com/js/plusone.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
              })();
            </script>
            <br/>
        </div>
        <div style="height:12px;">
           <#assign shoppingCart = sessionAttributes.shoppingCart?if_exists>
           <#if shoppingCart?has_content>
                <#assign shoppingCartSize = shoppingCart.size()>
                <#else>
                <#assign shoppingCartSize = 0>
           </#if>
          <#--if (shoppingCartSize > 0)>
               <#if shoppingCart?has_content && (shoppingCart.getGrandTotal() > 0)>
                 <a href="<@ofbizUrl>setPayPalCheckout</@ofbizUrl>"><img style="height:35px;" src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif" alt="[PayPal Express Checkout]" /></a>
               </#if>
          </#if-->
       </div>
       <#--div class="currencyprice">
            
        </div-->
        <div class="currencyprice">
            <#--ul id="right-links">
                <li id="header-bar-sitemap"><a href="<@ofbizUrl>sitemap</@ofbizUrl>"><div class="menu-right">${uiLabelMap.PFTSitemap}</div></a></li>
                <li id="header-bar-help"><a href="<@ofbizUrl>help</@ofbizUrl>"><div class="menu-right">${uiLabelMap.PFTHelpAndInstruction}</div></a></li>
            </ul-->
            ${uiLabelMap.PFTSwitchCurrency} : 
            <a href="<@ofbizUrl>setSessionCurrencyUom?currencyUom=THB</@ofbizUrl>"><img src="<@ofbizContentUrl>/pft-default/pftimages/flags/flag_th.png</@ofbizContentUrl>"/></a>
            <a href="<@ofbizUrl>setSessionCurrencyUom?currencyUom=USD</@ofbizUrl>"><img src="<@ofbizContentUrl>/pft-default/pftimages/flags/flag_us.png</@ofbizContentUrl>"/></a>
            <a href="<@ofbizUrl>setSessionCurrencyUom?currencyUom=EUR</@ofbizUrl>"><img src="<@ofbizContentUrl>/pft-default/pftimages/flags/flag_euro.png</@ofbizContentUrl>"/></a>
        </div>
    </div>
  </div>
<div id="main">
  <div id="ecom-header-bar">
      <div class="leftcorner">&nbsp;</div>
      <div class="rightcorner">&nbsp;</div><div style="clear:both;"/>
      <div class="whitespace">
            <#if requestAttributes._CURRENT_VIEW_?has_content>
                        <#if requestAttributes._CURRENT_VIEW_ == "main"><#assign headerId= "home"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "products"><#assign headerId= "products"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "services"><#assign headerId= "services"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "partner"><#assign headerId= "partner"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "aboutus"><#assign headerId= "aboutus"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "contactus"><#assign headerId= "contactus"></#if>
                        <#if requestAttributes._CURRENT_VIEW_ == "showcart"><#assign headerId= "showcart"></#if>
           </#if>
      <div id="menubar">
            <ul id="right-links">
              <!-- NOTE: these are in reverse order because they are stacked right to left instead of left to right -->
              <li class="headermenu" <#if headerId?if_exists == "home">id="${headerId}"</#if> ><a href="<@ofbizUrl>main</@ofbizUrl>">${uiLabelMap.PFTHome}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "products">id="${headerId}"</#if> ><a href="<@ofbizUrl>products</@ofbizUrl>">${uiLabelMap.PFTProducts}</a></li>
              <li class="headermenu" <#if headerId?if_exists  == "services">id="${headerId}"</#if> ><a href="<@ofbizUrl>services</@ofbizUrl>">${uiLabelMap.PFTServices}</a></li>
              <li class="headermenu" <#if headerId?if_exists  == "partner">id="${headerId}"</#if> ><a href="<@ofbizUrl>partner</@ofbizUrl>">${uiLabelMap.PFTPartner}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "aboutus">id="${headerId}"</#if> ><a href="<@ofbizUrl>aboutus</@ofbizUrl>">${uiLabelMap.PFTAboutUs}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "contactus">id="${headerId}"</#if> ><a href="<@ofbizUrl>contactus</@ofbizUrl>">${uiLabelMap.PFTContact}</a></li>
              <li class="headermenu" <#if headerId?if_exists == "help">id="${headerId}"</#if> ><a href="<@ofbizUrl>help</@ofbizUrl>">${uiLabelMap.PFTHelpAndInstruction}</a></li>
            </ul>
            <ul id="left-links">
                <li class="headermenu" <#if headerId?if_exists == "showcart">id="${headerId}"</#if> >
                <a href="<@ofbizUrl>view/showcart</@ofbizUrl>">${uiLabelMap.OrderViewCart}
                 <#if (shoppingCartSize > 0)>
                    <#-- show current currency -->
                    <#assign rateResult = dispatcher.runSync("getFXConversion", Static["org.ofbiz.base.util.UtilMisc"].toMap("uomId", shoppingCart.getCurrency(), "uomIdTo", currencyUom, "userLogin", userLogin?default(defaultUserLogin)))/>
                    <#assign conversionRate = rateResult.conversionRate>
                    <#assign grandTotal = shoppingCart.getGrandTotal()*conversionRate>
                       <span style="font-size:0.7em"> (${shoppingCart.getTotalQuantity()} : 
                        <#if shoppingCart.getTotalQuantity() == 1>${uiLabelMap.OrderItem}<#else/>${uiLabelMap.OrderItems}</#if>,
                        <#--@ofbizCurrency amount=shoppingCart.getGrandTotal() isoCode=shoppingCart.getCurrency()/-->
                        <@ofbizCurrency amount=grandTotal isoCode=currencyUom/>
                        )</span>
                 </#if>
                </a>
                </li>
            </ul>
     </div>
     <div id="searchbar">
           ${screens.render("component://productfromthailand/widget/CatalogScreens.xml#keywordsearchbox")}
    </div>
    </div>
</div>
<div class="whitespace">