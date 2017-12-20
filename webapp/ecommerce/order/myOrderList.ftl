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
<style>
    <#-- Override font size on this screens -->
    .shopping-cart-table tbody > tr > td {
        font-size: 14px !important;
    }
    .table-responsive > .table > tbody > tr.removestripe > td
    {
        border: none;
    }
    border: none;
</style>
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
                <th>${uiLabelMap.PFTOrderNbr}</th>
                <th>${uiLabelMap.ProductProductName}</th>
                <th>${uiLabelMap.CommonAmount}</th>
                <th>${uiLabelMap.CommonStatus}</th>
                <th>${uiLabelMap.PFTInvoices}</th>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <#if newOrderList?has_content>
                <#assign countList = 0>
                <#list newOrderList as orderHeader>
                  <#assign rateResult = dispatcher.runSync("getFXConversion", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("uomId", orderHeader.currencyUom!, "uomIdTo", currencyUom, "userLogin", userLogin?default(defaultUserLogin)))/>
                  <#assign conversionRate = rateResult.conversionRate>
                  <#if orderHeader.orderTypeId?has_content><tr><#else><tr class="removestripe"></#if>
                    <td><#if orderHeader.orderDate?has_content>${orderHeader.orderDate!?string.medium}<#else>&nbsp;</#if></td>
                    <td><#if orderHeader.orderTypeId?has_content><a href="<@ofbizUrl>orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>" target="_BLANK" class="btn btn-main">${orderHeader.orderId!}</a></#if></td>
                    <td>
                        <#if orderHeader.purchaseId?has_content><#assign orderItemId = orderHeader.purchaseId/><#else><#assign orderItemId = orderHeader.orderId/></#if>
                        <#assign orderItemList = EntityQuery.use(delegator).from("OrderItem").where("orderId", orderItemId).queryList()!>
                        <#if orderItemList?has_content>
                            <table>
                                <#if orderItemList?has_content>
                                    <#list orderItemList as orderItem>
                                        <#assign product = EntityQuery.use(delegator).from("Product").where("productId", orderItem.productId).queryOne()!>
                                        <#assign productContentWrapper = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].makeProductContentWrapper(product, request)/>
                                        <#if product?has_content>
                                           <tr><td>${orderItem.quantity!} x ${productContentWrapper.get("PRODUCT_NAME", "html")!}</td></tr>
                                        </#if>
                                    </#list>
                                </#if>
                            </table>
                        </#if>
                    </td>
                    <#if orderHeader.purchaseId?has_content><#assign statusId = orderHeader.purchaseStaus/><#else><#assign statusId = orderHeader.statusId/></#if>
                    <#assign statusItem = EntityQuery.use(delegator).from("StatusItem").where("statusId", statusId).queryOne()!>
                    <td><#if orderHeader.grandTotal?has_content><@ofbizCurrency amount=orderHeader.grandTotal*conversionRate isoCode=currencyUom /><#else>&nbsp;</#if></td>
                    <#assign conversionRate = rateResult.conversionRate>
                    <td>${statusItem.get("description")!}</td>
                    <#-- invoices -->
                    <#-- <#if orderHeader.orderId?has_content><#assign invoices = delegator.findByAnd("OrderItemBilling", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("orderId", "${orderHeader.purchaseId}"), Static["org.apache.ofbiz.base.util.UtilMisc"].toList("invoiceId"), false) />
                        <#assign distinctInvoiceIds = Static["org.apache.ofbiz.entity.util.EntityUtil"].getFieldListFromEntityList(invoices, "invoiceId", true)>
                        <#if distinctInvoiceIds?has_content>
                          <td>
                            <#list distinctInvoiceIds as invoiceId>
                               <a href="<@ofbizUrl>invoice.pdf?invoiceId=${invoiceId!}</@ofbizUrl>" class="btn btn-main">${invoiceId!}</a>
                            </#list>
                          </td>
                        <#else>
                          <td>&nbsp;</td>
                        </#if>
                    <#else>
                      <td>&nbsp;</td>
                    </#if>  -->
                    <#if orderHeader.orderItemSeqId?has_content>
                        <#assign orderItemBilling = EntityQuery.use(delegator).from("OrderItemBilling").where("orderId", orderHeader.orderId, "orderItemSeqId", orderHeader.orderItemSeqId).queryFirst()!>
                    <#else>
                        <#assign orderItemBilling = EntityQuery.use(delegator).from("OrderItemBilling").where("orderId", orderHeader.orderId).queryFirst()!>
                    </#if>
                    <#if orderItemBilling?has_content>
                      <td>
                           <a href="<@ofbizUrl>invoice.pdf?invoiceId=${orderItemBilling.invoiceId!}</@ofbizUrl>" class="btn btn-main">${orderItemBilling.invoiceId!}</a>
                      </td>
                    <#else>
                      <td>&nbsp;</td>
                    </#if>
                    <td>
                        <#if (orderHeader.purchaseStaus?has_content) && (orderHeader.purchaseStaus.equals("ORDER_APPROVED"))>
                            <#assign orderItemShipGroup = EntityQuery.use(delegator).from("OrderItemShipGroup").where("orderId", orderHeader.purchaseId).queryFirst()!>
                            <a href="javascript:document.receiveOrder_${countList!}.submit();" class="btn btn-main">${uiLabelMap.PFTReceiveItemOrder}</a>
                            <form name="receiveOrder_${countList!}" method="post" action="<@ofbizUrl>receiveOrder</@ofbizUrl>">
                              <input type="hidden" name="orderId" value="${orderHeader.purchaseId!}"/>
                              <input type="hidden" name="shipGroupSeqId" value="${orderItemShipGroup.shipGroupSeqId!}"/>
                            </form>
                        <#else>
                            <#if (!orderHeader.purchaseStaus?has_content) &&  orderHeader.statusId.equals("ORDER_APPROVED")>
                                <a href="javascript:document.receiveOrder_${countList!}.submit();" class="btn btn-main">${uiLabelMap.PFTReceiveItemOrder}</a>
                                <form name="receiveOrder_${countList!}" method="post" action="<@ofbizUrl>receiveOrderNoShip</@ofbizUrl>">
                                  <input type="hidden" name="orderId" value="${orderHeader.orderId!}"/>
                                </form>
                            <#else>
                                &nbsp;
                            </#if>
                        </#if>
                    </td>
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