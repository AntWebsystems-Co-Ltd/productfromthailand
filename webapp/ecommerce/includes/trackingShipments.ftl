
<#--Licensed to the Apache Software Foundation (ASF) under one
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
<#assign fedExReply = requestAttributes.fedExReply!>
<script>
<#-- trackingShipments script -->
    function trackingShipments() {

        var trakingNumber = $("#TrakingNumber").val();
        var trakingNumberLength = trakingNumber.length;
        if($('#couriers:checked').val() == "thaiPost") {
            if (trakingNumberLength != 13) {
                alert("Tracking number need to be 13 digits");
            } else {
                $("#TextBarcodeThaiPost").val(trakingNumber);
                $('#trackThaiPost').submit();
            }
        } else if ($('#couriers:checked').val() == "fedEx") {
            if (trakingNumberLength == 12
                || trakingNumberLength == 14
                || trakingNumberLength == 15
                || trakingNumberLength == 20
                || trakingNumberLength == 22) {
                $("#trackNumbersFedEx").val(trakingNumber);
                $('#trackFedEx').submit();
            } else {
                alert("Tracking number need to be 12, 14, 15, 20, 22 digits");
            }
        }
    }
 </script>
<#-- Main Container Starts -->
    <div id="main-container" class="container">
    <#-- Main Heading Ends -->
        <div class="panel-smart">
            <div class="panel-heading">
                <h2 class="main-heading text-center">
                    ${uiLabelMap.PFTTrackingShipment}
                </h2>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-sm-3"></div>
                    <div class=" col-sm-6">
                        <div class="input-group input-group-md">
                            <form name="trackingShipments" id="trackingShipments" method="post" action="javascript: trackingShipments();" style="margin: 0;">
                                <input type="text" id="TrakingNumber" name="TrakingNumber" class="form-control" placeholder="Tracking Number">
                            </form>
                            <a href="javascript: trackingShipments();" class="input-group-addon" id="trackBtn">Track</a>
                        </div>
                        <div style="margin: 12px 0 0 7px;">
                            <div><input type="radio" name="couriers" id="couriers" value="thaiPost" <#if !fedExReply?has_content>checked</#if>> Thailand Post</div>
                            <div><input type="radio" name="couriers" id="couriers" value="fedEx"<#if fedExReply?has_content>checked</#if>> FedEx</div>
                        </div>
                        <form id="trackThaiPost" action="http://track.thailandpost.co.th/tracking/default.aspx" method="post" target="_blank" class="hide">
                            <input type="hidden" name="CaptchaCTL1$submit" value="Submit Query" />
                            <input type="hidden" id="TextBarcodeThaiPost" name="TextBarcode" value="" />
                            <input type="hidden" name="__EVENTARGUMENT" value="" />
                            <input type="hidden" name="__EVENTTARGET" value="" />
                            <input type="hidden" name="__VIEWSTATE" value="" />
                            <input type="hidden" name="__VIEWSTATEGENERATOR" value="" />
                            <input type="hidden" name="textkey" value="" />
                            <input type="hidden" name="pwThaiPost" value="" />
                        </form>
                        <form id="trackFedEx" action="https://www.fedex.com/apps/fedextrack/index.html" method="get" target="_blank" class="hide">
                            <input type="hidden" name="action" value="track" />
                            <input type="hidden" id="trackNumbersFedEx" name="tracknumbers" value="" />
                        </form>
                        <#--
                        <form id="trackFedEx" action="<@ofbizUrl>trackFedEx</@ofbizUrl>" method="post" target="_blank" class="hide">
                            <input type="hidden" id="trackNumbersFedEx" name="tracknumbers" value="" />
                        </form>
                        -->
                    </div>
                    <div class="col-sm-3"></div>
                </div>
            </div>
        </div>
    </div>
<#-- Main Container Ends -->
