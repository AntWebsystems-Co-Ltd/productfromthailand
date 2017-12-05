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

<#assign productUrl = requestAttributes.productUrl>
<#assign smallImageUrl = requestAttributes.smallImageUrl>
<#assign productId = requestAttributes.productId>
<#assign productContentWrapper = requestAttributes.productContentWrapper>
<#assign price = requestAttributes.price>
<!-- Modal -->
<div class="modal fade" id="addCartModal_${productId!}" role="dialog" data-toggle="modal" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content" id="addcart-content-dialog">
            <div class="modal-header">
                <p class="addcartmsg h4">
                    <i class="fa fa-check" aria-hidden="true"></i>
                    <span id="qtyDisplay"></span> ${uiLabelMap.PFTAddToCartSuccessMsg}
                </p>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="product-col list clearfix">
                    <div class="image">
                        <a href="${productUrl!}" class="col-lg-10 col-xs-6">
                            <img src="<@ofbizContentUrl>${contentPathPrefix!}${smallImageUrl!}</@ofbizContentUrl>" alt="product" class="img-responsive" id="gridimage"/>
                        </a>
                    </div>
                    <div class="caption">
                        <h4><a href="${productUrl!}">${productContentWrapper.get("PRODUCT_NAME", "html")!}</a></h4>
                        <div class="description">
                            <#assign prodDesc = productContentWrapper.get("DESCRIPTION", "html")!>
                            <#if prodDesc?? && prodDesc?length &gt; 100>${prodDesc?substring(0,100)!}...<#else>${prodDesc!}</#if>
                        </div>
                        <div class="price">
                            <#if price.isSale?? && price.isSale>
                                <span class="price-new"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/></span>
                                <span class="price-old"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed/></span>
                            <#else>
                                <span class="price-new"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed/></span> 
                            </#if>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <table width="100%">
                    <tr>
                        <td width="50%" class="text-center">
                            <button type="button" class="btn btn-primary btn-block" data-dismiss="modal" onclick="javascript: waitSpinnerShow(); location.reload();">${uiLabelMap.EcommerceContinueShopping}</button>
                        </td>
                        <td>&nbsp;</td>
                        <td width="50%" class="text-center">
                            <button type="button" class="btn btn-main btn-block" data-dismiss="modal" onclick="javascript: waitSpinnerShow(); window.location.href='<@ofbizUrl>quickcheckout</@ofbizUrl>'">${uiLabelMap.PFTCheckout}</button>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
