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

import org.apache.ofbiz.base.util.UtilDateTime
import org.apache.ofbiz.entity.condition.EntityConditionBuilder

exprBldr = new EntityConditionBuilder();

upcomingList = [];
monthStart = UtilDateTime.getMonthStart(UtilDateTime.toTimestamp(UtilDateTime.nowTimestamp()), timeZone, locale);
monthEnd = UtilDateTime.getMonthEnd(UtilDateTime.toTimestamp(UtilDateTime.nowTimestamp()), timeZone, locale);
orderHeaderAndRolesCond = exprBldr.AND() {
    EQUALS(roleTypeId: "SUPPLIER_AGENT")
    EQUALS(orderTypeId: "PURCHASE_ORDER")
    EQUALS(partyId: userLogin.partyId)
    NOT_EQUALS(statusId: "ORDER_CANCELLED")
    GREATER_THAN_EQUAL_TO(orderDate: monthStart);
    LESS_THAN_EQUAL_TO(orderDate: monthEnd);
}
orderHeaderAndRoles = from("OrderHeaderAndRoles").where(orderHeaderAndRolesCond).queryList();
if (orderHeaderAndRoles) {
    orderHeaderAndRoles.each { orderRole ->
        invItemAndOrdItem = orderHeaderAndRoles = from("InvItemAndOrdItem").where("orderId", orderRole.orderId).queryFirst();
        if (invItemAndOrdItem) {
            invoiceCond = exprBldr.AND() {
                EQUALS(invoiceTypeId: "PURCHASE_INVOICE")
                exprBldr.OR() {
                    NOT_LIKE(description: "Monthly invoice of%")
                    EQUALS(description: null)
                }
                NOT_EQUALS(statusId: "INVOICE_CANCELLED")
                EQUALS(partyIdFrom: userLogin.partyId)
                EQUALS(invoiceId: invItemAndOrdItem.invoiceId)
            }
            invoices = from("Invoice").where(invoiceCond).queryList();
            if (invoices) {
                upcomingMap = [:];
                upcomingMap.put("orderDate", orderRole.orderDate);
                upcomingMap.put("orderId", orderRole.orderId);
                upcomingMap.put("currencyUom", orderRole.currencyUom);
                upcomingList.add(upcomingMap);
            }
        }
    }
}
context.upcomingList = upcomingList;
