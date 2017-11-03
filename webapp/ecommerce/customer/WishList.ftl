<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<div id="main-container" class="container">
<div class="panel panel-smart">
        <div class="panel-heading navbar">
          <h3>${uiLabelMap.PFTWishList}</h3>
        </div>
        <div class="panel-body">
          <table class="table">
            <thead>
              <tr>
                <th>${uiLabelMap.CommonDate}</th>
                <th>${uiLabelMap.PFTProducts}
                <th></th>
              </tr>
            </thead>
            <tbody>
              <#if wishLists?has_content>
                <#assign wishIndex = 0>
                <#list wishLists as wishList>
                <#assign wishIndex = wishIndex?int+1>
                    <tr>
                        <td>${wishList.date}</td>
                        <td><a href="/pft/products/p_${wishList.productId}"> ${wishList.productName}</a></td>
                        <td>
                            <div class="product-col" style="padding: 0; margin: 0;">
                                <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="addToCart${wishIndex!}form">
                                    <input type="hidden" name="add_product_id" value="${wishList.productId}"/>
                                    <input type="hidden" name="quantity" value="1"/>
                                    <input type="hidden" name="clearSearch" value="N"/>
                                    <input type="hidden" name="mainSubmitted" value="Y"/>
                                </form>
                                <button type="button" class="btn btn-cart" onclick="javascript:document.addToCart${wishIndex!}form.submit()">
                                    ${uiLabelMap.OrderAddToCart}
                                    <i class="fa fa-shopping-cart"></i>
                                </button>
                            </div>
                        </td>
                        <td>
                            <form name="removeProductFromWishList_${wishList.shoppingListId}_${wishList.shoppingListItemSeqId}" action="removeProductFromWishList" method="post">
                                <input name="shoppingListId" type="hidden" value="${wishList.shoppingListId}"/>
                                <input name="shoppingListItemSeqId" type="hidden" value="${wishList.shoppingListItemSeqId}"/>
                            </form>
                            <a href="javascript: $(document.removeProductFromWishList_${wishList.shoppingListId}_${wishList.shoppingListItemSeqId}).submit();"><i class="fa fa-trash" aria-hidden="true"></i></a>
                        </td>
                    </tr>
                </#list>
              <#else>
                <tr><td colspan="4" class="center">${uiLabelMap.PFTWishListNotFound}</td></tr>
              </#if>
            </tbody>
          </table>
        </div>
      </div>
</div>