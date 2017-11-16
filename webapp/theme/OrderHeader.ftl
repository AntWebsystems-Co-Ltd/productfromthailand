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

<#-- NOTE: this template is used for the orderstatus screen in ecommerce AND for order notification emails through the OrderNoticeEmail.ftl file -->
<#-- the "urlPrefix" value will be prepended to URLs by the ofbizUrl transform if/when there is no "request" object in the context -->
<#if baseEcommerceSecureUrl??><#assign urlPrefix = baseEcommerceSecureUrl/></#if>
<#if (orderHeader.externalId)?? && (orderHeader.externalId)?has_content >
  <#assign externalOrder = "(" + orderHeader.externalId + ")"/>
</#if>

<#if orderHeader?has_content>
    <div class="panel-heading">
      <h3 class="panel-title">
      <#if maySelectItems?default("N") == "Y" && returnLink?default("N") == "Y" && (orderHeader.statusId)! == "ORDER_COMPLETED" && roleTypeId! == "PLACING_CUSTOMER">
        <a href="<@ofbizUrl fullPath="true">makeReturn?orderId=${orderHeader.orderId}</@ofbizUrl>"
            class="submenutextright">${uiLabelMap.OrderRequestReturn}</a>
      </#if>
      ${uiLabelMap.OrderOrder}
      <#if orderHeader?has_content>
        ${uiLabelMap.CommonNbr}
        <a href="<@ofbizUrl fullPath="true">orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>"
            class="lightbuttontext">${orderHeader.orderId}</a>
      </#if>
      ${uiLabelMap.CommonInformation}
      <#if (orderHeader.orderId)??>
        ${externalOrder!} [ <a href="<@ofbizUrl fullPath="true">order.pdf?orderId=${(orderHeader.orderId)!}</@ofbizUrl>"
            target="_BLANK" class="lightbuttontext">PDF</a> ]
      </#if>
      </h3>
    </div>
    <div class="panel-body">
      <#-- placing customer information -->
        <#if localOrderReadHelper?? && orderHeader?has_content>
          <#assign displayParty = localOrderReadHelper.getPlacingParty()!/>
          <#if displayParty?has_content>
            <#assign displayPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", displayParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
          </#if>
          <#if displayPartyNameResult?exists && displayPartyNameResult.fullName?exists>
          <p>
            ${uiLabelMap.PartyName}
            ${(displayPartyNameResult.fullName)?default("[Name Not Found]")}
          </p>
          </#if>
        </#if>
        <#-- order status information -->
        <p>
          ${uiLabelMap.CommonStatus}
          <#if orderHeader?has_content>
            ${localOrderReadHelper.getStatusString(locale)}
          <#else>
            ${uiLabelMap.OrderNotYetOrdered}
          </#if>
        </p>
        <#-- ordered date -->
        <#if orderHeader?has_content>
          <p>
            ${uiLabelMap.CommonDate}
            ${orderHeader.orderDate.toString()}
          </p>
        </#if>
        <#if distributorId??>
          <p>
            ${uiLabelMap.OrderDistributor}
            ${distributorId}
          </p>
        </#if>
    </div>
</#if>

