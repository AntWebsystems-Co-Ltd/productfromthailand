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

<#assign nowTimestamp = Static["org.ofbiz.base.util.UtilDateTime"].nowTimestamp()>
                        <center><hr width="740"/></center>
                        <table  align="center">
                            <tbody>
                                <tr>
                                    <td  align="center">
                                        <h4>${uiLabelMap.PartyPhoneNumber}: +66-53 483245, ${uiLabelMap.PartyFaxNumber} : +66-53 483246, ${uiLabelMap.PartyEmailAddress} : info@productfromthailand.com</h4>
                                    </td>
                                </tr>
                                <tr>
                                    <td  align="center">
                                        <h4><a href="http://www.antwebsystems.com">${uiLabelMap.PFTCompanyName} ${uiLabelMap.PFTCompanyAddress} <a></h4>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td background="/pft/images/bg02.gif" width="800" height="18" align="center" valign="bottom"></td>
                </tr>
            </tbody>
        </table>
     </div>
</div>
<div id="ecom-footer">
  <br/>
  <div align="center">
    <a href="http://jigsaw.w3.org/css-validator/"><img style="border:0;width:88px;height:31px" src="<@ofbizContentUrl>/images/vcss.gif</@ofbizContentUrl>" alt="Valid CSS!"/></a>
    <a href="http://validator.w3.org/check?uri=referer"><img style="border:0;width:88px;height:31px" src="<@ofbizContentUrl>/images/valid-xhtml10.png</@ofbizContentUrl>" alt="Valid XHTML 1.0!"/></a>
  </div>
  <br/>
  <div class="tabletext" align="center">
    <div class="tabletext">Copyright (c) 2001-${nowTimestamp?string("yyyy")} The Apache Software Foundation - <a href="http://www.apache.org" class="tabletext" target="_blank">www.apache.org</a></div>
    <div class="tabletext">Powered by <a href="http://ofbiz.apache.org" class="tabletext" target="_blank">Apache OFBiz</a></div>
  </div>
  <br/>
  <div class="tabletext" align="center"><a href="<@ofbizUrl>policies</@ofbizUrl>">${uiLabelMap.EcommerceSeeStorePoliciesHere}</a></div>
</div>
</center>
</body>
</html>
