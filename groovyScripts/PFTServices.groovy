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
