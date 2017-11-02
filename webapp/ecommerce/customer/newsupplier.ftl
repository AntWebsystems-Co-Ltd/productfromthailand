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

<script type="text/javascript">
    $(document).ready(function () {
        document.newuserform.supplierType.value = "${parameters.supplierType!}"
        if ($("input[name=supplierType]:checked").val() == "SUPP_INDIVIDUAL") {
            $(".company").hide();
            $(".individual").show();
        }
        if ($("input[name=supplierType]:checked").val() == "SUPP_COMPANY") {
            $(".individual").hide();
            $(".company").show();
        }
        $("input[name=supplierType]").change(function(){
            supplierType = $("input[name=supplierType]:checked").val()
            if (supplierType == "SUPP_INDIVIDUAL") {
                $(".company").hide();
                $(".individual").show();

                $("#groupName").val("");
                $("#newsupplier_businessRegistNo").val("");
            } else {
                $(".individual").hide();
                $(".company").show();

                $("#firstName").val("");
                $("#lastName").val("");
                $("#USER_TITLE").val("");
                $("#newsupplier_idCardNo").val("");
            }
        });
    })
</script>

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
  //<![CDATA[
     function hideShowUsaStates() {
        var customerStateElement = document.getElementById('newuserform_stateProvinceGeoId');
        var customerCountryElement = document.getElementById('newuserform_countryGeoId');
        if (customerCountryElement.value == "USA" || customerCountryElement.value == "UMI" || customerCountryElement.value == "THA") {
          customerStateElement.style.display = "block";
        } else {
          customerStateElement.style.display = "none";
        }
      }
   //]]>
</script>
</#if>

