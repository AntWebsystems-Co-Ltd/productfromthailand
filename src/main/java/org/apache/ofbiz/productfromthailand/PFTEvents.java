package org.apache.ofbiz.productfromthailand;

import java.io.IOException;
import java.math.BigDecimal;
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
import org.apache.ofbiz.service.GenericServiceException;
import org.apache.ofbiz.service.LocalDispatcher;
import org.apache.ofbiz.service.ModelService;
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
                okay = OrderChangeHelper.cancelOrder(dispatcher, userLogin, orderId);
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

        return "success";
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
}