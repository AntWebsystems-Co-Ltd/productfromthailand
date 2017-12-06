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
    <div class="col-sm-12">
      <div class="panel-smart">
      <#-- Do this so that we don't have to find the content twice (again in renderSubContent) -->
      <#assign subContentId=requestParameters.contentId?if_exists/>
      <#assign nodeTrailCsv=requestParameters.nodeTrailCsv?if_exists/>
      <#-- <#assign dummy=Static["org.apache.ofbiz.base.util.Debug"].logInfo("in viewcontent, nodeTrailCsv:" + nodeTrailCsv, "")/> -->
      <#if ancestorList?has_content && (0 < ancestorList?size) >
          <#assign lastContent=ancestorList?last />
              <#if locale != "en">
                <#assign lastContent = Static["org.apache.ofbiz.content.content.ContentWorker"].findAlternateLocaleContent(delegator, lastContent, locale)/>
              </#if>
          <#assign firstContent=ancestorList[0] />
      </#if>
      <#if firstContent?has_content>
          <#assign siteId = firstContent.contentId/>
      </#if>
      <#if siteId?has_content>
          <@renderAncestryPath trail=ancestorList?default([]) endIndexOffset=1 siteId=siteId/>
      </#if>

      <#if lastContent?has_content>
        <div class="panel-heading">
          <h1>${lastContent.description}</h1>
        </div>
      </#if>

      <#if globalNodeTrail?has_content && (0 < globalNodeTrail?size) >
          <#assign lastNode = globalNodeTrail?last/>
          <#if lastNode?has_content>
            <#assign subContent=lastNode.value/>
          </#if>
      <#else>
          <#assign subContent = delegator.findByPrimaryKeyCache("Content", Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("contentId", subContentId))/>
      </#if>
      <#assign dummy=Static["org.apache.ofbiz.base.util.Debug"].logInfo("in viewcontent, subContent:" + subContent, "")/>
      <#--h1>${uiLabelMap.EcommerceContentFor} [${subContentId}] ${subContent.contentName?if_exists} - ${subContent.description?if_exists}:</h1><br/-->
      <div class="panel-body" style="color: #838383;">
        <@renderSubContentCache subContentId=subContentId />
        <#assign thisContentId = subContentId/>
        <@loopSubContent contentId=thisContentId viewIndex=0 viewSize=9999 contentAssocTypeId="RELATED_CONTENT">
          <#assign thisNodeTrailCsv = nodeTrailCsv />
              <a class="tabButton" href="<@ofbizUrl>viewcontent?contentId=${subContentId}&amp;nodeTrailCsv=${thisNodeTrailCsv?if_exists}</@ofbizUrl>" >${content.contentName?if_exists}</a>
        </@loopSubContent>
    </div>
      <#--
      <@checkPermission mode="not-equals" subContentId=subContentId targetOperation="CONTENT_CREATE|CONTENT_RESPOND" contentPurposeList="RESPONSE" >
                  ${permissionErrorMsg?if_exists}
      </@checkPermission>
      -->

      </div>
    </div>
  </div>
</div>

<#macro renderAncestryPath trail siteId startIndex=0 endIndexOffset=0 buttonTitle="Back to" searchOn="" >
    <#local indent = "">
    <#local csv = "">
    <#local counter = 0>
    <#local len = trail?size>
    <table border="0" class="tabletext" cellspacing="4">
    <#list trail as content>
      <#if counter < (len - endIndexOffset) && startIndex <= counter >
        <#if 0 < counter >
            <#local csv = csv + ","/>
        </#if>
        <#local csv = csv + content.contentId/>
        <#if counter < len && startIndex <= counter >
       <tr>
         <td>
            ${indent}
            <#if content.contentTypeId == "WEB_SITE_PUB_PT" >
              <a class="tabButton" href="<@ofbizUrl>showcontenttree?contentId=${content.contentId?if_exists}&nodeTrailCsv=${csv}</@ofbizUrl>" >${uiLabelMap.CommonBackTo}</a> &nbsp;${content.contentName?if_exists}
            <#else>
              <a class="tabButton" href="<@ofbizUrl>viewcontent?contentId=${content.contentId?if_exists}&nodeTrailCsv=${csv}</@ofbizUrl>" >${uiLabelMap.CommonBackTo}</a> &nbsp;${content.contentName?if_exists}
            </#if>
            <#local indent = indent + "&nbsp;&nbsp;&nbsp;&nbsp;">
            [${content.contentId?if_exists}]
            <#if searchOn?has_content && searchOn?lower_case == "true">
                &nbsp;
              <a class="tabButton" href="<@ofbizUrl>searchContent?siteId=${siteId?if_exists}&nodeTrailCsv=${csv}</@ofbizUrl>" >${uiLabelMap.CommonSearch}</a>
            </#if>
        </#if>
         </td>
       </tr>
      </#if>
      <#local counter = counter + 1>
    <#if 20 < counter > <#break/></#if>
    </#list>
    </table>
</#macro>