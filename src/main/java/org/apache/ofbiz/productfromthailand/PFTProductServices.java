/*******************************************************************************
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
 *******************************************************************************/
package org.apache.ofbiz.productfromthailand;

import java.math.BigDecimal;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.base.util.FileUtil;
import org.apache.ofbiz.base.util.GeneralException;
import org.apache.ofbiz.base.util.UtilGenerics;
import org.apache.ofbiz.base.util.UtilDateTime;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.base.util.UtilValidate;
import org.apache.ofbiz.base.util.string.FlexibleStringExpander;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.condition.EntityCondition;
import org.apache.ofbiz.entity.condition.EntityOperator;
import org.apache.ofbiz.entity.util.EntityQuery;
import org.apache.ofbiz.entity.util.EntityUtilProperties;
import org.apache.ofbiz.product.imagemanagement.ImageManagementServices;
import org.apache.ofbiz.service.GenericServiceException;
import org.apache.ofbiz.service.LocalDispatcher;

/**
 * Product Services
 */
public class PFTProductServices {
    public static final String module = PFTProductServices.class.getName();
    public static final String err_resource = "ContentErrorUiLabels";
    private static List<Map<String,Object>> josonMap = null;
    public static String createProductAndUploadMultiImage(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
        HttpSession session = request.getSession(true);
        GenericValue userLogin = (GenericValue) session.getAttribute("userLogin");
        ServletFileUpload fu = new ServletFileUpload(new DiskFileItemFactory(10240, FileUtil.getFile("runtime/tmp")));
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        List<FileItem> lst = null;
        Map<String, Object> productIdResult = null;
        Map<String, Object> createPriceResult = null;
        Map<String, Object> supplierProductResult = null;
        Map<String, Object> productCategoryResult = null;
        Map<String, Object> formInput = new HashMap<String, Object>();
        Map<String, Object> ProductFacilityParams = new HashMap<String, Object>();
        String productId = null;
        String manufacturingEnabled = EntityUtilProperties.getPropertyValue("growerp", "manufacturingEnabled", delegator);
        String imageServerPath = FlexibleStringExpander.expandString(EntityUtilProperties.getPropertyValue("catalog", "image.management.path", delegator), UtilMisc.toMap("userLoginId", userLogin.getString("userLoginId")));
        String imageServerUrl = FlexibleStringExpander.expandString(EntityUtilProperties.getPropertyValue("catalog", "image.management.url", delegator), UtilMisc.toMap("userLoginId", userLogin.getString("userLoginId")));
        List<String> sizeTypeList = UtilMisc.toList("small", "medium", "large");

        try {
           lst = UtilGenerics.checkList(fu.parseRequest(request));
        } catch (FileUploadException e4) {
            Debug.logError(e4.toString(), module);
            return "error";
        }
        FileItem fi = null;
        FileItem imageFi = null;
        byte[] imageBytes = {};
        for (int i=0; i < lst.size(); i++) {
            fi = lst.get(i);
            String fieldName = fi.getFieldName();
            if (fi.isFormField()) {
                formInput.put(fieldName, new String(fi.getString().getBytes("ISO-8859-1"), "UTF-8"));
            }
        }
        try {
            String priceStr = (String) formInput.get("price");
            BigDecimal priceb = new BigDecimal(priceStr);
            Map<String, Object> fieldMap = UtilMisc.toMap("productId", formInput.get("productId"), "description", formInput.get("description"), "productTypeId", formInput.get("productCategoryId"),"internalName"
                , formInput.get("internalName"), "productTypeId", formInput.get("productTypeId"), "productName", formInput.get("internalName"), "requirementMethodEnumId", "PRODRQM_DS", "userLogin", userLogin);
            if (formInput.get("isCreate").equals("Y")) {
                if (formInput.get("productId") != null) {
                    GenericValue product = delegator.findOne("Product", UtilMisc.toMap("productId", formInput.get("productId")), true);
                    if (UtilValidate.isEmpty(product)) {
                        productIdResult = dispatcher.runSync("createProduct", fieldMap);
                        productId = (String) productIdResult.get("productId");
                    } else {
                        request.setAttribute("prodId", formInput.get("productId"));
                        request.setAttribute("prodName", formInput.get("internalName"));
                        request.setAttribute("prodDesc", formInput.get("description"));
                        request.setAttribute("prodCat", formInput.get("productCategoryId"));
                        request.setAttribute("prodDefaultPrice", formInput.get("defaultPrice"));
                        request.setAttribute("prodTypeId", formInput.get("productTypeId"));
                        request.setAttribute("isError", "Y");
                        request.setAttribute("_ERROR_MESSAGE_", "Product ID already exists.");
                        return "error";
                    }
                } else {
                    productIdResult = dispatcher.runSync("createProduct", fieldMap);
                    productId = (String) productIdResult.get("productId");
                }
                if (productId != null) {
                    /*Create Default Price*/
                    Map<String, Object> productPriceMap = UtilMisc.toMap("productId", productId, "price", priceb, "productPriceTypeId", "DEFAULT_PRICE"
                        , "productPricePurposeId", "PURCHASE", "currencyUomId", formInput.get("currencyUomId"), "productStoreGroupId", "_NA_", "userLogin", userLogin);
                    createPriceResult = dispatcher.runSync("createProductPrice", productPriceMap);

                    /*Create Supplier Product*/
                    Map<String, Object> supplierProductMap = UtilMisc.toMap("productId", productId, "lastPrice", priceb, "partyId", userLogin.getString("partyId")
                        , "supplierProductId", userLogin.getString("partyId"), "currencyUomId", formInput.get("currencyUomId"), "minimumOrderQuantity", new BigDecimal("0"),"availableFromDate", UtilDateTime.nowTimestamp(), "canDropShip", "Y", "userLogin", userLogin);
                    supplierProductResult = dispatcher.runSync("createSupplierProduct", supplierProductMap);

                    /*Create Product Category Member*/
                    Map<String, Object> productCategoryMap = UtilMisc.toMap("productId", productId, "fromDate", UtilDateTime.nowTimestamp(), "productCategoryId", formInput.get("productCategoryId"), "userLogin", userLogin);
                    productCategoryResult = dispatcher.runSync("safeAddProductToCategory", productCategoryMap);
                }
            } else {
                dispatcher.runSync("updateProduct", fieldMap);
                productId = (String) formInput.get("productId");
                /*Update Default Price*/
                GenericValue productPrice = EntityQuery.use(delegator).from("ProductPrice")
                            .where("productId", formInput.get("productId"),
                                    "productPriceTypeId", "DEFAULT_PRICE",
                                    "productPricePurposeId", "PURCHASE",
                                    "currencyUomId", formInput.get("currencyUomId"))
                            .orderBy("-fromDate").filterByDate().queryFirst();
                Map<String, Object> productPriceMap = UtilMisc.toMap("productId", productId, "price", priceb, "productPriceTypeId", "DEFAULT_PRICE", "fromDate", productPrice.getTimestamp("fromDate")
                    , "productPricePurposeId", "PURCHASE", "currencyUomId", formInput.get("currencyUomId"), "productStoreGroupId", "_NA_", "userLogin", userLogin);
                createPriceResult = dispatcher.runSync("updateProductPrice", productPriceMap);

                /*Update Supplier Product*/
                GenericValue supplierPrice = EntityQuery.use(delegator).from("SupplierProduct")
                            .where("productId", formInput.get("productId"),
                                    "partyId", userLogin.getString("partyId"),
                                    "currencyUomId", formInput.get("currencyUomId"))
                            .orderBy("-availableFromDate").queryFirst();
                Map<String, Object> supplierProductMap = UtilMisc.toMap("productId", productId, "lastPrice", priceb, "partyId", userLogin.getString("partyId")
                    , "supplierProductId", userLogin.getString("partyId"), "currencyUomId", formInput.get("currencyUomId"), "minimumOrderQuantity", new BigDecimal("0"),"availableFromDate", supplierPrice.getTimestamp("availableFromDate"), "canDropShip", "Y", "userLogin", userLogin);
                supplierProductResult = dispatcher.runSync("updateSupplierProduct", supplierProductMap);

                /*Product Category Member*/
                GenericValue categoryMember = EntityQuery.use(delegator).from("ProductCategoryMember")
                            .where("productId", formInput.get("productId"))
                            .filterByDate().queryFirst();
                if(categoryMember != null){
                    if(!formInput.get("productCategoryId").equals(categoryMember.get("productCategoryId"))){
                        Map<String, Object> productCategoryMap = UtilMisc.toMap("productId", productId, "fromDate", categoryMember.getTimestamp("fromDate"), "productCategoryId", categoryMember.get("productCategoryId"), "userLogin", userLogin);
                        productCategoryResult = dispatcher.runSync("removeProductFromCategory", productCategoryMap);
                        if("success".equals(productCategoryResult.get("responseMessage"))){
                            Map<String, Object> newProductCategoryMap = UtilMisc.toMap("productId", productId, "fromDate", UtilDateTime.nowTimestamp(), "productCategoryId", formInput.get("productCategoryId"), "userLogin", userLogin);
                            productCategoryResult = dispatcher.runSync("safeAddProductToCategory", newProductCategoryMap);
                        }
                    }
                } else {
                    /*Create Product Category Member*/
                    Map<String, Object> productCategoryMap = UtilMisc.toMap("productId", productId, "fromDate", UtilDateTime.nowTimestamp(), "productCategoryId", formInput.get("productCategoryId"), "userLogin", userLogin);
                    productCategoryResult = dispatcher.runSync("safeAddProductToCategory", productCategoryMap);
                }
            }
            FileItem fi2 = null;
            for (int i=0; i < lst.size(); i++) {
                fi2 = lst.get(i);
                String fieldName = fi2.getFieldName();
                if (fieldName.startsWith("uploadedFile")) {
                    //Check for existing images for this product, if not, current image is the default one
                    String productContentTypeId = "IMAGE";
                    List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
                    List<EntityCondition> orConditionList = new ArrayList<EntityCondition>();
                    orConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "IMAGE"));
                    orConditionList.add(EntityCondition.makeCondition("productContentTypeId", EntityOperator.EQUALS, "DEFAULT_IMAGE"));
                    conditionList.add(EntityCondition.makeCondition(orConditionList, EntityOperator.OR));
                    conditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productId));

