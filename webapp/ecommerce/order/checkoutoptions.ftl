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
function submitForm(form, mode, value) {
    if (mode == "DN") {
        // done action; checkout
        form.action="<@ofbizUrl>checkout</@ofbizUrl>";
        form.submit();
    } else if (mode == "CS") {
        // continue shopping
        form.action="<@ofbizUrl>updateCheckoutOptions/showcart</@ofbizUrl>";
        form.submit();
    } else if (mode == "NA") {
        // new address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&preContactMechTypeId=POSTAL_ADDRESS&contactMechPurposeTypeId=SHIPPING_LOCATION</@ofbizUrl>";
        form.submit();
    } else if (mode == "EA") {
        // edit address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&contactMechId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "NC") {
        // new credit card
        form.action="<@ofbizUrl>updateCheckoutOptions/editcreditcard?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}</@ofbizUrl>";
        form.submit();
    } else if (mode == "EC") {
        // edit credit card
        form.action="<@ofbizUrl>updateCheckoutOptions/editcreditcard?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "GC") {
        // edit gift card
        form.action="<@ofbizUrl>updateCheckoutOptions/editgiftcard?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "NE") {
        // new eft account
        form.action="<@ofbizUrl>updateCheckoutOptions/editeftaccount?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}</@ofbizUrl>";
        form.submit();
    } else if (mode == "EE") {
        // edit eft account
        form.action="<@ofbizUrl>updateCheckoutOptions/editeftaccount?DONE_PAGE=quickcheckout&partyId=${shoppingCart.getPartyId()}&paymentMethodId="+value+"</@ofbizUrl>";
        form.submit();
    } else if (mode == "SP") {
        // split payment
        form.action="<@ofbizUrl>updateCheckoutOptions/checkoutpayment?partyId=${shoppingCart.getPartyId()}</@ofbizUrl>";
        form.submit();
    } else if (mode == "SA") {
        // selected shipping address
        form.action="<@ofbizUrl>updateCheckoutOptions/quickcheckout</@ofbizUrl>";
        form.submit();
    } else if (mode == "SC") {
        // selected ship to party
        form.action="<@ofbizUrl>cartUpdateShipToCustomerParty</@ofbizUrl>";
        form.submit();
    }
}
</script>

