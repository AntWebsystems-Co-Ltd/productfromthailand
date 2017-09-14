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
<div id="contentbox" class="screenlet">
     <h1>${uiLabelMap.PFTServices} </h1>
    <p>If you could not find the products you want please fill in the request form below.</p>
</div>
<form method="post" action="<@ofbizUrl>createrequest</@ofbizUrl>" name="EditRequestCustomer" id="EditRequestCustomer">
    <input type="hidden" name="statusId" value="CRQ_SUBMITTED"/>
    <input type="hidden" name="fromPartyId" value="${userLogin.partyId}"/>

    <table cellspacing="0" class="basic-table">
        <tr>
            <td class="label">${uiLabelMap.CommonPriority}</td>
            <td>
                <select name="priority" size="1">
                    <option value="">&nbsp;</option>
                    <option value="1(Highest)">1&#40;Highest&#41;</option> 
                    <option value="2">2</option> 
                    <option value="3">3</option> 
                    <option value="4">4</option> 
                    <option value="5">5</option> 
                    <option value="6">6</option> 
                    <option value="7">7</option> 
                    <option value="8">8</option> 
                    <option value="9(Lowest)">9&#40;Lowest&#41;</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="label">${uiLabelMap.FormFieldTitle_responseRequiredDate}</td>
            <td>
                <input type="text" name="responseRequiredDate" id="responseRequiredDate" size="25" maxlength="30"/>
                <a href="javascript:call_cal(document.EditRequestCustomer.responseRequiredDate, '${Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp()}');">
                <img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
            </td>
    
        </tr>
        <tr>
            <td class="label">${uiLabelMap.FormFieldTitle_subject}</td>
            <td><input type="text" name="custRequestName" size="25" autocomplete="off"/></td>
        </tr>
        <tr>
            <td class="label">${uiLabelMap.CommonContent}</td>
            <td><textarea name="description" cols="60" rows="15"></textarea></td>
        
        </tr>
        <tr>
            <td class="label">${uiLabelMap.CommonType}</td>
            <td>
                <select name="custRequestTypeId" size="1">
                    <#list custRequestTypeList as custRequestType>
                        <option value="${custRequestType.custRequestTypeId}">${custRequestType.description}</option>
                    </#list>
                </select>
            </td>
        </tr>
        <tr>
            <td class="label">&nbsp;</td>
            <td colspan="4"><input type="submit" class="smallSubmit" name="submitButton" value="${uiLabelMap.CommonSubmit}"/></td>
        </tr>
    </table>
</form>