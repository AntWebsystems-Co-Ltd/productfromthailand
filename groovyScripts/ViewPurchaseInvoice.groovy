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

import java.util.*;
import org.apache.ofbiz.entity.*;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.entity.util.EntityUtil;
import org.apache.ofbiz.accounting.invoice.*;

invoiceId = parameters.invoiceId;
context.invoiceId = invoiceId;

if (!invoiceId) return;

invoice = from('Invoice').where('invoiceId', invoiceId).queryOne();

context.invoice = invoice;

List invoiceItems = [];
invoiceItemList = delegator.findByAnd("InvoiceItem", [invoiceId : invoiceId], ["invoiceItemSeqId"], false);
if (invoiceItemList) {
    invoiceItemList.each { invoiceItem ->
        invoiceItemSeqId = invoiceItem.invoiceItemSeqId;
        invoiceId = invoiceItem.invoiceId;
        orderItemBilling = EntityUtil.getFirst(delegator.findByAnd("OrderItemBilling", [invoiceId : invoiceId, invoiceItemSeqId : invoiceItemSeqId], null, false));
        Map invoiceItemMap = new HashMap<String, Object>();
        invoiceItemMap.putAll((Map) invoiceItem);
        if (orderItemBilling) {
            orderId = orderItemBilling.orderId;
            invoiceItemMap.orderId = orderId;
        } else {
            orderAdjustmentBilling = EntityUtil.getFirst(delegator.findByAnd("OrderAdjustmentBilling", [invoiceId : invoiceId, invoiceItemSeqId : invoiceItemSeqId], null, false));
            if (orderAdjustmentBilling) {
                orderAdjustment = EntityUtil.getFirst(delegator.findByAnd("OrderAdjustment", [orderAdjustmentId : orderAdjustmentBilling.orderAdjustmentId], null, false))
                if (orderAdjustment) {
                    orderId = orderAdjustment.orderId;
                    invoiceItemMap.orderId = orderId;
                }
            }
        }
        invoiceItems.add(invoiceItemMap);
    }
    context.invoiceItems = invoiceItems;
}

context.invoiceRoles = from('InvoiceRole').where('invoiceId', invoiceId).orderBy("partyId").queryList();
context.invoiceStatus = from('InvoiceStatus').where('invoiceId', invoiceId).orderBy("statusDate").queryList();
context.invoiceTerms = from('InvoiceTerm').where('invoiceId', invoiceId).orderBy("invoiceTermId").queryList();
context.timeEntries = from('TimeEntry').where('invoiceId', invoiceId).orderBy("invoiceItemSeqId").queryList();
context.AcctgTransAndEntries = from('AcctgTransAndEntries').where('invoiceId', invoiceId).orderBy("acctgTransId", "acctgTransEntrySeqId").queryList();

if (invoice) {
    context.invoiceAmount = InvoiceWorker.getInvoiceTotal(invoice);
    context.notAppliedAmount = InvoiceWorker.getInvoiceNotApplied(invoice);
    context.appliedAmount = InvoiceWorker.getInvoiceApplied(invoice);
}
