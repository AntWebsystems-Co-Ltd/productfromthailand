/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import org.apache.ofbiz.party.content.PartyContentWrapper
import org.apache.ofbiz.entity.util.EntityUtilProperties
import org.apache.ofbiz.common.email.NotificationServices


website = from("WebSite").where("webSiteId", parameters.webSiteId).queryOne();
NotificationServices.setBaseUrl(delegator, website.webSiteId, context);
if(website){
    productStore = from("ProductStore").where("productStoreId", website.productStoreId).queryOne();
    partyId = productStore.payToPartyId;

    partyGroup = from("PartyGroup").where("partyId", partyId).queryOne();
    if (partyGroup) {
        partyContentWrapper = new PartyContentWrapper(dispatcher, partyGroup, locale, EntityUtilProperties.getPropertyValue("content", "defaultMimeType", "text/html; charset=utf-8", delegator));
        partyContent = partyContentWrapper.getFirstPartyContentByType(partyGroup.partyId , partyGroup, "LGOIMGURL", delegator);
        if (partyContent) {
            content = from("Content").where("contentId", partyContent.contentId).queryOne();
            if(content){
                dataResource = from("DataResource").where("dataResourceId", content.dataResourceId).queryOne();

                logoImageUrl = (String) dataResource.objectInfo;
                logoImageUrl = "/" + logoImageUrl.substring(39);
            }
        }
    }
}

if (logoImageUrl) {
    logoImageUrl = baseUrl+logoImageUrl;
}
context.baseURL = baseUrl;
context.logoImageUrl = logoImageUrl;