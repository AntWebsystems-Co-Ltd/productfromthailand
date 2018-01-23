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

<#-- Main Container Starts -->
    <div id="main-container-home" class="container">
    <#-- Slider & Main Banner Starts -->
        <div class="slider">
            <div class="row">
                <#assign numSlide = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"].getPropertyValue("pft", "image.slide.size", delegator)>
                <#assign intNumSlide = Static["java.lang.Integer"].parseInt("${numSlide}")>
                <#-- Slider Section Starts -->
                    <div class="col-md-9 col-xs-12">
                        <#if (categorySlideImageContentList)??>
                        <div id="main-carousel" class="carousel slide" data-ride="carousel">
                            <#-- Wrapper For Slides Starts -->
                                <div class="carousel-inner">
                                    <#list categorySlideImageContentList as categorySlideImageContent>
                                    <div class="item <#if categorySlideImageContent?is_first>active</#if>">
                                        <img src="/content/control/stream?contentId=${categorySlideImageContent.contentId}" alt="Slider" class="img-responsive">
                                    </div>
                                    </#list>
                                </div>
                            <#-- Wrapper For Slides Ends -->
                            <#-- Controls Starts -->
                            <#if (intNumSlide?int > 1)>
                                <a class="left carousel-control" href="#main-carousel" role="button" data-slide="prev">
                                    <span class="glyphicon glyphicon-chevron-left"></span>
                                </a>
                                <a class="right carousel-control" href="#main-carousel" role="button" data-slide="next">
                                    <span class="glyphicon glyphicon-chevron-right"></span>
                                </a>
                            </#if>
                            <#-- Controls Ends -->
                        </div>
                        </#if>
                    </div>
                <#-- Slider Section Ends -->
                <#-- Main Banner Starts -->
                    <div class="col-md-3 col-xs-12">
                        <#-- <img src="/pft-default/pftimages/banners/banner-top-right.png" alt="banners" class="img-responsive"> -->
                        ${screens.render("component://productfromthailand/widget/CartScreens.xml#minipromotext")}
                    </div>
                <#-- Main Banner Ends -->
            </div>
        </div>
    <#-- Slider & Main Banner Ends -->
    <#--
    <#-- Latest Products Starts
        <section class="product-carousel">
        <#-- Heading Starts
            <h2 class="product-head">Latest Products</h2>
        <#-- Heading Ends
        <#-- Products Row Starts
            <div class="row">
                <div class="col-xs-12">
                    <#-- Product Carousel Starts
                        <div id="owl-product" class="owl-carousel">
                            <#if requestAttributes.productCategoryId?has_content>
                                ${screens.render("component://productfromthailand/widget/ProductScreens.xml#showBestSellingCategory")}
                            </#if>
                        </div>
                    <#-- Product Carousel Ends
                </div>
            </div>
        <#-- Products Row Ends
        </section>
    <#-- Latest Products Ends
    <#-- 3 Column Banners Starts
        <div class="col3-banners">
            <ul class="row list-unstyled">
                <li class="col-sm-4">
                    <img src="images/banners/3col-banner1.png" alt="banners" class="img-responsive">
                </li>
                <li class="col-sm-4">
                    <img src="images/banners/3col-banner2.png" alt="banners" class="img-responsive">
                </li>
                <li class="col-sm-4">
                    <img src="images/banners/3col-banner3.png" alt="banners" class="img-responsive">
                </li>
            </ul>
        </div>
    <#-- 3 Column Banners Ends
    -->
    <#-- Featured Products Starts -->
        <section class="products-list">
        <#-- Heading Starts -->
            <div id="featureproduct-header">
                <h2 class="product-header">
                    ${uiLabelMap.PFTFeaturedProduct}
                    <a href="<@ofbizUrl>AllFeatureProducts?productCategoryId=${productCategoryId!}</@ofbizUrl>" class="btn btn-main pull-right" id="allfeature-btn">${uiLabelMap.ProductShowAll}</a>
                </h2>
            </div>
        <#-- Heading Ends -->
        <#-- Products Row Starts -->
            <#if requestAttributes.productCategoryId?has_content>
                ${screens.render("component://productfromthailand/widget/ProductScreens.xml#category-include")}
            <#else>
                <div class="row">
                <center><h2>${uiLabelMap.EcommerceNoPROMOTIONCategory}</h2></center>
                </div>
            </#if>
        <#-- Products Row Ends -->
        </section>
    <#-- Featured Products Ends -->
    <#-- 2 Column Banners Starts -->
        <div class="col2-banners">
            <ul class="row list-unstyled">
                <li class="col-sm-4">
                    <img src="/pft-default/pftimages/banners/banner-bottom-left.png" alt="banners" class="img-responsive">
                </li>
                <li class="col-sm-8">
                    <img src="/pft-default/pftimages/banners/banner-bottom-right.jpg" alt="banners" class="img-responsive">
                </li>
            </ul>
        </div>
    <#-- 2 Column Banners Ends -->
    </div>
<#-- Main Container Ends -->
