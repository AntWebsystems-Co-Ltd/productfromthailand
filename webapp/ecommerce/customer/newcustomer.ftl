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
  function hideShowUsaStates() {
    var customerStateElement = document.getElementById('newuserform_stateProvinceGeoId');
    var customerCountryElement = document.getElementById('newuserform_countryGeoId');
    if (customerCountryElement.value == "USA" || customerCountryElement.value == "UMI") {
      customerStateElement.style.display = "block";
    } else {
      customerStateElement.style.display = "none";
    }
  }
</script>
</#if>

<#------------------------------------------------------------------------------
NOTE: all page headings should start with an h2 tag, not an H1 tag, as 
there should generally always only be one h1 tag on the page and that 
will generally always be reserved for the logo at the top of the page.
------------------------------------------------------------------------------->

<h2>${uiLabelMap.PartyRequestNewAccount}
  <span>
    ${uiLabelMap.PartyAlreadyHaveAccount}, <a href='<@ofbizUrl>checkLogin/main</@ofbizUrl>'>${uiLabelMap.CommonLoginHere}</a>
  </span>
</h2>

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

<form method="post" action="<@ofbizUrl>createcustomer${previousParams}</@ofbizUrl>" id="newuserform" name="newuserform">
  
  
  <#----------------------------------------------------------------------
  If you need to include a brief explanation of the form, or certain 
  elements in the form (such as explaining asterisks denote REQUIRED),
  then you should use a <p></p> tag with a class name of "desc"
  ----------------------------------------------------------------------->

  <h1>${uiLabelMap.CommonFieldsMarkedAreRequired}</h1>

  <#----------------------------------------------------------------------
  There are two types of fieldsets, regular (full width) fielsets, and
  column (half width) fieldsets. If you want to group two sets of inputs
  side by side in two columns, give each fieldset a class name of "col"
  ----------------------------------------------------------------------->

  <fieldset class="col">
    <legend>${uiLabelMap.PartyFullName}</legend>
    <input type="hidden" name="emailProductStoreId" value="${productStoreId}"/>
    <#----------------------------------------------------------------------
    Each input row should be enclosed in a <div></div>. 
    This will ensure than each input field clears the one
    above it. Alternately, if you want several inputs to float next to
    each other, you can enclose them in a table as illustrated below for
    the phone numbers, or you can enclose each label/input pair in a span

    Example:
    <div>
      <span>
        <input type="text" name="expMonth" value=""/>
        <label for="expMonth">Exp. Month</label>
      </span>
      <span>
        <input type="text" name="expYear" value=""/>
        <label for="expYear">Exp. Year</label>
      </span>
    </div>
    ----------------------------------------------------------------------->
    <div>
      <label for="USER_TITLE">${uiLabelMap.CommonTitle}</label>
      <@fieldErrors fieldName="USER_TITLE"/>
      <select name="USER_TITLE" id="USER_TITLE">
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

    <div>
      <@fieldErrors fieldName="USER_FIRST_NAME"/>
      <label for="USER_FIRST_NAME">${uiLabelMap.PartyFirstName}*</label>
      <input type="text" name="USER_FIRST_NAME" id="USER_FIRST_NAME" value="${requestParameters.USER_FIRST_NAME?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="USER_MIDDLE_NAME"/>
      <label for="USER_MIDDLE_NAME">${uiLabelMap.PartyMiddleInitial}</label>
      <input type="text" name="USER_MIDDLE_NAME" id="USER_MIDDLE_NAME" value="${requestParameters.USER_MIDDLE_NAME?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="USER_LAST_NAME"/>
      <label for="USER_LAST_NAME">${uiLabelMap.PartyLastName}*</label>
      <input type="text" name="USER_LAST_NAME" id="USER_LAST_NAME" value="${requestParameters.USER_LAST_NAME?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="USER_SUFFIX"/>
      <label for="USER_SUFFIX">${uiLabelMap.PartySuffix}</label>
      <input type="text" class='inputBox' name="USER_SUFFIX" id="USER_SUFFIX" value="${requestParameters.USER_SUFFIX?if_exists}" />
    </div>

  </fieldset>

  <fieldset class="col">
    <legend>${uiLabelMap.PartyShippingAddress}</legend>
    <div>
      <@fieldErrors fieldName="CUSTOMER_ADDRESS1"/>
      <label for="CUSTOMER_ADDRESS1">${uiLabelMap.PartyAddressLine1}*</label>
      <input type="text" name="CUSTOMER_ADDRESS1" id="CUSTOMER_ADDRESS1" value="${requestParameters.CUSTOMER_ADDRESS1?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="CUSTOMER_ADDRESS2"/>
      <label for="CUSTOMER_ADDRESS2">${uiLabelMap.PartyAddressLine2}</label>
      <input type="text" name="CUSTOMER_ADDRESS2" id="CUSTOMER_ADDRESS2" value="${requestParameters.CUSTOMER_ADDRESS2?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="CUSTOMER_CITY"/>
      <label for="CUSTOMER_CITY">${uiLabelMap.PartyCity}*</label>
      <input type="text" name="CUSTOMER_CITY" id="CUSTOMER_CITY" value="${requestParameters.CUSTOMER_CITY?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="CUSTOMER_POSTAL_CODE"/>
      <label for="CUSTOMER_POSTAL_CODE">${uiLabelMap.PartyZipCode}*</label>
      <input type="text" name="CUSTOMER_POSTAL_CODE" id="CUSTOMER_POSTAL_CODE" value="${requestParameters.CUSTOMER_POSTAL_CODE?if_exists}" />
    </div>

    <div>
      <@fieldErrors fieldName="CUSTOMER_COUNTRY"/>
      <label for="customerCountry">${uiLabelMap.CommonCountry}*</label>
      <select name="CUSTOMER_COUNTRY" id="newuserform_countryGeoId">
        ${screens.render("component://common/widget/CommonScreens.xml#countries")}
        <#assign defaultCountryGeoId =
            Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general",
            "country.geo.id.default", delegator)>
        <option selected="selected" value="${defaultCountryGeoId}">
          <#assign countryGeo = delegator.findOne("Geo",Static["org.apache.ofbiz.base.util.UtilMisc"]
              .toMap("geoId",defaultCountryGeoId), false)>
          ${countryGeo.get("geoName",locale)}
        </option>
      </select>
    </div>

    <div>
      <@fieldErrors fieldName="CUSTOMER_STATE"/>
      <label for="customerState">${uiLabelMap.PartyState}*</label>
      <select name="CUSTOMER_STATE" id="newuserform_stateProvinceGeoId"></select>
    <div/>
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
          <td><input type="text" name="CUSTOMER_HOME_COUNTRY" size="5" value="${requestParameters.CUSTOMER_HOME_COUNTRY?if_exists}" /></td>
          <td><input type="text" name="CUSTOMER_HOME_AREA" size="5" value="${requestParameters.CUSTOMER_HOME_AREA?if_exists}" /></td>
          <td><input type="text" name="CUSTOMER_HOME_CONTACT" value="${requestParameters.CUSTOMER_HOME_CONTACT?if_exists}" /></td>
          <td><input type="text" name="CUSTOMER_HOME_EXT" size="6" value="${requestParameters.CUSTOMER_HOME_EXT?if_exists}"/></td>
        </tr>
        <tr>
          <th scope="row">${uiLabelMap.PartyMobilePhone}</th>
          <td><input type="text" name="CUSTOMER_MOBILE_COUNTRY" size="5" value="${requestParameters.CUSTOMER_MOBILE_COUNTRY?if_exists}" /></td>
          <td><input type="text" name="CUSTOMER_MOBILE_AREA" size="5" value="${requestParameters.CUSTOMER_MOBILE_AREA?if_exists}" /></td>
          <td><input type="text" name="CUSTOMER_MOBILE_CONTACT" value="${requestParameters.CUSTOMER_MOBILE_CONTACT?if_exists}" /></td>
          <td></td>
        </tr>
      </tbody>
    </table>
  </fieldset>

  <fieldset class="col">
    <legend>${uiLabelMap.PartyEmailAddress}</legend>
    <div>
      <@fieldErrors fieldName="CUSTOMER_EMAIL"/>
      <label for= "CUSTOMER_EMAIL">${uiLabelMap.PartyEmailAddress}*</label>
      <input type="text" name="CUSTOMER_EMAIL" id="CUSTOMER_EMAIL" value="${requestParameters.CUSTOMER_EMAIL?if_exists}" onchange="changeEmail()" onkeyup="changeEmail()" />
    </div>
  </fieldset>

  <fieldset class="col">
    <legend><#if getUsername>${uiLabelMap.CommonUsername}</#if></legend>
    <#if getUsername>
      <div class="form-row inline">
        <label for="UNUSEEMAIL" style="text-align:left;width:100%">
          <input type="checkbox" class="checkbox" name="UNUSEEMAIL" id="UNUSEEMAIL" value="on" onclick="setEmailUsername();" onfocus="setLastFocused(this);"/> ${uiLabelMap.EcommerceUseEmailAddress}
        </label>
      </div>
      <div class="bothclear"></div>
      <div>
        <@fieldErrors fieldName="USERNAME"/>
        <label for="USERNAME">${uiLabelMap.CommonUsername}*</label>
        <input type="text" name="USERNAME" id="USERNAME" value="${requestParameters.USERNAME?if_exists}" onfocus="clickUsername();" onchange="changeEmail();"/>
      </div>
    </#if>
  </fieldset>

  <fieldset class="col">
    <legend>${uiLabelMap.CommonPassword}</legend>
    <#if createAllowPassword>
      <div>
        <@fieldErrors fieldName="PASSWORD"/>
        <label for="PASSWORD">${uiLabelMap.CommonPassword}*</label>
        <input type="password" name="PASSWORD" id="PASSWORD" onfocus="setLastFocused(this);"/>
      </div>

      <div>
        <@fieldErrors fieldName="CONFIRM_PASSWORD"/>
        <label for="CONFIRM_PASSWORD">${uiLabelMap.PartyRepeatPassword}*</label>
        <input type="password" class='inputBox' name="CONFIRM_PASSWORD" id="CONFIRM_PASSWORD" value="" maxlength="50"/>
      </div>
    <#else/>
      <div>
        <label>${uiLabelMap.PartyReceivePasswordByEmail}.</label>
      </div>
    </#if>
  </fieldset>
</form>

<#------------------------------------------------------------------------------
To create a consistent look and feel for all buttons, input[type=submit], 
and a tags acting as submit buttons, all button actions should have a 
class name of "button". No other class names should be used to style 
button actions.
------------------------------------------------------------------------------->
<div class="newuserbutton">
  <div class="floatleft"><a href="javascript:$('#newuserform').submit()">${uiLabelMap.CommonSave}</a></div>
  <div class="floatright"><a href="<@ofbizUrl>checkLogin/main</@ofbizUrl>" class="reset">${uiLabelMap.CommonBack}</a></div>
</div>

<script type="text/javascript">
  //<![CDATA[
      hideShowUsaStates();
  //]]>
</script>