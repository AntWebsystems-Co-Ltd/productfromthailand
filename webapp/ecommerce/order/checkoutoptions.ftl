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
    enterStep(1)
    $("#newaddressform").validate();
});

function enterStep(step) {
    if(step == 1) {
        step1Function(true);
        step2Function(false);
        step3Function(false);
    } else if(step == 2) {
        step1Function(false);
        step2Function(true);
        step3Function(false);
    } else if (step == 3) {
        step1Function(false);
        step2Function(false);
        step3Function(true);
    }
}

function step1Function(status) {
    if(status == true) {
        $(".step").removeClass("current");
        $("#checkoutStepHeader1").addClass("current");
        $("#chosenAddress").addClass("hide");
        $("#chooseAddress").removeClass("hide");
        $('#step1Controller').removeClass('hide');
        $('#checkoutStep1').removeClass('checkoutNotCurrent');
    } else {
        $("#checkoutStepHeader1").removeClass("current");
        $("#chosenAddress").removeClass("hide");
        $("#chooseAddress").addClass("hide");
        $('#step1Controller').addClass('hide');
        $('#checkoutStep1').addClass('checkoutNotCurrent');
    }
}

function step2Function(status) {
    if(status == true) {
        $(".step").removeClass("current");
        $("#checkoutStepHeader2").addClass("current");
        $("input[name='shipping_method']").prop("disabled", false);
        $("input[name='checkOutPaymentId']").prop("disabled", false);
        $('#step2Controller').removeClass('hide');
        $('#checkoutStep2').removeClass('checkoutNotCurrent');
    } else {
        $("#checkoutStepHeader2").removeClass("current");
        $("input[name='shipping_method']").prop("disabled", true);
        $("input[name='checkOutPaymentId']").prop("disabled", true);
        $('#step2Controller').addClass('hide');
        $('#checkoutStep2').addClass('checkoutNotCurrent');
    }
}

function step3Function(status) {
    if(status == true) {
        $(".step").removeClass("current");
        $("#checkoutStepHeader3").addClass("current");
        $("#checkoutStep3Button").removeClass("hide");
        $('#checkouttotal_shipping').removeClass('hide');
        $('#step3Controller').removeClass('hide');
        $('#checkoutStep3').removeClass('checkoutNotCurrent');
    } else {
        $("#checkoutStepHeader3").removeClass("current");
        $("#checkoutStep3Button").addClass("hide");
        $('#checkouttotal_shipping').addClass('hide');
        $('#step3Controller').addClass('hide');
        $('#checkoutStep3').addClass('checkoutNotCurrent');
    }
}

function checkShippingAddress() {
    waitSpinnerShow();
    $("#newAddressDiv").remove();
    $("input").prop("disabled", false);
    $("#checkoutInfoForm").attr("action", "<@ofbizUrl>checkout</@ofbizUrl>");
    $("#checkoutInfoForm").submit();
}
function toggleNewAddress() {
    $('#checkoutInfoForm_toName').val(null);
    $('#checkoutInfoForm_shipToAddress1').val(null);
    $('#checkoutInfoForm_shipToCity').val(null);
    $('#checkoutInfoForm_shipToPostalCode').val(null);
    $('#newAddressDiv').toggleClass('hide')
    $('#chooseAddress').toggleClass('hide')
    $('#step1Controller').toggleClass('hide')
}
function saveNewAddress() {
    validform = $("#checkoutInfoForm_toName").valid() &&
    $("#checkoutInfoForm_shipToAddress1").valid() &&
    $("#checkoutInfoForm_shipToCity").valid() &&
    $("#checkoutInfoForm_shipToPostalCode").valid() &&
    $("#checkoutInfoForm_countryGeoId").valid() &&
    $("#checkoutInfoForm_stateProvinceGeoId").valid();
    if(validform) {
        $('#newaddressform_toName').val($('#checkoutInfoForm_toName').val());
        $('#newaddressform_address1').val($('#checkoutInfoForm_shipToAddress1').val());
        $('#newaddressform_city').val($('#checkoutInfoForm_shipToCity').val());
        $('#newaddressform_postalCode').val($('#checkoutInfoForm_shipToPostalCode').val());
        $('#newaddressform_countryGeoId').val($('#checkoutInfoForm_countryGeoId').val());
        $('#newaddressform_stateProvinceGeoId').val($('#checkoutInfoForm_stateProvinceGeoId').val());
        waitSpinnerShow();
        jQuery.ajax({
            url: '<@ofbizUrl>quickCheckoutCreatePostalAddressAndPurpose</@ofbizUrl>',
            type: 'POST',
            async: false,
            data: jQuery('#newaddressform').serialize(),
            success: function(json) {
                ajaxUpdateArea("step1Ajax", "<@ofbizUrl>checkoutoptionsAddress</@ofbizUrl>", null);
                toggleNewAddress();
                waitSpinnerHide();
            }
        });
    }
}

