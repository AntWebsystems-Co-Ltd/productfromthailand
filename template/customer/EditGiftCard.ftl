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
      <div class="panel-smart">
        <#if canNotView>
          <div class="panel-heading">
            <h3>${uiLabelMap.AccountingCardInfoNotBelongToYou}.</h3>
          </div>
        <div class="panel-body">
          <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>
        <#else>
          <#if !giftCard??>
            <div class="panel-heading">
              <h3>${uiLabelMap.AccountingAddNewGiftCard}.</h3>
            </div>
            <div class="panel-body">
              <form method="post" action="<@ofbizUrl>createGiftCard?DONE_PAGE=${donePage}</@ofbizUrl>" class="form-horizontal" name="editgiftcardform" style="margin: 0;">
          <#else>
            <div class="panel-heading">
              <h3>${uiLabelMap.AccountingEditGiftCard}.</h3>
            </div>
              <div class="panel-body">
              <form method="post" action="<@ofbizUrl>updateGiftCard?DONE_PAGE=${donePage}</@ofbizUrl>" class="form-horizontal" name="editgiftcardform" style="margin: 0;">
                <input type="hidden" name="paymentMethodId" value="${paymentMethodId}"/>
          </#if>
            <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>&nbsp;
            <a href="javascript:document.editgiftcardform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
            <p/>
            <div class="form-group">
              <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingCardNumber}</label>
              <div class="col-sm-6">
                <#if giftCardData?has_content && giftCardData.cardNumber?has_content>
                    <#assign pcardNumberDisplay = "">
                    <#assign pcardNumber = giftCardData.cardNumber!>
                    <#if pcardNumber?has_content>
                      <#assign psize = pcardNumber?length - 4>
                      <#if 0 < psize>
                        <#list 0 .. psize-1 as foo>
                          <#assign pcardNumberDisplay = pcardNumberDisplay + "*">
                        </#list>
                        <#assign pcardNumberDisplay = pcardNumberDisplay + pcardNumber[psize .. psize + 3]>
                      <#else>
                        <#assign pcardNumberDisplay = pcardNumber>
                      </#if>
                    </#if>
                  </#if>
                  <input type="text" class="form-control" size="20" maxlength="60" name="cardNumber" value="${pcardNumberDisplay!}"/>
              </div>
            </div>
            <div class="form-group">
              <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingPINNumber}</label>
              <div class="col-sm-6">
                <input type="text" class="form-control" size="10" maxlength="60" name="pinNumber" value="${giftCardData.pinNumber!}"/>
              </div>
            </div>
            <div class="form-group">
              <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.AccountingExpirationDate}</label>
              <div class="col-sm-2">
                <#assign expMonth = "">
                  <#assign expYear = "">
                  <#if giftCardData?? && giftCardData.expireDate??>
                    <#assign expDate = giftCard.expireDate>
                    <#if (expDate?? && expDate.indexOf("/") > 0)>
                      <#assign expMonth = expDate.substring(0,expDate.indexOf("/"))>
                      <#assign expYear = expDate.substring(expDate.indexOf("/")+1)>
                    </#if>
                  </#if>
                  <select name="expMonth" class="form-control" onchange="javascript:makeExpDate();">
                    <#if giftCardData?has_content && expMonth?has_content>
                      <#assign ccExprMonth = expMonth>
                    <#else>
                      <#assign ccExprMonth = requestParameters.expMonth!>
                    </#if>
                    <#if ccExprMonth?has_content>
                      <option value="${ccExprMonth!}">${ccExprMonth!}</option>
                    </#if>
                    ${screens.render("component://common/widget/CommonScreens.xml#ccmonths")}
                  </select>
                  <select name="expYear" class="form-control" onchange="javascript:makeExpDate();">
                    <#if giftCard?has_content && expYear?has_content>
                      <#assign ccExprYear = expYear>
                    <#else>
                      <#assign ccExprYear = requestParameters.expYear!>
                    </#if>
                    <#if ccExprYear?has_content>
                      <option value="${ccExprYear!}">${ccExprYear!}</option>
                    </#if>
                    ${screens.render("component://common/widget/CommonScreens.xml#ccyears")}
                  </select>
              </div>
            </div>
            <div class="form-group">
              <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonDescription}</label>
              <div class="col-sm-6">
                <input type="text" class="form-control" size="10" maxlength="60" name="description" value="${paymentMethodData.description!}"/>
              </div>
            </div>
          </form>&nbsp;
        <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonGoBack}</a>&nbsp;
        <a href="javascript:document.editgiftcardform.submit()" class="btn btn-main">${uiLabelMap.CommonSave}</a>
      </#if>
    </div>
  </div>
</div>
</div>