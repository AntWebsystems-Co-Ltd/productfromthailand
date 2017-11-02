import org.apache.ofbiz.entity.util.EntityQuery
import org.apache.ofbiz.entity.util.EntityUtil

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

wishLists = []

shoppingLists = from("ShoppingList").where([shoppingListTypeId: "SLT_WISH_LIST", partyId: userLogin.partyId]).queryList();
if (shoppingLists.size() != 0) {
    shoppingList = EntityUtil.getFirst(shoppingLists);
    shoppingListItems = from("ShoppingListItem").where([shoppingListId: shoppingList.shoppingListId])
            .orderBy("-createdStamp").queryList()
    shoppingListItems.each { shoppingListItem ->
        product = from("Product").where([productId: shoppingListItem.productId]).queryOne()
        wishLists.add([productId: shoppingListItem.productId, productName: product.productName,
                       date: shoppingListItem.createdStamp,
                       shoppingListId: shoppingListItem.shoppingListId,
                       shoppingListItemSeqId: shoppingListItem.shoppingListItemSeqId])
    }
}
context.wishLists = wishLists
