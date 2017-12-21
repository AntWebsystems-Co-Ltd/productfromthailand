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
<#-- variable setup -->
<#assign price = priceMap! />
<#assign productImageList = productImageList! />
<#-- end variable setup -->

<#-- virtual product javascript -->
${virtualJavaScript!}
${virtualVariantJavaScript!}
<script type="text/javascript">
//<![CDATA[
    var detailImageUrl = null;
    function setAddProductId(name) {
        document.addform.add_product_id.value = name;
        if (document.addform.quantity == null) return;
        if (name == '' || name == 'NULL' || isVirtual(name) == true) {
            document.addform.quantity.disabled = true;
            document.addform.addCartBtn.disabled = true;
            var elem = document.getElementById('product_id_display');
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        } else {
            document.addform.quantity.disabled = false;
            document.addform.addCartBtn.disabled = false;
            var elem = document.getElementById('product_id_display');
            var txt = document.createTextNode(name);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function setVariantPrice(sku) {
        if (sku == '' || sku == 'NULL' || isVirtual(sku) == true) {
            var elem = document.getElementById('variant_price_display');
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
        else {
            var elem = document.getElementById('variant_price_display');
            var price = getVariantPrice(sku);
            var txt = document.createTextNode(price);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function setVariantName(sku, vname) {
        if (vname == '' || vname == 'NULL' || isVirtual(sku) == true) {
            var elem = document.getElementById('variant_name_display');
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
        else {
            var elem = document.getElementById('variant_name_display');
            var txt = document.createTextNode(vname);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function setVariantType(sku, vtype) {
        if (vtype == '' || vtype == 'NULL' || isVirtual(sku) == true) {
            var elem = document.getElementById('variant_type_display');
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
        else {
            var elem = document.getElementById('variant_type_display');
            var txt = document.createTextNode(unescape(vtype));
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function isVirtual(product) {
        var isVirtual = false;
        <#if virtualJavaScript??>
        for (i = 0; i < VIR.length; i++) {
            if (VIR[i] == product) {
                isVirtual = true;
            }
        }
        </#if>
        return isVirtual;
    }
    function addItem() {
       if (document.addform.add_product_id.value == 'NULL') {
           showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonPleaseSelectAllRequiredOptions}");
           return;
       } else {
           if (isVirtual(document.addform.add_product_id.value)) {
               document.location = '<@ofbizUrl>product?category_id=${categoryId!}&amp;product_id=</@ofbizUrl>' + document.addform.add_product_id.value;
               return;
           } else {
               prodId = document.addform.add_product_id.value;
               $.ajax({
                   url: document.addform.action,
                   type: 'POST',
                   data: $(document.addform).serialize(),
                   async: false,
                   success: function(data) {
                       $('#addCartModal_'+prodId).modal('toggle');
                       $('#addCartModal_'+prodId).modal('show');
                       $('#addCartModal_'+prodId).modal({backdrop: 'static', keyboard: false})
                       $('#addCartModal_'+prodId+' #qtyDisplay').text(document.addform.quantity.value);
                   }
               });
           }
       }
    }

    function popupDetail(specificDetailImageUrl) {
        if( specificDetailImageUrl ) {
            detailImageUrl = specificDetailImageUrl;
        }
        else {
            var defaultDetailImage = "${firstDetailImage?default(mainDetailImageUrl?default("_NONE_"))}";
            if (defaultDetailImage == null || defaultDetailImage == "null" || defaultDetailImage == "") {
               defaultDetailImage = "_NONE_";
            }

            if (detailImageUrl == null || detailImageUrl == "null") {
                detailImageUrl = defaultDetailImage;
            }
        }

        if (detailImageUrl == "_NONE_") {
            hack = document.createElement('span');
            hack.innerHTML="${uiLabelMap.CommonNoDetailImageAvailableToDisplay}";
            showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonNoDetailImageAvailableToDisplay}");
            return;
        }
        detailImageUrl = detailImageUrl.replace(/\&\#47;/g, "/");
        popUp("<@ofbizUrl>detailImage?detail=" + detailImageUrl + "</@ofbizUrl>", 'detailImage', '600', '600');
    }

    function toggleAmt(toggle) {
        if (toggle == 'Y') {
            changeObjectVisibility("add_amount", "visible");
        }

        if (toggle == 'N') {
            changeObjectVisibility("add_amount", "hidden");
        }
    }

    function findIndex(name) {
        for (i = 0; i < OPT.length; i++) {
            if (OPT[i] == name) {
                return i;
            }
        }
        return -1;
    }

    function getList(name, index, src, img, vname, vtype) {
        currentFeatureIndex = findIndex(name);

        if (currentFeatureIndex == 0) {
            // set the images for the first selection
            if (IMG[index] != null && IMG[index]!="") {
                if (document.images['mainImage'] != null) {
                    var imgString = IMG[index];
                    imgString = imgString.replace(/%2F/g, "/");
                    document.images['mainImage'].src = imgString;
                    detailImageUrl = DET[index];
                }
            }

            // set the drop down index for swatch selection
            document.forms["addform"].elements[name].selectedIndex = (index*1)+1;
        }

        if (currentFeatureIndex < (OPT.length-1)) {
            // eval the next list if there are more
            var selectedValue = document.forms["addform"].elements[name].options[(index*1)+1].value;
            if (index == -1) {
              <#if featureOrderFirst??>
                var Variable1 = eval("list" + "${featureOrderFirst}" + "()");
              </#if>
            } else {
                var Variable1 = eval("list" + OPT[(currentFeatureIndex+1)] + selectedValue + "()");
            }
            // set the product ID to NULL to trigger the alerts
            setAddProductId('NULL');

            // set the variant price to NULL
            setVariantPrice('NULL');

            setVariantName('NULL', 'NULL');
            setVariantType('NULL', 'NULL');
        } else {
            // this is the final selection -- locate the selected index of the last selection
            var indexSelected = document.forms["addform"].elements[name].selectedIndex;

            // using the selected index locate the sku
            var sku = document.forms["addform"].elements[name].options[indexSelected].value;

            // display alternative packaging dropdown
            ajaxUpdateArea("product_uom", "<@ofbizUrl>ProductUomDropDownOnly</@ofbizUrl>", "productId=" + sku);

            // set the product ID
            setAddProductId(sku);

            // set the variant price
            setVariantPrice(sku);
            // set the variant name
            if (vname != "") {
                setVariantName(sku, vname);
            }
            if (vtype != "") {
                setVariantType(sku, vtype);
            }

            // check for amount box
            toggleAmt(checkAmtReq(sku));
        }

        if (img != "") {
            changeToVariantImg(img);
        }
    }

    function validate(x){
        var msg=new Array();
        msg[0]="Please use correct date format [yyyy-mm-dd]";

        var y=x.split("-");
        if(y.length!=3){ showAlert(msg[0]);return false; }
        if((y[2].length>2)||(parseInt(y[2])>31)) { showAlert(msg[0]); return false; }
        if(y[2].length==1){ y[2]="0"+y[2]; }
        if((y[1].length>2)||(parseInt(y[1])>12)){ showAlert(msg[0]); return false; }
        if(y[1].length==1){ y[1]="0"+y[1]; }
        if(y[0].length>4){ showAlert(msg[0]); return false; }
        if(y[0].length<4) {
            if(y[0].length==2) {
                y[0]="20"+y[0];
            } else {
                showAlert(msg[0]);
                return false;
            }
        }
        return (y[0]+"-"+y[1]+"-"+y[2]);
    }

    function showAlert(msg){
        showErrorAlert("${uiLabelMap.CommonErrorMessage2}", msg);
    }

    function additemSubmit(){
        <#if product.productTypeId! == "ASSET_USAGE" || product.productTypeId! == "ASSET_USAGE_OUT_IN">
        newdatevalue = validate(document.addform.reservStart.value);
        if (newdatevalue == false) {
            document.addform.reservStart.focus();
        } else {
            document.addform.reservStart.value = newdatevalue;
            document.addform.submit();
        }
        <#else>
        document.addform.submit();
        </#if>
    }

    function addShoplistSubmit(){
        <#if product.productTypeId! == "ASSET_USAGE" || product.productTypeId! == "ASSET_USAGE_OUT_IN">
        if (document.addToShoppingList.reservStartStr.value == "") {
            document.addToShoppingList.submit();
        } else {
            newdatevalue = validate(document.addToShoppingList.reservStartStr.value);
            if (newdatevalue == false) {
                document.addToShoppingList.reservStartStr.focus();
            } else {
                document.addToShoppingList.reservStartStr.value = newdatevalue;
                // document.addToShoppingList.reservStart.value = ;
                document.addToShoppingList.reservStartStr.value.slice(0,9)+" 00:00:00.000000000";
                document.addToShoppingList.submit();
            }
        }
        <#else>
        document.addToShoppingList.submit();
        </#if>
    }

    <#if product.virtualVariantMethodEnum! == "VV_FEATURETREE" && featureLists?has_content>
        function checkRadioButton() {
            var block1 = document.getElementById("addCart1");
            var block2 = document.getElementById("addCart2");
            <#list featureLists as featureList>
                <#list featureList as feature>
                    <#if feature_index == 0>
                        var myList = document.getElementById("FT${feature.productFeatureTypeId}");
                         if (myList.options[0].selected == true){
                             block1.style.display = "none";
                             block2.style.display = "block";
                             return;
                         }
                        <#break>
                    </#if>
                </#list>
            </#list>
            block1.style.display = "block";
            block2.style.display = "none";
        }
    </#if>

    function displayProductVirtualVariantId(variantId) {
        if(variantId){
            document.addform.product_id.value = variantId;
        }else{
            document.addform.product_id.value = '';
            variantId = '';
        }

        var elem = document.getElementById('product_id_display');
        var txt = document.createTextNode(variantId);
        if(elem.hasChildNodes()) {
            elem.replaceChild(txt, elem.firstChild);
        } else {
            elem.appendChild(txt);
        }

        var priceElem = document.getElementById('variant_price_display');
        var price = getVariantPrice(variantId);
        var priceTxt = null;
        if(price){
            priceTxt = document.createTextNode(price);
        }else{
            priceTxt = document.createTextNode('');
        }
        if(priceElem.hasChildNodes()) {
            priceElem.replaceChild(priceTxt, priceElem.firstChild);
        } else {
            priceElem.appendChild(priceTxt);
        }
    }

    function changeToVariantImg(img) {
        $("#mainImageLink").remove()
        $("#mainImage").remove()
        $("#images-block").prepend('<a href="' + img + '" id="mainImageLink"></a>')
        $("#mainImageLink").prepend('<img src="'+img+'" alt="Image" class="img-responsive thumbnail" id="mainImage"/>')
    }
//]]>
$(function(){
    $('a[id^=productTag_]').click(function(){
        var id = $(this).attr('id');
        var ids = id.split('_');
        var productTagStr = ids[1];
        if (productTagStr) {
            $('#productTagStr').val(productTagStr);
            $('#productTagsearchform').submit();
        }
    });

    $("#addVarientBtn").click(function() {
        var vId = $("input[name='add_product_id']").val();
        if (vId == "NULL") {
            alert("${StringUtil.wrapString(uiLabelMap.PFTPleaseSelectOption)}")
        }
    })
})
$(function(){
  // TABS
  $('.nav-tabs a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
})
</script>

<#macro showUnavailableVarients>
  <#if unavailableVariants??>
    <ul>
      <#list unavailableVariants as prod>
        <#assign features = prod.getRelated("ProductFeatureAppl", null, null, false)/>
        <li>
          <#list features as feature>
            <em>${feature.getRelatedOne("ProductFeature", false).description}</em><#if feature_has_next>, </#if>
          </#list>
          <span>${uiLabelMap.ProductItemOutOfStock}</span>
        </li>
      </#list>
    </ul>
  </#if>
</#macro>

<#-- variable setup -->
<#if backendPath?default("N") == "Y">
    <#assign productUrl><@ofbizCatalogUrl productId=product.productId productCategoryId=categoryId/></#assign>
<#else>
    <#assign productUrl><@ofbizCatalogAltUrl productId=product.productId productCategoryId=categoryId/></#assign>
</#if>

<div id="main-container" class="container">
  <ol class="breadcrumb">
    ${screens.render(breadcrumbs)}
  </ol>
  <#assign productAdditionalImage1 = productContentWrapper.get("XTRA_IMG_1_SMALL", "url")! />
  <#assign productAdditionalImage2 = productContentWrapper.get("XTRA_IMG_2_SMALL", "url")! />
  <#assign productAdditionalImage3 = productContentWrapper.get("XTRA_IMG_3_SMALL", "url")! />
  <#assign productAdditionalImage4 = productContentWrapper.get("XTRA_IMG_4_SMALL", "url")! />
  <#assign productAdditionalImageLarge1 = productContentWrapper.get("ADDITIONAL_IMAGE_1", "url")! />
  <#assign productAdditionalImageLarge2 = productContentWrapper.get("ADDITIONAL_IMAGE_2", "url")! />
  <#assign productAdditionalImageLarge3 = productContentWrapper.get("ADDITIONAL_IMAGE_3", "url")! />
  <#assign productAdditionalImageLarge4 = productContentWrapper.get("ADDITIONAL_IMAGE_4", "url")! />

  <#-- Category next/previous -->
  <#if category??>
    <div id="paginationBox">
      <#if previousProductId??>
        <a href="<@ofbizCatalogAltUrl productCategoryId=categoryId! productId=previousProductId!/>"
            class="buttontext">${uiLabelMap.CommonPrevious}</a>&nbsp;|&nbsp;
      </#if>
      <a href="<@ofbizCatalogAltUrl productCategoryId=categoryId!/>"
          class="linktext">${(category.categoryName)?default(category.description)!}</a>
      <#if nextProductId??>&nbsp;|&nbsp;
        <a href="<@ofbizCatalogAltUrl productCategoryId=categoryId! productId=nextProductId!/>"
            class="buttontext">${uiLabelMap.CommonNext}</a>
      </#if>
    </div>
  </#if>

  <div class="row product-info full">
    <div class="col-sm-4 images-block" id="images-block">
        <#assign productLargeImageUrl = productContentWrapper.get("LARGE_IMAGE_URL", "url")! />
        <#-- <#if firstLargeImage?has_content>
            <#assign productLargeImageUrl = firstLargeImage />
        </#if> -->
        <#if productLargeImageUrl?string?has_content>
            <a href="<@ofbizContentUrl>${contentPathPrefix!}${productLargeImageUrl!}</@ofbizContentUrl>" id="mainImageLink">
                <img src="<@ofbizContentUrl>${contentPathPrefix!}${productLargeImageUrl!}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail" id="mainImage"/>
            </a>
        </#if>
        <#if !productLargeImageUrl?string?has_content>
            <#assign productLargeImageUrl = "/pft-default/images/defaultImage.jpg">
            <img src="/pft-default/images/defaultImage.jpg" alt="Image" class="img-responsive thumbnail" id="mainImage"/>
        </#if>
        <ul class="list-unstyled list-inline">
            <#if productAdditionalImage1?string?has_content>
            <li>
                <a href="<@ofbizContentUrl>${productAdditionalImageLarge1}</@ofbizContentUrl>">
                    <img src="<@ofbizContentUrl>${productAdditionalImage1}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail" />
                </a>
            </li>
            </#if>
            <#if productAdditionalImage2?string?has_content>
            <li>
                <a href="<@ofbizContentUrl>${productAdditionalImageLarge2}</@ofbizContentUrl>">
                    <img src="<@ofbizContentUrl>${productAdditionalImage2}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail" />
                </a>
            </li>
            </#if>
            <#if productAdditionalImage3?string?has_content>
            <li>
                <a href="<@ofbizContentUrl>${productAdditionalImageLarge3}</@ofbizContentUrl>">
                    <img src="<@ofbizContentUrl>${productAdditionalImage3}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail" />
                </a>
            </li>
            </#if>
            <#if productAdditionalImage4?string?has_content>
            <li>
                <a href="<@ofbizContentUrl>${productAdditionalImageLarge4}</@ofbizContentUrl>">
                    <img src="<@ofbizContentUrl>${productAdditionalImage4}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail" />
                </a>
            </li>
            </#if>
        </ul>
      </div>

    <div class="col-sm-8 product-details">
    <div class="panel-smart">
    <div id="productDetailBox">
      <h2>${productContentWrapper.get("PRODUCT_NAME", "html")!}</h2>
      <hr/>
      <ul class="list-unstyled manufacturer">
        <li>
            <span>${uiLabelMap.PFTBrand} :</span> ${product.brandName!}
        </li>
        <#if product.virtualVariantMethodEnum! != "VV_FEATURETREE">
            <#if productStore??>
                <#if productStore.requireInventory?? && productStore.requireInventory == "N">
                <#else>
                    <li>
                        <span>${uiLabelMap.ProductAvailable}:</span> <strong class="label label-danger">${uiLabelMap.ProductItemOutOfStock}</strong>
                    </li>
                </#if>
            </#if>
        </#if>
      </ul>
      <hr/>
      <div class="price">
        <span class="price-head">${uiLabelMap.OrderPrice} :</span>
        <#if price.isSale?? && price.isSale>
            <span class="price-new"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed /></span>
            <span class="price-old"><@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed /></span>
        <#else>
            <span class="price-new"><@ofbizCurrency amount=price.price isoCode=price.currencyUsed /></span>
        </#if>
      </div>
      <hr/>

      <#-- <ul>
        <li>
            ${productContentWrapper.get("DESCRIPTION", "html")!}
        </li>
        <li>
            ${product.productId!}
        </li> -->
      <#-- example of showing a certain type of feature with the product -->
      <#-- <#if sizeProductFeatureAndAppls?has_content>
        <li>
          <#if (sizeProductFeatureAndAppls?size == 1)>
          <span>${uiLabelMap.OrderSizeAvailableSingle}:</span>
          <#else>
          <span>${uiLabelMap.OrderSizeAvailableMultiple}:</span>
          </#if>
          <#list sizeProductFeatureAndAppls as sizeProductFeatureAndAppl>
            ${sizeProductFeatureAndAppl.description?default(
                sizeProductFeatureAndAppl.abbrev?default(sizeProductFeatureAndAppl.productFeatureId))}
            <#if sizeProductFeatureAndAppl_has_next>,</#if>
          </#list>
        </li>
      </#if>
      </ul> -->

      <#-- for prices:
              - if price < competitivePrice, show competitive or "Compare At" price
              - if price < listPrice, show list price
              - if price < defaultPrice and defaultPrice < listPrice, show default
              - if isSale show price with salePrice style and print "On Sale!"
      -->
      <#-- <#if price.competitivePrice?? && price.price?? && price.price &lt; price.competitivePrice>
        <li><span>${uiLabelMap.ProductCompareAtPrice}:</span>
          <span class="basePrice">
            <@ofbizCurrency amount=price.competitivePrice isoCode=price.currencyUsed />
          </span>
        </li>
      </#if>
      <#if price.listPrice?? && price.price?? && price.price &lt; price.listPrice>
        <li><span>${uiLabelMap.ProductListPrice}:</span>
          <span class="basePrice">
            <@ofbizCurrency amount=price.listPrice isoCode=price.currencyUsed />
          </span>
        </li>
      </#if>
      <#if price.listPrice?? && price.defaultPrice?? && price.price?? &&
          price.price &lt; price.defaultPrice && price.defaultPrice &lt; price.listPrice>
        <li>
          <span>${uiLabelMap.ProductRegularPrice}:</span>
          <span class="basePrice">
            <@ofbizCurrency amount=price.defaultPrice isoCode=price.currencyUsed />
          </span>
        </li>
      </#if>
      <#if price.specialPromoPrice??>
        <li><span>${uiLabelMap.ProductSpecialPromoPrice}:</span>
          <span class="basePrice">
            <@ofbizCurrency amount=price.specialPromoPrice isoCode=price.currencyUsed />
          </span>
        </li>
      </#if>
      <li>
        <strong>
          <#if price.isSale?? && price.isSale>
            <span class="salePrice">${uiLabelMap.OrderOnSale}!</span>
            <#assign priceStyle = "salePrice" />
          <#else>
            <#assign priceStyle = "regularPrice" />
          </#if>
          <span>${uiLabelMap.OrderYourPrice}:</span>
          <#if "Y" = product.isVirtual!>
            ${uiLabelMap.CommonFrom}
          </#if>
          <span class="${priceStyle}">
            <@ofbizCurrency amount=price.price isoCode=price.currencyUsed />
          </span>
          <#if product.productTypeId! == "ASSET_USAGE" || product.productTypeId! == "ASSET_USAGE_OUT_IN">
            <#if product.reserv2ndPPPerc?? && product.reserv2ndPPPerc != 0><br/>
              <span class="${priceStyle}">
                ${uiLabelMap.ProductReserv2ndPPPerc}
                <#if !product.reservNthPPPerc?? || product.reservNthPPPerc == 0>
                  ${uiLabelMap.CommonUntil} ${product.reservMaxPersons!1}
                </#if>
                <@ofbizCurrency amount=product.reserv2ndPPPerc*price.price/100 isoCode=price.currencyUsed />
              </span>
            </#if>
            <#if product.reservNthPPPerc?? &&product.reservNthPPPerc != 0><br/>
              <span class="${priceStyle}">
                ${uiLabelMap.ProductReservNthPPPerc}
                <#if !product.reserv2ndPPPerc?? || product.reserv2ndPPPerc == 0>
                  ${uiLabelMap.ProductReservSecond}
                <#else>
                  ${uiLabelMap.ProductReservThird}
                </#if>
                ${uiLabelMap.CommonUntil} ${product.reservMaxPersons!1}, ${uiLabelMap.ProductEach}:
                <@ofbizCurrency amount=product.reservNthPPPerc*price.price/100 isoCode=price.currencyUsed />
              </span>
            </#if>
            <#if (!product.reserv2ndPPPerc?? || product.reserv2ndPPPerc == 0) && (!product.reservNthPPPerc?? ||
                product.reservNthPPPerc == 0)>
              <br/>${uiLabelMap.ProductMaximum} ${product.reservMaxPersons!1} ${uiLabelMap.ProductPersons}.
            </#if>
          </#if>
        </strong>
      </li>
      <#if price.listPrice?? && price.price?? && price.price &lt; price.listPrice>
        <#assign priceSaved = price.listPrice - price.price />
        <#assign percentSaved = (priceSaved / price.listPrice) * 100 />
        <li>
          <span>${uiLabelMap.OrderSave}:</span>
          <span class="basePrice">
            <@ofbizCurrency amount=priceSaved isoCode=price.currencyUsed />
            (${percentSaved?int}%)
          </span>
        </li>
      </#if> -->
      <#-- show price details ("showPriceDetails" field can be set in the screen definition) -->
      <#-- <#if (showPriceDetails?? && showPriceDetails?default("N") == "Y")>
        <#if price.orderItemPriceInfos??>
          <#list price.orderItemPriceInfos as orderItemPriceInfo>
            <li>${orderItemPriceInfo.description!}</li>
          </#list>
        </#if>
      </#if> -->

      <#-- Included quantities/pieces -->
      <#-- <#if product.piecesIncluded?? && product.piecesIncluded?long != 0>
        <li>
          <span>${uiLabelMap.OrderPieces}:</span> ${product.piecesIncluded}
        </li>
      </#if>
      <#if (product.quantityIncluded?? && product.quantityIncluded != 0) || product.quantityUomId?has_content>
        <#assign quantityUom = product.getRelatedOne("QuantityUom", true)! />
        <li>
          <span>${uiLabelMap.CommonQuantity} :</span>
          ${product.quantityIncluded!} ${((quantityUom.abbreviation)?default(product.quantityUomId))!}
        </li>
      </#if>

      <#if (product.productWeight?? && product.productWeight != 0) || product.weightUomId?has_content>
        <#assign weightUom = product.getRelatedOne("WeightUom", true)! />
        <li>
          <span>${uiLabelMap.CommonWeight}:</span>
          ${product.productWeight!} ${((weightUom.abbreviation)?default(product.weightUomId))!}
        </li>
      </#if>
      <#if (product.productHeight?? && product.productHeight != 0) || product.heightUomId?has_content>
        <#assign heightUom = product.getRelatedOne("HeightUom", true)! />
        <li>
          <span>${uiLabelMap.CommonHeight}:</span>
          ${product.productHeight!} ${((heightUom.abbreviation)?default(product.heightUomId))!}
        </li>
      </#if>
      <#if (product.productWidth?? && product.productWidth != 0) || product.widthUomId?has_content>
        <#assign widthUom = product.getRelatedOne("WidthUom", true)! />
        <li>
          <span>${uiLabelMap.CommonWidth}:</span>
          ${product.productWidth!} ${((widthUom.abbreviation)?default(product.widthUomId))!}
        </li>
      </#if>
      <#if (product.productDepth?? && product.productDepth != 0) || product.depthUomId?has_content>
        <#assign depthUom = product.getRelatedOne("DepthUom", true)! />
        <li>
          <span>${uiLabelMap.CommonDepth}:</span>
          ${product.productDepth!} ${((depthUom.abbreviation)?default(product.depthUomId))!}
        </li>
      </#if>

      <#if daysToShip??>
        <li>
          <strong>
            ${uiLabelMap.ProductUsuallyShipsIn} ${daysToShip} ${uiLabelMap.CommonDays}!
          </strong>
        </li>
      </#if> -->

      <#-- show tell a friend details only in ecommerce application -->
      <#--
      <div>&nbsp;</div>
      <div>
        <a href="javascript:popUpSmall('<@ofbizUrl>tellafriend?productId=${product.productId}<#if categoryId??>&categoryId=${categoryId}/</#if></@ofbizUrl>','tellafriend');"
            class="buttontext">${uiLabelMap.CommonTellAFriend}</a>
      </div>
      -->

      <#-- <#if disFeatureList?? && 0 &lt; disFeatureList.size()>
        <p>&nbsp;</p>
        <#list disFeatureList as currentFeature>
          <#assign disFeatureType = currentFeature.getRelatedOne("ProductFeatureType", true) />
          <li>
            <#if disFeatureType.description??>
              ${disFeatureType.get("description", locale)}
            <#else>
              ${currentFeature.productFeatureTypeId}
            </#if>:&nbsp;
            ${currentFeature.description}
          </li>
        </#list>
        <li>&nbsp;</li>
      </#if> -->
    </div>

    <div id="addItemForm" class="options">
      <form method="post" action="<@ofbizUrl>additem</@ofbizUrl>" name="addform" style="margin: 0;">
        <fieldset>
        <#assign inStock = true />
        <#--
        <#assign commentEnable = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"]
            .getPropertyValue("order", "order.item.comment.enable", delegator)>
        <#if commentEnable.equals("Y")>
          <#assign orderItemAttr = Static["org.apache.ofbiz.entity.util.EntityUtilProperties"]
              .getPropertyValue("order", "order.item.attr.prefix", delegator)>
          ${uiLabelMap.CommonComment}&nbsp;<input type="text" name="${orderItemAttr}comment"/>
        </#if>
        -->
        <#-- Variant Selection -->
        <#if product.isVirtual!?upper_case == "Y">
          <#if product.virtualVariantMethodEnum! == "VV_FEATURETREE" && featureLists?has_content>
            <#list featureLists as featureList>
              <#list featureList as feature>
                <#if feature_index == 0>
                  <div>
                    ${feature.description}:
                    <select id="FT${feature.productFeatureTypeId}" name="FT${feature.productFeatureTypeId}"
                        onchange="javascript:checkRadioButton();">
                      <option value="select" selected="selected">
                        ${uiLabelMap.EcommerceSelectOption}
                      </option>
                <#else>
                  <option value="${feature.productFeatureId}">
                    ${feature.description}
                    <#if feature.price??>
                      (+ <@ofbizCurrency amount=feature.price?string isoCode=feature.currencyUomId />)
                    </#if>
                  </option>
                </#if>
              </#list>
            </select>
            </div>
            </#list>
            <input type="hidden" name="add_product_id" value="${product.productId}"/>
            <div id="addCart1" style="display:none;">
            <span style="white-space: nowrap;"><strong>${uiLabelMap.CommonQuantity}:</strong></span>&nbsp;
              <input type="text" size="5" name="quantity" value="1" id="quantity" class="form-control" onkeypress="return event.charCode >= 48 && event.charCode <= 57"/>
              <a href="javascript:javascript:addItem();" class="buttontext"><span
                  style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
              &nbsp;
            </div>
            <div id="addCart2" style="display:block;">
              <span style="white-space: nowrap;"><strong>${uiLabelMap.CommonQuantity}:</strong></span>&nbsp;
              <input type="text" size="5" value="1" disabled="disabled"/>
              <a href="javascript:showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.CommonPleaseSelectAllFeaturesFirst}");"
              class="buttontext"><span style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
              &nbsp;
            </div>
          </#if>
          <#if !product.virtualVariantMethodEnum?? || product.virtualVariantMethodEnum == "VV_VARIANTTREE">
            <#if variantTree?? && (variantTree.size() &gt; 0)>
              <div class="form-group hidden">
                <label for="select" class="control-label text-uppercase">${uiLabelMap.CommonSelect}:</label>
                <#list featureSet as currentType>
                <div id="variantTreeOption">
                  <select name="FT${currentType}" onchange="javascript:getList(this.name, (this.selectedIndex-1), 1, '', '', '');" class="form-control">
                    <option>${featureTypes.get(currentType)}</option>
                  </select>
                </div>
                </#list>
                <span id="product_uom"></span>
                <input type="hidden" name="product_id" value="${product.productId}"/>
                <input type="hidden" name="add_product_id" value="NULL"/>
                <div>
                  <strong><span id="product_id_display"> </span></strong>
                  <strong>
                    <div id="variant_price_display"></div>
                  </strong>
                </div>
              </div>
            <#else>
              <input type="hidden" name="add_product_id" value="NULL"/>
              <#assign inStock = false />
            </#if>

            <#-- Prefill first select box (virtual products only) -->
            <#if variantTree?? && 0 &lt; variantTree.size()>
              <script type="text/javascript">eval("list" + "${featureOrderFirst}" + "()");</script>
            </#if>

            <#-- Swatches (virtual products only) -->
            <#if variantSample?? && 0 &lt; variantSample.size()>
              <div class="productDetailBox">
                <ul class="list-unstyled manufacturer">
                    <li><span class="h4" id="vTitle">${uiLabelMap.PFTOptionSelected} : </span> <label id="variant_name_display" class="h4"> </label></li>
                    <li><span class="h4">${uiLabelMap.PFTPleaseSelectOption} :</span></li>
                    <#list featureSet as currentType>
                        <li><span class="h4" id="vTitle">${featureTypes.get(currentType)} : </span> <label id="variant_type_display" class="h4"> </label></li>
                    </#list>
                </ul>
                <#assign imageKeys = variantSample.keySet() />
                <#assign imageMap = variantSample />
                <ul class="list-unstyled list-inline" id="variantitem">
                    <#assign indexer = 0 />
                    <#list imageKeys as key>
                      <#assign swatchProduct = imageMap.get(key) />
                      <#assign variantProductContentWrapper = Static["org.apache.ofbiz.product.product.ProductContentWrapper"].makeProductContentWrapper(swatchProduct, request)>
                      <#assign variantLargeImageUrl = variantProductContentWrapper.get("LARGE_IMAGE_URL", "url")!/>
                      <#if !variantLargeImageUrl?string?has_content>
                        <#assign variantLargeImageUrl = "/pft-default/images/defaultImage.jpg">
                      </#if>
                      <#assign variantMediumImageUrl = variantProductContentWrapper.get("MEDIUM_IMAGE_URL", "url")!/>
                      <#if !variantMediumImageUrl?string?has_content>
                        <#assign variantMediumImageUrl = "/pft-default/images/defaultImage.jpg">
                      </#if>
                      <#assign variantSmallImageUrl = variantProductContentWrapper.get("SMALL_IMAGE_URL", "url")!/>
                      <#if !variantSmallImageUrl?string?has_content>
                        <#assign variantSmallImageUrl = "/pft-default/images/defaultImage.jpg">
                      </#if>
                      <#assign variantName = variantProductContentWrapper.get("PRODUCT_NAME", "html")! />
                      <li>
                        <#assign productInfoLinkId = "productInfoLink">
                        <#assign productInfoLinkId = productInfoLinkId + swatchProduct.productId/>
                        <#assign productDetailId = "productDetailId"/>
                        <#assign productDetailId = productDetailId + swatchProduct.productId/>
                        <a href="#images-block" id="imageLink_${indexer}">
                          <span id="${productInfoLinkId}" class="popup_link" data-toggle="tooltip">
                            <img src="<@ofbizContentUrl>${contentPathPrefix!}${variantSmallImageUrl!}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail vr-img" id="variantProduct${indexer!}"/>
                          </span>
                        </a>
                        <center><a href="javascript:getList('FT${featureOrderFirst}','${indexer}',1,'${variantLargeImageUrl!}','${variantName!}','${StringUtil.wrapString(key)!}');" class="linktext">${key}</a></center>
                        <br/>
                        <div id="${productDetailId}" class="popup img-responsive thumbnail" style="display:none;">
                          <img src="<@ofbizContentUrl>${contentPathPrefix!}${variantMediumImageUrl!}</@ofbizContentUrl>" alt="Image" class="img-responsive thumbnail vr-img"/>
                        </div>
                        <script type="text/javascript">
                          $(document).ready(function(){
                            jQuery("#${productInfoLinkId}").attr('title', jQuery("#${productDetailId}").remove().html());
                            jQuery("#${productInfoLinkId}").tooltip({
                              content: function(){
                                return this.getAttribute("title");
                              },
                              tooltipClass: "popup",
                              track: true,
                              html: true,
                              placement: function (context, element) {
                                var position = $(element).position();
                                if ((position.top - $(window).scrollTop()) < 0){
                                  return "bottom";
                                }
                                return "top";
                              }
                            });
                            $("#imageLink_${indexer!}").click(function() {
                              var image = unescape("${variantLargeImageUrl!}")
                              getList('FT${featureOrderFirst}','${indexer}',1,image,'${variantName!}','${StringUtil.wrapString(key)!}')
                            })
                          });
                        </script>
                      </li>
                      <#-- Add cart dialog -->
                      ${setRequestAttribute("productUrl", productUrl)}
                      ${setRequestAttribute("smallImageUrl", variantLargeImageUrl)}
                      ${setRequestAttribute("productId", swatchProduct.productId)}
                      ${setRequestAttribute("productContentWrapper", variantProductContentWrapper)}
                      ${setRequestAttribute("price", price)}
                      ${screens.render("component://productfromthailand/widget/CartScreens.xml#addToCartDialog")}
                      <#assign indexer = indexer + 1 />
                    </#list>
                </ul>
              </div>
              <br/>
            </#if>
          </#if>
        <#else>
          <input type="hidden" name="add_product_id" value="${product.productId}"/>
          <#if mainProducts?has_content>
            <input type="hidden" name="product_id" value=""/>
            <select name="productVariantId" onchange="javascript:displayProductVirtualVariantId(this.value);">
              <option value="">Select Unit Of Measure</option>
              <#list mainProducts as mainProduct>
                <option value="${mainProduct.productId}">${mainProduct.uomDesc} : ${mainProduct.piecesIncluded}</option>
              </#list>
            </select><br/>
            <div>
              <strong><span id="product_id_display"> </span></strong>
              <strong>
                <div id="variant_price_display"></div>
              </strong>
            </div>
          </#if>
          <#if (availableInventory??) && (availableInventory <= 0) && product.requireAmount?default("N") == "N">
            <#assign inStock = false />
          </#if>
          <#-- Add cart dialog -->
          ${setRequestAttribute("productUrl", productUrl)}
          ${setRequestAttribute("smallImageUrl", productLargeImageUrl)}
          ${setRequestAttribute("productId", product.productId)}
          ${setRequestAttribute("productContentWrapper", productContentWrapper)}
          ${setRequestAttribute("price", price)}
          ${screens.render("component://productfromthailand/widget/CartScreens.xml#addToCartDialog")}
        </#if>
        <#-- check to see if introductionDate hasnt passed yet -->
        <#if product.introductionDate?? && nowTimestamp.before(product.introductionDate)>
          <p>&nbsp;</p>
          <div style="color: red;">${uiLabelMap.ProductProductNotYetMadeAvailable}.</div>
        <#-- check to see if salesDiscontinuationDate has passed -->
        <#elseif product.salesDiscontinuationDate?? && nowTimestamp.after(product.salesDiscontinuationDate)>
          <div style="color: red;">${uiLabelMap.ProductProductNoLongerAvailable}.</div>
        <#-- check to see if the product requires inventory check and has inventory -->
        <#elseif product.virtualVariantMethodEnum! != "VV_FEATURETREE">
          <#if inStock>
            <#if product.requireAmount?default("N") == "Y">
              <#assign hiddenStyle = "visible" />
            <#else>
              <#assign hiddenStyle = "hidden"/>
            </#if>
            <div id="add_amount" class="${hiddenStyle}">
              <span style="white-space: nowrap;"><strong>${uiLabelMap.CommonAmount}:</strong></span>&nbsp;
              <input type="text" size="5" name="add_amount" value=""/>
            </div>
            <#if product.productTypeId! == "ASSET_USAGE" || product.productTypeId! == "ASSET_USAGE_OUT_IN">
              <div>
                <label>
                  Start Date(yyyy-mm-dd)
                </label>
                <@htmlTemplate.renderDateTimeField event="" action="" name="reservStart" className="" alert=""
                    title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="${startDate}" size="25" maxlength="30"
                    id="reservStart1" dateType="date" shortDateInput=true timeDropdownParamName=""
                    defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString=""
                    hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected=""
                    pmSelected="" compositeType="" formName=""/>
              </div>
              <div>
              <#--td nowrap="nowrap" align="right">Number<br />of days</td>
                  <td><input type="textt" size="4" name="reservLength"/></td></tr>
                  <tr><td>&nbsp;</td><td align="right" nowrap="nowrap">&nbsp;</td-->
                Number of days<input type="text" size="4" name="reservLength" value=""/>
                Number of persons<input type="text" size="4" name="reservPersons" value="2"/>
                Number of rooms<input type="text" size="5" name="quantity" value="1" class="form-control" onkeypress="return event.charCode >= 48 && event.charCode <= 57"/>
              </div>
              <a href="javascript:addItem()" class="buttontext"><span
                  style="white-space: nowrap;">${uiLabelMap.OrderAddToCart}</span></a>
            <#else>
              <span><input name="quantity" id="quantity" value="1" size="4" maxLength="4" type="text" class="form-control" onkeypress="return event.charCode >= 48 && event.charCode <= 57"/></span>
              <button type="button" name="addCartBtn" id="addVarientBtn" class="btn btn-cart" onclick="javascript:addItem();">
                  ${uiLabelMap.OrderAddToCart}
                  <i class="fa fa-shopping-cart"></i>
              </button>
              <@showUnavailableVarients/>
            </#if>
          <#else>
            <#if productStore??>
              <#if productStore.requireInventory?? && productStore.requireInventory == "N">
                <span class="price-head">${uiLabelMap.CommonQuantity} :</span>
                <input name="quantity" id="quantity" value="1" size="4" maxLength="4" type="text" class="form-control" onkeypress="return event.charCode >= 48 && event.charCode <= 57"
                             <#if product.isVirtual!?upper_case == "Y">disabled="disabled"</#if>/>
                <button type="button" class="btn btn-cart" id="addToCart" name="addToCart" onclick="javascript:addItem()">
                    ${uiLabelMap.OrderAddToCart}
                    <i class="fa fa-shopping-cart"></i>
                </button>
                <@showUnavailableVarients/>
              <#else>
                <span><input name="quantity" id="quantity" value="1" size="4" maxLength="4" type="text" class="form-control" onkeypress="return event.charCode >= 48 && event.charCode <= 57" disabled="disabled"/></span>
                <button type="button" class="btn btn-cart" onclick="javascript:javascript:void(0);" disabled>
                    ${uiLabelMap.OrderAddToCart}
                    <i class="fa fa-shopping-cart"></i>
                </button>
                <#-- <span>${uiLabelMap.ProductItemOutOfStock}<#if product.inventoryMessage??>&mdash; ${product.inventoryMessage}</#if></span> -->
              </#if>
            </#if>
          </#if>
        </#if>
        <#assign timeId = Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp().getTime()/>
        <button type="button" onclick="addToWishlist(addProductToWishList_${timeId},'${productContentWrapper.get("PRODUCT_NAME", "html")!}')" title="Wishlist" class="btn btn-wishlist">
            <i class="fa fa-heart"></i>
        </button>
        <#if variantPriceList??>
          <#list variantPriceList as vpricing>
            <#assign variantName = vpricing.get("variantName")!>
            <#assign secondVariantName = vpricing.get("secondVariantName")!>
            <#assign minimumQuantity = vpricing.get("minimumQuantity")>
            <#if minimumQuantity &gt; 0>
              <div>minimum order quantity for ${secondVariantName!} ${variantName!} is ${minimumQuantity!}</div>
            </#if>
          </#list>
        <#elseif minimumQuantity?? && minimumQuantity?has_content && minimumQuantity &gt; 0>
          <div>minimum order quantity for ${productContentWrapper.get("PRODUCT_NAME", "html")!}
            is ${minimumQuantity!}</div>
        </#if>
        </fieldset>
      </form>
      <#assign timeId = Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp().getTime()/>
      <form name="addProductToWishList_${timeId}" method="post" action="<@ofbizUrl>addProductToWishList</@ofbizUrl>">
          <input name="productId" type="hidden" value="${product.productId}"/>
      </form>
    </div>

    <#-- Digital Download Files Associated with this Product -->
    <#if downloadProductContentAndInfoList?has_content>
      <div id="download-files">
        <div>${uiLabelMap.OrderDownloadFilesTitle}:</div>
        <#list downloadProductContentAndInfoList as downloadProductContentAndInfo>
          <div>${downloadProductContentAndInfo.contentName!}<#if downloadProductContentAndInfo.description?has_content>
            - ${downloadProductContentAndInfo.description}</#if></div>
        </#list>
      </div>
    </#if>

    <#-- Long description of product -->
    <div id="long-description">
      <div>${productContentWrapper.get("LONG_DESCRIPTION", "html")!}</div>
      <div>${productContentWrapper.get("WARNINGS", "html")!}</div>
    </div>
  </div>
  </div>
  </div>

    <!-- Tabs Starts -->
        <div class="tabs-panel panel-smart">
        <!-- Nav Tabs Starts -->
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#tab-description">${uiLabelMap.CommonDescription}</a>
                </li>
                <li><a href="#tab-review">${uiLabelMap.PageTitleProductReview}</a></li>
            </ul>
        <!-- Nav Tabs Ends -->
        <!-- Tab Content Starts -->
            <div class="tab-content clearfix">
            <!-- Description Starts -->
                <div class="tab-pane active" id="tab-description">
                    <div>${productContentWrapper.get("DESCRIPTION", "html")?string?replace("\n", "<br/>")!}</div>
                    <div>${productContentWrapper.get("LONG_DESCRIPTION", "html")?string?replace("\n", "<br/>")!}</div>
                </div>
            <!-- Description Ends -->
            <!-- Review Starts -->
                <div class="tab-pane" id="tab-review">
                    <#-- Product Reviews -->
                    <#if productReviews?has_content>
                      <div id="reviews">
                        <div><h3>${uiLabelMap.OrderCustomerReviews}</h3></div>
                        <#if averageRating?? && (averageRating &gt; 0) && numRatings?? && (numRatings &gt; 1)>
                          <div>${uiLabelMap.OrderAverageRating}: ${averageRating} <#if numRatings??>
                            (${uiLabelMap.CommonFrom} ${numRatings} ${uiLabelMap.OrderRatings})</#if></div>
                        </#if>
                        <hr/>
                        <#list productReviews as productReview>
                          <#assign postedUserLogin = productReview.getRelatedOne("UserLogin", false) />
                          <#assign postedPerson = postedUserLogin.getRelatedOne("Person", false)! />
                          <div>
                            <strong>${uiLabelMap.CommonBy} : </strong>
                            <#if productReview.postedAnonymous?default("N") == "Y">
                              ${uiLabelMap.OrderAnonymous}
                            <#else>
                              ${postedPerson.firstName} ${postedPerson.lastName}&nbsp;
                            </#if>
                          </div>
                          <div><strong>${uiLabelMap.CommonAt}: </strong>${productReview.postedDateTime!}&nbsp;</div>
                          <div><strong>${uiLabelMap.OrderRanking}: </strong>${productReview.productRating!?string}</div>
                          <div>&nbsp;</div>
                          <div>${productReview.productReview!}</div>
                          <hr/>
                        </#list>
                      </div>
                    </#if>
                    <div class="clearfix"></div>
                    <#if product.productId??>
                    <#assign productCategoryMember = EntityQuery.use(delegator).from("ProductCategoryMember").where("productId", product.productId).filterByDate().queryFirst()!>
                    <form class="form-horizontal" id="reviewProduct" method="post" action="<@ofbizUrl>createProductReview</@ofbizUrl>">
                        <input type="hidden" name="productStoreId" value="${productStore.productStoreId}" />
                        <input type="hidden" name="productId" value="${product.productId}" />
                        <input type="hidden" name="product_id" value="${product.productId}" />
                        <input type="hidden" name="category_id" value="${productCategoryMember.productCategoryId!}" />
                        <div class="form-group required">
                            <label class="col-sm-2 control-label ratings">${uiLabelMap.PFTRateThisProduct}</label>
                            <div class="col-sm-10">
                                1&nbsp;
                                <input type="radio" name="productRating" value="1" />
                                2&nbsp;
                                <input type="radio" name="productRating" value="2" />
                                3&nbsp;
                                <input type="radio" name="productRating" value="3" />
                                4&nbsp;
                                <input type="radio" name="productRating" value="4" />
                                5&nbsp;
                                <input type="radio" name="productRating" value="5" />
                                &nbsp;
                            </div>
                        </div>
                        <div class="form-group required">
                            <label class="col-sm-2 control-label ratings">${uiLabelMap.EcommercePostAnonymous}</label>
                            <div class="col-sm-10">
                                ${uiLabelMap.CommonYes}&nbsp;
                                <input type="radio" id="yes" name="postedAnonymous" value="Y" />
                                ${uiLabelMap.CommonNo}&nbsp;
                                <input type="radio" id="no" name="postedAnonymous" value="N" checked="checked" />
                            </div>
                        </div>
                        <div class="form-group required">
                            <label class="col-sm-2 control-label" for="input-review">${uiLabelMap.PFTReview}</label>
                            <div class="col-sm-10">
                                <textarea rows="5" name="productReview" class="form-control"></textarea>
                            </div>
                        </div>
                        <div class="buttons">
                            <div class="col-sm-offset-2 col-sm-10">
                                <a href="javascript:document.getElementById('reviewProduct').submit();" class="btn btn-main">
                                    ${uiLabelMap.CommonSave}
                                </a>
                            </div>
                        </div>
                    </form>
                    <#else>
                      <h2>${uiLabelMap.ProductCannotReviewUnKnownProduct}.</h2>
                    </#if>
                </div>
            <!-- Review Ends -->
            </div>
        <!-- Tab Content Ends -->
        </div>
    <!-- Tabs Ends -->
  <#-- Upgrades/Up-Sell/Cross-Sell -->
  <#macro associated assocProducts beforeName showName afterName formNamePrefix targetRequestName>
      <#assign pageProduct = product />
      <#assign targetRequest = "product" />
      <#if targetRequestName?has_content>
        <#assign targetRequest = targetRequestName />
      </#if>
      <#if assocProducts?has_content>
        <h4 class="heading">
            ${beforeName!} <#if showName == "Y">${productContentWrapper.get("PRODUCT_NAME", "html")!}</#if>${afterName!}
        </h4>
        <div class="row">

          <#list assocProducts as productAssoc>
            <#if productAssoc.productId == product.productId>
              <#assign assocProductId = productAssoc.productIdTo />
            <#else>
              <#assign assocProductId = productAssoc.productId />
            </#if>
            <#-- <div>
              <a href="<@ofbizUrl>${targetRequest}/<#if categoryId??>~category_id=${categoryId}/</#if>~product_id=${assocProductId}</@ofbizUrl>"
                 class="buttontext">
              ${assocProductId}
              </a>
              <#if productAssoc.reason?has_content>
                - <strong>${productAssoc.reason}</strong>
              </#if>
            </div> -->
            ${setRequestAttribute("optProductId", assocProductId)}
            ${setRequestAttribute("listIndex", listIndex)}
            ${setRequestAttribute("formNamePrefix", formNamePrefix)}
            <#if targetRequestName?has_content>
                ${setRequestAttribute("targetRequestName", targetRequestName)}
            </#if>
            ${screens.render(productsummaryScreen)}
            <#assign product = pageProduct />
            <#local listIndex = listIndex + 1 />
          </#list>

          ${setRequestAttribute("optProductId", "")}
          ${setRequestAttribute("formNamePrefix", "")}
          ${setRequestAttribute("targetRequestName", "")}
        </div>
      </#if>
  </#macro>
  <div class="product-info-box">
    <#assign productValue = product />
    <#assign listIndex = 1 />
    ${setRequestAttribute("productValue", productValue)}
    <div id="associated-products">
    <#-- also bought -->
      <@associated assocProducts=alsoBoughtProducts beforeName="" showName="N"
          afterName="${uiLabelMap.ProductAlsoBought}" formNamePrefix="albt" targetRequestName="" />
      <#-- obsolete -->
      <@associated assocProducts=obsoleteProducts beforeName="" showName="Y" afterName=" ${uiLabelMap.ProductObsolete}"
          formNamePrefix="obs" targetRequestName="" />
      <#-- cross sell -->
      <@associated assocProducts=crossSellProducts beforeName="" showName="N" afterName="${uiLabelMap.ProductCrossSell}"
          formNamePrefix="cssl" targetRequestName="crosssell" />
      <#-- up sell -->
      <@associated assocProducts=upSellProducts beforeName="${uiLabelMap.ProductUpSell} " showName="Y" afterName=":"
          formNamePrefix="upsl" targetRequestName="upsell" />
      <#-- obsolescence -->
      <@associated assocProducts=obsolenscenseProducts beforeName="" showName="Y"
          afterName=" ${uiLabelMap.ProductObsolescense}" formNamePrefix="obce" targetRequestName="" />
    </div>
  </div>

    <#-- special cross/up-sell area using commonFeatureResultIds (from common feature product search) -->
    <#if commonFeatureResultIds?has_content>
    <div class="product-info-box">
        <div class="row">
        <h4 class="heading">${uiLabelMap.ProductSimilarProducts}</h4>

            <div class="productsummary-container">
              <#list commonFeatureResultIds as commonFeatureResultId>
                ${setRequestAttribute("optProductId", commonFeatureResultId)}
                ${setRequestAttribute("listIndex", commonFeatureResultId_index)}
                ${setRequestAttribute("formNamePrefix", "cfeatcssl")}
                <#-- ${setRequestAttribute("targetRequestName", targetRequestName)} -->
                ${screens.render(productsummaryScreen)}
              </#list>
            </div>
        </div>
    </div>
    </#if>
</div>
