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
    function getFile(inputIndex) {
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
        if($('.uploaded').length == $('.file').length){
        var nextIndex = index+1;
        $("ul.uploading").append(
            "<li id='li-"+nextIndex+"'>"
                +"<div id='prev_upfile_"+nextIndex+"' class='uploaded-image' onclick='getFile("+nextIndex+")'>"
                    +"<img id='imgAvatar_"+nextIndex+"' src='/pft-default/images/add.png'>"
                +"</div>"
                +"<div style='height: 0px;width:0px; overflow:hidden; border:0;'>"
                    +"<input class='file' id='upfile_"+nextIndex+"' type='file' onchange='showPreview(this,"+nextIndex+")' name='uploadedFile_"+nextIndex+"'>"
                +"</div>"
                +"<a class='cancel hidden' id='cancel_"+nextIndex+"' onclick='cancelImage("+nextIndex+")'>Cancel</a>"
            +"</li>");
        }
    }
    function addNewInput(index) {
        var nextIndex = index+1;
        $('#cancel_'+index).removeClass('hidden');
        $("ul.uploading").append(
            "<li id='li-"+nextIndex+"'>"
                +"<input class='file' id='upfile_"+nextIndex+"' type='file' name='uploadedFile_"+nextIndex+"' style='margin-right:8px;' onclick='addNewInput("+nextIndex+")'/><br \>"
                +"<a class='cancel hidden' id='cancel_"+nextIndex+"' onclick='cancelImage("+nextIndex+")'>Cancel</a>"
            +"</li>");
    }
    function cancelImage(index) {
        $('#li-'+index).remove();
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
                <tr>
                    <td class="label">
                        <span id="EditProduct_uploadImages_title">${uiLabelMap.CommonUpload}</span>
                    </td>
                    <td>
                        <ul class="uploading">
                            <#if productImageList?has_content>
                                <#assign nextIndext = productImageList.size()+1/>
                                <#list productImageList as productImage>
                                    <li>
                                        <div class="uploaded-image">
                                            <img src="<@ofbizContentUrl>${productImage.productImageThumb}</@ofbizContentUrl>" width="82"/>
                                        </div>
                                        <form name="removeProductImageForm" id="removeProductImage${productImage.contentId?if_exists}" method="post" action="<@ofbizUrl>removeProductImage</@ofbizUrl>">
                                            <input type="hidden" name="productId" value="${productId?if_exists}" />
                                            <input type="hidden" name="contentId" value="${productImage.contentId?if_exists}" />
                                            <input type="hidden" name="fromDate" value="${productImage.fromDate?if_exists}" />
                                            <input type="hidden" name="productContentTypeId" value="${productImage.productContentTypeId?if_exists}" />
                                        </form>
                                        <a href="javascript:formImageSubmit('${productImage.contentId?if_exists}','remove')">Remove</a>
                                    </li>
                                </#list>
                                <li id="li-${nextIndext}">
                                    <div id="prev_upfile_${nextIndext}" class="uploaded-image" onclick="getFile(${nextIndext})">
                                        <img id="imgAvatar_${nextIndext}" src="/pft-default/images/add.png">
                                    </div>
                                    <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                        <input class="file" id="upfile_${nextIndext}" type="file" onchange="showPreview(this,${nextIndext})" name="uploadedFile_${nextIndext}"/>
                                    </div>
                                    <a class="cancel hidden" id="cancel_${nextIndext}" onclick="cancelImage(${nextIndext})">Cancel</a>
                                </li>
                            <#else>
                                <li id="li-1">
                                    <div id="prev_upfile_1" class="uploaded-image" onclick="getFile(1)">
                                        <img id="imgAvatar_1" src="/pft-default/images/add.png"/>
                                    </div>
                                    <div style='height: 0px;width:0px; overflow:hidden; border:0;'>
                                        <input class="file" id="upfile_1" type="file" onchange="showPreview(this,1)" name="uploadedFile_1
                                        "/>
                                    </div>
                                    <a class="cancel hidden" id="cancel_1" onclick="cancelImage(1)">Cancel</a>
                                </li>
                            </#if>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td><a href="<@ofbizUrl>StoreManagement</@ofbizUrl>" class="smallSubmit">${uiLabelMap.CommonGoBack}</a></td>
                    <td><input type="submit" name="submit" id="submitButton" value="${uiLabelMap.CommonSubmit}" class="buttontext"/></td>
                </tr>
            </table>
        </form>
    </div>
</div>
