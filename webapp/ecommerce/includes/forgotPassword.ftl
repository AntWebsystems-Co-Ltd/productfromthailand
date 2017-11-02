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
    <div class="col-sm-12" style="text-align:center">
      <div class="panel panel-smart">
        <div class="panel-heading">
          <h3>${uiLabelMap.CommonForgotYourPassword}?</h3>
        </div>
        <div class="panel-body">
          <form method="post" class="form-horizontal" action="<@ofbizUrl>forgotpassword</@ofbizUrl>">
            <div class="form-group">
              <label for="inputFname" for="forgotpassword_userName" class="col-sm-5 control-label">${uiLabelMap.CommonUsername}:</label>
              <div class="col-sm-3">
                  <input type="text" class="form-control" name="USERNAME" id="forgotpassword_userName" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>"/>
              </div>
            </div>
            <div class="form-group">
              <input type="submit" class="btn btn-main" name="GET_PASSWORD_HINT" value="${uiLabelMap.CommonGetPasswordHint}"/>
              <input type="submit" class="btn btn-main" name="EMAIL_PASSWORD" value="${uiLabelMap.CommonEmailPassword}"/>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
