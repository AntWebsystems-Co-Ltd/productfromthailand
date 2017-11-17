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
   <fo:table-column column-width="3.5in"/>
    <fo:table-body>
      <fo:table-row >
        <fo:table-cell>
          <fo:block>_______________________________</fo:block>
      </fo:table-cell>
    </fo:table-row>
      <fo:table-row >
        <fo:table-cell>
          <fo:block>${uiLabelMap.CommonTo}: </fo:block>
            <#if billingAddress?has_content>
                <#assign billToPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", billToParty.partyId, "compareDate", invoice.invoiceDate, "userLogin", userLogin))/>
                <#assign billToPartyAddress = dispatcher.runSync("getPartyPostalAddress", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", billToParty.partyId, "contactMechPurposeTypeId", "PAYMENT_LOCATION", "userLogin", userLogin))/>
                <#assign billToPartyStateGeo = EntityQuery.use(delegator).from("Geo").where("geoId", billToPartyAddress.stateProvinceGeoId!).queryOne()! />
                <fo:block>${billToPartyNameResult.fullName?default(billingAddress.toName)?default("Billing Name Not Found")}</fo:block>
                <#if billToPartyAddress.attnName??>
                    <fo:block>${billToPartyAddress.attnName}</fo:block>
                </#if>
                    <fo:block>${billToPartyAddress.address1!}</fo:block>
                <#if billToPartyAddress.address2??>
                    <fo:block>${billToPartyAddress.address2}</fo:block>
                </#if>
                <fo:block>${billToPartyAddress.city!} ${billToPartyStateGeo.geoName!} ${billToPartyAddress.postalCode!}</fo:block>
            <#else>
                <fo:block>${uiLabelMap.AccountingNoGenBilAddressFound}${billToParty.partyId}</fo:block>
            </#if>
       </fo:table-cell>
    </fo:table-row>
  </fo:table-body>
</fo:table>
</#escape>
