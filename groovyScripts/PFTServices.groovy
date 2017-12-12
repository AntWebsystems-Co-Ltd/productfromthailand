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
import java.util.HashMap
import java.util.LinkedList
import java.util.List
import java.util.Map

import org.apache.ofbiz.accounting.invoice.InvoiceWorker
import org.apache.ofbiz.base.util.Debug
import org.apache.ofbiz.base.util.GeneralException
import org.apache.ofbiz.base.util.UtilDateTime
import org.apache.ofbiz.base.util.UtilGenerics
import org.apache.ofbiz.base.util.UtilValidate
import org.apache.ofbiz.entity.Delegator
import org.apache.ofbiz.entity.GenericEntityException
import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.entity.condition.EntityCondition
import org.apache.ofbiz.entity.condition.EntityConditionBuilder
import org.apache.ofbiz.entity.condition.EntityOperator
import org.apache.ofbiz.entity.util.EntityListIterator
import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.entity.util.EntityUtilProperties
import org.apache.ofbiz.product.catalog.CatalogWorker
import org.apache.ofbiz.product.category.CategoryServices
import org.apache.ofbiz.product.category.CategoryWorker
import org.apache.ofbiz.product.price.PriceServices
import org.apache.ofbiz.product.product.ProductWorker
import org.apache.ofbiz.service.ServiceUtil

public Map calculateSalePrice() {
    Map<String, Object> result = ServiceUtil.returnSuccess()
    BigDecimal purchasePrice = parameters.purchasePrice
    BigDecimal paypalFeeAmount = BigDecimal.ZERO
    BigDecimal pftFeeAmount = BigDecimal.ZERO
    BigDecimal pftVatAmount = BigDecimal.ZERO
    BigDecimal salePrice = BigDecimal.ZERO
    BigDecimal totalSalePrice = BigDecimal.ZERO
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
        salePrice = purchasePrice.add(paypalFeeAmount).add(pftFeeAmount).add(pftVatAmount).setScale(0, PriceServices.taxRounding)
        String salePriceStr = salePrice.toString()
        String lastDigitStr = salePriceStr.substring(salePriceStr.length() - 1);
        if (lastDigitStr >= "1" && lastDigitStr <= "5") {
            BigDecimal a =  new BigDecimal("5")
            totalSalePrice = salePrice.add(a.subtract(new BigDecimal(lastDigitStr)))
        } else if (lastDigitStr >= "6" && lastDigitStr <= "9") {
            BigDecimal b =  new BigDecimal("9")
            totalSalePrice = salePrice.add(b.subtract(new BigDecimal(lastDigitStr)))
        } else {
            totalSalePrice = salePrice
        }
    }
    result.salePrice = totalSalePrice
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

