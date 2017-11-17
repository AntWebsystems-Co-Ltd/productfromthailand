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
<fo:block space-after="20pt"/>
<fo:block font-size="12pt">
    <#assign supplierName = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", invoice.partyIdFrom, "userLogin", userLogin))/>
    <fo:block>${supplierName.fullName!}</fo:block>
    <#assign supplierAddress = dispatcher.runSync("getPartyPostalAddress", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", invoice.partyIdFrom, "contactMechPurposeTypeId", "SHIPPING_LOCATION", "userLogin", userLogin))/>
    <#assign supplierStateGeo = EntityQuery.use(delegator).from("Geo").where("geoId", supplierAddress.stateProvinceGeoId!).queryOne()! />
    <fo:block>${supplierAddress.address1!}</fo:block>
    <#if supplierAddress.address2?has_content><fo:block>${supplierAddress.address2}</fo:block></#if>
    <fo:block>${supplierAddress.city!}<#if supplierAddress.stateProvinceGeoId?has_content>, ${supplierStateGeo.geoName!}</#if> ${supplierAddress.postalCode!}</fo:block>
</fo:block>
</#escape>