function saveAddress() {
    waitSpinnerShow();
    jQuery.ajax({
        url: '<@ofbizUrl>updateCheckoutOption</@ofbizUrl>',
        type: 'POST',
        async: false,
        data: jQuery('#checkoutInfoForm').serialize(),
        success: function(json) {
            ajaxUpdateArea("step1Ajax", "<@ofbizUrl>checkoutoptionsAddress</@ofbizUrl>", null);
            ajaxUpdateArea("step2Ajax", "<@ofbizUrl>checkoutoptionsPayments</@ofbizUrl>", null);
            setTimeout(function(){
                enterStep(2);
            }, 100);
            waitSpinnerHide();
        }
    });
}

function savePaymentsMethod() {
    waitSpinnerShow();
    jQuery.ajax({
        url: '<@ofbizUrl>updateCheckoutOptionAndShipping</@ofbizUrl>',
        type: 'POST',
        async: false,
        data: jQuery('#checkoutInfoForm').serialize(),
        success: function(json) {
            ajaxUpdateArea("step2Ajax", "<@ofbizUrl>checkoutoptionsPayments</@ofbizUrl>", null);
            ajaxUpdateArea("step3Ajax", "<@ofbizUrl>checkoutoptionsOrderDetails</@ofbizUrl>", null);
            setTimeout(function(){
                enterStep(3);
            }, 100);
            waitSpinnerHide();
        }
    });
}

function stepAction(action, step) {
    if(action === "next") {
        if(step == 1) {
            //submitForm(document.checkoutInfoForm, 'SA', null);
            saveAddress();
        } else if(step == 2) {
            //submitForm(document.checkoutInfoForm, 'SM', null);
            savePaymentsMethod();
        } else if(step == 3) {
            checkShippingAddress();
        }
    } else if(action === "back") {
        if(step == 2) {
            enterStep(1);
        } else if(step == 3) {
            enterStep(2);
        }
    }
}
</script>


<form method="post" action="<@ofbizUrl>quickCheckoutCreatePostalAddressAndPurpose</@ofbizUrl>" name="newaddressform" id="newaddressform">
    <input type="hidden" name="checkoutStep" id="checkoutStep" value="1">
    <input type="hidden" name="contactMechTypeId" value="POSTAL_ADDRESS">
    <input type="hidden" name="partyId" value="${partyId!}"/>
    <input type="hidden" name="contactMechPurposeTypeId" value="SHIPPING_LOCATION">
    <input type="hidden" name="preContactMechTypeId" value="POSTAL_ADDRESS">
    <input type="hidden" name="toName" id="newaddressform_toName">
    <input type="hidden" name="address1" id="newaddressform_address1">
    <input type="hidden" name="city" id="newaddressform_city">
    <input type="hidden" name="postalCode" id="newaddressform_postalCode">
    <input type="hidden" name="countryGeoId" id="newaddressform_countryGeoId">
    <input type="hidden" name="stateProvinceGeoId" id="newaddressform_stateProvinceGeoId">
