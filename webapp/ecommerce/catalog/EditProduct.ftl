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

<script type="text/javascript">
    function getFile(inputIndex){
        document.getElementById("upfile_"+inputIndex).click();
    }
    function showPreview(ele,index)
    {
        if (ele.files && ele.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#imgAvatar_'+index).attr('src', e.target.result);
            }
            reader.readAsDataURL(ele.files[0]);
        }
        $('#li-'+index).addClass('uploaded');
        $('#cancel_'+index).removeClass('hidden');
    }
    function addNewInput(index){
        var nextIndex = index+1;
        $('#cancel_'+index).removeClass('hidden');
        $("ul.uploading").append(
            "<li id='li-"+nextIndex+"'>"
                +"<input class='file' id='upfile_"+nextIndex+"' type='file' name='uploadedFile_"+nextIndex+"' style='margin-right:8px;' onclick='addNewInput("+nextIndex+")'/><br \>"
                +"<a class='cancel hidden' id='cancel_"+nextIndex+"' onclick='cancelImage("+nextIndex+")'>Cancel</a>"
            +"</li>");
    }
    function cancelImage(index){
        $('#imgAvatar_'+index).attr('src', '/pft-default/images/add.png');
        $('#upfile_'+index).val('');
        $('#cancel_'+index).addClass('hidden');
    }
    function validateProductId() {
        var x = document.forms["EditProductForm"]["productId"].value;
        var name = document.forms["EditProductForm"]["internalName"].value;
        var defaultPrice = document.forms["EditProductForm"]["price"].value;
        var isName = false;
        var isdPrice = false;
        if(name != null && name != "") isName = true;
        if(defaultPrice != null && defaultPrice != "") isdPrice = true;
        if ((x == null || x == "") && isName && isdPrice) {
            var inputs = document.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++)
            {
                var id = document.getElementsByTagName("input")[i].id;
                if(id == "productId")
                {
                    (elem=document.getElementById(id)).parentNode.removeChild(elem);
                    (elem=document.getElementById(id + 'label')).parentNode.removeChild(elem);
                    //document.getElementByTagName("input")[i].removeAttribute("name");
                }
            }
        }
    }
    $(window).load(function() {
        $('.uploaded-image').find('img').each(function(){
            var logoHeight = $(this).height();
            if (logoHeight < 82) {
                var margintop = (82 - logoHeight) / 2;
                $(this).css('margin-top', margintop);
            }
        });
    });
    function debug(msg) {
        alert(msg);
    }
    function formImageSubmit(id,mode) {
        if(mode === 'remove') {
            $('#removeProductImage'+id).submit();
        }
    }
    function allowOnly2Numeric2Decimal(field) {
        var testValue = (/^\d{0,99}(\.\d{0,2})?$/).test(field.value);
        if (!testValue) {
            $(field).val('');
        }
    }
    jQuery(document).ready( function() {
        var mybrowser=navigator.userAgent;
        if(mybrowser.indexOf('MSIE')>0){
            $('.browserNotIE').remove();
        }
        else{
            $('.browserIsIE').remove();
        }
        jQuery('#productName').focus();
        jQuery("#EditProductForm").validate();

        $('#price').on('input', function () {
            if($('#price').val() != ""){
                $.ajax({
                    url : "<@ofbizUrl>calculateSalePrice</@ofbizUrl>",
                    type : "POST",
                    data : "purchasePrice="+$('#price').val(),
                    success : function(data) {
                        $('#salePrice').val(data.salePrice);
                        $('#salePriceDisplay').val(data.salePrice);
                    }
                });
            } else {
                $('#salePrice').val(null);
                $('#salePriceDisplay').val(null);
            }
        });
    });
</script>

