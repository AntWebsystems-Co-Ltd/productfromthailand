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
      <h3 class="side-heading">Store Menu</h3>
      <div class="list-group">
          <a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="list-group-item">
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
      <div class="panel panel-smart">
        <a href="<@ofbizUrl>EditProduct</@ofbizUrl>" class="btn btn-main">${uiLabelMap.ProductNewProduct}</a>
        <a href="<@ofbizUrl>uploadproducts</@ofbizUrl>" class="btn btn-main">${uiLabelMap.PFTUploadProductSpreadsheet}</a>
        <a href="<@ofbizUrl>ViewSimpleContent?contentId=PROD_TEMP</@ofbizUrl>" class="btn btn-main">${uiLabelMap.PFTDownloadProductTemplate}</a><br/><br/>
        <div class="screenlet">
          <div class="row">
            <!-- Pagination Starts -->
            <#if (totalPage > 1)>
              <div class="col-sm-6 pagination-block">
                <ul class="pagination">
                  <li><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=0</@ofbizUrl>">«</a></li>
                  <#if (totalPage > 0)>
                    <#assign i = viewIndex +1/>
                    <#assign max = i +2/>
                    <#assign min = i -2/>
                    <#if (max >= totalPage)>
                      <#assign max = totalPage/>
                      <#assign min = max - 4/>
                    </#if>
                    <#if (min <= 0)>
                      <#assign min = 1/>
                      <#assign max = min + 4/>
                      <#if (max >= totalPage)>
                        <#assign max = totalPage/>
                      </#if>
                    </#if>
                    <#list min..max as i>
                      <#if (viewIndex = i-1)>
                        <li class="active"><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${i-1}</@ofbizUrl>">${i}</a></li>
                      <#else>
                        <li><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${i-1}</@ofbizUrl>">${i}</a></li>
                      </#if>
                    </#list>
                  </#if>
                  <li><a href="<@ofbizUrl>StoreManagement?portalPageId=${(parameters.portalPageId)?if_exists}&parentPortalPageId=${(parameters.parentPortalPageId)?if_exists}&VIEW_SIZE=${viewSize}&VIEW_INDEX=${totalPage-1}</@ofbizUrl>">»</a></li>
                </ul>
              </div>
              <div class="col-sm-6 results">
                Showing ${lowIndex} to ${highIndex} ${uiLabelMap.CommonOf} ${listSize} ( ${totalPage} pages)
              </div>
            </#if>
            <!-- Pagination Ends -->
          </div>
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
                              <a href="<@ofbizUrl>EditProduct?productId=${(supplierProduct.productId)?if_exists}</@ofbizUrl>"><img alt="Small Image" src="<@ofbizContentUrl>${(product.smallImageUrl)?default("/images/defaultImage.jpg")}</@ofbizContentUrl>" height="80" width="80" align="middle"></a>
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