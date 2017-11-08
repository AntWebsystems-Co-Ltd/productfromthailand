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
<#include "component://widget/templates/HtmlFormMacroLibrary.ftl">
<script>
    jQuery(document).ready( function() {
      jQuery("#editpersonform").validate();
    });
</script>
<div id="main-container" class="container">
  <div class="row">
    <div class="col-sm-12">
      <div class="panel panel-smart">
        <#if person??>
          <div class="panel-heading navbar">
            <h2>${uiLabelMap.PartyEditPersonalInformation}</h2>
          </div>
          <form id="editpersonform" method="post" action="<@ofbizUrl>updatePerson</@ofbizUrl>" class="form-horizontal" name="editpersonform">
        <#else>
          <div class="panel-heading navbar">
            <h2>${uiLabelMap.PartyAddNewPersonalInformation}</h2>
          </div>
          <form id="editpersonform" method="post" action="<@ofbizUrl>createPerson/${donePage}</@ofbizUrl>" class="form-horizontal" name="editpersonform">
        </#if>
            <div class="panel-body">
              &nbsp;<a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
              &nbsp;<a href="javascript:javascript:$('#editpersonform').submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
              <p/>
              <input type="hidden" name="partyId" value="${person.partyId!}"/>
              <table class="basic-table" cellspacing="0">
                <div class="form-group">
                  <label for="name" class="col-sm-3 control-label">${uiLabelMap.CommonTitle}</label>
                  <div class="col-sm-6">
                    <select name="personalTitle" class="form-control">
                      <#if personData.personalTitle?has_content >
                      <option>${personData.personalTitle}</option>
                      <option value=""> --</option>
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
                  <label for="firstName" class="col-sm-3 control-label">${uiLabelMap.PartyFirstName} *</label>
                  <div class="col-sm-6">
                    <input type="text" class='form-control required' size="30" maxlength="30" name="firstName" value="${personData.firstName!}"/>
                  </div>
                </div>
                <#if partyRoleType != 'SUPPLIER'>
                     <div class="form-group">
                       <label for="middleName" class="col-sm-3 control-label">${uiLabelMap.PartyMiddleInitial}</label>
                       <div class="col-sm-6">
                         <input type="text" class="form-control" size="4" maxlength="4" name="middleName" value="${personData.middleName!}"/>
                       </div>
                     </div>
                </#if>
                <div class="form-group">
                  <label for="lastName" class="col-sm-3 control-label">${uiLabelMap.PartyLastName} *</label>
                  <div class="col-sm-6">
                    <input type="text" class="form-control required" size="30" maxlength="30" name="lastName" value="${personData.lastName!}"/>
                  </div>
                </div>
                <#if partyRoleType == 'SUPPLIER'>
                     <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTTitleIdNoIdPassport} *</label>
                        <div class="col-sm-6" >
                            <input type="text" class="form-control required" name="idCardNo" value="${partyIdentification?if_exists}" maxlength="30" disabled/>
                        </div>
                    </div>
                </#if>
                <div class="form-group">
                  <label for="gender" class="col-sm-3 control-label">${uiLabelMap.PartyGender}</label>
                  <div class="col-sm-6">
                    <select name="gender" class="form-control">
                    <#if personData.gender?has_content >
                      <option value="${personData.gender}">
                        <#if personData.gender == "M" >${uiLabelMap.CommonMale}</#if>
                          <#if personData.gender == "F" >${uiLabelMap.CommonFemale}</#if>
                      </option>
                      <option value=""> --</option>
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
                        <div class="form-group">
                            <div class='input-group date' id='datetimepicker_birthDate'>
                                <input type='text' class="form-control" name="birthDate" <#if personData.birthDate?has_content > value="${personData.birthDate?string("yyyy-MM-dd")!}" </#if>/>
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-calendar">
                                    </span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <script type="text/javascript">
                        $(function () {
                            $('#datetimepicker_birthDate').datetimepicker({format: 'YYYY-MM-DD'});
                        });
                    </script>
                </div>
              </table>
            </div>
          </form>
        <a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>&nbsp;
        <a id="editpersonform" href="javascript:$('#editpersonform').submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
      </div>
    </div>
  </div>
</div>