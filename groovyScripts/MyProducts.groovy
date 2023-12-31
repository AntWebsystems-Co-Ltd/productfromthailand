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

import org.apache.base.util.*
import org.apache.ofbiz.entity.util.EntityUtil;

supplierPartyId = userLogin.partyId;

webSite = from('WebSite').where('webSiteId', webSiteId).queryOne();
if (webSite) {
    productStore = from('ProductStore').where("productStoreId", webSite.productStoreId).queryOne();
    if (productStore) {
        supplierProducts = from("SupplierProduct").where("partyId", supplierPartyId, "currencyUomId", productStore.defaultCurrencyUomId).filterByDate(nowTimestamp, "availableFromDate", "availableThruDate").orderBy("productId").queryList()
    }
}
supplier = from("PartyNameView").where("partyId", supplierPartyId).queryOne()

//set the page parameters
viewIndex = Integer.valueOf(parameters.VIEW_INDEX  ?: 0);
viewSize = Integer.valueOf(parameters.VIEW_SIZE ?: 20);
listSize = 0;
if (supplierProducts)
    listSize = supplierProducts.size();

lowIndex = viewIndex * viewSize;
highIndex = (viewIndex + 1) * viewSize;
if (listSize < highIndex)
    highIndex = listSize;
if ( highIndex < 1 )
    highIndex = 0;
BigDecimal totalPage = supplierProducts.size()/viewSize;
totalPage = totalPage.setScale(0,BigDecimal.ROUND_UP);
context.viewIndex = viewIndex;
context.listSize = listSize;
context.highIndex = highIndex;
context.lowIndex = lowIndex;
context.viewSize = viewSize;
context.totalPage = totalPage;

context.supplierPartyId = supplierPartyId;
context.supplierProducts = supplierProducts;
context.supplier = supplier;
