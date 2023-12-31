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
import org.apache.ofbiz.product.product.ProductContentWrapper
import org.apache.ofbiz.product.catalog.CatalogWorker
import org.apache.ofbiz.entity.condition.EntityConditionBuilder

exprBldr = new EntityConditionBuilder();

webSite = from('WebSite').where('webSiteId', webSiteId).queryOne();
if (webSite) {
    productStore = from('ProductStore').where("productStoreId", webSite.productStoreId).queryOne();
    context.currencyUomId = productStore.defaultCurrencyUomId;
}
baseCond = []
baseCond.add(EntityCondition.makeCondition("uomTypeId", EntityOperator.EQUALS, "WEIGHT_MEASURE"))
baseCond.add(EntityCondition.makeCondition("uomId", EntityOperator.IN, ["WT_kg", "WT_g"]))
weightUomList = EntityQuery.use(delegator).from("Uom").where(baseCond).orderBy("description").queryList();
context.weightUomList = weightUomList;


defaultTopCategoryId = requestParameters.TOP_CATEGORY ? requestParameters.TOP_CATEGORY : EntityUtilProperties.getPropertyValue("catalog", "top.category.default", delegator)
currentTopCategoryId = CategoryWorker.getCatalogTopCategory(request, defaultTopCategoryId)
CategoryWorker.getRelatedCategories(request, "topLevelList", defaultTopCategoryId, false)
context.topLevelList = request.getAttribute("topLevelList")
categoryList = request.getAttribute("topLevelList")
context.productCategoryList = categoryList;

