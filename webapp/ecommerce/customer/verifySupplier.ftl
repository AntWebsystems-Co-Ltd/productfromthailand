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
  <div class="panal panel-smart">
    <div class="panel-heading">
      <h2>${uiLabelMap.PFTVerifySupplier}</h2>
    </div>
    <div class="panel-body">

    <form id="newuserform" name="newuserform" method="post" action="updatesupplier" enctype="multipart/form-data" class="form-horizontal">
        <input type="hidden" name="partyId" value="${parameters.partyId!}"/>
        <input type="hidden" name="partyContentTypeId" value="INTERNAL"/>
        <input type="hidden" name="supplierType" value="<#if partyType == "PARTY_GROUP">SUPP_COMPANY<#else>SUPP_INDIVIDUAL</#if>"/>
        <#assign productStoreId = Static["org.apache.ofbiz.product.store.ProductStoreWorker"].getProductStoreId(request) />
        <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}"/>
        <#if partyType == "PARTY_GROUP">
        <div class="form-group company">
            <label class="col-sm-3 control-label ">${uiLabelMap.PFTSupplierName} *</label>
            <div class="col-sm-6" >
                <input type="text" class="form-control required" name="groupName" id="groupName" class="required" value="${groupName?if_exists}" maxlength="30"/>
            </div>
        </div>
        <div class="form-group company">
            <label class="col-sm-3 control-label">${uiLabelMap.PFTTitleIdBizRegisterNo} *</label>
            <div class="col-sm-6" >
                <input type="text" class="form-control required" name="businessRegistNo" id="newsupplier_businessRegistNo" class="required" value="${businessRegistNo?if_exists}" maxlength="30"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label company">${uiLabelMap.PFTTitleUploadBizRegisterNo} *</label>
            <div class="col-sm-6" >
                <input type="file" class="form-control required" size="50" name="imageFileName"/>
            </div>
        </div>
        <#else>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonTitle}</label>
          <div class="col-sm-6">
              <select name="personalTitle" name="USER_TITLE" id="USER_TITLE" class="form-control">
              <option value="">${uiLabelMap.CommonSelectOne}</option>
              <option value="Mr."<#if parameters.personalTitle! == "Mr."> selected="selected"</#if>>${uiLabelMap.CommonTitleMr}</option>
              <option value="Mrs."<#if parameters.personalTitle! == "Mrs."> selected="selected"</#if>>${uiLabelMap.CommonTitleMrs}</option>
              <option value="Ms."<#if parameters.personalTitle! == "Ms."> selected="selected"</#if>>${uiLabelMap.CommonTitleMs}</option>
              <option value="Dr."<#if parameters.personalTitle! == "Dr."> selected="selected"</#if>>${uiLabelMap.CommonTitleDr}</option>
            </select>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label required">${uiLabelMap.PartyFirstName} *</label>
          <div class="col-sm-6">
              <input type="text" class="form-control required" name="firstName" id="firstName" value="${firstName?if_exists}"/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyLastName} *</label>
          <div class="col-sm-6">
              <input type="text" class="form-control required" name="lastName" id="lastName" value="${lastName?if_exists}"/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTTitleIdNoIdPassport} *</label>
          <div class="col-sm-6">
              <input type="text" class="form-control required" name="idCardNo" id="newsupplier_idCardNo" value="${idCardNo?if_exists}" maxlength="30"/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTTitleUploadIdScan} *</label>
          <div class="col-sm-6">
              <input type="file" class="form-control required" name="imageFileName" id="imageFileName"/>
          </div>
        </div>
        </#if>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonEmail}</label>
          <div class="col-sm-6">
              <input type="text" class="form-control" name="idCardNo" id="emailAddress" value="${emailAddress?if_exists}" disabled/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyAddressLine1} *</label>
          <div class="col-sm-6">
              <input type="text" class="form-control required" name="shipToAddress1" id="shipToAddress1" value="${shipToAddress1?if_exists}"/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyAddressLine2}</label>
          <div class="col-sm-6">
              <input type="text" class="form-control" name="shipToAddress2" id="shipToAddress2" value="${shipToAddress2?if_exists}"/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonCity} *</label>
          <div class="col-sm-6">
              <input type="text" class="form-control required" name="shipToCity" id="shipToCity" value="${shipToCity?if_exists}"/>
          </div>
        </div>
        <div class="form-group individual">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyZipCode} *</label>
          <div class="col-sm-6">
              <input type="text" class="form-control required" name="shipToPostalCode" id="shipToPostalCode" value="${shipToPostalCode?if_exists}" maxlength="10"/>
          </div>
        </div>
        <div class="form-group">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonCountry}</label>
          <div class="col-sm-6">
            <select name="shipToCountryGeoId" id="newuserform_countryGeoId" class="form-control">
                ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                <#if shipToCountryGeoId??>
                    <#assign defaultCountryGeoId = shipToCountryGeoId>
                <#else>
                    <#assign defaultCountryGeoId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "country.geo.id.default", delegator)>
                </#if>
                <option selected="selected" value="${defaultCountryGeoId}">
                <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
                ${countryGeo.get("geoName",locale)!}
                </option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyState}</label>
          <div class="col-sm-6">
            <select class="form-control" name="shipToStateProvinceGeoId" id="newuserform_stateProvinceGeoId"></select>
          </div>
        </div>
        <table class="table" cellspacing="0" width="100%" summary="Tabular form for entering multiple telecom numbers for different purposes. Each row allows user to enter telecom number for a purpose">
          <thead>
            <tr>
              <th></th>
              <th scope="col">${uiLabelMap.CommonCountryCode}</th>
              <th scope="col">${uiLabelMap.PartyAreaCode}</th>
              <th scope="col">${uiLabelMap.PartyContactNumber}</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">${uiLabelMap.PartyHomePhone}</th>
              <td><input type="text" class="form-control" name="SUPPLIER_HOME_COUNTRY" size="5" value="${homeCountryCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_HOME_AREA" size="5" value="${homeAreaCode?if_exists}" /></td>
              <td><input type="text" class="form-control" ame="SUPPLIER_HOME_CONTACT" value="${homeContactNumber?if_exists}" /></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyBusinessPhone}</th>
              <td><input type="text" class="form-control" name="SUPPLIER_WORK_COUNTRY" size="5" value="${workCountryCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_WORK_AREA" size="5" value="${workAreaCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_WORK_CONTACT" value="${workContactNumber?if_exists}" /></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyFaxNumber}</th>
              <td><input type="text" class="form-control" name="SUPPLIER_FAX_COUNTRY" size="5" value="${faxCountryCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_FAX_AREA" size="5" value="${faxAreaCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_FAX_CONTACT" value="${faxContactNumber?if_exists}" /></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyMobilePhone}</th>
              <td><input type="text" class="form-control" name="SUPPLIER_MOBILE_COUNTRY" size="5" value="${mobileCountryCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_MOBILE_AREA" size="5" value="${mobileAreaCode?if_exists}" /></td>
              <td><input type="text" class="form-control" name="SUPPLIER_MOBILE_CONTACT" value="${mobileContactNumber?if_exists}" /></td>
            </tr>
          </tbody>
        </table>
        <a id="submitnewuserform" href="javascript:$('#newuserform').submit()" class="btn btn-main" style="color:black;">${uiLabelMap.CommonSubmit}</a>
    </form>
    </div>
  </div>
</div>
<script type="text/javascript">
  //<![CDATA[
    jQuery(document).ready( function() {
        jQuery("#newuserform").validate();
    });
  //]]>
</script>
