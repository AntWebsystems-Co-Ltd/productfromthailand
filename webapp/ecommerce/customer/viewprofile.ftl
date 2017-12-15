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

<#if party?exists>
<#-- Main Heading -->
<div id="main-container" class="container">
	<div class="row">
    <!-- Store Management Menu Start -->
    <div class="col-sm-3">
      <h3 class="side-heading">${uiLabelMap.PFTMyAccountMenu}</h3>
      <div class="list-group">
          <a href="<@ofbizUrl>viewprofile</@ofbizUrl> " class="list-group-item selected">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.PFTMyProfile}
          </a>
          <a href="<@ofbizUrl>myOrderlist</@ofbizUrl>" class="list-group-item">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.PFTMyOrder}
          </a>
      </div>
    </div>
    <div class="col-sm-9">
  <div class="panel panel-smart">
    <div class="panel-heading navbar">
      <#if person?exists>
        <h3>${uiLabelMap.PartyPersonalInformation}<a href="<@ofbizUrl>editperson</@ofbizUrl>" style="float: right;"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a></h3>
      <#else>
        <h3>${uiLabelMap.PartyPartyGroupInformation}<a href="<@ofbizUrl>editpartygroup</@ofbizUrl>" style="float: right;"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a></h3>
      </#if>
    </div>
    <div class="panel-body">
      <#if person?exists || partyGroup?exists>
      <dl class="dl-horizontal" id="partyinformation">
        <#if person?exists>
          <dt>${uiLabelMap.PartyName} :</dt>
          <dd>
            ${person.personalTitle?if_exists}
            ${person.firstName?if_exists}
            ${person.middleName?if_exists}
            ${person.lastName?if_exists}
            ${person.suffix?if_exists}
          </dd>
          <#if idNo?exists>
            <dt>${uiLabelMap.PFTTitleIdNoIdPassport} :</dt>
            <dd>${idNo.idValue?if_exists}</dd>
          </#if>
        <#elseif partyGroup?exists>
          <dt>${uiLabelMap.PartyName} :</dt>
          <dd>${partyGroup.groupName?if_exists}</dd>
          <#if regisNo?exists>
            <dt>${uiLabelMap.PFTTitleIdBizRegisterNo} :</dt>
            <dd>${regisNo.idValue?if_exists}</dd>
          </#if>
        </#if>
        <#if partyGroup?exists>
          <#if partyGroup.groupNameLocal?exists>
            <dt>${uiLabelMap.FormFieldTitle_groupNameLocal} :</dt>
            <dd>${partyGroup.groupNameLocal}</dd>
          </#if>
          <#if partyGroup.officeSiteName?exists>
            <dt>${uiLabelMap.FormFieldTitle_officeSiteName} :</dt>
              <dd>${partyGroup.officeSiteName}</dd>
          </#if>
          <#if partyGroup.comments?exists>
            <dt>${uiLabelMap.PartyComments} :</dt>
              <dd>${partyGroup.comments}</dd>
          </#if>
        </#if>
        <#if person?exists>
          <#if person.nickname?has_content>
            <dt>${uiLabelMap.PartyNickName} :</dt>
              <dd>${person.nickname}</dd>
          </#if>
          <#if person.gender?has_content>
            <dt>${uiLabelMap.PartyGender} :</dt>
              <dd>${person.gender}</dd>
          </#if>
          <#if person.birthDate?has_content>
            <dt>${uiLabelMap.PartyBirthDate} :</dt>
              <dd>${person.birthDate}</dd>
          </#if>
          <#if person.height?has_content>
            <dt>${uiLabelMap.PartyHeight} :</dt>
              <dd>${person.height}</dd>
          </#if>
          <#if person.mothersMaidenName?has_content>
            <dt>${uiLabelMap.PartyMaidenName} :</dt>
              <dd>${person.mothersMaidenName}</dd>
          </#if>
          <#if person.maritalStatus?has_content>
            <dt>${uiLabelMap.PartyMaritalStatus} :</dt>
              <dd>${person.maritalStatus}</dd>
          </#if>
          <#if person.socialSecurityNumber?has_content>
            <dt>${uiLabelMap.PartySocialSecurityNumber} :</dt>
              <dd>${person.socialSecurityNumber}</dd>
          </#if>
          <#if person.passportNumber?has_content>
            <dt>${uiLabelMap.PartyPassportNumber} :</dt>
              <dd>${person.passportNumber}</dd>
          </#if>
          <#if person.passportExpireDate?has_content>
            <dt>${uiLabelMap.PartyPassportExpireDate} :</dt>
              <dd>${person.passportExpireDate.toString()}</dd>
          </#if>
          <#if person.passportNumber?has_content>
            <dt>${uiLabelMap.PartyPassportNumber} :</dt>
              <dd>${person.passportNumber}</dd>
          </#if>
          <#if person.totalYearsWorkExperience?has_content>
            <dt>${uiLabelMap.PartyYearsWork} :</dt>
              <dd>${person.totalYearsWorkExperience}</dd>
          </#if>
          <#if person.comments?has_content>
            <dt>${uiLabelMap.CommonComments} :</dt>
              <dd>${person.comments}</dd>
          </#if>
        </#if>
      <#else>
        <label>${uiLabelMap.PartyPersonalInformationNotFound}</label>
      </#if>
      </dl>
      </div>
    </div>
    <#-- ============================================================= -->
    <#if person?exists>
      <#-- <div class="panel panel-smart">
        <div class="panel-heading navbar">
          <h3>${uiLabelMap.OrderSalesHistory}</h3>
        </div>
        <div class="panel-body table-responsive shopping-cart-table">
          <table class="table">
            <thead>
              <tr>
                <th>${uiLabelMap.CommonDate}</th>
                <th>${uiLabelMap.OrderOrder} ${uiLabelMap.CommonNbr}</th>
                <th>${uiLabelMap.CommonAmount}</th>
                <th>${uiLabelMap.CommonStatus}</th>
                <th>${uiLabelMap.OrderInvoices}</th>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <#if orderHeaderList?has_content>
                <#list orderHeaderList as orderHeader>
                  <#assign status = orderHeader.getRelatedOne("StatusItem", true) />
                  <#assign rateResult = dispatcher.runSync("getFXConversion", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("uomId", orderHeader.currencyUom, "uomIdTo", currencyUom, "userLogin", userLogin?default(defaultUserLogin)))/>
                  <#assign conversionRate = rateResult.conversionRate>
                  <tr>
                    <td>${orderHeader.orderDate.toString()}</td>
                    <td>${orderHeader.orderId}</td>
                    <td><@ofbizCurrency amount=orderHeader.grandTotal*conversionRate isoCode=currencyUom /></td>
                    <td>${status.get("description",locale)}</td>  -->
                    <#-- invoices -->
                    <#-- <#assign invoices = delegator.findByAnd("OrderItemBilling", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("orderId", "${orderHeader.orderId}"), Static["org.apache.ofbiz.base.util.UtilMisc"].toList("invoiceId"), false) />
                    <#assign distinctInvoiceIds = Static["org.apache.ofbiz.entity.util.EntityUtil"].getFieldListFromEntityList(invoices, "invoiceId", true)>
                    <#if distinctInvoiceIds?has_content>
                      <td>
                        <#list distinctInvoiceIds as invoiceId>
                           <a href="<@ofbizUrl>invoice.pdf?invoiceId=${invoiceId}</@ofbizUrl>" class="buttontext">(${invoiceId} PDF) </a>
                        </#list>
                      </td>
                    <#else>
                      <td></td>
                    </#if>
                    <td><a href="<@ofbizUrl>orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonView} ${status}</a></td>
                  </tr>
                </#list>
              <#else>
                <tr><td colspan="6">${uiLabelMap.OrderNoOrderFound}</td></tr>
              </#if>
            </tbody>
          </table>
        </div>
      </div>  -->

      <#-- ============================================================= -->
      <#if monthsToInclude?exists && totalSubRemainingAmount?exists && totalOrders?exists>
        <div class="panel panel-smart">
          <div class="panel-heading navbar">
            <h3>${uiLabelMap.EcommerceLoyaltyPoints}</h3>
          </div>
          <div class="panel-body">
            <label>${uiLabelMap.EcommerceYouHave} ${totalSubRemainingAmount} ${uiLabelMap.EcommercePointsFrom} ${totalOrders} ${uiLabelMap.EcommerceOrderInLast} ${monthsToInclude} ${uiLabelMap.EcommerceMonths}</label>
          </div>
        </div>
      </#if>
    </#if>
    <#-- ============================================================= -->
    <div class="panel panel-smart">
      <div class="panel-heading navbar">
        <h3>${uiLabelMap.PartyContactInformation}<a href="<@ofbizUrl>editcontactmech</@ofbizUrl>" style="float: right;"><i class="fa fa-plus" aria-hidden="true"></i></a></h3>
      </div>
      <div class="panel-body table-responsive shopping-cart-table">
        <#if partyContactMechValueMaps?has_content>
          <table class="table">
            <thead>
            <tr>
              <th class="text-center">${uiLabelMap.PartyContactType}</th>
              <th></th>
              <th class="text-center">${uiLabelMap.CommonInformation}</th>
              <th colspan="2" class="text-center">${uiLabelMap.PartySolicitingOk}?</th>
              <th colspan="2"></th>
            </tr>
            <#assign listcount=0>
            <#list partyContactMechValueMaps as partyContactMechValueMap>
              <#assign contactMech = partyContactMechValueMap.contactMech?if_exists />
              <#assign contactMechType = partyContactMechValueMap.contactMechType?if_exists />
              <#assign partyContactMech = partyContactMechValueMap.partyContactMech?if_exists />
              <tr>
                <td align="right" valign="top" class="text-center">
                  ${contactMechType.get("description",locale)}
                </td>
                <td>&nbsp;</td>
                <td valign="top">
                  <#list partyContactMechValueMap.partyContactMechPurposes! as partyContactMechPurpose>
                    <#assign contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true) />
                    <div class="tabletext">
                      <#if contactMechPurposeType?exists>
                        ${contactMechPurposeType.get("description",locale)}
                        <#if contactMechPurposeType.contactMechPurposeTypeId == "SHIPPING_LOCATION" && (profiledefs.defaultShipAddr)?default("") == contactMech.contactMechId>
                          <span class="buttontextdisabled">${uiLabelMap.EcommerceIsDefault}</span>
                        <#elseif contactMechPurposeType.contactMechPurposeTypeId == "SHIPPING_LOCATION">
                          <form name="defaultShippingAddressForm" method="post" action="<@ofbizUrl>setprofiledefault/viewprofile</@ofbizUrl>">
                            <input type="hidden" name="productStoreId" value="${productStoreId}" />
                            <input type="hidden" name="defaultShipAddr" value="${contactMech.contactMechId}" />
                            <input type="hidden" name="partyId" value="${party.partyId}" />
                            <input type="submit" value="${uiLabelMap.EcommerceSetDefault}" class="btn btn-main text-uppercase" />
                          </form>
                        </#if>
                      <#else>
                        ${uiLabelMap.PartyPurposeTypeNotFound}: "${partyContactMechPurpose.contactMechPurposeTypeId}"
                      </#if>
                      <#if partyContactMechPurpose.thruDate?exists>(${uiLabelMap.CommonExpire}:${partyContactMechPurpose.thruDate.toString()})</#if>
                    </div>
                  </#list>
                  <#if contactMech.contactMechTypeId?if_exists = "POSTAL_ADDRESS">
                    <#assign postalAddress = partyContactMechValueMap.postalAddress?if_exists />
                    <div class="tabletext">
                      <#if postalAddress?exists>
                        <#if postalAddress.toName?has_content>${uiLabelMap.CommonTo}: ${postalAddress.toName}<br/></#if>
                        <#if postalAddress.attnName?has_content>${uiLabelMap.PartyAddrAttnName}: ${postalAddress.attnName}<br/></#if>
                        ${postalAddress.address1}<br/>
                        <#if postalAddress.address2?has_content>${postalAddress.address2}<br/></#if>
                        ${postalAddress.city}<#if postalAddress.stateProvinceGeoId?has_content>,&nbsp;${postalAddress.stateProvinceGeoId}</#if>&nbsp;${postalAddress.postalCode?if_exists}
                        <#if postalAddress.countryGeoId?has_content><br/>${postalAddress.countryGeoId}</#if>
                        <#if (!postalAddress.countryGeoId?has_content || postalAddress.countryGeoId?if_exists = "USA")>
                          <#assign addr1 = postalAddress.address1?if_exists />
                          <#if (addr1.indexOf(" ") > 0)>
                            <#assign addressNum = addr1.substring(0, addr1.indexOf(" ")) />
                            <#assign addressOther = addr1.substring(addr1.indexOf(" ")+1) />
                            <a target="_blank" href="${uiLabelMap.CommonLookupWhitepagesAddressLink}" class="linktext">(${uiLabelMap.CommonLookupWhitepages})</a>
                          </#if>
                        </#if>
                      <#else>
                        ${uiLabelMap.PartyPostalInformationNotFound}.
                      </#if>
                      </div>
                  <#elseif contactMech.contactMechTypeId?if_exists = "TELECOM_NUMBER">
                    <#assign telecomNumber = partyContactMechValueMap.telecomNumber?if_exists>
                    <div class="tabletext">
                    <#if telecomNumber?exists>
                      ${telecomNumber.countryCode?if_exists}
                      <#if telecomNumber.areaCode?has_content>${telecomNumber.areaCode}-</#if>${telecomNumber.contactNumber?if_exists}
                      <#if partyContactMech.extension?has_content>ext&nbsp;${partyContactMech.extension}</#if>
                      <#if (!telecomNumber.countryCode?has_content || telecomNumber.countryCode = "011")>
                        <a target="_blank" href="${uiLabelMap.CommonLookupAnywhoLink}" class="linktext">${uiLabelMap.CommonLookupAnywho}</a>
                        <a target="_blank" href="${uiLabelMap.CommonLookupWhitepagesTelNumberLink}" class="linktext">${uiLabelMap.CommonLookupWhitepages}</a>
                      </#if>
                    <#else>
                      ${uiLabelMap.PartyPhoneNumberInfoNotFound}.
                    </#if>
                    </div>
                  <#elseif contactMech.contactMechTypeId?if_exists = "EMAIL_ADDRESS">
                      ${contactMech.infoString}
                      <a href="mailto:${contactMech.infoString}" class="linktext">(${uiLabelMap.PartySendEmail})</a>
                  <#elseif contactMech.contactMechTypeId?if_exists = "WEB_ADDRESS">
                    <div class="tabletext">
                      ${contactMech.infoString}
                      <#assign openAddress = contactMech.infoString?if_exists />
                      <#if !openAddress.startsWith("http") && !openAddress.startsWith("HTTP")><#assign openAddress = "http://" + openAddress /></#if>
                      <a target="_blank" href="${openAddress}" class="linktext">(${uiLabelMap.CommonOpenNewWindow})</a>
                    </div>
                  <#else>
                    ${contactMech.infoString?if_exists}
                  </#if>
                  <div class="tabletext">(${uiLabelMap.CommonUpdated}:&nbsp;${partyContactMech.fromDate.toString()})</div>
                  <#if partyContactMech.thruDate?exists><div class="tabletext">${uiLabelMap.CommonDelete}:&nbsp;${partyContactMech.thruDate.toString()}</div></#if>
                </td>
                <td align="center" valign="top"><div class="tabletext">(${partyContactMech.allowSolicitation?if_exists})</div></td>
                <td>&nbsp;</td>
                <td align="right" valign="top">
                  <a href="<@ofbizUrl>editcontactmech</@ofbizUrl>?contactMechId=${contactMech.contactMechId}" style="float: right;"><i class="fa fa-pencil-square-o" aria-hidden="true"></i></a>
                </td>
                <td align="right" valign="top">
                    <form name="deleteContactMech_${listcount}" method="post" action="<@ofbizUrl>deleteContactMech</@ofbizUrl>">
                        <input type="hidden" name="contactMechId" value="${contactMech.contactMechId}"/>
                    </form>
                  <a href="javascript:document.deleteContactMech_${listcount}.submit()" style="float: right;"><i class="fa fa-trash" aria-hidden="true"></i></a>
                </td>
              </tr>
              <#assign listcount=listcount+1>
            </#list>
          </thead>
          </table>
        <#else>
          <label>${uiLabelMap.PartyNoContactInformation}.</label><br/>
        </#if>
      </div>
    </div>

    <#-- ============================================================= -->
    <#if person?exists>
      <div class="panel panel-smart">
        <div class="panel-heading navbar">
          <h3>${uiLabelMap.AccountingPaymentMethodInformation}
            <h6>
              <a href="<@ofbizUrl>editcreditcard</@ofbizUrl>" style="float: right;">${uiLabelMap.PartyCreateNewCreditCard}</a>
              <label style="float: right;">&nbsp;&nbsp;|&nbsp;&nbsp;</label>
              <a href="<@ofbizUrl>editgiftcard</@ofbizUrl>" style="float: right;">${uiLabelMap.PartyCreateNewGiftCard}</a>
              <label style="float: right;">&nbsp;&nbsp;|&nbsp;&nbsp;</label>
              <a href="<@ofbizUrl>editeftaccount</@ofbizUrl>" style="float: right;">${uiLabelMap.PartyCreateNewEftAccount}</a>
            </h6>
          </h3>
        </div>
        <div class="panel-body">
          <table width="100%" border="0" cellpadding="1">
            <tr>
              <td>
                <#if paymentMethodValueMaps?has_content>
                <table width="100%" cellpadding="2" cellspacing="0" border="0">
                  <#list paymentMethodValueMaps as paymentMethodValueMap>
                    <#assign paymentMethod = paymentMethodValueMap.paymentMethod?if_exists />
                    <#assign creditCard = paymentMethodValueMap.creditCard?if_exists />
                    <#assign giftCard = paymentMethodValueMap.giftCard?if_exists />
                    <#assign eftAccount = paymentMethodValueMap.eftAccount?if_exists />
                    <tr>
                      <#if paymentMethod.paymentMethodTypeId?if_exists == "CREDIT_CARD">
                      <td valign="top">
                        <div class="tabletext">
                          ${uiLabelMap.AccountingCreditCard}:
                          <#if creditCard.companyNameOnCard?has_content>${creditCard.companyNameOnCard}&nbsp;</#if>
                          <#if creditCard.titleOnCard?has_content>${creditCard.titleOnCard}&nbsp</#if>
                          ${creditCard.firstNameOnCard}&nbsp;
                          <#if creditCard.middleNameOnCard?has_content>${creditCard.middleNameOnCard}&nbsp</#if>
                          ${creditCard.lastNameOnCard}
                          <#if creditCard.suffixOnCard?has_content>&nbsp;${creditCard.suffixOnCard}</#if>
                          &nbsp;${Static["org.apache.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}
                          <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                          <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate.toString()})</#if>
                          <#if paymentMethod.thruDate?exists>(${uiLabelMap.CommonDelete}:&nbsp;${paymentMethod.thruDate.toString()})</#if>
                        </div>
                      </td>
                      <td>&nbsp;</td>
                      <td align="right" valign="top">
                        <a href="<@ofbizUrl>editcreditcard?paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="btn btn-main">
                                  ${uiLabelMap.CommonUpdate}</a>
                      </td>
                      <#elseif paymentMethod.paymentMethodTypeId?if_exists == "GIFT_CARD">
                        <#if giftCard?has_content && giftCard.cardNumber?has_content>
                          <#assign giftCardNumber = "" />
                          <#assign pcardNumber = giftCard.cardNumber />
                          <#if pcardNumber?has_content>
                            <#assign psize = pcardNumber?length - 4 />
                            <#if (0 < psize)>
                              <#list 0 .. psize-1 as foo>
                                <#assign giftCardNumber = giftCardNumber + "*" />
                              </#list>
                               <#assign giftCardNumber = giftCardNumber + pcardNumber[psize .. psize + 3] />
                            <#else>
                               <#assign giftCardNumber = pcardNumber />
                            </#if>
                          </#if>
                        </#if>

                        <td valign="top">
                          <div class="tabletext">
                            ${uiLabelMap.AccountingGiftCard}: ${giftCardNumber}
                            <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                            <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate.toString()})</#if>
                            <#if paymentMethod.thruDate?exists>(${uiLabelMap.CommonDelete}:&nbsp;${paymentMethod.thruDate.toString()})</#if>
                          </div>
                        </td>
                        <td >&nbsp;</td>
                        <td align="right" valign="top">
                          <a href="<@ofbizUrl>editgiftcard?paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="btn btn-main">
                                  ${uiLabelMap.CommonUpdate}</a>
                        </td>
                        <#elseif paymentMethod.paymentMethodTypeId?if_exists == "EFT_ACCOUNT">
                        <td valign="top">
                          <div class="tabletext">
                            ${uiLabelMap.AccountingEFTAccount}: ${eftAccount.nameOnAccount?if_exists} - <#if eftAccount.bankName?has_content>${uiLabelMap.AccountingBank}: ${eftAccount.bankName}</#if> <#if eftAccount.accountNumber?has_content>${uiLabelMap.AccountingAccount} #: ${eftAccount.accountNumber}</#if>
                            <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                            <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate.toString()})</#if>
                            <#if paymentMethod.thruDate?exists>(${uiLabelMap.CommonDelete}:&nbsp;${paymentMethod.thruDate.toString()})</#if>
                          </div>
                        </td>
                        <td>&nbsp;</td>
                        <td align="right" valign="top">
                          <a href="<@ofbizUrl>editeftaccount?paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="btn btn-main">
                                  ${uiLabelMap.CommonUpdate}</a>
                        </td>
                      </#if>
                      <td align="right" valign="top">
                       <a href="<@ofbizUrl>deletePaymentMethod/viewprofile?paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="btn btn-main">
                              ${uiLabelMap.CommonExpire}</a>
                      </td>
                      <td align="right" valign="top">
                        <#if (profiledefs.defaultPayMeth)?default("") == paymentMethod.paymentMethodId>
                          <span class="buttontextdisabled">${uiLabelMap.EcommerceIsDefault}</span>
                        <#else>
                          <form name="defaultPaymentMethodForm" method="post" action="<@ofbizUrl>setprofiledefault/viewprofile</@ofbizUrl>">
                            <input type="hidden" name="productStoreId" value="${productStoreId}" />
                            <input type="hidden" name="defaultPayMeth" value="=${paymentMethod.paymentMethodId}" />
                            <input type="hidden" name="partyId" value="${party.partyId}" />
                            <input type="submit" value="${uiLabelMap.EcommerceSetDefault}" class="btn btn-main" />
                          </form>
                        </#if>
                      </td>
                    </tr>
                  </#list>
                </table>
                <#else>
                  ${uiLabelMap.AccountingNoPaymentMethodInformation}
                </#if>
              </td>
            </tr>
          </table>
        </div>
      </div>
    </#if>

    <#-- ============================================================= -->
    <#-- <div class="panel panel-smart">
      <div class="panel-heading navbar">
        <h3>${uiLabelMap.PartyTaxIdentification}</h3>
      </div>
      <div class="panel-body">
        <form method="post" action="<@ofbizUrl>createCustomerTaxAuthInfo</@ofbizUrl>" name="createCustTaxAuthInfoForm">
          <div>
            <input type="hidden" name="partyId" value="${party.partyId}"/>
            ${screens.render("component://order/widget/ordermgr/OrderEntryOrderScreens.xml#customertaxinfo")}
            <input type="submit" value="${uiLabelMap.CommonAdd}" class="smallSubmit"/>
          </div>
        </form>
      </div>
    </div>  -->

    <#-- ============================================================= -->
    <div class="panel panel-smart">
      <div class="panel-heading navbar">
        <h3>${uiLabelMap.CommonUsername} &amp; ${uiLabelMap.CommonPassword}
          <h5>
            <a href="<@ofbizUrl>changepassword</@ofbizUrl>" style="float: right;">${uiLabelMap.PartyChangePassword}</a>
          </h5>
        </h3>
      </div>
      <div class="panel-body">
        <dl class="dl-horizontal">
          <dt>${uiLabelMap.CommonUsername} :</dt>
          <dd>${userLogin.userLoginId}</dd>
        </dl>
      </div>
    </div>

    <#-- ============================================================= -->
    <#if person?exists>
      <form name="setdefaultshipmeth" action="<@ofbizUrl>setprofiledefault/viewprofile</@ofbizUrl>" method="post">
        <div class="panel panel-smart">
          <div class="panel-heading navbar">
            <h3>${uiLabelMap.EcommerceDefaultShipmentMethod}
              <#if profiledefs?has_content && profiledefs.defaultShipAddr?has_content && carrierShipMethods?has_content>
                <h5>
                  <a href="javascript:document.setdefaultshipmeth.submit();" style="float: right;">${uiLabelMap.EcommerceSetDefault}</a>
                </h5>
              </#if>
            </h3>
          </div>
          <div class="panel-body">
            <table width="100%" border="0" cellpadding="1">
              <#if profiledefs?has_content && profiledefs.defaultShipAddr?has_content && carrierShipMethods?has_content>
                <#list carrierShipMethods as shipMeth>
                  <#assign shippingMethod = shipMeth.shipmentMethodTypeId + "@" + shipMeth.partyId />
                  <tr>
                    <td>&nbsp;</td>
                    <td>
                      <div class="tabletext"><span style="white-space:;"><#if shipMeth.partyId != "_NA_">${shipMeth.partyId?if_exists}&nbsp;</#if>${shipMeth.get("description",locale)?if_exists}</span></div>
                    </td>
                    <td><input type="radio" name="defaultShipMeth" value="${shippingMethod}" <#if profiledefs.defaultShipMeth?default("") == shippingMethod>checked="checked"</#if> /></td>
                  </tr>
                </#list>
              <#else>
              <tr><td>${uiLabelMap.EcommerceDefaultShipmentMethodMsg}</td></tr>
              </#if>
            </table>
          </div>
        </div>
      </form>

      <#-- ============================================================= -->
      <#-- <div class="panel panel-smart">
        <div class="panel-heading navbar">
          <h3>${uiLabelMap.EcommerceFileManager}</h3>
        </div>
        <div class="panel-body">
          <table width="100%" border="0" cellpadding="1">
            <#if partyContent?has_content>
              <#list partyContent as contentRole>
              <#assign content = contentRole.getRelatedOne("Content") />
              <#assign contentType = content.getRelatedOneCache("ContentType") />
              <#assign mimeType = content.getRelatedOneCache("MimeType")?if_exists />
              <#assign status = content.getRelatedOneCache("StatusItem") />
                <tr>
                  <td><a href="<@ofbizUrl>img/${content.contentName?if_exists}?imgId=${content.dataResourceId?if_exists}</@ofbizUrl>" class="btn btn-main">${content.contentId}</a></td>
                  <td>${content.contentName?if_exists}</td>
                  <td>${(contentType.get("description",locale))?if_exists}</td>
                  <td>${mimeType?if_exists.description?if_exists}</td>
                  <td>${(status.get("description",locale))?if_exists}</td>
                  <td>${contentRole.fromDate?if_exists}</td>
                  <td align="right">
                    <a href="<@ofbizUrl>img/${content.contentName?if_exists}?imgId=${content.dataResourceId?if_exists}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonView}</a>
                    <a href="<@ofbizUrl>removePartyAsset?contentId=${contentRole.contentId}&amp;partyId=${contentRole.partyId}&amp;roleTypeId=${contentRole.roleTypeId}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonRemove}</a>
                  </td>
                </tr>
              </#list>
            <#else>
               <tr><td>${uiLabelMap.EcommerceNoFiles}</td></tr>
            </#if>
          </table>
          <div>&nbsp;</div>
          <label>${uiLabelMap.EcommerceUploadNewFile}</label>
          <div>
            <form method="post" enctype="multipart/form-data" action="<@ofbizUrl>uploadPartyContent</@ofbizUrl>">
              <div>
                <input type="hidden" name="partyId" value="${party.partyId}"/>
                <input type="hidden" name="dataCategoryId" value="PERSONAL"/>
                <input type="hidden" name="contentTypeId" value="DOCUMENT"/>
                <input type="hidden" name="statusId" value="CTNT_PUBLISHED"/>
                <input type="hidden" name="roleTypeId" value="OWNER"/>
                <input type="file" name="uploadedFile" size="50" class="inputBox"/>
                <div class="col-sm-4">
                  <select name="partyContentTypeId" class="form-control">
                    <option value="">${uiLabelMap.PartySelectPurpose}</option>
                    <#list partyContentTypes as partyContentType>
                      <option value="${partyContentType.partyContentTypeId}">${partyContentType.get("description", locale)?default(partyContentType.partyContentTypeId)}</option>
                    </#list>
                  </select>
                </div>
                <div class="col-sm-4">
                  <select name="mimeTypeId" class="form-control">
                    <option value="">${uiLabelMap.PartySelectMimeType}</option>
                    <#list mimeTypes as mimeType>
                      <option value="${mimeType.mimeTypeId}">${mimeType.get("description", locale)?default(mimeType.mimeTypeId)}</option>
                    </#list>
                  </select>
                </div>
                <div class="col-sm-4">
                  <input type="submit" value="${uiLabelMap.CommonUpload}" class="btn btn-main"/>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div> -->

      <#-- ============================================================= -->
      <div class="panel panel-smart">
        <div class="panel-heading navbar">
          <h3>${uiLabelMap.PartyContactLists}</h3>
        </div>
        <div class="panel-body">
          <table width="100%" border="0" cellpadding="1" cellspacing="0">
            <tr>
              <th>${uiLabelMap.EcommerceListName}</th>
              <#-- <th >${uiLabelMap.OrderListType}</th> -->
              <th>${uiLabelMap.CommonFromDate}</th>
              <th>${uiLabelMap.CommonThruDate}</th>
              <th>${uiLabelMap.CommonStatus}</th>
              <th>${uiLabelMap.CommonEmail}</th>
              <th>&nbsp;</th>
              <th>&nbsp;</th>
            </tr>
            <#list contactListPartyList as contactListParty>
            <#assign contactList = contactListParty.getRelatedOne("ContactList")?if_exists />
            <#assign statusItem = contactListParty.getRelatedOneCache("StatusItem")?if_exists />
            <#assign emailAddress = contactListParty.getRelatedOneCache("PreferredContactMech")?if_exists />
            <#-- <#assign contactListType = contactList.getRelatedOneCache("ContactListType")/> -->
            <tr><td colspan="7"></td></tr>
            <tr>
              <td>${contactList.contactListName?if_exists}<#if contactList.description?has_content>&nbsp;-&nbsp;${contactList.description}</#if></td>
              <#-- <td><div class="tabletext">${contactListType.get("description",locale)?if_exists}</div></td> -->
              <td>${contactListParty.fromDate?if_exists}</td>
              <td>${contactListParty.thruDate?if_exists}</td>
              <td>${(statusItem.get("description",locale))?if_exists}</td>
              <td>${emailAddress.infoString?if_exists}</td>
              <td>&nbsp;</td>
              <td>
                <#if (contactListParty.statusId?if_exists == "CLPT_ACCEPTED")>
                  <a href="<@ofbizUrl>updateContactListParty?partyId=${party.partyId}&amp;contactListId=${contactListParty.contactListId}&amp;fromDate=${contactListParty.fromDate}&amp;statusId=CLPT_REJECTED</@ofbizUrl>" class="btn btn-main">${uiLabelMap.EcommerceUnsubscribe}</a>
                <#elseif (contactListParty.statusId?if_exists == "CLPT_PENDING")>
                  <form method="post" action="<@ofbizUrl>updateContactListParty</@ofbizUrl>" name="clistAcceptForm${contactListParty_index}">
                  <div>
                    <input type="hidden" name="partyId" value="${party.partyId}"/>
                    <input type="hidden" name="contactListId" value="${contactListParty.contactListId}"/>
                    <input type="hidden" name="fromDate" value="${contactListParty.fromDate}"/>
                    <input type="hidden" name="statusId" value="CLPT_ACCEPTED"/>
                    <input type="text" size="10" name="optInVerifyCode" value="" class="inputBox"/>
                    <input type="submit" value="${uiLabelMap.EcommerceVerifySubscription}" class="btn btn-main"/>
                    </div>
                  </form>
                <#elseif (contactListParty.statusId?if_exists == "CLPT_REJECTED")>
                  <a href="<@ofbizUrl>updateContactListParty?partyId=${party.partyId}&amp;contactListId=${contactListParty.contactListId}&amp;fromDate=${contactListParty.fromDate}&amp;statusId=CLPT_PENDING</@ofbizUrl>" class="btn btn-main">${uiLabelMap.EcommerceSubscribe}</a>
                </#if>
              </td>
            </tr>
            </#list>
          </table>
          <div>
            <form method="post" action="<@ofbizUrl>createContactListParty</@ofbizUrl>" name="clistPendingForm">
              <div>
                <input type="hidden" name="partyId" value="${party.partyId}"/>
                <input type="hidden" name="statusId" value="CLPT_PENDING"/>
                <div class="form-group">
                  <label class="col-sm-2 control-label">New List: </label>
                  <div class="col-sm-4">
                    <select name="contactListId" class="form-control">
                      <#list publicContactLists as publicContactList>
                        <#-- <#assign publicContactListType = publicContactList.getRelatedOneCache("ContactListType")> -->
                        <#assign publicContactMechType = publicContactList.getRelatedOne("ContactMechType", true)! />
                        <option value="${publicContactList.contactListId}">${publicContactList.contactListName!} <#-- ${publicContactListType.get("description",locale)} --> <#if publicContactMechType?has_content>[${publicContactMechType.get("description",locale)}]</#if></option>
                      </#list>
                    </select>
                  </div>
                </div>
                <div class="col-sm-4">
                  <select name="preferredContactMechId" class="form-control">
                  <#-- <option></option> -->
                    <#list partyAndContactMechList as partyAndContactMech>
                      <option value="${partyAndContactMech.contactMechId}"><#if partyAndContactMech.infoString?has_content>${partyAndContactMech.infoString}<#elseif partyAndContactMech.tnContactNumber?has_content>${partyAndContactMech.tnCountryCode?if_exists}-${partyAndContactMech.tnAreaCode?if_exists}-${partyAndContactMech.tnContactNumber}<#elseif partyAndContactMech.paAddress1?has_content>${partyAndContactMech.paAddress1}, ${partyAndContactMech.paAddress2?if_exists}, ${partyAndContactMech.paCity?if_exists}, ${partyAndContactMech.paStateProvinceGeoId?if_exists}, ${partyAndContactMech.paPostalCode?if_exists}, ${partyAndContactMech.paPostalCodeExt?if_exists} ${partyAndContactMech.paCountryGeoId?if_exists}</#if></option>
                    </#list>
                  </select>
                </div>
                <div class="col-sm-2">
                  <input type="submit" value="${uiLabelMap.EcommerceSubscribe}" class="btn btn-main"/>
                </div>
              </div>
            </form>
          </div>
          <label>${uiLabelMap.EcommerceListNote}</label>
        </div>
      </div>

      <#-- ============================================================= -->
      <#if surveys?has_content>
        <div class="panel panel-smart">
          <div class="panel-heading navbar">
            <h3>${uiLabelMap.EcommerceSurveys}</h3>
          </div>
          <div class="panel-body">
            <table width="100%" border="0" cellpadding="1">
            <#list surveys as surveyAppl>
              <#assign survey = surveyAppl.getRelatedOne("Survey") />
              <tr>
                <td>&nbsp;</td>
                <td valign="top"><div class="tabletext">${survey.surveyName?if_exists}&nbsp;-&nbsp;${survey.description?if_exists}</div></td>
                <td>&nbsp;</td>
                <td valign="top">
                  <#assign responses = Static["org.apache.ofbiz.product.store.ProductStoreWorker"].checkSurveyResponse(request, survey.surveyId)?default(0)>
                  <#if (responses < 1)>${uiLabelMap.EcommerceNotCompleted}<#else>${uiLabelMap.EcommerceCompleted}</#if>
                </td>
                <#if (responses == 0 || survey.allowMultiple?default("N") == "Y")>
                  <#assign surveyLabel = uiLabelMap.EcommerceTakeSurvey />
                  <#if (responses > 0 && survey.allowUpdate?default("N") == "Y")>
                    <#assign surveyLabel = uiLabelMap.EcommerceUpdateSurvey />
                  </#if>
                  <td align="right"><a href="<@ofbizUrl>takesurvey?productStoreSurveyId=${surveyAppl.productStoreSurveyId}</@ofbizUrl>" class="btn btn-main">${surveyLabel}</a></td>
                <#else>
                &nbsp;
                </#if>
              </tr>
            </#list>
          </table>
          </div>
        </div>
      </#if>

      <#-- ============================================================= -->
      <#-- only 5 messages will show; edit the ViewProfile.groovy to change this number -->
      <#-- <div class="panel panel-smart">
        <div class="panel-body">
          ${screens.render("component://productfromthailand/widget/CustomerScreens.xml#messagelist-include")}

          ${screens.render("component://ecommerce/widget/CustomerScreens.xml#FinAccountList-include")} -->

          <#-- Serialized Inventory Summary -->
          <#-- ${screens.render('component://ecommerce/widget/CustomerScreens.xml#SerializedInventorySummary')} -->

          <#-- Subscription Summary -->
          <#-- ${screens.render('component://ecommerce/widget/CustomerScreens.xml#SubscriptionSummary')}
        </div>
      </div> -->
    </#if>
    <#else>
        <h3>${uiLabelMap.PartyNoPartyForCurrentUserName}: ${userLogin.userLoginId}</h3>
    </#if>
    </div>
    </div>
  </div>
</div>