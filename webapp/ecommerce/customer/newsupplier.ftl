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
            $("#idRegisNoTitle").hide();
            $("#idRegisNo").hide();
            $("#uploadIdRegisNoTitle").hide();
            $("#idNoPassportNoTitle").show();
            $("#idNoPassportNo").show();
            $("#uploadIdNoScanTitle").show();
        }
        if ($("input[name=supplierType]:checked").val() == "SUPP_COMPANY") {
            $("#idNoPassportNoTitle").hide();
            $("#idNoPassportNo").hide();
            $("#uploadIdNoScanTitle").hide();
            $("#idRegisNoTitle").show();
            $("#idRegisNo").show();
            $("#uploadIdRegisNoTitle").show();
        }
        $("input[name=supplierType]").change(function(){
            supplierType = $("input[name=supplierType]:checked").val()
            if (supplierType == "SUPP_INDIVIDUAL") {
                $("#idRegisNoTitle").hide();
                $("#idRegisNo").hide();
                $("#newsupplier_businessRegistNo").val("");
                $("#uploadIdRegisNoTitle").hide();

                $("#idNoPassportNoTitle").show();
                $("#idNoPassportNo").show();
                $("#uploadIdNoScanTitle").show();
            } else {
                $("#idNoPassportNoTitle").hide();
                $("#idNoPassportNo").hide();
                $("#newsupplier_idCardNo").val("");
                $("#uploadIdNoScanTitle").hide();

                $("#idRegisNoTitle").show();
                $("#idRegisNo").show();
                $("#uploadIdRegisNoTitle").show();
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

<h2>${uiLabelMap.PageTitleNewSupplier}</h2>
<div class="manualRegister">
    <form id="newuserform" name="newuserform" method="post" action="createsupplier" enctype="multipart/form-data">
      <fieldset class="col">
                <legend>${uiLabelMap.PartyPersonalInformation}</legend>
        <input type="hidden" name="roleTypeId" value="SUPPLIER" />
        <input type="hidden" name="emailContactMechPurposeTypeId" value="PRIMARY_EMAIL" />
        <input type="hidden" name="partyContentTypeId" value="INTERNAL" />
        <#assign productStoreId = Static["org.apache.ofbiz.product.store.ProductStoreWorker"].getProductStoreId(request) />
        <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}" />
        <table class="basic-table" cellspacing="0" width="90%">
            <tr>
                <td valign="middle" class="newsupplier" width="30%">${uiLabelMap.PFTTitleSupplierType}</td>
                <td width="1%"> : </td>
                <td width="60%">
                    <ul>
                        <li>
                            <input type="radio" name="supplierType" value="SUPP_INDIVIDUAL" checked="checked"/>${uiLabelMap.PFTSupplierTypeIndividual}
                        </li>
                        <li>
                            <input type="radio" name="supplierType" value="SUPP_COMPANY"/>${uiLabelMap.PFTSupplierTypeCompany}
                        </li>
                    </ul>
                </td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PFTSupplierName}</td>
                <td> : </td>
                <td><input type="text" name="groupName" id="groupName" class="required" value="${parameters.groupName?if_exists}" maxlength="30"/> *</td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier" id="idNoPassportNoTitle">${uiLabelMap.PFTTitleIdNoIdPassport}</td>
                <td valign="middle" class="newsupplier" id="idRegisNoTitle">${uiLabelMap.PFTTitleIdBizRegisterNo}</td>
                <td> : </td>
                <td id="idNoPassportNo"><input type="text" name="idCardNo" id="newsupplier_idCardNo" class="required" value="${parameters.idCardNo?if_exists}" maxlength="30"/> *</td>
                <td id="idRegisNo"><input type="text" name="businessRegistNo" id="newsupplier_businessRegistNo" class="required" value="${parameters.businessRegistNo?if_exists}" maxlength="30"/> *</td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier" id="uploadIdNoScanTitle">${uiLabelMap.PFTTitleUploadIdScan}</td>
                <td valign="middle" class="newsupplier" id="uploadIdRegisNoTitle">${uiLabelMap.PFTTitleUploadBizRegisterNo}</td>
                <td> : </td>
                <td width="20%" align="right" valign="top">
                    <input type="file" size="50" name="imageFileName" class="required"/> *
                </td>
            </tr>
        </table>
      </fieldset>
      <fieldset  class="col">
          <legend>${uiLabelMap.PFTAccountInformation}</legend>
          <table class="basic-table" cellspacing="0" width="90%">
            <tr>
                <td valign="middle" class="newsupplier" width="30%">${uiLabelMap.CommonUsername}<span id="advice-required-username" style="display: none" class="errorMessage">(required)</span></td>
                <td width="1%"> : </td>
                <td width="60%"><input type="text" name="username" id="username" class="required" value="${parameters.username?if_exists}" maxlength="255" /> *</td>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.CommonPassword}<span id="advice-required-username" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="password" name="password" id="password" class="required validate-password" value="" maxlength="16" /> *</td>
                <span id="advice-validate-password-password" class="errorMessage" style="display:none">${uiLabelMap["loginservices.password_may_not_equal_username"]}</span>
            </tr>
            <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PFTConfirmPassword}<span id="advice-required-username" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="password" name="passwordVerify" id="passwordVerify" class="required validate-passwordVerify" value="" maxlength="16" /> *</td>
                <span id="advice-validate-passwordVerify-passwordVerify" class="errorMessage" style="display:none">${uiLabelMap["loginservices.password_did_not_match_verify_password"]}</span>
            </tr>
          </table>
      </fieldset>
       <fieldset class="col">
          <legend>${uiLabelMap.PartyContactInformation}</legend>
          <table class="basic-table" cellspacing="0" width="90%">
              <tr>
                <td valign="middle" class="newsupplier" width="30%">${uiLabelMap.CommonEmail}<span id="advice-validate-email-emailAddress" class="errorMessage" style="display:none">${uiLabelMap.PartyEmailAddressNotFormattedCorrectly}</span></td>
                <td width="1%"> : </td>
                <td width="60%"><input type="text" class="required validate-email" name="emailAddress" id="emailAddress" value="${parameters.emailAddress?if_exists}" maxlength="255" /> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyAddressLine1}<span id="advice-required-shipToAddress1" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="text" name="shipToAddress1" id="shipToAddress1" class="required" value="${parameters.shipToAddress1?if_exists}" /> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyAddressLine2}</td>
                <td> : </td>
                <td><input type="text" name="shipToAddress2" id="shipToAddress2" value="${parameters.shipToAddress2?if_exists}" /></td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.CommonCity}<span id="advice-required-shipToCity" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="text" name="shipToCity" id="shipToCity" class="required" value="${parameters.shipToCity?if_exists}" /> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyZipCode}<span id="advice-required-shipToPostalCode" style="display: none" class="errorMessage">(required)</span></td>
                <td> : </td>
                <td><input type="text" name="shipToPostalCode" id="shipToPostalCode" class="required" value="${parameters.shipToPostalCode?if_exists}" maxlength="10" /> *</td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.CommonCountry}</td>
                <td width="1%"> : </td>
                <td><select name="shipToCountryGeoId" id="newuserform_countryGeoId">
                  ${screens.render("component://common/widget/CommonScreens.xml#countries")}
                  <#assign defaultCountryGeoId =
                      Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general",
                      "country.geo.id.default", delegator)>
                  <option selected="selected" value="${defaultCountryGeoId}">
                    <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"]
                        .toMap("geoId",defaultCountryGeoId), false)>
                    ${countryGeo.get("geoName",locale)}
                  </option>
                </select></td>
              </tr>
              <tr>
                <td valign="middle" class="newsupplier">${uiLabelMap.PartyState}</td>
                <td width="1%"> : </td>
                <td><select name="shipToStateProvinceGeoId" id="newuserform_stateProvinceGeoId"></select></td>
              </tr>
          </table>
      </fieldset>
      <fieldset>
        <legend>${uiLabelMap.PartyPhoneNumbers}</legend>
        <table summary="Tabular form for entering multiple telecom numbers for different purposes. Each row allows user to enter telecom number for a purpose">
          <thead>
            <tr>
              <th></th>
              <th scope="col">${uiLabelMap.CommonCountryCode}</th>
              <th scope="col">${uiLabelMap.PartyAreaCode}</th>
              <th scope="col">${uiLabelMap.PartyContactNumber}</th>
              <th scope="col">${uiLabelMap.PartyExtension}</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">${uiLabelMap.PartyHomePhone}</th>
              <td><input type="text" name="SUPPLIER_HOME_COUNTRY" size="5" value="${requestParameters.SUPPLIER_HOME_COUNTRY?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_HOME_AREA" size="5" value="${requestParameters.SUPPLIER_HOME_AREA?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_HOME_CONTACT" value="${requestParameters.SUPPLIER_HOME_CONTACT?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_HOME_EXT" size="6" value="${requestParameters.SUPPLIER_HOME_EXT?if_exists}"/></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyBusinessPhone}</th>
              <td><input type="text" name="SUPPLIER_WORK_COUNTRY" size="5" value="${requestParameters.SUPPLIER_WORK_COUNTRY?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_WORK_AREA" size="5" value="${requestParameters.SUPPLIER_WORK_AREA?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_WORK_CONTACT" value="${requestParameters.SUPPLIER_WORK_CONTACT?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_WORK_EXT" size="6" value="${requestParameters.SUPPLIER_WORK_EXT?if_exists}" /></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyFaxNumber}</th>
              <td><input type="text" name="SUPPLIER_FAX_COUNTRY" size="5" value="${requestParameters.SUPPLIER_FAX_COUNTRY?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_FAX_AREA" size="5" value="${requestParameters.SUPPLIER_FAX_AREA?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_FAX_CONTACT" value="${requestParameters.SUPPLIER_FAX_CONTACT?if_exists}" /></td>
              <td></td>
            </tr>
            <tr>
              <th scope="row">${uiLabelMap.PartyMobilePhone}</th>
              <td><input type="text" name="SUPPLIER_MOBILE_COUNTRY" size="5" value="${requestParameters.SUPPLIER_MOBILE_COUNTRY?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_MOBILE_AREA" size="5" value="${requestParameters.SUPPLIER_MOBILE_AREA?if_exists}" /></td>
              <td><input type="text" name="SUPPLIER_MOBILE_CONTACT" value="${requestParameters.SUPPLIER_MOBILE_CONTACT?if_exists}" /></td>
              <td></td>
            </tr>
          </tbody>
        </table>
      </fieldset>
        <div style="margin-left:300px;"><a id="submitnewuserform" href="javascript:$('#newuserform').submit()" class="button" style="color:black;">${uiLabelMap.CommonSubmit}</a></div>
    </form>
    <script type="text/javascript">
      //<![CDATA[
          hideShowUsaStates();
      //]]>
    </script>
</div>
<div class="separatorSignup">
    <span class="or">${uiLabelMap.CommonOr}</span>
    <span class="line"></span>
</div>
<div class="thirdPartyRegister">
    <div class="login-application">
        <ul>
            <li class="application">
                <#if googleClientId?has_content>
                <div id="googleBtn" class="customGPlusSignIn">
                  <span class="googleIcon"></span>
                  <span class="googleButtonText">Sign up with Google</span>
                </div>
                <script>startApp();</script>
                </#if>
                <#if facebookAppId?has_content>
                <div class="signInWrapper">
                    <div class="fb-login-button" data-max-rows="1" data-size="medium" data-button-type="login_with" login-text="Sign up with Facebook" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false" scope="public_profile,email" onlogin="checkLoginFacebook();"></div>
                </div>
                </#if>
            </li>
        </ul>
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
