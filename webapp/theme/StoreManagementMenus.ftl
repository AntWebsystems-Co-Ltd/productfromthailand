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

<h3 class="side-heading">${uiLabelMap.PFTStoreMenu}</h3>
<div class="list-group">
    <a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="list-group-item <#if requestAttributes.isMyProducts?default("N") == "Y">selected</#if>">
        <i class="fa fa-chevron-right"></i>
        ${uiLabelMap.PFTMyProducts}
    </a>
    <a href="<@ofbizUrl>SupplierInvoiceList</@ofbizUrl>" class="list-group-item <#if requestAttributes.isListInvoices?default("N") == "Y">selected</#if>">
        <i class="fa fa-chevron-right"></i>
        ${uiLabelMap.AccountingListInvoices}
    </a>
    <a href="<@ofbizUrl>PurchaseOrderList</@ofbizUrl>" class="list-group-item <#if requestAttributes.isMyOrders?default("N") == "Y">selected</#if>">
        <i class="fa fa-chevron-right"></i>
        ${uiLabelMap.PFTMyOrders}
    </a>
    <#if requestAttributes.isMyOrders?default("N") == "Y" || requestAttributes.isMyOrdersSub?default("N") == "Y">
    <ul class="store-dropdown">
        <li>
        <a href="<@ofbizUrl>AwaitingShipment</@ofbizUrl>" class="store-dropdown list-group-item <#if requestAttributes.isAwaitShipment?default("N") == "Y">selected</#if>">
            <i class="fa fa-chevron-right"></i>
            ${uiLabelMap.PFTAwaitingShipment}
        </a>
        </li>
        <li>
        <a href="<@ofbizUrl>PaidAndShippedOrder</@ofbizUrl>" class="list-group-item <#if requestAttributes.isPaidAndShipped?default("N") == "Y">selected</#if>">
            <i class="fa fa-chevron-right"></i>
            ${uiLabelMap.PFTPaidAndShipped}
        </a>
        </li>
        <li>
        <a href="<@ofbizUrl>CancellationsOrder</@ofbizUrl>" class="list-group-item <#if requestAttributes.isCancellations?default("N") == "Y">selected</#if>">
            <i class="fa fa-chevron-right"></i>
            ${uiLabelMap.PFTCancellations}
        </a>
        </li>
    </ul>
    </#if>
    <a href="<@ofbizUrl>PaymentsReports</@ofbizUrl>" class="list-group-item">
        <i class="fa fa-chevron-right"></i>
        ${uiLabelMap.PFTPaymentsReports}
    </a>
    <#if requestAttributes.isPaymentsReports?default("N") == "Y" || requestAttributes.isPaymentsReportsSub?default("N") == "Y">
    <ul class="store-dropdown">
        <li>
            <a href="<@ofbizUrl>UpcomingPayments</@ofbizUrl>" class="list-group-item <#if requestAttributes.isUpcomingPayments?default("N") == "Y">selected</#if>">
                <i class="fa fa-chevron-right"></i>
                ${uiLabelMap.PFTUpcomingPayments}
            </a>
        </li>
        <li>
            <a href="<@ofbizUrl>PaymentsReports</@ofbizUrl>" class="list-group-item <#if requestAttributes.isPaymentsReports?default("N") == "Y">selected</#if>">
                <i class="fa fa-chevron-right"></i>
                ${uiLabelMap.PFTAllPayments}
            </a>
        </li>
    </ul>
    </#if>
</div>
