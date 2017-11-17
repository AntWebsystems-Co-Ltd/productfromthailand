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
        ${setRequestAttribute("isPaymentsReports", "Y")}
        ${screens.render("component://productfromthailand/widget/CatalogScreens.xml#StoreManagementMenus")}
    </div>
    <!-- Store Management Menu Ends -->
    <div class="col-sm-9">
      <h4 class="main-heading text-center">
        ${uiLabelMap.CommonAll} ${uiLabelMap.CommonPayment}
      </h4>
      <div class="panel-smart">
        <form name="findAllPayments" id="findAllPayments" action="<@ofbizUrl>PaymentsReports</@ofbizUrl>" method="POST" class="form-horizontal">
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-sm-3 control-label">${uiLabelMap.FormFieldTitle_invoiceId}</label>
                    <div class="col-sm-6">
                        <div class="input-group">
                           <input type="input" name="invoiceId" class="form-control" value="${parameters.invoiceId!}"/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">${uiLabelMap.CommonMonth}</label>
                    <div class="col-sm-6">
                        <div class='input-group'>
                            <select name="selectedMonth" class="form-control">
                                <option value=""></option>
                                <#list monthList as month>
                                <option value="${month.value}" <#if parameters.selectedMonth!?string == month.value?string>selected</#if>>${month.description}</option>
                                </#list>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">${uiLabelMap.CommonEmptyHeader}</label>
                    <div class="col-sm-6">
                        <button type="submit" class="btn btn-main">${uiLabelMap.CommonFind}</button>
                    </div>
                </div>
            </div>
        </form>
      </div>
      <br/>
      <div class="panel-smart">
          <div class="table-responsive shopping-cart-table">
              <table class="table table-bordered">
                <thead>
                    <tr>
                        <td class="text-center">
                            ${uiLabelMap.AccountingInvoiceDate}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.FormFieldTitle_invoiceId}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.OrderGrandTotal}
                        </td>
                        <#if invoices?has_content>
                        <td class="text-center">
                            ${uiLabelMap.CommonEmptyHeader}
                        </td>
                        </#if>
                    </tr>
                </thead>
                <tbody>
                    <#list invoices as invoice>
                    <#assign invoiceTotal = Static["org.apache.ofbiz.accounting.invoice.InvoiceWorker"].getInvoiceTotal(invoice)>
                    <tr>
                        <td class="text-center">
                            ${invoice.invoiceDate?string.medium}
                        </td>
                        <td class="text-center">
                            ${invoice.invoiceId}
                        </td>
                        <td class="text-center">
                            <@ofbizCurrency amount=invoiceTotal! isoCode=invoice.currencyUomId/>
                        </td>
                        <td class="text-center">
                            <button type="button" class="btn btn-main" onclick="window.location.href='<@ofbizUrl>ViewPurchaseInvoice?invoiceId=${invoice.invoiceId!}</@ofbizUrl>'">${uiLabelMap.CommonView}</button>
                            <button type="button" class="btn btn-main" onclick="window.open('<@ofbizUrl>PaymentReport.pdf?invoiceId=${invoice.invoiceId!}</@ofbizUrl>', '_blank')">${uiLabelMap.CommonPdf}</button>
                        </td>
                    </tr>
                    </#list>
                </tbody>
              </table>
          </div>
      </div>
    </div>
  </div>
</div>
