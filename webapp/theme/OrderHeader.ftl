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
      <#if orderHeader?has_content>
        ${uiLabelMap.PFTOrderNbr}
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
          <#assign customerParty = localOrderReadHelper.getPlacingParty()!/>
          <#if customerParty?has_content>
            <#assign customerPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", customerParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
          </#if>
          <#assign supplierParty = localOrderReadHelper.getSupplierAgent()!/>
          <#if supplierParty?has_content>
            <#assign supplierPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", supplierParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
          </#if>
          <p>
            ${uiLabelMap.PartyName}
            <#if customerPartyNameResult?has_content>
                ${customerPartyNameResult.fullName!}
            <#elseif supplierPartyNameResult?has_content>
                ${supplierPartyNameResult.groupName!} ${supplierPartyNameResult.fullName!}
            <#else>
                [Name Not Found]
            </#if>
          </p>
        </#if>
        <#-- order status information -->
        <p>
          ${uiLabelMap.CommonStatus}
          <#if orderHeader?has_content>
            <#assign statusItem = orderHeader.getRelatedOne("StatusItem", false)!>
            ${statusItem.get("description", locale)}
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
    <div class="panel-body">
      <#-- shipping address -->
      <#assign groupIdx = 0>
      <#list orderItemShipGroups as shipGroup>
        <#if orderHeader?has_content>
          <#assign shippingAddress = shipGroup.getRelatedOne("PostalAddress", false)!>
          <#assign groupNumber = shipGroup.shipGroupSeqId!>
        <#else>
          <#assign shippingAddress = cart.getShippingAddress(groupIdx)!>
          <#assign groupNumber = groupIdx + 1>
        </#if>
          <#if shippingAddress?has_content>
            <p>
              ${uiLabelMap.OrderDestination} [${groupNumber}]
              <#if shippingAddress.toName?has_content>${uiLabelMap.CommonTo}: ${shippingAddress.toName}</#if>
            </p>
            <p>
              <#if shippingAddress.attnName?has_content>
                ${uiLabelMap.PartyAddrAttnName}  : ${shippingAddress.attnName}
              </#if>
            </p>
            <p>
              ${shippingAddress.address1}
            </p>
            <p>
              <#if shippingAddress.address2?has_content>${shippingAddress.address2}</#if>
            </p>
            <p>
              <#assign shippingStateGeo = (delegator.findOne("Geo", {"geoId", shippingAddress.stateProvinceGeoId!}, false))! />
              ${shippingAddress.city}
              <#if shippingStateGeo?has_content>, ${shippingStateGeo.geoName!}</#if>
              ${shippingAddress.postalCode!}
            </p>
            <p>
              <#assign shippingCountryGeo = (delegator.findOne("Geo", {"geoId", shippingAddress.countryGeoId!}, false))! />
              <#if shippingCountryGeo?has_content>${shippingCountryGeo.geoName!}</#if>
            </p>
          </#if>
          <p>
            ${uiLabelMap.PFTShippingMethod}:
            <#if orderHeader?has_content>
              <#assign shipmentMethodType = shipGroup.getRelatedOne("ShipmentMethodType", false)!>
              <#assign carrierPartyId = shipGroup.carrierPartyId!>
            <#else>
              <#assign shipmentMethodType = cart.getShipmentMethodType(groupIdx)!>
              <#assign carrierPartyId = cart.getCarrierPartyId(groupIdx)!>
            </#if>
            <#if carrierPartyId?? && carrierPartyId != "_NA_">${carrierPartyId!}</#if>
            ${(shipmentMethodType.description)?default("N/A")}
          </p>
          <p>
            <#if shippingAccount??>${uiLabelMap.AccountingUseAccount}: ${shippingAccount}</#if>
          </p>
          <#-- tracking number -->
          <#if shipGroup.trackingNumber?exists>
            <p>
              ${uiLabelMap.OrderTrackingNumber}:
              <#-- TODO: add links to UPS/FEDEX/etc based on carrier partyId  -->
              <#if shipGroup.trackingNumber?has_content>
                ${shipGroup.trackingNumber}
              </#if>
              <#if orderShipmentInfoSummaryList?has_content>
                <#list orderShipmentInfoSummaryList as orderShipmentInfoSummary>
                  <#if (orderShipmentInfoSummaryList?size > 1)>${orderShipmentInfoSummary.shipmentPackageSeqId}: </#if>
                  Code: ${orderShipmentInfoSummary.trackingCode?default("[Not Yet Known]")}
                  <#if orderShipmentInfoSummary.boxNumber?has_content>
                    ${uiLabelMap.OrderBoxNumber}${orderShipmentInfoSummary.boxNumber}
                  </#if>
                  <#if orderShipmentInfoSummary.carrierPartyId?has_content>
                    (${uiLabelMap.ProductCarrier}: ${orderShipmentInfoSummary.carrierPartyId})
                  </#if>
                </#list>
              </#if>
            </p>
          </#if>
          <#if shipGroup_has_next></#if>
        <#assign groupIdx = groupIdx + 1>
      </#list><#-- end list of orderItemShipGroups -->
    </div>
</#if>
