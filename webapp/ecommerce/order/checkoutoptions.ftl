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
        form.action="<@ofbizUrl>updateCheckoutOption</@ofbizUrl>";
        form.submit();
    } else if (mode == "SM") {
        // selected shipping method
        form.action="<@ofbizUrl>updateCheckoutOptionAndShipping</@ofbizUrl>";
        form.submit();
    } else if (mode == "SC") {
        // selected ship to party
        form.action="<@ofbizUrl>cartUpdateShipToCustomerParty</@ofbizUrl>";
        form.submit();
    }
}
</script>

<#-- Main Container Starts -->
<form method="post" name="checkoutInfoForm" id="checkoutInfoForm">
    <input type="hidden" name="checkoutpage" value="quick"/>
    <input type="hidden" name="BACK_PAGE" value="quickcheckout"/>
    <input type="hidden" name="may_split" value="false"/>
    <input type="hidden" name="is_gift" value="false"/>
    <input type="hidden" name="partyId" value="${partyId!}"/>
    <input type="hidden" id="shipping_contact_mech_id" name="shipping_contact_mech_id" value="${shipToContactMechId!}"/>
    <div id="main-container" class="container text-center-xs">
        <div class="panel-smart">
        <#-- Nested Row Starts -->
            <div class="row">
            <#-- Mainarea Starts -->
                <div class="col-sm-8 col-xs-12 fs-1">
                <#-- Nested Row Starts -->
                    <div class="row">
                        <div class="col-md-6 col-xs-12">
                        <#-- Shipping Address Starts -->
                            <div id="shippingAddress">
                            <#-- Heading Starts -->
                                <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.OrderShippingAddress}</h3>
                            <#-- Heading Ends -->
                            <#-- Destination Name Starts -->
                                <div class="form-group">
                                    <label class="text-uppercase" for="shipping-lname">${uiLabelMap.OrderDestination} ${uiLabelMap.PartyName} <span class="text-color-5 font2">*</span></label>
                                    <input type="text" class="form-control flat animation required" id="toName" name="toName" value="<#if shipToName??>${shipToName!}<#else>${firstName!} <#if lastName??>${lastName!}</#if></#if>">
                                </div>
                            <#-- Destination Name Ends -->
                            <#-- Address1 Starts -->
                                <div class="form-group">
                                    <label class="text-uppercase" for="shipping-address">${uiLabelMap.PartyAddressLine1} <span class="text-color-5 font2">*</span></label>
                                    <textarea name="address1" id="shipToAddress1" rows="5" class="form-control flat animation required" maxlength="255">${shipToAddress1!}</textarea>
                                </div>
                            <#-- Address1 Ends -->
                            <#-- Address2 Starts -->
                                <#-- <div class="form-group">
                                    <label class="text-uppercase" for="shipping-address">${uiLabelMap.PartyAddressLine2}</label>
                                    <input type="text" class="form-control flat animation" id="shipToAddress2" name="shipToAddress1" value="${shipToAddress2!}" maxlength="255">
                                </div> -->
                            <#-- Address2 Ends -->
                            <#-- City Starts -->
                                <div class="form-group">
                                    <label class="text-uppercase" for="shipping-city">${uiLabelMap.PFTCity} <span class="text-color-5 font2">*</span></label>
                                    <input type="text" class="form-control flat animation required" id="shipToCity" name="city" value="${shipToCity!}">
                                </div>
                            <#-- City Ends -->
                            <#-- Zip Code Starts -->
                                <div class="form-group">
                                    <label class="text-uppercase" for="shipping-zipcode">${uiLabelMap.PartyZipCode} <span class="text-color-5 font2">*</span></label>
                                    <input type="text" class="form-control flat animation required" id="shipToPostalCode" name="postalCode" value="${shipToPostalCode!}">
                                </div>
                            <#-- Zip Code Ends -->
                            <#-- Country Starts -->
                                <div class="form-group">
                                    <label class="text-uppercase" for="shipping-country">${uiLabelMap.CommonCountry} <span class="text-color-5 font2">*</span></label>
                                    <select name="countryGeoId" id="checkoutInfoForm_countryGeoId" class="form-control flat animation required">
                                        ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                                        <#if (shipToCountryGeoId??)>
                                            <#assign defaultCountryGeoId = shipToCountryGeoId>
                                        <#else>
                                            <#assign defaultCountryGeoId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "country.geo.id.default", delegator)>
                                        </#if>
                                        <option selected="selected" value="${defaultCountryGeoId}">
                                        <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"]
                                            .toMap("geoId",defaultCountryGeoId), false)>
                                        ${countryGeo.get("geoName",locale)}
                                        </option>
                                    </select>
                                </div>
                            <#-- Country Ends -->
                            <#-- State Starts -->
                                <div class="form-group">
                                    <label class="text-uppercase" for="shipping-state">${uiLabelMap.PartyState} <span class="text-color-5 font2">*</span></label>
                                    <select class="form-control required" name="stateProvinceGeoId" id="checkoutInfoForm_stateProvinceGeoId"></select>
                                </div>
                            <#-- State Ends -->
                            <#-- check out Address button -->
                                <div class="form-group">
                                    <br>
                                        <button type="submit" id="checkOutAddress" class="btn btn-secondary btn-style-1 animation flat text-uppercase<#if shoppingCart.getShippingContactMechId()?has_content> hide</#if>"
                                            onclick="javascript:confirmCheckOutAddress()">
                                            ${uiLabelMap.PFTConfirmAddress}
                                        </button>
                                        <button type="button" id="resetAddress" class="btn btn-secondary btn-style-1 animation flat text-uppercase<#if !shoppingCart.getShippingContactMechId()?has_content> hide</#if>"
                                            onclick="javascript:changeCheckOutAddress()">
                                            ${uiLabelMap.PFTChangeAddress}
                                        </button>
                                    </br>
                                </div>
                            <#-- check out Address button -->
                            </div>
                        <#-- Shipping Address Ends -->
                        </div>
                        <div class="col-md-6 col-xs-12">
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
                                        <input type="radio" id="checkOutPaymentId" name="checkOutPaymentId" value="EXT_PAYPAL" checked="checked"/>${uiLabelMap.AccountingPayWithPayPal}
                                        <#if parameters.locale == "th">
                                            <a href="<@ofbizUrl>showhelpcontent?contentId=CHECKOUT_PAYPAL_TH&nodeTrailCsv=CHECKOUT_PAYPAL_TH</@ofbizUrl>">
                                        <#else>
                                            <a href="<@ofbizUrl>showhelpcontent?contentId=CHECKOUT_PAYPAL&nodeTrailCsv=CHECKOUT_PAYPAL</@ofbizUrl>">
                                        </#if>
                                            <i class="fa fa-question-circle-o" style="font-size: 20px"></i>
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
                        </div>
                    </div>
                <#-- Nested Row Ends -->
                </div>
            <#-- Mainarea Ends -->
            <#-- Spacer Starts -->
                <div class="col-xs-12 hidden visible-xs">
                    <div class="spacer-big"></div>
                </div>
            <#-- Spacer Ends -->
            <#-- Sidearea Starts -->
                <div class="col-sm-4 col-xs-12 fs-1">
                <#-- Starts -->
                    <div id="orderDetails" class="sbox-1">
                    <#-- Your Order Details Starts -->
                        <h5 class="hs-1 text-color-5 text-bold text-uppercase text-center-xs">${uiLabelMap.PFTYourOrderDetails}</h5>
                        <div class="table-responsive">
                            <table class="table table-bordered" id="checkoutreview-table">
                                <thead>
                                    <tr>
                                        <th>${uiLabelMap.CommonProduct}</th>
                                        <th class="text-center">${uiLabelMap.CommonQty}</th>
                                        <th class="text-right">${uiLabelMap.CommonTotal}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <#list shoppingCart.items() as cartLine>
                                        <tr id="checkoutreview-detail">
                                            <td>${StringUtil.wrapString(cartLine.getName()?if_exists)}</td>
                                            <td class="text-center">x${cartLine.getQuantity()?string.number?default(0)}</td>
                                            <td class="text-right"><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></td>
                                        </tr>
                                    </#list>
                                </tbody>
                                <tfoot>
                                    <tr id="checkouttotal">
                                        <#assign orderAdjustmentsTotal = 0 />
                                        <#list shoppingCart.getAdjustments() as cartAdjustment>
                                          <#assign orderAdjustmentsTotal = orderAdjustmentsTotal +
                                              Static["org.apache.ofbiz.order.order.OrderReadHelper"]
                                              .calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) />
                                        </#list>
                                        <td colspan="2"><b>${uiLabelMap.EcommerceAdjustment}</b></td>
                                        <td class="text-right"><b><@ofbizCurrency amount=orderAdjustmentsTotal isoCode=shoppingCart.getCurrency() /></b></td>
                                    </tr>
                                    <tr id="checkouttotal">
                                        <td colspan="2"><b>${uiLabelMap.CommonSubtotal}</b></td>
                                        <td class="text-right"><b><@ofbizCurrency amount=shoppingCart.getSubTotal() isoCode=shoppingCart.getCurrency()/></b></td>
                                    </tr>
                                    <tr id="checkouttotal">
                                        <td colspan="2"><b>${uiLabelMap.OrderShippingAndHandling}</b></td>
                                        <td class="text-right"><b><@ofbizCurrency amount=shoppingCart.getTotalShipping() isoCode=shoppingCart.getCurrency() /></b></td>
                                    </tr>
                                    <tr id="checkouttotal">
                                        <td colspan="2"><b>${uiLabelMap.PFTSalesTax}</b></td>
                                        <td class="text-right"><b><@ofbizCurrency amount=shoppingCart.getTotalSalesTax() isoCode=shoppingCart.getCurrency() /></b></td>
                                    </tr>
                                    <tr id="checkouttotal">
                                        <td colspan="2"><b>${uiLabelMap.OrderGrandTotal}</b></td>
                                        <td class="text-right"><b><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency() /></b></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    <#-- Your Order Details Ends -->
                    <#-- Spacer Starts -->
                        <div class="spacer"></div>
                    <#-- Spacer Ends -->
                        <div class="checkbox">
                            <label class="checkbox-style-1">
                                <input type="checkbox" id="acceptcondition" disabled> ${uiLabelMap.PFTIHaveReadAndAcceptThe} <a href="<@ofbizUrl>showhelpcontent</@ofbizUrl>?contentId=HELP_TERMSANDCON&nodeTrailCsv=HELP_TERMSANDCON">${uiLabelMap.PFTTermsAndCons}</a>
                            </label>
                        </div>
                        <button type="submit" id="finalOrderBtn" class="btn btn-secondary btn-block btn-style-1 animation flat text-uppercase"
                            onclick="javascript:checkShippingAddress()" disabled>
                            ${uiLabelMap.OrderContinueToFinalOrderReview}
                        </button>
                    </div>
                <#-- Ends -->
                </div>
            <#-- Sidearea Ends -->
            </div>
        </div>
    <#-- Nested Row Ends -->
    </div>
