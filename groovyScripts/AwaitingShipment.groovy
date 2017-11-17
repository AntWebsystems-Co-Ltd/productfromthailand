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

orderLists = [];
saleOrderLists = [];
saleOrders = from("OrderHeaderAndRoles").where("partyId", userLogin.partyId, "roleTypeId", "BILL_TO_CUSTOMER", "orderTypeId", "SALES_ORDER", "statusId", "ORDER_APPROVED").orderBy("-orderDate").queryList();
if (saleOrders) {
    saleOrders.each { saleOrder ->
        saleOrderPaymentPref = from("OrderHeaderAndPaymentPref").where("orderId", saleOrder.orderId, "paymentStatusId", "PAYMENT_RECEIVED").queryFirst();
        if (saleOrderPaymentPref) {
            saleOrderLists.add(saleOrder)
        }
    }
}

if (saleOrderLists) {
    saleOrderLists.each { saleOrder ->
        getPurchaseOrder = from("OrderItemAssoc").where("orderId", saleOrder.orderId).queryFirst();
        if (getPurchaseOrder) {
            orderLists = from("OrderHeaderAndRoles").where("orderId", getPurchaseOrder.toOrderId, "roleTypeId", "SUPPLIER_AGENT", "orderTypeId", "PURCHASE_ORDER", "statusId", "ORDER_CREATED").orderBy("-orderDate").queryList();
        }
    }
}

context.orderLists = orderLists;
