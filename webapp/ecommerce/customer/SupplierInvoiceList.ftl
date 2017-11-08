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
          <a href="<@ofbizUrl>SupplierInvoiceList</@ofbizUrl>" class="list-group-item selected">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.AccountingListInvoices}
          </a>
          <a href="<@ofbizUrl>PurchaseOrderList</@ofbizUrl>" class="list-group-item">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.AccountingFixedAssetMaintOrders}
          </a>
      </div>
    </div>
    <!-- Store Management Menu Ends -->
    <div class="col-sm-9">
      <h4 class="main-heading text-center">
        ${uiLabelMap.AccountingListInvoices}
      </h4>
      <div class="table-responsive shopping-cart-table">
        <table class="table table-bordered">
          <thead>
            <tr>
              <td class="text-center">
                  ${uiLabelMap.FormFieldTitle_invoiceId}
              </td>
              <td class="text-center">
                  ${uiLabelMap.PFTInvoiceTypeId}
              </td>
              <td class="text-center">
                  ${uiLabelMap.AccountingInvoiceDate}
              </td>
              <td class="text-center">
                  ${uiLabelMap.PFTStatus}
              </td>
              <td class="text-center">
                  ${uiLabelMap.CommonTotal}
              </td>
              <td class="text-center">
                  ${uiLabelMap.FormFieldTitle_amountToApply}
              </td>
            </tr>
          </thead>
          <tbody>
            <#if invoiceslistexternal?has_content>
              <#list invoiceslistexternal as invoiceslist>
                <#assign invoiceType = delegator.findOne("InvoiceType", {"invoiceTypeId" : invoiceslist.invoiceTypeId}, false)!/>
                <#assign invoiceStatus = delegator.findOne("StatusItem", {"statusId" : invoiceslist.statusId}, false)!/>
                <#-- <#assign amount = (Static["org.apache.ofbiz.accounting.invoice.InvoiceWorker"].getInvoiceItemTotal(invoiceItem))> -->
                <#assign total = (Static["org.apache.ofbiz.accounting.invoice.InvoiceWorker"].getInvoiceTotal(delegator,invoiceslist.invoiceId))/>
                <#assign amountToApply = (Static["org.apache.ofbiz.accounting.invoice.InvoiceWorker"].getInvoiceNotApplied(delegator,invoiceslist.invoiceId))/>
                <#-- <#assign amountToApply = "${groovy:org.apache.ofbiz.accounting.invoice.InvoiceWorker.getInvoiceNotApplied(delegator,invoiceId)
                  .multiply(org.apache.ofbiz.accounting.invoice.InvoiceWorker.getInvoiceCurrencyConversionRate(delegator,invoiceId))}"/> -->

                <tr>
                  <td class="text-center">
                    ${invoiceslist.invoiceId}
                  </td>
                  <td class="text-center">
                    ${invoiceType.description}
                  </td>
                  <td class="text-center">
                    ${invoiceslist.invoiceDate}
                  </td>
                  <td class="text-center">
                    ${invoiceStatus.description}
                  </td>
                  <td class="text-center">
                    ${total}
                  </td>
                  <td class="text-center">
                    ${amountToApply}
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