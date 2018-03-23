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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title>${title?if_exists}</title>
  <style type="text/css">
    td {
      color: #777777;
    }

    .header-social{
      text-align: center;
      vertical-align:middle;
    }

    .header-logo {
      vertical-align:middle;
    }

    .footer {
      background-color: #f7f7f7;
      height: 100px;
    }

    .footer-address {
      padding: 25px 0 25px
    }

    .blank_row {
      height: 10px !important; /* overwrites any other rules */
    }
    .btn-main{
        color: #fff;
        background-color: #ff434a;
        text-decoration: inherit;
    }
    .button_text {
        -webkit-appearance: button;
        display: inline-block;
        padding: 6px 12px;
        margin-bottom: 0;
        font-size: 14px;
        font-weight: 400;
        line-height: 1.42857143;
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        touch-action: manipulation;
        cursor: pointer;
        user-select: none;
        background-image: none;
        border: 1px solid transparent;
        border-radius: 4px;
    }
    .textalert{
        color: #e85258;
        font-size: 20px;
    }
  </style>
</head>
<body bgcolor="#f7f7f7">
<#if parameters.localeValue?has_content>
    <#assign locale = Static["org.apache.ofbiz.base.util.UtilMisc"].parseLocale(parameters.localeValue)!>
<#else>
    <#assign locale = Static["org.apache.ofbiz.base.util.UtilMisc"].parseLocale("en")!>
</#if>
<#if parameters.lastCurrencyUom?has_content>
    <#assign lastCurrencyUom = parameters.lastCurrencyUom>
<#else>
    <#assign lastCurrencyUom = 'THB'>
</#if>
<#assign uiLabelMap = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("ProductFromThailandUiLabels", locale)>
<table align="center" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td align="left" valign="top" width="100%" class="bg-top">
      <center>
        <table cellspacing="0" cellpadding="0" width="100%" background="${baseURL}/pft-default/pftimages/bg_top.jpg">
          <tr>
            <td style="text-align:center;">
                <a href=""><img height="80%" src="${logoImageUrl}" alt="logo"/></a>
            </td>
          </tr>
        </table>
      </center>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="100%" bgcolor="#f7f7f7">
      <center>
        <table cellspacing="0" cellpadding="0" width="600">
          <tr class="blank_row'>
              <td colspan="3"><br/></td>
          </tr>
          <tr>
             <td>${uiLabelMap.PFTHelloRemind} ${parameters.customerName!},</td>
          </tr>
          <tr>
              <td colspan="3"><br/></td>
          </tr>
          <tr>
            <td>
              <#if locale == "en">
                  ${uiLabelMap.PFTDontforgetEn}, ${parameters.customerName!}. ${uiLabelMap.PFTDontforget}
              <#else>
                  ${uiLabelMap.PFTDontforget}
              </#if>
            </td>
          </tr>
          <tr>
              <td colspan="3"><br/></td>
          </tr>
          <tr>
            <td class="textalert">
              <center>
                  ${uiLabelMap.PFTShoppingNow}
              </center>
            </td>
          </tr>
          <tr>
              <td colspan="3"><br/></td>
          </tr>
          <tr>
            <td>
              <center>
              <table cellspacing="0" cellpadding="0" width="70%">
                  <#list listProduct as shoppingItem>
                      <tr>
                          <#assign product = EntityQuery.use(delegator).from("Product").where("productId", shoppingItem.productId).queryOne()!>
                          <#if product.isVariant.equals("Y")>
                              <#assign productAssoc = EntityQuery.use(delegator).from("ProductAssoc").where("productIdTo", shoppingItem.productId).queryFirst()!>
                              <#assign productTo = EntityQuery.use(delegator).from("Product").where("productId", productAssoc.productId).queryOne()!>
                              <#assign productId = productTo.productId>
                          <#else>
                              <#assign productId = shoppingItem.productId>
                          </#if>
                          <#assign productItem = EntityQuery.use(delegator).from("Product").where("productId", productId).queryOne()!>
                          <#assign productName = Static['org.apache.ofbiz.product.product.ProductContentWrapper'].getProductContentAsText(productItem, 'PRODUCT_NAME', locale, dispatcher, "html")?if_exists>
                          <#assign smallImageUrl = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(productItem, "SMALL_IMAGE_URL", locale, dispatcher, "html")?if_exists />
                          <#assign baseCurrencyUomId = (delegator.findOne("PartyAcctgPreference", {"partyId" : parameters.webSiteId}, true))?default('THB')>
                          <#assign result = dispatcher.runSync("calculateProductPrice", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("product", productItem, "userLogin", userLogin, "locale", locale, "currencyUomIdTo", lastCurrencyUom, "currencyUomId", baseCurrencyUomId))/>
                          <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/pft-default/images/defaultImage.jpg" /></#if>
                                  <#if smallImageUrl?string?has_content>
                                      <td>
                                          <img src="${baseURL}${StringUtil.wrapString(smallImageUrl)!}" alt="productImage" width="65" height="65"/>
                                      </td>
                                  </#if>
                            <#if product?has_content>
                                <td>${StringUtil.wrapString(productName)!}</td>
                                <td><@ofbizCurrency amount=result.price isoCode=result.currencyUsed/></td>
                            </#if>
                      </tr>
                  </#list>
              </table>
              </center>
            </td>
          </tr>
          <tr>
              <td colspan="3"><br></td>
          </tr>
          <tr>
              <td colspan="3">
                  <center>
                  <a href="${baseURL}/control/showcartView" class="button_text btn-main">${uiLabelMap.PFTGotoyourshoppingCart}</a>
                  </center>
               </td>
          </tr>
          <tr>
              <td colspan="3"><br></td>
          </tr>
        </table>
      </center>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="100%" class="footer">
      <center>
        <table cellspacing="0" cellpadding="0" width="600">
            <tr>
                <td align="center"><center><hr width="70%"></center></td>
            </tr>
          <tr>
              <td align="center" >${uiLabelMap.PFTContact}</td>
          </tr>
          <tr>
              <td colspan="3"><br></td>
          </tr>
          <tr>
            <td align="center">
                <a href="https://www.facebook.com/Careelnatural/"><img width="48" height="47" src="${baseURL}/pft-default/pftimages/social_facebook_icon.gif" alt="facebook"/></a>
                <a href="https://twitter.com/Product_Thai/"><img width="44" height="47" src="${baseURL}/pft-default/pftimages/social_twitter_icon.gif" alt="twitter"/></a>
            </td>
          </tr>
              <br/>
          <tr>
            <td align="center">
              <strong>Product From Thailand</strong><br />
              73/1 M.8, Soi AntWebsystems Tambon Sanklang, Amphur Sanpatong<br />
              Chiang Mai, Thailand 50120 <br /><br />
            </td>
          </tr>
        </table>
      </center>
    </td>
  </tr>
</table>
</body>
</html>
