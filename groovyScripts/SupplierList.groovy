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

pendingList = [];
approvelList = [];

suppliers = from("PartyRole").where("roleTypeId", "SUPPLIER").queryList();
if (suppliers) {
    suppliers.each {
        partyContent = from("PartyContent").where("partyId", it.partyId, "partyContentTypeId", "INTERNAL").filterByDate().queryFirst();
        if (partyContent) {
            listMap = [:];
            supplierName = null
            idNumber = null;
            email = null;

            getPartyNameForDate = dispatcher.runSync("getPartyNameForDate", [partyId: it.partyId, userLogin: userLogin]);
            if (getPartyNameForDate) {
                if (getPartyNameForDate.groupName) {
                    supplierName = getPartyNameForDate.groupName;
                } else {
                    supplierName = getPartyNameForDate.fullName;
                }
            }

            getIdNumber = from("PartyIdentification").where("partyId", it.partyId, "partyIdentificationTypeId", "ID_NUMBER").queryOne();
            if (getIdNumber) {
                idNumber = getIdNumber.idValue;
            }
            getIdBizNumber = from("PartyIdentification").where("partyId", it.partyId, "partyIdentificationTypeId", "ID_BIZ_REGISTER_NO").queryOne();
            if (getIdBizNumber) {
                idNumber = getIdBizNumber.idValue;
            }

            getPartyEmail = dispatcher.runSync("getPartyEmail", [partyId: it.partyId, userLogin: userLogin]);
            if (getPartyEmail && getPartyEmail.emailAddress) {
                email = getPartyEmail.emailAddress
            }

            listMap.put("partyId", it.partyId);
            listMap.put("supplierName", supplierName);
            listMap.put("idNumber", idNumber);
            listMap.put("email", email);
            listMap.put("contentId", partyContent.contentId)

            approvalSupplier = from("UserLoginAndSecurityGroup").where("partyId", it.partyId, "groupId", "MYPORTAL_SUPPLIER").filterByDate().queryList();
            if (approvalSupplier) {
                approvelList.add(listMap)
            } else {
                isReject = from("PartyNoteView").where("targetPartyId", it.partyId, "noteName", "Reject Reason").queryFirst();
                if (!isReject) {
                    pendingList.add(listMap)
                }
            }
        }
    }
}

context.pendingList = pendingList;
context.approvelList = approvelList;
