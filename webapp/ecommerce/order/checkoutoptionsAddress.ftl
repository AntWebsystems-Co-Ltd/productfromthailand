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
    <#if shoppingCart.getShippingContactMechId()??>
        $("#step1NextButton").removeClass("hide");
    </#if>
    $("input:radio[name='shipping_contact_mech_id']").change(function() {
        if ($("input:radio[name='shipping_contact_mech_id']").is(":checked")) {
            $("#step1NextButton").removeClass("hide");
        }
    })
});
</script>
<#-- Choose Address Starts -->
<div id="chooseAddress">
<#if shippingContactMechList?has_content>
    <table style="width:100%;">
    <#list shippingContactMechList as shippingContactMech>
        <#assign shippingAddress = shippingContactMech.getRelatedOne("PostalAddress", false)>
        <tr>
            <td valign="top">
                <label>
                    <input type="radio" name="shipping_contact_mech_id" value="${shippingAddress.contactMechId}"<#if shoppingCart.getShippingContactMechId()?default("") == shippingAddress.contactMechId> checked="checked"</#if>/>
                    <span>
                    <#if shippingAddress.toName?has_content><b>${uiLabelMap.CommonTo}:</b>&nbsp;${shippingAddress.toName}<br/></#if>
                    <#if shippingAddress.attnName?has_content><b>${uiLabelMap.PartyAddrAttnName}:</b>&nbsp;${shippingAddress.attnName}<br/></#if>
                    <#if shippingAddress.address1?has_content>${shippingAddress.address1}<br /></#if>
                    <#if shippingAddress.address2?has_content>${shippingAddress.address2}<br /></#if>
                    <#if shippingAddress.city?has_content>${shippingAddress.city}</#if>
                    <#assign stateGeo = (delegator.findOne("Geo", {"geoId", shippingAddress.stateProvinceGeoId!}, false))! />
                    <#if shippingAddress.stateProvinceGeoId?has_content><br/>${stateGeo.geoName!shippingAddress.stateProvinceGeoId}</#if>
                    <#if shippingAddress.postalCode?has_content><br/>${shippingAddress.postalCode}</#if>
                    <#assign countryGeo = (delegator.findOne("Geo", {"geoId", shippingAddress.countryGeoId!}, false))! />
                    <#if shippingAddress.countryGeoId?has_content><br/>${countryGeo.geoName!shippingAddress.countryGeoId}</#if>
                    </span>
                </label>
            </td>
        </tr>
        <#if shippingContactMech_has_next>
        <tr><td colspan="2"><hr/></td></tr>
       </#if>
    </#list>
    </table>
</#if>
<#-- New Address Button Starts -->
    <div>
        <hr/>
        <a onclick="javascript:toggleNewAddress();" style="cursor: pointer;"><i class="fa fa-plus" aria-hidden="true"></i> ${uiLabelMap.PartyAddNewAddress}</a>
    </button>
    </div>
<#-- New Address Button Ends -->
</div>
<#-- Chosen Address Starts -->
<div id="chosenAddress" class="hide">
    <label>
        <span>
            <#if shoppingCart.getShippingContactMechId()??>
            <#assign thisAddress = (delegator.findOne("PostalAddress", {"contactMechId", shoppingCart.getShippingContactMechId()!}, false))! />
                <b>${uiLabelMap.CommonTo}:</b> <#if thisAddress.toName??>${thisAddress.toName!}<#else>${firstName!} <#if lastName??>${lastName!}</#if></#if><br/>
                <#if thisAddress.address1??>${thisAddress.address1!}<br/></#if>
                <#if thisAddress.address2??>${thisAddress.address2!}<br/></#if>
                <#if thisAddress.city??>${thisAddress.city!}<br/></#if>
                <#if thisAddress.stateProvinceGeoId??>
                    <#assign thisStateGeo = (delegator.findOne("Geo", {"geoId", thisAddress.stateProvinceGeoId!}, false))! />
                    ${thisStateGeo.geoName!shipToStateProvinceGeoId}<br/>
                </#if>
                <#if thisAddress.postalCode??>${thisAddress.postalCode!}<br/></#if>
                <#if thisAddress.countryGeoId??>
                    <#assign thisCountryGeo = (delegator.findOne("Geo", {"geoId", thisAddress.countryGeoId!}, false))! />
                    ${thisCountryGeo.geoName!shipToCountryGeoId}<br/>
                </#if>
            </#if>
        </span>
    </label><br/>
</div>
<#-- Chosen Address Ends -->