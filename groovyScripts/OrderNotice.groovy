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

orderHeader = from("OrderHeader").where("orderId", parameters.orderId).queryOne()
if(orderHeader.orderTypeId.equals("SALES_ORDER")) {
    webSiteId = orderHeader.webSiteId;
}else {
    orderItemAssoc = from("OrderItemAssoc").where("toOrderId", parameters.orderId).queryFirst();
    orderHeaderSale = from("OrderHeader").where("orderId", orderItemAssoc.orderId).queryOne()
    webSiteId = orderHeaderSale.webSiteId;
}
if(!webSiteId) {
    webSiteContent = from("WebSiteContent").where("webSiteContentTypeId", "FRONTEND_URL").queryFirst();
    webSiteId = webSiteContent.webSiteId;
}
if (orderHeader) {
    website = from("WebSite").where("webSiteId", webSiteId).queryOne();
    if (website){
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

        /* BaseUrl */
        if (website.httpsHost) {
            if ("localhost".equals(website.httpsHost)) {
                baseUrl = "https://" + website.httpsHost + ":" +website.httpsPort;
            } else {
                baseUrl = "https://" + website.httpsHost;
            }
        } else {
            NotificationServices.setBaseUrl(delegator, website.webSiteId, context)
            baseUrl = context.baseUrl
            baseSecureUrl = context.baseSecureUrl
        }

        if (logoImageUrl) {
            logoImageUrl = baseUrl + logoImageUrl;
        }
    }
}
context.baseUrl = baseUrl;
context.logoImageUrl = logoImageUrl;
