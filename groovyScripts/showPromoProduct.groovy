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
 * NOTE: This script is also referenced by the ecommerce's screens and
 * should not contain order component's specific code.
 */

import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.entity.*;
import org.apache.ofbiz.service.*;
import org.apache.ofbiz.product.catalog.*;
import org.apache.ofbiz.product.category.CategoryContentWrapper;
import org.apache.ofbiz.product.store.ProductStoreWorker;

productCategoryId = request.getAttribute("productCategoryId");
context.productCategoryId = productCategoryId;

viewSize = parameters.VIEW_SIZE;
viewIndex = parameters.VIEW_INDEX;
currentCatalogId = CatalogWorker.getCurrentCatalogId(request);

// set the default view size
defaultViewSize = request.getAttribute("defaultViewSize") ?: 10;
context.defaultViewSize = defaultViewSize;

// set the limit view
limitView = request.getAttribute("limitView") ?: true;
context.limitView = limitView;

// get the product category & members
andMap = [productCategoryId : productCategoryId,
        viewIndexString : viewIndex,
        viewSizeString : viewSize,
        defaultViewSize : defaultViewSize,
        limitView : limitView];
andMap.put("prodCatalogId", currentCatalogId);
andMap.put("checkViewAllow", true);
if (context.orderByFields) {
    andMap.put("orderByFields", context.orderByFields);
} else {
    andMap.put("orderByFields", ["sequenceNum", "productId"]);
}
catResult = dispatcher.runSync("getProductCategoryAndLimitedMembers", andMap);

productCategory = catResult.productCategory;

promoShowLimit = 6;
//now slim it down to promoShowLimit
productCategoryMembersRandomTemp = new ArrayList(catResult.productCategoryMembers);
productCategoryMembers = null;
if (productCategoryMembersRandomTemp.size() > promoShowLimit) {
    productCategoryMembers = new ArrayList(promoShowLimit);
    for (i = 0; i < promoShowLimit; i++) {
        randomIndex = Math.round(java.lang.Math.random() * (productCategoryMembersRandomTemp.size() - 1)) as int;
        productCategoryMembers.add(productCategoryMembersRandomTemp.remove(randomIndex));
    }
} else {
    productCategoryMembers = productCategoryMembersRandomTemp;
}

// Prevents out of stock product to be displayed on site
productStore = ProductStoreWorker.getProductStore(request);
if(productStore) {
    if("N".equals(productStore.showOutOfStockProducts)) {
        productsInStock = [];
        productCategoryMembers.each { productCategoryMember ->
            productFacility = delegator.findOne("ProductFacility", [productId : productCategoryMember.productId, facilityId : productStore.inventoryFacilityId], true);
            if(productFacility) {
                if(productFacility.lastInventoryCount >= 1) {
                    productsInStock.add(productCategoryMember);
                }
            }
        }
        context.productCategoryMembers = productsInStock;
    } else {
        context.productCategoryMembers = productCategoryMembers;
    }
}
context.productCategory = productCategory;
context.viewIndex = catResult.viewIndex;
context.viewSize = catResult.viewSize;
context.lowIndex = catResult.lowIndex;
context.highIndex = catResult.highIndex;
context.listSize = catResult.listSize;

// set this as a last viewed
// DEJ20070220: WHY is this done this way? why not use the existing CategoryWorker stuff?
LAST_VIEWED_TO_KEEP = 10; // modify this to change the number of last viewed to keep
lastViewedCategories = session.getAttribute("lastViewedCategories");
if (!lastViewedCategories) {
    lastViewedCategories = [];
    session.setAttribute("lastViewedCategories", lastViewedCategories);
}
lastViewedCategories.remove(productCategoryId);
lastViewedCategories.add(0, productCategoryId);
while (lastViewedCategories.size() > LAST_VIEWED_TO_KEEP) {
    lastViewedCategories.remove(lastViewedCategories.size() - 1);
}

// set the content path prefix
contentPathPrefix = CatalogWorker.getContentPathPrefix(request);
context.put("contentPathPrefix", contentPathPrefix);

// little routine to see if any members have a quantity > 0 assigned
members = context.get("productCategoryMembers");
if (UtilValidate.isNotEmpty(members)) {
    for (i = 0; i < members.size(); i++) {
        productCategoryMember = (GenericValue) members.get(i);
        if (productCategoryMember.get("quantity") != null && productCategoryMember.getDouble("quantity").doubleValue() > 0.0) {
            context.put("hasQuantities", new Boolean(true));
            break;
        }
    }
}

CategoryContentWrapper categoryContentWrapper = new CategoryContentWrapper(productCategory, request);
context.put("categoryContentWrapper", categoryContentWrapper);
