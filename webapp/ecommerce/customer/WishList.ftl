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
                <#list wishLists as wishList>
                    <tr>
                        <td>${wishList.date}</td>
                        <td><a href="/pft/products/p_${wishList.productId}"> ${wishList.productName}</a></td>
                        <td>
                            <#assign timeId = Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp().getTime()/>
                            <form name="removeProductFromWishList_${timeId}" action="removeProductFromWishList" method="post">
                                <input name="shoppingListId" type="hidden" value="${wishList.shoppingListId}"/>
                                <input name="shoppingListItemSeqId" type="hidden" value="${wishList.shoppingListItemSeqId}"/>
                            </form>
                            <a href="javascript: $(document.removeProductFromWishList_${timeId}).submit();"><i class="fa fa-trash" aria-hidden="true"></i></a>
                        </td>
                    </tr>
                </#list>
              <#else>
                <tr><td colspan="3" class="center">${uiLabelMap.PFTWishListNotFound}</td></tr>
              </#if>
            </tbody>
          </table>
        </div>
      </div>
</div>