</form>
<form method="post" name="checkoutInfoForm" id="checkoutInfoForm">
    <input type="hidden" name="checkoutpage" value="quick"/>
    <input type="hidden" name="BACK_PAGE" value="quickcheckout"/>
    <input type="hidden" name="may_split" value="false"/>
    <input type="hidden" name="is_gift" value="false"/>
    <input type="hidden" name="partyId" value="${partyId!}"/>
<#-- Main Container Starts -->
    <div id="main-container" class="container text-center-xs">
        <div class="panel-smart">
            <div class="row">
                <div class="arrow-steps clearfix">
                    <div id="checkoutStepHeader1" class="step arrow-width">
                        <span>${uiLabelMap.PFTStep} 1<br><div class="step-description">${uiLabelMap.PFTStepHeader1}</div></span>
                    </div>
                    <div id="checkoutStepHeader2" class="step arrow-width">
                        <span>${uiLabelMap.PFTStep} 2<br><div class="step-description">${uiLabelMap.PFTStepHeader2}</div></span>
                    </div>
                    <div id="checkoutStepHeader3" class="step arrow-width">
                        <span>${uiLabelMap.PFTStep} 3<br><div class="step-description">${uiLabelMap.PFTStepHeader3}</div></span>
                    </div>
                </div>
            </div>
        <#-- Nested Row Starts -->
            <div class="row">
            <#-- Mainarea Starts -->
                <div class="col-sm-4 col-xs-12 fs-1 checkoutNotCurrent" id="checkoutStep1">
                <#-- Shipping Address Starts -->
                    <div id="shippingAddress">
                    <#-- Heading Starts -->
                        <h3 class="hs-1 text-center-xs text-color-6 text-uppercase text-bold">${uiLabelMap.OrderShippingAddress}</h3>
                    <#-- Heading Ends -->
                    <#-- New Address Starts -->
                        <div id="newAddressDiv" class="hide">
                        <#-- Destination Name Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-lname">${uiLabelMap.OrderDestination} ${uiLabelMap.PartyName} <span class="text-color-5 font2">*</span></label>
                                <input name="newaddressform_toName" type="text" id="checkoutInfoForm_toName" class="form-control flat animation required">
                            </div>
                        <#-- Destination Name Ends -->
                        <#-- Address1 Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-address">${uiLabelMap.PartyAddressLine1} <span class="text-color-5 font2">*</span></label>
                                <textarea name="newaddressform_address1" id="checkoutInfoForm_shipToAddress1" rows="5" class="form-control flat animation required" maxlength="255"></textarea>
                            </div>
                        <#-- Address1 Ends -->
                        <#-- Address2 Starts -->
                            <#-- <div class="form-group">
                                <label class="text-uppercase" for="shipping-address">${uiLabelMap.PartyAddressLine2}</label>
                                <textarea name="address2" id="shipToAddress2" rows="5" class="form-control flat animation required" maxlength="255"></textarea>
                            </div> -->
                        <#-- Address2 Ends -->
                        <#-- City Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-city">${uiLabelMap.PFTCity} <span class="text-color-5 font2">*</span></label>
                                <input name="newaddressform_city" type="text" id="checkoutInfoForm_shipToCity" class="form-control flat animation required">
                            </div>
                        <#-- City Ends -->
                        <#-- Zip Code Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-zipcode">${uiLabelMap.PartyZipCode} <span class="text-color-5 font2">*</span></label>
                                <input name="newaddressform_postalCode" type="text" id="checkoutInfoForm_shipToPostalCode" class="form-control flat animation required">
                            </div>
                        <#-- Zip Code Ends -->
                        <#-- Country Starts -->
                            <div class="form-group">
                                <label class="text-uppercase" for="shipping-country">${uiLabelMap.CommonCountry} <span class="text-color-5 font2">*</span></label>
                                <select name="newaddressform_countryGeoId" id="checkoutInfoForm_countryGeoId" class="form-control flat animation required">
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
                                <select name="newaddressform_stateProvinceGeoId" id="checkoutInfoForm_stateProvinceGeoId" class="form-control required"></select>
                            </div>
                        <#-- State Ends -->
                        <#-- check out Address button -->
                            <div class="form-group">
                                <button type="button" id="saveNewAddressButton" class="btn btn-main btn-style-1 animation flat text-uppercase"
                                onclick="javascript:saveNewAddress();">
                                    ${uiLabelMap.CommonSave}
                                </button>
                                <button type="button" id="cancelNewAddressButton" class="btn btn-main btn-style-1 animation flat text-uppercase"
                                    onclick="javascript:toggleNewAddress();">
                                    ${uiLabelMap.CommonCancel}
                                </button>
                            </div>
                        <#-- check out Address button -->
                        </div>
                    <#-- New Address Ends -->
                        <div id="step1Ajax">
                            <#include "component://productfromthailand/webapp/ecommerce/order/checkoutoptionsAddress.ftl">
                        </div>
                        <#-- Step 1 Controller Starts -->
                        <div id="step1Controller" class="stepController hide">
                            <button type="button" id="step1NextButton" class="btn btn-main btn-style-1 animation flat text-uppercase hide"
                                onclick="javascript:stepAction('next',1);" style="float: right; background-color: #0d9cd7;">
                                ${uiLabelMap.CommonNext}
                            </button>
                        </div>
                        <#-- Step 1 Controller Ends -->
                    </div>
                <#-- Shipping Address Ends -->
                </div>
                <div class="col-sm-4 col-xs-12 fs-1 checkoutNotCurrent" id="checkoutStep2">
                    <div id="step2Ajax">
                        <#include "component://productfromthailand/webapp/ecommerce/order/checkoutoptionsPayments.ftl">
                    </div>
                <#-- Step 2 Controller Starts -->
                    <div id="step2Controller" class="stepController hide" style="text-align: center;">
                        <button type="button" id="step2NextButton" class="btn btn-main btn-style-1 animation flat text-uppercase hide"
                            onclick="javascript:stepAction('next',2);" style="float: right; background-color: #0d9cd7;">
                            ${uiLabelMap.CommonNext}
                        </button>
                        <button type="button" id="step2BackButton" class="btn btn-main btn-style-1 animation flat text-uppercase"
                            onclick="stepAction('back',2);" style="float: left; background-color: #0d9cd7;">
                            ${uiLabelMap.CommonBack}
                        </button>
                    </div>
                <#-- Step 2 Controller Ends -->
                </div>
            <#-- Mainarea Ends -->
            <#-- Spacer Starts -->
                <div class="col-xs-12 hidden visible-xs">
                    <div class="spacer-big"></div>
                </div>
            <#-- Spacer Ends -->
            <#-- Sidearea Starts -->
                <div class="col-sm-4 col-xs-12 fs-1 checkoutNotCurrent" id="checkoutStep3">
                <#-- Starts -->
                    <div id="orderDetails" class="sbox-1">
                    <#-- Your Order Details Starts -->
                        <h5 class="hs-1 text-color-5 text-bold text-uppercase text-center-xs">${uiLabelMap.PFTYourOrderDetails}</h5>
                        <div id="step3Ajax">
                            <#include "component://productfromthailand/webapp/ecommerce/order/checkoutoptionsOrderDetails.ftl">
                        </div>
                    <#-- Step 3 Controller Starts -->
                        <div id="step3Controller" class="stepController hide">
                            <button type="button" id="step3BackButton" class="btn btn-main btn-style-1 animation flat text-uppercase"
                                onclick="javascript:stepAction('back',3);" style="float: left; background-color: #0d9cd7;">
                                ${uiLabelMap.CommonBack}
                            </button>
                        </div>
                    <#-- Step 3 Controller Ends -->
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