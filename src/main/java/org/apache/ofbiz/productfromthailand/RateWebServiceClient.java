package org.apache.ofbiz.productfromthailand;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;

import org.apache.axis.types.NonNegativeInteger;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.base.util.UtilGenerics;
import org.apache.ofbiz.base.util.UtilProperties;
import org.apache.ofbiz.base.util.UtilValidate;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.util.EntityQuery;
import org.apache.ofbiz.entity.util.EntityUtilProperties;
import org.apache.ofbiz.entity.condition.OrderByList;
import org.apache.ofbiz.service.DispatchContext;
import org.apache.ofbiz.service.ServiceUtil;
import org.apache.ofbiz.service.LocalDispatcher;

import com.fedex.rate.stub.Address;
import com.fedex.rate.stub.ClientDetail;
import com.fedex.rate.stub.CurrencyExchangeRate;
import com.fedex.rate.stub.Dimensions;
import com.fedex.rate.stub.DropoffType;
import com.fedex.rate.stub.LinearUnits;
import com.fedex.rate.stub.Money;
import com.fedex.rate.stub.Notification;
import com.fedex.rate.stub.NotificationSeverityType;
import com.fedex.rate.stub.PackageSpecialServicesRequested;
import com.fedex.rate.stub.PackagingType;
import com.fedex.rate.stub.Party;
import com.fedex.rate.stub.Payment;
import com.fedex.rate.stub.PaymentType;
import com.fedex.rate.stub.RatePortType;
import com.fedex.rate.stub.RateReply;
import com.fedex.rate.stub.RateReplyDetail;
import com.fedex.rate.stub.RateRequest;
import com.fedex.rate.stub.RateServiceLocator;
import com.fedex.rate.stub.RatedShipmentDetail;
import com.fedex.rate.stub.RequestedPackageLineItem;
import com.fedex.rate.stub.RequestedShipment;
import com.fedex.rate.stub.ServiceType;
import com.fedex.rate.stub.ShipmentRateDetail;
import com.fedex.rate.stub.TransactionDetail;
import com.fedex.rate.stub.VersionId;
import com.fedex.rate.stub.WebAuthenticationCredential;
import com.fedex.rate.stub.WebAuthenticationDetail;
import com.fedex.rate.stub.Weight;
import com.fedex.rate.stub.WeightUnits;

/**
 * Sample code to call Rate Web Service with Axis
 * <p>
 * com.fedex.rate.stub is generated via WSDL2Java, like this:<br>
 * <pre>
 * java org.apache.axis.wsdl.WSDL2Java -w -p com.fedex.rate.stub http://www.fedex.com/...../RateService?wsdl
 * </pre>
 *
 * This sample code has been tested with JDK 7 and Apache Axis 1.4
 */
public class RateWebServiceClient {
    public final static String module = RateWebServiceClient.class.getName();
    public final static String resourceError = "ProductUiLabels";
    private static List<String> domesticCountries = new LinkedList<String>();
    // Countries treated as domestic for rate enquiries
    static {
        domesticCountries.add("USA");
        domesticCountries.add("ASM");
        domesticCountries.add("GU");
        domesticCountries.add("THA");
        domesticCountries = Collections.unmodifiableList(domesticCountries);
    }