<#if paymentMethods?has_content || paymentMethodType?has_content || billingAccount?has_content>
    <div class="panel-heading">
        <#-- order payment info -->
        <h3 class="panel-title">${uiLabelMap.AccountingPaymentInformation}</h3>
        <#-- offline payment address infomation :: change this to use Company's address -->
    </div>
    <div class="panel-body">
      <#if !paymentMethod?has_content && paymentMethodType?has_content>
        <p>
          <#if paymentMethodType.paymentMethodTypeId == "EXT_OFFLINE">
            ${uiLabelMap.AccountingOfflinePayment}
            <#if orderHeader?has_content && paymentAddress?has_content>
              ${uiLabelMap.OrderSendPaymentTo}:
              <#if paymentAddress.toName?has_content>${paymentAddress.toName}</#if>
              <#if paymentAddress.attnName?has_content>
                ${uiLabelMap.PartyAddrAttnName}  : ${paymentAddress.attnName}
              </#if>
              ${paymentAddress.address1}
              <#if paymentAddress.address2?has_content>${paymentAddress.address2}</#if>
              <#assign paymentStateGeo = (delegator.findOne("Geo", {"geoId", paymentAddress.stateProvinceGeoId!}, false))! />
              ${paymentAddress.city}
              <#if paymentStateGeo?has_content>, ${paymentStateGeo.geoName!}</#if>
              ${paymentAddress.postalCode!}
              <#assign paymentCountryGeo = (delegator.findOne("Geo", {"geoId", paymentAddress.countryGeoId!}, false))! />
              <#if paymentCountryGeo?has_content>${paymentCountryGeo.geoName!}</#if>
              ${uiLabelMap.EcommerceBeSureToIncludeYourOrderNb}
            </#if>
          <#else>
            <#assign outputted = true>
            ${uiLabelMap.AccountingPaymentVia} ${paymentMethodType.get("description",locale)}
          </#if>
        </p>
      </#if>
      <#if paymentMethods?has_content>
        <#list paymentMethods as paymentMethod>
          <#if "CREDIT_CARD" == paymentMethod.paymentMethodTypeId>
            <#assign creditCard = paymentMethod.getRelatedOne("CreditCard", false)>
            <#assign formattedCardNumber = Static["org.apache.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)>
          <#elseif "GIFT_CARD" == paymentMethod.paymentMethodTypeId>
            <#assign giftCard = paymentMethod.getRelatedOne("GiftCard", false)>
          <#elseif "EFT_ACCOUNT" == paymentMethod.paymentMethodTypeId>
            <#assign eftAccount = paymentMethod.getRelatedOne("EftAccount", false)>
          </#if>
          <#-- credit card info -->
          <#if "CREDIT_CARD" == paymentMethod.paymentMethodTypeId && creditCard?has_content>
            <#if outputted?default(false)></#if>
            <#assign pmBillingAddress = creditCard.getRelatedOne("PostalAddress", false)!>
            <p> ${uiLabelMap.AccountingCreditCard}
              <#if creditCard.companyNameOnCard?has_content>${creditCard.companyNameOnCard}</#if>
              <#if creditCard.titleOnCard?has_content>${creditCard.titleOnCard}</#if>
              ${creditCard.firstNameOnCard}
              <#if creditCard.middleNameOnCard?has_content>${creditCard.middleNameOnCard}</#if>
              ${creditCard.lastNameOnCard}
              <#if creditCard.suffixOnCard?has_content>${creditCard.suffixOnCard}</#if>
            </p>
            <p>${formattedCardNumber}</p>
            <#-- Gift Card info -->
          <#elseif "GIFT_CARD" == paymentMethod.paymentMethodTypeId && giftCard?has_content>
            <#if outputted?default(false)></#if>
            <#if giftCard?has_content && giftCard.cardNumber?has_content>
              <#assign pmBillingAddress = giftCard.getRelatedOne("PostalAddress", false)!>
              <#assign giftCardNumber = "">
              <#assign pcardNumber = giftCard.cardNumber>
              <#if pcardNumber?has_content>
                <#assign psize = pcardNumber?length - 4>
                <#if 0 < psize>
                  <#list 0 .. psize-1 as foo>
                    <#assign giftCardNumber = giftCardNumber + "*">
                  </#list>
                  <#assign giftCardNumber = giftCardNumber + pcardNumber[psize .. psize + 3]>
                <#else>
                  <#assign giftCardNumber = pcardNumber>
                </#if>
              </#if>
            </#if>
            <p>
              ${uiLabelMap.AccountingGiftCard}
              ${giftCardNumber}
            </p>
            <#-- EFT account info -->
          <#elseif "EFT_ACCOUNT" == paymentMethod.paymentMethodTypeId && eftAccount?has_content>
            <#if outputted?default(false)></#if>
            <#assign pmBillingAddress = eftAccount.getRelatedOne("PostalAddress", false)!>
            <p>
              ${uiLabelMap.AccountingEFTAccount}
              ${eftAccount.nameOnAccount!}
            </p>
            <p>
              <#if eftAccount.companyNameOnAccount?has_content>${eftAccount.companyNameOnAccount}</#if>
            </p>
            <p>
              ${uiLabelMap.AccountingBank}: ${eftAccount.bankName}, ${eftAccount.routingNumber}
            </p>
            <p>
              ${uiLabelMap.AccountingAccount} #: ${eftAccount.accountNumber}
            </p>
          </#if>
          <#if pmBillingAddress?has_content>
            <p>
              <#if pmBillingAddress.toName?has_content>${uiLabelMap.CommonTo}: ${pmBillingAddress.toName}</#if>
            </p>
            <p>
              <#if pmBillingAddress.attnName?has_content>
                ${uiLabelMap.CommonAttn}  : ${pmBillingAddress.attnName}
              </#if>
            </p>
            <p>
              ${pmBillingAddress.address1}
            </p>
            <p>
              <#if pmBillingAddress.address2?has_content>${pmBillingAddress.address2}</#if>
            </p>
            <p>
              <#assign pmBillingStateGeo = (delegator.findOne("Geo", {"geoId", pmBillingAddress.stateProvinceGeoId!}, false))! />
              ${pmBillingAddress.city}
              <#if pmBillingStateGeo?has_content>  , ${ pmBillingStateGeo.geoName!}</#if>
              ${pmBillingAddress.postalCode!}
              <#assign pmBillingCountryGeo = (delegator.findOne("Geo", {"geoId", pmBillingAddress.countryGeoId!}, false))! />
              <#if pmBillingCountryGeo?has_content>${pmBillingCountryGeo.geoName!}</#if>
            </p>
          </#if>
          <#assign outputted = true>
        </#list>
      </#if>
      <#-- billing account info -->
      <#if billingAccount?has_content>
        <#if outputted?default(false)></#if>
        <#assign outputted = true>
        <p>
          ${uiLabelMap.AccountingBillingAccount}
          #${billingAccount.billingAccountId!} - ${billingAccount.description!}
        </p>
      </#if>
      <#if (customerPoNumberSet?has_content)>
        <p>
          ${uiLabelMap.OrderPurchaseOrderNumber}
          <#list customerPoNumberSet as customerPoNumber>
            ${customerPoNumber!}
          </#list>
        </p>
      </#if>
    </div>
