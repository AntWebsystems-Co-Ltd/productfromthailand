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

<#-- Start Paginate Logic -->
<#assign viewIndexMax = Static["java.lang.Math"].ceil(((listSize)?int / viewSize?int)-1)>
<#assign lowViewList = viewIndex?int-2>
<#assign highViewList = viewIndex?int+2>
<#assign lowHasNext = true>
<#assign highHasNext = true>
<#if (lowViewList?int <= 0)>
    <#assign highViewList = highViewList?int-lowViewList?int>
    <#assign lowViewList = 0>
    <#assign lowHasNext = false>
</#if>
<#if (highViewList?int >= viewIndexMax?int)>
    <#if (lowViewList?int != 0)>
        <#assign highViewList = highViewList?int-viewIndexMax?int>
        <#assign lowViewList = lowViewList?int-highViewList?int>
    </#if>
    <#assign highViewList = viewIndexMax?int>
    <#assign highHasNext = false>
</#if>
<#if lowHasNext>
    <#assign lowNext = viewIndex?int-5>
    <#if (lowNext?int < 0)>
        <#assign lowNext = 0>
    </#if>
</#if>
<#if highHasNext>
    <#assign highNext = viewIndex?int+5>
    <#if (highNext?int >= viewIndexMax?int)>
        <#assign highNext = viewIndexMax?int>
    </#if>
</#if>

