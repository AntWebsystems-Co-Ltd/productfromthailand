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
context.shoppingCart = shoppingCart
partyId = shoppingCart.getPartyId()
if(partyId) {
    party = from("Party").where("partyId", partyId).cache(true).queryOne()
    profiledefs = from("PartyProfileDefault").where("partyId", userLogin.partyId, "productStoreId", productStoreId).queryOne()
    context.profiledefs = profiledefs
    if (shoppingCart.getShipmentMethodTypeId() && shoppingCart.getCarrierPartyId()) {
        context.chosenShippingMethod = shoppingCart.getShipmentMethodTypeId() + '@' + shoppingCart.getCarrierPartyId()
    } else if (profiledefs?.defaultShipMeth) {
        context.chosenShippingMethod = profiledefs.defaultShipMeth
    }
}