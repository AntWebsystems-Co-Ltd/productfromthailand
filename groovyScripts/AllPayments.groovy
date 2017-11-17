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
import org.apache.ofbiz.service.calendar.ExpressionUiHelper

exprBldr = new EntityConditionBuilder();

monthList = ExpressionUiHelper.getMonthValueList(locale)
context.monthList = monthList;

invoiceCond = exprBldr.AND() {
    EQUALS(invoiceTypeId: "PURCHASE_INVOICE")
    LIKE(description: "Monthly invoice of%")
    NOT_EQUALS(statusId: "INVOICE_CANCELLED")
    EQUALS(partyIdFrom: userLogin.partyId)
    LIKE(invoiceId: "%"+parameters.invoiceId+"%")
    if (parameters.selectedMonth) {
        selectedMonth = Integer.valueOf(parameters.selectedMonth)
        selectedMonthDate = UtilDateTime.toTimestamp((selectedMonth + 1), 1, UtilDateTime.getYear(UtilDateTime.nowTimestamp(), timeZone, locale), 0, 0, 0)
        monthStart = UtilDateTime.getMonthStart(selectedMonthDate, timeZone, locale);
        monthEnd = UtilDateTime.getMonthEnd(selectedMonthDate, timeZone, locale);
        GREATER_THAN_EQUAL_TO(invoiceDate: monthStart);
        LESS_THAN_EQUAL_TO(invoiceDate: monthEnd);
    }
}
invoices = from("Invoice").where(invoiceCond).queryList();
context.invoices = invoices;
