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
        <div class="panel-heading">
          <h2>${uiLabelMap.PageTitleEditGroupInformation}</h2>
        </div>
        <div class="panel-body">
          &nbsp;<a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
          &nbsp;<a href="javascript:document.EditPartyGroup.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
          <form method="post" action="<@ofbizUrl>updatePartyGroup</@ofbizUrl>" class="form-horizontal" id="EditPartyGroup" name="EditPartyGroup">
            <input type="hidden" name="partyId" value="${partyGroup.partyId!}"/>
            <div class="form-group">
              <label class="col-sm-3 control-label">${uiLabelMap.PartyPartyId}</label>
              <div class="col-sm-6">
                <input type="text" class='form-control' size="30" maxlength="30" name="partyId" value="${partyGroup.partyId!}" disabled/>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_groupName}</label>
              <div class="col-sm-6">
                <input type="text" class='form-control required' size="30" maxlength="30" name="groupName" value="${partyGroup.groupName!}"/>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_groupNameLocal}</label>
              <div class="col-sm-6">
                <input type="text" class='form-control' size="30" maxlength="30" name="groupNameLocal" value="${partyGroup.groupNameLocal!}"/>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_officeSiteName}</label>
              <div class="col-sm-6">
                <input type="text" class='form-control' size="30" maxlength="30" name="officeSiteName" value="${partyGroup.officeSiteName!}"/>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">${uiLabelMap.PartyComments}</label>
              <div class="col-sm-6">
                <input type="text" class='form-control' size="30" maxlength="30" name="comments" value="${partyGroup.comments!}"/>
              </div>
            </div>
            <div class="form-group company">
                <label class="col-sm-3 control-label">${uiLabelMap.PFTTitleIdBizRegisterNo} *</label>
                <div class="col-sm-6" >
                    <input type="text" class="form-control required" name="businessRegistNo" value="<#if regisNo?has_content>${regisNo.idValue!}</#if>" maxlength="30" disabled/>
                </div>
            </div>
          </form>
        </div>
        <a href='<@ofbizUrl>${donePage}</@ofbizUrl>' class="btn btn-main">${uiLabelMap.CommonGoBack}</a>&nbsp;
        <a id="editpersonform3" href="javascript:document.EditPartyGroup.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
      </div>
    </div>
  </div>
</div>