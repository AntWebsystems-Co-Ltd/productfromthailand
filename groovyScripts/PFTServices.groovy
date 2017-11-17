/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import java.sql.Timestamp
import java.util.Map

import org.apache.ofbiz.accounting.invoice.InvoiceWorker
import org.apache.ofbiz.base.util.UtilDateTime
import org.apache.ofbiz.entity.Delegator
import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.entity.condition.EntityConditionBuilder
import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.entity.util.EntityUtilProperties
import org.apache.ofbiz.product.price.PriceServices
import org.apache.ofbiz.service.ServiceUtil

public Map calculateSalePrice() {
    Map<String, Object> result = ServiceUtil.returnSuccess()
    BigDecimal purchasePrice = parameters.purchasePrice
    BigDecimal paypalFeeAmount = BigDecimal.ZERO
    BigDecimal pftFeeAmount = BigDecimal.ZERO
    BigDecimal pftVatAmount = BigDecimal.ZERO
    BigDecimal salePrice = BigDecimal.ZERO
    String paypalFeeStr = EntityUtilProperties.getPropertyValue("pft", "paypal.fee", delegator)
    String pftFeeStr = EntityUtilProperties.getPropertyValue("pft", "pft.fee", delegator)
    String pftVatStr = EntityUtilProperties.getPropertyValue("pft", "pft.vat", delegator)
    if (paypalFeeStr && pftFeeStr && pftVatStr) {
        BigDecimal paypalFee =  new BigDecimal(paypalFeeStr)
        BigDecimal pftFee =  new BigDecimal(pftFeeStr)
        BigDecimal pftVat =  new BigDecimal(pftVatStr)
        paypalFeeAmount = purchasePrice.multiply(paypalFee.movePointLeft(2))
        pftFeeAmount = purchasePrice.add(paypalFeeAmount).multiply(pftFee.movePointLeft(2))
        pftVatAmount = purchasePrice.add(paypalFeeAmount).add(pftFeeAmount).multiply(pftVat.movePointLeft(2))
        salePrice = purchasePrice.add(paypalFeeAmount).add(pftFeeAmount).add(pftVatAmount)
    }
    result.salePrice = salePrice.setScale(PriceServices.taxFinalScale, PriceServices.taxRounding)
    return result
}