<!-- Main Container Starts -->
<form method="post" name="checkoutInfoForm" id="checkoutInfoForm" action="checkShippingAddress">
    <input type="hidden" name="checkoutpage" value="quick"/>
    <input type="hidden" name="BACK_PAGE" value="quickcheckout"/>
    <input type="hidden" name="may_split" value="false"/>
    <input type="hidden" name="is_gift" value="false"/>
    <input type="hidden" name="partyId" value="${partyId!}"/>
    <input type="hidden" id="shipping_contact_mech_id" name="shipping_contact_mech_id" value="${shipToContactMechId!}"/>
    <div id="main-container" class="container text-center-xs">
        <div class="panel-smart">
        <!-- Nested Row Starts -->
            <div class="row">
            <!-- Mainarea Starts -->
                <div class="col-sm-8 col-xs-12 fs-1">
                <!-- Nested Row Starts -->
                    <div class="row">
                    <!-- Shipping Address Starts -->
                        <div class="col-md-6 col-xs-12">
                        <!-- Heading Starts -->
                            <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.OrderShippingAddress}</h3>
                        <!-- Heading Ends -->
                        <!-- Delivery Method Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-deliver">${uiLabelMap.OrderSelectShippingMethod} <span class="text-color-5 font2">*</span></label>
                                <select id="shipping_method" name="shipping_method" class="form-control flat animation required">
                                    <#list carrierShipmentMethodList as carrierShipmentMethod>
                                        <#assign shippingMethod = carrierShipmentMethod.shipmentMethodTypeId + "@" + carrierShipmentMethod.partyId>
                                        <option value="${shippingMethod!}" <#if !parameters.shipping_method?exists && shippingMethod == "NO_SHIPPING@_NA_">selected="selected"</#if>>
                                            <#if shoppingCart.getShippingContactMechId()??>
                                                <#assign shippingEst = shippingEstWpr.getShippingEstimate(carrierShipmentMethod)?default(-1)>
                                            </#if>
                                            <#if carrierShipmentMethod.partyId != "_NA_">${carrierShipmentMethod.partyId!}&nbsp;</#if>${carrierShipmentMethod.description!}
                                            <#if shippingEst?has_content> - <#if (shippingEst > -1)><@ofbizCurrency amount=shippingEst isoCode=shoppingCart.getCurrency()/><#else>${uiLabelMap.OrderCalculatedOffline}</#if></#if>
                                        </option>
                                    </#list>
                                </select>
                            </div>
                        <!-- Delivery Method Ends -->
                        <!-- Destination Name Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-lname">${uiLabelMap.OrderDestination} ${uiLabelMap.PartyName} <span class="text-color-5 font2">*</span></label>
                                <input type="text" class="form-control flat animation required" id="toName" name="toName" value="${firstName!} ${lastName!} ${groupName!}">
                            </div>
                        <!-- Destination Name Ends -->
                        <!-- Address1 Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-address">${uiLabelMap.PartyAddressLine1} <span class="text-color-5 font2">*</span></label>
                                <textarea name="address1" id="shipToAddress1" rows="5" class="form-control flat animation required" maxlength="255">${shipToAddress1!}</textarea>
                            </div>
                        <!-- Address1 Ends -->
                        <!-- Address2 Starts -->
                            <#-- <div class="form-group">
                                <label class="text-uppercase" for="shipping-address">${uiLabelMap.PartyAddressLine2}</label>
                                <input type="text" class="form-control flat animation" id="shipToAddress2" name="shipToAddress1" value="${shipToAddress2!}" maxlength="255">
                            </div> -->
                        <!-- Address2 Ends -->
                        <!-- City Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-city">${uiLabelMap.CommonCity} <span class="text-color-5 font2">*</span></label>
                                <input type="text" class="form-control flat animation required" id="shipToCity" name="city" value="${shipToCity!}">
                            </div>
                        <!-- City Ends -->
                        <!-- Zip Code Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-zipcode">${uiLabelMap.PartyZipCode} <span class="text-color-5 font2">*</span></label>
                                <input type="text" class="form-control flat animation required" id="shipToPostalCode" name="postalCode" value="${shipToPostalCode!}">
                            </div>
                        <!-- Zip Code Ends -->
                        <!-- Country Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-country">${uiLabelMap.CommonCountry} <span class="text-color-5 font2">*</span></label>
                                <select name="countryGeoId" id="checkoutInfoForm_countryGeoId" class="form-control flat animation required">
                                    ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                                    <#assign defaultCountryGeoId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "country.geo.id.default", delegator)>
                                    <option selected="selected" value="${defaultCountryGeoId}">
                                    <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
                                    ${countryGeo.get("geoName",locale)}
                                    </option>
                                </select>
                            </div>
                        <!-- Country Ends -->
                        <!-- State Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-state">${uiLabelMap.CommonState} <span class="text-color-5 font2">*</span></label>
                                <select class="form-control required" name="stateProvinceGeoId" id="checkoutInfoForm_stateProvinceGeoId"></select>
                            </div>
                        <!-- State Ends -->
                        </div>
                    <!-- Shipping Address Ends -->
                        <div class="col-md-6 col-xs-12">
                        <!-- Heading Starts -->
                            <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.AccountingPaymentMethod}</h3>
                        <!-- Heading Ends -->
                            <#if productStorePaymentMethodTypeIdMap.EXT_OFFLINE?exists>
                                <div class="form-group">
                                    <input type="radio" name="checkOutPaymentId" value="EXT_OFFLINE" <#if "EXT_OFFLINE" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.OrderMoneyOrder}
                                </div>
                            </#if>
                            <#if productStorePaymentMethodTypeIdMap.EXT_PAYPAL?exists>
                                <div class="form-group">
                                    <input type="radio" name="checkOutPaymentId" value="EXT_PAYPAL" checked="checked"/>${uiLabelMap.AccountingPayWithPayPal}
                                </div>
                            </#if>
                            <#if productStorePaymentMethodTypeIdMap.EXT_COD?exists>
                                <div class="form-group">
                                    <input type="radio" name="checkOutPaymentId" value="EXT_COD" <#if "EXT_COD" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.OrderCOD}
                                </div>
                            </#if>
                            <#if productStorePaymentMethodTypeIdMap.EXT_WORLDPAY?exists>
                                <div class="form-group">
                                    <input type="radio" name="checkOutPaymentId" value="EXT_WORLDPAY" <#if "EXT_WORLDPAY" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.AccountingPayWithWorldPay}
                                </div>
                            </#if>
                            <#-- financial accounts -->
                            <#if finAccounts?has_content>
                                <#list finAccounts as finAccount>
                                <div class="form-group">
                                    <input type="radio" name="checkOutPaymentId" value="FIN_ACCOUNT|${finAccount.finAccountId}" <#if "FIN_ACCOUNT" == checkOutPaymentId>checked="checked"</#if>/>${uiLabelMap.AccountingFinAccount} #${finAccount.finAccountId}
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
                                                <input type="radio" name="checkOutPaymentId" value="${paymentMethod.paymentMethodId}" <#if shoppingCart.isPaymentSelected(paymentMethod.paymentMethodId)>checked="checked"</#if>/>
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
                    </div>
                <!-- Nested Row Ends -->
                </div>
            <!-- Mainarea Ends -->
            <!-- Spacer Starts -->
                <div class="col-xs-12 hidden visible-xs">
                    <div class="spacer-big"></div>
                </div>
            <!-- Spacer Ends -->
            <!-- Sidearea Starts -->
                <div class="col-sm-4 col-xs-12 fs-1">
                <!-- Starts -->
                    <div class="sbox-1">
                    <!-- Your Order Details Starts -->
                        <h5 class="hs-1 text-color-5 text-bold text-uppercase text-center-xs">${uiLabelMap.PFTYourOrderDetails}</h5>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>${uiLabelMap.CommonProduct}</th>
                                        <th class="text-center">${uiLabelMap.CommonQty}</th>
                                        <th class="text-right">${uiLabelMap.CommonTotal}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <#list shoppingCart.items() as cartLine>
                                        <tr>
                                            <td>${cartLine.getName()?if_exists}</td>
                                            <td class="text-center">x${cartLine.getQuantity()?string.number?default(0)}</td>
                                            <td class="text-right"><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></td>
                                        </tr>
                                    </#list>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <#assign orderAdjustmentsTotal = 0 />
                                        <#list shoppingCart.getAdjustments() as cartAdjustment>
                                          <#assign orderAdjustmentsTotal = orderAdjustmentsTotal +
                                              Static["org.apache.ofbiz.order.order.OrderReadHelper"]
                                              .calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) />
                                        </#list>
                                        <th colspan="2">${uiLabelMap.EcommerceAdjustment}</th>
                                        <td class="text-right"><@ofbizCurrency amount=orderAdjustmentsTotal isoCode=shoppingCart.getCurrency() /></td>
                                    </tr>
                                    <tr>
                                        <th colspan="2">${uiLabelMap.CommonSubtotal}</th>
                                        <td class="text-right"><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></td>
                                    </tr>
                                    <tr>
                                        <th colspan="2">${uiLabelMap.OrderShippingAndHandling}</th>
                                        <td class="text-right"><@ofbizCurrency amount=shoppingCart.getTotalShipping() isoCode=shoppingCart.getCurrency() /></td>
                                    </tr>
                                    <tr>
                                        <th colspan="2">${uiLabelMap.OrderSalesTax}</th>
                                        <td class="text-right"><@ofbizCurrency amount=shoppingCart.getTotalSalesTax() isoCode=shoppingCart.getCurrency() /></td>
                                    </tr>
                                    <tr>
                                        <th colspan="2">${uiLabelMap.OrderGrandTotal}</th>
                                        <td class="text-right"><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency() /></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    <!-- Your Order Details Ends -->
                    <!-- Spacer Starts -->
                        <div class="spacer"></div>
                    <!-- Spacer Ends -->
                        <div class="checkbox">
                            <label class="checkbox-style-1">
                                <input type="checkbox"> ${uiLabelMap.PFTIHaveReadAndAcceptThe} <a href="<@ofbizUrl>showhelpcontent</@ofbizUrl>?contentId=HELP_TERMSANDCON&nodeTrailCsv=HELP_TERMSANDCON">${uiLabelMap.PFTTermsAndCons}</a>
                            </label>
                        </div>
                        <button type="submit" id="finalOrderBtn" class="btn btn-secondary btn-block btn-style-1 animation flat text-uppercase"
                            onclick="javascript:$(document.checkoutInfoForm).submit();" disabled>
                            ${uiLabelMap.OrderContinueToFinalOrderReview}
                        </button>
                    </div>
                <!-- Ends -->
                </div>
            <!-- Sidearea Ends -->
            </div>
        </div>
    <!-- Nested Row Ends -->
    </div>
<!-- Main Container Ends -->
</form>

<script>
jQuery(document).ready( function() {
    jQuery("#checkoutInfoForm").validate({
        submitHandler: function(form) {
            checkShippingAddress();
        }
    });

    $("#acceptcondition").change(function() {
    console.log($("#acceptcondition").is(":checked"))
        if ($("#acceptcondition").is(":checked")) {
            $("#finalOrderBtn").prop("disabled", false);
        } else {
            $("#finalOrderBtn").prop("disabled", true);
        }
    })
});

function checkShippingAddress() {
    waitSpinnerShow();
    $.ajax({
        url: 'checkShippingAddress',
        type: 'POST',
        data: $('#checkoutInfoForm').serialize(),
        async: false,
        success: function(data) {
            waitSpinnerHide();
            if (data.shipping_contact_mech_id) {
                $("#shipping_contact_mech_id").val(data.shipping_contact_mech_id);
                submitForm(document.checkoutInfoForm, 'DN', '');
            }
        }
    });
}
</script>
