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

import org.apache.ofbiz.entity.*;
import org.apache.ofbiz.entity.condition.EntityCondition;
import org.apache.ofbiz.entity.condition.EntityOperator;
import org.apache.ofbiz.entity.util.*;
import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.base.util.string.*;
import org.apache.ofbiz.product.image.ScaleImage;
import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.product.category.CategoryWorker

webSite = from('WebSite').where('webSiteId', webSiteId).queryOne();
if (webSite) {
    productStore = from('ProductStore').where("productStoreId", webSite.productStoreId).queryOne();
    context.currencyUomId = productStore.defaultCurrencyUomId;
}

defaultTopCategoryId = requestParameters.TOP_CATEGORY ? requestParameters.TOP_CATEGORY : EntityUtilProperties.getPropertyValue("catalog", "top.category.default", delegator)
currentTopCategoryId = CategoryWorker.getCatalogTopCategory(request, defaultTopCategoryId)
CategoryWorker.getRelatedCategories(request, "topLevelList", defaultTopCategoryId, false)
context.topLevelList = request.getAttribute("topLevelList")
categoryList = request.getAttribute("topLevelList")
context.productCategoryList = categoryList;

productImageList = [];
if (product) {
    productCategory = from("ProductCategoryMember").where("productId", product.productId).filterByDate().queryFirst();
    if(productCategory){
        description = from("ProductCategory").where("productCategoryId", productCategory.productCategoryId).queryOne();
        productCategoryMember = [:]
        productCategoryMember.description = description.description;
        productCategoryMember.productCategoryId = productCategory.productCategoryId;
        context.productCategoryMember = productCategoryMember;
    }

    supplierProduct = from("SupplierProduct")
                .where('partyId', userLogin.partyId, 'productId', parameters.productId)
                .queryFirst()
    if (supplierProduct) {
        context.price = supplierProduct.lastPrice;
    }
    //Get Images
    imConditionList = [];
    imOrConditionList = [];
    imOrConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "IMAGE"));
    imOrConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "DEFAULT_IMAGE"));
    imConditionList.add(EntityCondition.makeCondition(imOrConditionList, EntityOperator.OR));
    imConditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, product.productId));
    imConditionList.add(EntityCondition.makeCondition("drIsPublic", EntityOperator.EQUALS, "Y"));
    productImageAndContentLists = EntityQuery.use(delegator)
            .from("ProductContentAndInfo")
            .where(imConditionList)
            .orderBy("productContentTypeId")
            .queryList();
    if (productImageAndContentLists) {
        productImageAndContentLists.each { productImageAndContentLists ->
            productImageMap = [:];
            contentAssocThumb = EntityUtil.getFirst(delegator.findByAnd("ContentAssocDataResourceViewTo", [contentIdStart : productImageAndContentLists.contentId, caContentAssocTypeId : "IMAGE_THUMBNAIL"], null, false));
            if (contentAssocThumb) {
                productImageMap.productImage = productImageAndContentLists.drObjectInfo;
                productImageMap.productImageThumb = contentAssocThumb.drObjectInfo;
                productImageMap.contentId = productImageAndContentLists.contentId;
                productImageMap.fromDate = productImageAndContentLists.fromDate;
                productImageMap.productContentTypeId = productImageAndContentLists.productContentTypeId;
            }
            productImageList.add(productImageMap);
        }
    }
    context.productImageList = productImageList;
}