<#-- Main Container Ends -->
</form>

<script>
jQuery(document).ready( function() {
    <#if shoppingCart.getShippingContactMechId()?exists>
        <#if chosenShippingMethod?exists>
            $("input[name='shipping_method'][value='${StringUtil.wrapString(chosenShippingMethod)}']").attr('checked', 'checked');
        </#if>
        firstStepDisabled(true);
    <#else>
        nextStepDisabled(true);
    </#if>
    isCheckedShippingAndPayment();
    $("input:radio[name='shipping_method']").change(function() {
        waitSpinnerShow();
        submitForm(document.checkoutInfoForm, 'SM', '');
    })
    $("#acceptcondition").change(function() {
        if ($("#acceptcondition").is(":checked")) {
            $("#finalOrderBtn").prop("disabled", false);
        } else {
            $("#finalOrderBtn").prop("disabled", true);
        }
    })
});

function isCheckedShippingAndPayment() {
    if ($("input:radio[name='shipping_method']").is(":checked") && $("input:radio[name='checkOutPaymentId']").is(":checked")) {
        $("#acceptcondition").prop("disabled", false);
    } else {
        $("#acceptcondition").prop("disabled", true);
    }
}
function firstStepDisabled(status) {
    $("#toName").prop("disabled", status);
    $("#shipToAddress1").prop("disabled", status);
    $("#shipToCity").prop("disabled", status);
    $("#shipToPostalCode").prop("disabled", status);
    $("#checkoutInfoForm_countryGeoId").prop("disabled", status);
    $("#checkoutInfoForm_stateProvinceGeoId").prop("disabled", status);
}
function nextStepDisabled(status) {
    $("input:radio[name='checkOutPaymentId']").prop("disabled", status);
    $("input:radio[name='shipping_method']").prop("disabled", status);
    $("#acceptcondition").prop("disabled", status);
    $("#finalOrderBtn").prop("disabled", status);
}

function checkShippingAddress() {
    firstStepDisabled(false);
    jQuery("#checkoutInfoForm").validate({
        submitHandler: function() {
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
    });
}
function confirmCheckOutAddress() {
    jQuery("#checkoutInfoForm").validate({
        submitHandler: function() {
            waitSpinnerShow();
            $.ajax({
                url: 'confirmAddress',
                type: 'POST',
                data: $('#checkoutInfoForm').serialize(),
                async: false,
                success: function(data) {
                    waitSpinnerHide();
                    if (data.shipping_contact_mech_id) {
                        $("#shipping_contact_mech_id").val(data.shipping_contact_mech_id);
                        submitForm(document.checkoutInfoForm, 'SA', '');
                    }
                }
            });
        }
    });
}
function changeCheckOutAddress() {
    firstStepDisabled(false);
    nextStepDisabled(true);
    $("#resetAddress").addClass("hide");
    $("#checkOutAddress").removeClass("hide");
}
</script>