<div id="main-container" class="container">
    <div class="row">
        <div class="col-md-9 col-xs-12">
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h3 class="panel-title">${uiLabelMap.OrderPromotionDetails}</h3>
                </div>
                <div class="panel-body">
                    <div>${StringUtil.wrapString(productPromo.promoText!)}</div><br/>
                    <div>${uiLabelMap.OrderGeneratedDescription} ${StringUtil.wrapString(promoAutoDescription!)}</div>
                </div>
            </div>

            <#if productPromoCategoryIncludeList?has_content || productPromoCategoryExcludeList?has_content || productPromoCategoryAlwaysList?has_content>
            <br/>
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h3 class="panel-title">${uiLabelMap.OrderPromotionCategories}</h3>
                </div>
                <div class="panel-body">
                    <#if productPromoCategoryIncludeList?has_content>
                    <p>
                        <div>${uiLabelMap.OrderPromotionProductsInCategories}</div>
                        <#list productPromoCategoryIncludeList as productPromoCategory>
                            <#assign productCategory = productPromoCategory.getRelatedOne("ProductCategory", true)>
                            <div>
                                -&nbsp;<a href="<@ofbizUrl>category/~category_id=${productPromoCategory.productCategoryId}</@ofbizUrl>" class="buttontext">${(productCategory.description)?default(productPromoCategory.productCategoryId)}</a>
                                <#if productPromoCategory.includeSubCategories! = "Y">(${uiLabelMap.OrderIncludeSubCategories})</#if>
                            </div>
                        </#list>
                    </p>
                    </#if>
                    <#if productPromoCategoryExcludeList?has_content>
                    <p>
                        <div>${uiLabelMap.OrderExcludeCategories}</div>
                        <#list productPromoCategoryExcludeList as productPromoCategory>
                            <#assign productCategory = productPromoCategory.getRelatedOne("ProductCategory", true)>
                            <div>
                                -&nbsp;<a href="<@ofbizUrl>category/~category_id=${productPromoCategory.productCategoryId}</@ofbizUrl>" class="buttontext">${(productCategory.description)?default(productPromoCategory.productCategoryId)}</a>
                                <#if productPromoCategory.includeSubCategories! = "Y">(${uiLabelMap.OrderIncludeSubCategories})</#if>
                            </div>
                        </#list>
                    </p>
                    </#if>
                    <#if productPromoCategoryAlwaysList?has_content>
                    <p>
                        <div>${uiLabelMap.OrderAlwaysList}</div>
                        <#list productPromoCategoryAlwaysList as productPromoCategory>
                            <#assign productCategory = productPromoCategory.getRelatedOne("ProductCategory", true)>
                            <div>
                                -&nbsp;<a href="<@ofbizUrl>category/~category_id=${productPromoCategory.productCategoryId}</@ofbizUrl>" class="buttontext">${(productCategory.description)?default(productPromoCategory.productCategoryId)}</a>
                                <#if productPromoCategory.includeSubCategories! = "Y">(${uiLabelMap.OrderIncludeSubCategories})</#if>
                            </div>
                        </#list>
                    </p>
                    </#if>
                </div>
            </div>
            </#if>

            <#if productIds?has_content>
            <br/>
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h3 class="panel-title">${uiLabelMap.OrderProductsForPromotion}</h3>
                </div>
                <div class="panel-body">
                    <#-- Pagination & Results Starts -->
                    <#if (viewIndexMax > 0)>
                        <div class="row">
                        <#if productIds?has_content>
                        <#-- Pagination Starts -->
                            <div class="col-sm-6 pagination-block">
                                <ul class="pagination">
                                    <#if lowHasNext>
                                        <li><a href="<@ofbizUrl>showPromotionDetails/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~productPromoId=${productPromoId}</@ofbizUrl>">&laquo;</a></li>
                                    </#if>
                                    <#list lowViewList..highViewList as curViewNum>
                                        <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>showPromotionDetails/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~productPromoId=${productPromoId}</@ofbizUrl>">${curViewNum?int+1}</a></li>
                                    </#list>
                                    <#if highHasNext>
                                        <li><a href="<@ofbizUrl>showPromotionDetails/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~productPromoId=${productPromoId}</@ofbizUrl>">&raquo;</a></li>
                                    </#if>
                                </ul>
                            </div>
                        <#-- Pagination Ends -->
                        <#-- Results Starts -->
                            <div class="col-sm-6 results">
                                ${uiLabelMap.PFTShowing} ${lowIndex} ${uiLabelMap.CommonTo} ${highIndex} ${uiLabelMap.CommonOf} ${listSize} (${viewIndexMax?int + 1} ${uiLabelMap.PFTPages})
                            </div>
                        <#-- Results Ends -->
                        </#if>
                        </div>
                    </#if>
                    <table class="table table-bordered" id="productspromotion">
                        <thead>
                            <tr>
                                <th>${uiLabelMap.CommonQualifier}</th>
                                <th>${uiLabelMap.CommonBenefit}</th>
                                <#if (listSize > 0)>
                                    <th>&nbsp;</th>
                                </#if>
                            </tr>
                        </thead>
                        <tbody>
                            <#if (listSize > 0)>
                                <#list productIds as productId>
                                    <tr>
                                        <td>[<#if productIdsCond.contains(productId)>x<#else>&nbsp;</#if>]</td>
                                        <td>[<#if productIdsAction.contains(productId)>x<#else>&nbsp;</#if>]</td>
                                        <td>
                                            ${setRequestAttribute("optProductId", productId)}
                                            ${setRequestAttribute("listIndex", productId_index)}
                                            ${screens.render(productcategorylist)}
                                        </td>
                                    </tr>
                                </#list>
                            </#if>
                        </tbody>
                    </table>
                    <#-- Pagination & Results Starts -->
                    <#if (viewIndexMax > 0)>
                        <div class="row">
                        <#if productIds?has_content>
                        <#-- Pagination Starts -->
                            <div class="col-sm-6 pagination-block">
                                <ul class="pagination">
                                    <#if lowHasNext>
                                        <li><a href="<@ofbizUrl>showPromotionDetails/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~productPromoId=${productPromoId}</@ofbizUrl>">&laquo;</a></li>
                                    </#if>
                                    <#list lowViewList..highViewList as curViewNum>
                                        <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>showPromotionDetails/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~productPromoId=${productPromoId}</@ofbizUrl>">${curViewNum?int+1}</a></li>
                                    </#list>
                                    <#if highHasNext>
                                        <li><a href="<@ofbizUrl>showPromotionDetails/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~productPromoId=${productPromoId}</@ofbizUrl>">&raquo;</a></li>
                                    </#if>
                                </ul>
                            </div>
                        <#-- Pagination Ends -->
                        <#-- Results Starts -->
                            <div class="col-sm-6 results">
                                ${uiLabelMap.PFTShowing} ${lowIndex} ${uiLabelMap.CommonTo} ${highIndex} ${uiLabelMap.CommonOf} ${listSize} (${viewIndexMax?int + 1} ${uiLabelMap.PFTPages})
                            </div>
                        <#-- Results Ends -->
                        </#if>
                        </div>
                    </#if>
                </div>
            </div>
            </#if>
        </div>
        <div class="col-md-3 col-xs-12">
            ${screens.render("component://productfromthailand/widget/CartScreens.xml#minipromotext")}
        </div>
    </div>
</div>