public Map getProductCategoryAndLimitedMembers() {
    String productCategoryId = (String) context.get("productCategoryId");
    boolean limitView = ((Boolean) context.get("limitView")).booleanValue();
    int defaultViewSize = ((Integer) context.get("defaultViewSize")).intValue();
    Timestamp introductionDateLimit = (Timestamp) context.get("introductionDateLimit");
    Timestamp releaseDateLimit = (Timestamp) context.get("releaseDateLimit");

    List<String> orderByFields = UtilGenerics.checkList(context.get("orderByFields"));
    if (orderByFields == null) orderByFields = new LinkedList<String>();
    String entityName = new CategoryServices().getCategoryFindEntityName(delegator, orderByFields, introductionDateLimit, releaseDateLimit);

    String prodCatalogId = (String) context.get("prodCatalogId");

    boolean useCacheForMembers = (context.get("useCacheForMembers") == null || ((Boolean) context.get("useCacheForMembers")).booleanValue());
    boolean activeOnly = (context.get("activeOnly") == null || ((Boolean) context.get("activeOnly")).booleanValue());

    boolean useRandomForMembers = context.get("useRandomForMembers");
    // Set random for featured products
    if (productCategoryId.equals("PFTPROMOTION")) {
        useRandomForMembers = true;
    }

    // checkViewAllow defaults to false, must be set to true and pass the prodCatalogId to enable
    boolean checkViewAllow = (prodCatalogId != null && context.get("checkViewAllow") != null &&
            ((Boolean) context.get("checkViewAllow")).booleanValue());

    String viewProductCategoryId = null;
    if (checkViewAllow) {
        viewProductCategoryId = CatalogWorker.getCatalogViewAllowCategoryId(delegator, prodCatalogId);
    }

    Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
    int viewIndex = 0;
    try {
        viewIndex = Integer.valueOf((String) context.get("viewIndexString")).intValue();
    } catch (Exception e) {
        viewIndex = 0;
    }

    int viewSize = defaultViewSize;
    try {
        viewSize = Integer.valueOf((String) context.get("viewSizeString")).intValue();
    } catch (Exception e) {
        viewSize = defaultViewSize;
    }

    GenericValue productCategory = null;
    try {
        productCategory = EntityQuery.use(delegator).from("ProductCategory").where("productCategoryId", productCategoryId).cache().queryOne();
    } catch (GenericEntityException e) {
        Debug.logWarning(e.getMessage(), "");
        productCategory = null;
    }

    int listSize = 0;
    int lowIndex = 0;
    int highIndex = 0;

    if (limitView) {
        // get the indexes for the partial list
        lowIndex = ((viewIndex * viewSize) + 1);
        highIndex = (viewIndex + 1) * viewSize;
    } else {
        lowIndex = 0;
        highIndex = 0;
    }

    boolean filterOutOfStock = false;
    try {
        String productStoreId = (String) context.get("productStoreId");
        if (UtilValidate.isNotEmpty(productStoreId)) {
            GenericValue productStore = EntityQuery.use(delegator).from("ProductStore").where("productStoreId", productStoreId).queryOne();
            if (productStore != null && "N".equals(productStore.getString("showOutOfStockProducts"))) {
                filterOutOfStock = true;
            }
        }
    } catch (GenericEntityException e) {
        Debug.logWarning(e.getMessage(), "");
    }

    List<GenericValue> productCategoryMembers = null;
    if (productCategory != null) {
        EntityListIterator pli = null;
        try {
            if (useCacheForMembers) {
                productCategoryMembers = EntityQuery.use(delegator).from(entityName).where("productCategoryId", productCategoryId).orderBy(orderByFields).cache(true).queryList();
                if (activeOnly) {
                    productCategoryMembers = EntityUtil.filterByDate(productCategoryMembers, true);
                }
                List<EntityCondition> filterConditions = new LinkedList<EntityCondition>();
                if (introductionDateLimit != null) {
                    EntityCondition condition = EntityCondition.makeCondition(EntityCondition.makeCondition("introductionDate", EntityOperator.EQUALS, null), EntityOperator.OR, EntityCondition.makeCondition("introductionDate", EntityOperator.LESS_THAN_EQUAL_TO, introductionDateLimit));
                    filterConditions.add(condition);
                }
                if (releaseDateLimit != null) {
                    EntityCondition condition = EntityCondition.makeCondition(EntityCondition.makeCondition("releaseDate", EntityOperator.EQUALS, null), EntityOperator.OR, EntityCondition.makeCondition("releaseDate", EntityOperator.LESS_THAN_EQUAL_TO, releaseDateLimit));
                    filterConditions.add(condition);
                }
                if (!filterConditions.isEmpty()) {
                    productCategoryMembers = EntityUtil.filterByCondition(productCategoryMembers, EntityCondition.makeCondition(filterConditions, EntityOperator.AND));
                }

                // filter out of stock products
                if (filterOutOfStock) {
                    try {
                        productCategoryMembers = ProductWorker.filterOutOfStockProducts(productCategoryMembers, dispatcher, delegator);
                    } catch (GeneralException e) {
                        Debug.logWarning("Problem filtering out of stock products :"+e.getMessage(), "");
                    }
                }
                // filter out the view allow before getting the sublist
                if (UtilValidate.isNotEmpty(viewProductCategoryId)) {
                    productCategoryMembers = CategoryWorker.filterProductsInCategory(delegator, productCategoryMembers, viewProductCategoryId);
                }

                // set the index and size
                listSize = productCategoryMembers.size();
                if (limitView) {
                    // limit high index to (filtered) listSize
                    if (highIndex > listSize) {
                        highIndex = listSize;
                    }
                    // if lowIndex > listSize, the input is wrong => reset to first page
                    if (lowIndex > listSize) {
                        viewIndex = 0;
                        lowIndex = 1;
                        highIndex = Math.min(viewSize, highIndex);
                    }
                    // get only between low and high indexes
                    if (UtilValidate.isNotEmpty(productCategoryMembers)) {
                        // Random for featured products
                        if (useRandomForMembers) {
                            List productCategoryMembersRandomTemp = new ArrayList(productCategoryMembers);
                            List<Map<String, Object>> productCategoryMembersList = new LinkedList<Map<String,Object>>();
                            Random rand = new Random();
                            while (productCategoryMembersRandomTemp.size() > 0) {
                                int index = rand.nextInt(productCategoryMembersRandomTemp.size());
                                productCategoryMembersList.add(productCategoryMembersRandomTemp.remove(index))
                            }
                            productCategoryMembers = productCategoryMembersList.subList(lowIndex-1, highIndex);
                        } else {
                            productCategoryMembers = productCategoryMembers.subList(lowIndex-1, highIndex);
                        }
                    }
                } else {
                    lowIndex = 1;
                    highIndex = listSize;
                }
            } else {
                List<EntityCondition> mainCondList = new LinkedList<EntityCondition>();
                mainCondList.add(EntityCondition.makeCondition("productCategoryId", EntityOperator.EQUALS, productCategory.getString("productCategoryId")));
                if (activeOnly) {
                    mainCondList.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, nowTimestamp));
                    mainCondList.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null), EntityOperator.OR, EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, nowTimestamp)));
                }
                if (introductionDateLimit != null) {
                    mainCondList.add(EntityCondition.makeCondition(EntityCondition.makeCondition("introductionDate", EntityOperator.EQUALS, null), EntityOperator.OR, EntityCondition.makeCondition("introductionDate", EntityOperator.LESS_THAN_EQUAL_TO, introductionDateLimit)));
                }
                if (releaseDateLimit != null) {
                    mainCondList.add(EntityCondition.makeCondition(EntityCondition.makeCondition("releaseDate", EntityOperator.EQUALS, null), EntityOperator.OR, EntityCondition.makeCondition("releaseDate", EntityOperator.LESS_THAN_EQUAL_TO, releaseDateLimit)));
                }
                EntityCondition mainCond = EntityCondition.makeCondition(mainCondList, EntityOperator.AND);

                // set distinct on
                // using list iterator
                pli = EntityQuery.use(delegator).from(entityName).where(mainCond).orderBy(orderByFields).cursorScrollInsensitive().maxRows(highIndex).queryIterator();

                // get the partial list for this page
                if (limitView) {
                    if (viewProductCategoryId != null) {
                        // do manual checking to filter view allow
                        productCategoryMembers = new LinkedList<GenericValue>();
                        GenericValue nextValue;
                        int chunkSize = 0;
                        listSize = 0;

                        while ((nextValue = pli.next()) != null) {
                            String productId = nextValue.getString("productId");
                            if (CategoryWorker.isProductInCategory(delegator, productId, viewProductCategoryId)) {
                                if (listSize + 1 >= lowIndex && chunkSize < viewSize) {
                                    productCategoryMembers.add(nextValue);
                                    chunkSize++;
                                }
                                listSize++;
                            }
                        }
                    } else {
                        productCategoryMembers = pli.getPartialList(lowIndex, viewSize);
                        listSize = pli.getResultsSizeAfterPartialList();
                    }
                } else {
                    productCategoryMembers = pli.getCompleteList();
                    if (UtilValidate.isNotEmpty(viewProductCategoryId)) {
                        // filter out the view allow
                        productCategoryMembers = CategoryWorker.filterProductsInCategory(delegator, productCategoryMembers, viewProductCategoryId);
                    }

                    listSize = productCategoryMembers.size();
                    lowIndex = 1;
                    highIndex = listSize;
                }

                // filter out of stock products
                if (filterOutOfStock) {
                    try {
                        productCategoryMembers = ProductWorker.filterOutOfStockProducts(productCategoryMembers, dispatcher, delegator);
                        listSize = productCategoryMembers.size();
                    } catch (GeneralException e) {
                        Debug.logWarning("Problem filtering out of stock products :"+e.getMessage(), "");
                    }
                }

                // null safety
                if (productCategoryMembers == null) {
                    productCategoryMembers = new LinkedList<GenericValue>();
                }

                if (highIndex > listSize) {
                    highIndex = listSize;
                }
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, "");
        }
        finally {
            // close the list iterator, if used
            if (pli != null) {
                try {
                    pli.close();
                } catch (GenericEntityException e) {
                    Debug.logError(e, "");
                }
            }
        }
    }

    Map<String, Object> result = new HashMap<String, Object>();
    result.put("viewIndex", Integer.valueOf(viewIndex));
    result.put("viewSize", Integer.valueOf(viewSize));
    result.put("lowIndex", Integer.valueOf(lowIndex));
    result.put("highIndex", Integer.valueOf(highIndex));
    result.put("listSize", Integer.valueOf(listSize));
    if (productCategory != null) result.put("productCategory", productCategory);
    if (productCategoryMembers != null) result.put("productCategoryMembers", productCategoryMembers);
    return result;
}
