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
        var customerStateElement = document.getElementById('newuserform_stateProvinceGeoId');
        var customerCountryElement = document.getElementById('newuserform_countryGeoId');
        if (customerCountryElement.value == "USA" || customerCountryElement.value == "UMI" || customerCountryElement.value == "THA") {
          customerStateElement.style.display = "block";
        } else {
          customerStateElement.style.display = "none";
        }
      }
   //]]>
</script>
</#if>

<h2>${uiLabelMap.PFTVerifySupplier}</h2>
<div class="manualUpdateRegister">
    <form id="newuserform" name="newuserform" method="post" action="updatesupplier" enctype="multipart/form-data">
      <fieldset class="col">
        <legend>${uiLabelMap.PartyPersonalInformation}</legend>
        <input type="hidden" name="partyId" value="${parameters.partyId!}"/>
        <input type="hidden" name="partyContentTypeId" value="INTERNAL"/>
        <input type="hidden" name="supplierType" value="SUPP_INDIVIDUAL"/>
        <#assign productStoreId = Static["org.apache.ofbiz.product.store.ProductStoreWorker"].getProductStoreId(request) />
        <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}" />
        <table class="basic-table" cellspacing="0" width="90%">
            <tr id="titleNameSupplier">
                <td valign="middle" class="newsupplier" id="titleNameTitle" width="30%">${uiLabelMap.CommonTitle}</td>
                <td width="1%"> : </td>
                <td id="supplier_titleName" width="60%">
                  <select name="USER_TITLE" id="USER_TITLE">
                    <#if personalTitle?has_content >
                      <option>${personalTitle!}</option>
                      <option value="${personalTitle!}"> -- </option>
                    <#else>
                      <option value="">${uiLabelMap.CommonSelectOne}</option>
                    </#if>
                    <option>${uiLabelMap.CommonTitleMr}</option>
                    <option>${uiLabelMap.CommonTitleMrs}</option>
                    <option>${uiLabelMap.CommonTitleMs}</option>
                    <option>${uiLabelMap.CommonTitleDr}</option>
                  </select>
                </td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier" id="firstNameTitle">${uiLabelMap.PartyFirstName}</td>
                <td> : </td>
                <td id="supplier_firstName"><input type="text" name="firstName" id="firstName" value="${firstName!}"/> *</td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier" id="lastNameTitle">${uiLabelMap.PartyLastName}</td>
                <td> : </td>
                <td id="supplier_lastName"><input type="text" name="lastName" id="lastName" value="${lastName!}"/> *</td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier" id="idNoPassportNoTitle">${uiLabelMap.PFTTitleIdNoIdPassport}</td>
                <td> : </td>
                <td id="idNoPassportNo"><input type="text" name="idCardNo" id="newsupplier_idCardNo" class="required" value="${idCardNo!}" maxlength="30"/> *</td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier" id="uploadIdNoScanTitle">${uiLabelMap.PFTTitleUploadIdScan}</td>
                <td> : </td>
                <td width="20%" align="right" valign="top">
                    <input type="file" size="50" name="imageFileName" class="required"/> *
                </td>
            </tr>
        </table>
      </fieldset>
      <fieldset class="col">
          <legend>${uiLabelMap.PartyContactInformation}</legend>
          <table class="basic-table" cellspacing="0" width="90%">
              <tr>
                <td valign="middle" class="newsupplier" width="30%">${uiLabelMap.CommonEmail}<span id="advice-validate-email-emailAddress" class="errorMessage" style="display:none">${uiLabelMap.PartyEmailAddressNotFormattedCorrectly}</span></td>
                <td width="1%"> : </td>
                <td width="60%">${emailAddress!}</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyAddressLine1}<span id="advice-required-shipToAddress1" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="text" name="shipToAddress1" id="shipToAddress1" class="required" value="${shipToAddress1!}"/> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyAddressLine2}</td>
                <td> : </td>
                <td><input type="text" name="shipToAddress2" id="shipToAddress2" value="${shipToAddress2!}"/></td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.CommonCity}<span id="advice-required-shipToCity" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="text" name="shipToCity" id="shipToCity" class="required" value="${shipToCity!}"/> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyZipCode}<span id="advice-required-shipToPostalCode" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="text" name="shipToPostalCode" id="shipToPostalCode" class="required" value="${shipToPostalCode!}" maxlength="10"/> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.CommonCountry}</td>
                <td width="1%"> : </td>
                <td><select name="shipToCountryGeoId" id="newuserform_countryGeoId">
                  ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                  <#assign defaultCountryGeoId =
                      Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general",
                      "country.geo.id.default", delegator)>
                  <option selected="selected" value="${defaultCountryGeoId}">
                    <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"]
                        .toMap("geoId",defaultCountryGeoId), false)>
                    ${countryGeo.get("geoName",locale)}
                  </option>
                </select></td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyState}</td>
                <td width="1%"> : </td>
                <td><select name="shipToStateProvinceGeoId" id="newuserform_stateProvinceGeoId"></select></td>
              </tr>
          </table>
      </fieldset>
      <fieldset>
        <legend>${uiLabelMap.PartyPhoneNumbers}</legend>
        <table class="basic-table" cellspacing="0" width="80%" summary="Tabular form for entering multiple telecom numbers for different purposes. Each row allows user to enter telecom number for a purpose">
          <thead>
            <tr>
              <th></th>
              <th scope="col">${uiLabelMap.CommonCountryCode}</th>
              <th scope="col">${uiLabelMap.PartyAreaCode}</th>
              <th scope="col">${uiLabelMap.PartyContactNumber}</th>
              <th scope="col">${uiLabelMap.PartyExtension}</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">${uiLabelMap.PartyHomePhone}</th>
              <td><input type="text" name="SUPPLIER_HOME_COUNTRY" size="5" value="${homeCountryCode!}"/></td>
              <td><input type="text" name="SUPPLIER_HOME_AREA" size="5" value="${homeAreaCode!}"/></td>
              <td><input type="text" name="SUPPLIER_HOME_CONTACT" value="${homeContactNumber!}"/></td>
              <td><input type="text" name="SUPPLIER_HOME_EXT" size="6" value="${homeExtension!}"/></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyBusinessPhone}</th>
              <td><input type="text" name="SUPPLIER_WORK_COUNTRY" size="5" value="${workCountryCode!}"/></td>
              <td><input type="text" name="SUPPLIER_WORK_AREA" size="5" value="${workAreaCode!}"/></td>
              <td><input type="text" name="SUPPLIER_WORK_CONTACT" value="${workContactNumber!}"/></td>
              <td><input type="text" name="SUPPLIER_WORK_EXT" size="6" value="${workExtension!}"/></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyFaxNumber}</th>
              <td><input type="text" name="SUPPLIER_FAX_COUNTRY" size="5" value="${faxCountryCode!}"/></td>
              <td><input type="text" name="SUPPLIER_FAX_AREA" size="5" value="${faxAreaCode!}"/></td>
              <td><input type="text" name="SUPPLIER_FAX_CONTACT" value="${faxContactNumber!}"/></td>
              <td></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyMobilePhone}</th>
              <td><input type="text" name="SUPPLIER_MOBILE_COUNTRY" size="5" value="${mobileCountryCode!}"/></td>
              <td><input type="text" name="SUPPLIER_MOBILE_AREA" size="5" value="${mobileAreaCode!}"/></td>
              <td><input type="text" name="SUPPLIER_MOBILE_CONTACT" value="${mobileContactNumber!}"/></td>
              <td></td>
            </tr>
          </tbody>
        </table>
      </fieldset>
        <div style="margin-left:300px;"><a id="submitnewuserform" href="javascript:$('#newuserform').submit()" class="button" style="color:black;">${uiLabelMap.CommonSubmit}</a></div>
    </form>
    <script type="text/javascript">
      //<![CDATA[
          hideShowUsaStates();
      //]]>
    </script>
</div>
<script type="text/javascript">
    jQuery(document).ready( function() {
        jQuery("#newuserform").validate();
    });
</script>
