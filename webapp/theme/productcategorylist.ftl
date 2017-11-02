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
        <div class="col-xs-12">
            <div class="product-col list clearfix">
                <div class="image">
                    <img src="<@ofbizContentUrl>${contentPathPrefix!}${smallImageUrl}</@ofbizContentUrl>" alt="product" class="img-responsive" />
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
                        <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="the${requestAttributes.formNamePrefix!}${requestAttributes.listIndex!}form">
                            <input type="hidden" name="add_product_id" value="${product.productId}"/>
                            <input type="hidden" name="quantity" value="1"/>
                            <input type="hidden" name="clearSearch" value="N"/>
                            <input type="hidden" name="mainSubmitted" value="Y"/>
                        </form>
                        <#if userLogin?has_content>
                        <#assign timeId = Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp().getTime()/>
                        <form name="addProductToWishList_${timeId}" method="post" action="<@ofbizUrl>addProductToWishList</@ofbizUrl>">
                            <input name="productId" type="hidden" value="${product.productId}"/>
                        </form>
                        <button type="button" onclick="$(document.addProductToWishList_${timeId}).submit()" title="Wishlist" class="btn btn-wishlist">
                            <i class="fa fa-heart"></i>
                        </button>
                        </#if>
                        <button type="button" title="Compare" class="btn btn-compare">
                            <i class="fa fa-bar-chart-o"></i>
                        </button>
                        <button type="button" class="btn btn-cart" onclick="javascript:document.the${requestAttributes.formNamePrefix!}${requestAttributes.listIndex!}form.submit()">
                            ${uiLabelMap.OrderAddToCart}
                            <i class="fa fa-shopping-cart"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    <!-- Product Ends -->
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br />
</#if>
