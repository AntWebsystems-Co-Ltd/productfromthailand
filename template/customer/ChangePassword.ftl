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
  <div class="panel panel-smart">
    <div class="panel-heading navbar">
      <h3>${uiLabelMap.PartyChangePassword}</h3>
    </div>
    <div class="panel-body">
      <form id="changepasswordform" method="post" class="form-horizontal" action="<@ofbizUrl>updatePassword/${donePage}</@ofbizUrl>">
        <div class="form-group">
          <label for="currentPassword" class="col-sm-3 control-label">${uiLabelMap.PartyOldPassword} *</label>
          <div class="col-sm-6">
              <input type="password" class='form-control required' name="currentPassword" id="currentPassword" maxlength="20"/>
          </div>
        </div>
        <div class="form-group">
          <label for="newPassword" class="col-sm-3 control-label">${uiLabelMap.PartyNewPassword} *</label>
          <div class="col-sm-6">
              <input type="password" class='form-control required' name="newPassword" id="newPassword" maxlength="20"/>
          </div>
        </div>
        <div class="form-group">
          <label for="newPasswordVerify" class="col-sm-3 control-label">${uiLabelMap.PartyNewPasswordVerify} *</label>
          <div class="col-sm-6">
              <input type="password" class='form-control required' name="newPasswordVerify" id="newPasswordVerify" maxlength="20"/>
          </div>
        </div>
        <div class="form-group">
          <label for="passwordHint" class="col-sm-3 control-label">${uiLabelMap.PartyPasswordHint} *</label>
          <div class="col-sm-6">
              <input type="passwordHint" class='form-control required' name="passwordHint" id="passwordHint" maxlength="100" value="${userLoginData.passwordHint!}"/>
          </div>
        </div>
      </form>
      <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
      <a href="javascript:document.getElementById('changepasswordform').submit()" class="btn btn-main">
        ${uiLabelMap.CommonSave}
      </a>
    </div>
  </div>
</div>
