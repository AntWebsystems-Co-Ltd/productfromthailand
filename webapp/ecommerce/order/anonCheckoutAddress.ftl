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
    $("#anonProcessCustomer").validate();
    <#if (parameters.shipToStateProvinceGeoId??)>
        $("#anonProcessCustomer_shipToStateProvinceGeoId").val("${parameters.shipToStateProvinceGeoId!}");
    </#if>
});
function anonProcessCustomerSubmit() {
    $("#shipToName").val($("#firstName").val() + " " + $("#lastName").val());
    validform = $("#anonProcessCustomer").valid();
    if(validform) {
        $("#anonProcessCustomer").submit();
    }
}
<#if (parameters.partyId??)>
$(document).ready( function() {
    $("#anonProcessCustomerForm").addClass("hide");
});
function anonProcessCustomerEdit() {
    $("#anonProcessCustomerForm").toggleClass("hide");
    $("#anonProcessCustomerValue").toggleClass("hide");
}
function anonProcessCustomerContinue() {
    location.href = "<@ofbizUrl>anonCheckoutShippingPayments</@ofbizUrl>";
}
</#if>

</script>
<style>
.form-group {
    overflow: auto;
}
</style>
<div id="main-container" class="container text-center-xs">
    <div class="panel-smart col3-banners">
        <div class="arrow-steps clearfix">
            <div id="checkoutStepHeader1" class="step arrow-width current">
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
    <div class="col-sm-7">
        <div class="panel-smart">
            <div id="anonProcessCustomerForm">
                <form name="anonProcessCustomer" id="anonProcessCustomer" method="post" action="<@ofbizUrl>anonProcessCustomer</@ofbizUrl>">
                    <input type="hidden" name="partyId" value="${parameters.partyId!}"/>
                    <input type="hidden" name="shippingContactMechId" value="${parameters.shippingContactMechId!}"/>
                    <input type="hidden" name="emailContactMechId" value="${parameters.emailContactMechId!}"/>
                    <input type="hidden" name="billingContactMechId" value="${parameters.billingContactMechId!}"/>
                    <input type="hidden" name="shippingContactMechPurposeTypeId" value="${parameters.shippingContactMechPurposeTypeId!}"/>
                    <input type="hidden" name="billingContactMechPurposeTypeId" value="${parameters.billingContactMechPurposeTypeId!}"/>
                    <input type="hidden" name="shipToName" id="shipToName" value="${parameters.shipToName!}"/>
                    <input type="hidden" name="useShippingPostalAddressForBilling" value="Y"/>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_firstName} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <input name="firstName" type="text" id="firstName" class="form-control flat animation required" value="${parameters.firstName!}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_lastName} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <input name="lastName" type="text" id="lastName" class="form-control flat animation required" value="${parameters.lastName!}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.PartyEmailAddress} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <input name="emailAddress" type="text" id="emailAddress" class="form-control flat animation required validate-email" value="${parameters.emailAddress!}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.OrderAddress} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <textarea name="shipToAddress1" id="shipToAddress1" rows="5" class="form-control flat animation required" maxlength="255">${parameters.shipToAddress1!}</textarea>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.PFTCity} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <input name="shipToCity" type="text" id="shipToCity" class="form-control flat animation required" value="${parameters.shipToCity!}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.PartyZipCode} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <input name="shipToPostalCode" type="text" id="shipToPostalCode" class="form-control flat animation required" value="${parameters.shipToPostalCode!}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.CommonCountry} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <select name="shipToCountryGeoId" id="anonProcessCustomer_shipToCountryGeoId" class="form-control flat animation required">
                                ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                                <#if (parameters.shipToCountryGeoId??)>
                                    <#assign defaultCountryGeoId = parameters.shipToCountryGeoId>
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
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">${uiLabelMap.PartyState} <span class="text-color-5 font2">*</span></label>
                        <div class="col-sm-9">
                            <select name="shipToStateProvinceGeoId" id="anonProcessCustomer_shipToStateProvinceGeoId" class="form-control required"></select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label"></label>
                        <button type="button" id="anonContinue" class="btn btn-secondary btn-right btn-style-1 animation flat text-uppercase"
                        onclick="javascript:anonProcessCustomerSubmit();">
                            ${uiLabelMap.PFTContinue}
                        </button>
                    </div>
                </form>
            </div>
            <#if (parameters.partyId??)>
            <div id="anonProcessCustomerValue">
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.FormFieldTitle_firstName}</label>
                    <div class="col-sm-8">
                        ${parameters.firstName!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.FormFieldTitle_lastName}</label>
                    <div class="col-sm-8">
                        ${parameters.lastName!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.PartyEmailAddress}</label>
                    <div class="col-sm-8">
                        ${parameters.emailAddress!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.OrderAddress}</label>
                    <div class="col-sm-8">
                        ${parameters.shipToAddress1!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.PFTCity}</label>
                    <div class="col-sm-8">
                        ${parameters.shipToCity!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.PartyZipCode}</label>
                    <div class="col-sm-8">
                        ${parameters.shipToPostalCode!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.CommonCountry}</label>
                    <div class="col-sm-8">
                        <#assign countryGeo = (delegator.findOne("Geo", {"geoId", parameters.shipToCountryGeoId!}, false))! />
                        ${countryGeo.geoName!parameters.shipToCountryGeoId!}
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-4 control-label">${uiLabelMap.PartyState}</label>
                    <div class="col-sm-8">
                        <#assign stateGeo = (delegator.findOne("Geo", {"geoId", parameters.shipToStateProvinceGeoId!}, false))! />
                        ${stateGeo.geoName!parameters.shipToStateProvinceGeoId!}
                    </div>
                </div>
                <div class="form-group">
                    <button type="button" id="anonEdit" class="btn btn-secondary btn-left btn-style-1 animation flat text-uppercase"
                        onclick="javascript:anonProcessCustomerEdit();">
                        ${uiLabelMap.CommonEdit}
                    </button>
                    <button type="button" id="anonContinue" class="btn btn-secondary btn-right btn-style-1 animation flat text-uppercase"
                        onclick="javascript:anonProcessCustomerContinue();">
                        ${uiLabelMap.PFTContinue}
                    </button>
                </div>
            </div>
            </#if>
        </div>
    </div>
    <div class="col-sm-5">
        <div id="anonOrderDetails" class="panel-smart">
            ${screens.render("component://productfromthailand/widget/OrderScreens.xml#anonOrderDetails")}
        </div>
    </div>
</div>