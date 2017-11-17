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
    <#assign currencyUomId = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("general", "currency.uom.id.default", delegator)>
    <div class="panel-smart">
        <div class="panel-heading">
            <h3 class="panel-title">
                ${uiLabelMap.AccountingInvoicePurchase} ${uiLabelMap.CommonInformation}
            </h3>
        </div>
        <div class="panel-body">
            <#if invoice??>
            <#assign currencyUomId = invoice.currencyUomId/>
            <#assign invoicePartyIdFrom = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", invoice.partyIdFrom, "compareDate", invoice.invoiceDate, "userLogin", userLogin))/>
            <#assign invoicePartyIdTo = dispatcher.runSync("getPartyNameForDate", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("partyId", invoice.partyId, "compareDate", invoice.invoiceDate, "userLogin", userLogin))/>
            <p><b>${uiLabelMap.AccountingInvoice} ${uiLabelMap.CommonNbr}:</b> ${invoice.invoiceId!}</p>
            <p><b>${uiLabelMap.AccountingInvoice} ${uiLabelMap.CommonDate}:</b> ${invoice.invoiceDate?string.medium!}</p>
            <p><b>${uiLabelMap.FormFieldTitle_partyIdFrom}:</b> ${invoicePartyIdFrom.fullName!}</p>
            <p><b>${uiLabelMap.FormFieldTitle_partyIdTo}:</b> ${invoicePartyIdTo.fullName!}</p>
            </#if>
        </div>
        <div class="panel-heading">
            <h3 class="panel-title">
                ${uiLabelMap.AccountingInvoiceItems}
            </h3>
        </div>
        <div class="panel-body">
            <div class="panel-smart">
                <div class="table-responsive shopping-cart-table">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <td class="text-center">
                                    ${uiLabelMap.AccountingProduct}
                                </td>
                                <td class="text-center">
                                    ${uiLabelMap.OrderQuantity}
                                </td>
                                <td class="text-center">
                                    ${uiLabelMap.OrderUnitPrice}
                                </td>
                                <td class="text-center">
                                    ${uiLabelMap.OrderAmount}
                                </td>
                            </tr>
                        </thead>
                        <tbody>
                            <#assign grandTotal = 0>
                            <#list invoiceItems as invoiceItem>
                            <#assign itemTotal= invoiceItem.amount * invoiceItem.quantity>
                            <#assign grandTotal = grandTotal + itemTotal>
                            <tr>
                                <td class="text-left">
                                    ${invoiceItem.description} [#${invoiceItem.productId}]
                                </td>
                                <td class="text-center">
                                    ${invoiceItem.quantity}
                                </td>
                                <td class="text-center">
                                    <@ofbizCurrency amount=invoiceItem.amount! isoCode=currencyUomId/>
                                </td>
                                <td class="text-center">
                                    <div><@ofbizCurrency amount=grandTotal isoCode=currencyUomId/></div>
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
