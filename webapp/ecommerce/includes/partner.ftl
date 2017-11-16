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
<div id="main-container" class="container">
  <div class="row">
    <div class="col-sm-12">
      <div class="panel panel-smart">
        <div class="panel-heading">
          <h1>${uiLabelMap.PFTSalesconditions}</h1>
        </div>
        <div class="screenlet-body">
          <p>${uiLabelMap.PFTSalescond}
           <br/><br/><a href="<@ofbizUrl>newsupplier</@ofbizUrl>" class="btn btn-main text-uppercase">${uiLabelMap.PFTClickToRegister}</a></p><br/><br/>
          <ul class="partnerconditions">
            <li class="partnerconditions">${uiLabelMap.PFTMaintainYourProductWithAnyCost}</li>
            <li class="partnerconditions">${uiLabelMap.PFTSupplierProvideInfomation}</li>
            <li class="partnerconditions">${uiLabelMap.PFTDeliveryWorldWideShouldBe15Day}</li>
            <li class="partnerconditions">${uiLabelMap.PFTSaleComeAndPaidSupplierSendToCustomerWith3Day}</li>
            <#-- <li class="partnerconditions">The supplier will enter in the system when the order is sent, and what it contains so the customer can be notified.</li> -->
            <li class="partnerconditions">${uiLabelMap.PFTSupplierWillPaidMonthly}</li>
          </ul>
          <br/><br/><h2>${uiLabelMap.PFTSupplierRegisterGuide}</h2></div><br/><br/>
          <table class="steps" cellspacing="0" width="100%">
              <tr>
                  <td><img class="stepSuppile" src="<@ofbizContentUrl>/pft-default/pftimages/Step1.png</@ofbizContentUrl>"/></td>
                  <td> <lable class="stepSuppile">${uiLabelMap.PFTSupplierHeadStep1}</lable>
                  <br><lable>${uiLabelMap.PFTSupplierStep1}</lable></br></td>
                </tr>
                <tr>
                  <td><img class="stepSuppile" src="<@ofbizContentUrl>/pft-default/pftimages/Step2.png</@ofbizContentUrl>"/></td>
                  <td> <lable class="stepSuppile">${uiLabelMap.PFTSupplierHeadStep2}</lable>
                  <lable><br>${uiLabelMap.PFTSupplierStep2}</br><lable></td>
                </tr>
                <tr>
                  <td><img class="stepSuppile" src="<@ofbizContentUrl>/pft-default/pftimages/Step3.png</@ofbizContentUrl>"/></td>
                  <td><lable class="stepSuppile">${uiLabelMap.PFTSupplierHeadStep3}</lable>
                  <br><lable>${uiLabelMap.PFTSupplierStep3}</lable></br></td>
                </tr>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
