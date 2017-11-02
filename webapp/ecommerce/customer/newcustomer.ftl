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

<#assign googleClientId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("google", "clientId", delegator)>
<#assign facebookAppId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("facebook", "appId", delegator)>
<#assign facebookApiVersion = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("facebook", "apiVersion", delegator)>

<#-- Google Js -->
<#if googleClientId?has_content>
<script src="https://apis.google.com/js/api:client.js"></script>
<meta name="google-signin-client_id" content="${googleClientId!}">

<script>
    var googleUser = {};
    var startApp = function() {
        gapi.load('auth2', function(){
            // Retrieve the singleton for the GoogleAuth library and set up the client.
            auth2 = gapi.auth2.init({
                client_id: '${googleClientId!}',
                cookiepolicy: 'none',
                // Request scopes in addition to 'profile' and 'email'
                //scope: 'additional_scope'
            });
            attachSignin(document.getElementById('googleBtn'));
            function attachSignin(element) {
                auth2.attachClickHandler(element, {},
                    function(googleUser) {
                        onSignIn(googleUser);
                    }
                );
            }
        });
    };
</script>
</#if>
<#-- Facebook Js -->
<#if facebookAppId?has_content>
<script src="https://connect.facebook.net/en_US/sdk.js"></script>
<script>
  window.fbAsyncInit = function() {
    FB.init({
        appId   : '${facebookAppId!}',
        oauth   : true,
        status  : true, // check login status
        cookie  : true, // enable cookies to allow the server to access the session
        xfbml   : true, // parse XFBML
        version : <#if facebookApiVersion?has_content>'${facebookApiVersion}'<#else>'v2.10'</#if>
    });
    (function(d, s, id){
       var js, fjs = d.getElementsByTagName(s)[0];
       if (d.getElementById(id)) {return;}
       js = d.createElement(s); js.id = id;
       //js.src = "//connect.facebook.net/en_US/sdk.js";
       fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

  };
</script>
</#if>

<#if getUsername>
<script type="text/javascript">
  lastFocusedName = null;
  function setLastFocused(formElement) {
    lastFocusedName = formElement.name;
    document.write.lastFocusedName;
  }
  function clickUsername() {
    if (document.getElementById('UNUSEEMAIL').checked) {
      if (lastFocusedName == "UNUSEEMAIL") {
        jQuery('#PASSWORD').focus();
      } else if (lastFocusedName == "PASSWORD") {
        jQuery('#UNUSEEMAIL').focus();
      } else {
        jQuery('#PASSWORD').focus();
      }
    }
  }
  function changeEmail() {
    if (document.getElementById('UNUSEEMAIL').checked) {
      document.getElementById('USERNAME').value = jQuery('#CUSTOMER_EMAIL').val();
    }
  }
  function setEmailUsername() {
    if (document.getElementById('UNUSEEMAIL').checked) {
      document.getElementById('USERNAME').value = jQuery('#CUSTOMER_EMAIL').val();
      // don't disable, make the browser not submit the field: document.getElementById('USERNAME').disabled=true;
    } else {
      document.getElementById('USERNAME').value = '';
      // document.getElementById('USERNAME').disabled=false;
    }
  }
</script>
</#if>

<#------------------------------------------------------------------------------
NOTE: all page headings should start with an h2 tag, not an H1 tag, as
there should generally always only be one h1 tag on the page and that
will generally always be reserved for the logo at the top of the page.
------------------------------------------------------------------------------->
<div id="main-container" class="container">
  <div class="row">
    <div class="col-sm-8">
      <div class="panel-smart">
        <div class="panel-heading">
          <h2>${uiLabelMap.PFTRegisterAsCustomer}</h2>
        </div>
        <#macro fieldErrors fieldName>
          <#if errorMessageList?has_content>
            <#assign fieldMessages = Static["org.apache.ofbiz.base.util.MessageString"].getMessagesForField(fieldName, true, errorMessageList)>
            <ul>
              <#list fieldMessages as errorMsg>
                <li class="errorMessage">${errorMsg}</li>
              </#list>
            </ul>
          </#if>
        </#macro>
        <#macro fieldErrorsMulti fieldName1 fieldName2 fieldName3 fieldName4>
          <#if errorMessageList?has_content>
            <#assign fieldMessages = Static["org.apache.ofbiz.base.util.MessageString"].getMessagesForField(fieldName1, fieldName2, fieldName3, fieldName4, true, errorMessageList)>
            <ul>
              <#list fieldMessages as errorMsg>
                <li class="errorMessage">${errorMsg}</li>
              </#list>
            </ul>
          </#if>
        </#macro>
        <div class="panel-body">
          <div class="manualRegister">
            <form method="post" action="<@ofbizUrl>createcustomer${previousParams}</@ofbizUrl>" class="form-horizontal" id="newuserform" name="newuserform">
              <input type="hidden" name="emailProductStoreId" value="${productStoreId}"/>
              <div class="form-group">
                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonTitle}</label>
                <div class="col-sm-6">
                  <@fieldErrors fieldName="USER_TITLE"/>
                  <select name="USER_TITLE" id="USER_TITLE" class="form-control">
                    <#if requestParameters.USER_TITLE?has_content >
                      <option>${requestParameters.USER_TITLE}</option>
                      <option value="${requestParameters.USER_TITLE}"> -- </option>
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
                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyFirstName} *</label>
                <div class="col-sm-6">
                  <input type="text" class="form-control required" name="USER_FIRST_NAME" id="USER_FIRST_NAME" value="${requestParameters.USER_FIRST_NAME?if_exists}"/>
                </div>
              </div>
              <div class="form-group">
                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyLastName} *</label>
                <div class="col-sm-6">
                  <input type="text" class="form-control required" name="USER_LAST_NAME" id="USER_LAST_NAME" value="${requestParameters.USER_LAST_NAME?if_exists}"/>
                </div>
              </div>
              <div class="form-group">
                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyEmailAddress} *</label>
                <div class="col-sm-6">
                  <input type="text" class="form-control required" name="CUSTOMER_EMAIL" id="CUSTOMER_EMAIL" value="${requestParameters.CUSTOMER_EMAIL?if_exists}" onchange="changeEmail()" onkeyup="changeEmail()"/>
                </div>
              </div>
              <#if getUsername>
                <div class="form-group">
                  <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonUsername} *</label>
                  <div class="col-sm-6">
                    <input type="checkbox" name="UNUSEEMAIL" id="UNUSEEMAIL" value="on" onclick="setEmailUsername();" onfocus="setLastFocused(this);"> ${uiLabelMap.EcommerceUseEmailAddress}
                    <br/>
                    <input type="text" class="form-control required" name="USERNAME" id="USERNAME" value="${requestParameters.USERNAME?if_exists}" onfocus="clickUsername();" onchange="changeEmail();"/>
                  </div>
                </div>
              </#if>
              <#if createAllowPassword>
                <div class="form-group">
                  <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonPassword} *</label>
                  <div class="col-sm-6">
                    <input type="password" class="form-control required" name="PASSWORD" id="PASSWORD" onfocus="setLastFocused(this);"/>
                  </div>
                </div>
                <div class="form-group">
                  <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTConfirmPassword} *</label>
                  <div class="col-sm-6">
                    <input type="password" class="form-control required" name="CONFIRM_PASSWORD" id="CONFIRM_PASSWORD" value="" maxlength="50"/>
                  </div>
                </div>
              </#if>
            </form>
            <#------------------------------------------------------------------------------
            To create a consistent look and feel for all buttons, input[type=submit],
            and a tags acting as submit buttons, all button actions should have a
            class name of "button". No other class names should be used to style
            button actions.
            ------------------------------------------------------------------------------->
            <div class="newuserbutton">
              <a href="javascript:$('#newuserform').submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
              <a href="<@ofbizUrl>checkLogin</@ofbizUrl>" class="reset btn btn-main">${uiLabelMap.CommonBack}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-sm-4">
      <div class="panel-smart">
        <div class="panel-heading">
          <h2>${uiLabelMap.PFTRegisterWithSocial}</h2>
        </div>
        <div class="panel-body">
          <#if googleClientId?has_content>
            <div class="form-group">
              <div id="googleBtn" class="customGPlusSignIn">
                <span class="googleIcon"></span>
                <span class="googleButtonText">Sign up with Google</span>
              </div>
              <script>startApp();</script>
            </div>
          </#if>
          <#if facebookAppId?has_content>
            <div class="form-group">
              <div class="signInWrapper">
                  <div class="fb-login-button" data-max-rows="1" data-size="medium" data-button-type="login_with" login-text="Sign up with Facebook" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false" scope="public_profile,email" onlogin="checkLoginFacebook();"></div>
              </div>
            </div>
          </#if>
        </div>
      </div>
    </div>
  </div>
