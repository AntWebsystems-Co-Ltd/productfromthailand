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

<#-- NOTE: this template is used for the orderstatus screen in ecommerce AND for order notification emails through the OrderNoticeEmail.ftl file -->
<#-- the "urlPrefix" value will be prepended to URLs by the ofbizUrl transform if/when there is no "request" object in the context -->
<#if baseEcommerceSecureUrl?exists><#assign urlPrefix = baseEcommerceSecureUrl/></#if>
<div class="screenlet">
  <h3>
      <#assign numColumns = 8>
      <#if maySelectItems?default("N") == "Y" && roleTypeId?if_exists == "PLACING_CUSTOMER">
          <#assign numColumns = 11>
          <a href="javascript:document.addCommonToCartForm.add_all.value='true';document.addCommonToCartForm.submit()" class="submenutext">${uiLabelMap.OrderAddAllToCart}</a><a href="javascript:document.addCommonToCartForm.add_all.value='false';document.addCommonToCartForm.submit()" class="submenutext">${uiLabelMap.OrderAddCheckedToCart}</a><a href="<@ofbizUrl>createShoppingListFromOrder?orderId=${orderHeader.orderId}&frequency=6&intervalNumber=1&shoppingListTypeId=SLT_AUTO_REODR</@ofbizUrl>" class="submenutextright">${uiLabelMap.OrderSendMeThisEveryMonth}</a>
      </#if>
      ${uiLabelMap.OrderOrderItems}
  </h3>
  <table>
    <tr>
      <td>${uiLabelMap.OrderProduct}</td>
      <#if maySelectItems?default("N") == "Y">
        <td>${uiLabelMap.OrderQtyOrdered}</td>
        <td>${uiLabelMap.OrderQtyPicked}</td>
        <td>${uiLabelMap.OrderQtyShipped}</td>
        <td>${uiLabelMap.OrderQtyCanceled}</td>
      <#else>
        <td></td>
        <td></td>
        <td></td>
        <td>${uiLabelMap.OrderQtyOrdered}</td>
      </#if>
      <td >${uiLabelMap.EcommerceUnitPrice}</td>
      <td >${uiLabelMap.OrderAdjustments}</td>
      <td >${uiLabelMap.CommonSubtotal}</td>
      <#if maySelectItems?default("N") == "Y" && roleTypeId?if_exists == "PLACING_CUSTOMER">
        <td colspan="3"></td>
      </#if>
    </tr>
    <#assign rateResult = dispatcher.runSync("getFXConversion", Static["org.ofbiz.base.util.UtilMisc"].toMap("uomId", currencyUomId, "uomIdTo", currencyUom, "userLogin", userLogin?default(defaultUserLogin)))/>
    <#assign conversionRate = rateResult.conversionRate>
    <#list orderItems as orderItem>
      <#-- get info from workeffort and calculate rental quantity, if it was a rental item -->
      <#assign rentalQuantity = 1> <#-- no change if no rental item -->
      <#if orderItem.orderItemTypeId == "RENTAL_ORDER_ITEM" && workEfforts?exists>
        <#list workEfforts as workEffort>
          <#if workEffort.workEffortId == orderItem.orderItemSeqId>
            <#assign rentalQuantity = localOrderReadHelper.getWorkEffortRentalQuantity(workEffort)>
            <#assign workEffortSave = workEffort>
            <#break>
          </#if>
        </#list>
      <#else>
        <#assign WorkOrderItemFulfillments = orderItem.getRelated("WorkOrderItemFulfillment")?if_exists>
        <#if WorkOrderItemFulfillments?has_content>
          <#list WorkOrderItemFulfillments as WorkOrderItemFulfillment>
            <#assign workEffortSave = WorkOrderItemFulfillment.getRelatedOneCache("WorkEffort")?if_exists>
            <#break>
           </#list>
        </#if>
      </#if>
      <tr><td colspan="${numColumns}"></td></tr>
      <tr>
        <#if !orderItem.productId?exists || orderItem.productId == "_?_">
          <td >
            ${orderItem.itemDescription?default("")}
          </td>
        <#else>
          <#assign product = orderItem.getRelatedOneCache("Product")?if_exists/> <#-- should always exist because of FK constraint, but just in case -->
          <td >
            <a href="<@ofbizUrl>product?product_id=${orderItem.productId}</@ofbizUrl>" class="linktext">${orderItem.productId} - ${orderItem.itemDescription?default("")}</a>
            <#if product?has_content>
              <#if product.piecesIncluded?exists && product.piecesIncluded?long != 0>
                  [${uiLabelMap.OrderPieces}: ${product.piecesIncluded}]
              </#if>
              <#if (product.quantityIncluded?exists && product.quantityIncluded != 0) || product.quantityUomId?has_content>
                <#assign quantityUom = product.getRelatedOneCache("QuantityUom")?if_exists/>
                  [${uiLabelMap.CommonQuantity}: ${product.quantityIncluded?if_exists} ${((quantityUom.abbreviation)?default(product.quantityUomId))?if_exists}]
              </#if>
              <#if (product.weight?exists && product.weight != 0) || product.weightUomId?has_content>
                <#assign weightUom = product.getRelatedOneCache("WeightUom")?if_exists/>
                  [${uiLabelMap.CommonWeight}: ${product.weight?if_exists} ${((weightUom.abbreviation)?default(product.weightUomId))?if_exists}]
              </#if>
              <#if (product.productHeight?exists && product.productHeight != 0) || product.heightUomId?has_content>
                <#assign heightUom = product.getRelatedOneCache("HeightUom")?if_exists/>
                  [${uiLabelMap.CommonHeight}: ${product.productHeight?if_exists} ${((heightUom.abbreviation)?default(product.heightUomId))?if_exists}]
              </#if>
              <#if (product.productWidth?exists && product.productWidth != 0) || product.widthUomId?has_content>
                <#assign widthUom = product.getRelatedOneCache("WidthUom")?if_exists/>
                  [${uiLabelMap.CommonWidth}: ${product.productWidth?if_exists} ${((widthUom.abbreviation)?default(product.widthUomId))?if_exists}]
              </#if>
              <#if (product.productDepth?exists && product.productDepth != 0) || product.depthUomId?has_content>
                <#assign depthUom = product.getRelatedOneCache("DepthUom")?if_exists/>
                  [${uiLabelMap.CommonDepth}: ${product.productDepth?if_exists} ${((depthUom.abbreviation)?default(product.depthUomId))?if_exists}]
              </#if>
            </#if>
            <#if maySelectItems?default("N") == "Y">
              <#assign returns = orderItem.getRelated("ReturnItem")?if_exists>
              <#if returns?has_content>
                <#list returns as return>
                  <#assign returnHeader = return.getRelatedOne("ReturnHeader")>
                  <#if returnHeader.statusId != "RETURN_CANCELLED">
                    <#if returnHeader.statusId == "RETURN_REQUESTED" || returnHeader.statusId == "RETURN_APPROVED">
                      <#assign displayState = "Return Pending">
                    <#else>
                      <#assign displayState = "Returned">
                    </#if>
                    ${displayState} (#${return.returnId})
                  </#if>
                </#list>
              </#if>
            </#if>
          </td>
          <#if !(maySelectItems?default("N") == "Y")>
            <td></td>
            <td></td>
            <td></td>
          </#if>
          <td>
            ${orderItem.quantity?string.number}
          </td>
          <#if maySelectItems?default("N") == "Y">
          <td>
            <#assign pickedQty = localOrderReadHelper.getItemPickedQuantityBd(orderItem)>
            <#if pickedQty gt 0 && orderHeader.statusId == "ORDER_APPROVED">${pickedQty?default(0)?string.number}<#else>${pickedQty?default(0)?string.number}</#if>
          </td>
          <td>
            <#assign shippedQty = localOrderReadHelper.getItemShippedQuantity(orderItem)>
            ${shippedQty?default(0)?string.number}
          </td>
          <td>
            <#assign canceledQty = localOrderReadHelper.getItemCanceledQuantity(orderItem)>
            ${canceledQty?default(0)?string.number}
          </td>
          </#if>
          <td>
            <@ofbizCurrency amount=orderItem.unitPrice*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=orderItem.unitPrice isoCode=currencyUomId/-->
          </td>
          <td>
            <@ofbizCurrency amount=localOrderReadHelper.getOrderItemAdjustmentsTotal(orderItem)*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=localOrderReadHelper.getOrderItemAdjustmentsTotal(orderItem) isoCode=currencyUomId/-->
          </td>
          <td>
            <#if workEfforts?exists>
              <@ofbizCurrency amount=localOrderReadHelper.getOrderItemTotal(orderItem)*rentalQuantity*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=localOrderReadHelper.getOrderItemTotal(orderItem)*rentalQuantity isoCode=currencyUomId/-->
            <#else>
              <@ofbizCurrency amount=localOrderReadHelper.getOrderItemTotal(orderItem)*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=localOrderReadHelper.getOrderItemTotal(orderItem) isoCode=currencyUomId/-->
            </#if>
          </td>
          <#if maySelectItems?default("N") == "Y" && roleTypeId?if_exists == "PLACING_CUSTOMER">
            <td></td>
            <td>
              <input name="item_id" value="${orderItem.orderItemSeqId}" type="checkbox"/>
            </td>
            <td></td>
          </#if>
        </#if>
      </tr>
      <#-- now cancel reason and comment field -->
      <#if maySelectItems?default("N") == "Y" && (orderHeader.statusId != "ORDER_SENT" && orderItem.statusId != "ITEM_COMPLETED" && orderItem.statusId != "ITEM_CANCELLED" && pickedQty == 0)>
        <tr>
          <td colspan="7">${uiLabelMap.OrderReturnReason}
            <select name="irm_${orderItem.orderItemSeqId}" class="selectBox">
              <option value=""></option>
              <#list orderItemChangeReasons as reason>
                <option value="${reason.enumId}">${reason.get("description",locale)?default(reason.enumId)}</option>
              </#list>
            </select>
            ${uiLabelMap.CommonComments}
            <input class="inputBox" type="text" name="icm_${orderItem.orderItemSeqId}" value="" size="30" maxlength="60"/>
          </td>
          <td colspan="4"><a href="javascript:document.addCommonToCartForm.action='<@ofbizUrl>cancelOrderItem</@ofbizUrl>';document.addCommonToCartForm.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
            <input type="hidden" name="orderItemSeqId" value="${orderItem.orderItemSeqId}"/>
          </td>
        </tr>
      </#if>
      <#-- show info from workeffort if it was a rental item -->
      <#if orderItem.orderItemTypeId == "RENTAL_ORDER_ITEM">
        <#if workEffortSave?exists>
          <tr><td></td><td colspan="${numColumns}">${uiLabelMap.CommonFrom}: ${workEffortSave.estimatedStartDate?string("yyyy-MM-dd")} ${uiLabelMap.CommonUntil} ${workEffortSave.estimatedCompletionDate?string("yyyy-MM-dd")} ${uiLabelMap.CommonFor} ${workEffortSave.reservPersons} ${uiLabelMap.CommonPerson}(s)</td></tr>
        </#if>
      </#if>
      <#-- now show adjustment details per line item -->
      <#assign itemAdjustments = localOrderReadHelper.getOrderItemAdjustments(orderItem)>
      <#list itemAdjustments as orderItemAdjustment>
        <tr>
          <td>
            ${uiLabelMap.EcommerceAdjustment}: ${localOrderReadHelper.getAdjustmentType(orderItemAdjustment)}
            <#if orderItemAdjustment.description?has_content>: ${orderItemAdjustment.description}</#if>
            <#if orderItemAdjustment.orderAdjustmentTypeId == "SALES_TAX">
              <#if orderItemAdjustment.primaryGeoId?has_content>
                <#assign primaryGeo = orderItemAdjustment.getRelatedOneCache("PrimaryGeo")/>
                <#if primaryGeo.geoName?has_content>
                  ${uiLabelMap.OrderJurisdiction}: ${primaryGeo.geoName} [${primaryGeo.abbreviation?if_exists}]
                </#if>
                <#if orderItemAdjustment.secondaryGeoId?has_content>
                  <#assign secondaryGeo = orderItemAdjustment.getRelatedOneCache("SecondaryGeo")/>
                  (${uiLabelMap.CommonIn}: ${secondaryGeo.geoName} [${secondaryGeo.abbreviation?if_exists}])
                </#if>
              </#if>
              <#if orderItemAdjustment.sourcePercentage?exists>${uiLabelMap.EcommerceRate}: ${orderItemAdjustment.sourcePercentage}</#if>
              <#if orderItemAdjustment.customerReferenceId?has_content>${uiLabelMap.OrderCustomerTaxId}: ${orderItemAdjustment.customerReferenceId}</#if>
              <#if orderItemAdjustment.exemptAmount?exists>${uiLabelMap.EcommerceExemptAmount}: ${orderItemAdjustment.exemptAmount}</#if>
            </#if>
          </td>
          <td colspan="5"></td>
          <td>
            <@ofbizCurrency amount=localOrderReadHelper.getOrderItemAdjustmentTotal(orderItem, orderItemAdjustment)*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=localOrderReadHelper.getOrderItemAdjustmentTotal(orderItem, orderItemAdjustment) isoCode=currencyUomId/-->
          </td>
          <td></td>
          <#if maySelectItems?default("N") == "Y"><td colspan="3"></td></#if>
        </tr>
      </#list>
      <#-- show the order item ship group info -->
      <#assign orderItemShipGroupAssocs = orderItem.getRelated("OrderItemShipGroupAssoc")?if_exists>
      <#if orderItemShipGroupAssocs?has_content>
        <#list orderItemShipGroupAssocs as shipGroupAssoc>
          <#assign shipGroup = shipGroupAssoc.getRelatedOne("OrderItemShipGroup")?if_exists>
          <#assign shipGroupAddress = (shipGroup.getRelatedOne("PostalAddress"))?if_exists>
          <tr>
            <td>
              ${uiLabelMap.OrderShipGroup}: [${shipGroup.shipGroupSeqId}] ${shipGroupAddress.address1?default("N/A")}
            </td>
            <td>
              ${shipGroupAssoc.quantity?string.number}
            </td>
            <td colspan="${numColumns - 2}"></td>
          </tr>
        </#list>
      </#if>
    </#list>
    <#if orderItems?size == 0 || !orderItems?has_content>
      <tr><td colspan="${numColumns}">${uiLabelMap.OrderSalesOrderLookupFailed}</td></tr>
    </#if>
    <tr><td colspan="${numColumns}"></td></tr>
    <tr>
      <td colspan="7">${uiLabelMap.CommonSubtotal}</td>
      <td><@ofbizCurrency amount=orderSubTotal*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=orderSubTotal isoCode=currencyUomId/--></td>
      <#if maySelectItems?default("N") == "Y"><td colspan="3"></td></#if>
    </tr>
    <#list headerAdjustmentsToShow as orderHeaderAdjustment>
      <tr>
        <td colspan="7">${localOrderReadHelper.getAdjustmentType(orderHeaderAdjustment)}</td>
        <td><@ofbizCurrency amount=localOrderReadHelper.getOrderAdjustmentTotal(orderHeaderAdjustment)*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=localOrderReadHelper.getOrderAdjustmentTotal(orderHeaderAdjustment) isoCode=currencyUomId/--></td>
        <#if maySelectItems?default("N") == "Y"><td colspan="3"></td></#if>
      </tr>
    </#list>
    <tr>
      <td colspan="7">${uiLabelMap.OrderShippingAndHandling}</td>
      <td><@ofbizCurrency amount=orderShippingTotal*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=orderShippingTotal isoCode=currencyUomId/--></td>
      <#if maySelectItems?default("N") == "Y"><td colspan="3"></td></#if>
    </tr>
    <tr>
      <td colspan="7">${uiLabelMap.OrderSalesTax}</td>
      <td><@ofbizCurrency amount=orderTaxTotal*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=orderTaxTotal isoCode=currencyUomId/--></td>
      <#if maySelectItems?default("N") == "Y"><td colspan="3"></td></#if>
    </tr>
    <tr>
      <td colspan="3"></td>
      <#if maySelectItems?default("N") == "Y">
        <td colspan="${numColumns - 6}"></td>
        <td colspan="3"></td>
      <#else>
        <td colspan="${numColumns - 3}"></td>
      </#if>
    </tr>
    <tr>
      <td colspan="7">${uiLabelMap.OrderGrandTotal}</td>
      <td>
        <@ofbizCurrency amount=orderGrandTotal*conversionRate isoCode=currencyUom/><#--@ofbizCurrency amount=orderGrandTotal isoCode=currencyUomId/-->
      </td>
      <#if maySelectItems?default("N") == "Y"><td colspan="3"></td></#if>
    </tr>
  </table>
</div>