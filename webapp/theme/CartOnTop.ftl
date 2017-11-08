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

<script>
    function removeFromCart(form) {
        $.ajax({
            url: form.action,
            type: 'POST',
            data: $(form).serialize(),
            async: false,
            success: function(data) {
                ajaxUpdateArea("cart", "<@ofbizUrl>cartontop</@ofbizUrl>", data);
            }
        });
    }
</script>

<div id="cart" class="btn-group btn-block">
    <button type="button" data-toggle="dropdown" class="btn btn-block btn-lg dropdown-toggle">
        <i class="fa fa-shopping-cart"></i>
        <span class="hidden-md">${uiLabelMap.PFTCart}:</span>
        <span id="cart-total">
            ${shoppingCart.getTotalQuantity()} <#if shoppingCart.getTotalQuantity() == 1>${uiLabelMap.OrderItem}<#else>${uiLabelMap.OrderItems}</#if>
             - <@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/>
        </span>
        <i class="fa fa-caret-down"></i>
    </button>
    <ul class="dropdown-menu pull-right">
        <#if (shoppingCartSize > 0)>
        <li>
            <table class="table hcart">
                <#list shoppingCart.items() as cartLine>
                    <#assign cartLineIndex = shoppingCart.getItemIndex(cartLine) />
                    <#assign lineOptionalFeatures = cartLine.getOptionalProductFeatures() />
                    <tr id="cartItemDisplayRow_${cartLineIndex}">
                        <td class="text-center">
                            <#if cartLine.getProductId()?exists>
                                <#-- product item -->
                                <#-- start code to display a small image of the product -->
                                <#if cartLine.getParentProductId()?exists>
                                  <#assign parentProductId = cartLine.getParentProductId() />
                                <#else>
                                  <#assign parentProductId = cartLine.getProductId() />
                                </#if>
                                <#assign smallImageUrl = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(cartLine.getProduct(), "SMALL_IMAGE_URL", locale, dispatcher, "url")?if_exists />
                                <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg" /></#if>
                                <#if smallImageUrl?string?has_content>
                                <a href="<@ofbizUrl>product?product_id=${parentProductId}</@ofbizUrl>">
                                    <img src="<@ofbizContentUrl>${requestAttributes.contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="image" title="image" class="img-thumbnail img-responsive" />
                                </a>
                                </#if>
                            <#else>
                                 ${cartLine.getItemTypeDescription()?if_exists}: ${cartLine.getName()?if_exists}
                            </#if>
                        </td>
                        <td class="text-left">
                            <a href="<@ofbizCatalogAltUrl productId=parentProductId/>" class="linktext">${cartLine.getName()?if_exists}</a>
                        </td>
                        <td class="text-right">x ${cartLine.getQuantity()?string.number?default(0)}</td>
                        <td class="text-right"><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></td>
                        <td class="text-center">
                            <a href="javascript:removeFromCart(removecartformheader_${cartLineIndex!});">
                                <i class="fa fa-times"></i>
                            </a>
                            <form method="post" action="<@ofbizUrl>removecart</@ofbizUrl>" name="removecartformheader_${cartLineIndex!}" id="removecartformheader_${cartLineIndex!}">
                                <input type="hidden" name="removeSelected" value="true"/>
                                <input type="hidden" name="selectedItem" value="${cartLineIndex!}"/>
                            </form>
                        </td>
                    </tr>
                </#list>
            </table>
        </li>
        <li>
            <table class="table table-bordered total">
                <tbody>
                    <tr>
                        <td class="text-right"><strong>Sub-Total</strong></td>
                        <td class="text-left"><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></td>
                    </tr>
                    <#-- <tr>
                        <td class="text-right"><strong>Eco Tax (-2.00)</strong></td>
                        <td class="text-left">$4.00</td>
                    </tr>
                    <tr>
                        <td class="text-right"><strong>VAT (17.5%)</strong></td>
                        <td class="text-left">$192.68</td>
                    </tr> -->
                    <tr>
                        <td class="text-right"><strong>Total</strong></td>
                        <td class="text-left"><@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/></td>
                    </tr>
                </tbody>
            </table>
            <p class="text-right btn-block1">
                <a href="<@ofbizUrl>view/showcart</@ofbizUrl>">
                    ${uiLabelMap.OrderViewCart}
                </a>
                <a href="<@ofbizUrl>quickcheckout</@ofbizUrl>">
                    ${uiLabelMap.OrderCheckout}
                </a>
            </p>
        </li>
        <#else>
        <li>
            <p class="text-center">${uiLabelMap.OrderShoppingCartEmpty}</p>
        </li>
        </#if>
    </ul>
</div>
