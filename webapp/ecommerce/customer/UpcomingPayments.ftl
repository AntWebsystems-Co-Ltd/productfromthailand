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
    <!-- Store Management Menu Start -->
    <div class="col-sm-3">
        ${setRequestAttribute("isUpcomingPayments", "Y")}
        ${setRequestAttribute("isPaymentsReportsSub", "Y")}
        ${screens.render("component://productfromthailand/widget/CatalogScreens.xml#StoreManagementMenus")}
    </div>
    <!-- Store Management Menu Ends -->
    <div class="col-sm-9">
      <h4 class="main-heading text-center">
        ${uiLabelMap.PFTUpcomingPayments}
      </h4>
      <div class="table-responsive shopping-cart-table">
          <table class="table table-bordered">
            <thead>
                <tr>
                    <td class="text-center">
                        ${uiLabelMap.OrderOrderDate}
                    </td>
                    <td class="text-center">
                        ${uiLabelMap.FormFieldTitle_purchaseOrderId}
                    </td>
                    <td class="text-center">
                        ${uiLabelMap.ProductProductName}
                    </td>
                    <td class="text-center">
                        ${uiLabelMap.AccountingQuantity}
                    </td>
                    <td class="text-center">
                        ${uiLabelMap.AccountingUnitPrice}
                    </td>
                    <td class="text-center">
                        ${uiLabelMap.OrderItemTotal}
                    </td>
                </tr>
            </thead>
            <tbody>
                <#assign grandTotal = 0>
                <#assign currencyUomId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "currency.uom.id.default", delegator)>
                <#if upcomingList?has_content>
                    <#list upcomingList as upcoming>
                    <#assign productDetailList = EntityQuery.use(delegator).from("OrderItemAndProduct").where("orderId", upcoming.orderId).queryList()!>
                    <#if upcoming.currencyUom??><#assign currencyUomId = upcoming.currencyUom/></#if>
                    <tr>
                        <td class="text-center">
                            ${upcoming.orderDate?string.medium}
                        </td>
                        <td class="text-center">
                            ${upcoming.orderId}
                        </td>
                        <td class="text-left">
                            <#if productDetailList?has_content>
                                <#list productDetailList as productDetail>
                                    <div>${productDetail.productName!} [#${productDetail.productId}]</div>
                                </#list>
                            </#if>
                        </td>
                        <td class="text-center">
                            <#if productDetailList?has_content>
                                <#list productDetailList as productDetail>
                                    <div>${productDetail.quantity!}</div>
                                </#list>
                            </#if>
                        </td>
                        <td class="text-center">
                            <#if productDetailList?has_content>
                                <#list productDetailList as productDetail>
                                    <div><@ofbizCurrency amount=productDetail.unitPrice isoCode=upcoming.currencyUom/></div>
                                </#list>
                            </#if>
                        </td>
                        <td class="text-center">
                            <#if productDetailList?has_content>
                                <#list productDetailList as productDetail>
                                    <#assign itemTotal= productDetail.unitPrice * productDetail.quantity>
                                    <#assign grandTotal = grandTotal + itemTotal>
                                    <div><@ofbizCurrency amount=itemTotal isoCode=upcoming.currencyUom/></div>
                                </#list>
                            </#if>
                        </td>
                    </tr>
                    </#list>
                </#if>
                <tr>
                    <td class="text-left" colspan="5">
                        <b>${uiLabelMap.CommonTotal}</b>
                    </td>
                    <td class="text-center">
                        <b><@ofbizCurrency amount=grandTotal isoCode=currencyUomId/></b>
                    </td>
                </tr>
            </tbody>
          </table>
        </div>
    </div>
  </div>
</div>
