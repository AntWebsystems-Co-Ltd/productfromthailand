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
        <#if person??>
          <div class="panel-heading navbar">
            <h2>${uiLabelMap.PartyEditPersonalInformation}</h2>
          </div>
          <form id="editpersonform1" method="post" action="<@ofbizUrl>updatePerson</@ofbizUrl>" class="form-horizontal" name="editpersonform">
        <#else>
          <div class="panel-heading navbar">
            <h2>${uiLabelMap.PartyAddNewPersonalInformation}</h2>
          </div>
          <form id="editpersonform2" method="post" action="<@ofbizUrl>createPerson/${donePage}</@ofbizUrl>" class="form-horizontal" name="editpersonform">
        </#if>
            <div class="panel-body">
              &nbsp;<a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
              &nbsp;<a href="javascript:document.editpersonform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
              <p/>
              <input type="hidden" name="partyId" value="${person.partyId!}"/>
              <table class="basic-table" cellspacing="0">
                <div class="form-group">
                  <label for="name" class="col-sm-3 control-label">${uiLabelMap.CommonTitle}</label>
                  <div class="col-sm-6">
                    <select name="personalTitle" class="form-control">
                      <#if personData.personalTitle?has_content >
                      <option>${personData.personalTitle}</option>
                      <option value="${personData.personalTitle}"> --</option>
                    <#else>
                      <option value="">${uiLabelMap.CommonSelectOne}</option>
                    </#if>
                      <option>${uiLabelMap.CommonTitleMr}</option>
                      <option>${uiLabelMap.CommonTitleMrs}</option>
                      <option>${uiLabelMap.CommonTitleMs}</option>
                        <option>${uiLabelMap.CommonTitleDr}</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label for="firstName" class="col-sm-3 control-label">${uiLabelMap.PartyFirstName}</label>
                  <div class="col-sm-6">
                    <input type="text" class='form-control required' size="30" maxlength="30" name="firstName" value="${personData.firstName!}"/>*
                  </div>
                </div>
                <div class="form-group">
                  <label for="middleName" class="col-sm-3 control-label">${uiLabelMap.PartyMiddleInitial}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="4" maxlength="4" name="middleName" value="${personData.middleName!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="lastName" class="col-sm-3 control-label">${uiLabelMap.PartyLastName}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="30" name="lastName" value="${personData.lastName!}"/>*
                  </div>
                </div>
                <div class="form-group">
                  <label for="suffix" class="col-sm-3 control-label">${uiLabelMap.PartySuffix}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="10" maxlength="30" name="suffix" value="${personData.suffix!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="nickname" class="col-sm-3 control-label">${uiLabelMap.PartyNickName}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="nickname" value="${personData.nickname!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="gender" class="col-sm-3 control-label">${uiLabelMap.PartyGender}</label>
                  <div class="col-sm-6">
                    <select name="gender" class="form-control">
                    <#if personData.gender?has_content >
                      <option value="${personData.gender}">
                        <#if personData.gender == "M" >${uiLabelMap.CommonMale}</#if>
                          <#if personData.gender == "F" >${uiLabelMap.CommonFemale}</#if>
                      </option>
                      <option value="${personData.gender}"> --</option>
                    <#else>
                      <option value="">${uiLabelMap.CommonSelectOne}</option>
                    </#if>
                      <option value="M">${uiLabelMap.CommonMale}</option>
                      <option value="F">${uiLabelMap.CommonFemale}</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label for="birthDate" class="col-sm-3 control-label">${uiLabelMap.PartyBirthDate}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="11" maxlength="20" name="birthDate" value="${(personData.birthDate.toString())!}"/>
                    <div>${uiLabelMap.CommonFormatDate}</div>
                  </div>
                </div>
                <div class="form-group">
                  <label for="height" class="col-sm-3 control-label">${uiLabelMap.PartyHeight}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="height" value="${personData.height!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="weight" class="col-sm-3 control-label">${uiLabelMap.PartyWeight}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="weight" value="${personData.weight!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="mothersMaidenName" class="col-sm-3 control-label">${uiLabelMap.PartyMaidenName}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="mothersMaidenName" value="${personData.mothersMaidenName!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="maritalStatus" class="col-sm-3 control-label">${uiLabelMap.PartyMaritalStatus}</label>
                  <div class="col-sm-6">
                    <select name="maritalStatus" class="form-control">
                    <#if personData.maritalStatus?has_content>
                      <option value="${personData.maritalStatus}">
                        <#if personData.maritalStatus == "S">${uiLabelMap.PartySingle}</#if>
                         <#if personData.maritalStatus == "M">${uiLabelMap.PartyMarried}</#if>
                         <#if personData.maritalStatus == "D">${uiLabelMap.PartyDivorced}</#if>
                      </option>
                      <option value="${personData.maritalStatus}"> --</option>
                    <#else>
                      <option></option>
                    </#if>
                      <option value="S">${uiLabelMap.PartySingle}</option>
                      <option value="M">${uiLabelMap.PartyMarried}</option>
                      <option value="D">${uiLabelMap.PartyDivorced}</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <label for="socialSecurityNumber" class="col-sm-3 control-label">${uiLabelMap.PartySocialSecurityNumber}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="socialSecurityNumber" value="${personData.socialSecurityNumber!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="passportNumber" class="col-sm-3 control-label">${uiLabelMap.PartyPassportNumber}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="passportNumber" value="${personData.passportNumber!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="name" class="col-sm-3 control-label">${uiLabelMap.PartyPassportExpireDate}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="passportExpireDate" value="${personData.passportExpireDate!}"/>
                    <div>${uiLabelMap.CommonFormatDate}</div>
                  </div>
                </div>
                <div class="form-group">
                  <label for="totalYearsWorkExperience" class="col-sm-3 control-label">${uiLabelMap.PartyTotalYearsWorkExperience}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="totalYearsWorkExperience" value="${personData.totalYearsWorkExperience!}"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="comments" class="col-sm-3 control-label">${uiLabelMap.CommonComment}</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control" size="30" maxlength="60" name="comments" value="${personData.comments!}"/>
                  </div>
                </div>
              </table>
            </div>
          </form>
        <a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>&nbsp;
        <a id="editpersonform3" href="javascript:document.editpersonform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
      </div>
    </div>
  </div>
</div>