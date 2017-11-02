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

<div id="main-container" class="container">
  <div class="row">
      <div class="panel-smart">
        <#if canNotView>
          <div class="panel-heading">
            <h3>${uiLabelMap.AccountingEFTNotBelongToYou}.</h3>
          </div>
        <div class="panel-body">
          <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
        <#else>
          <#if !eftAccount??>
            <div class="panel-heading">
              <h1>${uiLabelMap.AccountingAddNewEftAccount}</h1>
            </div>
            <div class="panel-body">
              <form method="post" action="<@ofbizUrl>createEftAccount?DONE_PAGE=${donePage}</@ofbizUrl>" class="form-horizontal" name="editeftaccountform" style="margin: 0;">
          <#else>
            <div class="panel-heading">
              <h1>${uiLabelMap.PageTitleEditEFTAccount}</h1>
            </div>
            <div class="panel-body">
              <form method="post" action="<@ofbizUrl>updateEftAccount?DONE_PAGE=${donePage}</@ofbizUrl>" class="form-horizontal" name="editeftaccountform" style="margin: 0;">
              <input type="hidden" name="paymentMethodId" value="${paymentMethodId}"/>
          </#if>
          <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>&nbsp;
          <a href="javascript:document.editeftaccountform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingNameOnAccount}</label>
            <div class="col-sm-6">
              <input type="text" class="form-control" size="30" maxlength="60" name="nameOnAccount" value="${eftAccountData.nameOnAccount!}"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingCompanyNameOnAccount}</label>
            <div class="col-sm-6">
              <input type="text" class="form-control" size="30" maxlength="60" name="companyNameOnAccount" value="${eftAccountData.companyNameOnAccount!}"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingBankName}</label>
            <div class="col-sm-6">
              <input type="text" class="form-control" size="30" maxlength="60" name="bankName" value="${eftAccountData.bankName!}"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingRoutingNumber}</label>
            <div class="col-sm-6">
              <input type="text" class="form-control" size="10" maxlength="30" name="routingNumber" value="${eftAccountData.routingNumber!}"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingAccountType} *</label>
            <div class="col-sm-6">
              <select name="accountType" class="form-control">
                <option>${eftAccountData.accountType!}</option>
                <option></option>
                <option>${uiLabelMap.CommonChecking}</option>
                <option>${uiLabelMap.CommonSavings}</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingAccountNumber}</label>
            <div class="col-sm-6">
              <input type="text" class="form-control" size="20" maxlength="40" name="accountNumber" value="${eftAccountData.accountNumber!}"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonDescription}</label>
            <div class="col-sm-6">
              <input type="text" class="form-control" size="30" maxlength="60" name="description" value="${paymentMethodData.description!}"/>
            </div>
          </div>
          <div class="form-group">
            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyBillingAddress}</label>
            <div class="col-sm-6">
              <#if curPostalAddress??>
                <input type="radio" name="contactMechId" value="${curContactMechId}" checked="checked"/>
                <div><b>${uiLabelMap.PartyUseCurrentAddress}:</b></div>
                <#list curPartyContactMechPurposes as curPartyContactMechPurpose>
                  <#assign curContactMechPurposeType =
                      curPartyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
                  <div>
                    <b>${curContactMechPurposeType.get("description",locale)!}</b>
                    <#if curPartyContactMechPurpose.thruDate??>
                      (${uiLabelMap.CommonExpire}:${curPartyContactMechPurpose.thruDate.toString()})
                    </#if>
                  </div>
                </#list>
                <div>
                  <#if curPostalAddress.toName??>
                    <b>${uiLabelMap.CommonTo}:</b> ${curPostalAddress.toName}<br/>
                  </#if>
                  <#if curPostalAddress.attnName??>
                    <b>${uiLabelMap.PartyAddrAttnName}:</b> ${curPostalAddress.attnName}<br/>
                  </#if>
                  ${curPostalAddress.address1!}<br/>
                  <#if curPostalAddress.address2??>${curPostalAddress.address2}<br/></#if>
                  ${curPostalAddress.city}
                  <#if curPostalAddress.stateProvinceGeoId?has_content>,&nbsp;
                    ${curPostalAddress.stateProvinceGeoId}
                  </#if>&nbsp;
                  ${curPostalAddress.postalCode}
                  <#if curPostalAddress.countryGeoId??><br/>${curPostalAddress.countryGeoId}</#if>
                </div>
                <div>(${uiLabelMap.CommonUpdated}:&nbsp;${(curPartyContactMech.fromDate.toString())!})</div>
                <#if curPartyContactMech.thruDate??>
                  <div><b>${uiLabelMap.CommonDelete}:&nbsp;${curPartyContactMech.thruDate.toString()}</b></div>
                </#if>
              <#else>
                <#--
                  <tr>
                    <td valign="top" colspan="2">
                      <div>${uiLabelMap.PartyNoBillingAddress}</div>
                    </td>
                  </tr>
                -->
              </#if>
              <#-- is confusing
              <tr>
                <td valign="top" colspan="2">
                  <div><b>${uiLabelMap.EcommerceMessage3}</b></div>
                </td>
              </tr>
              -->
              <#list postalAddressInfos as postalAddressInfo>
                <#assign contactMech = postalAddressInfo.contactMech>
                <#assign partyContactMechPurposes = postalAddressInfo.partyContactMechPurposes>
                <#assign postalAddress = postalAddressInfo.postalAddress>
                <#assign partyContactMech = postalAddressInfo.partyContactMech>
                  <input type="radio" name="contactMechId" value="${contactMech.contactMechId}"/>
                    <#list partyContactMechPurposes as partyContactMechPurpose>
                      <#assign contactMechPurposeType =
                          partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
                      <div>
                        <b>${contactMechPurposeType.get("description",locale)!}</b>
                        <#if partyContactMechPurpose.thruDate??>
                          (${uiLabelMap.CommonExpire}:${partyContactMechPurpose.thruDate})
                        </#if>
                      </div>
                    </#list>
                    <div>
                      <#if postalAddress.toName??><b>${uiLabelMap.CommonTo}:</b> ${postalAddress.toName}<br/></#if>
                      <#if postalAddress.attnName??>
                        <b>${uiLabelMap.PartyAddrAttnName}:</b> ${postalAddress.attnName}<br/>
                      </#if>
                      ${postalAddress.address1!}<br/>
                      <#if postalAddress.address2??>${postalAddress.address2}<br/></#if>
                      ${postalAddress.city}
                      <#if postalAddress.stateProvinceGeoId?has_content>,&nbsp;
                        ${postalAddress.stateProvinceGeoId}
                      </#if>&nbsp;
                      ${postalAddress.postalCode}
                      <#if postalAddress.countryGeoId??><br/>${postalAddress.countryGeoId}</#if>
                    </div>
                    <div>(${uiLabelMap.CommonUpdated}:&nbsp;${(partyContactMech.fromDate.toString())!})</div>
                    <#if partyContactMech.thruDate??>
                      <div><b>${uiLabelMap.CommonDelete}:&nbsp;${partyContactMech.thruDate.toString()}</b></div>
                    </#if>
                  </#list>
                <#if !postalAddressInfos?has_content && !curContactMech??>
                  <tr>
                    <td colspan="2">
                      <div>${uiLabelMap.PartyNoContactInformation}.</div>
                    </td>
                  </tr>
                </#if>
              </div>
            </div>
          </form>
          &nbsp;<a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
          &nbsp;<a href="javascript:document.editeftaccountform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
        </#if>
        </div>
      </div>
    </div>
  </div>
</div>

