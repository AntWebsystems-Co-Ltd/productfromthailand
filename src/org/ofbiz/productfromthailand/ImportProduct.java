package org.ofbiz.productfromthailand;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.ofbiz.base.util.*;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntity;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityConditionList;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

public class ImportProduct {
    
    public static final String module = ImportProduct.class.getName();
    public static final String resource = "ProductFromThailandUiLabels";
    
    public static String importProductFromSpreadsheet(HttpServletRequest request, HttpServletResponse response){
        Locale locale = UtilHttp.getLocale(request);
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        HttpSession session = request.getSession();
        GenericValue userLogin = (GenericValue) session.getAttribute("userLogin");
        
        ServletFileUpload dfu = new ServletFileUpload(new DiskFileItemFactory(10470, FileUtil.getFile("runtime/tmp")));
        java.util.List lst = null;
        
        try {
            lst = dfu.parseRequest(request);
        } catch (FileUploadException e) {
            request.setAttribute("_ERROR_MESSAGE_", e.getMessage());
            Debug.logError("[ImportProduct.importProductFromSpreadsheet] " + e.getMessage(), module);
            return "error";
        }
        if (Debug.infoOn()) Debug.logInfo("[ImportProduct.importProductFromSpreadsheet]+lst " + lst, module);
        
        if (lst.size() == 0) {
            request.setAttribute("_ERROR_MESSAGE_", "No files uploaded");
            Debug.logWarning("[ImportProduct.importProductFromSpreadsheet] No files uploaded", module);
            return "error";
        }
        Map passedParams = FastMap.newInstance();
        FileItem fi = null;
        FileItem sheetnameFi = null;
        String filename = null;
        
        byte[] sheetBytes = {};
        for (int i = 0; i < lst.size(); i++) {
            fi = (FileItem) lst.get(i);
            String fieldName = fi.getFieldName();
            if (fi.isFormField()) {
                String fieldStr = fi.getString();
                passedParams.put(fieldName, fieldStr);
            } else if (fieldName.equals("fname")) {
                sheetnameFi = fi;
                sheetBytes = sheetnameFi.get();
                filename = fi.getName();
            }
        }
        
        long originalSize = sheetnameFi.getSize();

        String supplierPartyId = (String) passedParams.get("supplierPartyId");
        if (UtilValidate.isEmpty(supplierPartyId)) {
            supplierPartyId = (String) userLogin.get("partyId");
        }

        File localPathFile = new File(System.getProperty("ofbiz.home")+"/runtime/uploads");
        if (!localPathFile.exists()) {
            localPathFile.mkdir();
        }
        
        File uploadFileName = new File(localPathFile +"/"+ filename);
        try {
            sheetnameFi.write(uploadFileName);
        } catch (Exception e) {
            Debug.logError("Unable to write workbook from upload file", module);
            return "error";
        }
        
        long byteSize = uploadFileName.length();
        if(originalSize != byteSize){
            uploadFileName.delete();
            request.setAttribute("_ERROR_MESSAGE_", "Problem in uploading product from spreadsheet. Please try again");
            return "error";
        }
        // read all xls file and create workbook one by one.
        List<Map<String, Object>> products = FastList.newInstance();
        List<Map<String, Object>> supplierProducts = FastList.newInstance();
        List<Map<String, Object>> productPrices = FastList.newInstance();
        List<Map<String, Object>> pNameEnDataResources = FastList.newInstance();
        List<Map<String, Object>> pNameThDataResources = FastList.newInstance();
        List<Map<String, Object>> pNameEnContents = FastList.newInstance();
        List<Map<String, Object>> pNameThContents = FastList.newInstance();
        List<Map<String, Object>> pDescEnDataResources = FastList.newInstance();
        List<Map<String, Object>> pDescThDataResources = FastList.newInstance();
        List<Map<String, Object>> pDescEnContents = FastList.newInstance();
        List<Map<String, Object>> pDescThContents = FastList.newInstance();
        List<Map<String, Object>> pNameProductContents = FastList.newInstance();
        List<Map<String, Object>> pDescProductContents = FastList.newInstance();
        List<Map<String, Object>> pNameDataAndContents = FastList.newInstance();
        List<Map<String, Object>> pDescDataAndContents = FastList.newInstance();
        
        POIFSFileSystem fs = null;
        HSSFWorkbook wb = null;
        try {
            fs = new POIFSFileSystem(new FileInputStream(uploadFileName));
            wb = new HSSFWorkbook(fs);
        } catch (IOException e) {
            request.setAttribute("_ERROR_MESSAGE_", "Unable to read or create workbook from file");
            Debug.logError("Unable to read or create workbook from file", module);
            return "error";
        }
        
        for( int i=0; i<wb.getNumberOfSheets(); i++ ){
            // get sheet one by one
            HSSFSheet sheet = wb.getSheetAt(i);
            int sheetLastRowNumber = sheet.getLastRowNum();
            for (int j = 1; j <= sheetLastRowNumber; j++) {
                HSSFRow row = sheet.getRow(j);
                if (row != null) {
                    String productId = null;
                    // starts from 0"
                    // read supplierProductId from first column
                    HSSFCell cell0 = row.getCell((int) 0);
                    String supplierProductId = null;
                    if(UtilValidate.isNotEmpty(cell0)){
                        supplierProductId= toStringValue(cell0);
                    }
                    if(supplierProductId == null){
                        supplierProductId = "SP_" + productId;
                    }else{
                        List<GenericValue> supplierProductList = null;
                        try {
                            supplierProductList = delegator.findByAnd("SupplierProduct", UtilMisc.toMap("supplierProductId", supplierProductId));
                        } catch (GenericEntityException e) {
                            request.setAttribute("_ERROR_MESSAGE_", "Error getting SupplierProduct.");
                        }
                        if(supplierProductList != null && supplierProductList.size()>0){
                            GenericValue supplierProduct = EntityUtil.getFirst(supplierProductList);
                            productId = supplierProduct.getString("productId");
                        }
                    }
                    if(productId == null){
                        productId = delegator.getNextSeqId("Product");
                    }
                    
                    // read productName from second column
                    HSSFCell cell1 = row.getCell((int) 1);
                    String productName = null;
                    if(UtilValidate.isNotEmpty(cell1)){
                        cell1.setCellType(HSSFCell.CELL_TYPE_STRING);
                        productName = cell1.getRichStringCellValue().toString();
                    }
                    
                    // read productName in Thai language from third column
                    HSSFCell cell2 = row.getCell((int) 2);
                    String productNameTH = null;
                    if(UtilValidate.isNotEmpty(cell2)){
                        cell2.setCellType(HSSFCell.CELL_TYPE_STRING);
                        productNameTH  = cell2.getRichStringCellValue().toString();
                    }
                    
                    HSSFCell cell3 = row.getCell((int) 3);
                    String internalName = null;
                    if(UtilValidate.isNotEmpty(cell3)){
                        cell3.setCellType(HSSFCell.CELL_TYPE_STRING);
                        internalName = cell3.getRichStringCellValue().toString();
                    }
                    if(internalName == null){
                        internalName = "Product_" + productId;
                    }
                    
                    HSSFCell cell4 = row.getCell((int) 4);
                    String description = null;
                    if(UtilValidate.isNotEmpty(cell4)){
                        cell4.setCellType(HSSFCell.CELL_TYPE_STRING);
                        description = cell4.getRichStringCellValue().toString();
                    }
                    
                    HSSFCell cell5 = row.getCell((int) 5);
                    String descriptionTH = null;
                    if(UtilValidate.isNotEmpty(cell5)){
                        cell5.setCellType(HSSFCell.CELL_TYPE_STRING);
                        descriptionTH = cell5.getRichStringCellValue().toString();
                    }
                    
                    // read price from eighth column
                    HSSFCell cell6 = row.getCell((int) 6);
                    BigDecimal price = BigDecimal.ZERO;
                    if (cell6 != null && cell6.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                        price = new BigDecimal(cell6.getNumericCellValue());
                    
                    HSSFCell cell7 = row.getCell((int) 7);
                    BigDecimal supplierPrice = BigDecimal.ZERO;
                    if (cell7 != null && cell7.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                        supplierPrice = new BigDecimal(cell7.getNumericCellValue());
                    
                    Map<String,Object> priceData =  FastMap.newInstance();
                    if (productId != null && !productId.trim().equalsIgnoreCase("")) {
                        products.add(prepareProduct(productId, internalName, userLogin));
                        
                        // create ProductContent for product name & description in Thai and Eng language
                        if(productName != null){
                            String pNameEnDataResourceId = null;
                            String pNameThDataResourceId = null;
                            boolean pNameContentExists = false;
                            // check if a ProductContent already exists update it, otherwise create new one
                            if(!checkProductContentExists(productId, "PRODUCT_NAME", delegator)){
                                pNameEnDataResourceId = productId + "-PNAMEEN";
                                pNameThDataResourceId = productId + "-PNAMETH";
                            }else{
                                // update DataResource
                                pNameContentExists = true;
                                pNameEnDataResourceId = getDataResourceId(productId , "PRODUCT_NAME", "en" , delegator);
                                pNameThDataResourceId = getDataResourceId(productId , "PRODUCT_NAME", "th" , delegator);
                            }
                            
                            pNameEnDataResources.add(prepareDataResource(pNameEnDataResourceId, "en", productName , userLogin));
                            pNameEnContents.add(prepareContent(pNameEnDataResourceId, "en", userLogin));
                            if(productNameTH != null){
                                pNameThDataResources.add(prepareDataResource(pNameThDataResourceId, "th", productNameTH , userLogin));
                                pNameThContents.add(prepareContent(pNameThDataResourceId, "th", userLogin));
                            }
                            Map<String, Object> context = FastMap.newInstance();
                            context.put("productId", productId);
                            pNameDataAndContents.add(context);

                            if(!pNameContentExists)
                                pNameProductContents.add(prepareProductContent(productId, pNameEnDataResourceId, "PRODUCT_NAME", userLogin));
                        }
                        if(description != null){
                            String pDescEnDataResourceId = null;
                            String pDescThDataResourceId = null;
                            boolean contentExists = false;
                            // check if description in ProductContent already exists update it, otherwise create new one
                            if(!checkProductContentExists(productId, "DESCRIPTION", delegator)){
                                pDescEnDataResourceId = productId + "-DESCEN";
                                pDescThDataResourceId = productId + "-DESCTH";
                            }else{
                                // update DataResource
                                contentExists = true;
                                pDescEnDataResourceId = getDataResourceId(productId , "DESCRIPTION", "en" , delegator);
                                pDescThDataResourceId = getDataResourceId(productId , "DESCRIPTION", "th" , delegator);
                            }
                            
                            pDescEnDataResources.add(ImportProduct.prepareDataResource(pDescEnDataResourceId, "en", description , userLogin));
                            pDescEnContents.add(prepareContent(pDescEnDataResourceId, "en", userLogin));
                            if(descriptionTH != null){
                                pDescThDataResources.add(ImportProduct.prepareDataResource(pDescThDataResourceId, "th", descriptionTH , userLogin));
                                pDescThContents.add(prepareContent(pDescThDataResourceId, "th", userLogin));
                            }
                            Map<String, Object> context = FastMap.newInstance();
                            context.put("productId", productId);
                            pDescDataAndContents.add(context);
                            if(!contentExists)
                                pDescProductContents.add(prepareProductContent(productId, pDescEnDataResourceId, "DESCRIPTION", userLogin));
                        }
                    
                        if (!checkSupplierProductExists(productId, delegator)) {
                            if(supplierProductId == null)
                                supplierProductId = "SP-"+productId;
                            supplierProducts.add(prepareSupplierProduct(productId, supplierProductId, supplierPartyId, supplierPrice
                                    , UtilDateTime.nowTimestamp(), BigDecimal.ZERO, "THB" , userLogin));
                        }else{
                            List<GenericValue> tmpSupplierProducts = null;
                            try {
                                tmpSupplierProducts = delegator.findByAnd("SupplierProduct", UtilMisc.toMap("productId", productId));
                            } catch (GenericEntityException e) {
                                request.setAttribute("_ERROR_MESSAGE_", "Error getting SupplierProduct.");
                            }
                            GenericValue supplierProductGV = EntityUtil.getFirst(tmpSupplierProducts);
                            supplierProducts.add(prepareSupplierProduct(productId, supplierProductGV.getString("supplierProductId"), supplierPartyId, supplierPrice,
                                    (Timestamp) supplierProductGV.get("availableFromDate"),(BigDecimal) supplierProductGV.get("minimumOrderQuantity"), supplierProductGV.getString("currencyUomId"), userLogin));
                        }
                        
                        Map<String, ?> productPriceCtx = checkProductPriceExists(productId, delegator);
                        Boolean productPriceExists = (Boolean) productPriceCtx.get("productPriceExists");
                        if (!productPriceExists) {
                            priceData.put("productId", productId);
                            priceData.put("price", price);
                            priceData.put("productPriceTypeId","DEFAULT_PRICE");
                            priceData.put("currencyUomId", "THB");
                            priceData.put("productStoreGroupId","_NA_");
                            priceData.put("fromDate",UtilDateTime.nowTimestamp());
                            priceData.put("productPricePurposeId","PURCHASE");
                            
                        }else{
                            GenericValue productPriceGV = (GenericValue) productPriceCtx.get("productPriceGV");
                            priceData.put("productId", productId);
                            priceData.put("price", price);
                            priceData.put("productPriceTypeId", productPriceGV.get("productPriceTypeId"));
                            priceData.put("currencyUomId", productPriceGV.get("currencyUomId"));
                            priceData.put("productStoreGroupId", productPriceGV.get("productStoreGroupId"));
                            priceData.put("fromDate", productPriceGV.get("fromDate"));
                            priceData.put("productPricePurposeId", productPriceGV.get("productPricePurposeId"));
                        }
                        priceData.put("userLogin", userLogin);
                        productPrices.add(priceData);
                    }
//                    int rowNum = row.getRowNum() + 1;
//                    if (row.toString() != null && !row.toString().trim().equalsIgnoreCase("") && productExists) {
//                        Debug.logWarning("Row number " + rowNum + " not imported from " + sheetnameFi.getName(), module);
//                    }
                }
            }
        }
        // create and store values in "Product" entity
        // in database
        for (int j = 0; j < products.size(); j++) {
            Map<String, Object> tmpProduct = products.get(j);
            String tmpProductId = (String) tmpProduct.get("productId");
            if (!checkProductExists(tmpProductId, delegator)) {
                 try {
                     Map<String, Object> createProductResult = dispatcher.runSync("createProduct", products.get(j));
                     if (ServiceUtil.isError(createProductResult)) {
                         request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createProductResult));
                         return "error";
                     }
                 } catch (GenericServiceException e) {
                     String errMsg = "Error update product : " + e.toString();
                     request.setAttribute("_ERROR_MESSAGE_", errMsg);
                     return "error";
                 }
            }else{
                try {
                    Map<String, Object> updateProductResult = dispatcher.runSync("updateProduct", products.get(j));
                    if (ServiceUtil.isError(updateProductResult)) {
                        request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(updateProductResult));
                        return "error";
                    }
                } catch (GenericServiceException e) {
                    String errMsg = "Error update product : " + e.toString();
                    request.setAttribute("_ERROR_MESSAGE_", errMsg);
                    return "error";
                }
            }
           
            // create/update values in "SupplierProduct" entity
            if (!checkSupplierProductExists(tmpProductId, delegator)) {
                try {
                    Map<String, Object> createSupplierProductResult = dispatcher.runSync("createSupplierProduct", supplierProducts.get(j));
                    if (ServiceUtil.isError(createSupplierProductResult)) {
                        request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createSupplierProductResult));
                        return "error";
                    }
                } catch (GenericServiceException e) {
                    String errMsg = "Error update product : " + e.toString();
                    request.setAttribute("_ERROR_MESSAGE_", errMsg);
                    return "error";
                }
            }else{
                try {
                    Map<String, Object> updateSupplierProductResult = dispatcher.runSync("updateSupplierProduct", supplierProducts.get(j));
                    if (ServiceUtil.isError(updateSupplierProductResult)) {
                        request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(updateSupplierProductResult));
                        return "error";
                    }
                } catch (GenericServiceException e) {
                    String errMsg = "Error update product : " + e.toString();
                    request.setAttribute("_ERROR_MESSAGE_", errMsg);
                    return "error";
                }
            }
            
            // create/update values in "ProductPrice" entity
            Map<String, ?> productPriceCtx = ImportProduct.checkProductPriceExists(tmpProductId, delegator);
            Boolean productPriceExists = (Boolean) productPriceCtx.get("productPriceExists");
            if (!productPriceExists) {
                try {
                    Map<String, Object> createProductPriceResult = dispatcher.runSync("createProductPrice", productPrices.get(j));
                    if (ServiceUtil.isError(createProductPriceResult)) {
                        request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createProductPriceResult));
                        return "error";
                    }
                } catch (GenericServiceException e) {
                    String errMsg = "Error update product : " + e.toString();
                    request.setAttribute("_ERROR_MESSAGE_", errMsg);
                    return "error";
                }
            }else{
                try {
                    Map<String, Object> updateProductPriceResult = dispatcher.runSync("updateProductPrice", productPrices.get(j));
                    if (ServiceUtil.isError(updateProductPriceResult)) {
                        request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(updateProductPriceResult));
                        return "error";
                    }
                } catch (GenericServiceException e) {
                    String errMsg = "Error update product : " + e.toString();
                    request.setAttribute("_ERROR_MESSAGE_", errMsg);
                    return "error";
                }
            }
        }
        
        String currentProductId = null;
        for (int j = 0; j < pNameDataAndContents.size(); j++) {
            Map<String, Object> tmpProductContents = pNameDataAndContents.get(j);
            currentProductId = (String) tmpProductContents.get("productId");
            // create DataResource, Content, ContentAssoc and ProductContent for product name 
            if(!checkProductContentExists(currentProductId, "PRODUCT_NAME", delegator)){
                if(!pNameEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameEnDataResourceResults = dispatcher.runSync("createDataResourceAndText", pNameEnDataResources.get(j));
                        if (ServiceUtil.isError(pNameEnDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameEnDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting DataResource and Text for product name in En language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
                if(!pNameThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameThDataResourceResults = dispatcher.runSync("createDataResourceAndText", pNameThDataResources.get(j));
                        if (ServiceUtil.isError(pNameThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting DataResource and Text for product name in Th language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
                String pNameEnContentId = null;
                String pNameThContentId = null;
                if(!pNameEnContents.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameEnContentResults = dispatcher.runSync("createContent", pNameEnContents.get(j));
                        if(pNameEnContentResults.size()>0){
                            pNameEnContentId = (String) pNameEnContentResults.get("contentId");
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting content for product name in En language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                    
                }
                if(!pNameThContents.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameThContentResults = dispatcher.runSync("createContent", pNameThContents.get(j));
                        if(pNameThContentResults.size()>0){
                            pNameThContentId = (String) pNameThContentResults.get("contentId");
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting content for product name in Th language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                    
                }

                if(pNameEnContentId != null){
                    // create ContentAssoc
                    if(pNameThContentId != null){
                        try {
                            Map<String, Object> createContentAssocResult = dispatcher.runSync("createContentAssoc", UtilMisc.toMap("contentId", pNameEnContentId 
                                , "contentIdTo" , pNameThContentId , "contentAssocTypeId", "ALTERNATE_LOCALE" , "userLogin", userLogin));
                            if (ServiceUtil.isError(createContentAssocResult)) {
                                request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createContentAssocResult));
                                return "error";
                            }
                        } catch (GenericServiceException e) {
                            String errMsg = "Error setting ContentAssoc for product name: " + e.toString();
                            request.setAttribute("_ERROR_MESSAGE_", errMsg);
                            return "error";
                        }
                    }
                    try {
                        Map<String, Object> createProductContentResult = dispatcher.runSync("createProductContent", pNameProductContents.get(j));
                        if (ServiceUtil.isError(createProductContentResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createProductContentResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting ProductContent for product name: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }else{
                // update DataResource, Content, ContentAssoc and ProductContent for product name 
                if(!pNameEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameEnDataResourceResults = dispatcher.runSync("updateDataResourceAndText", pNameEnDataResources.get(j));
                        if (ServiceUtil.isError(pNameEnDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameEnDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product name in En language:" + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
                if(!pNameThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameThDataResourceResults = dispatcher.runSync("updateDataResourceAndText", pNameThDataResources.get(j));
                        if (ServiceUtil.isError(pNameThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product name in En language:" + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

        }
        
        for (int j = 0; j < pDescDataAndContents.size(); j++) {
            Map<String, Object> tmpProductContents = pDescDataAndContents.get(j);
            currentProductId = (String) tmpProductContents.get("productId");
            
            // create DataResource, Content, ContentAssoc and ProductContent for product description 
            if(!checkProductContentExists(currentProductId, "DESCRIPTION", delegator)){
                 if(!pDescEnDataResources.get(j).isEmpty()){
                     try {
                         Map<String, Object> pDescEnDataResourceResults = dispatcher.runSync("createDataResourceAndText", pDescEnDataResources.get(j));
                         if (ServiceUtil.isError(pDescEnDataResourceResults)) {
                             request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescEnDataResourceResults));
                             return "error";
                         }
                     } catch (GenericServiceException e) {
                         String errMsg = "Error setting DataResource and Text for product description in En language: " + e.toString();
                         request.setAttribute("_ERROR_MESSAGE_", errMsg);
                         return "error";
                     }
                 }
                 if(!pDescThDataResources.get(j).isEmpty()){
                     try {
                         Map<String, Object> pDescThDataResourceResults = dispatcher.runSync("createDataResourceAndText", pDescThDataResources.get(j));
                         if (ServiceUtil.isError(pDescThDataResourceResults)) {
                             request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescThDataResourceResults));
                             return "error";
                         }
                     } catch (GenericServiceException e) {
                         String errMsg = "Error setting DataResource and Text for product description in Th language: " + e.toString();
                         request.setAttribute("_ERROR_MESSAGE_", errMsg);
                         return "error";
                     }
                 }
                 String pDescEnContentId = null;
                 String pDescThContentId = null;
                 if(!pDescEnContents.get(j).isEmpty()){
                     try {
                         Map<String, Object> pDescEnContentResults = dispatcher.runSync("createContent", pDescEnContents.get(j));
                         if(pDescEnContentResults.size()>0){
                             pDescEnContentId = (String) pDescEnContentResults.get("contentId");
                         }
                     } catch (GenericServiceException e) {
                         String errMsg = "Error setting content for product description in En language: " + e.toString();
                         request.setAttribute("_ERROR_MESSAGE_", errMsg);
                         return "error";
                     }
                     
                 }
                 if(!pDescThContents.get(j).isEmpty()){
                     try {
                         Map<String, Object> pDescThContentResults = dispatcher.runSync("createContent", pDescThContents.get(j));
                         if(pDescThContentResults.size()>0){
                             pDescThContentId = (String) pDescThContentResults.get("contentId");
                         }
                     } catch (GenericServiceException e) {
                         String errMsg = "Error setting content for product description in Th language: " + e.toString();
                         request.setAttribute("_ERROR_MESSAGE_", errMsg);
                         return "error";
                     }
                     
                 }

                 if(pDescEnContentId != null){
                     // create ContentAssoc
                     if(pDescThContentId != null){
                         try {
                             Map<String, Object> createContentAssocResult = dispatcher.runSync("createContentAssoc", UtilMisc.toMap("contentId", pDescEnContentId 
                                 , "contentIdTo" , pDescThContentId , "contentAssocTypeId", "ALTERNATE_LOCALE" , "userLogin", userLogin));
                             if (ServiceUtil.isError(createContentAssocResult)) {
                                 request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createContentAssocResult));
                                 return "error";
                             }
                         } catch (GenericServiceException e) {
                             String errMsg = "Error setting ContentAssoc for product description: " + e.toString();
                             request.setAttribute("_ERROR_MESSAGE_", errMsg);
                             return "error";
                         }
                     }

                     try {
                         Map<String, Object> createProductContentResult = dispatcher.runSync("createProductContent", pDescProductContents.get(j));
                         if (ServiceUtil.isError(createProductContentResult)) {
                             request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createProductContentResult));
                             return "error";
                         }
                     } catch (GenericServiceException e) {
                         String errMsg = "Error setting ProductContent for product description: " + e.toString();
                         request.setAttribute("_ERROR_MESSAGE_", errMsg);
                         return "error";
                     }
                 }
                
            }else{
                // update DataResource, Content, ContentAssoc and ProductContent for product description
                if(!pDescEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pDescEnDataResourceResults = dispatcher.runSync("updateDataResourceAndText", pDescEnDataResources.get(j));
                        if (ServiceUtil.isError(pDescEnDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescEnDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product description in En language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
                if(!pDescThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pDescThDataResourceResults = dispatcher.runSync("updateDataResourceAndText", pDescThDataResources.get(j));
                        if (ServiceUtil.isError(pDescThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product description in Th language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }
        }
        
        
        int uploadedProducts = products.size();
        if (products.size() > 0){
            Debug.logInfo(">>>>>>>>>>>>>>> Uploaded " + uploadedProducts + " products from file " + sheetnameFi.getName(), module);
            request.setAttribute("_EVENT_MESSAGE_", "Uploaded " + uploadedProducts + " products from file " + sheetnameFi.getName());
        }else{
        	Debug.logInfo("Do not have product information in file " + sheetnameFi.getName(), module);
            request.setAttribute("_ERROR_MESSAGE_","Please enter product information into file " +sheetnameFi.getName() + " and try again.");
            return "error";
        }
        
        if(uploadFileName!= null){
            uploadFileName.delete();
        }
        return "success";
        
    }

    // check if product already exists in database
    public static boolean checkProductExists(String productId,
            Delegator delegator) {
        GenericValue tmpProductGV = null;
        boolean productExists = false;
        try {
            tmpProductGV = delegator.findByPrimaryKey("Product", UtilMisc.toMap("productId", productId));
            if (tmpProductGV != null && tmpProductGV.getString("productId") == productId)
                productExists = true;
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of product", module);
        }
        return productExists;
    }
    
    // check if SupplierProduct already exists in database
    public static boolean checkSupplierProductExists(String productId, Delegator delegator) {
        GenericValue tmpSupplierProductGV = null;
        boolean supplierProductExists = false;
        try {
            List<GenericValue> tmpSupplierProducts = delegator.findByAnd("SupplierProduct", UtilMisc.toMap("productId", productId));
            tmpSupplierProductGV = EntityUtil.getFirst(tmpSupplierProducts);
            if (tmpSupplierProductGV != null)
                supplierProductExists = true;
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of supplier product", module);
        }
        return supplierProductExists;
    }
    
    // check if SupplierProduct already exists in database
    public static Map<String, ?> checkProductPriceExists(String productId, Delegator delegator) {
        Map<String,Object> results =  FastMap.newInstance();
        GenericValue tmpProductPriceGV = null;
        boolean productPriceExists = false;
        try {
            List<GenericValue> tmpProductPrices = delegator.findByAnd("ProductPrice", UtilMisc.toMap("productId", productId
                    , "productPriceTypeId", "DEFAULT_PRICE", "productPricePurposeId", "PURCHASE"));
            tmpProductPriceGV = EntityUtil.getFirst(tmpProductPrices);
            results.put("productPriceGV", tmpProductPriceGV);
            if (tmpProductPriceGV != null)
                productPriceExists = true;
            
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of ProductPrice", module);
        }
        results.put("productPriceExists", productPriceExists);
        return results;
    }
    
    // check if ProductContent already exists in database
    public static boolean checkProductContentExists(String productId, String productContentTypeId, Delegator delegator) {
        GenericValue tmpProductContentGV = null;
        boolean productContentExists = false;
        try {
            List<GenericValue> tmpProductContents = EntityUtil.filterByDate(delegator.findByAnd("ProductContent", 
                    UtilMisc.toMap("productId", productId, "productContentTypeId", productContentTypeId)));
            tmpProductContentGV = EntityUtil.getFirst(tmpProductContents);
            if (tmpProductContentGV != null)
                productContentExists = true;
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of ProductContent", module);
        }
        return productContentExists;
    }
    
 // prepare the product map
    public static Map<String, Object> prepareProduct(String productId, String internalName, GenericValue userLogin) {
        Map<String, Object> fields = FastMap.newInstance();
        fields.put("productId", productId);
        fields.put("internalName", internalName);
        fields.put("productTypeId", "FINISHED_GOOD");
        fields.put("requirementMethodEnumId", "PRODRQM_DS");
        fields.put("isVirtual", "N");
        fields.put("isVariant", "N");
        fields.put("userLogin", userLogin);
        return fields;
    }
    
    // prepare the DataResource map
    public static Map<String, Object> prepareDataResource(String dataResourceId,
            String localeString, String textData, GenericValue userLogin) {
        Map<String, Object> fields = FastMap.newInstance();
        fields.put("dataResourceId", dataResourceId);
        fields.put("dataResourceTypeId", "ELECTRONIC_TEXT");
        fields.put("statusId", "CTNT_IN_PROGRESS");
        fields.put("localeString", localeString);
        fields.put("textData", textData);
        fields.put("userLogin", userLogin);
        return fields;
    }
    
    // prepare the product map
    public static Map<String, Object> prepareContent(String dataResourceId,
            String localeString, GenericValue userLogin) {
        Map<String, Object> fields = FastMap.newInstance();
        fields.put("contentId", dataResourceId);
        fields.put("dataResourceId", dataResourceId);
        fields.put("contentTypeId", "DOCUMENT");
        fields.put("statusId", "CTNT_IN_PROGRESS");
        fields.put("localeString", localeString);
        fields.put("userLogin", userLogin);
        return fields;
    }
    
    // prepare the ProductContent map
    public static Map<String, Object> prepareProductContent(String productId, String contentId,
            String productContentTypeId, GenericValue userLogin) {
        Map<String, Object> fields = FastMap.newInstance();
        fields.put("productId", productId);
        fields.put("contentId", contentId);
        fields.put("productContentTypeId", productContentTypeId);
        fields.put("userLogin", userLogin);
        return fields;
    }
    
    // prepare the ProductContent map
    public static Map<String, Object> prepareSupplierProduct(String productId, String supplierProductId, String supplierPartyId,
            BigDecimal supplierPrice, Timestamp availableFromDate, BigDecimal minimumOrderQuantity, String currencyUomId, GenericValue userLogin) {
        Map<String, Object> fields = FastMap.newInstance();
        fields.put("productId", productId);
        fields.put("partyId", supplierPartyId);
        fields.put("lastPrice", supplierPrice);
        fields.put("supplierProductId", supplierProductId);
//        fields.put("supplierProductName", supplierProductName);
        fields.put("currencyUomId", currencyUomId);
        fields.put("minimumOrderQuantity",minimumOrderQuantity);
        fields.put("availableFromDate",availableFromDate);
        fields.put("canDropShip","Y");
        fields.put("userLogin", userLogin);
        return fields;
    }
    
    public static String getDataResourceId(String productId, String productContentTypeId, String localeString, Delegator delegator) {
        String dataResourceId = null;
        GenericValue productContentGV = null;
        try {
            List<GenericValue> productContents = EntityUtil.filterByDate(delegator.findByAnd("ProductContent", 
                    UtilMisc.toMap("productId", productId, "productContentTypeId", productContentTypeId)));
            if(productContents.size()>0){
                productContentGV = EntityUtil.getFirst(productContents);
            }
        } catch (GenericEntityException e) {
            Debug.logError("Error finding ProductContent", module);
        }
        if(productContentGV != null){
            try {
                GenericValue content = productContentGV.getRelatedOne("Content");

                if("en".equals(localeString)){
                    GenericValue dataResource = content.getRelatedOne("DataResource");
                    dataResourceId = dataResource.getString("dataResourceId");
                }else if("th".equals(localeString)){
                    EntityConditionList<EntityCondition> contentAssocConditions = EntityCondition.makeCondition(UtilMisc.toList(
                            EntityCondition.makeCondition("contentIdStart", EntityOperator.EQUALS, content.get("contentId")),
                            EntityCondition.makeCondition("caContentAssocTypeId", EntityOperator.EQUALS, "ALTERNATE_LOCALE"),
                            EntityUtil.getFilterByDateExpr("caFromDate", "caThruDate")),
                        EntityOperator.AND);
                    
                    List<GenericValue> contentAssocList = delegator.findList("ContentAssocDataResourceViewTo", contentAssocConditions , null, UtilMisc.toList("contentIdStart DESC"), null, false);
                    
                    if(contentAssocList.size()>0){
                        GenericValue contentAssoc = EntityUtil.getFirst(contentAssocList);
                        dataResourceId = contentAssoc.getString("dataResourceId");
                    }
                }
            } catch (GenericEntityException e) {
                Debug.logError("Error finding Content", module);
            }
        }
        return dataResourceId;
    }
    
    public static String toStringValue(HSSFCell cell){
        String cellValue = null;

        switch(cell.getCellType()){
        case HSSFCell.CELL_TYPE_NUMERIC:
                String cellValueWithPoint = String.valueOf(cell.getNumericCellValue());
                cellValue = cellValueWithPoint.substring(0, cellValueWithPoint.indexOf('.'));
                break;
        case HSSFCell.CELL_TYPE_STRING:
                cellValue = cell.getRichStringCellValue().toString();
                break;
        case HSSFCell.CELL_TYPE_FORMULA:
                cellValue = null;
                break;
        case HSSFCell.CELL_TYPE_BLANK:
                cellValue= null;
                break;
        case HSSFCell.CELL_TYPE_BOOLEAN:
                cellValue = String.valueOf((boolean)cell.getBooleanCellValue());
                break;
        case HSSFCell.CELL_TYPE_ERROR:
                cellValue = null;
                break;
        default:
                cellValue = null;
        }
        return cellValue;
    }
}