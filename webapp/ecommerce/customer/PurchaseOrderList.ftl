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
        <h3 class="side-heading">Store Menu</h3>
        <div class="list-group">
            <a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="list-group-item">
                <i class="fa fa-chevron-right"></i>
                ${uiLabelMap.PFTMyProducts}
            </a>
            <a href="<@ofbizUrl>SupplierInvoiceList</@ofbizUrl>" class="list-group-item">
                <i class="fa fa-chevron-right"></i>
                ${uiLabelMap.AccountingListInvoices}
            </a>
            <a href="<@ofbizUrl>PurchaseOrderList</@ofbizUrl>" class="list-group-item selected">
                <i class="fa fa-chevron-right"></i>
                ${uiLabelMap.AccountingFixedAssetMaintOrders}
            </a>
      </div>
    </div>
    <!-- Store Management Menu Ends -->
    <div class="col-sm-9">
      <h4 class="main-heading text-center">
        ${uiLabelMap.AccountingFixedAssetMaintOrders}
      </h4>
      <div class="table-responsive shopping-cart-table">
          <table class="table table-bordered">
            <thead>
              <tr>
                <td class="text-center">
                    ${uiLabelMap.FormFieldTitle_orderTypeId}
                </td>
                <td class="text-center">
                    ${uiLabelMap.orderId}
                </td>
                <td class="text-center">
                    ${uiLabelMap.grandTotal}
                </td>
                <td class="text-center">
                    ${uiLabelMap.statusId}
                </td>
                <td class="text-center">
                    ${uiLabelMap.orderDate}
                </td>
                <td class="text-center">
                    ${uiLabelMap.partyId}
                </td>
                <td class="text-center">
                    ${uiLabelMap.CommonEmptyHeader}
                </td>
              </tr>
            </thead>
            <tbody>
              <#if orderLists?has_content>
                <#list orderLists as orderList>
                  <#assign orderType = delegator.findOne("OrderType", {"orderTypeId" : orderList.orderTypeId}, false)!/>
                  <#assign orderStatus = delegator.findOne("StatusItem", {"statusId" : orderList.statusId}, false)!/>
                  <#assign roleType = delegator.findOne("RoleType", {"roleTypeId" : orderList.roleTypeId}, false)!/>
                  <tr>
                    <td class="text-center">
                      ${orderType.description}
                    </td>
                    <td class="text-center">
                      ${orderList.orderId}
                    </td>
                    <td class="text-center">
                      <@ofbizCurrency amount=orderList.grandTotal! isoCode=orderList.currencyUom/>
                    </td>
                    <td class="text-center">
                      ${orderStatus.description}
                    </td>
                    <td class="text-center">
                      ${orderList.orderDate?string.medium}
                    </td>
                    <td class="text-center">
                      ${orderList.partyId}
                    </td>
                    <td class="text-center">
                      <input type="button" class="btn btn-main" value="${uiLabelMap.CommonView}" onclick="javascript: location.href = '<@ofbizUrl>orderstatus?orderId=${orderList.orderId}</@ofbizUrl>';"/>
                    </td>
                  </tr>
                </#list>
              </#if>
            </tbody>
          </table>
        </div>
    </div>
  </div>
</div>