<div id="main-container" class="container">
    <div class="row">
        <div class="col-sm-3">
            <h3 class="side-heading">Store Menu</h3>
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
        <div class="col-sm-8">
            <div class="panel-smart">
                <div class="panel-heading">
                  <h3><#if product?exists>${uiLabelMap.PageTitleEditProduct} : ${product.internalName} [${uiLabelMap.CommonId}:${productId}]<#else>${uiLabelMap.ProductCreateProduct}</#if> <#if productCategory?exists>${uiLabelMap.CommonIn} <#if (productCategory.categoryName)?has_content>"${productCategory.categoryName}"</#if> [${uiLabelMap.CommonId}:${productCategory.productCategoryId?if_exists}]</#if></h3>
                </div>
                <div class="panel-body">
                <form method="post" onsubmit="return validateProductId()" enctype="multipart/form-data" action="<#if product?exists><@ofbizUrl>updateProduct</@ofbizUrl><#else><@ofbizUrl>createProduct</@ofbizUrl></#if>" class="form-horizontal" name="EditProductForm" id="EditProductForm">
                    <input type="hidden" name="currencyUomId" value="${currencyUomId}"/>
                    <input type="hidden" name="productTypeId" value="FINISHED_GOOD"/>
                    <#if product?has_content>
                        <input type="hidden" name="isCreate" value="N"/>
                        <input type="hidden" name="productId" value="${productId}"/>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductProductId}</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" name="productId" size="15" maxlength="20" value="${productId}" disabled/>
                            </div>
                        </div>
                    <#else>
                        <input type="hidden" name="isCreate" value="Y"/>
                        <div class="form-group">
                            <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductProductId}</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" name="productId" size="15" maxlength="20"/>
                            </div>
                        </div>
                    </#if>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductProductName} *</label>
                        <div class="col-sm-6">
                            <input type="text" name="internalName" id="internalName" size="30" maxlength="60" value="${(product.internalName)?default(internalName!)}" class="required form-control"/><span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.CommonDescription}</label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" name="description" size="60" maxlength="250" value="${(product.description)?default(description!)}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="brandName" class="col-sm-3 control-label">${uiLabelMap.PFTProductbrandName}</label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" name="brandName" size="30" maxlength="250" value="${(product.brandName)?default(brandName!)}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductProductCategoryId} *</label>
                        <div class="col-sm-6">
                            <select name="productCategoryId" class="required form-control">
                                <#if productCategoryMember??>
                                    <option value="${productCategoryMember.productCategoryId}">${productCategoryMember.description!}</option>
                                    <option value="${productCategoryMember.productCategoryId}">---</option>
                                <#else>
                                    <option value=""></option>
                                    <option value="">---</option>
                                </#if>
                                <#list productCategoryList as productCategory>
                                    <option value="${productCategory.productCategoryId}">${productCategory.description}</option>
                                </#list>
                            </select><span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTPurchasePrice} *</label>
                        <div class="col-sm-6">
                            <input type="number" class="form-control required" step='any' placeholder='0.00' min="1" onkeyup="allowOnly2Numeric2Decimal(this)" name="price" id="price" size="8" value="${price?default('')}" class="required"/><span class="tooltip">${uiLabelMap.CommonRequired}</span>
                            <span id="advice-validate-number-defaultPrice" style="display:none;" class="errorMessage"> (${uiLabelMap.CommonPleaseEnterValidNumberInThisField})</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTSalePrice}</label>
                        <div class="col-sm-6">
                            <input type="hidden" id="salePrice" name="salePrice" value="${salePrice?default('')}"/>
                            <input type="number" class="form-control required" id="salePriceDisplay" name="salePriceDisplay" placeholder='0.00' value="${salePrice?default('')}" class="required" readonly="readonly"/><span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductProductWeight} *</label>
                        <div class="col-sm-6">
                            <input type="number" class="form-control required" step='any' placeholder='0.00' min="1" onkeyup="allowOnly2Numeric2Decimal(this)" name="productWeight" size="8" value="${(product.productWeight)?default(productWeight!)}" class="required form-control"/><span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.PFTUnitOfWeight} *</label>
                        <div class="col-sm-6">
                            <select name="weightUomId" class="required form-control">
                                <#if product?exists && product.weightUomId?exists>
                                    <#assign weightUom = EntityQuery.use(delegator).from("Uom").where("uomId", product.weightUomId).queryOne()!>
                                    <option value="${product.weightUomId!}">${weightUom.get("description",locale)!}</option>
                                    <option value="${product.weightUomId!}">---</option>
                                <#else>
                                    <option value=""></option>
                                    <option value="">---</option>
                                </#if>
                                <#assign weightUomList = EntityQuery.use(delegator).from("Uom").where("uomTypeId", "WEIGHT_MEASURE").orderBy("description").queryList()!>
                                <#list weightUomList as weightUom>
                                    <option value="${weightUom.uomId!}">${weightUom.get("description",locale)!}</option>
                                </#list>
                            </select><span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        </div>
                    </div>
                    <#-- small image -->
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductSmallImage}</label>
                        <div class="col-sm-6">
                            <div class="browserNotIE">
                                <div class="imageBlock">
                                <#if smallImage?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${smallImage.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${smallImage.contentId?if_exists}','remove')">Remove</a>
                                <#else>
                                    <div id="prev_upfile_small" class="uploaded-image" onclick="getFile('small')">
                                        <img id="imgAvatar_small" src="/pft-default/images/add.png">
                                    </div>
                                    <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                        <input class="file" id="upfile_small" type="file" onchange="showPreview(this,'small')" name="uploadedFile_small"/>
                                    </div>
                                    <a class="cancel hidden" id="cancel_small" onclick="cancelImage('small')">Cancel</a>
                                </#if>
                                </div>
                            </div>
                            <div class="browserIsIE">
                                <div class="imageBlock">
                                <#if smallImage?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${smallImage.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${smallImage.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_small" type="file" name="uploadedFile_small" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_small" onclick="cancelImage(small)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_small" type="file" name="uploadedFile_small" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_small" onclick="cancelImage(small)">Cancel</a>
                                </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <#-- medium image -->
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductMediumImage}</label>
                        <div class="col-sm-6">
                            <div class="browserNotIE">
                                <div class="imageBlock">
                                <#if mediumImage?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${mediumImage.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${mediumImage.contentId?if_exists}','remove')">Remove</a>
                                <#else>
                                    <div id="prev_upfile_medium" class="uploaded-image" onclick="getFile('medium')">
                                        <img id="imgAvatar_medium" src="/pft-default/images/add.png">
                                    </div>
                                    <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                        <input class="file" id="upfile_medium" type="file" onchange="showPreview(this,'medium')" name="uploadedFile_medium"/>
                                    </div>
                                    <a class="cancel hidden" id="cancel_medium" onclick="cancelImage('medium')">Cancel</a>
                                </#if>
                                </div>
                            </div>
                            <div class="browserIsIE">
                                <div class="imageBlock">
                                <#if mediumImage?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${mediumImage.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${mediumImage.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_medium" type="file" name="uploadedFile_medium" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_medium" onclick="cancelImage(medium)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_medium" type="file" name="uploadedFile_medium" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_medium" onclick="cancelImage(medium)">Cancel</a>
                                </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <#-- large image -->
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductLargeImage}</label>
                        <div class="col-sm-6">
                            <div class="browserNotIE">
                                <div class="imageBlock">
                                <#if largeImage?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${largeImage.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${largeImage.contentId?if_exists}','remove')">Remove</a>
                                <#else>
                                    <div id="prev_upfile_large" class="uploaded-image" onclick="getFile('large')">
                                        <img id="imgAvatar_large" src="/pft-default/images/add.png">
                                    </div>
                                    <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                        <input class="file" id="upfile_large" type="file" onchange="showPreview(this,'large')" name="uploadedFile_large"/>
                                    </div>
                                    <a class="cancel hidden" id="cancel_large" onclick="cancelImage('large')">Cancel</a>
                                </#if>
                                </div>
                            </div>
                            <div class="browserIsIE">
                                <div class="imageBlock">
                                <#if largeImage?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${largeImage.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${largeImage.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_large" type="file" name="uploadedFile_large" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_large" onclick="cancelImage(large)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_large" type="file" name="uploadedFile_large" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_large" onclick="cancelImage(large)">Cancel</a>
                                </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <#-- Additional image -->
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label">${uiLabelMap.ProductAddAdditionalImages}</label>
                        <div class="col-sm-6">
                            <div class="browserNotIE">
                                <div class="additionalImageList">
                                    <div class="imageBlock">
                                    <#if additionalImage1?has_content>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage1.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <a href="javascript:formImageSubmit('${additionalImage1.contentId?if_exists}','remove')">Remove</a>
                                    <#else>
                                        <div id="prev_upfile_additionalImage1" class="uploaded-image" onclick="getFile('additionalImage1')">
                                            <img id="imgAvatar_additionalImage1" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage1" type="file" onchange="showPreview(this,'additionalImage1')" name="uploadedFile_additionalImage1"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage1" onclick="cancelImage('additionalImage1')">Cancel</a>
                                    </#if>
                                    </div>
                                    <div class="imageBlock">
                                    <#if additionalImage2?has_content>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage2.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <a href="javascript:formImageSubmit('${additionalImage2.contentId?if_exists}','remove')">Remove</a>
                                    <#else>
                                        <div id="prev_upfile_additionalImage2" class="uploaded-image" onclick="getFile('additionalImage2')">
                                            <img id="imgAvatar_additionalImage2" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage2" type="file" onchange="showPreview(this,'additionalImage2')" name="uploadedFile_additionalImage2"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage2" onclick="cancelImage('additionalImage2')">Cancel</a>
                                    </#if>
                                    </div>
                                    <div class="imageBlock">
                                    <#if additionalImage3?has_content>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage3.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <a href="javascript:formImageSubmit('${additionalImage3.contentId?if_exists}','remove')">Remove</a>
                                    <#else>
                                        <div id="prev_upfile_additionalImage3" class="uploaded-image" onclick="getFile('additionalImage3')">
                                            <img id="imgAvatar_additionalImage3" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage3" type="file" onchange="showPreview(this,'additionalImage3')" name="uploadedFile_additionalImage3"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage3" onclick="cancelImage('additionalImage3')">Cancel</a>
                                    </#if>
                                    </div>
                                    <div class="imageBlock">
                                    <#if additionalImage4?has_content>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage4.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <a href="javascript:formImageSubmit('${additionalImage4.contentId?if_exists}','remove')">Remove</a>
                                    <#else>
                                        <div id="prev_upfile_additionalImage4" class="uploaded-image" onclick="getFile('additionalImage4')">
                                            <img id="imgAvatar_additionalImage4" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage4" type="file" onchange="showPreview(this,'additionalImage4')" name="uploadedFile_additionalImage4"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage4" onclick="cancelImage('additionalImage4')">Cancel</a>
                                    </#if>
                                    </div>
                                </div>
                            </div>
                            <div class="browserIsIE">
                                <div class="additionalImageList">
                                <#if additionalImage1Image?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${additionalImage1.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${additionalImage1.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_additionalImage1" type="file" name="uploadedFile_additionalImage1" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_additionalImage1" onclick="cancelImage(additionalImage1)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_additionalImage1" type="file" name="uploadedFile_additionalImage1" style="margin-right:8px;"/><br \>
                                    &nbsp;<a class="cancel hidden" id="cancel_additionalImage1" onclick="cancelImage(additionalImage1)">Cancel</a>
                                </#if>
                                <#if additionalImage2Image?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${additionalImage2.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${additionalImage2.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_additionalImage2" type="file" name="uploadedFile_additionalImage2" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_additionalImage2" onclick="cancelImage(additionalImage2)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_additionalImage2" type="file" name="uploadedFile_additionalImage2" style="margin-right:8px;"/><br \>
                                    &nbsp;<a class="cancel hidden" id="cancel_additionalImage2" onclick="cancelImage(additionalImage2)">Cancel</a>
                                </#if>
                                <#if additionalImage3Image?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${additionalImage3.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${additionalImage3.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_additionalImage3" type="file" name="uploadedFile_additionalImage3" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_additionalImage3" onclick="cancelImage(additionalImage3)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_additionalImage3" type="file" name="uploadedFile_additionalImage3" style="margin-right:8px;"/><br \>
                                    &nbsp;<a class="cancel hidden" id="cancel_additionalImage3" onclick="cancelImage(additionalImage3)">Cancel</a>
                                </#if>
                                <#if additionalImage4Image?has_content>
                                    <div class="uploaded-image">
                                        <img src="<@ofbizContentUrl>${additionalImage4.productImage}</@ofbizContentUrl>" width="82"/>
                                    </div>
                                    <a href="javascript:formImageSubmit('${additionalImage4.contentId?if_exists}','remove')">Remove</a>
                                    <input class="file" id="upfile_additionalImage4" type="file" name="uploadedFile_additionalImage4" style="margin-right:8px;"/><br \>
                                    <a class="cancel hidden" id="cancel_additionalImage4" onclick="cancelImage(additionalImage4)">Cancel</a>
                                <#else>
                                    <input class="file" id="upfile_additionalImage4" type="file" name="uploadedFile_additionalImage4" style="margin-right:8px;"/><br \>
                                    &nbsp;<a class="cancel hidden" id="cancel_additionalImage4" onclick="cancelImage(additionalImage4)">Cancel</a>
                                </#if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputFname" class="col-sm-3 control-label"></label>
                        <div class="col-sm-6">
                            <input type="submit" name="submit" id="submitButton" value="${uiLabelMap.CommonSubmit}" class="btn btn-main"/>
                            <input type="button" name="backButton" id="backButton" value="${uiLabelMap.CommonGoBack}" class="btn btn-main" onclick="javascript:location.href = '<@ofbizUrl>StoreManagement</@ofbizUrl>';"/>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<#if smallImage?has_content>
    <form name="removeProductImageForm" id="removeProductImage${smallImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${smallImage.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${smallImage.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${smallImage.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${smallImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${smallImage.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${smallImage.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${smallImage.productContentTypeId?if_exists}" />
    </form>
