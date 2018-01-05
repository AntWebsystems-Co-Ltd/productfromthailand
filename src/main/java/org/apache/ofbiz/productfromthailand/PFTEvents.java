package org.apache.ofbiz.productfromthailand;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.paypal.base.*;
import com.paypal.base.exception.HttpErrorException;
import com.paypal.base.exception.InvalidResponseDataException;
import com.paypal.base.rest.*;
import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.transaction.GenericTransactionException;
import org.apache.ofbiz.entity.transaction.TransactionUtil;
import org.apache.ofbiz.entity.util.EntityQuery;
import org.apache.ofbiz.entity.util.EntityUtil;
import org.apache.ofbiz.entity.util.EntityUtilProperties;
import org.apache.ofbiz.order.order.OrderChangeHelper;
import org.apache.ofbiz.product.store.ProductStoreWorker;
import org.apache.ofbiz.service.DispatchContext;
import org.apache.ofbiz.service.GenericServiceException;
import org.apache.ofbiz.service.LocalDispatcher;
import org.apache.ofbiz.service.ModelService;
import org.apache.ofbiz.service.ServiceUtil;

import org.json.JSONObject;

public class PFTEvents {

    public static final String module = PFTEvents.class.getName();
    public static final String resource = "AccountingUiLabels";
    public static final String resourceErr = "AccountingErrorUiLabels";
    public static final String commonResource = "CommonUiLabels";
    /** Simple event to set the users per-session locale setting. The user's locale
     * setting should be passed as a "localeString" session attribute. */
    public static String setProductStoreAndSessionLocale(HttpServletRequest request, HttpServletResponse response) {
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        HttpSession session = request.getSession();

        String defaultLocaleString = (String) session.getAttribute("localeString");
        GenericValue productStore = null;
        GenericValue webSite = null;
        try {
            productStore = EntityUtil.getFirst(delegator.findByAnd("ProductStore", UtilMisc.toMap("defaultLocaleString", defaultLocaleString), null, false));
        } catch (GenericEntityException e) {
            Debug.logError(e, "Problems getting ProductStore", module);
            return "error";
        }

        if(productStore != null){
            session.setAttribute("productStoreId", productStore.getString("productStoreId"));
            session.setAttribute("currencyUom", productStore.getString("defaultCurrencyUomId"));
            try {
                webSite = EntityUtil.getFirst(productStore.getRelated("WebSite", UtilMisc.toMap("productStoreId", productStore.getString("productStoreId")), null, false));
            } catch (GenericEntityException e) {
                Debug.logError(e, "Problems getting WebSite", module);
                return "error";
            }
        }
        session.getServletContext().setAttribute("webSiteId", webSite.get("webSiteId"));

        return "success";
    }