                    List<GenericValue> productContent = EntityQuery.use(delegator)
                            .from("ProductContent")
                            .where(conditionList)
                            .cache(false)
                            .queryList();
                    if (UtilValidate.isEmpty(productContent)) {
                        productContentTypeId = "DEFAULT_IMAGE";
                    }

                    Map<String, Object> passedParams = new HashMap<String, Object>();
                    Map<String, Object> contentLength = new HashMap<String, Object>();
                    if(josonMap == null){
                         josonMap = new LinkedList<Map<String,Object>>();
                    }
                    imageFi = fi2;
                    String fileName = fi2.getName();
                    fileName = fileName.replaceAll(" ", "_");
                    String contentType = fi2.getContentType();
                    imageBytes = imageFi.get();
                    ByteBuffer byteWrap = ByteBuffer.wrap(imageBytes);
                    if (imageFi.getSize() > 0) {
                        passedParams.put("userLogin", userLogin);
                        passedParams.put("productId", productId);
                        passedParams.put("productContentTypeId", productContentTypeId);
                        passedParams.put("_uploadedFile_contentType", contentType);
                        passedParams.put("uploadedFile", byteWrap);
                        passedParams.put("_uploadedFile_fileName", fileName);
                        contentLength.put("imageSize", imageFi.getSize());
                        josonMap.add(contentLength);
                        if (passedParams.get("productId") != null) {
                            try {
                                dispatcher.runSync("addMultipleuploadForProduct", passedParams);
                            } catch (GenericServiceException e) {
                                return e.getMessage();
                            }
                        }
                        if (productContentTypeId.equals("DEFAULT_IMAGE")) {
                            //Loop thru all image sizes
                            for (String sizeType : sizeTypeList) {
                                String fileNameToUse = new StringBuilder(fileName).insert(fileName.lastIndexOf("."), "-" + sizeType).toString();

                                String targetDirectory = imageServerPath + "/" + productId;
                                File targetDir = new File(targetDirectory);
                                if (!targetDir.exists()) {
                                    boolean created = targetDir.mkdirs();
                                    if (!created) {
                                        String errMsg = "Cannot create the target directory";
                                        Debug.logFatal(errMsg, module);
                                        return errMsg;
                                    }
                                }
                                File file = new File(imageServerPath + "/" + productId + "/" + fileNameToUse);
                                file = ImageManagementServices.checkExistsImage(file);
                                try {
                                    RandomAccessFile out = new RandomAccessFile(file, "rw");
                                    out.write(byteWrap.array());
                                    out.close();
                                } catch (FileNotFoundException e) {
                                    Debug.logError(e, module);
                                    return e.getMessage();
                                } catch (IOException e) {
                                    Debug.logError(e, module);
                                    return e.getMessage();
                                }
                                //Set the image url in the Product entity
                                String imageUrl = null;
                                switch (sizeType) {
                                case "small":
                                    imageUrl = "smallImageUrl";
                                    break;
                                case "medium":
                                    imageUrl = "mediumImageUrl";
                                    break;
                                case "large":
                                    imageUrl = "largeImageUrl";
                                    break;
                                }
                                GenericValue product = EntityQuery.use(delegator)
                                        .from("Product")
                                        .where("productId", productId)
                                        .queryOne();
                                product.set(imageUrl, imageServerUrl + "/" + productId + "/" + fileNameToUse);
                                product.store();
                            }
                        }
                    }
                }
            }
            request.setAttribute("productId", productId);
            return "success";
        } catch (GeneralException e) {
            Debug.logError(e.toString(), module);
            return "error";
        }
    }
}