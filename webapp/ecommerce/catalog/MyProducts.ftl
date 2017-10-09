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

<a href="<@ofbizUrl>EditProduct</@ofbizUrl>" class="buttontext">${uiLabelMap.ProductNewProduct}</a>&nbsp;&nbsp;
<a href="<@ofbizUrl>uploadproducts</@ofbizUrl>" class="buttontext">${uiLabelMap.PFTUploadProductSpreadsheet}</a>
<a href="<@ofbizUrl>ViewSimpleContent?contentId=PROD_TEMP</@ofbizUrl>" class="buttontext">${uiLabelMap.PFTDownloadProductTemplete}</a><br/><br/>
<div class="screenlet">
    <div class="screenlet-title-bar" id="product-title-bar">
        <#if (listSize > 0)>
            <div class="boxhead-right">
                <#if (0 < viewIndex)>
                    <a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${viewIndex-1}</@ofbizUrl>" class="submenutext">${uiLabelMap.CommonPrevious}</a> |
                <#else>
                  <span class="submenutextdisabled">${uiLabelMap.CommonPrevious}</span>
                </#if>
                <#if 0 < listSize>
                <span class="submenutextinfo">${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span>
                </#if>
                <#if (listSize > highIndex)>
                    | <a class="lightbuttontext" href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${viewIndex+1}</@ofbizUrl>" class="submenutextright">${uiLabelMap.CommonNext}</a>
                <#else>
                  <span class="submenutextrightdisabled">${uiLabelMap.CommonNext}</span>
                </#if>
                &nbsp;
            </div>
            <div class="boxhead-left">
                &nbsp;${uiLabelMap.PFTProductsOf?if_exists} : ${supplier.groupName?if_exists} ${supplier.firstName?if_exists} ${supplier.lastName?if_exists}
            </div>
        </#if>
    </div>
    <div class="screenlet-body">
        <table cellspacing="0" class="basic-table">
          <tr class="header-row">
            <td align="left" colspan="3">${uiLabelMap.ProductProductNameId}</td>
            <td>${uiLabelMap.CommonFromDateTime}</td>
            <td>${uiLabelMap.SupplierProductPrice}</td>
          </tr>
          <#if (listSize > 0)>
            <tr><td>
              <#assign rowClass = "2">
              <#assign rowCount = 0>
              <#list supplierProducts[lowIndex..highIndex-1] as supplierProduct>
                <#assign suffix = "_o_" + supplierProduct_index>
                <#assign product = supplierProduct.getRelatedOne("Product")>
                <#assign hasntStarted = false>
                <#if product.createdDate?exists && nowTimestamp.before(product.getTimestamp("createdDate"))><#assign hasntStarted = true></#if>
                <#assign hasExpired = false>
                <#if supplierProduct.availableThruDate?exists && nowTimestamp.after(supplierProduct.getTimestamp("availableThruDate"))><#assign hasExpired = true></#if>
                <form method="post" action="<@ofbizUrl>updateSupplierProduct</@ofbizUrl>" name="EditProduct">
                  <input type="hidden" name="VIEW_SIZE" value="${viewSize}"/>
                  <input type="hidden" name="VIEW_INDEX" value="${viewIndex}"/>

                  <tr valign="middle"<#if rowClass == "1"> class="alternate-row"</#if>>
                    <td colspan="3">
                        <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>"><img alt="Small Image" src="<@ofbizContentUrl>${(product.smallImageUrl)?default("/images/defaultImage.jpg")}</@ofbizContentUrl>" height="80" width="80" align="middle"></a>
                      <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>" class="buttontext"><#if product?exists>${(product.internalName)?if_exists}</#if> [${(supplierProduct.productId)?if_exists}]</a>
                    </td>
                    <td <#if hasntStarted> style="color: red;"</#if>>${(product.createdDate)?if_exists}</td>
                    <td><div><@ofbizCurrency amount=supplierProduct.lastPrice isoCode=supplierProduct.currencyUomId/></div></span>
                    <input type="hidden" name="productId${suffix}" value="${(supplierProduct.productId)?if_exists}">
                  </tr>
                  <#-- toggle the row color -->
                  <#if rowClass == "2">
                      <#assign rowClass = "1">
                  <#else>
                      <#assign rowClass = "2">
                  </#if>
                  <tr valign="middle">
                      <td colspan="4" align="center">
                          <#--input type="submit" value="${uiLabelMap.CommonEdit}" style="font-size: x-small;"-->
                          <input type="hidden" value="${supplierProducts.size()}" name="_rowCount">
                      </td>
                  </tr>
                </form>
                <#assign rowCount = rowCount + 1>
              </#list>
          </#if>
        </table>
    </div>
</div>