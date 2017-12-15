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
<script language="javascript" type="text/javascript">
$(document).ready( function() {
    <#if shoppingCart.getShippingContactMechId()?exists>
        <#if chosenShippingMethod?exists>
            if ($("input:radio[name='shipping_method']").is(":checked")) {
                if(checkoutStep == 3) {
                    $("#checkoutStep3Button").removeClass("hide");
                }
            }
        </#if>
    </#if>
});
</script>
<table class="table table-bordered" id="checkoutreview-table">
    <thead>
        <tr>
            <th>${uiLabelMap.ProductProduct}</th>
            <th class="text-center">${uiLabelMap.CommonQty}</th>
            <th class="text-right">${uiLabelMap.CommonTotal}</th>
        </tr>
    </thead>
    <tbody>
        <#list shoppingCart.items() as cartLine>
            <tr id="checkoutreview-detail">
                <td>${StringUtil.wrapString(cartLine.getName()?if_exists)}</td>
                <td class="text-center">x${cartLine.getQuantity()?string.number?default(0)}</td>
                <td class="text-right"><@ofbizCurrency amount=cartLine.getDisplayItemSubTotal() isoCode=shoppingCart.getCurrency()/></td>
            </tr>
        </#list>
    </tbody>
    <tfoot>
        <tr id="checkouttotal_adjustment" class="checkouttotal">
            <#assign orderAdjustmentsTotal = 0 />
            <#list shoppingCart.getAdjustments() as cartAdjustment>
              <#assign orderAdjustmentsTotal = orderAdjustmentsTotal +
                  Static["org.apache.ofbiz.order.order.OrderReadHelper"]
                  .calcOrderAdjustment(cartAdjustment, shoppingCart.getSubTotal()) />
            </#list>
            <td colspan="2"><b>${uiLabelMap.EcommerceAdjustment}</b></td>
            <td class="text-right"><b><@ofbizCurrency amount=orderAdjustmentsTotal isoCode=shoppingCart.getCurrency() /></b></td>
        </tr>
        <tr id="checkouttotal_subtotal" class="checkouttotal">
            <td colspan="2"><b>${uiLabelMap.CommonSubtotal}</b></td>
            <td class="text-right"><b><@ofbizCurrency amount=shoppingCart.getSubTotal() isoCode=shoppingCart.getCurrency()/></b></td>
        </tr>
        <tr id="checkouttotal_shipping" class="checkouttotal">
            <td colspan="2"><b>${uiLabelMap.OrderShippingAndHandling}</b></td>
            <td class="text-right"><b><@ofbizCurrency amount=shoppingCart.getTotalShipping() isoCode=shoppingCart.getCurrency() /></b></td>
        </tr>
        <tr id="checkouttotal_tax" class="checkouttotal">
            <td colspan="2"><b>${uiLabelMap.PFTSalesTax}</b></td>
            <td class="text-right"><b><@ofbizCurrency amount=orderTaxTotal isoCode=shoppingCart.getCurrency() /></b></td>
        </tr>
        <tr id="checkouttotal_grandtotal" class="checkouttotal">
            <td colspan="2"><b>${uiLabelMap.OrderGrandTotal}</b></td>
            <td class="text-right"><b><@ofbizCurrency amount=orderGrandTotal isoCode=shoppingCart.getCurrency() /></b></td>
        </tr>
    </tfoot>
</table>
<#-- Your Order Details Ends -->
<#-- Spacer Starts -->
<div class="spacer"></div>
<#-- Spacer Ends -->
<div id="checkoutStep3Button" class="">
    <div class="checkbox">
        <label class="checkbox-style-1">
            <input type="checkbox" id="acceptcondition"> ${uiLabelMap.PFTIHaveReadAndAcceptThe} <a href="<@ofbizUrl>showhelpcontent</@ofbizUrl>?contentId=HELP_TERMSANDCON&nodeTrailCsv=HELP_TERMSANDCON" target="_blank">${uiLabelMap.PFTTermsAndCons}</a>
        </label>
        <button type="button" id="finalOrderBtn" class="btn btn-main btn-block  btn-style-1 animation flat text-uppercase"
        onclick="javascript:stepAction('next',3);">
        ${uiLabelMap.OrderContinueToFinalOrderReview}
    </button>
    </div>
</div>