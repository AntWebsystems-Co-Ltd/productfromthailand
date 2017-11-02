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

<#-- Breadcrumb Starts -->
    <ol class="breadcrumb">
        ${screens.render(breadcrumbs)}
    </ol>
<#-- Breadcrumb Ends -->
<#-- Main Heading Starts -->
    <h2 class="main-heading2">
        <#assign categoryName = categoryContentWrapper.get("CATEGORY_NAME", "html")!/>
        <#if categoryName?has_content>
            ${categoryName}
        </#if>
    </h2>
<#-- Main Heading Ends -->
<#assign categoryImageUrl = categoryContentWrapper.get("CATEGORY_IMAGE_URL", "url")!/>
<#assign longDescription = categoryContentWrapper.get("LONG_DESCRIPTION", "html")!/>
<#-- Category Intro Content Starts -->
    <div class="row cat-intro">
        <#if categoryImageUrl?default("") != "">
        <div class="col-sm-3">
            <img src="<@ofbizContentUrl>${categoryImageUrl}</@ofbizContentUrl>" alt="Image" class="img-responsive img-thumbnail" />
        </div>
        </#if>
        <div class="col-sm-8 <#if categoryImageUrl?default("") != "">cat-body</#if>">
            <#assign categoryDescription = categoryContentWrapper.get("DESCRIPTION", "html")!/>
            <#if categoryDescription?has_content>
            <p>${categoryDescription}</p>
            </#if>
        </div>
    </div>
<#-- Category Intro Content Ends -->
