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
<#escape x as x?xml>
<fo:table table-layout="fixed" width="100%" space-after="0.3in">
   <fo:table-column column-width="5in"/>
    <fo:table-body>
      <fo:table-row >
        <fo:table-cell>
          <fo:block linefeed-treatment="preserve">_______________________________</fo:block>
      </fo:table-cell>
    </fo:table-row>
      <fo:table-row >
        <fo:table-cell>
          <fo:block>${uiLabelMap.CommonTo}: </fo:block>
                <#assign partyContactMechShipping = EntityQuery.use(delegator).from("PartyContactMechPurpose").where("partyId", billToParty.partyId, "contactMechPurposeTypeId", "SHIPPING_LOCATION").queryFirst()!>
                <#if partyContactMechShipping?has_content>
                    <#assign contactMechId = partyContactMechShipping.contactMechId/>
                <#else>
                    <#assign partyContactMechGeneral = EntityQuery.use(delegator).from("PartyContactMechPurpose").where("partyId", billToParty.partyId, "contactMechPurposeTypeId", "GENERAL_LOCATION").queryFirst()!>
                    <#if partyContactMechGeneral?has_content>
                        <#assign contactMechId = partyContactMechGeneral.contactMechId/>
                    <#else>
                        <#assign partyContactMechBilling = EntityQuery.use(delegator).from("PartyContactMechPurpose").where("partyId", billToParty.partyId, "contactMechPurposeTypeId", "BILLING_LOCATION").queryFirst()!>
                        <#assign contactMechId = partyContactMechBilling.contactMechId/>
                    </#if>
                </#if>
                <#if contactMechId?has_content>
                    <#assign contactMech = delegator.findOne("ContactMech", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("contactMechId", contactMechId), false)! />
                    <#if contactMech?has_content>
                        <#assign address = contactMech.getRelatedOne("PostalAddress", false)! />
                    </#if>
                    <#assign partyNameView = EntityQuery.use(delegator).from("PartyNameView").where("partyId", billToParty.partyId).queryOne()!>
                    <fo:block>
                        <#if partyNameView?has_content>
                            ${partyNameView.groupName!} ${partyNameView.firstName!} ${partyNameView.lastName!}
                            <#else>
                            Billing Name Not Found
                        </#if>
                    </fo:block>
                    <#if address.attnName??>
                        <fo:block>${address.attnName!}</fo:block>
                    </#if>
                        <fo:block>${address.address1!}</fo:block>
                    <#if address.address2??>
                        <fo:block>${address.address2}</fo:block>
                    </#if>
                    <fo:block>
                        <#assign stateGeo = (delegator.findOne("Geo", {"geoId", address.stateProvinceGeoId!}, false))! />
                            ${address.city!} <#if stateGeo?has_content>${stateGeo.geoName!}</#if> ${address.postalCode!}
                    </fo:block>
                    <#if billToPartyTaxId?has_content>
                        <fo:block>${uiLabelMap.PartyTaxId}: ${billToPartyTaxId!}</fo:block>
                    </#if>
                 <#else>
                     <fo:block>${uiLabelMap.AccountingNoGenBilAddressFound}${billToParty.partyId}</fo:block>
                 </#if>
       </fo:table-cell>
    </fo:table-row>
  </fo:table-body>
</fo:table>
</#escape>