<div id="main-container" class="container">
    <div class="row">
        <div class="col-sm-8">
            <div class="panel-smart">
                <div class="panel-heading">
                    <h2>${uiLabelMap.PFTRegisterAsSupplier}</h2>
                </div>
                <div class="panel-body">
                    <form id="newuserform" name="newuserform" method="post" class="form-horizontal" action="createsupplier" enctype="multipart/form-data" novalidate="novalidate">
                        <input type="hidden" name="roleTypeId" value="SUPPLIER"/>
                        <input type="hidden" name="emailContactMechPurposeTypeId" value="PRIMARY_EMAIL"/>
                        <input type="hidden" name="partyContentTypeId" value="INTERNAL"/>
                        <#assign productStoreId = Static["org.apache.ofbiz.product.store.ProductStoreWorker"].getProductStoreId(request)/>
                        <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}"/>
                        <div class="form-group">
                            <label for="supplierType" class="col-sm-3 control-label">${uiLabelMap.PFTTitleSupplierType}</label>
                            <div class="col-sm-6">
                                <input type="radio" name="supplierType" value="SUPP_INDIVIDUAL" checked="checked"/>${uiLabelMap.PFTSupplierTypeIndividual}<br/>
                                <input type="radio" name="supplierType" value="SUPP_COMPANY"/>${uiLabelMap.PFTSupplierTypeCompany}
                            </div>
                        </div>
                        <div class="form-group individual">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonTitle} *</label>
                            <div class="col-sm-6">
                                <select name="personalTitle" id="USER_TITLE" class="form-control required">
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
                            <div class="col-sm-6" ">
                                <input type="text" class="form-control required" name="firstName" id="firstName" value="${parameters.firstName?if_exists}"/>
                            </div>
                        </div>
                        <div class="form-group company">
                            <label for="inputFname" class="col-sm-3 control-label ">${uiLabelMap.PFTSupplierName} *</label>
                            <div class="col-sm-6" >
                                <input type="text" class="form-control required" name="groupName" id="groupName" class="required" value="${parameters.groupName?if_exists}" maxlength="30"/>
                            </div>
                        </div>
                        <div class="form-group individual">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyLastName} *</label>
                            <div class="col-sm-6" >
                                <input type="text" class="form-control required" name="lastName" id="lastName" value="${parameters.lastName?if_exists}"/>
                            </div>
                        </div>
                        <div class="form-group individual">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTTitleIdNoIdPassport} *</label>
                            <div class="col-sm-6" >
                                <input type="text" class="form-control required" name="idCardNo" id="newsupplier_idCardNo" value="${parameters.idCardNo?if_exists}" maxlength="30"/>
                            </div>
                        </div>
                        <div class="form-group company">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTTitleIdBizRegisterNo} *</label>
                            <div class="col-sm-6" >
                                <input type="text" class="form-control required" name="businessRegistNo" id="newsupplier_businessRegistNo" class="required" value="${parameters.businessRegistNo?if_exists}" maxlength="30"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label company">${uiLabelMap.PFTTitleUploadIdScan} *</label>
                            <label for="inputFname" class="col-sm-3 control-label individual">${uiLabelMap.PFTTitleUploadBizRegisterNo} *</label>
                            <div class="col-sm-6" >
                                <input type="file" class="form-control required" size="50" name="imageFileName"/>
                            </div>
                        </div>
                        <div class="form-group">
                          <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonUsername} *<span id="advice-required-username" style="display: none" class="errorMessage">(required)</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control required" name="username" id="username" value="${parameters.username?if_exists}" maxlength="255" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonPassword} *<span id="advice-required-username" style="display: none" class="errorMessage">(required)</span></label>
                            <div class="col-sm-6">
                                <input type="password" name="password" id="password" class="form-control required validate-password" value="" maxlength="16" />
                                <span id="advice-validate-password-password" class="errorMessage" style="display:none">${uiLabelMap["loginservices.password_may_not_equal_username"]}</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTConfirmPassword} *<span id="advice-required-username" style="display: none" class="errorMessage">(required)</span></label>
                            <div class="col-sm-6">
                                <input type="password" name="passwordVerify" id="passwordVerify" class="form-control required validate-passwordVerify" value="" maxlength="16"/>
                                <span id="advice-validate-passwordVerify-passwordVerify" class="errorMessage" style="display:none">${uiLabelMap["loginservices.password_did_not_match_verify_password"]}</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonEmail} *<span id="advice-validate-email-emailAddress" class="errorMessage" style="display:none">${uiLabelMap.PartyEmailAddressNotFormattedCorrectly}</span></label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control required validate-email" name="emailAddress" id="emailAddress" value="${parameters.emailAddress?if_exists}" maxlength="255"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyAddressLine1} *<span id="advice-required-shipToAddress1" style="display: none" class="errorMessage">(required)</span></label>
                            <div class="col-sm-6">
                                <input type="text" name="shipToAddress1" id="shipToAddress1" class="form-control required" value="${parameters.shipToAddress1?if_exists}"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyAddressLine2}</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" name="shipToAddress2" id="shipToAddress2" value="${parameters.shipToAddress2?if_exists}"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonCity} *<span id="advice-required-shipToCity" style="display: none" class="errorMessage">(required)</span></label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control required" name="shipToCity" id="shipToCity" value="${parameters.shipToCity?if_exists}" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PartyZipCode} *<span id="advice-required-shipToPostalCode" style="display: none" class="errorMessage">(required)</span></label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control required" name="shipToPostalCode" id="shipToPostalCode" value="${parameters.shipToPostalCode?if_exists}" maxlength="10" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonCountry}</label>
                            <div class="col-sm-6">
                                <select name="shipToCountryGeoId" id="newuserform_countryGeoId" class="form-control">
                                    ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                                    <#assign defaultCountryGeoId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "country.geo.id.default", delegator)>
                                    <option selected="selected" value="${defaultCountryGeoId}">
                                    <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
                                    ${countryGeo.get("geoName",locale)}
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
                                    <td><input type="text" class="form-control" name="SUPPLIER_HOME_COUNTRY" size="5" value="${requestParameters.SUPPLIER_HOME_COUNTRY?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_HOME_AREA" size="5" value="${requestParameters.SUPPLIER_HOME_AREA?if_exists}" /></td>
                                    <td><input type="text" class="form-control" ame="SUPPLIER_HOME_CONTACT" value="${requestParameters.SUPPLIER_HOME_CONTACT?if_exists}" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">${uiLabelMap.PartyBusinessPhone}</th>
                                    <td><input type="text" class="form-control" name="SUPPLIER_WORK_COUNTRY" size="5" value="${requestParameters.SUPPLIER_WORK_COUNTRY?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_WORK_AREA" size="5" value="${requestParameters.SUPPLIER_WORK_AREA?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_WORK_CONTACT" value="${requestParameters.SUPPLIER_WORK_CONTACT?if_exists}" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">${uiLabelMap.PartyFaxNumber}</th>
                                    <td><input type="text" class="form-control" name="SUPPLIER_FAX_COUNTRY" size="5" value="${requestParameters.SUPPLIER_FAX_COUNTRY?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_FAX_AREA" size="5" value="${requestParameters.SUPPLIER_FAX_AREA?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_FAX_CONTACT" value="${requestParameters.SUPPLIER_FAX_CONTACT?if_exists}" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">${uiLabelMap.PartyMobilePhone}</th>
                                    <td><input type="text" class="form-control" name="SUPPLIER_MOBILE_COUNTRY" size="5" value="${requestParameters.SUPPLIER_MOBILE_COUNTRY?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_MOBILE_AREA" size="5" value="${requestParameters.SUPPLIER_MOBILE_AREA?if_exists}" /></td>
                                    <td><input type="text" class="form-control" name="SUPPLIER_MOBILE_CONTACT" value="${requestParameters.SUPPLIER_MOBILE_CONTACT?if_exists}" /></td>
                                </tr>
                            </tbody>
                        </table>
                        <a id="submitnewuserform" href="javascript:$('#newuserform').submit()" class="btn btn-main" style="color:black;">${uiLabelMap.CommonSubmit}</a>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-sm-4">
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h3>Sign in with Social Media</h3>
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
                        <div class="signInWrapper">
                            <div class="fb-login-button" data-max-rows="1" data-size="medium" data-button-type="login_with" login-text="Sign up with Facebook" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false" scope="public_profile,email" onlogin="checkLoginFacebook();"></div>
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
    <input id="roleTypeId" type="hidden" name="roleTypeId" value="SUPPLIER">
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
    <input id="roleTypeId" type="hidden" name="roleTypeId" value="SUPPLIER">
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
