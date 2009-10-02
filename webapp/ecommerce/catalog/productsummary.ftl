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
    <#-- variable setup -->
    <#assign productUrl = Static["org.ofbiz.product.category.CatalogUrlServlet"].makeCatalogUrl(request, product.productId, categoryId, "")/>

    <#if requestAttributes.productCategoryMember?exists>
        <#assign prodCatMem = requestAttributes.productCategoryMember>
    </#if>
    <#assign smallImageUrl = productContentWrapper.get("SMALL_IMAGE_URL")?if_exists>
    <#if !smallImageUrl?string?has_content><#assign smallImageUrl = "/images/defaultImage.jpg"></#if>
    <#-- end variable setup -->
    <#assign productInfoLinkId = "productInfoLink">
    <#assign productInfoLinkId = productInfoLinkId + product.productId/>
    <#assign productDetailId = "productDetailId"/>
    <#assign productDetailId = productDetailId + product.productId/>
    <div class="productsummary">
        <div class="smallimage">
            <a href="${productUrl}">
                <#--span id="${productInfoLinkId}" class="popup_link"--><img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Small Image"/><#--/span-->
            </a>
        </div>
        <div id="${productDetailId}" class="popup" >
          <table>
            <tr valign="top">
              <td>
                <img src="<@ofbizContentUrl>${contentPathPrefix?if_exists}${smallImageUrl}</@ofbizContentUrl>" alt="Small Image"/><br/>
                ${uiLabelMap.ProductProductId}   : ${product.productId?if_exists}<br/>
                ${uiLabelMap.ProductProductName} : ${product.productName?if_exists}<br/>
                ${uiLabelMap.CommonDescription}  : ${product.description?if_exists}
              </td>
            </tr>
          </table>
        </div>
        <script type="text/javascript">
          new Popup('${productDetailId}','${productInfoLinkId}', {position: 'none'})
        </script>
        
        <div class="productinfo">
          <div>
            <a href="${productUrl}" class="linktext">${productContentWrapper.get("PRODUCT_NAME")?if_exists}</a>
          </div>
        </div>  
    </div>
<#else>
&nbsp;${uiLabelMap.ProductErrorProductNotFound}.<br/>
</#if>