// get promotion category
promoCat = CatalogWorker.getCatalogPromotionsCategoryId(request);
productImageList = [];
if (product) {
    productCategoryCond = exprBldr.AND() {
        EQUALS(productId: product.productId)
        NOT_EQUALS(productCategoryId: promoCat)
    }
    productCategory = from("ProductCategoryMember").where(productCategoryCond).filterByDate().queryFirst();
    if(productCategory){
        catDes = from("ProductCategory").where("productCategoryId", productCategory.productCategoryId).queryOne();
        productCategoryMember = [:]
        productCategoryMember.description = catDes.description;
        productCategoryMember.categoryName = catDes.categoryName;
        productCategoryMember.productCategoryId = catDes.productCategoryId;
        context.productCategoryMember = productCategoryMember;
    }

    supplierProduct = from("SupplierProduct")
                .where('partyId', userLogin.partyId, 'productId', parameters.productId, "currencyUomId", context.currencyUomId)
                .queryFirst()
    if (supplierProduct) {
        context.price = supplierProduct.lastPrice;
    }

    productPrice = from("ProductPrice").where("productId", parameters.productId, "productPriceTypeId", "DEFAULT_PRICE", "productPricePurposeId", "PURCHASE", "currencyUomId", context.currencyUomId).filterByDate().queryFirst()
    if (productPrice) {
        context.salePrice = productPrice.price;
    }

    productContentAndInfo = from("ProductContentAndInfo").where('productId', product.productId, 'productContentTypeId', 'PRODUCT_NAME').filterByDate().queryFirst()
    if (productContentAndInfo) {
        contentAssoc = from("ContentAssoc").where('contentId', productContentAndInfo.contentId).filterByDate().queryFirst()
        if (contentAssoc) {
            serviceInMap = [:]
            serviceInMap.contentId = contentAssoc.contentId
            resultMap = runService("getContentAndDataResource", serviceInMap)
            localeString = resultMap.resultData.content.localeString
            if (localeString.equals("en")) {
                context.dataResourceProdENId = resultMap.resultData.electronicText.dataResourceId
                context.productName = resultMap.resultData.electronicText.textData
            }
            serviceInMap.clear();
            serviceInMap.contentId = contentAssoc.contentIdTo
            resultMap = runService("getContentAndDataResource", serviceInMap)
            localeString = resultMap.resultData.content.localeString
            if (localeString.equals("th")) {
                context.dataResourceProdTHId = resultMap.resultData.electronicText.dataResourceId
                context.productNameTH = resultMap.resultData.electronicText.textData
            }
        }
    }

    productContentAndInfo = from("ProductContentAndInfo").where('productId', product.productId, 'productContentTypeId', 'DESCRIPTION').filterByDate().queryFirst()
    if (productContentAndInfo) {
        contentAssoc = from("ContentAssoc").where('contentId', productContentAndInfo.contentId).filterByDate().queryFirst()
        if (contentAssoc) {
            serviceInMap = [:]
            serviceInMap.contentId = contentAssoc.contentId
            resultMap = runService("getContentAndDataResource", serviceInMap)
            localeString = resultMap.resultData.content.localeString
            electronicText = resultMap.resultData.electronicText
            if (localeString.equals("en") && electronicText) {
                context.dataResourceDescENId = resultMap.resultData.electronicText.dataResourceId
                context.description = resultMap.resultData.electronicText.textData
            }
            serviceInMap.clear();
            serviceInMap.contentId = contentAssoc.contentIdTo
            resultMap = runService("getContentAndDataResource", serviceInMap)
            localeString = resultMap.resultData.content.localeString
            electronicText = resultMap.resultData.electronicText
            if (localeString.equals("th") && electronicText) {
                context.dataResourceDescTHId = resultMap.resultData.electronicText.dataResourceId
                context.descriptionTH = resultMap.resultData.electronicText.textData
            }
        }
    }

    //Get Images
    smallImageConditionList = [];
    smallImageConditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, product.productId));
    smallImageConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "SMALL_IMAGE_ALT"));
    productSmallImageContent = from("ProductContentAndInfo").where(smallImageConditionList).filterByDate().queryFirst();
    if(productSmallImageContent) {
        imageMap = [:];
        imageMap.productImage = productSmallImageContent.drObjectInfo;
        imageMap.contentId = productSmallImageContent.contentId;
        imageMap.fromDate = productSmallImageContent.fromDate;
        imageMap.productContentTypeId = productSmallImageContent.productContentTypeId;
        context.smallImage = imageMap;
    }

    mediumImageConditionList = [];
    mediumImageConditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, product.productId));
    mediumImageConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "MEDIUM_IMAGE_ALT"));
    productMediumImageContent = from("ProductContentAndInfo").where(mediumImageConditionList).filterByDate().queryFirst();
    if(productMediumImageContent) {
        imageMap = [:];
        imageMap.productImage = productMediumImageContent.drObjectInfo;
        imageMap.contentId = productMediumImageContent.contentId;
        imageMap.fromDate = productMediumImageContent.fromDate;
        imageMap.productContentTypeId = productMediumImageContent.productContentTypeId;
        context.mediumImage = imageMap;
    }

    largeImageConditionList = [];
    largeImageConditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, product.productId));
    largeImageConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "LARGE_IMAGE_ALT"));
    productLargeImageContent = from("ProductContentAndInfo").where(largeImageConditionList).filterByDate().queryFirst();
    if(productLargeImageContent) {
        imageMap = [:];
        imageMap.productImage = productLargeImageContent.drObjectInfo;
        imageMap.contentId = productLargeImageContent.contentId;
        imageMap.fromDate = productLargeImageContent.fromDate;
        imageMap.productContentTypeId = productLargeImageContent.productContentTypeId;
        context.largeImage = imageMap;
    }

    addImageConditionList = [];
    addImageConditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, product.productId));
    addImageConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.LIKE, "ADDITIONAL_IMAGE_%"));
    productAddImageContents = from("ProductContentAndInfo").where(addImageConditionList).orderBy("productContentTypeId").filterByDate().queryList();
    if(productAddImageContents) {
        addImage = []
        productAddImageContents.each { productAddImageContent ->
            imageMap = [:];
            imageMap.productImage = productAddImageContent.drObjectInfo;
            imageMap.contentId = productAddImageContent.contentId;
            imageMap.fromDate = productAddImageContent.fromDate;
            imageMap.productContentTypeId = productAddImageContent.productContentTypeId;
            if("ADDITIONAL_IMAGE_1".equals(productAddImageContent.productContentTypeId)) {
                context.additionalImage1 = imageMap;
            } else if("ADDITIONAL_IMAGE_2".equals(productAddImageContent.productContentTypeId)) {
                context.additionalImage2 = imageMap;
            } else if("ADDITIONAL_IMAGE_3".equals(productAddImageContent.productContentTypeId)) {
                context.additionalImage3 = imageMap;
            } else if("ADDITIONAL_IMAGE_4".equals(productAddImageContent.productContentTypeId)) {
                context.additionalImage4 = imageMap;
            }
        }
    }
    context.productImageList = productImageList;

    isDropship = "N"
    if (product.requirementMethodEnumId && product.requirementMethodEnumId.equals("PRODRQM_DS")){
        isDropship = "Y"
    }
    context.isDropship = isDropship;
}
