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
<#-- End Paginate Logic -->

<div id="main-container" class="container">
    <div class="row">
        <div class="col-md-9">
            <#-- Start Search Header -->
            <h2 class="main-heading2">${uiLabelMap.ProductProductSearch}</h2>
            <br />
            <#-- End Search Header -->
            <#-- Start Paginate -->
            <#if productIds?has_content>
            <div class="row">
                <div class="col-sm-6 pagination-block">
                    <ul class="pagination">
                        <#if lowHasNext>
                            <li><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~clearSearch=N</@ofbizUrl>">&laquo;</a></li>
                        </#if>
                        <#list lowViewList..highViewList as curViewNum>
                            <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~clearSearch=N</@ofbizUrl>">${curViewNum?int+1}</a></li>
                        </#list>
                        <#if highHasNext>
                            <li><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~clearSearch=N</@ofbizUrl>">&raquo;</a></li>
                        </#if>
                    </ul>
                </div>
                <div class="col-sm-6 results">
                    Showing ${lowIndex+1} to ${highIndex} of ${listSize} (${viewIndexMax?int + 1} Pages)
                </div>
            </div>
            </#if>
            <#-- End Paginate -->
            <#-- Start Product -->
            <div class="row">
            <#if productIds?has_content>
                <div class="productsummary-container">
                    <#list productIds as productId>
                        ${setRequestAttribute("optProductId", productId)}
                        ${setRequestAttribute("listIndex", productId_index)}
                        ${screens.render(productcategorylist)}
                    </#list>
                </div>
            <#else>
                <h2>&nbsp;${uiLabelMap.ProductNoResultsFound}.</h2>
            </#if>
            </div>
            <#-- End Product -->
            <#-- Start Paginate -->
            <#if productIds?has_content>
            <div class="row">
                <div class="col-sm-6 pagination-block">
                    <ul class="pagination">
                        <#if lowHasNext>
                            <li><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~clearSearch=N</@ofbizUrl>">&laquo;</a></li>
                        </#if>
                        <#list lowViewList..highViewList as curViewNum>
                            <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~clearSearch=N</@ofbizUrl>">${curViewNum?int+1}</a></li>
                        </#list>
                        <#if highHasNext>
                            <li><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~clearSearch=N</@ofbizUrl>">&raquo;</a></li>
                        </#if>
                    </ul>
                </div>
                <div class="col-sm-6 results">
                    Showing ${lowIndex+1} to ${highIndex} of ${listSize} (${viewIndexMax?int + 1} Pages)
                </div>
            </div>
            </#if>
            <#-- End Paginate -->
        </div>
        <#-- Sidebar Starts -->
        <div class="col-md-3">
        <#-- Categories Links Starts -->
            <h3 class="side-heading">Categories</h3>
            <div class="list-group">
                <#if (completedTree?has_content)>
                    <#list completedTree?sort_by("productCategoryId") as root>
                        <#if !root.child?has_content>
                            <a href="<@ofbizUrl>categorylist?productCategoryId=${root.productCategoryId!}</@ofbizUrl>" class="list-group-item">
                                <i class="fa fa-chevron-right"></i>
                                <#if root.categoryName??>${root.categoryName?js_string}<#elseif root.categoryDescription??>${root.categoryDescription?js_string}<#else>${root.productCategoryId?js_string}</#if>
                            </a>
                        </#if>
                    </#list>
                </#if>
            </div>
        <#-- Categories Links Ends -->
        <#--
        <#-- Shopping Options Starts --
            <h3 class="side-heading">Shopping Options</h3>
            <div class="list-group">
                <div class="list-group-item">
                    Brands
                </div>
                <div class="list-group-item">
                    <div class="filter-group">
                        <label class="checkbox">
                            <input name="filter1" type="checkbox" value="br1" checked="checked" />
                            Brand Name 1
                        </label>
                        <label class="checkbox">
                            <input name="filter2" type="checkbox" value="br2" />
                            Brand Name 2
                        </label>
                        <label class="checkbox">
                            <input name="filter2" type="checkbox" value="br2" />
                            Brand Name 3
                        </label>
                    </div>
                </div>
                <div class="list-group-item">
                    Manufacturer
                </div>
                <div class="list-group-item">
                    <div class="filter-group">
                        <label class="radio">
                            <input name="filter-manuf" type="radio" value="mr1" checked="checked" />
                            Manufacturer Name 1
                        </label>
                        <label class="radio">
                            <input name="filter-manuf" type="radio" value="mr2" />
                            Manufacturer Name 2
                        </label>
                        <label class="radio">
                            <input name="filter-manuf" type="radio" value="mr3" />
                            Manufacturer Name 3
                        </label>
                    </div>
                </div>
                <div class="list-group-item">
                    <button type="button" class="btn btn-main">Filter</button>
                </div>
            </div>
        <#-- Shopping Options Ends --
        <#-- Bestsellers Links Starts --
            <h3 class="side-heading">Bestsellers</h3>
            <div class="product-col">
                <div class="image">
                    <img src="images/product-images/6.JPG" alt="product" class="img-responsive" />
                </div>
                <div class="caption">
                    <h4>
                        <a href="product-full.html">Antique Jewellery</a>
                    </h4>
                    <div class="description">
                        We are so lucky living in such a wonderful time. Our almost unlimited ...
                    </div>
                    <div class="price">
                        <span class="price-new">$199.50</span>
                        <span class="price-old">$249.50</span>
                    </div>
                    <div class="cart-button button-group">
                        <button type="button" title="Wishlist" class="btn btn-wishlist">
                            <i class="fa fa-heart"></i>
                        </button>
                        <button type="button" title="Compare" class="btn btn-compare">
                            <i class="fa fa-bar-chart-o"></i>
                        </button>
                        <button type="button" class="btn btn-cart">
                            Add to cart
                            <i class="fa fa-shopping-cart"></i>
                        </button>
                    </div>
                </div>
            </div>
        <#-- Bestsellers Links Ends --
        -->
        </div>
        <#-- Sidebar Ends -->
    </div>
</div>