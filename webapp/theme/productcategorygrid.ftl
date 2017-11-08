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
${virtualJavaScript!}

<#if product??>
    <#-- variable setup -->
    <#if backendPath?default("N") == "Y">
        <#assign productUrl><@ofbizCatalogUrl productId=product.productId productCategoryId=categoryId/></#assign>
    <#else>
        <#assign productUrl><@ofbizCatalogAltUrl productId=product.productId productCategoryId=categoryId/></#assign>
    </#if>

    <#if requestAttributes.productCategoryMember??>
        <#assign prodCatMem = requestAttributes.productCategoryMember>
    </#if>
    <#assign smallImageUrl = productContentWrapper.get("SMALL_IMAGE_URL", "url")!>
    <#assign largeImageUrl = productContentWrapper.get("LARGE_IMAGE_URL", "url")!>
    <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg"></#if>
    <#if !largeImageUrl?string?has_content><#assign largeImageUrl = "/images/defaultImage.jpg"></#if>
    <#-- end variable setup -->
    <#assign productInfoLinkId = "productInfoLink">
    <#assign productInfoLinkId = productInfoLinkId + product.productId/>
    <#assign productDetailId = "productDetailId"/>
    <#assign productDetailId = productDetailId + product.productId/>
    <!-- Product Starts -->
        <div class="col-md-4 col-sm-6">
            <div class="product-col">
                <div class="image">
                    <a href="${productUrl}">
                        <img src="<@ofbizContentUrl>${contentPathPrefix!}${smallImageUrl}</@ofbizContentUrl>" alt="product" class="img-responsive" id="gridimage"/>
                    </a>
                </div>
                <div class="caption">
                    <h4><a href="${productUrl}">${productContentWrapper.get("PRODUCT_NAME", "html")!}</a></h4>
                    <div class="description">
                        ${productContentWrapper.get("DESCRIPTION", "html")!}
                    </div>
                    <div class="price">
                        <#if price.isSale?? && price.isSale>
                            <span class="price-new"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/></span>
                            <span class="price-old"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/></span>
                        <#else>
                            <span class="price-new"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/></span>
                        </#if>
                    </div>
                    <div class="cart-button button-group">
                        <#assign timeId = Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp().getTime()/>
                        <form name="addProductToWishList_${timeId}" method="post" action="<@ofbizUrl>addProductToWishList</@ofbizUrl>">
                            <input name="productId" type="hidden" value="${product.productId}"/>
                        </form>
                        <#if product.introductionDate?? && nowTimestamp.before(product.introductionDate)>
                            <div style="color: red;">${uiLabelMap.ProductNotYetAvailable}</div>
                            <button type="button" class="btn btn-cart">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.ProductNotYetAvailable}
                            </button>
                        <#-- check to see if salesDiscontinuationDate has passed -->
                        <#elseif product.salesDiscontinuationDate?? && nowTimestamp.after(product.salesDiscontinuationDate)>
                            <button type="button" class="btn btn-cart">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.ProductNoLongerAvailable}
                            </button>
                        <#-- check to see if it is a rental item; will enter parameters on the detail screen-->
                        <#elseif product.productTypeId! == "ASSET_USAGE">
                            <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.OrderMakeBooking}
                            </button>
                        <#-- check to see if it is an aggregated or configurable product; will enter parameters on the detail screen-->
                        <#elseif product.productTypeId! == "AGGREGATED" || product.productTypeId! == "AGGREGATED_SERVICE">
                            <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.OrderConfigure}
                            </button>
                        <#-- check to see if the product is a virtual product -->
                        <#elseif product.isVirtual?? && product.isVirtual == "Y">
                            <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.OrderChooseVariations}
                            </button>
                        <#-- check to see if the product requires an amount -->
                        <#elseif product.requireAmount?? && product.requireAmount == "Y">
                            <button type="button" class="btn btn-cart" onclick="window.location.href='${productUrl}'">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.OrderChooseAmount}
                            </button>
                        <#elseif product.productTypeId! == "ASSET_USAGE_OUT_IN">
                            <button type="button" class="btn btn-cart" onclick="${productUrl}">
                                <i class="fa fa-shopping-cart"></i>
                                ${uiLabelMap.OrderRent}
                            </button>
                        <#else>
                            <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix!}${requestAttributes.listIndex!}form" class="hidden">
                                <input type="hidden" name="add_product_id" value="${product.productId}"/>
                                <input type="hidden" name="quantity" value="1"/>
                                <input type="hidden" name="clearSearch" value="N"/>
                                <input type="hidden" name="mainSubmitted" value="Y"/>
                            </form>
                            <button type="button" class="btn btn-cart" onclick="javascript:addToCart(the${requestAttributes.formNamePrefix!}${requestAttributes.listIndex!}form)">
                                ${uiLabelMap.OrderAddToCart}
                                <i class="fa fa-shopping-cart"></i>
                            </button>
                        </#if>
                        <button type="button" onclick="addToWishlist(addProductToWishList_${timeId},'${productContentWrapper.get("PRODUCT_NAME", "html")!}')" title="Wishlist" class="btn btn-wishlist">
                            <i class="fa fa-heart"></i>
                        </button>
                        <#-- <button type="button" title="Compare" class="btn btn-compare">
                            <i class="fa fa-bar-chart-o"></i>
                        </button> -->
                    </div>
                </div>
            </div>
        </div>
    <!-- Product Ends -->
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br />
</#if>

<script>
    $(document).ready(function () {
        var maxdesc = 0;
        $("div.product-col div.description").each(function() {
            maxdesc = Math.max(maxdesc, $(this).outerHeight())
        });
        $("div.product-col div.description").each(function() {
            if ($(this).outerHeight() < maxdesc){
                $(this).outerHeight(maxdesc);
            }
        });

        var maximg = 0;
        $("div.product-col div.image").each(function() {
            maximg = Math.max(maximg, $(this).outerHeight())
        });
        $("div.product-col div.image").each(function() {
            if ($(this).outerHeight() < maximg){
                $(this).outerHeight(maximg);
            }
        });

        var maxprodname = 0;
        $("div.product-col div.caption h4").each(function() {
            maxprodname = Math.max(maxprodname, $(this).outerHeight())
        });
        $("div.product-col div.caption h4").each(function() {
            if ($(this).outerHeight() < maxprodname){
                $(this).outerHeight(maxprodname);
            }
        });
    })

    function addToCart(form) {
        $.ajax({
            url: form.action,
            type: 'POST',
            data: $(form).serialize(),
            async: false,
            success: function(data) {
                location.reload()
            }
        });
    }
</script>
