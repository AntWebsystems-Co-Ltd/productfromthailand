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

<div id="keywordsearchbox" class="screenlet">
    <div class="screenlet-header">
       <table width="100%">
           <tbody>
               <tr>
                   <td align="right" width="450px" valign="top"><div class="boxhead_sb">${uiLabelMap.PFTSelectByCategories} :</div></td>
                   <td align="right" width="260px" valign="top"><div class="boxhead_sb">${uiLabelMap.PFTEnterKeyword} :</div></td>
               </tr>
               <tr>
                    <form name="keywordsearchform" method="post" action="<@ofbizUrl>keywordsearch</@ofbizUrl>">
                      <input type="hidden" name="VIEW_SIZE" value="10"/>
                      <input type="hidden" name="PAGING" value="Y"/>
                      <input type="hidden" name="SEARCH_OPERATOR" value="OR"/>
                      <input type="hidden" name="SEARCH_CATALOG_ID" value="${currentCatalogId?if_exists}"/>
                   <td align="right" valign="top">
                   <#if 0 < allProductCategories?size>
                        <div>
                          <select name="SEARCH_CATEGORY_ID" size="1">
                            <option value="${searchCategoryId?if_exists}">${uiLabelMap.PFTInAllCategories}</option>
                            <#list allProductCategories as allProductCategory>
                              <#assign searchProductCategory = allProductCategory.getRelatedOneCache("CurrentProductCategory")>
                              <#if searchProductCategory?exists>
                                <option value="${searchProductCategory.productCategoryId}">${searchProductCategory.description?default("No Description " + searchProductCategory.productCategoryId)}</option>
                              </#if>
                            </#list>
                          </select>
                        </div>
                  <#else>
                       <input type="hidden" name="SEARCH_CATEGORY_ID" value="${searchCategoryId?if_exists}"/>
                  </#if>
                   </td>
                   <td align="right" valign="top">
                    <input type="text" name="SEARCH_STRING" size="25" maxlength="50" value="${requestParameters.SEARCH_STRING?if_exists}"/>
                    <input type="submit" class="smallSubmit" value="${uiLabelMap.CommonFind}"/>
                   </td>
                   </form>
               </tr>
           </tbody>
       </table>
          
    </div>
</div>