    /** PayPal Call-Back Event */
    public static String payPalCallBack(HttpServletRequest request, HttpServletResponse response) {
        Locale locale = UtilHttp.getLocale(request);
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");

        // get the product store
        GenericValue productStore = ProductStoreWorker.getProductStore(request);
        if (productStore == null) {
            Debug.logError("ProductStore is null", module);
            request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.problemsGettingMerchantConfiguration", locale));
            return "error";
        }

        // get the payment properties file
        GenericValue paymentConfig = ProductStoreWorker.getProductStorePaymentSetting(delegator, productStore.getString("productStoreId"), "EXT_PAYPAL", null, true);

        String configString = null;
        String paymentGatewayConfigId = null;
        if (paymentConfig != null) {
            paymentGatewayConfigId = paymentConfig.getString("paymentGatewayConfigId");
            configString = paymentConfig.getString("paymentPropertiesPath");
        }

        if (configString == null) {
            configString = "payment.properties";
        }

        // get mode
        String apiEnvironment = getPaymentGatewayConfigValue(delegator, paymentGatewayConfigId, "apiEnvironment", configString, "payment.paypal.confirm");
        Debug.logInfo("Paypal environment is " + apiEnvironment, module);
        // get API URL
        String apiUrl = null;
        if (Constants.LIVE.equals(apiEnvironment)) {
            apiUrl = EntityUtilProperties.getPropertyValue("paypal", "paypal.apiUrl.live", delegator);
        } else {
            apiUrl = EntityUtilProperties.getPropertyValue("paypal", "paypal.apiUrl.sandbox", delegator);
        }
        if (UtilValidate.isEmpty(apiUrl)) {
            Debug.logError("Payment properties is not configured properly, no API URL defined!", module);
            request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.problemsGettingMerchantConfiguration", locale));
            return "error";
        }

        // first verify this is valid from PayPal
        Map <String, Object> parametersMap = UtilHttp.getParameterMap(request);
        String paypalOrderId = (String) parametersMap.get("tx");

        // Check Order Status
        String clientId = EntityUtilProperties.getPropertyValue("paypal", "paypal.clientId", delegator);
        String clientSecret = EntityUtilProperties.getPropertyValue("paypal", "paypal.clientSecret", delegator);
        Map<String, String> config = new HashMap<>();
        if (Constants.LIVE.equals(apiEnvironment)) {
            config.put(Constants.MODE, Constants.LIVE);
        } else {
            config.put(Constants.MODE, Constants.SANDBOX);
        }
        OAuthTokenCredential oAuthTokenCredential = new OAuthTokenCredential(clientId, clientSecret, config);
        String orderId = null;
        String paymentStatus = null;
        try {
            HttpConfiguration httpConfiguration = new HttpConfiguration();
            httpConfiguration.setHttpMethod("GET");
            httpConfiguration.setEndPointUrl(apiUrl + "v1/checkout/orders/" + paypalOrderId);
            httpConfiguration.setConnectionTimeout(300);
            HttpConnection httpConnection = new DefaultHttpConnection();
            httpConnection.createAndconfigureHttpConnection(httpConfiguration);
            String url = "v1/checkout/orders/" + parametersMap.get("tx");
            Map<String, String> headers = new HashMap<String, String>();
            headers.put("Authorization", oAuthTokenCredential.getAccessToken());
            headers.put("Content-Type", "application/json");
            String resp = httpConnection.execute(url, "", headers);
            JSONObject jsonObject = new JSONObject(resp);
            JSONObject purchaseUnits = (JSONObject) jsonObject.getJSONArray("purchase_units").get(0);
            Debug.log("### Paypal invoice_number: " + purchaseUnits.getString("invoice_number"));
            orderId = purchaseUnits.getString("invoice_number");
            request.setAttribute("orderId", orderId);

            // get the transaction status
            paymentStatus = jsonObject.getString("status");
        } catch (InvalidResponseDataException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (HttpErrorException e) {
            e.printStackTrace();
        } catch (PayPalRESTException e) {
            e.printStackTrace();
        }

        // get the system user
        GenericValue userLogin = null;
        try {
            userLogin = EntityQuery.use(delegator).from("UserLogin").where("userLoginId", "system").queryOne();
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get UserLogin for: system; cannot continue", module);
            request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.problemsGettingAuthenticationUser", locale));
            return "error";
        }

        // get the order header
        GenericValue orderHeader = null;
        if (UtilValidate.isNotEmpty(orderId)) {
            try {
                orderHeader = EntityQuery.use(delegator).from("OrderHeader").where("orderId", orderId).queryOne();
            } catch (GenericEntityException e) {
                Debug.logError(e, "Cannot get the order header for order: " + orderId, module);
                request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.problemsGettingOrderHeader", locale));
                return "error";
            }
        } else {
            Debug.logError("PayPal did not callback with a valid orderId!", module);
            request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.noValidOrderIdReturned", locale));
            return "error";
        }

        if (orderHeader == null) {
            Debug.logError("Cannot get the order header for order: " + orderId, module);
            request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.problemsGettingOrderHeader", locale));
            return "error";
        }


        // attempt to start a transaction
        boolean okay = true;
        boolean beganTransaction = false;
        try {
            beganTransaction = TransactionUtil.begin();

            if (paymentStatus.equals("COMPLETED")) {
                okay = OrderChangeHelper.approveOrder(dispatcher, userLogin, orderId);
            } else if (paymentStatus.equals("FAILED")) {
                List<String> payPalOrderIds = new LinkedList<String>();
                payPalOrderIds.add(orderId);
                List <GenericValue> orderItemAssocList = null;
                try {
                    orderItemAssocList = EntityQuery.use(delegator).from("OrderItemAssoc").where("orderId", orderId).queryList();
                    if (orderItemAssocList != null) {
                        for (GenericValue orderItemAssoc : orderItemAssocList) {
                            payPalOrderIds.add(orderItemAssoc.getString("toOrderId"));
                        }
                    }
                } catch (GenericEntityException e) {
                    Debug.logError(e, module);
                }
                for (String payPalOrderId : payPalOrderIds) {
                    okay = OrderChangeHelper.cancelOrder(dispatcher, userLogin, payPalOrderId);
                }
            }

            if (okay) {
                // set the payment preference
                okay = setPaymentPreferences(delegator, dispatcher, userLogin, orderId, request);
            }
        } catch (Exception e) {
            String errMsg = "Error handling PayPal notification";
            Debug.logError(e, errMsg, module);
            try {
                TransactionUtil.rollback(beganTransaction, errMsg, e);
            } catch (GenericTransactionException gte2) {
                Debug.logError(gte2, "Unable to rollback transaction", module);
            }
        } finally {
            if (!okay) {
                try {
                    TransactionUtil.rollback(beganTransaction, "Failure in processing PayPal callback", null);
                } catch (GenericTransactionException gte) {
                    Debug.logError(gte, "Unable to rollback transaction", module);
                }
            } else {
                try {
                    TransactionUtil.commit(beganTransaction);
                } catch (GenericTransactionException gte) {
                    Debug.logError(gte, "Unable to commit transaction", module);
                }
            }
        }


        if (okay) {
            // attempt to release the offline hold on the order (workflow)
            OrderChangeHelper.releaseInitialOrderHold(dispatcher, orderId);

            // call the email confirm service
            Map <String, String> emailContext = UtilMisc.toMap("orderId", orderId);
            try {
                dispatcher.runAsync("sendOrderConfirmation", emailContext, true);
            } catch (GenericServiceException e) {
                Debug.logError(e, "Problems sending email confirmation", module);
            }
        }

        GenericValue thisUserLogin = (GenericValue) request.getSession().getAttribute("userLogin");
        if(UtilValidate.isNotEmpty(thisUserLogin)) {
            if(UtilValidate.isNotEmpty(thisUserLogin.get("userLoginId"))) {
                return "success";
            }
        }
        return "anonSuccess";
    }

    private static String getPaymentGatewayConfigValue(Delegator delegator, String paymentGatewayConfigId,
            String paymentGatewayConfigParameterName, String resource, String parameterName) {
        String returnValue = "";
        if (UtilValidate.isNotEmpty(paymentGatewayConfigId)) {
            try {
                GenericValue payPal = EntityQuery.use(delegator).from("PaymentGatewayPayPal")
                        .where("paymentGatewayConfigId", paymentGatewayConfigId).queryOne();
                if (payPal != null) {
                    String payPalField = payPal.getString(paymentGatewayConfigParameterName);
                    if (payPalField != null) {
                        returnValue = payPalField.trim();
                    }
                }
            } catch (GenericEntityException e) {
                Debug.logError(e, module);
            }
        } else {
            String value = EntityUtilProperties.getPropertyValue(resource, parameterName, delegator);
            if (value != null) {
                returnValue = value.trim();
            }
        }
        return returnValue;
    }

    private static boolean setPaymentPreferences(Delegator delegator, LocalDispatcher dispatcher, GenericValue userLogin, String orderId, HttpServletRequest request) {
        Debug.logVerbose("Setting payment prefrences..", module);
        List <GenericValue> paymentPrefs = null;
        try {
            paymentPrefs = EntityQuery.use(delegator).from("OrderPaymentPreference").where("orderId", orderId, "statusId", "PAYMENT_NOT_RECEIVED").queryList();
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get payment preferences for order #" + orderId, module);
            return false;
        }
        if (paymentPrefs.size() > 0) {
            for (GenericValue pref : paymentPrefs) {
                boolean okay = setPaymentPreference(dispatcher, userLogin, pref, request);
                if (!okay)
                    return false;
            }
        }
        return true;
    }

    private static boolean setPaymentPreference(LocalDispatcher dispatcher, GenericValue userLogin, GenericValue paymentPreference, HttpServletRequest request) {
        Locale locale = UtilHttp.getLocale(request);
        String itemName = request.getParameter("item_name");
        String paymentAmount = request.getParameter("amt");
        String paymentStatus = request.getParameter("st");
        String transactionId = request.getParameter("tx");

        List <GenericValue> toStore = new LinkedList <GenericValue> ();

        paymentPreference.set("maxAmount", new BigDecimal(paymentAmount));
        if (paymentStatus.equals("Completed")) {
            paymentPreference.set("statusId", "PAYMENT_RECEIVED");
        } else if (paymentStatus.equals("Pending")) {
            paymentPreference.set("statusId", "PAYMENT_NOT_RECEIVED");
        } else {
            paymentPreference.set("statusId", "PAYMENT_CANCELLED");
        }
        toStore.add(paymentPreference);


        Delegator delegator = paymentPreference.getDelegator();

        // create the PaymentGatewayResponse
        String responseId = delegator.getNextSeqId("PaymentGatewayResponse");
        GenericValue response = delegator.makeValue("PaymentGatewayResponse");
        response.set("paymentGatewayResponseId", responseId);
        response.set("paymentServiceTypeEnumId", "PRDS_PAY_EXTERNAL");
        response.set("orderPaymentPreferenceId", paymentPreference.get("orderPaymentPreferenceId"));
        response.set("paymentMethodTypeId", paymentPreference.get("paymentMethodTypeId"));
        response.set("paymentMethodId", paymentPreference.get("paymentMethodId"));

        // set the auth info
        response.set("amount", new BigDecimal(paymentAmount));
        response.set("referenceNum", transactionId);
        response.set("gatewayCode", paymentStatus);
        response.set("gatewayFlag", paymentStatus.substring(0,1));
        response.set("gatewayMessage", itemName);
        response.set("transactionDate", UtilDateTime.nowTimestamp());
        toStore.add(response);

        try {
            delegator.storeAll(toStore);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot set payment preference/payment info", module);
            return false;
        }

        // create a payment record too
        Map <String, Object> results = null;
        try {
            String comment = UtilProperties.getMessage(resource, "AccountingPaymentReceiveViaPayPal", locale);
            results = dispatcher.runSync("createPaymentFromPreference", UtilMisc.toMap("userLogin", userLogin,
                    "orderPaymentPreferenceId", paymentPreference.get("orderPaymentPreferenceId"), "comments", comment));
        } catch (GenericServiceException e) {
            Debug.logError(e, "Failed to execute service createPaymentFromPreference", module);
            request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.failedToExecuteServiceCreatePaymentFromPreference", locale));
            return false;
        }

        if ((results == null) || (results.get(ModelService.RESPONSE_MESSAGE).equals(ModelService.RESPOND_ERROR))) {
            Debug.logError((String) results.get(ModelService.ERROR_MESSAGE), module);
            request.setAttribute("_ERROR_MESSAGE_", results.get(ModelService.ERROR_MESSAGE));
            return false;
        }

        return true;
    }

    public static Map<String, Object> thaiPostRateInquire(DispatchContext dctx, Map<String, ? extends Object> context) {
        String currencyUom = (String) context.get("currency");
        Delegator delegator = dctx.getDelegator();
        LocalDispatcher dispatcher = dctx.getDispatcher();
        Locale locale = (Locale) context.get("locale");
        String shipmentGatewayConfigId = (String) context.get("shipmentGatewayConfigId");
        BigDecimal estimateAmount = BigDecimal.ZERO;
        List<GenericValue> shippableItemInfo = UtilGenerics.checkList(context.get("shippableItemInfo"));
        List<Map<String, Object>> newListShippableItemInfo = new LinkedList<Map<String,Object>>();
        String checkSupplierTo = null;
        BigDecimal totalweight = BigDecimal.ZERO;
        BigDecimal quantity = BigDecimal.ZERO;
        BigDecimal amount = BigDecimal.ZERO;

        String serviceCode = null;
        try {
            GenericValue carrierShipmentMethod = EntityQuery.use(delegator).from("CarrierShipmentMethod")
                    .where("shipmentMethodTypeId", (String) context.get("shipmentMethodTypeId"), "partyId", (String) context.get("carrierPartyId"), "roleTypeId", (String) context.get("carrierRoleTypeId"))
                    .queryOne();
            if (carrierShipmentMethod != null) {
                serviceCode = carrierShipmentMethod.getString("carrierServiceCode").toUpperCase();
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
        }
        String partyCheckSupplier = null;
        if(UtilValidate.isNotEmpty(shippableItemInfo)) {
            for (Map<String, Object> itemInfo: shippableItemInfo) {
                try {
                    GenericValue productValue = EntityQuery.use(delegator).from("Product").where("productId",(String) itemInfo.get("productId")).cache().queryOne();
                    if(UtilValidate.isNotEmpty(productValue)) {
                        Map<String, Object> newMapListCtx = new HashMap<String, Object>();
                        if(UtilValidate.isNotEmpty(productValue.get("requirementMethodEnumId")) && (productValue.get("requirementMethodEnumId")).equals("PRODRQM_DS")){
                            if((productValue.get("isVariant")).equals("N")) {
                                partyCheckSupplier = (String) productValue.get("productId");
                            } else {
                                GenericValue productAssocValue = EntityQuery.use(delegator).from("ProductAssoc").where("productIdTo",(String) itemInfo.get("productId"), "productAssocTypeId", "PRODUCT_VARIANT").cache().queryFirst();
                                if(UtilValidate.isNotEmpty(productAssocValue)) {
                                    partyCheckSupplier = (String) productAssocValue.get("productId");
                                }
                            }
                            GenericValue supplierTo = EntityQuery.use(delegator).from("SupplierProduct").where("productId", partyCheckSupplier).queryFirst();
                            if (UtilValidate.isNotEmpty(supplierTo)) {
                                newMapListCtx.putAll(itemInfo);
                                newMapListCtx.put("supplierTo", supplierTo.getString("partyId"));
                                newListShippableItemInfo.add(newMapListCtx);
                            }
                        }else {
                            newMapListCtx.putAll(itemInfo);
                            newMapListCtx.put("supplierTo", null);
                            newListShippableItemInfo.add(newMapListCtx);
                        }
                    }
                } catch (GenericEntityException e) {
                    Debug.logError(e, module);
                }
            }
        }
        if (UtilValidate.isNotEmpty(newListShippableItemInfo)) {
            Collections.sort(newListShippableItemInfo, new Comparator<Map<String, Object>>() {
                public int compare(Map<String, Object> node1, Map<String, Object> node2) {
                    String title1 = (String) node1.get("supplierTo");
                    String title2 = (String) node2.get("supplierTo");
                    if (title1 == null || title2 == null) {
                        return 0;
                    }
                    return title1.compareTo(title2);
                }
            });
        }
        int conutLits = 0;
        for (Map<String, Object> itemInfo: newListShippableItemInfo) {
            conutLits ++;
            String supplierProductId = (String)itemInfo.get("supplierTo");
            String productId = (String)itemInfo.get("productId");
            if (supplierProductId == null || !supplierProductId.equals(checkSupplierTo)) {
                checkSupplierTo = supplierProductId;
                if(conutLits == shippableItemInfo.size()) {
                    if(totalweight.intValue()>BigDecimal.ZERO.intValue()) {
                        if(serviceCode.equals("THAIPOST_EMS")) {
                            amount = getRateThaiPost(totalweight, delegator);
                        }else {
                            amount = getInterRateThaiPost(totalweight, delegator);
                        }
                        quantity = (BigDecimal) itemInfo.get("quantity");
                        totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                        if(serviceCode.equals("THAIPOST_EMS")) {
                            amount = amount.add(getRateThaiPost(totalweight, delegator));
                        }else {
                            amount = amount.add(getInterRateThaiPost(totalweight, delegator));
                        }
                    }else {
                        quantity = (BigDecimal) itemInfo.get("quantity");
                        totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                        if(serviceCode.equals("THAIPOST_EMS")) {
                            amount = getRateThaiPost(totalweight, delegator);
                        }else {
                            amount = getInterRateThaiPost(totalweight, delegator);
                        }
                    }
                }else {
                    if(totalweight.intValue() > BigDecimal.ZERO.intValue()) {
                        if(serviceCode.equals("THAIPOST_EMS")) {
                            amount = getRateThaiPost(totalweight, delegator);
                        }else {
                            amount = getInterRateThaiPost(totalweight, delegator);
                        }
                        quantity = (BigDecimal) itemInfo.get("quantity");
                        totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                    }else {
                        quantity = (BigDecimal) itemInfo.get("quantity");
                        totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                    }
                }
            }else {
                if(conutLits == shippableItemInfo.size()) {
                    quantity = (BigDecimal) itemInfo.get("quantity");
                    totalweight = totalweight.add(getWeightProduct(productId,delegator).multiply(quantity));
                    if(amount.intValue() > BigDecimal.ZERO.intValue()) {
                        if(serviceCode.equals("THAIPOST_EMS")) {
                            amount = amount.add(getRateThaiPost(totalweight, delegator));
                        }else {
                            amount = amount.add(getInterRateThaiPost(totalweight, delegator));
                        }
                    }else {
                        if(serviceCode.equals("THAIPOST_EMS")) {
                            amount = getRateThaiPost(totalweight, delegator);
                        }else {
                            amount = getInterRateThaiPost(totalweight, delegator);
                        }
                    }
                }else {
                    quantity = (BigDecimal) itemInfo.get("quantity");
                    totalweight = totalweight.add(getWeightProduct(productId,delegator).multiply(quantity));
                }
            }
        }
        Map<String, Object> result = ServiceUtil.returnSuccess();
        result.put("shippingEstimateAmount", amount);
        return result;
    }

    public static BigDecimal getRateThaiPost(BigDecimal totalweight , Delegator delegator) {
        BigDecimal amount = BigDecimal.ZERO;
        int res;
        res = new BigDecimal (0.25).compareTo(totalweight);
        if(res == -1) {
            //weight between 0.25 - 0.5 KG
            res = new BigDecimal (0.5).compareTo(totalweight);
            if(res != -1) {
                amount = new BigDecimal (52.00);
            }else {
                //weight between 0.5-3 KG
                res = new BigDecimal (3.00).compareTo(totalweight);
                if(res != -1) {
                    BigDecimal startWeight = new BigDecimal (0.5);
                    int LoopCount = 0;
                    int resLoop = 0;
                    while (resLoop != 1) {
                        resLoop = startWeight.compareTo(totalweight);
                        if(resLoop == -1) {
                            startWeight = startWeight.add(new BigDecimal (0.5));
                            LoopCount ++;
                        } else if(resLoop == 0) {
                            resLoop = 1;
                        }
                    }
                    amount = new BigDecimal (67).add(new BigDecimal (15).multiply(new BigDecimal (LoopCount-1)));
                    int resOver2Kg = totalweight.compareTo(new BigDecimal (2.00));
                    if(resOver2Kg == 1) {
                        amount = new BigDecimal(122);
                        int resOverKg = totalweight.compareTo(new BigDecimal (2.5));
                        if(resOverKg == 1){
                            amount = new BigDecimal (137);
                        }
                    }
                }else {
                    res = new BigDecimal (5.00).compareTo(totalweight);
                    if(res != -1) {
                        //weight between 3-5 KG
                        BigDecimal startWeight = new BigDecimal (3);
                        int LoopCount = 0;
                        int resLoop = 0;
                        while (resLoop != 1) {
                            resLoop = startWeight.compareTo(totalweight);
                            if(resLoop == -1) {
                                startWeight = startWeight.add(new BigDecimal (0.5));
                                LoopCount ++;
                            } else if(resLoop == 0) {
                                resLoop = 1;
                            }
                        }
                        amount = new BigDecimal (157).add(new BigDecimal (20).multiply(new BigDecimal (LoopCount-1)));
                    }else {
                        res = new BigDecimal (8.00).compareTo(totalweight);
                        if(res != -1) {
                            //weight between 5-8 KG
                            BigDecimal startWeight = new BigDecimal (5);
                            int LoopCount = 0;
                            int resLoop = 0;
                            while (resLoop != 1) {
                                resLoop = startWeight.compareTo(totalweight);
                                if(resLoop == -1) {
                                    startWeight = startWeight.add(new BigDecimal (0.5));
                                    LoopCount ++;
                                } else if(resLoop == 0) {
                                    resLoop = 1;
                                }
                            }
                            amount = new BigDecimal (242).add(new BigDecimal (25).multiply(new BigDecimal (LoopCount-1)));
                        }else {
                            //weight between 8-10 KG
                            res = new BigDecimal (10.00).compareTo(totalweight);
                            if(res != -1) {
                                BigDecimal startWeight = new BigDecimal (8);
                                int LoopCount = 0;
                                int resLoop = 0;
                                while (resLoop != 1) {
                                    resLoop = startWeight.compareTo(totalweight);
                                    if(resLoop == -1) {
                                        startWeight = startWeight.add(new BigDecimal (0.5));
                                        LoopCount ++;
                                    } else if(resLoop == 0) {
                                        resLoop = 1;
                                    }
                                }
                                amount = new BigDecimal (397).add(new BigDecimal (30).multiply(new BigDecimal (LoopCount-1)));
                            }else {
                                //Over 10 KG
                                BigDecimal startWeight = new BigDecimal (10);
                                int LoopCount = 0;
                                int resLoop = 0;
                                while (resLoop != 1) {
                                    resLoop = startWeight.compareTo(totalweight);
                                    if(resLoop == -1) {
                                        startWeight = startWeight.add(new BigDecimal (1));
                                        LoopCount ++;
                                    } else if(resLoop == 0) {
                                        resLoop = 1;
                                    }
                                }
                                amount = new BigDecimal (502).add(new BigDecimal (15).multiply(new BigDecimal (LoopCount-1)));
                            }
                        }
                    }
                }
            }
        }else {
            //weight between 0 0.02KG
            res = new BigDecimal (0.02).compareTo(totalweight);
            if(res != -1) {
                amount = new BigDecimal (32.00);
            }else {
                res = new BigDecimal (0.1).compareTo(totalweight);
                if(res != -1) {
                    amount = new BigDecimal (37.00);
                }else {
                    amount = new BigDecimal (42.00);
                }
            }
        }
        return amount;
    }

    public static BigDecimal getInterRateThaiPost(BigDecimal totalweight , Delegator delegator) {
        BigDecimal amount = BigDecimal.ZERO;
        int res;
        //Over 1 KG
        BigDecimal startWeight = new BigDecimal (1);
        int LoopCount = 0;
        int resLoop = 0;
        while (resLoop != 1) {
            resLoop = startWeight.compareTo(totalweight);
            LoopCount ++;
            if(resLoop == -1) {
                startWeight = startWeight.add(new BigDecimal (1));
            } else if(resLoop == 0) {
                resLoop = 1;
            }
        }
        amount = new BigDecimal (950).add(new BigDecimal(500).multiply(new BigDecimal (LoopCount-1)));
        return amount;
    }

    public static BigDecimal getWeightProduct(String productId , Delegator delegator) {
        BigDecimal weightProudct = BigDecimal.ZERO;
        try {
            GenericValue productItem = EntityQuery.use(delegator).from("Product").where("productId", productId).cache().queryOne();
            if (UtilValidate.isNotEmpty(productItem)) {
                if((productItem.get("isVariant")).equals("N")) {
                    if (UtilValidate.isNotEmpty(productItem.get("productWeight"))) {
                        if(productItem.getString("weightUomId").equals("WT_g")) {
                            BigDecimal weightProudcts = (BigDecimal) productItem.get("productWeight");
                            weightProudct = (BigDecimal) weightProudcts.divide(BigDecimal.valueOf(1000), 3, RoundingMode.CEILING);
                        }else {
                            weightProudct = (BigDecimal) productItem.get("productWeight");
                        }
                    }
                }else {
                    GenericValue productAssoc = EntityQuery.use(delegator).from("ProductAssoc").where("productIdTo", productId, "productAssocTypeId", "PRODUCT_VARIANT").cache().queryFirst();
                    if(UtilValidate.isNotEmpty(productAssoc)) {
                        GenericValue productItemValue = EntityQuery.use(delegator).from("Product").where("productId", productAssoc.get("productId")).cache().queryOne();
                        if (UtilValidate.isNotEmpty(productItemValue.get("productWeight"))) {
                            if(productItemValue.getString("weightUomId").equals("WT_g")) {
                                BigDecimal weightProudcts = (BigDecimal) productItemValue.get("productWeight");
                                weightProudct = (BigDecimal) weightProudcts.divide(BigDecimal.valueOf(1000), 3, RoundingMode.CEILING);
                            }else {
                                weightProudct = (BigDecimal) productItemValue.get("productWeight");
                            }
                        }
                    }
                }
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
        }
        return weightProudct;
    }

    public static String cancelPayPalOrder(HttpServletRequest request, HttpServletResponse response) {
        Locale locale = UtilHttp.getLocale(request);
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        List<String> orderIds = new LinkedList<String>();

        GenericValue userLogin = null;
        try {
            userLogin = EntityQuery.use(delegator).from("UserLogin").where("userLoginId", "system").queryOne();
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
        }

        // get the stored order id from the session
        String payPalOrderId = (String) request.getSession().getAttribute("PAYPAL_ORDER");
        orderIds.add(payPalOrderId);
        List <GenericValue> orderItemAssocList = null;
        try {
            orderItemAssocList = EntityQuery.use(delegator).from("OrderItemAssoc").where("orderId", payPalOrderId).queryList();
            if (orderItemAssocList != null) {
                for (GenericValue orderItemAssoc : orderItemAssocList) {
                    orderIds.add(orderItemAssoc.getString("toOrderId"));
                }
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
        }

        for (String orderId : orderIds) {
            // attempt to start a transaction
            boolean beganTransaction = false;
            try {
                beganTransaction = TransactionUtil.begin();
            } catch (GenericTransactionException gte) {
                Debug.logError(gte, "Unable to begin transaction", module);
            }

            // cancel the order
            boolean okay = OrderChangeHelper.cancelOrder(dispatcher, userLogin, orderId);

            if (okay) {
                try {
                    TransactionUtil.commit(beganTransaction);
                } catch (GenericTransactionException gte) {
                    Debug.logError(gte, "Unable to commit transaction", module);
                }
            } else {
                try {
                    TransactionUtil.rollback(beganTransaction, "Failure in processing PayPal cancel callback", null);
                } catch (GenericTransactionException gte) {
                    Debug.logError(gte, "Unable to rollback transaction", module);
                }
            }

            // attempt to release the offline hold on the order (workflow)
            if (okay)
                OrderChangeHelper.releaseInitialOrderHold(dispatcher, orderId);

        }
        request.setAttribute("_EVENT_MESSAGE_", UtilProperties.getMessage(resourceErr, "payPalEvents.previousPayPalOrderHasBeenCancelled", locale));
        return "success";
    }
}