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

<#if productCategoryId?? && productCategoryId != "PFTPROMOTION">
<#-- Pagination & Results Starts -->
<#if (viewIndexMax > 0)>
    <div class="row">
    <#if productCategoryMembers?has_content>
    <#-- Pagination Starts -->
        <div class="col-sm-6 pagination-block">
            <ul class="pagination">
                <#if lowHasNext>
                    <li><a href="<@ofbizUrl>main/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>">&laquo;</a></li>
                </#if>
                <#list lowViewList..highViewList as curViewNum>
                    <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>main/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~productCategoryId=${productCategoryId}</@ofbizUrl>">${curViewNum?int+1}</a></li>
                </#list>
                <#if highHasNext>
                    <li><a href="<@ofbizUrl>main/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>">&raquo;</a></li>
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
<#-- Pagination & Results Ends -->
</#if>

<div class="row">
<#if productCategoryMembers?has_content>
    <#list productCategoryMembers as productCategoryMember>
        ${setRequestAttribute("optProductId", productCategoryMember.productId)}
        ${setRequestAttribute("productCategoryMember", productCategoryMember)}
        ${setRequestAttribute("listIndex", productCategoryMember_index)}
        ${screens.render(productsummaryScreen)}
    </#list>
<#else>
    <hr />
    ${uiLabelMap.ProductNoProductsInThisCategory}
</#if>
</div>

<#if productCategoryId?? && productCategoryId != "PFTPROMOTION">
<#-- Pagination & Results Starts -->
<#if (viewIndexMax > 0)>
    <div class="row">
    <#if productCategoryMembers?has_content>
    <#-- Pagination Starts -->
        <div class="col-sm-6 pagination-block">
            <ul class="pagination">
                <#if lowHasNext>
                    <li><a href="<@ofbizUrl>main/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${lowNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>">&laquo;</a></li>
                </#if>
                <#list lowViewList..highViewList as curViewNum>
                    <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>main/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~productCategoryId=${productCategoryId}</@ofbizUrl>">${curViewNum?int+1}</a></li>
                </#list>
                <#if highHasNext>
                    <li><a href="<@ofbizUrl>main/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${highNext}/~productCategoryId=${productCategoryId}</@ofbizUrl>">&raquo;</a></li>
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
<#-- Pagination & Results Ends -->
</#if>
