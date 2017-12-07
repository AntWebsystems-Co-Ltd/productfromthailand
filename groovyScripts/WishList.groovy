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

import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.entity.util.EntityUtil
import org.apache.ofbiz.product.catalog.CatalogWorker
import org.apache.ofbiz.product.store.ProductStoreWorker
import org.apache.ofbiz.webapp.website.WebSiteWorker

wishLists = []
products = [];

shoppingLists = from("ShoppingList").where([shoppingListTypeId: "SLT_WISH_LIST", partyId: userLogin.partyId]).queryList();
if (shoppingLists.size() != 0) {
    shoppingList = EntityUtil.getFirst(shoppingLists);
    shoppingListItems = from("ShoppingListItem").where([shoppingListId: shoppingList.shoppingListId])
            .orderBy("-createdStamp").queryList()
    shoppingListItems.each { shoppingListItem ->
        product = from("Product").where([productId: shoppingListItem.productId]).queryOne()
        wishLists.add([productId: shoppingListItem.productId, productName: product.productName,
                       date: shoppingListItem.createdStamp,
                       shoppingListId: shoppingListItem.shoppingListId,
                       shoppingListItemSeqId: shoppingListItem.shoppingListItemSeqId,
                       introductionDate: product.introductionDate,
                       salesDiscontinuationDate: product.salesDiscontinuationDate,
                       productTypeId: product.productTypeId,
                       isVirtual: product.isVirtual,
                       requireAmount: product.requireAmount])
        products.add(product)
    }
}
context.wishLists = wishLists

autoUserLogin = session.getAttribute("autoUserLogin")
userLogin = session.getAttribute("userLogin")
webSiteId = WebSiteWorker.getWebSiteId(request)
catalogId = CatalogWorker.getCurrentCatalogId(request)
priceList = [];
productList = [];
if (products) {
    products.each { product ->
        productMap = [:];

        // sales order: run the "calculateProductPrice" service
        priceContext = [product : product, autoUserLogin : autoUserLogin, userLogin : userLogin]
        priceContext.webSiteId = webSiteId
        priceContext.prodCatalogId = catalogId
        priceContext.productStoreId = ProductStoreWorker.getProductStore(request).productStoreId;
        priceContext.currencyUomId = ProductStoreWorker.getProductStore(request).getString("defaultCurrencyUomId")
        priceContext.partyId = userLogin.partyId // IMPORTANT: otherwise it'll be calculating prices using the logged in user which could be a CSR instead of the customer
        priceContext.checkIncludeVat = "Y"
        priceMap = runService('calculateProductPrice', priceContext)

        categoryId = parameters.category_id ?: request.getAttribute("productCategoryId") ?: null;

        productMap.put("product", product);
        productMap.put("price", priceMap);
        productMap.put("categoryId", categoryId);
        productList.add(productMap);
    }
}
context.productLists = productList;

// set the content path prefix
contentPathPrefix = CatalogWorker.getContentPathPrefix(request)
context.contentPathPrefix = contentPathPrefix
