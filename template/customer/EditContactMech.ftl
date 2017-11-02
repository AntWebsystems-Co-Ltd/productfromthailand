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
    <div class="col-sm-12">
      <div class="panel panel-smart">
        <#if canNotView>
        <div class="panel-heading navbar">
          <h2>${uiLabelMap.PartyEditPersonalInformation}</h2>
        </div>
        <h3>${uiLabelMap.PartyContactInfoNotBelongToYou}.</h3>
        <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonBack}</a>
        <#else>
          <#if !contactMech??>
          <#-- When creating a new contact mech, first select the type, then actually create -->
            <#if !requestParameters.preContactMechTypeId?? && !preContactMechTypeId??>
            <div class="panel-heading navbar">
              <h2>${uiLabelMap.PartyCreateNewContactInfo}</h2>
            </div>
            <form method="post" action='<@ofbizUrl>editcontactmechnosave</@ofbizUrl>' class="form-horizontal" name="createcontactmechform">
              <div class="form-group">
                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartySelectContactType}:</label>
                <div class="col-sm-4">
                  <select name="preContactMechTypeId" class="form-control">
                    <#list contactMechTypes as contactMechType>
                      <option value='${contactMechType.contactMechTypeId}'>
                        ${contactMechType.get("description",locale)}
                      </option>
                    </#list>
                  </select>
                </div>
                <a href="javascript:document.createcontactmechform.submit()" class="btn btn-main">${uiLabelMap.CommonCreate}</a>
              </div>
            </form>
            <#-- <p><h3>ERROR: Contact information with ID "${contactMechId}" not found!</h3></p> -->
            </#if>
          </#if>

          <#if contactMechTypeId??>
            <#if !contactMech??>
              <div class="panel-heading navbar">
                <h2>${uiLabelMap.PartyCreateNewContactInfo}</h2>
              </div>
              <a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
              <a href="javascript:document.editcontactmechform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
              <table width="90%" border="0" cellpadding="2" cellspacing="0">
                <form method="post" action='<@ofbizUrl>${reqName}</@ofbizUrl>' name="editcontactmechform" id="editcontactmechform" class="form-horizontal">
                    <input type='hidden' name='contactMechTypeId' value='${contactMechTypeId}'/>
                    <input type='hidden' name='DONE_PAGE' value='${donePage}'/>
                    <#if contactMechPurposeType??>
                      <div>(${uiLabelMap.PartyNewContactHavePurpose} "${contactMechPurposeType.get("description",locale)!}")</div>
                    </#if>
                    <#if cmNewPurposeTypeId?has_content>
                      <input type='hidden' name='contactMechPurposeTypeId' value='${cmNewPurposeTypeId}'/>
                    </#if>
                    <#if preContactMechTypeId?has_content>
                      <input type='hidden' name='preContactMechTypeId' value='${preContactMechTypeId}'/>
                    </#if>
                    <#if paymentMethodId?has_content>
                      <input type='hidden' name='paymentMethodId' value='${paymentMethodId}'/>
                    </#if>
                <#else>
                  <div class="panel-heading navbar">
                    <h2>${uiLabelMap.PartyEditContactInfo}</h2>
                  </div>
                  <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
                  <a href="javascript:document.editcontactmechform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
                  <div class="form-group">
                    <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyContactPurposes}</label>
                    <div class="col-sm-9">
                      <#list partyContactMechPurposes! as partyContactMechPurpose>
                        <#assign contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true) />
                        <form name="deletePartyContactMechPurpose_${partyContactMechPurpose.contactMechPurposeTypeId}" class="form-horizontal" method="post" action="<@ofbizUrl>deletePartyContactMechPurpose</@ofbizUrl>">
                          <#if contactMechPurposeType??>
                          ${contactMechPurposeType.get("description",locale)}
                          <#else>
                          ${uiLabelMap.PartyPurposeTypeNotFound}: "${partyContactMechPurpose.contactMechPurposeTypeId}"
                          </#if>
                          (${uiLabelMap.CommonSince}:${partyContactMechPurpose.fromDate.toString()})
                          <#if partyContactMechPurpose.thruDate??>(${uiLabelMap.CommonExpires}
                            :${partyContactMechPurpose.thruDate.toString()})</#if>
                          <input type="hidden" name="contactMechId" value="${contactMechId}"/>
                          <input type="hidden" name="contactMechPurposeTypeId" value="${partyContactMechPurpose.contactMechPurposeTypeId}"/>
                          <input type="hidden" name="fromDate" value="${partyContactMechPurpose.fromDate}"/>
                          <input type="hidden" name="useValues" value="true"/>
                          <a href='javascript:document.deletePartyContactMechPurpose_${partyContactMechPurpose.contactMechPurposeTypeId}.submit()' class='btn btn-main'>&nbsp;${uiLabelMap.CommonDelete}&nbsp;</a>
                        </form>
                      </#list>
                    </div>
                  </div>
                  <#if purposeTypes?has_content>
                    <div class="form-group">
                      <label for="inputFname" class="col-sm-3 control-label"></label>
                      <div class="col-sm-9">
                        <form method="post" action="<@ofbizUrl>createPartyContactMechPurpose</@ofbizUrl>" name="newpurposeform">
                          <div class="col-sm-4">
                            <input type="hidden" name="contactMechId" value="${contactMechId}"/>
                            <input type="hidden" name="useValues" value="true"/>
                            <select name='contactMechPurposeTypeId' class="form-control">
                              <option></option>
                              <#list purposeTypes as contactMechPurposeType>
                                <option value='${contactMechPurposeType.contactMechPurposeTypeId}'>
                                  ${contactMechPurposeType.get("description",locale)}
                                </option>
                              </#list>
                            </select>
                          </div>
                          <a href='javascript:document.newpurposeform.submit()' class='btn btn-main'>${uiLabelMap.PartyAddPurpose}</a>
                        </form>
                      </div>
                    </div>
                    &nbsp;
                  </#if>
                <form method="post" action='<@ofbizUrl>${reqName}</@ofbizUrl>' class="form-horizontal" name="editcontactmechform" id="editcontactmechform">
                <div>
                  <input type="hidden" name="contactMechId" value='${contactMechId}'/>
                  <input type="hidden" name="contactMechTypeId" value='${contactMechTypeId}'/>
                  <input type='hidden' name='DONE_PAGE' value='${donePage}'/>
                </#if>
                <div class="form-horizontal">
                  <#if contactMechTypeId = "POSTAL_ADDRESS">
                  <div class="form-group">
                    <label for="toName" class="col-sm-3 control-label">${uiLabelMap.PartyToName}</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" size="30" maxlength="60" name="toName" value="${postalAddressData.toName!}"/>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="attnName" class="col-sm-3 control-label">${uiLabelMap.PartyAttentionName}</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" size="30" maxlength="60" name="attnName" value="${postalAddressData.attnName!}"/>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="address1" class="col-sm-3 control-label">${uiLabelMap.PartyAddressLine1} *</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control required" size="30" maxlength="60" name="address1" value="${postalAddressData.address1!}"/>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="address2" class="col-sm-3 control-label">${uiLabelMap.PartyAddressLine2}</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control" size="30" maxlength="30" name="address2" value="${postalAddressData.address2!}"/>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="city" class="col-sm-3 control-label">${uiLabelMap.PartyCity} *</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control required" size="30" maxlength="30" name="city" value="${postalAddressData.city!}"/>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="city" class="col-sm-3 control-label">${uiLabelMap.PartyState}</label>
                    <div class="col-sm-6">
                        <select name="stateProvinceGeoId" id="editcontactmechform_stateProvinceGeoId" class="form-control">
                        </select>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="partyZipCode" class="col-sm-3 control-label">${uiLabelMap.PartyZipCode} *</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control required" size="12" maxlength="10" name="postalCode" value="${postalAddressData.postalCode!}"/>
                    </div>
                  </div>
                  <div class="form-group">
                    <label for="partyZipCode" class="col-sm-3 control-label">${uiLabelMap.CommonCountry}</label>
                    <div class="col-sm-6">
                        <select name="countryGeoId" id="editcontactmechform_countryGeoId" class="form-control">
                          ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                          <#if (postalAddress??) && (postalAddress.countryGeoId??)>
                            <#assign defaultCountryGeoId = postalAddress.countryGeoId>
                          <#else>
                            <#assign defaultCountryGeoId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"]
                                .getPropertyValue("general", "country.geo.id.default", delegator)>
                          </#if>
                          <option selected="selected" value="${defaultCountryGeoId}">
                            <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"]
                                .toMap("geoId",defaultCountryGeoId), false)>
                            ${countryGeo.get("geoName",locale)}
                          </option>
                        </select>
                    </div>
                  </div>
                  <#elseif contactMechTypeId = "TELECOM_NUMBER">
                    <div class="form-group">
                      <label for="phoneNumber" class="col-sm-3 control-label">${uiLabelMap.PartyPhoneNumber}</label>
                      <div class="col-sm-6">
                        <input type="text" class="form-control" size="4" maxlength="10" name="countryCode" value="${telecomNumberData.countryCode!}"/>-&nbsp;
                        <input type="text" class="form-control" size="4" maxlength="10" name="areaCode" value="${telecomNumberData.areaCode!}"/>-&nbsp;
                        <input type="text" class="form-control" size="15" maxlength="15" name="contactNumber" value="${telecomNumberData.contactNumber!}"/>&nbsp;
                        ${uiLabelMap.PartyExtension}&nbsp;
                        <input type="text" class="form-control" size="6" maxlength="10" name="extension" value="${partyContactMechData.extension!}"/>
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="partyZipCode" class="col-sm-3 control-label"></label>
                      <div class="col-sm-6">
                          [${uiLabelMap.CommonCountryCode}] [${uiLabelMap.PartyAreaCode}] [${uiLabelMap.PartyContactNumber}]
                        [${uiLabelMap.PartyExtension}]
                      </div>
                    </div>
                  <#elseif contactMechTypeId = "EMAIL_ADDRESS">
                  <div class="form-group">
                    <label for="partyZipCode" class="col-sm-3 control-label">${uiLabelMap.PartyEmailAddress} *</label>
                    <div class="col-sm-6">
                        <input type="text" class="form-control required" size="60" maxlength="255" name="emailAddress" value="<#if tryEntity>${contactMech.infoString!}<#else>${requestParameters.emailAddress!}</#if>"/>
                    </div>
                  </div>
                  <#else>
                    <div class="form-group">
                      <label for="partyZipCode" class="col-sm-3 control-label">${contactMechType.get("description",locale)!} *</label>
                      <div class="col-sm-6">
                          <input type="text" class="form-control required" size="60" maxlength="255" name="infoString"
                            value="${contactMechData.infoString!}"/>
                      </div>
                    </div>
                  </#if>
                  <div class="form-group">
                    <label for="partyZipCode" class="col-sm-3 control-label">${uiLabelMap.PartyAllowSolicitation}?</label>
                    <div class="col-sm-2">
                        <select name="allowSolicitation" class="form-control">
                        <#if (((partyContactMechData.allowSolicitation)!"") == "Y")>
                          <option value="Y">${uiLabelMap.CommonY}</option></#if>
                        <#if (((partyContactMechData.allowSolicitation)!"") == "N")>
                          <option value="N">${uiLabelMap.CommonN}</option></#if>
                        <option></option>
                        <option value="Y">${uiLabelMap.CommonY}</option>
                        <option value="N">${uiLabelMap.CommonN}</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </table>
          <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
          <a href="javascript:document.editcontactmechform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
          <#else>
            <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
          </#if>
        </#if>
        </div>
      </div>
    </div>
  </div>
</div>