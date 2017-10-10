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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title>${title?if_exists}</title>
  <style type="text/css">
    td {
      color: #777777;
    }

    .bg-top {
      background:repeat-x url(${baseURL}/pft-default/pftimages/bg_top.jpg) #ffffff;
    }

    .header-social{
      text-align: center;
      vertical-align:middle;
    }

    .header-logo {
      vertical-align:middle;
    }

    .footer {
      background-color: #f7f7f7;
      height: 100px;
    }

    .footer-address {
      padding: 25px 0 25px
    }

    .blank_row {
      height: 10px !important; /* overwrites any other rules */
    }
  </style>
</head>
<body bgcolor="#f7f7f7">
<table align="center" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td align="left" valign="top" width="100%" class="bg-top">
      <center>
      <img src="${baseURL}/pft-default/pftimages/transparent.png">
        <table cellspacing="0" cellpadding="0" width="100%" background="${baseURL}/pft-default/pftimages/bg_top.jpg">
          <tr>
            <td width="100%" height="80" valign="top" lass="header-social">
              <center>
                <table cellpadding="0" cellspacing="0" width="600">
                  <tr>
                    <td class="header-logo">
                      <a href=""><img width="137" height="47" src="${logoImageUrl}" alt="logo"/></a>
                    </td>
                    <td>
                      <a href="https://twitter.com/Product_Thai/"><img width="44" height="47" src="${baseURL}/pft-default/pftimages/social_twitter.gif" alt="twitter"/></a>
                      <a href="https://www.facebook.com/Careelnatural/"><img width="38" height="47" src="${baseURL}/pft-default/pftimages/social_facebook.gif" alt="facebook"/></a>
                    </td>
                  </tr>
                </table>
              </center>
            </td>
          </tr>
        </table>
      </center>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="100%" bgcolor="#f7f7f7">
      <center>
        <table cellspacing="0" cellpadding="0" width="600">
          <tr class="blank_row">
              <td colspan="3"></td>
          </tr>
          <tr>
              <#if parameters.groupName?has_content>
                <td>
                Dear ${parameters.groupName!},
                </td>
            </#if>
            <#if parameters.firstName?has_content>
                <td>
                Dear ${parameters.firstName!} ${parameters.lastName!},
                </td>
            </#if>
          </tr>
          <tr class="blank_row">
              <td colspan="3"></td>
          </tr>
          <tr>
            <td>
            Welcome to Product From Thailand!
            </td>
          </tr>
          <tr>
            <td>
            Thank you for signing up on www.productfromthailand.com.
            </td>
          </tr>
          <tr>
            <td>
              Your supplier account has been created successfully.
            </td>
          </tr>
          <tr class="blank_row">
              <td colspan="3"></td>
          </tr>
          <tr>
            <td>
            Your documents has been uploaded successfully. We will check your documents within 24 hours.
            </td>
          </tr>
          <tr>
            <td>
            If you have any questions or concerns you can contact our support team : support@productfromthailand.com
            </td>
          </tr>
          <tr class="blank_row">
              <td colspan="3"></td>
          </tr>
          <tr class="blank_row">
              <td colspan="3"></td>
          </tr>
          <tr>
            <td>
            Regards,
            </td>
          </tr>
          <tr>
            <td>
            Product From Thailand
            </td>
          </tr>
        </table>
      </center>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="100%" class="footer">
      <center>
        <table cellspacing="0" cellpadding="0" width="600">
          <tr>
            <td class="footer-address" align="center">
              <strong>Product From Thailand</strong><br />
              73/1 M.8, Soi AntWebsystems Tambon Sanklang, Amphur Sanpatong<br />
              Chiang Mai, Thailand 50120 <br /><br />
            </td>
          </tr>
        </table>
      </center>
    </td>
  </tr>
</table>
</body>
</html>
