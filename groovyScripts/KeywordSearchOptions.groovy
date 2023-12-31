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

import org.apache.ofbiz.product.catalog.*;
import org.apache.ofbiz.product.category.*;
import org.apache.ofbiz.entity.*;

currentCatalogId = CatalogWorker.getCurrentCatalogId(request);
searchCategoryId = CatalogWorker.getCatalogSearchCategoryId(request, currentCatalogId);
otherSearchProdCatalogCategories = CatalogWorker.getProdCatalogCategories(request, currentCatalogId, "PCCT_OTHER_SEARCH");
currentTopCategoryId = CatalogWorker.getCatalogTopCategoryId(request);
allProductCategories = from("ProductCategoryRollup").where("parentProductCategoryId", currentTopCategoryId).queryList()

searchOperator = request.getParameter("SEARCH_OPERATOR");
if (!"AND".equals(searchOperator) && !"OR".equals(searchOperator)) {
  searchOperator = "OR";
}

if (allProductCategories) {
    catContentWrappers = [:];
    CategoryWorker.getCategoryContentWrappers(catContentWrappers, allProductCategories, request);
    context.catContentWrappers = catContentWrappers;
}
context.currentCatalogId = currentCatalogId;
context.searchCategoryId = searchCategoryId;
context.otherSearchProdCatalogCategories = otherSearchProdCatalogCategories;
context.searchOperator = searchOperator;
context.allProductCategories = allProductCategories;
