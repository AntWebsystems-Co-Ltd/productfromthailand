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

<div id="main-container" class="container">
  <div class="row">
    <!-- Store Management Menu Start -->
    <div class="col-sm-3">
      <h3 class="side-heading">${uiLabelMap.PFTStoreMenu}</h3>
      <div class="list-group">
          <a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="list-group-item selected">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.PFTMyProducts}
          </a>
          <a href="<@ofbizUrl>SupplierInvoiceList</@ofbizUrl>" class="list-group-item">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.AccountingListInvoices}
          </a>
          <a href="<@ofbizUrl>PurchaseOrderList</@ofbizUrl>" class="list-group-item">
              <i class="fa fa-chevron-right"></i>
              ${uiLabelMap.AccountingFixedAssetMaintOrders}
          </a>
      </div>
    </div>
    <!-- Store Management Menu Ends -->
    <div class="col-sm-9">
      <div class="panel-smart">
        <a href="<@ofbizUrl>EditProduct</@ofbizUrl>" class="btn btn-main">${uiLabelMap.ProductNewProduct}</a>
        <a href="<@ofbizUrl>uploadproducts</@ofbizUrl>" class="btn btn-main">${uiLabelMap.PFTUploadProductSpreadsheet}</a>
        <a href="<@ofbizUrl>ViewSimpleContent?contentId=PROD_TEMP</@ofbizUrl>" class="btn btn-main">${uiLabelMap.PFTDownloadProductTemplate}</a><br/><br/>
        <div class="screenlet">
          <!-- Pagination Starts -->
          <#if (totalPage > 1)>
          <div class="row">
              <div class="col-sm-6 pagination-block">
                <ul class="pagination">
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
                    <#if lowHasNext>
                    <li><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=0</@ofbizUrl>">&laquo;</a></li>
                    </#if>
                    <#list lowViewList..highViewList as curViewNum>
                        <li <#if (curViewNum?int == viewIndex?int)>class="active"</#if>><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${curViewNum?int}</@ofbizUrl>">${curViewNum?int+1}</a></li>
                    </#list>
                    <#if highHasNext>
                    <li><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${totalPage-1}</@ofbizUrl>">&raquo;</a></li>
                    </#if>
                </ul>
              </div>
              <div class="col-sm-6 results">
                ${uiLabelMap.PFTShowing} ${lowIndex+1} ${uiLabelMap.CommonTo} ${highIndex} ${uiLabelMap.CommonOf} ${listSize} (${viewIndexMax?int + 1} ${uiLabelMap.PFTPages})
              </div>
          </div>
          </#if>
          <!-- Pagination Ends -->
          <div class="screenlet-body table-responsive shopping-cart-table">
            <table class="table table-bordered">
              <thead>
                  <tr>
                    <td colspan="3" class="text-center">${uiLabelMap.ProductProductNameId}</td>
                    <td class="text-center">${uiLabelMap.CommonFromDateTime}</td>
                    <td class="text-center">${uiLabelMap.SupplierProductPrice}</td>
                  </tr>
              </thead>
              <tbody>
                <#if (listSize > 0)>
                  <tr>
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
                              <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>"><img alt="Small Image" src="<@ofbizContentUrl>${(product.smallImageUrl)?default("/pft-default/images/defaultImage.jpg")}</@ofbizContentUrl>" height="80" width="80" align="middle"></a>
                            <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>" class="btn btn-main"><#if product?exists>${(product.internalName)?if_exists}</#if> [${(supplierProduct.productId)?if_exists}]</a>
                          </td>
                          <td class="text-center" <#if hasntStarted> style="color: red;"</#if>>${(product.createdDate)?if_exists}</td>
                          <td class="text-center">
                            <span><div><@ofbizCurrency amount=supplierProduct.lastPrice isoCode=supplierProduct.currencyUomId/></div></span>
                            <input type="hidden" name="productId${suffix}" value="${(supplierProduct.productId)?if_exists}">
                          </td>
                        </tr>
                      </form>
                      <#assign rowCount = rowCount + 1>
                    </#list>
                  </tr>
                </#if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>