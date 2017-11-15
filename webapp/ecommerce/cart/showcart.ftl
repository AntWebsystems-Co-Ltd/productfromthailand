
<#--Licensed to the Apache Software Foundation (ASF) under one
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

<!-- Main Container Starts -->
    <div id="main-container" class="container">
    <!-- Main Heading Starts -->
        <h2 class="main-heading text-center">
            ${uiLabelMap.PageTitleShoppingCart}
        </h2>
    <!-- Main Heading Ends -->
    <!-- Shopping Cart Table Starts -->
        <#if shoppingCart.items()?has_content>
        <div class="table-responsive shopping-cart-table">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <td class="text-center">
                            ${uiLabelMap.CommonImage}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.OrderProduct}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.CommonQuantity}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.EcommerceUnitPrice}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.EcommerceItemTotal}
                        </td>
                        <td class="text-center">
                            ${uiLabelMap.FormFieldTitle_actionEnumId}
                        </td>
                    </tr>
                </thead>
                <tbody>
                    <#list shoppingCart.items() as cartLine>
                        <#assign cartLineIndex = shoppingCart.getItemIndex(cartLine) />
                        <#assign lineOptionalFeatures = cartLine.getOptionalProductFeatures() />
                        <tr id="cartItemDisplayRow_${cartLineIndex}">
                        <#if cartLine.getProductId()?exists>
                            <#-- product item -->
                            <#-- start code to display a small image of the product -->
                            <#if cartLine.getParentProductId()?exists>
                              <#assign parentProductId = cartLine.getParentProductId() />
                            <#else>
                              <#assign parentProductId = cartLine.getProductId() />
                            </#if>
                            <#assign smallImageUrl = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher, "url")?if_exists />
                            <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/pft-default/images/defaultImage.jpg" /></#if>
                            <#if smallImageUrl?string?has_content>
                                <td class="text-center">
                                    <a href="<@ofbizUrl>product?product_id=${parentProductId}</@ofbizUrl>">
                                        <img src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Product Name" title="Product Name" class="img-thumbnail" />
                                    </a>
                                </td>
                            </#if>
                            <#-- end code to display a small image of the product -->
                            <#-- ${cartLineIndex} - -->
                            <td class="text-center">
                                <a href="<@ofbizCatalogAltUrl productId=parentProductId/>">${cartLine.getName()?if_exists}</a>
                            </td>
                            <td class="text-center">
                                <div class="input-group btn-block">
                                    <form method="post" action="<@ofbizUrl>modifycart</@ofbizUrl>" name="cartform_${cartLineIndex!}">
                                        <input type="hidden" name="removeSelected" value="false"/>
                                        <input type="text" name="update_${cartLineIndex!}" value="${cartLine.getQuantity()?string.number}" size="1" class="form-control" />
                                    </form>
                                </div>
                            </td>
                            <td class="text-center">
                                <@ofbizCurrency amount=cartLine.getDisplayPrice() isoCode=shoppingCart.getCurrency()/>
                            </td>
                            <td class="text-center">
                                <@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/>
                            </td>
                            <td class="text-center">
                                <button type="submit" title="${uiLabelMap.CommonUpdate}" class="btn btn-default tool-tip" onclick="javascript:document.cartform_${cartLineIndex!}.submit();">
                                    <i class="fa fa-refresh"></i>
                                </button>
                                <button type="button" title="${uiLabelMap.CommonRemove}" class="btn btn-default tool-tip" onclick="javascript:document.removecartform_${cartLineIndex!}.submit();">
                                    <i class="fa fa-times-circle"></i>
                                </button>
                                <#if (shoppingCartSize == 1)>
                                <form method="post" action="<@ofbizUrl>clearcart</@ofbizUrl>" name="removecartform_${cartLineIndex!}">
                                    <input type="hidden" name="clear" value="true"/>
                                </form>
                                <#else>
                                <form method="post" action="<@ofbizUrl>modifycart</@ofbizUrl>" name="removecartform_${cartLineIndex!}">
                                    <input type="hidden" name="removeSelected" value="false"/>
                                    <input type="hidden" name="delete_${cartLineIndex!}" value="${cartLine.getQuantity()?string.number}"/>
                                </form>
                                </#if>
                            </td>
                        <#else>
                            <#-- this is a non-product item -->
                            ${cartLine.getItemTypeDescription()?if_exists}: ${cartLine.getName()?if_exists}
                        </#if>
                        </tr>
                    </#list>
                </tbody>
                <tfoot>
                    <tr>
                      <td colspan="4" class="text-right">
                        <strong>${uiLabelMap.OrderCartTotal} :</strong>
                      </td>
                      <td colspan="2" class="text-left">
                        <@ofbizCurrency amount=shoppingCart.getDisplaySubTotal() isoCode=shoppingCart.getCurrency()/>
                      </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    <!-- Shopping Cart Table Ends -->
    <!-- Shipping Section Starts -->
        <section class="registration-area">
            <div class="row">
            <!-- Discount Coupon Block Starts -->
                <div class="col-sm-6">
                    <div class="panel panel-smart">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                ${uiLabelMap.OrderPromotionCouponCodes}
                            </h3>
                        </div>
                        <div class="panel-body">
                        <!-- Form Starts -->
                            <form class="form-horizontal" role="form" method="post" action="<@ofbizUrl>addpromocode<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" name="addpromocodeform">
                                <div class="form-group">
                                    <label for="inputCouponCode" class="col-sm-3 control-label">${uiLabelMap.OrderAddCode}</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control required" name="productPromoCodeId" id="inputCouponCode" placeholder="Promotions Code">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-3 col-sm-9">
                                        <button type="submit" class="btn btn-default">
                                            ${uiLabelMap.OrderAddCode}
                                        </button>
                                    </div>
                                </div>
                            </form>
                        <!-- Form Ends -->
                        </div>
                    </div>
                </div>
            <!-- Discount Coupon Block Ends -->
            <!-- Discount Blocks Starts -->
                <div class="col-sm-6">
                <!-- Total Panel Starts -->
                    <div class="panel panel-smart">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                ${uiLabelMap.OrderTotal}
                            </h3>
                        </div>
                        <div class="panel-body">
                            <dl class="dl-horizontal">
                                <#assign orderAdjustmentsTotal = 0 />
                                <#list shoppingCart.getAdjustments() as cartAdjustment>
                                  <#assign orderAdjustmentsTotal = orderAdjustmentsTotal +
                                      Static["org.apache.ofbiz.order.order.OrderReadHelper"]
                                      .calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) />
                                </#list>
                                <dt>${uiLabelMap.EcommerceAdjustment} :</dt>
                                <dd><@ofbizCurrency amount=orderAdjustmentsTotal isoCode=shoppingCart.getCurrency() /></dd>
                                <dt>${uiLabelMap.CommonSubtotal} :</dt>
                                <dd><@ofbizCurrency amount=shoppingCart.getSubTotal() isoCode=shoppingCart.getCurrency() /></dd>
                                <dt>${uiLabelMap.OrderShippingAndHandling} :</dt>
                                <dd><@ofbizCurrency amount=shoppingCart.getTotalShipping() isoCode=shoppingCart.getCurrency() /></dd>
                                <dt>${uiLabelMap.OrderSalesTax} :</dt>
                                <dd><@ofbizCurrency amount=shoppingCart.getTotalSalesTax() isoCode=shoppingCart.getCurrency() /></dd>
                            </dl>
                            <hr />
                            <dl class="dl-horizontal total">
                                <dt>${uiLabelMap.OrderGrandTotal} :</dt>
                                <dd><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency() /></dd>
                            </dl>
                            <hr />
                            <div class="text-uppercase clearfix">
                                <a href="<@ofbizUrl>main</@ofbizUrl>" class="btn btn-default pull-left">
                                    <span class="hidden-xs">${uiLabelMap.EcommerceContinueShopping}</span>
                                    <span class="visible-xs">${uiLabelMap.CommonContinue}</span>
                                </a>
                                <a href="<@ofbizUrl>quickcheckout</@ofbizUrl>" class="btn btn-main pull-right">
                                    ${uiLabelMap.OrderCheckout}
                                </a>
                            </div>
                        </div>
                    </div>
                <!-- Total Panel Ends -->
                </div>
            <!-- Discount Blocks Ends -->
            </div>
        </section>
    <!-- Shipping Section Ends -->
        <#else>
        <div class="panel-smart">
            <label class="h3">${uiLabelMap.PFTYourShoppingCartEmpty}.</label>
        </div>
        </#if>
    </div>
<!-- Main Container Ends -->
<script>
    jQuery(document).ready( function() {
        jQuery(document.addpromocodeform).validate();
    });
</script>
