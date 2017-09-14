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

/*
 * This script is also referenced by the ecommerce's screens and
 * should not contain order component's specific code.
 */

import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.entity.*;
import org.apache.ofbiz.entity.util.*;
import org.apache.ofbiz.service.*;
import org.apache.ofbiz.product.product.ProductContentWrapper;
import org.apache.ofbiz.product.config.ProductConfigWorker;
import org.apache.ofbiz.product.catalog.*;
import org.apache.ofbiz.product.store.*;
import org.apache.ofbiz.order.shoppingcart.*;
import java.math.BigDecimal;
import org.apache.ofbiz.base.util.UtilNumber;
import org.apache.ofbiz.webapp.website.WebSiteWorker

//either optProduct, optProductId or productId must be specified
product = request.getAttribute("optProduct");
optProductId = request.getAttribute("optProductId");
productId = product?.productId ?: optProductId ?: request.getAttribute("productId");

webSiteId = WebSiteWorker.getWebSiteId(request)
catalogId = CatalogWorker.getCurrentCatalogId(request);
productStore = ProductStoreWorker.getProductStore(request);
facilityId = productStore.inventoryFacilityId;
productStoreId = productStore.productStoreId;
autoUserLogin = session.getAttribute("autoUserLogin");
userLogin = session.getAttribute("userLogin");
cart = ShoppingCartEvents.getCartObject(request);

context.remove("daysToShip");
context.remove("averageRating");
context.remove("numRatings");
context.remove("totalPrice");

// get the product entity
if (!product && productId) {
    product = from("Product").where("productId", productId).cache(true).queryOne()
}
if (product) {
    resultOutput = [:];
    if(facilityId){
        resultOutput = dispatcher.runSync("getInventoryAvailableByFacility", [productId : product.productId, facilityId : facilityId, useCache : true]);
    }
    totalAvailableToPromise = resultOutput.availableToPromiseTotal;
    if (totalAvailableToPromise && totalAvailableToPromise.doubleValue() > 0) {
        productFacility = delegator.findByPrimaryKeyCache("ProductFacility", [productId : product.productId, facilityId : facilityId]);
        if (productFacility?.daysToShip != null) {
            context.daysToShip = productFacility.daysToShip;
        }
    } else {
       supplierProduct = from("SupplierProduct").where("productId", product.productId).orderBy("-availableFromDate").cache(true).queryFirst()
       if (supplierProduct?.standardLeadTimeDays != null) {
           standardLeadTimeDays = supplierProduct.standardLeadTimeDays;
           daysToShip = standardLeadTimeDays + 1;
           context.daysToShip = daysToShip;
       }
    }
    // make the productContentWrapper
    productContentWrapper = new ProductContentWrapper(product, request);
    context.productContentWrapper = productContentWrapper;
}

categoryId = null;
reviews = null;
if (product) {
    categoryId = parameters.category_id ?: request.getAttribute("productCategoryId");

    // get the product price
    if (cart.isSalesOrder()) {
        // sales order: run the "calculateProductPrice" service
        priceContext = [product : product, currencyUomId : cart.getCurrency(),
                autoUserLogin : autoUserLogin, userLogin : userLogin];
        priceContext.webSiteId = webSiteId;
        priceContext.prodCatalogId = catalogId;
        priceContext.productStoreId = productStoreId;
        priceContext.agreementId = cart.getAgreementId();
        priceContext.partyId = cart.getPartyId();  // IMPORTANT: otherwise it'll be calculating prices using the logged in user which could be a CSR instead of the customer
        priceContext.checkIncludeVat = "Y";
        priceMap = dispatcher.runSync("calculateProductPrice", priceContext);

        context.price = priceMap;
    } else {
        // purchase order: run the "calculatePurchasePrice" service
        priceContext = [product : product, currencyUomId : cart.getCurrency(),
                partyId : cart.getPartyId(), userLogin : userLogin];
        priceMap = dispatcher.runSync("calculatePurchasePrice", priceContext);

        context.price = priceMap;
    }
    /* get current currenct
    if(userLogin == null){
        userLogin = delegator.findByPrimaryKeyCache("UserLogin", [userLoginId : "system"]);
    }
    decimals = UtilNumber.getBigDecimalScale("invoice.decimals");
    rounding = UtilNumber.getBigDecimalRoundingMode("invoice.rounding");

    if(currencyUom.equals(priceMap.currencyUsed)){
        currentPrice = priceMap.price;
        conversionRate = new BigDecimal(1);
    }else{
        results = dispatcher.runSync("getFXConversion", [uomId : priceMap.currencyUsed, uomIdTo : currencyUom, userLogin : userLogin]);
        conversionRate = results.get("conversionRate");
        BigDecimal price = priceMap.price;
        currentPrice = price.multiply(conversionRate).setScale(decimals, rounding);
    }
    context.conversionRate = conversionRate;
    context.currentPrice = currentPrice;*/
    
    // get aggregated product totalPrice
    if ("AGGREGATED".equals(product.productTypeId)) {
        configWrapper = ProductConfigWorker.getProductConfigWrapper(productId, cart.getCurrency(), request);
        if (configWrapper) {
            configWrapper.setDefaultConfig();
            context.totalPrice = configWrapper.getTotalPrice();
        }
    }

    // get the product review(s)
    reviews = product.getRelated("ProductReview", null, ["-postedDateTime"], true)
}

// get the average rating
if (reviews) {
    totalProductRating = 0;
    numRatings = 0;
    reviews.each { productReview ->
        productRating = productReview.productRating;
        if (productRating) {
            totalProductRating += productRating;
            numRatings++;
        }
    }
    if (numRatings) {
        context.averageRating = totalProductRating/numRatings;
        context.numRatings = numRatings;
    }
}

// an example of getting features of a certain type to show
sizeProductFeatureAndAppls = from("ProductFeatureAndAppl").where("productId", productId, "productFeatureTypeId", "SIZE").orderBy("sequenceNum", "defaultSequenceNum").cache(true).queryList()

context.product = product;
context.productStoreId = productStoreId;
context.categoryId = categoryId;
context.productReviews = reviews;
context.sizeProductFeatureAndAppls = sizeProductFeatureAndAppls;
