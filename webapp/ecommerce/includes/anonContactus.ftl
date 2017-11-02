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
    <div class="screenlet">
      <script type="text/javascript" language="JavaScript">
        <!--
        function reloadCaptcha(fieldName) {
          var captchaUri = "<@ofbizUrl>captcha.jpg?captchaCodeId=" + fieldName + "&amp;unique=_PLACEHOLDER_</@ofbizUrl>";
          var unique = Date.now();
          captchaUri = captchaUri.replace("_PLACEHOLDER_", unique);
          document.getElementById(fieldName).src = captchaUri;
        }
        //-->
      </script>
      <div class="col-sm-4">
        <div class="panel panel-smart">
          <div class="panel-heading">
            <h3 class="panel-title">Contact Details</h3>
          </div>
          <div class="panel-body">
            <ul class="list-unstyled contact-details">
              <#if address.address1?has_content>
                <li class="clearfix">
                  <i class="fa fa-home pull-left"></i>
                  <span class="pull-left">
                    ${address.address1} <br>
                    ${address.city!}  ${address.postalCode!}
                  </span>
                </li>
              </#if>
              <#if telephone.contactNumber?has_content>
                <li class="clearfix">
                  <i class="fa fa-phone pull-left"></i>
                  <span class="pull-left">
                    (${telephone.countryCode!}) ${telephone.areaCode!}-${telephone.contactNumber!}
                  </span>
                </li>
              </#if>
              <#if orgEmail.emailAddress?has_content>
                <li class="clearfix">
                  <i class="fa fa-envelope-o pull-left"></i>
                  <span class="pull-left">
                    ${orgEmail.emailAddress}
                  </span>
                </li>
              </#if>
            </ul>
          </div>
        </div>
      </div>
      <div class="col-sm-8">
        <div class="panel panel-smart">
          <div class="panel-heading">
            <h3 class="panel-title">${uiLabelMap.CommonContactUs}</h3>
          </div>
          <div class="panel-body">
            <form id="contactForm" method="post" action="<@ofbizUrl>submitAnonContact</@ofbizUrl>" class="form-horizontal" role="form">
              <input type="hidden" name="partyIdFrom" value="${(userLogin.partyId)!}"/>
              <input type="hidden" name="partyIdTo" value="${productStore.payToPartyId!}"/>
              <input type="hidden" name="contactMechTypeId" value="WEB_ADDRESS"/>
              <input type="hidden" name="communicationEventTypeId" value="WEB_SITE_COMMUNICATI"/>
              <input type="hidden" name="productStoreId" value="${productStore.productStoreId}"/>
              <input type="hidden" name="emailType" value="CONT_NOTI_EMAIL"/>
              <div class="form-group">
                <label for="name" class="col-sm-2 control-label">
                  ${uiLabelMap.EcommerceSubject}
                </label>
                <div class="col-sm-10">
                  <input type="text" name="subject" id="subject" class="required form-control" placeholder="Subject" value="${requestParameters.subject!}"/>
                </div>
              </div>
              <div class="form-group">
                <label for="email" class="col-sm-2 control-label">
                  ${uiLabelMap.CommonMessage}
                </label>
                <div class="col-sm-10">
                  <textarea name="content" id="message" class="required form-control" rows="5" placeholder="Message">${requestParameters.content!}</textarea>
                </div>
              </div>
              <div class="form-group">
                <label for="subject" class="col-sm-2 control-label">
                  ${uiLabelMap.FormFieldTitle_emailAddress}
                </label>
                <div class="col-sm-10">
                  <input type="text" name="emailAddress" id="emailAddress" class="form-control required" placeholder="Email address" value="${requestParameters.emailAddress!}"/>
                </div>
              </div>
              <div class="form-group">
                <label for="message" class="col-sm-2 control-label">
                  ${uiLabelMap.PartyFirstName}
                </label>
                <div class="col-sm-10">
                  <input type="text" name="firstName" id="firstName" class="form-control required" placeholder="First name" value="${requestParameters.firstName!}"/>
                </div>
              </div>
              <div class="form-group">
                <label for="message" class="col-sm-2 control-label">
                  ${uiLabelMap.PartyLastName}
                </label>
                <div class="col-sm-10">
                  <input type="text" name="lastName" id="lastName" class="form-control required" placeholder="Last name" value="${requestParameters.lastName!}"/>
                </div>
              </div>
              <div class="form-group">
                <label for="message" class="col-sm-2 control-label">
                  ${uiLabelMap.CommonCaptchaCode}
                </label>
                <div class="col-sm-10">
                  <div>
                    <img id="captchaImage"
                        src="<@ofbizUrl>captcha.jpg?captchaCodeId=captchaImage&amp;unique=${nowTimestamp.getTime()}</@ofbizUrl>"
                        alt=""/>
                  </div>
                  <a href="javascript:reloadCaptcha('captchaImage');">${uiLabelMap.CommonReloadCaptchaCode}</a>
                  </div>
              </div>
              <div class="form-group">
                <label for="message" class="col-sm-2 control-label">
                  ${uiLabelMap.CommonVerifyCaptchaCode}
                </label>
                <div class="col-sm-10">
                  <input type="text" autocomplete="off" maxlength="30" size="23" name="captcha" class="form-control"/>
                </div>
              </div>
              <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                  <button type="submit" class="btn btn-main text-uppercase">Submit</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
