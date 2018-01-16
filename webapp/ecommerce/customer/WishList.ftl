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
        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th>${uiLabelMap.CommonImage}</th>
                <th>${uiLabelMap.PFTProducts}</th>
                <th>${uiLabelMap.CommonDate}</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <#if wishLists?has_content>
                <#assign wishIndex = 0>
                <#list wishLists as wishList>
                <#if backendPath?default("N") == "Y">
                    <#assign productUrl><@ofbizCatalogUrl productId=wishList.productId/></#assign>
                <#else>
                    <#assign productUrl><@ofbizCatalogAltUrl productId=wishList.productId/></#assign>
                </#if>
                <#assign wishIndex = wishIndex?int+1>
                    <tr>
                        <#assign product = EntityQuery.use(delegator).from("Product").where("productId", wishList.productId).queryOne()!>
                        <#assign smallImageUrl = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(product, "SMALL_IMAGE_URL", request, "url")!>
                        <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/pft-default/images/defaultImage.jpg"/></#if>
                        <#if smallImageUrl?string?has_content>
                            <td>
                                <a href="<@ofbizUrl>product?product_id=${wishList.productId!}</@ofbizUrl>">
                                    <img src="<@ofbizContentUrl>${contentPathPrefix!}${smallImageUrl}</@ofbizContentUrl>" class="img-thumbnail"/>
                                </a>
                            </td>
                        </#if>
                        <td>
                            <#assign productName = Static['org.apache.ofbiz.product.product.ProductContentWrapper'].getProductContentAsText(product, 'PRODUCT_NAME', request, "html")!>
                            <a href="/pft/products/p_${wishList.productId}">${StringUtil.wrapString(productName)!}</a>
                        </td>
                        <td>${wishList.date?string.medium}</td>
                        <td>
                            <div class="product-col" style="padding: 0; margin: 0;">
                                <#if wishList.introductionDate?? && nowTimestamp.before(wishList.introductionDate)>
                                    <div style="color: red;">${uiLabelMap.ProductNotYetAvailable}</div>
                                    <button type="button" class="btn btn-cart">
                                        <i class="fa fa-shopping-cart"></i>
                                        ${uiLabelMap.ProductNotYetAvailable}
                                    </button>
                                <#-- check to see if salesDiscontinuationDate has passed -->
                                <#elseif wishList.salesDiscontinuationDate?? && nowTimestamp.after(wishList.salesDiscontinuationDate)>
                                    <button type="button" class="btn btn-cart">
                                        ${uiLabelMap.ProductNoLongerAvailable}
                                    </button>
                                <#-- check to see if it is a rental item; will enter parameters on the detail screen-->
                                <#elseif wishList.productTypeId! == "ASSET_USAGE">
                                    <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                        <i class="fa fa-shopping-cart"></i>
                                        ${uiLabelMap.OrderMakeBooking}
                                    </button>
                                <#-- check to see if it is an aggregated or configurable product; will enter parameters on the detail screen-->
                                <#elseif wishList.productTypeId! == "AGGREGATED" || wishList.productTypeId! == "AGGREGATED_SERVICE">
                                    <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                        <i class="fa fa-shopping-cart"></i>
                                        ${uiLabelMap.OrderConfigure}
                                    </button>
                                <#-- check to see if the product is a virtual product -->
                                <#elseif wishList.isVirtual?? && wishList.isVirtual == "Y">
                                    <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                        <i class="fa fa-shopping-cart"></i>
                                        ${uiLabelMap.OrderChooseVariations}
                                    </button>
                                <#-- check to see if the product requires an amount -->
                                <#elseif wishList.requireAmount?? && wishList.requireAmount == "Y">
                                    <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                        <i class="fa fa-shopping-cart"></i>
                                        ${uiLabelMap.OrderChooseAmount}
                                    </button>
                                <#elseif wishList.productTypeId! == "ASSET_USAGE_OUT_IN">
                                    <button type="button" class="btn btn-cart" onclick="${productUrl}">
                                        <i class="fa fa-shopping-cart"></i>
                                        ${uiLabelMap.OrderRent}
                                    </button>
                                <#else>
                                    <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="addToCart${wishIndex!}form">
                                        <input type="hidden" name="add_product_id" value="${wishList.productId}"/>
                                        <input type="hidden" name="quantity" value="1"/>
                                        <input type="hidden" name="clearSearch" value="N"/>
                                        <input type="hidden" name="mainSubmitted" value="Y"/>
                                    </form>
                                    <button type="button" class="btn btn-cart" onclick="addToCart(addToCart${wishIndex!}form)">
                                        ${uiLabelMap.OrderAddToCart}
                                        <i class="fa fa-shopping-cart"></i>
                                    </button>
                                </#if>
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

<#if productLists?has_content>
    <#list productLists as productList>
        <#assign product = productList.product>
        <#if product?has_content>
            <#assign productContentWrapper = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].makeProductContentWrapper(product, request)>
            <#if backendPath?default("N") == "Y">
                <#assign productUrl><@ofbizCatalogUrl productId=product.productId productCategoryId=productList.categoryId!/></#assign>
            <#else>
                <#assign productUrl><@ofbizCatalogAltUrl productId=product.productId productCategoryId=productList.categoryId!/></#assign>
            </#if>

            <#assign smallImageUrl = productContentWrapper.get("SMALL_IMAGE_URL", "url")!>
            <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/pft-default/images/defaultImage.jpg"></#if>
            <#-- Add cart dialog -->
            ${setRequestAttribute("productUrl", productUrl)}
            ${setRequestAttribute("smallImageUrl", smallImageUrl)}
            ${setRequestAttribute("productId", product.productId)}
            ${setRequestAttribute("productContentWrapper", productContentWrapper)}
            ${setRequestAttribute("price", productList.price)}
            ${screens.render("component://productfromthailand/widget/CartScreens.xml#addToCartDialog")}
        </#if>
    </#list>

    <script>
        function addToCart(form) {
            prodId = form.add_product_id.value;
            $.ajax({
                url: form.action,
                type: 'POST',
                data: $(form).serialize(),
                async: false,
                success: function(data) {
                    $('#addCartModal_'+prodId).modal('toggle');
                    $('#addCartModal_'+prodId).modal('show');
                    $('#addCartModal_'+prodId).modal({backdrop: 'static', keyboard: false})
                    $('#addCartModal_'+prodId+' #qtyDisplay').text(form.quantity.value);
                }
            });
        }
    </script>
</#if>
