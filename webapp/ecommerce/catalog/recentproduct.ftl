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
<#if product?exists>
    <#assign productUrl = Static["org.ofbiz.product.category.CatalogUrlServlet"].makeCatalogUrl(request, product.productId, product.primaryProductCategoryId,"")/>
<div class="recentproduct">
    <div class="recentproductimage">
        <#if product.smallImageUrl?exists>
        <a href="${productUrl}"><img src="${product.smallImageUrl}"/></a>
        <#else>
        <a href="${productUrl}"><img src="/images/defaultImage.jpg"/></a>
        </#if>
    </div>
    <div id="recentproductdetail">
         <div class="recentproductlabel">
             <a href="${productUrl}" class="linktext">${productContentWrapper.get("PRODUCT_NAME")?if_exists}</a>
         </div>
         <p>${productContentWrapper.get("DESCRIPTION")?if_exists}</p> 
    </div>
</div>
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br/>
</#if>