</div>
<#-- Google login hidden Form -->
<#if googleClientId?has_content>
<form id="googleForm" name="googleForm" action="<@ofbizUrl>googleLogin</@ofbizUrl>" method="POST">
    <input id="googleFirstName" type="hidden" name="firstName" value="">
    <input id="googleLastName" type="hidden" name="lastName" value="">
    <input id="email" type="hidden" name="email" value="">
    <input id="accesToken" type="hidden" name="accesToken" value="">
    <input id="googleSignUp" type="hidden" name="signUp" value="Y">
    <input id="roleTypeId" type="hidden" name="roleTypeId" value="CUSTOMER">
</form>
</#if>
<#-- Facebook login hidden Form -->
<#if facebookAppId?has_content>
<form id="facebookForm" name="facebookForm" action="<@ofbizUrl>facebookLogin</@ofbizUrl>" method="POST">
    <input id="facebookFirstName" type="hidden" name="firstName" value="">
    <input id="facebookLastName" type="hidden" name="lastName" value="">
    <input id="facebookEmail" type="hidden" name="email" value="">
    <input id="facebookAccesToken" type="hidden" name="accesToken" value="">
    <input id="facebookSignUp" type="hidden" name="signUp" value="Y">
    <input id="roleTypeId" type="hidden" name="roleTypeId" value="CUSTOMER">
</form>
</#if>
<script>
    jQuery(document).ready( function() {
      jQuery("#newuserform").validate();
    });
    <#-- Google login Js to get data -->
    <#if googleClientId?has_content>
    function onSignIn(googleUser) {
        var profile = googleUser.getBasicProfile();
        $("#googleFirstName").val(profile.getGivenName());
        $("#googleLastName").val(profile.getFamilyName());
        $("#email").val(profile.getEmail());
        var auth2 = gapi.auth2.getAuthInstance();
        $("#accesToken").val(auth2.currentUser.get().getAuthResponse().id_token);
        auth2.signOut();
        document.getElementById("googleForm").submit();
    }
    </#if>
    <#-- Facebook login Js to get data -->
    <#if facebookAppId?has_content>
    function checkLoginFacebook() {
        FB.getLoginStatus(function(response) {
            if(response.status === 'connected') {
                $("#facebookAccesToken").val(response.authResponse.accessToken);
                $("#facebookUserId").val(response.authResponse.userID);
                FB.api('/me?fields=first_name,last_name,email', function(response) {
                    $("#facebookFirstName").val(response.first_name);
                    $("#facebookLastName").val(response.last_name);
                    $("#facebookEmail").val(response.email);
                    document.getElementById("facebookForm").submit();
                });
            }
        });
    }
    </#if>
</script>
