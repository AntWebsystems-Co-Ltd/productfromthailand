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
<script language="javascript" type="text/javascript">
$(document).ready( function() {
    <#if shoppingCart.getShippingContactMechId()?exists>
        <#if chosenShippingMethod?exists>
            $("input:radio[name='shipping_method'][value='${StringUtil.wrapString(chosenShippingMethod)}']").attr('checked', 'checked');
        </#if>
    </#if>
});
</script>
<#-- Shipping Method Starts -->
<div id="shippingMethod">
<#-- Heading Starts -->
    <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.OrderSelectShippingMethod}</h3>
<#-- Heading Ends -->
    <div class="form-group">
        <#list ShippingList as carrierShipmentMethod>
            <div>
                <#assign shippingMethod = carrierShipmentMethod.shipmentMethodTypeId + "@" + carrierShipmentMethod.partyId>
                <input type="radio" id="shipping_method_${shippingMethod!}" name="shipping_method" value="${shippingMethod!}"/>
                <#if carrierShipmentMethod.partyId != "_NA_">${carrierShipmentMethod.partyId!}&nbsp;</#if>${carrierShipmentMethod.description!}
                <#if carrierShipmentMethod.shippingEst?has_content> - <#if (carrierShipmentMethod.shippingEst > -1)><@ofbizCurrency amount=carrierShipmentMethod.shippingEst isoCode=shoppingCart.getCurrency()/><#else>${uiLabelMap.OrderCalculatedOffline}</#if></#if>
            </div>
        </#list>
    </div>
</div>
<#-- Shipping Method Ends -->
<#-- Payment Method Starts -->
<div id="paymentMethod">
<#-- Heading Starts -->
    <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.AccountingPaymentMethod}</h3>
<#-- Heading Ends -->
    <#if productStorePaymentMethodTypeIdMap.EXT_OFFLINE?exists>
        <div class="form-group">
            <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="EXT_OFFLINE" <#if "EXT_OFFLINE" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.OrderMoneyOrder}
        </div>
    </#if>
    <#if productStorePaymentMethodTypeIdMap.EXT_PAYPAL?exists>
        <div class="form-group">
            <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="EXT_PAYPAL" checked="checked"/>${uiLabelMap.AccountingPayWithPayPal} &nbsp;
            <a href="<@ofbizUrl>showhelpcontent?contentId=CHECKOUT_PAYPAL&nodeTrailCsv=CHECKOUT_PAYPAL</@ofbizUrl>" class="btn btn-main" target="_blank">
                ${uiLabelMap.PFTUserGuide}
            </a>
        </div>
    </#if>
    <#if productStorePaymentMethodTypeIdMap.EXT_COD?exists>
        <div class="form-group">
            <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="EXT_COD" <#if "EXT_COD" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.OrderCOD}
        </div>
    </#if>
    <#if productStorePaymentMethodTypeIdMap.EXT_WORLDPAY?exists>
        <div class="form-group">
            <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="EXT_WORLDPAY" <#if "EXT_WORLDPAY" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.AccountingPayWithWorldPay}
        </div>
    </#if>
    <#-- financial accounts -->
    <#if finAccounts?has_content>
        <#list finAccounts as finAccount>
        <div class="form-group">
            <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="FIN_ACCOUNT|${finAccount.finAccountId}" <#if "FIN_ACCOUNT" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.AccountingFinAccount} #${finAccount.finAccountId}
        </div>
        </#list>
    </#if>
    <#--
    <#if paymentMethodList?has_content>
        <#list paymentMethodList as paymentMethod>
            <#if paymentMethod.paymentMethodTypeId == "CREDIT_CARD">
                <#if productStorePaymentMethodTypeIdMap.CREDIT_CARD?exists>
                    <#assign creditCard = paymentMethod.getRelatedOne("CreditCard")>
                    <div class="form-group">
                        <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="${paymentMethod.paymentMethodId}" <#if shoppingCart.isPaymentSelected(paymentMethod.paymentMethodId)>checked="checked"</#if>/>
                    </div>
                </#if>
            </#if>
        </#list>
    </#if>
    <#if productStorePaymentMethodTypeIdMap.EXT_BILLACT?exists>
        <#if billingAccountList?has_content>
            <select id="billingAccountId" name="billingAccountId" class="form-control flat animation" required>
                <option value=""></option>
                <#list billingAccountList as billingAccount>
                    <#assign availableAmount = billingAccount.accountBalance?double>
                    <#assign accountLimit = billingAccount.accountLimit?double>
                    <option value="${billingAccount.billingAccountId}" <#if billingAccount.billingAccountId == selectedBillingAccountId?default("")>selected</#if>>${billingAccount.description?default("")} [${billingAccount.billingAccountId}] Available: <@ofbizCurrency amount=availableAmount isoCode=billingAccount.accountCurrencyUomId/> Limit: <@ofbizCurrency amount=accountLimit isoCode=billingAccount.accountCurrencyUomId/></option>
                </#list>
            </select>
        </#if>
    </#if>
    -->
</div>
<#-- Payment Method End -->