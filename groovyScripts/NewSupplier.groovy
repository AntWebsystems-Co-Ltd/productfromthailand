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
import org.apache.ofbiz.base.util.UtilProperties;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.product.store.ProductStoreWorker;

productStore = ProductStoreWorker.getProductStore(request);
context.productStoreId = productStore.productStoreId;
context.productStore = productStore;

context.createAllowPassword = "Y".equals(productStore.allowPassword);
context.getUsername = !"Y".equals(productStore.usePrimaryEmailUsername);

// load the geo names for selected countries and states/regions
if (parameters.shipToCountryGeoId) {
    geoValue = delegator.findOne("Geo", [geoId : parameters.shipToCountryGeoId], false)
    if (geoValue) {
        context.selectedCountryName = geoValue.geoName;
    }
}

if (parameters.shipToStateProvinceGeoId) {
    geoValue = delegator.findOne("Geo", [geoId : parameters.shipToStateProvinceGeoId], false)
    if (geoValue) {
        context.selectedStateName = geoValue.geoName;
    }
}

previousParams = parameters._PREVIOUS_PARAMS_;
if (previousParams) {
    previousParams = "?" + previousParams;
} else {
    previousParams = "";
}
context.previousParams = previousParams;

// Get party detail
if (parameters.partyId) {
    // Get party name
    getPartyNameForDate = dispatcher.runSync("getPartyNameForDate", [partyId: parameters.partyId, userLogin: userLogin]);
    if (getPartyNameForDate) {
        if (getPartyNameForDate.personalTitle) {
            context.personalTitle = getPartyNameForDate.personalTitle;
        }
        if (getPartyNameForDate.firstName) {
            context.firstName = getPartyNameForDate.firstName;
        }
        if (getPartyNameForDate.lastName) {
            context.lastName = getPartyNameForDate.lastName;
        }
        if (getPartyNameForDate.groupName) {
            context.groupName = getPartyNameForDate.groupName;
        }
    }
    // Get party email
    getPartyEmail = dispatcher.runSync("getPartyEmail", [partyId: parameters.partyId, userLogin: userLogin]);
    if (getPartyEmail && getPartyEmail.emailAddress) {
        context.emailAddress = getPartyEmail.emailAddress;
    }
    // Get party id number
    getIdNo = from("PartyIdentification").where("partyId", parameters.partyId, "partyIdentificationTypeId", "ID_NUMBER").queryOne();
    if (getIdNo) {
        context.idCardNo = getIdNo.idValue;
    }
    // Get company registration number
    getRegisNo = from("PartyIdentification").where("partyId", parameters.partyId, "partyIdentificationTypeId", "ID_BIZ_REGISTER_NO").queryOne();
    if (getRegisNo) {
        context.businessRegistNo = getRegisNo.idValue;
    }
    // Get party address
    getPartyPostalAddress = dispatcher.runSync("getPartyPostalAddress", [partyId: parameters.partyId, userLogin: userLogin]);
    if (getPartyPostalAddress) {
        if (getPartyPostalAddress.address1) {
            context.shipToAddress1 = getPartyPostalAddress.address1;
        }
        if (getPartyPostalAddress.address2) {
            context.shipToAddress2 = getPartyPostalAddress.address2;
        }
        if (getPartyPostalAddress.city) {
            context.shipToCity = getPartyPostalAddress.city;
        }
        if (getPartyPostalAddress.postalCode) {
            context.shipToPostalCode = getPartyPostalAddress.postalCode;
        }
        if (getPartyPostalAddress.stateProvinceGeoId) {
            context.shipToStateProvinceGeoId = getPartyPostalAddress.stateProvinceGeoId;
        }
        if (getPartyPostalAddress.countryGeoId) {
            context.shipToCountryGeoId = getPartyPostalAddress.countryGeoId;
        }
    }
    // Get home phone
    getHomeTelephone = dispatcher.runSync("getPartyTelephone", [partyId: parameters.partyId, contactMechPurposeTypeId: "PHONE_HOME", userLogin: userLogin]);
    if (getHomeTelephone) {
        if (getHomeTelephone.countryCode) {
            context.homeCountryCode = getHomeTelephone.countryCode;
        }
        if (getHomeTelephone.areaCode) {
            context.homeAreaCode = getHomeTelephone.areaCode;
        }
        if (getHomeTelephone.contactNumber) {
            context.homeContactNumber = getHomeTelephone.contactNumber;
        }
        if (getHomeTelephone.extension) {
            context.homeExtension = getHomeTelephone.extension;
        }
    }
    // Get work phone
    getWorkTelephone = dispatcher.runSync("getPartyTelephone", [partyId: parameters.partyId, contactMechPurposeTypeId: "PHONE_WORK", userLogin: userLogin]);
    if (getWorkTelephone) {
        if (getWorkTelephone.countryCode) {
            context.workCountryCode = getWorkTelephone.countryCode;
        }
        if (getWorkTelephone.areaCode) {
            context.workAreaCode = getWorkTelephone.areaCode;
        }
        if (getWorkTelephone.contactNumber) {
            context.workContactNumber = getWorkTelephone.contactNumber;
        }
        if (getWorkTelephone.extension) {
            context.workExtension = getWorkTelephone.extension;
        }
    }
    // Get fax number
    getFaxTelephone = dispatcher.runSync("getPartyTelephone", [partyId: parameters.partyId, contactMechPurposeTypeId: "FAX_NUMBER", userLogin: userLogin]);
    if (getFaxTelephone) {
        if (getFaxTelephone.countryCode) {
            context.faxCountryCode = getFaxTelephone.countryCode;
        }
        if (getFaxTelephone.areaCode) {
            context.faxAreaCode = getFaxTelephone.areaCode;
        }
        if (getFaxTelephone.contactNumber) {
            context.faxContactNumber = getFaxTelephone.contactNumber;
        }
    }
    // Get mobile phone
    getMobileTelephone = dispatcher.runSync("getPartyTelephone", [partyId: parameters.partyId, contactMechPurposeTypeId: "PHONE_MOBILE", userLogin: userLogin]);
    if (getMobileTelephone) {
        if (getMobileTelephone.countryCode) {
            context.mobileCountryCode = getMobileTelephone.countryCode;
        }
        if (getMobileTelephone.areaCode) {
            context.mobileAreaCode = getMobileTelephone.areaCode;
        }
        if (getMobileTelephone.contactNumber) {
            context.mobileContactNumber = getMobileTelephone.contactNumber;
        }
    }

    getPartyType = from("Party").where("partyId", parameters.partyId).queryOne();
    context.partyType = getPartyType.partyTypeId ?: "PERSON";
}
