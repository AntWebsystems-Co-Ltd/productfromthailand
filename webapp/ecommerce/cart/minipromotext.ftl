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
<div id="minipromotext" class="screenlet">
    <table cellspacing="0" cellpadding="0" border="0">
        <tbody>
            <tr>
                <td height="8" background="/pft/images/promo01.gif"></td>
            </tr>
            <tr>
                <td bgcolor="#D3C970"> 
                    <div class="screenlet-header">
                        <center><h3>${uiLabelMap.OrderSpecialOffers}</h3></center>
                    </div>
                </td>
            </tr>
            <tr>
                <td bgcolor="#D3C970">
                    <div class="screenlet-body">
                        <#-- show promotions text -->
                        <#list productPromos as productPromo>
                            <p>
                                <a href="<@ofbizUrl>showPromotionDetails?productPromoId=${productPromo.productPromoId}</@ofbizUrl>" class="linktext">${uiLabelMap.CommonDetails}</a>
                                ${StringUtil.wrapString(productPromo.promoText?if_exists)}
                            </p>
                            <#if productPromo_has_next>
                                <div><hr/></div>
                            </#if>
                        </#list>
                        <div><hr/></div>
                        <a href="<@ofbizUrl>showAllPromotions</@ofbizUrl>" class="buttontext">${uiLabelMap.OrderViewAllPromotions}</a>
                    </div>
                </td>
            </tr>
            <tr>
                <td height="7" background="/pft/images/promo02.gif"></td>
            </tr>
        </tbody>
    </table>
    <br>
    <table>
        <tbody>
            <tr>
                <td height="88" width="200" background="/pft/images/adver.gif"></td>
            </tr>
            <tr>
                <td height="215" width="200" background="/pft/images/adver02.gif"></td>
            </tr>
        </tbody>
    </table>
</div>
</#if>