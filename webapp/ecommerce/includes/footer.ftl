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
        <nav class="dummy"></nav>
        <nav class="footer-column">
            <h3>Browse <span>Categories</span></h3>
            <ul>
                <li>
                    <a href="#">Category 1</a>
                </li>
                <li>
                    <a href="#">Category 2</a>
                </li>
                <li>
                    <a href="#">Category 3</a>
                </li>
                <li>
                    <a href="#">Category 4</a>
                </li>
            </ul>
        </nav>
        <nav class="footer-column">
            <h3>HELP <span>& Support</span></h3>
            <ul>
                <li>
                    <a href="#">Support 1</a>
                </li>
                <li>
                    <a href="#">Support 2</a>
                </li>
                <li>
                    <a href="#">Support 3</a>
                </li>
                <li>
                    <a href="#">Support 4</a>
                </li>
            </ul>
        </nav>
        <nav class="footer-column">
            <div class="input-group input-group-md">
              <input type="text" class="form-control" placeholder="Email Address">
              <span class="input-group-addon">Subscribe</span>
            </div>
            <ul class="social-icon">
                <a href="#" class="social"><i class="fa fa-facebook" aria-hidden="true"></i></a>
                <a href="#" class="social"><i class="fa fa-twitter" aria-hidden="true"></i></a>
                <a href="#" class="social"><i class="fa fa-google-plus" aria-hidden="true"></i></a>
            </ul>
        </nav>
        <nav class="dummy"></nav>
    </div>
</div>
<div class="copyright-section">
    <br/>
    <div class="copyright">Copyright © ${nowTimestamp?string("yyyy")} <a href="http://www.productfromthailand.com" style="" target="_blank">productfromthailand.com</a> All Rights Reserved</div>
    <br/><br/>
</div>
</center>
</body>
</html>