    public static Map<String, Object> fedexRateInquire(DispatchContext dctx, Map<String, ? extends Object> context) {
        String currencyUom = (String) context.get("currency");
        Delegator delegator = dctx.getDelegator();
        LocalDispatcher dispatcher = dctx.getDispatcher();
        String shipmentGatewayConfigId = (String) context.get("shipmentGatewayConfigId");
        List<GenericValue> shippableItemInfo = UtilGenerics.checkList(context.get("shippableItemInfo"));
        String resource = (String) context.get("configProps");
        Locale locale = (Locale) context.get("locale");
        BigDecimal estimateAmount = BigDecimal.ZERO;

        RateRequest request = new RateRequest();
        request.setClientDetail(createClientDetail(delegator));
        request.setWebAuthenticationDetail(createWebAuthenticationDetail(delegator));
        request.setReturnTransitAndCommit(true);
        //
        TransactionDetail transactionDetail = new TransactionDetail();
        transactionDetail.setCustomerTransactionId("java sample - Rate Request"); // The client will get the same value back in the response
        request.setTransactionDetail(transactionDetail);
        //
        VersionId versionId = new VersionId("crs", 22, 0, 0);

        request.setVersion(versionId);
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
        if (UtilValidate.isEmpty(serviceCode)) {
            return ServiceUtil.returnError(UtilProperties.getMessage(resourceError,
                    "FacilityShipmentUspsUnableDetermineServiceCode", locale));
        }
        //
        RequestedShipment requestedShipment = new RequestedShipment();
        requestedShipment.setShipTimestamp(Calendar.getInstance());
        requestedShipment.setDropoffType(DropoffType.REGULAR_PICKUP);
        requestedShipment.setServiceType(new ServiceType(serviceCode));
        requestedShipment.setPackagingType(PackagingType.YOUR_PACKAGING);
        String supplierProductId = null;
        String fedexCurrency = null;
        BigDecimal totalweight = BigDecimal.ZERO;
        BigDecimal quantity = BigDecimal.ZERO;

        Address shipperAddress = null; // Origin information
        String partyContactMechForm = null;
        List<String> sortList = org.apache.ofbiz.base.util.UtilMisc.toList("supplierTo");

        if(UtilValidate.isNotEmpty(shippableItemInfo)) {
            List<Map<String, Object>> newListShippableItemInfo = new LinkedList<Map<String,Object>>();
            for (Map<String, Object> itemInfo: shippableItemInfo) {
                try {
                    Map<String, Object> newMapListCtx = new HashMap<String, Object>();
                    GenericValue supplierTo2 = EntityQuery.use(delegator).from("SupplierProduct").where("productId", (String) itemInfo.get("productId")).queryFirst();
                    if (UtilValidate.isNotEmpty(supplierTo2)) {
                        newMapListCtx.putAll(itemInfo);
                        newMapListCtx.put("supplierTo", supplierTo2.getString("partyId"));
                        newListShippableItemInfo.add(newMapListCtx);
                    }
                }catch (Exception e) {
                    e.printStackTrace();
                }
            }
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
            int countList = 0;
            for (Map<String, Object> itemInfo: newListShippableItemInfo) {
                String productId = (String)itemInfo.get("productId");
                countList ++;
                try {
                    GenericValue supplierTo = EntityQuery.use(delegator).from("SupplierProduct").where("productId", productId).queryFirst();
                    if(UtilValidate.isNotEmpty(supplierTo)) {
                        String checkSupplierTo = supplierTo.getString("partyId");
                        if(supplierProductId == null || !supplierProductId.equals(checkSupplierTo)) {
                            //Add shipper address
                            GenericValue partyContactMechPurpose = EntityQuery.use(delegator).from("PartyContactMechPurpose").where("partyId", supplierTo.getString("partyId"), "contactMechPurposeTypeId", "SHIP_ORIG_LOCATION").queryFirst();
                            if(UtilValidate.isNotEmpty(partyContactMechPurpose)) {
                                partyContactMechForm = partyContactMechPurpose.getString("contactMechId");
                            }else {
                                GenericValue partyContactMechGeneral = EntityQuery.use(delegator).from("PartyContactMechPurpose").where("partyId", supplierTo.getString("partyId"), "contactMechPurposeTypeId", "GENERAL_LOCATION").queryFirst();
                                if(UtilValidate.isNotEmpty(partyContactMechGeneral)) {
                                    partyContactMechForm = partyContactMechGeneral.getString("contactMechId");
                                }
                            }
                            if(UtilValidate.isNotEmpty(shipperAddress)) {
                                Party shipper = new Party();
                                shipper.setAddress(shipperAddress);
                                requestedShipment.setRecipient(shipper);
                                Party recipient = new Party();
                                String shippingContactMechId = (String) context.get("shippingContactMechId");
                                Address recipientAddress = addAddress(shippingContactMechId, delegator);
                                recipient.setAddress(recipientAddress);
                                requestedShipment.setShipper(recipient);
                                //calcula Rateing
                                Map<String, Object> resultCalculaRates = calculaRate(requestedShipment,request, totalweight);
                                System.out.println("resultCalculaRates :::::::::::: "+resultCalculaRates);
                                estimateAmount = estimateAmount.add((BigDecimal) resultCalculaRates.get("estimateAmount"));
                                fedexCurrency = (String)resultCalculaRates.get("currency");
                                if(countList == shippableItemInfo.size()) {
                                    quantity = (BigDecimal) itemInfo.get("quantity");
                                    totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                                    shipperAddress = new Address();
                                    shipperAddress = addAddress(partyContactMechForm, delegator);
                                    //calcula Rateing
                                    Map<String, Object> resultCalculaRate1 = calculaRate(requestedShipment,request, totalweight);
                                    estimateAmount = estimateAmount.add((BigDecimal) resultCalculaRate1.get("estimateAmount"));
                                    fedexCurrency = (String)resultCalculaRate1.get("currency");
                                }else {
                                    supplierProductId = checkSupplierTo;
                                    quantity = (BigDecimal) itemInfo.get("quantity");
                                    totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                                    shipperAddress = new Address();
                                    shipperAddress = addAddress(partyContactMechForm, delegator);
                                }
                            }else {
                                if(countList == shippableItemInfo.size()) {
                                    supplierProductId = checkSupplierTo;
                                    quantity = (BigDecimal) itemInfo.get("quantity");
                                    totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                                    shipperAddress = new Address();
                                    shipperAddress = addAddress(partyContactMechForm, delegator);
                                    Party shipper = new Party();
                                    shipper.setAddress(shipperAddress);
                                    requestedShipment.setRecipient(shipper);
                                    Party recipient = new Party();
                                    String shippingContactMechId = (String) context.get("shippingContactMechId");
                                    Address recipientAddress = addAddress(shippingContactMechId, delegator);
                                    recipient.setAddress(recipientAddress);
                                    requestedShipment.setShipper(recipient);
                                    //calcula Rateing
                                    Map<String, Object> resultCalculaRate2 = calculaRate(requestedShipment,request, totalweight);
                                    estimateAmount = estimateAmount.add((BigDecimal) resultCalculaRate2.get("estimateAmount"));
                                    fedexCurrency = (String)resultCalculaRate2.get("currency");
                                }else {
                                    supplierProductId = checkSupplierTo;
                                    quantity = (BigDecimal) itemInfo.get("quantity");
                                    totalweight = getWeightProduct(productId,delegator).multiply(quantity);
                                    shipperAddress = new Address();
                                    shipperAddress = addAddress(partyContactMechForm, delegator);
                                }
                            }
                        }else {
                            quantity = (BigDecimal) itemInfo.get("quantity");
                            totalweight = totalweight.add(getWeightProduct(productId,delegator).multiply(quantity));
                            if(countList == shippableItemInfo.size()) {
                                if(UtilValidate.isNotEmpty(shipperAddress)) {
                                    Party shipper = new Party();
                                    shipper.setAddress(shipperAddress);
                                    requestedShipment.setRecipient(shipper);
                                    Party recipient = new Party();
                                    String shippingContactMechId = (String) context.get("shippingContactMechId");
                                    Address recipientAddress = addAddress(shippingContactMechId, delegator);
                                    recipient.setAddress(recipientAddress);
                                    requestedShipment.setShipper(recipient);
                                    //calcula Rateing
                                    Map<String, Object> resultCalculaRate3 = calculaRate(requestedShipment,request, totalweight);
                                    estimateAmount = estimateAmount.add((BigDecimal) resultCalculaRate3.get("estimateAmount"));
                                    fedexCurrency = (String)resultCalculaRate3.get("currency");
                                }
                            }
                        }
                    }
                }catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        if (UtilValidate.isEmpty(currencyUom)) {
            currencyUom = EntityUtilProperties.getPropertyValue("general", "currency.uom.id.default", "USD", delegator);
        }
        try {
            Map<String, Object> convertCurrencyCtx = new HashMap<String, Object>();
            convertCurrencyCtx.put("uomIdTo",currencyUom);
            convertCurrencyCtx.put("uomId",fedexCurrency);
            convertCurrencyCtx.put("originalValue",estimateAmount);
            if(!currencyUom.equals(fedexCurrency) && UtilValidate.isNotEmpty(fedexCurrency)) {
                Map<String, Object> resultConvert = dispatcher.runSync("convertUom", convertCurrencyCtx);
                estimateAmount = (BigDecimal) resultConvert.get("convertedValue");
            }else {estimateAmount = estimateAmount;}
        }catch (Exception e) {
            e.printStackTrace();
        }
        Map<String, Object> result = ServiceUtil.returnSuccess();
        result.put("shippingEstimateAmount", estimateAmount);
        return result;
    }

    public static Map<String, Object> writeServiceOutput(RateReply reply) {
        RateReplyDetail[] rrds = reply.getRateReplyDetails();
        Map<String, Object> result = ServiceUtil.returnSuccess();
        BigDecimal totalNetCharge = BigDecimal.ZERO;
        for (int i = 0; i < rrds.length; i++) {
            RateReplyDetail rrd = rrds[i];
            RatedShipmentDetail[] rsds = rrd.getRatedShipmentDetails();
            for (int j = 0; j < rsds.length; j++) {
                RatedShipmentDetail rsd = rsds[j];
                ShipmentRateDetail srd = rsd.getShipmentRateDetail();
                totalNetCharge = totalNetCharge.add(srd.getTotalNetCharge().getAmount());
                System.out.println("totalNetCharge :::::::::::: "+totalNetCharge);
                result.put("estimateAmount", totalNetCharge);
                result.put("currency", srd.getTotalNetCharge().getCurrency());
            }
        }
        return result;
    }

    private static ClientDetail createClientDetail(Delegator delegator) {
        ClientDetail clientDetail = new ClientDetail();
        String accountNumber = EntityUtilProperties.getPropertyValue("fedex", "fedexaccountnum", "510087380", delegator);
        String meterNumber = EntityUtilProperties.getPropertyValue("fedex", "fedexmeternum", "118965778", delegator);
        //
        // See if the accountNumber and meterNumber properties are set,
        // if set use those values, otherwise default them to "XXX"
        //
        if (accountNumber == null) {
            accountNumber = "510087380"; // Replace "XXX" with clients account number
        }
        if (meterNumber == null) {
            meterNumber = "118965778"; // Replace "XXX" with clients meter number
        }
        clientDetail.setAccountNumber(accountNumber);
        clientDetail.setMeterNumber(meterNumber);
        return clientDetail;
    }

    private static WebAuthenticationDetail createWebAuthenticationDetail(Delegator delegator) {
        WebAuthenticationCredential userCredential = new WebAuthenticationCredential();
        String key = EntityUtilProperties.getPropertyValue("fedex", "fedexapikey", "aFP6Cx8GTwP7dqn0", delegator);
        String password = EntityUtilProperties.getPropertyValue("fedex", "fedexpassword", "kNW57I5rdTKoR1wy5o7Klx3y3", delegator);
        //
        // See if the key and password properties are set,
        // if set use those values, otherwise default them to "XXX"
        //
        if (key == null) {
            key = "aFP6Cx8GTwP7dqn0"; // Replace "XXX" with clients key
        }
        if (password == null) {
            password = "kNW57I5rdTKoR1wy5o7Klx3y3"; // Replace "XXX" with clients password
        }
        userCredential.setKey(key);
        userCredential.setPassword(password);

        WebAuthenticationCredential parentCredential = null;
        Boolean useParentCredential=false; //Set this value to true is using a parent credential
        if(useParentCredential){
            String parentKey = System.getProperty("parentkey");
            String parentPassword = System.getProperty("parentpassword");
            //
            // See if the parentkey and parentpassword properties are set,
            // if set use those values, otherwise default them to "XXX"
            //
            if (parentKey == null) {
                parentKey = "XXX"; // Replace "XXX" with clients parent key
            }
            if (parentPassword == null) {
                parentPassword = "XXX"; // Replace "XXX" with clients parent password
            }
            parentCredential = new WebAuthenticationCredential();
            parentCredential.setKey(parentKey);
            parentCredential.setPassword(parentPassword);
        }
        return new WebAuthenticationDetail(parentCredential, userCredential);
    }

    private static void printNotifications(Notification[] notifications) {
        System.out.println("Notifications:");
        if (notifications == null || notifications.length == 0) {
            System.out.println("  No notifications returned");
        }
        for (int i=0; i < notifications.length; i++){
            Notification n = notifications[i];
            System.out.print("  Notification no. " + i + ": ");
            if (n == null) {
                System.out.println("null");
                continue;
            } else {
                System.out.println("");
            }
            NotificationSeverityType nst = n.getSeverity();
            System.out.println("    Severity: " + (nst == null ? "null" : nst.getValue()));
            System.out.println("    Code: " + n.getCode());
            System.out.println("    Message: " + n.getMessage());
            System.out.println("    Source: " + n.getSource());
        }
    }

    private static boolean isResponseOk(NotificationSeverityType notificationSeverityType) {
        if (notificationSeverityType == null) {
            return false;
        }
        if (notificationSeverityType.equals(NotificationSeverityType.WARNING) ||
            notificationSeverityType.equals(NotificationSeverityType.NOTE)    ||
            notificationSeverityType.equals(NotificationSeverityType.SUCCESS)) {
            return true;
        }
        return false;
    }

    private static void updateEndPoint(RateServiceLocator serviceLocator) {
        String endPoint = System.getProperty("endPoint");
        if (endPoint != null) {
            serviceLocator.setRateServicePortEndpointAddress(endPoint);
        }
    }

    public static BigDecimal getWeightProduct(String productId , Delegator delegator) {
        BigDecimal weightProudct = BigDecimal.ZERO;
        try {
            GenericValue productItem = EntityQuery.use(delegator).from("Product").where("productId", productId).cache().queryOne();
            if (UtilValidate.isNotEmpty(productItem)) {
                if(productItem.getString("weightUomId").equals("WT_g")) {
                    BigDecimal weightProudcts = (BigDecimal) productItem.get("productWeight");
                    weightProudct = (BigDecimal) weightProudcts.divide(BigDecimal.valueOf(1000), 3, RoundingMode.CEILING);
                }else {
                    weightProudct = (BigDecimal) productItem.get("productWeight");
                }
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
        }
        return weightProudct;
    }

    public static Address addAddress (String partyContactMechForm , Delegator delegator) {
        Address address = new Address ();
        if (partyContactMechForm != null) {
            try {
                GenericValue shipFromAddress = EntityQuery.use(delegator).from("PostalAddress").where("contactMechId", partyContactMechForm).queryOne();
                if (shipFromAddress != null) {
                    String countryCodeId = null;
                    String stateProvinceGeoCodeId = null;
                    GenericValue geoCode = EntityQuery.use(delegator).from("Geo").where("geoId", shipFromAddress.getString("countryGeoId")).queryOne();
                    if(UtilValidate.isNotEmpty(geoCode)) {
                        countryCodeId = geoCode.getString("geoCode");
                    }else {
                        countryCodeId = shipFromAddress.getString("countryGeoId");
                    }
                    GenericValue stateProvinceGeoCode = EntityQuery.use(delegator).from("Geo").where("geoId", shipFromAddress.getString("stateProvinceGeoId")).queryOne();
                    if(UtilValidate.isNotEmpty(stateProvinceGeoCode)) {
                        stateProvinceGeoCodeId = stateProvinceGeoCode.getString("geoCode");
                    }else {
                        stateProvinceGeoCodeId = shipFromAddress.getString("stateProvinceGeoId");
                    }
                    address.setPostalCode(shipFromAddress.getString("postalCode"));
                    address.setStreetLines(new String[] {shipFromAddress.getString("address1")});
                    address.setCity(shipFromAddress.getString("city"));
                    address.setStateOrProvinceCode(stateProvinceGeoCodeId);
                    address.setCountryCode(countryCodeId);
                }
            } catch (GenericEntityException e) {
                Debug.logError(e, module);
            }
        }
        return address;
    }
    public static Map<String, Object> calculaRate (RequestedShipment requestedShipment, RateRequest request, BigDecimal totalweight) {
        BigDecimal amount = BigDecimal.ZERO;
        Map<String, Object> result = ServiceUtil.returnSuccess();
        Payment shippingChargesPayment = new Payment();
        shippingChargesPayment.setPaymentType(PaymentType.SENDER);
        requestedShipment.setShippingChargesPayment(shippingChargesPayment);
        RequestedPackageLineItem rp = new RequestedPackageLineItem();
        rp.setGroupPackageCount(new NonNegativeInteger("1"));
        rp.setWeight(new Weight(WeightUnits.KG, totalweight)); //type Units, weight total
        PackageSpecialServicesRequested pssr = new PackageSpecialServicesRequested();
        rp.setSpecialServicesRequested(pssr);
        requestedShipment.setRequestedPackageLineItems(new RequestedPackageLineItem[] {rp});
        requestedShipment.setPackageCount(new NonNegativeInteger("1"));
        request.setRequestedShipment(requestedShipment);
        try {
            // Initialize the service
            RateServiceLocator service;
            RatePortType port;
            //
            service = new RateServiceLocator();
            updateEndPoint(service);
            port = service.getRateServicePort();
            // This is the call to the web service passing in a RateRequest and returning a RateReply
            RateReply reply = port.getRates(request); // Service call
            if (isResponseOk(reply.getHighestSeverity())) {
                result = writeServiceOutput(reply);
            }else {
                result.put("estimateAmount", BigDecimal.ZERO);
                result.put("currency", "USD");
            }
            printNotifications(reply.getNotifications());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
