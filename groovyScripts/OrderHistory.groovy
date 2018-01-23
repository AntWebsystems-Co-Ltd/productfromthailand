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
import org.apache.ofbiz.entity.condition.*

partyRole = from("PartyRole").where("partyId", userLogin.partyId, "roleTypeId", "SUPPLIER").queryOne()

orderRoleCollection = from("OrderRole").where("partyId", userLogin.partyId, "roleTypeId", "PLACING_CUSTOMER").queryList()
orderHeaderList = EntityUtil.orderBy(EntityUtil.filterByAnd(EntityUtil.getRelated("OrderHeader", null, orderRoleCollection, false),
        [EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "ORDER_REJECTED")]), ["orderDate DESC"]);
newOrderList = [];
newpoOrderList = [];
if(orderHeaderList) {
    newpoOrderList = [];
    String orderCheck = null;
    String orderHeaderCheck = null;
    for (orderHeader in orderHeaderList) {
        orderItemList = from("OrderItem").where("orderId", orderHeader.orderId).queryList();
        if(orderItemList) {
            for (orderItem in orderItemList) {
                newpoOrderCtx = [:];
                if(!orderHeaderCheck || !orderHeaderCheck.equals(orderItem.orderId)) {
                    newpoOrderCtx.put("isHeader", "Y");
                }else {
                    newpoOrderCtx.put("isHeader", "N");
                }
                orderHeaderCheck = orderItem.orderId;
                porderItemAssoc = from("OrderItemAssoc").where("orderId", orderHeader.orderId, "orderItemSeqId", orderItem.orderItemSeqId).queryFirst();
                if(porderItemAssoc) {
                    if (!orderCheck.equals(porderItemAssoc.toOrderId)) {
                        porderHeader = from("OrderHeader").where("orderId", porderItemAssoc.toOrderId).queryFirst();
                        if(porderHeader && !(newpoOrderList.purchaseId.contains(porderHeader.orderId))) {
                            newpoOrderCtx.put("orderDate", orderHeader.orderDate);
                            newpoOrderCtx.put("orderTypeId", orderHeader.orderTypeId);
                            newpoOrderCtx.put("grandTotal", orderHeader.grandTotal);
                            newpoOrderCtx.put("orderId", orderHeader.orderId);
                            newpoOrderCtx.put("purchaseId", porderHeader.orderId);
                            newpoOrderCtx.put("orderItemSeqId", orderItem.orderItemSeqId);
                            newpoOrderCtx.put("statusId", porderHeader.statusId);
                            newpoOrderCtx.put("requestDropShip", "Y");
                            orderCheck = porderItemAssoc.toOrderId;
                            newpoOrderList.add(newpoOrderCtx);
                        }
                    }
                }else {
                    if(!(newpoOrderList.purchaseId.contains(orderHeader.orderId))) {
                        newItemSeq = [];
                        newpoOrderCtx.put("orderDate", orderHeader.orderDate);
                        newpoOrderCtx.put("orderTypeId", orderHeader.orderTypeId);
                        newpoOrderCtx.put("grandTotal", orderHeader.grandTotal);
                        newpoOrderCtx.put("orderId", orderHeader.orderId);
                        newpoOrderCtx.put("purchaseId", orderHeader.orderId);
                        newItemSeq.add(orderItem.orderItemSeqId);
                        newpoOrderCtx.put("orderItemSeqId", newItemSeq);
                        newpoOrderCtx.put("statusId", orderHeader.statusId);
                        newpoOrderCtx.put("requestDropShip", "N");
                        newpoOrderList.add(newpoOrderCtx);
                    } else {
                        int positionIndex = newpoOrderList.purchaseId.indexOf(orderHeader.orderId);
                        newItemSeqOrderCtx = [:];
                        newItemSeqOrder = [];
                        newItemSeqOrder.add(newpoOrderList[positionIndex].orderItemSeqId);
                        newItemSeqOrder.add(orderItem.orderItemSeqId);
                        newItemSeqOrderCtx.putAll(newpoOrderList[positionIndex]);
                        newItemSeqOrderCtx.put("orderItemSeqId", newItemSeqOrder);
                        newpoOrderList.remove(positionIndex);
                        newpoOrderList.add(newItemSeqOrderCtx);
                    }
                }
            }
        }
    }
}
context.newOrderList = newpoOrderList
context.orderHeaderList = orderHeaderList

downloadOrderRoleAndProductContentInfoList = from("OrderRoleAndProductContentInfo").where("partyId", userLogin.partyId, "roleTypeId", "PLACING_CUSTOMER", "productContentTypeId", "DIGITAL_DOWNLOAD", "statusId", "ITEM_COMPLETED").queryList()
context.downloadOrderRoleAndProductContentInfoList = downloadOrderRoleAndProductContentInfoList