</#if>
<#if mediumImage?has_content>
    <form name="removeProductImageForm" id="removeProductImage${mediumImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${mediumImage.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${mediumImage.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${mediumImage.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${mediumImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${mediumImage.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${mediumImage.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${mediumImage.productContentTypeId?if_exists}" />
    </form>
</#if>
<#if largeImage?has_content>
    <form name="removeProductImageForm" id="removeProductImage${largeImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${largeImage.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${largeImage.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${largeImage.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${largeImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${largeImage.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${largeImage.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${largeImage.productContentTypeId?if_exists}" />
    </form>
</#if>
<#if additionalImage1?has_content>
    <form name="removeProductImageForm" id="removeProductImage${additionalImage1.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage1.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage1.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage1.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${additionalImage1.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage1.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage1.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage1.productContentTypeId?if_exists}" />
    </form>
</#if>
<#if additionalImage2?has_content>
    <form name="removeProductImageForm" id="removeProductImage${additionalImage2.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage2.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage2.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage2.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${additionalImage2.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage2.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage2.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage2.productContentTypeId?if_exists}" />
    </form>
</#if>
<#if additionalImage3?has_content>
    <form name="removeProductImageForm" id="removeProductImage${additionalImage3.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage3.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage3.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage3.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${additionalImage3.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage3.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage3.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage3.productContentTypeId?if_exists}" />
    </form>
</#if>
<#if additionalImage4?has_content>
    <form name="removeProductImageForm" id="removeProductImage${additionalImage4.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage4.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage4.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage4.productContentTypeId?if_exists}" />
    </form>
    <form name="removeProductImageForm" id="removeProductImage_${additionalImage4.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
        <input type="hidden" name="productId" value="${productId?if_exists}" />
        <input type="hidden" name="contentId" value="${additionalImage4.contentId?if_exists}" />
        <input type="hidden" name="fromDate" value="${additionalImage4.fromDate?if_exists}" />
        <input type="hidden" name="productContentTypeId" value="${additionalImage4.productContentTypeId?if_exists}" />
    </form>
</#if>