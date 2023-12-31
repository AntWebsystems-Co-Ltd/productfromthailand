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
        <div class="col-sm-3">
            ${setRequestAttribute("isMyProducts", "Y")}
            ${screens.render("component://productfromthailand/widget/CatalogScreens.xml#StoreManagementMenus")}
        </div>
        <div class="col-sm-9">
            <div class="panel panel-smart">
                <div class="panel-heading">
                    <h3>${uiLabelMap.PFTUploadProductSpreadsheet}</h3>
                </div>
                <div class="panel-body">
                    <form method="post" enctype="multipart/form-data" action="<@ofbizUrl>UploadProductFromSpreadsheet</@ofbizUrl>" class="form-horizontal name="productsUploadForm">
                        <input type="hidden" name="supplierPartyId" value="${partyId?if_exists}"/>
                        <div class="form-group">
                            <div class="col-sm-6">
                                <input type="file" class="form-control" size="50" name="fname"/>
                            </div>

                            <div class="col-sm-3">
                                <input type="submit" class="btn btn-main" value="${uiLabelMap.PFTUploadProduct}"/>
                            </div>
                        </div>
                    </form>
                    <a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonBack}</a>
                </div>
            </div>
        </div>
    </div>
</div>