</#if>

<#-- right side -->
<#if orderItemShipGroups?has_content>
    <div class="panel-heading">
      <h3 class="panel-title">${uiLabelMap.OrderShippingInformation}</h3>
    </div>
    <div class="panel-body table-responsive">
      <table width="100%" class="table table-bordered">

      <#-- header -->

      <tr>
        <td><span>${uiLabelMap.OrderDestination}</span></td>
        <td><span>${uiLabelMap.PartySupplier}</span></td>
        <td><span>${uiLabelMap.ProductShipmentMethod}</span></td>
        <td><span>${uiLabelMap.ProductItem}</span></td>
        <td><span>${uiLabelMap.ProductQuantity}</span></td>
      </tr>
      <#list cart.getShipGroups() as cartShipInfo>
      <#assign numberOfItems = cartShipInfo.getShipItems().size()>
      <#if (numberOfItems > 0)>

      <#-- spacer goes here -->

      <tr>

        <#-- address destination column (spans a number of rows = number of cart items in it) -->

        <td rowspan="${numberOfItems}">
          <#assign contactMech = delegator.findOne("ContactMech", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("contactMechId", cartShipInfo.contactMechId), false)! />
          <#if contactMech?has_content>
            <#assign address = contactMech.getRelatedOne("PostalAddress", false)! />
          </#if>

          <#if address??>
            <#if address.toName?has_content><b>${uiLabelMap.CommonTo}:</b>&nbsp;${address.toName}<br /></#if>
            <#if address.attnName?has_content><b>${uiLabelMap.CommonAttn}:</b>&nbsp;${address.attnName}<br /></#if>
            <#if address.address1?has_content>${address.address1}<br /></#if>
            <#if address.address2?has_content>${address.address2}<br /></#if>
            <#if address.city?has_content>${address.city}</#if>
            <#assign shippingStateGeo = (delegator.findOne("Geo", {"geoId", address.stateProvinceGeoId!}, false))! />
            <#if address.stateProvinceGeoId?has_content>&nbsp;${shippingStateGeo.geoName!}</#if>
            <#if address.postalCode?has_content>, ${address.postalCode!}</#if>
          </#if>
        </td>

        <#-- supplier id (for drop shipments) (also spans rows = number of items) -->

        <td rowspan="${numberOfItems}" valign="top">
          <#assign supplier =  delegator.findOne("PartyGroup", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", cartShipInfo.getSupplierPartyId()), false)! />
          <#if supplier?has_content>${supplier.groupName?default(supplier.partyId)}</#if>
        </td>

        <#-- carrier column (also spans rows = number of items) -->

        <td rowspan="${numberOfItems}" valign="top">
          <#assign carrier =  delegator.findOne("PartyGroup", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", cartShipInfo.getCarrierPartyId()), false)! />
          <#assign method =  delegator.findOne("ShipmentMethodType", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("shipmentMethodTypeId", cartShipInfo.getShipmentMethodTypeId()), false)! />
          <#if carrier?has_content>${carrier.groupName?default(carrier.partyId)}</#if>
          <#if method?has_content>${method.description?default(method.shipmentMethodTypeId)}</#if>
        </td>

        <#-- list each ShoppingCartItem in this group -->

        <#assign itemIndex = 0 />
        <#list cartShipInfo.getShipItems() as shoppingCartItem>
        <#if (itemIndex > 0)> <tr> </#if>

        <td valign="top"> ${shoppingCartItem.getProductId()?default("")} - ${shoppingCartItem.getName()?default("")} </td>
        <td valign="top"> ${cartShipInfo.getShipItemInfo(shoppingCartItem).getItemQuantity()?default("0")} </td>

        <#if (itemIndex == 0)> </tr> </#if>
        <#assign itemIndex = itemIndex + 1 />
        </#list>

      </tr>

      </#if>
      </#list>
      </table>
    </div>
</#if>
