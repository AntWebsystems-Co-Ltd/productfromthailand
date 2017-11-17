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

<script language="JavaScript" type="text/javascript">
<!--
    var clicked = 0;
    function processOrder() {
        if (clicked == 0) {
            clicked++;
            //window.location.replace("<@ofbizUrl>processorder</@ofbizUrl>");
            document.${parameters.formNameValue}.processButton.value="${uiLabelMap.OrderSubmittingOrder}";
            document.${parameters.formNameValue}.processButton.disabled=true;
            document.${parameters.formNameValue}.submit();
        } else {
            alert("You order is being processed, this may take a moment.");
        }
    }
// -->
</script>

<div id="main-container" class="container">
    <h1>${uiLabelMap.PFTFinalCheckoutReview}</h1>
    <#if !isDemoStore?exists && isDemoStore><p>${uiLabelMap.OrderDemoFrontNote}.</p></#if>
    <div class="panel-smart">
    <#if cart?exists && 0 < cart.size()>
      <div class="col-xs-12">
      ${screens.render("component://productfromthailand/widget/OrderScreens.xml#orderheader")}
      ${screens.render("component://productfromthailand/widget/OrderScreens.xml#orderitems")}
      </div>
      <table border="0" cellpadding="1" width="100%">
       <tr>
          <td colspan="4">
            &nbsp;
          </td>
          <td>
            &nbsp;
          </td>
        </tr>
        <tr>
          <td colspan="4">
            &nbsp;
          </td>
          <td align="right">
            <form type="POST" action="<@ofbizUrl>processorder</@ofbizUrl>" name="${parameters.formNameValue}">
              <#if (requestParameters.checkoutpage)?has_content>
                <input type="hidden" name="checkoutpage" value="${requestParameters.checkoutpage}"/>
              </#if>
              <#if (requestAttributes.issuerId)?has_content>
                <input type="hidden" name="issuerId" value="${requestAttributes.issuerId}"/>
              </#if>
              <button type="button" name="processButton" class="btn btn-main" onclick="processOrder();">${uiLabelMap.OrderSubmitOrder}</button>
            </form>
          </td>
        </tr>
      </table>
    <#else>
      <h3>${uiLabelMap.OrderErrorShoppingCartEmpty}.</h3>
    </#if>
    </div>
</div>
