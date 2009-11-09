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

    <h3>${uiLabelMap.PFTUploadProduct}</h3>
    <form method="post" enctype="multipart/form-data" action="<@ofbizUrl>UploadProductFromSpreadsheet</@ofbizUrl>" name="productsUploadForm">
        <input type="hidden" name="supplierPartyId" value="${partyId?if_exists}"/>
        <input type="hidden" name="bbbb" value="1111111"/>
        <table cellspacing="0" class="basic-table">
            <tr>
                <td width="20%" align="right" valign="top">
                    <input type="file" size="50" name="fname"/>
                </td>
                <td>&nbsp;</td>
                <td width="80%" colspan="4" valign="top">
                    <input type="submit" class="smallSubmit" value="${uiLabelMap.PFTUploadProduct}"/>
                </td>
            </tr>
        </table>
    </form>
