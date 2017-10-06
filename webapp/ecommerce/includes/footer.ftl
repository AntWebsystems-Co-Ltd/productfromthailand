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

<#assign nowTimestamp = Static["org.apache.ofbiz.base.util.UtilDateTime"].nowTimestamp()>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<div class="footer-section">
    <div>
        <nav class="footer-column">
            <h3>HELP & Support</h3>
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
        </nav>
        <div class="headerAlert headerhide">&nbsp;</div>
        <nav class="footer-column">
            <div class="input-group input-group-md" id="emailSubscribe">
              <form method="post" name="signUpForContactListForm" id="signUpForContactListForm">
                <input type="hidden" name="contactListId" value="${webSiteId?if_exists}"/>
                <input type="text" class="form-control" placeholder="Email Address" id="subscribeEmail">
              </form>
              <a href="javascript: fixedsub(this);" class="input-group-addon" id="subscribBtn" >Subscribe</a>
            </div>
            <ul class="social-icon" id="socialApplication">
                <a href="https://www.facebook.com/Careelnatural/" class="social-icon-facebook"><i class="fa fa-facebook" aria-hidden="true"></i></a>
                <a href="https://twitter.com/Product_Thai/" class="social-icon-twitter"><i class="fa fa-twitter" aria-hidden="true"></i></a>
                <a href="#" class="social-icon-google"><i class="fa fa-google-plus" aria-hidden="true"></i></a>
            </ul>
        </nav>
    </div>
</div>
<div class="copyright-section">
    <br/>
    <div class="copyright">Copyright © ${nowTimestamp?string("yyyy")} <a href="http://www.productfromthailand.com" style="" target="_blank">productfromthailand.com</a> All Rights Reserved</div>
    <br/><br/>
</div>
</center>
<script>
    function fixedsub(button) {
        button.disabled = true;
        var email = $("#subscribeEmail").val();
        var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9])+$/;
        if(!regex.test(email) || email == '' || email == null) {
            headerAlertMsg("${uiLabelMap.GrowErpSubscribeNotValid}",1);
            setTimeout(function(){
                button.disabled = false;
            }, 2000);
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
                            headerAlertMsg("${uiLabelMap.GrowErpSubscribeNotValid}",1);
                        } else {
                            headerAlertMsg(data._ERROR_MESSAGE_,1);
                        }
                        setTimeout(function(){
                            button.disabled = false;
                        }, 2000);
                    } else if (data._ERROR_MESSAGE_LIST_ != null) {
                        headerAlertMsg(data._ERROR_MESSAGE_LIST_[0],1);
                        setTimeout(function(){
                            button.disabled = false;
                        }, 2000);
                    } else if (data._EVENT_MESSAGE_LIST_ != null) {
                        headerAlertMsg(data._EVENT_MESSAGE_LIST_[0],2);
                        setTimeout(function(){
                            button.disabled = false;
                        }, 2000);
                    }
                }
            });
            return true;
        }
    }
    function headerAlertMsg(headerMessage,mode){
    /*
        headerMessage is income message to headerAlert
        mode will chose class to add
            1 is error
            2 is success
    */
        if(headerMessage != "") {
            jQuery('.headerAlert').html(headerMessage);
        }
        jQuery('.headerAlert').removeClass("success");
        jQuery('.headerAlert').removeClass("error");
        jQuery('.headerAlert').removeClass("headerhide");
        jQuery('.headerAlert').click(function() {
            jQuery('.headerAlert').addClass("headerhide");
        });
        if(mode == 1) {
            jQuery('.headerAlert').addClass("error");
        } else if(mode == 2) {
            jQuery('.headerAlert').addClass("success");
        }
    }
</script>
</body>
</html>
