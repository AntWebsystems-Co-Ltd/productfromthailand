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
<#assign shoppingCart = sessionAttributes.shoppingCart!>
<#if shoppingCart?has_content>
  <#assign shoppingCartSize = shoppingCart.size()>
<#else>
  <#assign shoppingCartSize = 0>
</#if>
<div id="microcart">
  <#if (shoppingCartSize > 0)>
    <p id="microCartNotEmpty">
      <a id="cart" href="<@ofbizUrl>view/showcart</@ofbizUrl>">
      <strong id="microCartQuantity">
        ${shoppingCart.getTotalQuantity()}
      </strong>
      <#if shoppingCart.getTotalQuantity() == 1>
        ${uiLabelMap.OrderItem}
      <#else>
        ${uiLabelMap.OrderItems}
      </#if>,
      <strong id="microCartTotal">
        <@ofbizCurrency amount=shoppingCart.getDisplayGrandTotal() isoCode=shoppingCart.getCurrency()/>
      </strong>
      </a>
    </p>
    <span id="microCartEmpty" style="display:none">${uiLabelMap.OrderShoppingCartEmpty}</span>
  <#else>
    <p>${uiLabelMap.OrderShoppingCartEmpty}</p>
  </#if>
</div>

