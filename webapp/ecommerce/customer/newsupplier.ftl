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
<#if getUsername>
<script type="text/javascript">
  //<![CDATA[
     
     function hideShowUsaStates() {
         if ($('customerCountry').value == "USA" || $('customerCountry').value == "UMI") {
             $('customerState').style.display = "block";
         } else {
             $('customerState').style.display = "none";
         }
     }
   //]]>
</script>
</#if>

  <h2>${uiLabelMap.PageTitleNewSupplier}</h2>

    <form id="newuserform" method="post" action="<@ofbizUrl>createsupplier</@ofbizUrl>">
      <fieldset class="col">
                <legend>${uiLabelMap.CompanyName}</legend>
        <input type="hidden" name="roleTypeId" value="SUPPLIER" />
        <input type="hidden" name="emailContactMechPurposeTypeId" value="PRIMARY_EMAIL" />
        <#assign productStoreId = Static["org.ofbiz.product.store.ProductStoreWorker"].getProductStoreId(request) />
        <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}" />
          <div>
            <label for="groupName">${uiLabelMap.CompanyName}*</label>
            <input type="text" name="groupName" id="groupName" value="${parameters.firstName?if_exists}" maxlength="30" />
          </div>
      </fieldset>
      <fieldset  class="col"> 
          <legend>${uiLabelMap.EcommerceAccountInformation}</legend>
            <div>
              <label for="username">${uiLabelMap.CommonUsername}* <span id="advice-required-username" style="display: none" class="errorMessage">(required)</span></label>
              <input type="text" name="username" id="username" class="required" value="${parameters.username?if_exists}" maxlength="255" />
            </div>
            <div>
              <label for="password">${uiLabelMap.CommonPassword}* <span id="advice-required-password" style="display: none" class="errorMessage">(required)</span></label>
              <input type="password" name="password" id="password" class="required validate-password" value="${parameters.password?if_exists}" maxlength="16" />
              <span id="advice-validate-password-password" class="errorMessage" style="display:none">${uiLabelMap["loginservices.password_may_not_equal_username"]}</span>
            </div>
            <div>
              <label for="passwordVerify">${uiLabelMap.PartyRepeatPassword}* <span id="advice-required-passwordVerify" style="display: none" class="errorMessage">(required)</span></label>
              <input type="password" name="passwordVerify" id="passwordVerify" class="required validate-passwordVerify" value="${parameters.passwordVerify?if_exists}" maxlength="16" />
              <span id="advice-validate-passwordVerify-passwordVerify" class="errorMessage" style="display:none">${uiLabelMap["loginservices.password_did_not_match_verify_password"]}</span>
            </div>
            <br/>
      </fieldset>
       <fieldset class="col">
                <legend>${uiLabelMap.PartyContactInformation}</legend>
          <div>
            <label for="emailAddress">${uiLabelMap.CommonEmail}*</label>
            <input type="text" class="required validate-email" name="emailAddress" id="emailAddress" value="${parameters.emailAddress?if_exists}" maxlength="255" />
            <span id="advice-validate-email-emailAddress" class="errorMessage" style="display:none">${uiLabelMap.PartyEmailAddressNotFormattedCorrectly}</span>
          </div>
          <div>
            <label for="shipToAddress1">${uiLabelMap.PartyAddressLine1}* <span id="advice-required-shipToAddress1" style="display: none" class="errorMessage">(required)</span></label>
            <input type="text" name="shipToAddress1" id="shipToAddress1" class="required" value="${parameters.shipToAddress1?if_exists}" />
          </div>
          <div>
            <label for="shipToAddress2">${uiLabelMap.PartyAddressLine2}</label>
            <input type="text" name="shipToAddress2" id="shipToAddress2" value="${parameters.shipToAddress2?if_exists}" />
          </div>
          <div>
            <label for="shipToCity">${uiLabelMap.CommonCity}* <span id="advice-required-shipToCity" style="display: none" class="errorMessage">(required)</span></label>
            <input type="text" name="shipToCity" id="shipToCity" class="required" value="${parameters.shipToCity?if_exists}" />
          </div>
          <div>
            <label for="shipToPostalCode">${uiLabelMap.PartyZipCode}* <span id="advice-required-shipToPostalCode" style="display: none" class="errorMessage">(required)</span></label>
            <input type="text" name="shipToPostalCode" id="shipToPostalCode" class="required" value="${parameters.shipToPostalCode?if_exists}" maxlength="10" />
          </div>
          <div>
            <label for="shipToCountryGeoId">${uiLabelMap.PartyCountry}* <span id="advice-required-shipToCountryGeoId" style="display: none" class="errorMessage">(required)</span></label>
              <select name="shipToCountryGeoId" onclick="hideShowUsaStates();" id="customerCountry">
                <#if requestParameters.shipToCountryGeoId?exists>
                  <option value='${requestParameters.shipToCountryGeoId}'>${selectedCountryName?default(requestParameters.shipToCountryGeoId)}</option>
                </#if>
                ${screens.render("component://common/widget/CommonScreens.xml#countries")}
              </select>
          </div>
          <div id='shipToStates'>
            <label for="shipToStateProvinceGeoId">${uiLabelMap.CommonState}*<span id="advice-required-shipToStateProvinceGeoId" style="display: none" class="errorMessage">(required)</span></label>
              <select name="shipToStateProvinceGeoId" id="customerState">
                <#if requestParameters.shipToStateProvinceGeoId?exists>
                  <option value='${requestParameters.shipToStateProvinceGeoId}'>${selectedStateName?default(requestParameters.shipToStateProvinceGeoId)}</option>
                </#if>
                <option value="">${uiLabelMap.PartyNoState}</option>
                ${screens.render("component://common/widget/CommonScreens.xml#states")}
              </select>
          </div>
          <div>
            <label>${uiLabelMap.PartyPhoneNumber}*</label>
            <span id="advice-required-shipToCountryCode" style="display:none" class="errorMessage"></span>
            <span id="advice-required-shipToAreaCode" style="display:none" class="errorMessage"></span>
            <span id="advice-required-shipToContactNumber" style="display:none" class="errorMessage"></span>
            <span id="shipToPhoneRequired" style="display: none;" class="errorMessage">(required)</span>
            <input type="text" name="shipToCountryCode" id="shipToCountryCode" title="Country Code" class="required" value="${parameters.shipToCountryCode?if_exists}" size="3" maxlength="3" />
            - <input type="text" name="shipToAreaCode" id="shipToAreaCode" title="Area Code" class="required" value="${parameters.shipToAreaCode?if_exists}" size="3" maxlength="3" />
            - <input type="text" name="shipToContactNumber" id="shipToContactNumber" title="Contact Number" class="required" value="${contactNumber?default("${parameters.shipToContactNumber?if_exists}")}" size="6" maxlength="7" />
            - <input type="text" name="shipToExtension" id="shipToExtension" title="Extension" value="${extension?default("${parameters.shipToExtension?if_exists}")}" size="3" maxlength="3" />
          </div>
          </fieldset>
      <div style="margin-left:300px;"><a id="submitnewuserform" href="javascript:$('newuserform').submit()" class="button" style="color:black;">${uiLabelMap.CommonSubmit}</a></div>
      
    </form>
<script type="text/javascript">
  //<![CDATA[
      hideShowUsaStates();
  //]]>
</script>