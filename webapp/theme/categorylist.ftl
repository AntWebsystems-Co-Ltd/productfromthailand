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
        <#if (lowViewList?int <= 0)>
            <#assign lowViewList = 0>
            <#assign lowHasNext = false>
        </#if>
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

<#-- Main Container Starts -->
    <div id="main-container" class="container">
        <div class="row">
        <#-- Primary Content Starts -->
            <div class="col-md-9">
                <#if productCategory??>
                    ${screens.render(categorycontent)}
                </#if>
            <#-- Product Filter Starts -->
                <#if productCategoryMembers?has_content>
                <div class="product-filter">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="display">
                                <#assign categoryListUrl = "categorylist?productCategoryId="+productCategory.productCategoryId>
                                <#assign categoryGridUrl = "categorygrid?productCategoryId="+productCategory.productCategoryId>
                                <a href="<@ofbizUrl>${categoryListUrl!}</@ofbizUrl>#main-container" class="active">
                                    <i class="fa fa-th-list" title="List View"></i>
                                </a>
                                <a href="<@ofbizUrl>${categoryGridUrl!}</@ofbizUrl>#main-container">
                                    <i class="fa fa-th" title="Grid View"></i>
                                </a>
                            </div>
                         </div>
                        <#--
                        <div class="col-md-2 text-right">
                            <label class="control-label">Sort</label>
                        </div>
                        <div class="col-md-3 text-right">
                            <select class="form-control">
                                <option value="default" selected="selected">Default</option>
                                <option value="NAZ">Name (A - Z)</option>
                                <option value="NZA">Name (Z - A)</option>
                            </select>
                        </div>
                        <div class="col-md-1 text-right">
                            <label class="control-label">Show</label>
                        </div>
                        <div class="col-md-2 text-right">
                            <select class="form-control">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3" selected="selected">3</option>
                            </select>
                        </div>
                         -->
                    </div>
                </div>
                </#if>
            <#-- Product Filter Ends -->
            <#-- Pagination & Results Starts -->
            <#if (viewIndexMax > 0)>
                <div class="row">
                <#if productCategoryMembers?has_content>
                <#-- Pagination Starts -->
                    <div class="col-sm-6 pagination-block">
                        <ul class="pagination">
                            <#if lowHasNext>
                                <li><a href="<@ofbizUrl>categorylist/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>#main-container">&laquo;</a></li>
                            </#if>
                            <#list lowViewList..highViewList as curViewNum>
                                <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>categorylist/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~productCategoryId=${productCategoryId}</@ofbizUrl>#main-container">${curViewNum?int+1}</a></li>
                            </#list>
                            <#if highHasNext>
                                <li><a href="<@ofbizUrl>categorylist/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>#main-container">&raquo;</a></li>
                            </#if>
                        </ul>
                    </div>
                <#-- Pagination Ends -->
                <#-- Results Starts -->
                    <div class="col-sm-6 results">
                        Showing ${lowIndex} to ${highIndex} of ${listSize} (${viewIndexMax?int + 1} Pages)
                    </div>
                <#-- Results Ends -->
                </#if>
                </div>
            </#if>
            <#-- Pagination & Results Ends -->
            <#-- Product List Display Starts -->
                <div class="row">
                    <#if productCategoryMembers?has_content>
                        <#list productCategoryMembers as productCategoryMember>
                            ${setRequestAttribute("optProductId", productCategoryMember.productId)}
                            ${setRequestAttribute("productCategoryMember", productCategoryMember)}
                            ${setRequestAttribute("listIndex", productCategoryMember_index)}
                            ${screens.render(productcategorylist)}
                        </#list>
                        <#else>
                        <div class="panel-smart">
                            <label class="h3">${uiLabelMap.ProductNoProductsInThisCategory}.</label>
                        </div>
                    </#if>
                </div>
            <#-- Product List Display Ends -->
            <#-- Pagination & Results Starts -->
            <#if (viewIndexMax > 0)>
                <div class="row">
                <#if productCategoryMembers?has_content>
                <#-- Pagination Starts -->
                    <div class="col-sm-6 pagination-block">
                        <ul class="pagination">
                            <#if lowHasNext>
                                <li><a href="<@ofbizUrl>categorylist/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>#main-container">&laquo;</a></li>
                            </#if>
                            <#list lowViewList..highViewList as curViewNum>
                                <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>categorylist/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~productCategoryId=${productCategoryId}</@ofbizUrl>#main-container">${curViewNum?int+1}</a></li>
                            </#list>
                            <#if highHasNext>
                                <li><a href="<@ofbizUrl>categorylist/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>#main-container">&raquo;</a></li>
                            </#if>
                        </ul>
                    </div>
                <#-- Pagination Ends -->
                <#-- Results Starts -->
                    <div class="col-sm-6 results">
                        Showing ${lowIndex} to ${highIndex} of ${listSize} (${viewIndexMax?int + 1} Pages)
                    </div>
                <#-- Results Ends -->
                </#if>
                </div>
            </#if>
            <#-- Pagination & Results Ends -->
            </div>
        <#-- Primary Content Ends -->
        <#-- Sidebar Starts -->
            <div class="col-md-3">
                ${screens.render("component://productfromthailand/widget/CartScreens.xml#minipromotext")}
            <#--
            <#-- Shopping Options Starts
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
            <#-- Shopping Options Ends
            <#-- Bestsellers Links Starts
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
            <#-- Bestsellers Links Ends
            -->
            </div>
        <#-- Sidebar Ends -->
        </div>
    </div>
<#-- Main Container Ends -->
