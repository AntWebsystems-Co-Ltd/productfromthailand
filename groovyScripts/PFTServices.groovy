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

import java.util.Map
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