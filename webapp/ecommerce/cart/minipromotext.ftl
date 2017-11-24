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

<#if showPromoText>
<h3 class="side-heading">${uiLabelMap.OrderSpecialOffers}</h3>
<div class="list-group" id="list-group-promo">
    <div class="list-group-item" id="promotionslist">
        <#list productPromos as productPromo>
            <a href="<@ofbizUrl>showPromotionDetails?productPromoId=${productPromo.productPromoId}</@ofbizUrl>" class="linktext"><b>${uiLabelMap.CommonDetails}</b></a>
            <#assign promoText = StringUtil.wrapString(productPromo.promoText?if_exists)>
            <#if promoText??>
                <#if promoText?length &gt; 70>${promoText?substring(0, 70)}...<#else>${promoText}</#if>
            </#if>
            <#if productPromo_has_next>
               <hr/>
            </#if>
        </#list>
    </div>
    <div class="list-group-item">
        <a href="<@ofbizUrl>showAllPromotions</@ofbizUrl>" class="btn btn-main">${uiLabelMap.OrderViewAllPromotions}</a>
    </div>
</div>
</#if>
