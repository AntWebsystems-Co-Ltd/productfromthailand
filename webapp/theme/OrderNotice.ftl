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

<#if (orderHeader.externalId)?? && (orderHeader.externalId)?has_content >
  <#assign externalOrder = "(" + orderHeader.externalId + ")"/>
</#if>

<!-- BODY -->
<table cellspacing="0" cellpadding="0" width="100%" background="${baseUrl!}/pft-default/pftimages/bg_top.jpg">
  <tr>
    <td style="text-align:center;">
        <a href=""><img height="80%" src="${logoImageUrl}" alt="logo"/></a>
    </td>
  </tr>
</table>
<table class="body-wrap">
    <tr>
        <td class="container" bgcolor="#f7f7f7">
            <div class="content">
            <table>
                <tr>
                    <td><br/>
                        <#-- <h4>
                            <#if orderHeader?has_content>
                                ${uiLabelMap.PFTOrderNbr}
                                <a href="<@ofbizUrl fullPath="true">orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>" class="lightbuttontext">${orderHeader.orderId}</a>
                            </#if>
                            ${uiLabelMap.CommonInformation}
                            <#if (orderHeader.orderId)??>
                                ${externalOrder!} [ <a href="<@ofbizUrl fullPath="true">order.pdf?orderId=${(orderHeader.orderId)!}</@ofbizUrl>"target="_BLANK" class="lightbuttontext">PDF</a> ]
                            </#if>
                        </h4><br/>  -->
                        <#if localOrderReadHelper?? && orderHeader?has_content>
                          <#assign displayParty = localOrderReadHelper.getPlacingParty()!/>
                          <#if displayParty?has_content>
                            <#assign partyNameView = EntityQuery.use(delegator).from("PartyNameView").where("partyId", displayParty.partyId).queryOne()!>
                            <#else>
                                <#if orderHeader.orderTypeId.equals("PURCHASE_ORDER")>
                                    <#assign orderItemHeader = EntityQuery.use(delegator).from("OrderItem").where("orderId", orderHeader.orderId).queryFirst()!>
                                    <#assign supplierProduct = EntityQuery.use(delegator).from("SupplierProduct").where("supplierProductId", orderItemHeader.supplierProductId).queryFirst()!>
                                    <#assign partyNameView = EntityQuery.use(delegator).from("PartyNameView").where("partyId", supplierProduct.partyId).queryOne()!>
                                </#if>
                          </#if>
                          <#assign userLoginValue = EntityQuery.use(delegator).from("UserLogin").where("partyId", partyNameView.partyId).queryFirst()!>
                          <#if userLoginValue.lastLocale?has_content>
                              <#assign locale = Static["org.apache.ofbiz.base.util.UtilMisc"].parseLocale(userLoginValue.lastLocale)!>
                          </#if>
                          <#assign uiLabelMap = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("AccountingUiLabels", locale)>
                          <#assign uiLabelMapEcom = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("EcommerceUiLabels", locale)>
                          <#assign uiLabelMapOrder = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("OrderUiLabels", locale)>
                          <#assign uiLabelMapParty = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("PartyUiLabels", locale)>
                          <#assign uiLabelMapCom = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("CommonUiLabels", locale)>
                          <#assign uiLabelMapPFT = Static["org.apache.ofbiz.base.util.UtilProperties"].getResourceBundleMap("ProductFromThailandUiLabels", locale)>

                          <h4>${uiLabelMapPFT.PFTThanksForYourOrderfromPFT}</h4><br/>
                          <p>
                            ${uiLabelMapPFT.PFTHi}
                            ${partyNameView.firstName!} ${partyNameView.lastName!}${partyNameView.groupName!}<#if locale == "en">,</#if>
                          </p>
                        </#if><br/>
                        <p>${uiLabelMapPFT.PFTThanksForYourOrderfromPFT} ${uiLabelMapPFT.PFTWeHopeYouLoveYourNewThingsAsMuchAsWeDo} ${uiLabelMapPFT.PFTYouCanCheckOnYourOrderAtAnytimeByLoggingIntoYourAccount}</p><br/>

                        <!-- Order Items -->
                        <b>${uiLabelMapOrder.OrderOrderItems}</b>
                        <#list orderItems as orderItem>
                            <div class="products">
                                <#if !orderItem.productId?? || orderItem.productId == "_?_">
                                  ${orderItem.itemDescription?default("")}
                                <#else>
                                  <#assign product = orderItem.getRelatedOne("Product", true)!/>
                                  <#assign productName = Static['org.apache.ofbiz.product.product.ProductContentWrapper'].getProductContentAsText(product, 'PRODUCT_NAME', locale, dispatcher, "html")?if_exists>
                                  <#assign smallImageUrl = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(product, "SMALL_IMAGE_URL", locale, dispatcher, "url")?if_exists />
                                  <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/pft-default/images/defaultImage.jpg" /></#if>
                                  <#if smallImageUrl?string?has_content>
                                    <img src="${baseUrl!}${smallImageUrl!}"/>
                                  </#if>
                                  <span>${orderItem.productId} - ${StringUtil.wrapString(productName)?default("")} x  ${orderItem.quantity?string.number} <@ofbizCurrency amount=orderItem.unitPrice isoCode=currencyUomId/></span>
                                </#if>
                            </div>
                            <hr>
                            <div style="clear:both;"></div>
                        </#list>
                        <br/>

                        <!-- Subtotal -->
                        <b>${uiLabelMapCom.CommonSubtotal}: </b><@ofbizCurrency amount=orderSubTotal isoCode=currencyUomId/><br />
                        <!-- Shipping -->
                        <b>${uiLabelMapOrder.OrderShippingAndHandling}: </b><@ofbizCurrency amount=orderShippingTotal isoCode=currencyUomId/><br />
                        <!-- Discounts -->
                        <#list headerAdjustmentsToShow as orderHeaderAdjustment>
                          <b>${uiLabelMap.AccountingAgreementPromoAppls}: </b><@ofbizCurrency amount=localOrderReadHelper.getOrderAdjustmentTotal(orderHeaderAdjustment) isoCode=currencyUomId/><br />
                        </#list>
                        <!-- SalesTax -->
                        <b>${uiLabelMapOrder.OrderSalesTax}: </b><@ofbizCurrency amount=orderTaxTotal isoCode=currencyUomId/>
                        <br/><br/>

                        <!-- GrandTotal -->
                        <h4><b>${uiLabelMapOrder.OrderGrandTotal}:
                        <#if orderHeader?has_content && orderHeader.statusId.equals("ORDER_CANCELLED")>
                          <@ofbizCurrency amount=0.00 isoCode=currencyUomId/>
                        <#else>
                          <@ofbizCurrency amount=orderGrandTotal isoCode=currencyUomId/>
                        </#if>
                        </b></h4>
                        <br/>

                        <!-- Shipping Address -->
                        <h5 class="">${uiLabelMapOrder.OrderShippingInformation}</h5>
                        <p>
                            <#if orderItemShipGroups?has_content>
                              <#assign countlist = '0'>
                              <#list orderItemShipGroups as shipGroup>
                                <#if orderHeader?has_content>
                                  <#assign shippingAddress = shipGroup.getRelatedOne("PostalAddress", false)!>
                                  <#assign groupNumber = shipGroup.shipGroupSeqId!>
                                <#else>
                                  <#assign shippingAddress = cart.getShippingAddress(groupIdx)!>
                                  <#assign groupNumber = groupIdx + 1>
                                </#if>
                                  <#if countlist != '0'> <br/></#if>
                                  <#if shippingAddress?has_content>
                                      <#if shippingAddress.toName?has_content>${shippingAddress.toName}</#if>
                                      <#if shippingAddress.attnName?has_content>
                                        ${uiLabelMapParty.PartyAddrAttnName}  : ${shippingAddress.attnName}
                                      </#if>
                                      ${shippingAddress.address1}
                                      <#if shippingAddress.address2?has_content>${shippingAddress.address2}</#if>
                                      <#assign shippingStateGeo = (delegator.findOne("Geo", {"geoId", shippingAddress.stateProvinceGeoId!}, false))! />
                                      ${shippingAddress.city}
                                      <#if shippingStateGeo?has_content>, ${shippingStateGeo.geoName!}</#if>
                                      ${shippingAddress.postalCode!}
                                      <#assign shippingCountryGeo = (delegator.findOne("Geo", {"geoId", shippingAddress.countryGeoId!}, false))! />
                                      <#if shippingCountryGeo?has_content>${shippingCountryGeo.geoName!}</#if>
                                  </#if>
                                  <br/>
                                ${uiLabelMapOrder.OrderMethod}:
                                <#if orderHeader?has_content>
                                  <#assign shipmentMethodType = shipGroup.getRelatedOne("ShipmentMethodType", false)!>
                                  <#assign carrierPartyId = shipGroup.carrierPartyId!>
                                <#else>
                                  <#assign shipmentMethodType = cart.getShipmentMethodType(groupIdx)!>
                                  <#assign carrierPartyId = cart.getCarrierPartyId(groupIdx)!>
                                </#if>
                                <#if carrierPartyId?? && carrierPartyId != "_NA_">${carrierPartyId!}</#if>
                                ${(shipmentMethodType.description)?default("N/A")}
                                <#assign countlist = countlist+1>
                              </#list>
                            </#if>
                        </p><br />

                        <!-- Payment Method -->
                        <#if paymentMethods?has_content || paymentMethodType?has_content || billingAccount?has_content>
                            <#-- order payment info -->
                            <h5>${uiLabelMap.AccountingPaymentInformation}</h5>
                            <#-- offline payment address infomation :: change this to use Company's address -->
                            <p>
                              <#if !paymentMethod?has_content && paymentMethodType?has_content>
                                  <#if paymentMethodType.paymentMethodTypeId == "EXT_OFFLINE">
                                    ${uiLabelMap.AccountingOfflinePayment}
                                    <#if orderHeader?has_content && paymentAddress?has_content>
                                      ${uiLabelMapOrder.OrderSendPaymentTo}:
                                      <#if paymentAddress.toName?has_content>${paymentAddress.toName}</#if>
                                      <#if paymentAddress.attnName?has_content>
                                        ${uiLabelMapParty.PartyAddrAttnName} : ${paymentAddress.attnName}
                                      </#if>
                                      ${paymentAddress.address1}
                                      <#if paymentAddress.address2?has_content>${paymentAddress.address2}</#if>
                                      <#assign paymentStateGeo = (delegator.findOne("Geo", {"geoId", paymentAddress.stateProvinceGeoId!}, false))! />
                                      ${paymentAddress.city}
                                      <#if paymentStateGeo?has_content>, ${paymentStateGeo.geoName!}</#if>
                                      ${paymentAddress.postalCode!}
                                      <#assign paymentCountryGeo = (delegator.findOne("Geo", {"geoId", paymentAddress.countryGeoId!}, false))! />
                                      <#if paymentCountryGeo?has_content>${paymentCountryGeo.geoName!}</#if>
                                      ${uiLabelMapEcom.EcommerceBeSureToIncludeYourOrderNb}
                                    </#if>
                                  <#else>
                                    <#assign outputted = true>
                                    ${uiLabelMap.AccountingPaymentVia} ${paymentMethodType.get("description",locale)}
                                  </#if>
                              </#if>
                          </#if>
                          </p>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td align="center"><center><hr width="70%"></center></td>
                </tr>
                <tr>
                    <td align="center" >${uiLabelMapPFT.PFTContact}</td>
                </tr>
                <tr>
                    <td colspan="3"><br></td>
                </tr>
                <tr>
                  <td align="center">
                      <a href="https://www.facebook.com/Careelnatural/"><img width="48" height="47" src="${baseUrl!}/pft-default/pftimages/social_facebook_icon.gif" alt="facebook"/></a>
                      <a href="https://twitter.com/Product_Thai/"><img width="44" height="47" src="${baseUrl!}/pft-default/pftimages/social_twitter_icon.gif" alt="twitter"/></a>
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
            </div>
        </td>
    </tr>
</table>
<!-- /BODY -->
