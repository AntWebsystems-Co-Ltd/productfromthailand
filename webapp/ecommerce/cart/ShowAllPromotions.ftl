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

<div id="main-container" class="container">
    <div class="row">
        <div class="col-md-12 col-xs-12">
            <div class="panel-smart">
                <div class="panel-heading">
                    <h3 class="panel-title">${uiLabelMap.OrderSpecialOffers}</h3>
                </div>
                <div class="list-group">
                    <div class="list-group-item" id="showallpromo">
                        <#-- show promotions text -->
                        <#list productPromosAllShowable as productPromo>
                            <a href="<@ofbizUrl>showPromotionDetails?productPromoId=${productPromo.productPromoId}</@ofbizUrl>" class="btn btn-main">${uiLabelMap.CommonDetails}</a>
                            &nbsp;&nbsp;&nbsp;${StringUtil.wrapString(productPromo.promoText!)}
                            <#if productPromo_has_next>
                                <hr/>
                            </#if>
                        </#list>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<#-- <#if (shoppingCartSize > 0)>
  ${screens.render(promoUseDetailsInlineScreen)}
</#if> -->
