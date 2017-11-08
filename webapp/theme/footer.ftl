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

<#-- Footer Section Starts -->
    <footer id="footer-area" class="container">
    <#-- Footer Links Starts -->
        <div class="footer-links">
        <#-- Container Starts -->
            <div class="row">
                <#-- Information Links Starts -->
                    <div class="col-md-4 col-sm-6">
                        <h5>${uiLabelMap.PFTInformation}</h5>
                        <ul>
                        <#assign contentRootId = "HELPROOT"/>
                        <#assign contentAssocTypeId = "SUB_CONTENT"/>
                        <#assign count_1=0/>
                        <#assign contentAssocs  = delegator.findByAnd("ContentAssoc",Static["org.apache.ofbiz.base.util.UtilMisc"].toMap("contentId",contentRootId,"contentAssocTypeId", contentAssocTypeId), ["sequenceNum"], false)/>
                              <#if (contentAssocs?has_content)>
                                <#list contentAssocs as assoc>
                                    <#assign content  = delegator.findOne("Content",{"contentId":assoc.contentIdTo},true)/>
                                    <#if locale != "en">
                                        <#assign content = Static["org.apache.ofbiz.content.content.ContentWorker"].findAlternateLocaleContent(delegator, content, locale)/>
                                    </#if>
                                    <li>
                                        <a href="<@ofbizUrl>showhelpcontent?contentId=${assoc.contentIdTo}&amp;nodeTrailCsv=${assoc.contentIdTo}</@ofbizUrl>">${content.description}</a>
                                    </li>
                                    <#assign count_1=(count_1 + 1)/>
                                </#list>
                            </#if>
                        </ul>
                    </div>
                <#-- Information Links Ends -->
                <#-- Follow Us Links Starts -->
                    <div class="col-md-3 col-sm-6" align="center">
                        <h5>${uiLabelMap.PFTFollowUs}</h5>
                        <ul>
                            <li><a href="https://www.facebook.com/Careelnatural/" class="social-icon-facebook"><i class="fa fa-facebook" aria-hidden="true"></i></a>
                            <a href="https://twitter.com/Product_Thai/" class="social-icon-twitter"><i class="fa fa-twitter" aria-hidden="true"></i></a>
                            <a href="#" class="social-icon-google"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                        </ul>
                        <ul>
                            <img src="/pft-default/pftimages/LOGO_AUTHENTIC_2.png" style="" width="130px">
                        </ul>
                    </div>
                <#-- Follow Us Links Ends -->
                <#-- Last Colum Start -->
                    <div class="col-md-5 col-sm-12 last">
                        <h5>${uiLabelMap.EcommerceSubscribe}</h5>
                            <div class="input-group input-group-md" id="emailSubscribe">
                              <form method="post" name="signUpForContactListForm" id="signUpForContactListForm">
                                <input type="hidden" name="contactListId" value="${webSiteId?if_exists}"/>
                                <input type="text" name="emailAddress" class="form-control" placeholder="Email Address" id="subscribeEmail">
                              </form>
                              <a href="javascript: fixedsub(this);" class="input-group-addon" id="subscribBtn" >Subscribe</a>
                            </div>
                        <br/>
                        <h5>${uiLabelMap.PFTContact}</h5>
                        <ul>
                            <#if address.address1?has_content>
                                <li>
                                    ${address.address1} <br>
                                    ${address.city!}  ${address.postalCode!}
                                </li>
                            </#if>
                            <#if orgEmail.emailAddress?has_content>
                                <li>
                                    Email: ${orgEmail.emailAddress}
                                </li>
                            </#if>
                        </ul>
                        <#if telephone.contactNumber?has_content>
                            <h4 class="lead">
                                Tel: <span>(${telephone.countryCode}) ${telephone.areaCode}-${telephone.contactNumber}</span>
                            </h4>
                        </#if>
                    </div>
                <#-- Last Colum Ends -->
            </div>
        <#-- Container Ends -->
        </div>
    <#-- Footer Links Ends -->
    <#-- Copyright Area Starts -->
        <div class="copyright">
        <#-- Container Starts -->
            <div class="clearfix">
            <#-- Starts -->
                <p class="pull-left">
                    Copyright <i class="fa fa-copyright" aria-hidden="true"></i> 2017 <a href="http://www.productfromthailand.com">productfromthailand.com</a> All Rights Reserved.
                </p>
            <#-- Ends -->
            <#-- Payment Gateway Links Starts -->
                <ul class="pull-right list-inline">
                    <li>
                        <img src="/theme/images/payment-icon/paypal.png" alt="PaymentGateway">
                    </li>
                </ul>
            <#-- Payment Gateway Links Ends -->
            </div>
        <#-- Container Ends -->
        </div>
    <#-- Copyright Area Ends -->
    </footer>
<#-- Footer Section Ends -->
<#-- JavaScript Files -->
<#-- <#if layoutSettings.javaScripts?has_content>
    <#assign javaScriptsSet = Static["org.apache.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
    <#list layoutSettings.javaScripts as javaScript>
        <#if javaScriptsSet.contains(javaScript)>
            <#assign nothing = javaScriptsSet.remove(javaScript)/>
            <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="text/javascript"></script>
        </#if>
    </#list>
</#if> -->
<script>
    function fixedsub(button) {
        button.disabled = true;
        var email = $("#subscribeEmail").val();
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9])+$/;
        var alertmsg = "";
        if(!regex.test(email) || email == '' || email == null) {
            alertmsg = "${uiLabelMap.GrowErpSubscribeNotValid}";
            setTimeout(function(){
                button.disabled = false;
            }, 2000);
            alert(alertmsg);
            return false;
        }
        else {
            waitSpinnerShow();
            data = "contactListId=${webSiteId!}&email="+email
            jQuery.ajax({
                url: 'signUpForContactList',
                type: 'POST',
                data: data,
                success: function(data) {
                    waitSpinnerHide();
                    if (data._ERROR_MESSAGE_ != null) {
                        if (data._ERROR_MESSAGE_ == "Invalid email address entered.") {
                            alertmsg = "${uiLabelMap.GrowErpSubscribeNotValid}";
                        } else {
                            alertmsg = data._ERROR_MESSAGE_;
                        }
                    } else if (data._ERROR_MESSAGE_LIST_ != null) {
                        alertmsg = data._ERROR_MESSAGE_LIST_[0];
                    } else if (data._EVENT_MESSAGE_LIST_ != null) {
                        alertmsg = data._EVENT_MESSAGE_LIST_[0];
                    }
                    setTimeout(function(){
                        button.disabled = false;
                    }, 2000);
                    alert(alertmsg);
                }
            });
            return true;
        }
    }
</script>
</body>
</html>
