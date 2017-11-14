package org.apache.ofbiz.productfromthailand;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
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
import org.apache.ofbiz.base.util.UtilDateTime;
import org.apache.ofbiz.base.util.UtilHttp;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.base.util.UtilProperties;
import org.apache.ofbiz.base.util.UtilValidate;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.condition.EntityCondition;
import org.apache.ofbiz.entity.condition.EntityConditionList;
import org.apache.ofbiz.entity.condition.EntityOperator;
import org.apache.ofbiz.entity.util.EntityUtil;
import org.apache.ofbiz.service.GenericServiceException;
import org.apache.ofbiz.service.LocalDispatcher;
import org.apache.ofbiz.service.ServiceUtil;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

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
        List<Object> errMsgList = new LinkedList<Object>();

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
        Map passedParams = new HashMap();
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
        String supplierName = null;
        Map<String, Object> getPartyName = new HashMap<String, Object>();
        try {
            getPartyName = dispatcher.runSync("getPartyNameForDate", UtilMisc.toMap("partyId", supplierPartyId, "userLogin", userLogin));
            if (getPartyName.get("groupName") != null) {
                supplierName = getPartyName.get("groupName").toString().substring(0, 2).toUpperCase();
            } else {
                supplierName = getPartyName.get("firstName").toString().substring(0, 2).toUpperCase();
            }
        } catch (GenericServiceException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        supplierName = supplierName + "-";

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
        List<Map<String, Object>> products = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> productCategoryMembers = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> createSupplierProducts = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> updateSupplierProducts = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> removeSupplierProducts = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> createProductPrices = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> updateProductPrices = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> removeProductPrices = new LinkedList<Map<String, Object>>();

        List<Map<String, Object>> createPNameEnDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> updatePNameEnDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> createPNameThDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> updatePNameThDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> pNameEnContents = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> pNameThContents = new LinkedList<Map<String, Object>>();

        List<Map<String, Object>> createPDescEnDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> updatePDescEnDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> createPDescThDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> updatePDescThDataResources = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> pDescEnContents = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> pDescThContents = new LinkedList<Map<String, Object>>();

        List<Map<String, Object>> createNameProductContents = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> createDescProductContents = new LinkedList<Map<String, Object>>();

        List<Map<String, Object>> removeNameProductContents = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> removeDescProductContents = new LinkedList<Map<String, Object>>();

        List<Map<String, Object>> createNameContentAssocs = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> createDescContentAssocs = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> removeNameContentAssocs = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> removeDescContentAssocs = new LinkedList<Map<String, Object>>();

        List<Map<String, Object>> pNameDataAndContents = new LinkedList<Map<String, Object>>();
        List<Map<String, Object>> pDescDataAndContents = new LinkedList<Map<String, Object>>();

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
                    String productId = delegator.getNextSeqId("Product");
                    String supplierProductId = supplierName + delegator.getNextSeqId("SupplierProduct");
                    String actionField = "add";
                    // read action from ninth column
                    /*HSSFCell cell8 = row.getCell(8);
                    String actionField = null;
                    if(UtilValidate.isNotEmpty(cell8)){
                        actionField = toStringValue(cell8);
                    }*/

                    if (actionField != null) {
                        //actionField = actionField.toLowerCase();
                        // starts from 0"
                        // read supplierProductId from first column
                        /*HSSFCell cell0 = row.getCell(0);
                        String supplierProductId = null;
                        if(UtilValidate.isNotEmpty(cell0)){
                            supplierProductId= toStringValue(cell0);
                        }

                        if(supplierProductId == null){
                            supplierProductId = "SP-"+delegator.getNextSeqId("SupplierProduct");
                        }else{
                            List<GenericValue> supplierProductList = null;
                            try {
                                supplierProductList = delegator.findByAnd("SupplierProduct", UtilMisc.toMap("supplierProductId", supplierProductId), null, false);
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
                        }*/

                        // read productName from first column
                        HSSFCell cell0 = row.getCell(0);
                        String productName = null;
                        if(UtilValidate.isNotEmpty(cell0)){
                            productName = toStringValue(cell0);
                        }

                        // read productName in Thai language from second column
                        HSSFCell cell1 = row.getCell(1);
                        String productNameTH = null;
                        if(UtilValidate.isNotEmpty(cell1)){
                            productNameTH  = toStringValue(cell1);
                        }

                        String internalName = productName;

                        HSSFCell cell2 = row.getCell(2);
                        String description = null;
                        if(UtilValidate.isNotEmpty(cell2)){
                            description = toStringValue(cell2);
                        }

                        HSSFCell cell3 = row.getCell(3);
                        String descriptionTH = null;
                        if(UtilValidate.isNotEmpty(cell3)){
                            descriptionTH  = toStringValue(cell3);
                        }

                        // read price from fifth column
                        HSSFCell cell4 = row.getCell(4);
                        BigDecimal price = BigDecimal.ZERO;
                        if (cell4 != null && cell4.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                            price = BigDecimal.valueOf(cell4.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP);

                        // read productWidth from sixth column
                        HSSFCell cell5 = row.getCell(5);
                        BigDecimal productWidth = BigDecimal.ZERO;
                        if (cell5 != null && cell5.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                            productWidth = BigDecimal.valueOf(cell5.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP);

                        // read productDepth from seventh column
                        HSSFCell cell6 = row.getCell(6);
                        BigDecimal productDepth = BigDecimal.ZERO;
                        if (cell6 != null && cell6.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                            productDepth = BigDecimal.valueOf(cell6.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP);

                        // read productHeight from eighth column
                        HSSFCell cell7 = row.getCell(7);
                        BigDecimal productHeight = BigDecimal.ZERO;
                        if (cell7 != null && cell7.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                            productHeight = BigDecimal.valueOf(cell7.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP);

                        // read productWeight from ninth column
                        HSSFCell cell8 = row.getCell(8);
                        BigDecimal productWeight = BigDecimal.ZERO;
                        if (cell8 != null && cell8.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
                            productWeight = BigDecimal.valueOf(cell8.getNumericCellValue()).setScale(2, BigDecimal.ROUND_HALF_UP);

                        // read imageUrl from tenth column
                        String imageUrl = null;

                        Timestamp now = UtilDateTime.nowTimestamp();

                        BigDecimal salePrice = BigDecimal.ZERO;
                        try {
                            Map<String, Object> calculateSalePriceResult = dispatcher.runSync("calculateSalePrice", UtilMisc.<String, Object>toMap("purchasePrice", price, "userLogin", userLogin));
                            if (ServiceUtil.isError(calculateSalePriceResult)) {
                                request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(calculateSalePriceResult));
                                return "error";
                            }
                            salePrice = (BigDecimal) calculateSalePriceResult.get("salePrice");
                        } catch (GenericServiceException e) {
                            String errMsg = "Error Calculate Sale Price : " + e.toString();
                            request.setAttribute("_ERROR_MESSAGE_", errMsg);
                            return "error";
                        }

                        products.add(prepareProduct(productId, productName, internalName, description, productWidth, productDepth, productHeight, productWeight, imageUrl, actionField, userLogin));
                        // check if SupplierProduct already exists update it, otherwise create new one
                        List<GenericValue> tmpSupplierProducts = null;
                        GenericValue supplierProductGV = null;
                        if (checkSupplierProductExists(productId, delegator)) {
                             try {
                                 tmpSupplierProducts = delegator.findByAnd("SupplierProduct", UtilMisc.toMap("productId", productId), null, false);
                             } catch (GenericEntityException e) {
                                 request.setAttribute("_ERROR_MESSAGE_", "Error getting SupplierProduct.");
                             }
                             tmpSupplierProducts = EntityUtil.filterByDate(tmpSupplierProducts, UtilDateTime.nowTimestamp(), "availableFromDate", "availableThruDate", true);
                             supplierProductGV = EntityUtil.getFirst(tmpSupplierProducts);
                        }
                        Map<String, ?> productPriceCtx = checkProductPriceExists(productId, delegator);
                        GenericValue productPriceGV = null;
                        if(productPriceCtx.size() > 0){
                            productPriceGV = (GenericValue) productPriceCtx.get("productPriceGV");
                        }

                        // prepare variable for create/update/delete ProductContent for product name & description in Thai and Eng language
                        String pNameEnDataResourceId = null;
                        String pNameThDataResourceId = null;
                        String pNameEnContentId = null;
                        String pNameThContentId = null;
                        String pDescEnDataResourceId = null;
                        String pDescThDataResourceId = null;
                        String pDescEnContentId = null;
                        String pDescThContentId = null;
                        Map<String, Object> pNameCtx = new HashMap<String, Object>();
                        Map<String, Object> pDescCtx = new HashMap<String, Object>();

                        if("add".equals(actionField)){
                            if (!checkSupplierProductExists(productId, delegator)) {
                                createSupplierProducts.add(prepareSupplierProduct(productId, supplierProductId, supplierPartyId, price
                                        , UtilDateTime.nowTimestamp(), actionField, BigDecimal.ZERO, "THB" , userLogin));
                            }else{
                                request.setAttribute("_ERROR_MESSAGE_", "Error setting SupplierProduct: "+ supplierProductId+ " already exists.");
                                return "error";
                            }
                            createProductPrices.add(prepareProductPrice(productId, salePrice, now, "THB", "_NA_", actionField, userLogin));

                            // create ProductContent for product name & description in Thai and Eng language
                            if(productName != null){
                                // Create new ProductContent
                                pNameEnDataResourceId = productId + "-PNAMEEN";
                                pNameThDataResourceId = productId + "-PNAMETH";

                                pNameEnContentId = pNameEnDataResourceId;
                                createPNameEnDataResources.add(prepareDataResource(pNameEnDataResourceId, "en", productName , userLogin));
                                pNameEnContents.add(prepareContent(pNameEnContentId, pNameEnDataResourceId, "en", userLogin));

                                if(productNameTH != null){
                                    pNameThContentId = pNameThDataResourceId;
                                    createPNameThDataResources.add(prepareDataResource(pNameThDataResourceId, "th", productNameTH , userLogin));
                                    pNameThContents.add(prepareContent(pNameThContentId, pNameThDataResourceId, "th", userLogin));
                                    if(pNameEnContentId != null)
                                        createNameContentAssocs.add(prepareContentAssoc(pNameEnContentId, pNameThContentId, now, userLogin));
                                } else {
                                    request.setAttribute("_ERROR_MESSAGE_", "Error Product name (Thai) is missing.");
                                    return "error";
                                }
                                createNameProductContents.add(prepareProductContent(productId, pNameEnDataResourceId, now, "PRODUCT_NAME", actionField, userLogin));

                                pNameCtx.put("productId", productId);
                            }

                            if(description != null){
                                pDescEnDataResourceId = productId + "-DESCEN";
                                pDescThDataResourceId = productId + "-DESCTH";

                                pDescEnContentId = pDescEnDataResourceId;
                                createPDescEnDataResources.add(prepareDataResource(pDescEnDataResourceId, "en", description , userLogin));
                                pDescEnContents.add(prepareContent(pDescEnContentId, pDescEnDataResourceId, "en", userLogin));

                                if(descriptionTH != null){
                                    pDescThContentId = pDescThDataResourceId;
                                    createPDescThDataResources.add(prepareDataResource(pDescThDataResourceId, "th", descriptionTH , userLogin));
                                    pDescThContents.add(prepareContent(pDescThContentId, pDescThDataResourceId, "th", userLogin));
                                    if(pDescEnContentId != null)
                                        createDescContentAssocs.add(prepareContentAssoc(pDescEnContentId, pDescThContentId, now, userLogin));
                                }
                                createDescProductContents.add(prepareProductContent(productId, pDescEnContentId, now, "DESCRIPTION", actionField, userLogin));
                                pDescCtx.put("productId", productId);
                            }

                        }else if("update".equals(actionField)){
                            if(supplierProductGV != null){
                                updateSupplierProducts.add(prepareSupplierProduct(productId, supplierProductGV.getString("supplierProductId"), supplierPartyId, price,
                                        (Timestamp) supplierProductGV.get("availableFromDate"), actionField,(BigDecimal) supplierProductGV.get("minimumOrderQuantity")
                                        , supplierProductGV.getString("currencyUomId"), userLogin));
                            }else{
                                request.setAttribute("_ERROR_MESSAGE_", "Error updating SupplierProduct: "+ supplierProductId+ " not found.");
                                return "error";
                            }
                            if(productPriceGV != null){
                                updateProductPrices.add(prepareProductPrice(productId, salePrice, productPriceGV.getTimestamp("fromDate"), productPriceGV.getString("currencyUomId")
                                        , productPriceGV.getString("productStoreGroupId"), actionField, userLogin));
                            }else{
                                request.setAttribute("_ERROR_MESSAGE_", "Error updating ProductPrice: ");
                                return "error";
                            }

                            // check if a ProductContent already exists update it
                            if(productName != null){
                                 Map<String, Object> pNameEnContentResults = getDataResourceAndContent(productId , "PRODUCT_NAME", "en" , delegator);
                                 if(pNameEnContentResults.size() > 0){
                                     pNameEnDataResourceId = (String) pNameEnContentResults.get("dataResourceId");
                                     pNameEnContentId = (String) pNameEnContentResults.get("contentId");
                                 }
                                 Map<String, Object> pNameThContentResults = getDataResourceAndContent(productId , "PRODUCT_NAME", "th" , delegator);
                                 if(pNameThContentResults.size() > 0){
                                     pNameThDataResourceId = (String) pNameThContentResults.get("dataResourceId");
                                     pNameThContentId = (String) pNameThContentResults.get("contentId");
                                 }
                                if(pNameEnDataResourceId != null){
                                    updatePNameEnDataResources.add(prepareDataResource(pNameEnDataResourceId, "en", productName , userLogin));

                                }else{
                                    pNameEnDataResourceId = productId + "-PNAMEEN";
                                    createPNameEnDataResources.add(prepareDataResource(pNameEnDataResourceId, "en", productName , userLogin));
                                    if(pNameEnContentId == null)
                                        pNameEnContentId = pNameEnDataResourceId;
                                    pNameEnContents.add(prepareContent(pNameEnContentId, pNameEnDataResourceId, "en", userLogin));
                                }

                                if(productNameTH != null){
                                    if(pNameThDataResourceId != null){
                                        updatePNameThDataResources.add(prepareDataResource(pNameThDataResourceId, "th", productNameTH , userLogin));
                                    }else{
                                        pNameThDataResourceId = productId + "-PNAMETH";
                                        createPNameThDataResources.add(prepareDataResource(pNameThDataResourceId, "th", productNameTH , userLogin));
                                        if(pNameThContentId == null)
                                            pNameThContentId = pNameThDataResourceId;
                                        pNameThContents.add(prepareContent(pNameThContentId, pNameThDataResourceId, "th", userLogin));
                                        if(pNameEnContentId != null)
                                            createNameContentAssocs.add(prepareContentAssoc(pNameEnContentId, pNameThContentId, now, userLogin));
                                    }
                                }
                                if(!checkProductContentExists(productId, "PRODUCT_NAME", delegator)){
                                    createNameProductContents.add(prepareProductContent(productId, pNameEnContentId, now, "PRODUCT_NAME", actionField, userLogin));
                                }
                                pNameCtx.put("productId", productId);
                            }

                            if(description != null){
                                Map<String, Object> pDescEnContentResults = getDataResourceAndContent(productId , "DESCRIPTION", "en" , delegator);
                                if(pDescEnContentResults.size() > 0){
                                    pDescEnDataResourceId = (String) pDescEnContentResults.get("dataResourceId");
                                    pDescEnContentId = (String) pDescEnContentResults.get("contentId");
                                }
                                Map<String, Object> pDescThContentResults = getDataResourceAndContent(productId , "DESCRIPTION", "th" , delegator);
                                if(pDescThContentResults.size() > 0){
                                    pDescThDataResourceId = (String) pDescThContentResults.get("dataResourceId");
                                    pDescThContentId = (String) pDescThContentResults.get("contentId");
                                }

                                if(pDescEnDataResourceId != null){
                                    updatePDescEnDataResources.add(prepareDataResource(pDescEnDataResourceId, "en", description , userLogin));
                                }else{
                                    pDescEnDataResourceId = productId + "-DESCEN";
                                    createPDescEnDataResources.add(prepareDataResource(pDescEnDataResourceId, "en", description , userLogin));
                                    if(pDescEnContentId == null)
                                        pDescEnContentId = pDescEnDataResourceId;
                                    pDescEnContents.add(prepareContent(pDescEnContentId, pDescEnDataResourceId, "en", userLogin));
                                }

                                if(descriptionTH != null){
                                    if(pDescThDataResourceId != null){
                                        updatePDescThDataResources.add(prepareDataResource(pDescThDataResourceId, "th", descriptionTH , userLogin));
                                    }else{
                                        pDescThDataResourceId = productId + "-DESCTH";
                                        createPDescThDataResources.add(prepareDataResource(pDescThDataResourceId, "th", descriptionTH , userLogin));
                                        if(pDescThContentId == null)
                                            pDescThContentId = pDescThDataResourceId;
                                        pDescThContents.add(prepareContent(pDescThContentId, pDescThDataResourceId, "th", userLogin));

                                        if(pDescEnContentId != null)
                                            createDescContentAssocs.add(prepareContentAssoc(pDescEnContentId, pDescThContentId, now, userLogin));
                                    }
                                }
                                // check if description in ProductContent already exists update it, otherwise create new one
                                if(!checkProductContentExists(productId, "DESCRIPTION", delegator))
                                    createDescProductContents.add(prepareProductContent(productId, pDescEnContentId, now, "DESCRIPTION", actionField, userLogin));

                                pDescCtx.put("productId", productId);
                            }
                        }else if("delete".equals(actionField)){
                            if(supplierProductGV != null){
                                Map<String, Object> removeSupplierProductCtx = new HashMap<String, Object>();
                                removeSupplierProductCtx.put("productId", productId);
                                removeSupplierProductCtx.put("currencyUomId", supplierProductGV.getString("currencyUomId"));
                                removeSupplierProductCtx.put("availableFromDate", supplierProductGV.get("availableFromDate"));
                                removeSupplierProductCtx.put("availableThruDate", now);
                                removeSupplierProductCtx.put("minimumOrderQuantity", supplierProductGV.get("minimumOrderQuantity"));
                                removeSupplierProductCtx.put("partyId", supplierPartyId);
                                removeSupplierProductCtx.put("userLogin", userLogin);

                                removeSupplierProducts.add(removeSupplierProductCtx);
                            }else{
                                request.setAttribute("_ERROR_MESSAGE_", "Error removing SupplierProduct: "+ supplierProductId+ " not found.");
                                return "error";
                            }
                            /*
                            if(productPriceGV != null){
                                removeProductPrices.add(prepareProductPrice(productId, salePrice, productPriceGV.getTimestamp("fromDate"), productPriceGV.getString("currencyUomId")
                                        , productPriceGV.getString("productStoreGroupId"), actionField, userLogin));

                            }else{
                                request.setAttribute("_ERROR_MESSAGE_", "Error updating ProductPrice: ");
                                return "error";
                            }

                            // remove product name
                            if(checkProductContentExists(productId, "PRODUCT_NAME", delegator)){
                                Map<String, Object> pNameEnContentResults = getDataResourceAndContent(productId , "PRODUCT_NAME", "en" , delegator);

                                if(pNameEnContentResults.size() > 0){
                                    pNameEnDataResourceId = (String) pNameEnContentResults.get("dataResourceId");
                                    pNameEnContentId = (String) pNameEnContentResults.get("contentId");
                                }
                                Map<String, Object> pNameThContentResults = getDataResourceAndContent(productId , "PRODUCT_NAME", "th" , delegator);

                                if(pNameThContentResults.size() > 0){
                                    pNameThDataResourceId = (String) pNameThContentResults.get("dataResourceId");
                                    pNameThContentId = (String) pNameThContentResults.get("contentId");
                                }
                            }

                            if(pNameEnDataResourceId != null){
                                // prepare to remove ContentAssoc
                                List<GenericValue> contentAssocs = null;
                                try {
                                    contentAssocs = EntityUtil.filterByDate(delegator.findByAnd("ContentAssoc",
                                            UtilMisc.toMap("contentId", pNameEnContentId, "contentAssocTypeId", "ALTERNATE_LOCALE", "contentIdTo", pNameThContentId)));
                                } catch (GenericEntityException e) {
                                    Debug.logError("Error finding ProductContent", module);
                                }
                                if(contentAssocs.size()>0){
                                    GenericValue contentAssocGV = EntityUtil.getFirst(contentAssocs);
                                    removeNameContentAssocs.add(prepareContentAssoc(pNameEnContentId, pNameThContentId, contentAssocGV.getTimestamp("fromDate"), userLogin));
                                }

                                List<GenericValue> productContents = null;
                                try {
                                    productContents = EntityUtil.filterByDate(delegator.findByAnd("ProductContent",
                                            UtilMisc.toMap("productId", productId, "productContentTypeId", "PRODUCT_NAME")));
                                } catch (GenericEntityException e) {
                                    Debug.logError("Error finding ProductContent", module);
                                }
                                if(productContents.size()>0){
                                    GenericValue productContentGV = EntityUtil.getFirst(productContents);
                                    removeNameProductContents.add(prepareProductContent(productId, productContentGV.getString("contentId"), productContentGV.getTimestamp("fromDate"),
                                            "PRODUCT_NAME", actionField, userLogin));
                                    pNameCtx.put("productId", productId);
                                }
                            }

                            // check if description in ProductContent already exists delete it
                            if(checkProductContentExists(productId, "DESCRIPTION", delegator)){
                                Map<String, Object> pDescEnContentResults = getDataResourceAndContent(productId , "DESCRIPTION", "en" , delegator);
                                if(pDescEnContentResults.size() > 0){
                                    pDescEnDataResourceId = (String) pDescEnContentResults.get("dataResourceId");
                                    pDescEnContentId = (String) pDescEnContentResults.get("contentId");
                                }
                                Map<String, Object> pDescThContentResults = getDataResourceAndContent(productId , "DESCRIPTION", "th" , delegator);

                                if(pDescThContentResults.size() > 0){
                                    pDescThDataResourceId = (String) pDescThContentResults.get("dataResourceId");
                                    pDescThContentId = (String) pDescThContentResults.get("contentId");
                                }
                            }

                            if(pDescEnDataResourceId != null){
                                // prepare to remove ContentAssoc
                                List<GenericValue> contentAssocs = null;
                                try {
                                    contentAssocs = EntityUtil.filterByDate(delegator.findByAnd("ContentAssoc",
                                            UtilMisc.toMap("contentId", pDescEnContentId, "contentAssocTypeId", "ALTERNATE_LOCALE", "contentIdTo", pDescThContentId)));
                                } catch (GenericEntityException e) {
                                    Debug.logError("Error finding ProductContent", module);
                                }
                                if(contentAssocs.size()>0){
                                    GenericValue contentAssocGV = EntityUtil.getFirst(contentAssocs);
                                    removeDescContentAssocs.add(prepareContentAssoc(pDescEnContentId, pDescThContentId, contentAssocGV.getTimestamp("fromDate"), userLogin));
                                }
                                List<GenericValue> productContents = null;
                                try {
                                    productContents = EntityUtil.filterByDate(delegator.findByAnd("ProductContent",
                                            UtilMisc.toMap("productId", productId, "productContentTypeId", "DESCRIPTION")));
                                } catch (GenericEntityException e) {
                                    Debug.logError("Error finding ProductContent", module);
                                }
                                if(productContents.size()>0){
                                    GenericValue productContentGV = EntityUtil.getFirst(productContents);
                                    removeDescProductContents.add(prepareProductContent(productId, productContentGV.getString("contentId"), productContentGV.getTimestamp("fromDate"),
                                            "DESCRIPTION", actionField, userLogin));
                                    pDescCtx.put("productId", productId);
                                }
                            }
                            */

                        }
                        pNameDataAndContents.add(pNameCtx);
                        pDescDataAndContents.add(pDescCtx);
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
                    String errMsg = "Error create product : " + e.toString();
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
            // create values in "SupplierProduct" entity
            if(createSupplierProducts.size() > 0 && createSupplierProducts.size() > j){
                if(!createSupplierProducts.get(j).isEmpty()){
                    try {
                        Map<String, Object> createSupplierProductResult = dispatcher.runSync("createSupplierProduct", createSupplierProducts.get(j));
                        if (ServiceUtil.isError(createSupplierProductResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createSupplierProductResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting SupplierProduct : " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            // update values in "SupplierProduct" entity
            if(updateSupplierProducts.size() > 0 && updateSupplierProducts.size() > j){
                if(!updateSupplierProducts.get(j).isEmpty()){
                    try {
                        Map<String, Object> updateSupplierProductResult = dispatcher.runSync("updateSupplierProduct", updateSupplierProducts.get(j));
                        if (ServiceUtil.isError(updateSupplierProductResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(updateSupplierProductResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating SupplierProduct : " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }

            }

            // remove values in "SupplierProduct" entity
            if(removeSupplierProducts.size() > 0 && removeSupplierProducts.size() > j){
                if(!removeSupplierProducts.get(j).isEmpty()){
                    try {
                        Map<String, Object> removeSupplierProductResult = dispatcher.runSync("updateSupplierProduct", removeSupplierProducts.get(j));
                        if (ServiceUtil.isError(removeSupplierProductResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(removeSupplierProductResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error removing SupplierProduct : " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            // create values in "ProductPrice" entity
            if(createProductPrices.size() > 0 && createProductPrices.size() > j){
                if(!createProductPrices.get(j).isEmpty()){
                    try {
                        Map<String, Object> createProductPriceResult = dispatcher.runSync("createProductPrice", createProductPrices.get(j));
                        if (ServiceUtil.isError(createProductPriceResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(createProductPriceResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting SupplierProduct : " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }

            }

            // update values in "ProductPrice" entity
            if(updateProductPrices.size() > 0 && updateProductPrices.size() > j){
                if(!updateProductPrices.get(j).isEmpty()){
                    try {
                        Map<String, Object> updateProductPriceResult = dispatcher.runSync("updateProductPrice", updateProductPrices.get(j));
                        if (ServiceUtil.isError(updateProductPriceResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(updateProductPriceResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating SupplierProduct : " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            // remove values in "ProductPrice" entity
            if(removeProductPrices.size() > 0 && removeProductPrices.size() > j){
                if(!removeProductPrices.get(j).isEmpty()){
                    try {
                        Map<String, Object> removeProductPriceResult = dispatcher.runSync("deleteProductPrice", removeProductPrices.get(j));
                        if (ServiceUtil.isError(removeProductPriceResult)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(removeProductPriceResult));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error removing SupplierProduct : " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }
        }

        String currentProductId = null;
        for (int j = 0; j < pNameDataAndContents.size(); j++) {
            Map<String, Object> tmpProductContents = pNameDataAndContents.get(j);
            currentProductId = (String) tmpProductContents.get("productId");
            String pNameEnContentId = null;
            String pNameThContentId = null;

            // create DataResource, Content, ContentAssoc and ProductContent for product name
            if(createPNameEnDataResources.size() > 0 && createPNameEnDataResources.size() > j){
                if(!createPNameEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameEnDataResourceResults = dispatcher.runSync("createDataResourceAndText", createPNameEnDataResources.get(j));
                        if (ServiceUtil.isError(pNameEnDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameEnDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting DataResource and Text for product name in En language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }

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
            }

            if(createPNameThDataResources.size() > 0 && createPNameThDataResources.size() > j){
                if(!createPNameThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameThDataResourceResults = dispatcher.runSync("createDataResourceAndText", createPNameThDataResources.get(j));
                        if (ServiceUtil.isError(pNameThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting DataResource and Text for product name in Th language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }

                    try {
                        Map<String, Object> pNameThContentResults = dispatcher.runSync("createContent", pNameThContents.get(j));
                        if(pNameThContentResults.size()>0){
                            pNameEnContentId = (String) pNameThContentResults.get("contentId");
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting content for product name in En language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            // create ContentAssoc
            if(createNameContentAssocs.size() > 0 && createNameContentAssocs.size() > j){
                if(!createNameContentAssocs.get(j).isEmpty()){
                    try {
                        Map<String, Object> createContentAssocResult = dispatcher.runSync("createContentAssoc", createNameContentAssocs.get(j));
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
            }
            if(createNameProductContents.size() > 0 && createNameProductContents.size() > j){
                if(!createNameProductContents.get(j).isEmpty()){
                    try {
                        Map<String, Object> createProductContentResult = dispatcher.runSync("createProductContent", createNameProductContents.get(j));
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
            }

            if(updatePNameEnDataResources.size() > 0 && updatePNameEnDataResources.size() > j){
                if(!updatePNameEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameEnDataResourceResults = dispatcher.runSync("updateDataResourceAndText", updatePNameEnDataResources.get(j));
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
            }

            if(updatePNameThDataResources.size() > 0 && updatePNameThDataResources.size() > j){
                if(!updatePNameThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pNameThDataResourceResults = dispatcher.runSync("updateDataResourceAndText", updatePNameThDataResources.get(j));
                        if (ServiceUtil.isError(pNameThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pNameThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product name in Th language:" + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            if(removeNameContentAssocs.size() > 0 && removeNameContentAssocs.size() > j){
                if(!removeNameContentAssocs.get(j).isEmpty()){
                    // set thruDate to ContentAssoc
                    try {
                        Map<String, Object> removeContentAssocResults = dispatcher.runSync("removeContentAssoc", removeNameContentAssocs.get(j));
                        if (ServiceUtil.isError(removeContentAssocResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(removeContentAssocResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error removing ContentAssoc for product name: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            if(removeNameProductContents.size() > 0 && removeNameProductContents.size() > j){
                if(!removeNameProductContents.get(j).isEmpty()){
                    // set thruDate to ProductContent
                    try {
                        Map<String, Object> removeProductContentResults = dispatcher.runSync("removeProductContent", removeNameProductContents.get(j));
                        if (ServiceUtil.isError(removeProductContentResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(removeProductContentResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error removing ProductContent for product name: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }
        }

        for (int j = 0; j < pDescDataAndContents.size(); j++) {
            Map<String, Object> tmpProductContents = pDescDataAndContents.get(j);
            currentProductId = (String) tmpProductContents.get("productId");
            String pDescEnContentId = null;
            String pDescThContentId = null;

            // create DataResource, Content, ContentAssoc and ProductContent for product description
            if(createPDescEnDataResources.size() > 0 && createPDescEnDataResources.size() > j){
                if(!createPDescEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pDescEnDataResourceResults = dispatcher.runSync("createDataResourceAndText", createPDescEnDataResources.get(j));
                        if (ServiceUtil.isError(pDescEnDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescEnDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting DataResource and Text for product description in En language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }

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
            }
            if(createPDescThDataResources.size() > 0 && createPDescThDataResources.size() > j){
                if(!createPDescThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pDescThDataResourceResults = dispatcher.runSync("createDataResourceAndText", createPDescThDataResources.get(j));
                        if (ServiceUtil.isError(pDescThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error setting DataResource and Text for product description in Th language: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }

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
            }

            // create ContentAssoc
            if(createDescContentAssocs.size() > 0 && createDescContentAssocs.size() > j){
                if(!createDescContentAssocs.get(j).isEmpty()){
                    try {
                        Map<String, Object> createContentAssocResult = dispatcher.runSync("createContentAssoc", createDescContentAssocs.get(j));
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
            }
            if(createDescProductContents.size() > 0 && createDescProductContents.size() > j){
                if(!createDescProductContents.get(j).isEmpty()){
                    try {
                        Map<String, Object> createProductContentResult = dispatcher.runSync("createProductContent", createDescProductContents.get(j));
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
            }

            if(updatePDescEnDataResources.size() > 0 && updatePDescEnDataResources.size() > j){
                if(!updatePDescEnDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pDescEnDataResourceResults = dispatcher.runSync("updateDataResourceAndText", updatePDescEnDataResources.get(j));
                        if (ServiceUtil.isError(pDescEnDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescEnDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product description in En language:" + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            if(updatePDescThDataResources.size() > 0 && updatePDescThDataResources.size() > j){
                if(!updatePDescThDataResources.get(j).isEmpty()){
                    try {
                        Map<String, Object> pDescThDataResourceResults = dispatcher.runSync("updateDataResourceAndText", updatePDescThDataResources.get(j));
                        if (ServiceUtil.isError(pDescThDataResourceResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(pDescThDataResourceResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error updating DataResource and Text for product description in Th language:" + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            if(removeDescContentAssocs.size() > 0 && removeDescContentAssocs.size() > j){
                if(!removeDescContentAssocs.get(j).isEmpty()){
                    // set thruDate to ContentAssoc
                    try {
                        Map<String, Object> removeContentAssocResults = dispatcher.runSync("removeContentAssoc", removeDescContentAssocs.get(j));
                        if (ServiceUtil.isError(removeContentAssocResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(removeContentAssocResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error removing ContentAssoc for product description: " + e.toString();
                        request.setAttribute("_ERROR_MESSAGE_", errMsg);
                        return "error";
                    }
                }
            }

            if(removeDescProductContents.size() > 0 && removeDescProductContents.size() > j){
                if(!removeDescProductContents.get(j).isEmpty()){
                    // set thruDate to ProductContent
                    try {
                        Map<String, Object> removeProductContentResults = dispatcher.runSync("removeProductContent", removeDescProductContents.get(j));
                        if (ServiceUtil.isError(removeProductContentResults)) {
                            request.setAttribute("_ERROR_MESSAGE_", ServiceUtil.getErrorMessage(removeProductContentResults));
                            return "error";
                        }
                    } catch (GenericServiceException e) {
                        String errMsg = "Error removing ProductContent for product description: " + e.toString();
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
            tmpProductGV = delegator.findOne("Product", UtilMisc.toMap("productId", productId), false);
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
            List<GenericValue> tmpSupplierProducts = delegator.findByAnd("SupplierProduct", UtilMisc.toMap("productId", productId), null, false);
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
        Map<String,Object> results =  new HashMap<String, Object>();
        GenericValue tmpProductPriceGV = null;
        boolean productPriceExists = false;
        try {
            List<GenericValue> tmpProductPrices = delegator.findByAnd("ProductPrice", UtilMisc.toMap("productId", productId
                    , "productPriceTypeId", "DEFAULT_PRICE", "productPricePurposeId", "PURCHASE"), null, false);
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
                    UtilMisc.toMap("productId", productId, "productContentTypeId", productContentTypeId), null, false));
            tmpProductContentGV = EntityUtil.getFirst(tmpProductContents);
            if (tmpProductContentGV != null)
                productContentExists = true;
        } catch (GenericEntityException e) {
            Debug.logError("Problem in reading data of ProductContent", module);
        }
        return productContentExists;
    }

    // prepare the product map
    public static Map<String, Object> prepareProduct(String productId, String productName, String internalName, String description, BigDecimal productWidth, BigDecimal productDepth, BigDecimal productHeight,
            BigDecimal productWeight, String imageUrl, String actionField, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("productId", productId);
        fields.put("productName", productName);
        fields.put("internalName", internalName);
        fields.put("description", description);
        fields.put("productTypeId", "FINISHED_GOOD");
        fields.put("requirementMethodEnumId", "PRODRQM_DS");
        fields.put("isVirtual", "N");
        fields.put("isVariant", "N");

        if(imageUrl != null){
            String prefixSmallImage = "/images/products/small/";
            String prefixMediumImage = "/images/products/medium/";
            String prefixLargeImage = "/images/products/large/";

            fields.put("smallImageUrl", prefixSmallImage+imageUrl);
            fields.put("mediumImageUrl", prefixMediumImage+imageUrl);
            fields.put("largeImageUrl", prefixLargeImage+imageUrl);
        }
        if(productWidth.compareTo(BigDecimal.ZERO) > 0){
            fields.put("productWidth", productWidth);
            fields.put("widthUomId", "LEN_cm");
        }
        if(productDepth.compareTo(BigDecimal.ZERO) > 0){
            fields.put("productDepth", productDepth);
            fields.put("depthUomId", "LEN_cm");
        }
        if(productHeight.compareTo(BigDecimal.ZERO) > 0){
            fields.put("productHeight", productHeight);
            fields.put("heightUomId", "LEN_cm");
        }
        if(productWeight.compareTo(BigDecimal.ZERO) > 0){
            fields.put("productWeight", productWeight);
            fields.put("weightUomId", "WT_kg");
        }
        if("delete".equals(actionField))
            fields.put("salesDiscontinuationDate",UtilDateTime.nowTimestamp());
            fields.put("userLogin", userLogin);
        return fields;
    }

    // prepare the DataResource map
    public static Map<String, Object> prepareDataResource(String dataResourceId,
            String localeString, String textData, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("dataResourceId", dataResourceId);
        fields.put("dataResourceTypeId", "ELECTRONIC_TEXT");
        fields.put("statusId", "CTNT_IN_PROGRESS");
        fields.put("localeString", localeString);
        fields.put("textData", textData);
        fields.put("userLogin", userLogin);
        return fields;
    }

    // prepare the product map
    public static Map<String, Object> prepareContent(String contentId, String dataResourceId,
            String localeString, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("contentId", contentId);
        fields.put("dataResourceId", dataResourceId);
        fields.put("contentTypeId", "DOCUMENT");
        fields.put("statusId", "CTNT_IN_PROGRESS");
        fields.put("localeString", localeString);
        fields.put("userLogin", userLogin);
        return fields;
    }

    // prepare the ProductContent map
    public static Map<String, Object> prepareContentAssoc(String contentId, String contentIdTo, Timestamp fromDate, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("contentId", contentId);
        fields.put("contentIdTo", contentIdTo);
        fields.put("contentAssocTypeId", "ALTERNATE_LOCALE");
        fields.put("fromDate", fromDate);
        fields.put("userLogin", userLogin);
        return fields;
    }

    // prepare the ProductContent map
    public static Map<String, Object> prepareProductContent(String productId, String contentId, Timestamp fromDate,
            String productContentTypeId, String actionField, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("productId", productId);
        fields.put("contentId", contentId);
        fields.put("productContentTypeId", productContentTypeId);
        fields.put("fromDate", fromDate);
        if("delete".equals(actionField))
            fields.put("thruDate",UtilDateTime.nowTimestamp());
        fields.put("userLogin", userLogin);
        return fields;
    }

    // prepare the SupplierProduct map
    public static Map<String, Object> prepareSupplierProduct(String productId, String supplierProductId, String supplierPartyId,BigDecimal supplierPrice,
            Timestamp availableFromDate, String actionField, BigDecimal minimumOrderQuantity, String currencyUomId, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("productId", productId);
        fields.put("partyId", supplierPartyId);
        fields.put("lastPrice", supplierPrice);
        fields.put("supplierProductId", supplierProductId);
//        fields.put("supplierProductName", supplierProductName);
        fields.put("currencyUomId", currencyUomId);
        fields.put("minimumOrderQuantity",minimumOrderQuantity);
        fields.put("availableFromDate",availableFromDate);
        if("delete".equals(actionField))
            fields.put("availableThruDate",UtilDateTime.nowTimestamp());
        fields.put("canDropShip","Y");
        fields.put("userLogin", userLogin);
        return fields;
    }

    // prepare the ProductContent map
    public static Map<String, Object> prepareProductPrice(String productId, BigDecimal salePrice, Timestamp fromDate, String currencyUomId, String productStoreGroupId
            , String actionField, GenericValue userLogin) {
        Map<String, Object> fields = new HashMap<String, Object>();
        fields.put("productId", productId);
        fields.put("productPriceTypeId", "DEFAULT_PRICE");
        fields.put("currencyUomId", currencyUomId);
        fields.put("productStoreGroupId", productStoreGroupId);
        fields.put("fromDate", fromDate);
        fields.put("productPricePurposeId", "PURCHASE");
        fields.put("userLogin", userLogin);
        if(!"delete".equals(actionField))
            fields.put("price", salePrice);
        return fields;
    }

    public static Map<String, Object> getDataResourceAndContent(String productId, String productContentTypeId, String localeString, Delegator delegator) {
        Map<String, Object> results = new HashMap<String, Object>();
        String dataResourceId = null;
        String contentId = null;
        GenericValue productContentGV = null;
        try {
            List<GenericValue> productContents = EntityUtil.filterByDate(delegator.findByAnd("ProductContent",
                    UtilMisc.toMap("productId", productId, "productContentTypeId", productContentTypeId), null, false));
            if(productContents.size()>0){
                productContentGV = EntityUtil.getFirst(productContents);
            }
        } catch (GenericEntityException e) {
            Debug.logError("Error finding ProductContent", module);
        }
        if(productContentGV != null){
            try {
                GenericValue content = productContentGV.getRelatedOne("Content", false);
                if("en".equals(localeString)){
                    GenericValue dataResource = content.getRelatedOne("DataResource", false);
                    dataResourceId = dataResource.getString("dataResourceId");
                    contentId = content.getString("contentId");
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
                        contentId = contentAssoc.getString("caContentIdTo");
                    }
                }
                results.put("contentId", contentId);
                results.put("dataResourceId", dataResourceId);
            } catch (GenericEntityException e) {
                Debug.logError("Error finding Content", module);
            }
        }
        return results;
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
                cellValue = String.valueOf(cell.getBooleanCellValue());
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