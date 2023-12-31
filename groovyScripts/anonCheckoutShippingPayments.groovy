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

import org.apache.ofbiz.base.util.*
import org.apache.ofbiz.entity.*
import org.apache.ofbiz.entity.util.*
import org.apache.ofbiz.accounting.payment.*
import org.apache.ofbiz.party.contact.*
import org.apache.ofbiz.product.store.*
import org.apache.ofbiz.order.shoppingcart.shipping.*

shoppingCart = session.getAttribute("shoppingCart")
shippingContactMechId = shoppingCart.getShippingContactMechId()
currencyUomId = shoppingCart.getCurrency()
partyId = shoppingCart.getPartyId()
party = from("Party").where("partyId", partyId).cache(true).queryOne()

// Estimate shipping cost
if (shoppingCart) {
    shippingList = [];
    shipGroupIndex = 0;
    for(shipGroup in shoppingCart.getShipGroups()) {
        shippingEstWpr = new ShippingEstimateWrapper(dispatcher, shoppingCart, shipGroupIndex);
        allEstimates = shippingEstWpr.getAllEstimates();
        for(oneEstimate in allEstimates) {
            checkNotInclude = true;
            listIndex = 0;
            plusIndex = 0;
            shipGroupEstimate = oneEstimate.getKey();
            estimateValue = oneEstimate.getValue();
            if(estimateValue > 0 || shipGroupEstimate.shipmentMethodTypeId.equals("FREE_SHIPPING")) {
                for(oneShipping in shippingList) {
                    if(oneShipping.productStoreShipMethId.equals(shipGroupEstimate.productStoreShipMethId)) {
                        oneShipping.shippingEst += estimateValue;
                        checkNotInclude = false;
                        break;
                    } else if(oneShipping.partyId.equals(shipGroupEstimate.partyId)) {
                        plusIndex = listIndex+1;
                    }
                    listIndex++;
                }
            } else {
                checkNotInclude = false;
            }
            if(checkNotInclude) {
                shippingMap = [:];
                shippingMap.put("productStoreShipMethId", shipGroupEstimate.productStoreShipMethId);
                shippingMap.put("shipmentMethodTypeId", shipGroupEstimate.shipmentMethodTypeId);
                shippingMap.put("description", shipGroupEstimate.description);
                shippingMap.put("partyId", shipGroupEstimate.partyId);
                shippingMap.put("shippingEst", 0+estimateValue);
                if(plusIndex == 0) {
                    shippingList.add(shippingMap);
                } else {
                    shippingList.add(plusIndex, shippingMap);
                }
            }
        }
        shipGroupIndex++;
    }
    context.ShippingList = shippingList;

    // Reassign items requiring drop-shipping to new or existing drop-ship groups
    shoppingCart.createDropShipGroups(dispatcher)
}
if(!shoppingCart.getShippingContactMechId().equals(shippingContactMechId)) {
    shoppingCart.setAllShippingContactMechId(shippingContactMechId);
}
context.shoppingCart = shoppingCart
shipToParty = from("Party").where("partyId", shoppingCart.getShipToCustomerPartyId()).cache(true).queryOne()
context.shippingContactMechList = ContactHelper.getContactMech(shipToParty, "SHIPPING_LOCATION", "POSTAL_ADDRESS", false)

profiledefs = from("PartyProfileDefault").where("partyId", userLogin.partyId, "productStoreId", productStoreId).queryOne()
context.profiledefs = profiledefs
if (shoppingCart.getShipmentMethodTypeId() && shoppingCart.getCarrierPartyId()) {
    context.chosenShippingMethod = shoppingCart.getShipmentMethodTypeId() + '@' + shoppingCart.getCarrierPartyId()
} else if (profiledefs?.defaultShipMeth) {
    context.chosenShippingMethod = profiledefs.defaultShipMeth
}

// create a list containing all the parties associated to the current cart, useful to change
// the ship to party id
cartParties = [shoppingCart.getShipToCustomerPartyId()]
if (!cartParties.contains(partyId)) {
    cartParties.add(partyId)
}
if (!cartParties.contains(shoppingCart.getOrderPartyId())) {
    cartParties.add(shoppingCart.getOrderPartyId())
}
if (!cartParties.contains(shoppingCart.getPlacingCustomerPartyId())) {
    cartParties.add(shoppingCart.getPlacingCustomerPartyId())
}
if (!cartParties.contains(shoppingCart.getBillToCustomerPartyId())) {
    cartParties.add(shoppingCart.getBillToCustomerPartyId())
}
if (!cartParties.contains(shoppingCart.getEndUserCustomerPartyId())) {
    cartParties.add(shoppingCart.getEndUserCustomerPartyId())
}
if (!cartParties.contains(shoppingCart.getSupplierAgentPartyId())) {
    cartParties.add(shoppingCart.getSupplierAgentPartyId())
}
salesReps = shoppingCart.getAdditionalPartyRoleMap().SALES_REP
if (salesReps) {
    salesReps.each { salesRep ->
        if (!cartParties.contains(salesRep)) {
            cartParties.add(salesRep)
        }
    }
}
context.cartParties = cartParties