public Map autoGeneratePurchaseInvoice() {
    Map<String, Object> result = ServiceUtil.returnSuccess();
    Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
    exprBldr = new EntityConditionBuilder();
    invoiceList = [];
    invoiceCond = exprBldr.AND() {
        EQUALS(invoiceTypeId: "PURCHASE_INVOICE")
        EQUALS(statusId: "INVOICE_IN_PROCESS")
        GREATER_THAN_EQUAL_TO(invoiceDate: UtilDateTime.getMonthStart(UtilDateTime.toTimestamp(nowTimestamp), timeZone, locale));
        LESS_THAN(invoiceDate: UtilDateTime.getMonthEnd(UtilDateTime.toTimestamp(nowTimestamp), timeZone, locale));
    }
    invoices = EntityQuery.use(delegator).from("Invoice").where(invoiceCond).orderBy("partyIdFrom").queryList();
    if (invoices) {
        supplierPartyId = null;
        invoices.each { invoice ->
            invoiceMap = [:];
            invItemAndOrdItemCond = exprBldr.AND() {
                EQUALS(invoiceId: invoice.invoiceId)
                EQUALS(invoiceItemTypeId: "PINV_FPROD_ITEM")
                NOT_EQUALS(orderId: null)
            }
            invItemAndOrdItems = EntityQuery.use(delegator).from("InvItemAndOrdItem").where(invItemAndOrdItemCond).queryList();
            if (invItemAndOrdItems) {
                invoiceMap.put("partyIdFrom", invoice.partyIdFrom)
                invoiceMap.put("invoiceItemList", invItemAndOrdItems)
            }
            if (invoiceMap) {
                invoiceList.add(invoiceMap)
            }
            if ((invoice.description && !invoice.description.startsWith("Monthly invoice of")) || !invoice.description) {
                paymentApplications = EntityQuery.use(delegator).from("PaymentApplication").where("invoiceId", invoice.invoiceId).queryList();
                if (paymentApplications) {
                    paymentApplications.each { paymentApplication ->
                        payment = EntityQuery.use(delegator).from("Payment").where("paymentId", paymentApplication.paymentId).queryOne();
                        if (payment) {
                            // Cancel payment
                            cancelPaymentMap = [:];
                            cancelPaymentMap.put("paymentId", payment.paymentId);
                            cancelPaymentMap.put("statusId", "PMNT_CANCELLED");
                            cancelPaymentMap.put("userLogin", userLogin);
                            cancelPayment = dispatcher.runSync("setPaymentStatus", cancelPaymentMap);
                        }
                    }
                }
                // Cancel invoice
                cancelInvoiceMap = [:];
                cancelInvoiceMap.put("invoiceId", invoice.invoiceId);
                cancelInvoiceMap.put("statusId", "INVOICE_CANCELLED");
                cancelInvoiceMap.put("userLogin", userLogin);
                cancelInvoice = dispatcher.runSync("setInvoiceStatus", cancelInvoiceMap);
            }
        }
    }

    defaultCurrencyUomId = EntityUtilProperties.getPropertyValue("general", "currency.uom.id.default", "THB", delegator);
    defaultOrganizationPartyId = EntityUtilProperties.getPropertyValue("general", "ORGANIZATION_PARTY", "pft", delegator);
    supplierPartyId = null;
    newInvoiceId = null;
    invoiceList.each {
        if (it.partyIdFrom != supplierPartyId) {
            supplierPartyId = it.partyIdFrom
            createInvoiceMap = [:];
            createInvoiceMap.put("statusId", "INVOICE_IN_PROCESS");
            createInvoiceMap.put("invoiceTypeId", "PURCHASE_INVOICE");
            createInvoiceMap.put("partyId", defaultOrganizationPartyId);
            createInvoiceMap.put("partyIdFrom", supplierPartyId);
            createInvoiceMap.put("currencyUomId", defaultCurrencyUomId);
            createInvoiceMap.put("description", "Monthly invoice of "+ UtilDateTime.timeStampToString(nowTimestamp, "MMMM yyyy", timeZone, locale));
            createInvoiceMap.put("userLogin", userLogin);
            newInvoice = dispatcher.runSync("createInvoice", createInvoiceMap);
            newInvoiceId = newInvoice.invoiceId;
        }
        if (newInvoiceId) {
            it.invoiceItemList.each { invoiceItem ->
                createInvoiceItemMap = [:];
                createInvoiceItemMap.put("invoiceId", newInvoiceId);
                createInvoiceItemMap.put("invoiceItemTypeId", invoiceItem.invoiceItemTypeId);
                createInvoiceItemMap.put("productId", invoiceItem.productId);
                createInvoiceItemMap.put("quantity", invoiceItem.quantity);
                createInvoiceItemMap.put("amount", invoiceItem.amount);
                createInvoiceItemMap.put("description", "From Order #"+invoiceItem.orderId);
                createInvoiceItemMap.put("userLogin", userLogin);
                newInvoiceItem = dispatcher.runSync("createInvoiceItem", createInvoiceItemMap);
            }
        }
    }
    return result
}

public Map createUpdateSupplierProductOtherCurrencies() {
    Map<String, Object> result = ServiceUtil.returnSuccess()
    String productId = parameters.productId
    BigDecimal lastPrice = parameters.lastPrice
    systemUserLogin = from("UserLogin").where("userLoginId", "system").queryOne();
    currencyList = from("Uom").where("uomTypeId", "CURRENCY_MEASURE").queryList()
    if (currencyList) {
        currencyList.each { currency ->
            supplierProduct = from("SupplierProduct").where("productId", productId, "currencyUomId", "THB").orderBy("-availableFromDate").queryFirst()
            if (supplierProduct) {
                if (!currency.uomId.equals(supplierProduct.currencyUomId)) {
                    uomConversionDated = from("UomConversionDated").where("uomId", supplierProduct.currencyUomId, "uomIdTo", currency.uomId).filterByDate().queryList()
                    if (uomConversionDated) {
                        Double conversionFactor = uomConversionDated[0].conversionFactor
                        BigDecimal newPrice = BigDecimal.ZERO
                        newPrice = lastPrice.multiply(conversionFactor)
                        checkPriceExist = from("SupplierProduct").where("productId", supplierProduct.productId, "currencyUomId", currency.uomId).queryFirst()
                        if (checkPriceExist) {
                            updateSupplierProduct = [:]
                            updateSupplierProduct = dispatcher.getDispatchContext().makeValidContext("updateSupplierProduct", "IN", supplierProduct)
                            updateSupplierProduct.currencyUomId = currency.uomId
                            updateSupplierProduct.lastPrice = newPrice
                            updateSupplierProduct.userLogin = systemUserLogin
                            runService('updateSupplierProduct', updateSupplierProduct)
                        } else {
                            newSupplierProduct = [:]
                            newSupplierProduct = dispatcher.getDispatchContext().makeValidContext("createSupplierProduct", "IN", supplierProduct)
                            newSupplierProduct.currencyUomId = currency.uomId
                            newSupplierProduct.lastPrice = newPrice
                            newSupplierProduct.userLogin = systemUserLogin
                            runService('createSupplierProduct', newSupplierProduct)
                        }
                    }
                }
            }
        }
    }
    return result
}
