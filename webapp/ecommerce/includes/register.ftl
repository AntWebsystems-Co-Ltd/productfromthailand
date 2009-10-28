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
     <h1>${uiLabelMap.PFTRegister} </h1><br/>
     ${uiLabelMap.PFTRegisterIntro}
     <br/><br/>
    <div class="screenlet-body">
       <div class="register" id="leftblock">
       <fieldset class="reg" align="baseline">
            <ul>
                <li>Update Profile</li>
                <li>See All order History</li>
                <li>Tell your friend about the products</li>
                <li>Rate and Comment Products</li>
            </ul>
            <legend>Register As customer</legend>
        <div class="regBtt">
        <a href="<@ofbizUrl>newcustomer</@ofbizUrl>" alt="${uiLabelMap.PFTRegister}">
        ${uiLabelMap.PFTRegister}
        </a>
        </div> 
      </fieldset>
       </div>
       <div class="register" id="rightblock">
        <fieldset class="reg">
            <legend>Register As Provider</legend>
            <ul>
                <li>Maintain your own products at our website without any further costs.</li>
                <li>The supplier will be notified by email when a sale cames in.</li>
                <li> The supplier will provide product information with at least one picture, title, longer description and price.</li>
                
            </ul>
        <div class="regBtt">
        <a href="<@ofbizUrl>newsupplier</@ofbizUrl>" alt="${uiLabelMap.PFTRegister}">
        ${uiLabelMap.PFTRegister}
        </a>
        </div> 
      </fieldset>
       </div>
    </div>
</div>