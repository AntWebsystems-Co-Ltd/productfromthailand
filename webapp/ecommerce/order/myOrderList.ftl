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
          <a href="<@ofbizUrl>viewprofile</@ofbizUrl> " class="list-group-item">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.PFTMyProfile}
          </a>
          <a href="<@ofbizUrl>myOrderlist</@ofbizUrl>" class="list-group-item selected">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.PFTMyOrder}
          </a>
      </div>
    </div>
    <div class="col-sm-9">
  <h1>
    ${uiLabelMap.PFTOrderHistory}
    <#if person?exists>
      ${person.personalTitle?if_exists}
      ${person.firstName?if_exists}
      ${person.middleName?if_exists}
      ${person.lastName?if_exists}
      ${person.suffix?if_exists}
    <#elseif partyGroup?exists>
      ${partyGroup.groupName?if_exists}
    <#else>
      "${uiLabelMap.PartyNewUser}"
    </#if>
  </h1>
    <#-- ============================================================= -->
      <div class="panel panel-smart">
        <div class="panel-heading navbar">
          <h3>${uiLabelMap.OrderSalesHistory}</h3>
        </div>
        <div class="panel-body table-responsive shopping-cart-table">
          <table class="table">
            <thead>
              <tr>
                <th>${uiLabelMap.CommonDate}</th>
                <th>${uiLabelMap.OrderOrder} ${uiLabelMap.CommonNbr}</th>
                <th>${uiLabelMap.ProductProductName}</th>
                <th>${uiLabelMap.CommonAmount}</th>
                <th>${uiLabelMap.CommonStatus}</th>
                <th></th>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <#if newOrderList?has_content>
                <#assign countList = 0>
                <#list newOrderList as orderHeader>
                  <#assign rateResult = dispatcher.runSync("getFXConversion", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("uomId", orderHeader.currencyUom, "uomIdTo", currencyUom, "userLogin", userLogin?default(defaultUserLogin)))/>
                  <#assign conversionRate = rateResult.conversionRate>
                  <tr>
                    <td>${orderHeader.orderDate?string.medium}</td>
                    <td>${orderHeader.orderId}</td>
                    <td>
                        <#assign orderItemList = EntityQuery.use(delegator).from("OrderItem").where("orderId", orderHeader.purchaseId).queryList()!>
                        <#if orderItemList?has_content>
                            <table>
                                <#if orderItemList?has_content>
                                    <#list orderItemList as orderItem>
                                        <#assign product = EntityQuery.use(delegator).from("Product").where("productId", orderItem.productId).queryOne()!>
                                        <#if product?has_content>
                                           <tr><td>${orderItem.quantity!} x ${product.internalName!}</td></tr>
                                        </#if>
                                    </#list>
                                </#if>
                            </table>
                        </#if>
                    </td>
                    <#assign statusItem = EntityQuery.use(delegator).from("StatusItem").where("statusId", orderHeader.purchaseStaus).queryOne()!>
                    <td><@ofbizCurrency amount=orderHeader.grandTotal*conversionRate isoCode=currencyUom /></td>
                    <#assign conversionRate = rateResult.conversionRate>
                    <td>${statusItem.get("description")!}</td>
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
                    </#if> -->
                    <td><a href="<@ofbizUrl>orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonView}</a></td>
                    <td><#if orderHeader.purchaseStaus.equals("ORDER_APPROVED")>
                        <#assign orderItemShipGroup = EntityQuery.use(delegator).from("OrderItemShipGroup").where("orderId", orderHeader.purchaseId).queryFirst()!>
                        <a href="javascript:document.receiveOrder_${countList!}.submit();" class="btn btn-main">${uiLabelMap.PFTReceiveItemOrder}</a>
                        <form name="receiveOrder_${countList!}" method="post" action="<@ofbizUrl>receiveOrder</@ofbizUrl>">
                          <input type="hidden" name="orderId" value="${orderHeader.purchaseId!}"/>
                          <input type="hidden" name="shipGroupSeqId" value="${orderItemShipGroup.shipGroupSeqId!}"/>
                        </form>
                    </#if></td>
                    <#assign countList = countList+1>
                  </tr>
                </#list>
              <#else>
                <tr><td colspan="6">${uiLabelMap.OrderNoOrderFound}</td></tr>
              </#if>
            </tbody>
          </table>
        </div>
      </div>
    </#if>
    </div>
    </div>
  </div>
</div>