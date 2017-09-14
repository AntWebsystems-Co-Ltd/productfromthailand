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

import java.util.*;
import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.entity.*;
import org.apache.ofbiz.product.catalog.CatalogWorker;
import org.apache.ofbiz.product.store.ProductStoreWorker;
import org.apache.ofbiz.common.CommonWorkers;
import org.apache.ofbiz.order.shoppingcart.*;
import org.apache.ofbiz.webapp.control.*;
import org.apache.ofbiz.base.util.UtilHttp;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.util.EntityUtil;
import org.apache.ofbiz.webapp.website.WebSiteWorker

productStore = ProductStoreWorker.getProductStore(request);
productStoreId = ProductStoreWorker.getProductStoreId(request);

currencyUom = ProductStoreWorker.getStoreCurrencyUomId(request);
session.setAttribute("currencyUom", currencyUom);
globalContext.currencyUom = currencyUom;

webSiteId = WebSiteWorker.getWebSiteId(request)

servletContext = session.getServletContext();
servletContext.setAttribute("webSiteId", webSiteId);

cart = ShoppingCartEvents.getCartObject(request);
cart.setCurrency(dispatcher, currencyUom);
lastProductStoreId = cart.getProductStoreId();
if(!lastProductStoreId.equals(productStoreId)){
    if(cart.size() == 0){
        cart.setProductStoreId(productStoreId);
    }
}

prodCatalog = CatalogWorker.getProdCatalog(request);
if (prodCatalog) {
    catalogStyleSheet = prodCatalog.styleSheet;
    if (catalogStyleSheet) globalContext.catalogStyleSheet = catalogStyleSheet;
    catalogHeaderLogo = prodCatalog.headerLogo;
    if (catalogHeaderLogo) globalContext.catalogHeaderLogo = catalogHeaderLogo;
}
globalContext.productStore = productStore;
globalContext.checkLoginUrl = LoginWorker.makeLoginUrl(request, "checkLogin");
globalContext.catalogQuickaddUse = CatalogWorker.getCatalogQuickaddUse(request);
globalContext.productStoreId = productStoreId;

if(userLogin == null)
    globalContext.defaultUserLogin = from("UserLogin").where("userLoginId", "system").queryOne()

currCatalog = session.getAttribute("CURRENT_CATALOG_ID");
if (!currCatalog)
    session.setAttribute("CURRENT_CATALOG_ID", "PFTCatalog");
