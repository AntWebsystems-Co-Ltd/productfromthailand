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
function anonProcessSubmit() {
    if ($("input:radio[name='shipping_method']").is(":checked")) {
        $("#anonCheckoutShippingPayments").submit();
    } else {
        alert("${StringUtil.wrapString(uiLabelMap.PFTErrorCheckoutStep2)}");
    }
}
function anonProcessBack() {
    location.href = "<@ofbizUrl>quickcheckout</@ofbizUrl>";
}
</script>

<div id="main-container" class="container text-center-xs">
    <div class="panel-smart col3-banners">
        <div class="arrow-steps clearfix">
            <div id="checkoutStepHeader1" class="step arrow-width">
                <span>${uiLabelMap.PFTStep} 1<br><div class="step-description">${uiLabelMap.PFTStepHeader1}</div></span>
            </div>
            <div id="checkoutStepHeader2" class="step arrow-width current">
                <span>${uiLabelMap.PFTStep} 2<br><div class="step-description">${uiLabelMap.PFTStepHeader2}</div></span>
            </div>
            <div id="checkoutStepHeader3" class="step arrow-width">
                <span>${uiLabelMap.PFTStep} 3<br><div class="step-description">${uiLabelMap.PFTStepHeader3}</div></span>
            </div>
        </div>
    </div>
    <div class="col-sm-7">
        <div class="panel-smart">
            <form name="anonCheckoutShippingPayments" id="anonCheckoutShippingPayments" action="<@ofbizUrl>updateAnonCheckoutOptionAndShipping</@ofbizUrl>" type="post">
                <input type="hidden" name="checkoutpage" value="quick"/>
                <input type="hidden" name="BACK_PAGE" value="quickcheckout"/>
                <input type="hidden" name="may_split" value="false"/>
                <input type="hidden" name="is_gift" value="false"/>
                <input type="hidden" name="partyId" value="${parameters.partyId!}"/>
                <input type="hidden" name="shipping_contact_mech_id" value="${shoppingCart.getShippingContactMechId()}"/>
                <div id="shippingMethod">
                    <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.OrderSelectShippingMethod}</h3>
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
                <div id="paymentMethod">
                    <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.AccountingPaymentMethod}</h3>
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
                <div class="form-group">
                    <button type="button" id="anonBack" class="btn btn-secondary btn-left btn-style-1 animation flat text-uppercase"
                        onclick="javascript:anonProcessBack();">
                        ${uiLabelMap.CommonBack}
                    </button>
                    <button type="button" id="anonContinue" class="btn btn-secondary btn-right btn-style-1 animation flat text-uppercase"
                        onclick="javascript:anonProcessSubmit();">
                        ${uiLabelMap.PFTContinue}
                    </button>
                </div>
            </form>
        </div>
    </div>
    <div class="col-sm-5">
        <div id="anonOrderDetails" class="panel-smart">
            ${screens.render("component://productfromthailand/widget/OrderScreens.xml#anonOrderDetails")}
        </div>
    </div>
</div>
<#-- Main Container Ends -->
