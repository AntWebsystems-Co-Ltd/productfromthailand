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
      appId            : '${facebookAppId!}',
      autoLogAppEvents : true,
      xfbml            : true,
      version          : <#if facebookApiVersion?has_content>'${facebookApiVersion}'<#else>'v2.10'</#if>
    });
    FB.AppEvents.logPageView();
  };
  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     //js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
</script>
</#if>
<div id="main-container" class="container">
    <div class="row">
        <div class="col-sm-6">
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h4>${uiLabelMap.PFTSignIn}</h4>
                </div>
                <div class="panel-body">
                    <form method="post" action="<@ofbizUrl>login</@ofbizUrl>" class="form-horizontal" name="loginform">
                        <table class="basic-table" cellspacing="0">
                            <div class="form-group">
                                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonUsername}</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" name="USERNAME" id="username" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonPassword}</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" name="PASSWORD" id="password" size="20"/>
                                </div>
                            </div>
                            <div class="form-group" align="center">
                                <button type="submit" class="btn btn-main">Login</button>
                                <a href="<@ofbizUrl>forgotYourPassword</@ofbizUrl>" class="btn btn-main text-uppercase">${uiLabelMap.CommonForgotYourPassword}</a>
                            </div>
                        </table>
                        <input type="hidden" name="JavaScriptEnabled" value="N"/>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h4>${uiLabelMap.PFTSignInWithSocial}</h4>
                </div>
                <div class="panel-body">
                    <#if googleClientId?has_content>
                        <div class="form-group">
                            <div id="googleBtn" class="customGPlusSignIn">
                              <span class="googleIcon"></span>
                              <span class="googleButtonText">Sign in with Google</span>
                            </div>
                            <script>startApp();</script>
                        </div>
                    </#if>
                    <#if facebookAppId?has_content>
                        <div class="form-group">
                            <div class="signInWrapper">
                                <div class="fb-login-button" data-max-rows="1" data-size="medium" data-button-type="login_with" login-text="Sign in with Facebook" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false" scope="public_profile,email" onlogin="checkLoginFacebook();"></div>
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
</form>
</#if>
<#-- Facebook login hidden Form -->
<#if facebookAppId?has_content>
<form id="facebookForm" name="facebookForm" action="<@ofbizUrl>facebookLogin</@ofbizUrl>" method="POST">
    <input id="facebookFirstName" type="hidden" name="firstName" value="">
    <input id="facebookLastName" type="hidden" name="lastName" value="">
    <input id="facebookEmail" type="hidden" name="email" value="">
    <input id="facebookAccesToken" type="hidden" name="accesToken" value="">
</form>
</#if>
<script>
    <#if autoUserLogin?has_content>document.loginform.PASSWORD.focus();</#if>
    <#if !autoUserLogin?has_content>document.loginform.USERNAME.focus();</#if>

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
