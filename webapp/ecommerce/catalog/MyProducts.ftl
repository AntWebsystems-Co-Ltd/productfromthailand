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
    <a href="<@ofbizUrl>main</@ofbizUrl>" class="buttontext">${uiLabelMap.PFTUploadProductSpreadsheet}</a><br/><br/>
<div class="screenlet">
    <div class="screenlet-title-bar">
        <#if (listSize > 0)>
            <div class="boxhead-right">
                <#if (viewIndex > 1)>
                    <a href="<@ofbizUrl>EditCategoryProducts?productCategoryId=${productCategoryId?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${viewIndex-1}</@ofbizUrl>" class="submenutext">${uiLabelMap.CommonPrevious}</a> |
                </#if>
                <span class="submenutextinfo">${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span>
                <#if (listSize > highIndex)>
                    | <a class="lightbuttontext" href="<@ofbizUrl>EditCategoryProducts?productCategoryId=${productCategoryId?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${viewIndex+1}</@ofbizUrl>" class="submenutextright">${uiLabelMap.CommonNext}</a>
                </#if>
                &nbsp;
            </div>
            <div class="boxhead-left">
                ${uiLabelMap.PFTProductsOf} ${supplier.groupName}
            </div>
            <div class="boxhead-fill">&nbsp;</div>
        </#if>
    </div>
    <div class="screenlet-body">
        <table cellspacing="0" class="basic-table">
          <tr class="header-row">
            <td align="left" colspan="3">${uiLabelMap.ProductProductNameId}</td>
            <td>${uiLabelMap.CommonFromDateTime}</td>
          </tr>
          <#if (listSize > 0)>
            <tr><td>
              <#assign rowClass = "2">
              <#assign rowCount = 0>
              <#list supplierProducts as supplierProduct>
                <#assign suffix = "_o_" + supplierProduct_index>
                <#assign product = supplierProduct.getRelatedOne("Product")>
                <#assign hasntStarted = false>
                <#if product.createdDate?exists && nowTimestamp.before(product.getTimestamp("createdDate"))><#assign hasntStarted = true></#if>
                <#assign hasExpired = false>
                <#if supplierProduct.availableThruDate?exists && nowTimestamp.after(supplierProduct.getTimestamp("availableThruDate"))><#assign hasExpired = true></#if>
                <form method="post" action="<@ofbizUrl>updateSupplierProduct</@ofbizUrl>" name="EditProduct">
                  <input type="hidden" name="VIEW_SIZE" value="${viewSize}"/>
                  <input type="hidden" name="VIEW_INDEX" value="${viewIndex}"/>
                  
                  <input type="hidden" name="productCategoryId" value="${productCategoryId?if_exists}">
                  <tr valign="middle"<#if rowClass == "1"> class="alternate-row"</#if>>
                    <td colspan="3">
                        <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>"><img alt="Small Image" src="<@ofbizContentUrl>${(product.smallImageUrl)?default("/images/defaultImage.jpg")}</@ofbizContentUrl>" height="80" width="80" align="middle"></a>
                      <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>" class="buttontext"><#if product?exists>${(product.internalName)?if_exists}</#if> [${(supplierProduct.productId)?if_exists}]</a>
                    </td>
                    <td <#if hasntStarted> style="color: red;"</#if>>${(product.createdDate)?if_exists}</td>
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