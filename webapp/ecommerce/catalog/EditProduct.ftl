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
    });
</script>
<div class="screenlet">
    <div class="screenlet-title-bar">
        <ul>
          <li class="h3"><#if product?exists>${uiLabelMap.PageTitleEditProduct}<#else>${uiLabelMap.ProductCreateProduct}</#if> <#if productCategory?exists>${uiLabelMap.CommonIn} <#if (productCategory.categoryName)?has_content>"${productCategory.categoryName}"</#if> [${uiLabelMap.CommonId}:${productCategory.productCategoryId?if_exists}]</#if></li>
        </ul>
        <br class="clear"/>
    </div>
    <div class="screenlet-body">
        <form method="post" onsubmit="return validateProductId()" enctype="multipart/form-data" action="<#if product?exists><@ofbizUrl>updateProduct</@ofbizUrl><#else><@ofbizUrl>createProduct</@ofbizUrl></#if>" name="EditProductForm" id="EditProductForm">
            <table cellspacing="0" class="basic-table" width="100%">
                <input type="hidden" name="currencyUomId" value="${currencyUomId}"/>
                <input type="hidden" name="productTypeId" value="FINISHED_GOOD"/>
                <tr>
                    <td class="label">${uiLabelMap.ProductProductId}</td>
                    <td>
                        <#if product?has_content>
                            <input type="hidden" name="isCreate" value="N"/>
                            <input type="hidden" name="productId" value="${productId}"/>
                            ${productId} <span class="tooltip">(${uiLabelMap.ProductNotModificationRecreatingProduct}.)</span>
                        <#else>
                            <input type="hidden" name="isCreate" value="Y"/>
                            <input type="text" name="productId" size="15" maxlength="20" id="productId"/>
                        </#if>
                    </td>
                </tr>
                <tr>
                    <td class="label">${uiLabelMap.ProductProductName}</td>
                    <td>
                        <input type="text" name="internalName" id="internalName" size="30" maxlength="60" value="${(product.internalName)?default(internalName!)}" class="required"/>*<span class="tooltip">${uiLabelMap.CommonRequired}</span>
                    </td>
                </tr>
                <tr>
                    <td class="label">${uiLabelMap.CommonDescription}</td>
                    <td><input type="text" name="description" size="60" maxlength="250" value="${(product.description)?default(description!)}"/></td>
                </tr>
                <tr>
                    <td class="label">${uiLabelMap.ProductProductCategoryId}</td>
                    <form>
                        <td>
                            <select name="productCategoryId" class="required">
                                <#if productCategoryMember??>
                                    <option value="${productCategoryMember.productCategoryId}">${productCategoryMember.description}</option>
                                    <option value="${productCategoryMember.productCategoryId}">---</option>
                                <#else>
                                    <option value=""></option>
                                    <option value="">---</option>
                                </#if>
                                <#list productCategoryList as productCategory>
                                    <option value="${productCategory.productCategoryId}">${productCategory.description}</option>
                                </#list>
                            </select>*<span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        </td>
                    </form>
                </tr>
                <tr>
                    <td class="label">${uiLabelMap.ProductPrice}</td>
                    <td>
                        <input type="number" step='any' placeholder='0.00' min="1" nkeyup="allowOnly2Numeric2Decimal(this)" name="price" id="price" size="8" value="${price?default('')}" class="required"/>*<span class="tooltip">${uiLabelMap.CommonRequired}</span>
                        <span id="advice-validate-number-defaultPrice" style="display:none;" class="errorMessage"> (${uiLabelMap.CommonPleaseEnterValidNumberInThisField}) </span>
                    </td>
                </tr>
                <#-- small image -->
                <tr>
                    <td class="label">
                        <span id="EditProduct_uploadImages_title">${uiLabelMap.ProductSmallImage}</span>
                    </td>
                    <td>
                        <div class="browserNotIE">
                            <ul class="uploading">
                                <#if smallImage?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${smallImage.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${smallImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${smallImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${smallImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${smallImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${smallImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-small">
                                        <div id="prev_upfile_small" class="uploaded-image" onclick="getFile('small')">
                                            <img id="imgAvatar_small" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_small" type="file" onchange="showPreview(this,'small')" name="uploadedFile_small"/>
                                        </div>
                                        <a class="cancel hidden" id="cancel_small" onclick="cancelImage('small')">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                        <div class="browserIsIE">
                            <ul class="uploading">
                                <#if smallImage?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${smallImage.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${smallImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${smallImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${smallImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${smallImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${smallImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-small">
                                        <input class="file" id="upfile_small" type="file" name="uploadedFile_small" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_small" onclick="cancelImage(small)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-small">
                                        <input class="file" id="upfile_small" type="file" name="uploadedFile_small" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_small" onclick="cancelImage(small)">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                    </td>
                </tr>
                <#-- medium image -->
                <tr>
                    <td class="label">
                        <span id="EditProduct_uploadImages_title">${uiLabelMap.ProductMediumImage}</span>
                    </td>
                    <td>
                        <div class="browserNotIE">
                            <ul class="uploading">
                                <#if mediumImage?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${mediumImage.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${mediumImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${mediumImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${mediumImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${mediumImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${mediumImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-medium">
                                        <div id="prev_upfile_medium" class="uploaded-image" onclick="getFile('medium')">
                                            <img id="imgAvatar_medium" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_medium" type="file" onchange="showPreview(this,'medium')" name="uploadedFile_medium"/>
                                        </div>
                                        <a class="cancel hidden" id="cancel_medium" onclick="cancelImage('medium')">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                        <div class="browserIsIE">
                            <ul class="uploading">
                                <#if mediumImage?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${mediumImage.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${mediumImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${mediumImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${mediumImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${mediumImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${mediumImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-medium">
                                        <input class="file" id="upfile_medium" type="file" name="uploadedFile_medium" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_medium" onclick="cancelImage(medium)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-medium">
                                        <input class="file" id="upfile_medium" type="file" name="uploadedFile_medium" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_medium" onclick="cancelImage(medium)">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                    </td>
                </tr>
                <#-- large image -->
                <tr>
                    <td class="label">
                        <span id="EditProduct_uploadImages_title">${uiLabelMap.ProductLargeImage}</span>
                    </td>
                    <td>
                        <div class="browserNotIE">
                            <ul class="uploading">
                                <#if largeImage?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${largeImage.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${largeImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${largeImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${largeImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${largeImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${largeImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-large">
                                        <div id="prev_upfile_large" class="uploaded-image" onclick="getFile('large')">
                                            <img id="imgAvatar_large" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_large" type="file" onchange="showPreview(this,'large')" name="uploadedFile_large"/>
                                        </div>
                                        <a class="cancel hidden" id="cancel_large" onclick="cancelImage('large')">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                        <div class="browserIsIE">
                            <ul class="uploading">
                                <#if largeImage?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${largeImage.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${largeImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${largeImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${largeImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${largeImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${largeImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-large">
                                        <input class="file" id="upfile_large" type="file" name="uploadedFile_large" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_large" onclick="cancelImage(large)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-large">
                                        <input class="file" id="upfile_large" type="file" name="uploadedFile_large" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_large" onclick="cancelImage(large)">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                    </td>
                </tr>
                <#-- Additional image -->
                <tr>
                    <td class="label">
                        <span id="EditProduct_uploadImages_title">${uiLabelMap.ProductAddAdditionalImages}</span>
                    </td>
                    <td>
                        <div class="browserNotIE">
                            <ul class="uploading">
                                <#if additionalImage1?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage1.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${additionalImage1.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage1.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage1.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage1.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage1.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage1">
                                        <div id="prev_upfile_additionalImage1" class="uploaded-image" onclick="getFile('additionalImage1')">
                                            <img id="imgAvatar_additionalImage1" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage1" type="file" onchange="showPreview(this,'additionalImage1')" name="uploadedFile_additionalImage1"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage1" onclick="cancelImage('additionalImage1')">Cancel</a>
                                    </li>
                                </#if>
                                <#if additionalImage2?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage2.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${additionalImage2.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage2.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage2.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage2.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage2.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage2">
                                        <div id="prev_upfile_additionalImage2" class="uploaded-image" onclick="getFile('additionalImage2')">
                                            <img id="imgAvatar_additionalImage2" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage2" type="file" onchange="showPreview(this,'additionalImage2')" name="uploadedFile_additionalImage2"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage2" onclick="cancelImage('additionalImage2')">Cancel</a>
                                    </li>
                                </#if>
                                <#if additionalImage3?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage3.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${additionalImage3.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage3.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage3.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage3.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage3.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage3">
                                        <div id="prev_upfile_additionalImage3" class="uploaded-image" onclick="getFile('additionalImage3')">
                                            <img id="imgAvatar_additionalImage3" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage3" type="file" onchange="showPreview(this,'additionalImage3')" name="uploadedFile_additionalImage3"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage3" onclick="cancelImage('additionalImage3')">Cancel</a>
                                    </li>
                                </#if>
                                <#if additionalImage4?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage4.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${additionalImage4.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage4.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage4.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage4.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage4.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage4">
                                        <div id="prev_upfile_additionalImage4" class="uploaded-image" onclick="getFile('additionalImage4')">
                                            <img id="imgAvatar_additionalImage4" src="/pft-default/images/add.png">
                                        </div>
                                        <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                            <input class="file" id="upfile_additionalImage4" type="file" onchange="showPreview(this,'additionalImage4')" name="uploadedFile_additionalImage4"/>
                                        </div>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage4" onclick="cancelImage('additionalImage4')">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                        <div class="browserIsIE">
                            <ul class="uploading">
                                <#if additionalImage1Image?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage1.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${additionalImage1.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage1.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage1.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage1.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage1.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-additionalImage1">
                                        <input class="file" id="upfile_additionalImage1" type="file" name="uploadedFile_additionalImage1" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_additionalImage1" onclick="cancelImage(additionalImage1)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage1">
                                        <input class="file" id="upfile_additionalImage1" type="file" name="uploadedFile_additionalImage1" style="margin-right:8px;"/><br \>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage1" onclick="cancelImage(additionalImage1)">Cancel</a>
                                    </li>
                                </#if>
                                <#if additionalImage2Image?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage2.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${additionalImage2.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage2.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage2.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage2.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage2.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-additionalImage2">
                                        <input class="file" id="upfile_additionalImage2" type="file" name="uploadedFile_additionalImage2" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_additionalImage2" onclick="cancelImage(additionalImage2)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage2">
                                        <input class="file" id="upfile_additionalImage2" type="file" name="uploadedFile_additionalImage2" style="margin-right:8px;"/><br \>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage2" onclick="cancelImage(additionalImage2)">Cancel</a>
                                    </li>
                                </#if>
                                <#if additionalImage3Image?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage3.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${additionalImage3.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage3.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage3.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage3.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage3.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-additionalImage3">
                                        <input class="file" id="upfile_additionalImage3" type="file" name="uploadedFile_additionalImage3" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_additionalImage3" onclick="cancelImage(additionalImage3)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage3">
                                        <input class="file" id="upfile_additionalImage3" type="file" name="uploadedFile_additionalImage3" style="margin-right:8px;"/><br \>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage3" onclick="cancelImage(additionalImage3)">Cancel</a>
                                    </li>
                                </#if>
                                <#if additionalImage4Image?has_content>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${additionalImage4.productImage}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage_${additionalImage4.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${additionalImage4.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${additionalImage4.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${additionalImage4.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${additionalImage4.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                    <li id="li-additionalImage4">
                                        <input class="file" id="upfile_additionalImage4" type="file" name="uploadedFile_additionalImage4" style="margin-right:8px;"/><br \>
                                        <a class="cancel hidden" id="cancel_additionalImage4" onclick="cancelImage(additionalImage4)">Cancel</a>
                                    </li>
                                <#else>
                                    <li id="li-additionalImage4">
                                        <input class="file" id="upfile_additionalImage4" type="file" name="uploadedFile_additionalImage4" style="margin-right:8px;"/><br \>
                                        &nbsp;<a class="cancel hidden" id="cancel_additionalImage4" onclick="cancelImage(additionalImage4)">Cancel</a>
                                    </li>
                                </#if>
                            </ul>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td></td>
                    <td>
                        <input type="submit" name="submit" id="submitButton" value="${uiLabelMap.CommonSubmit}" class="buttontext"/>
                        <a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="smallSubmit" style="padding: 4px;">${uiLabelMap.CommonGoBack}</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
