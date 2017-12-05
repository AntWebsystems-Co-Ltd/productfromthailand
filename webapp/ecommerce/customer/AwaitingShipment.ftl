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
    <!-- Store Management Menu Start -->
    <div class="col-sm-3">
        ${setRequestAttribute("isAwaitShipment", "Y")}
        ${setRequestAttribute("isMyOrdersSub", "Y")}
        ${screens.render("component://productfromthailand/widget/CatalogScreens.xml#StoreManagementMenus")}
    </div>
    <!-- Store Management Menu Ends -->
    <div class="col-sm-9">
      <h4 class="main-heading text-center">
        ${uiLabelMap.PFTAwaitingShipment} ${uiLabelMap.OrderOrder}
      </h4>
      <div class="table-responsive shopping-cart-table">
          <table class="table table-bordered">
            <thead>
              <tr>
                <td class="text-center">
                    ${uiLabelMap.OrderOrderId}
                </td>
                <td class="text-center">
                    ${uiLabelMap.OrderDate}
                </td>
                <td class="text-center">
                    ${uiLabelMap.OrderGrandTotal}
                </td>
                <#-- <td class="text-center">
                    ${uiLabelMap.OrderCustomer} ${uiLabelMap.CommonName}
                </td>  -->
                <#if orderLists?has_content>
                <td class="text-center">
                    ${uiLabelMap.CommonEmptyHeader}
                </td>
                </#if>
              </tr>
            </thead>
            <tbody>
              <#if orderLists?has_content>
                <#list orderLists as orderList>
                  <tr>
                    <td class="text-center">
                      ${orderList.orderId}
                    </td>
                    <td class="text-center">
                      ${orderList.orderDate?string.medium}
                    </td>
                    <td class="text-center">
                      <@ofbizCurrency amount=orderList.grandTotal! isoCode=orderList.currencyUom/>
                    </td>
                    <#-- <td class="text-center">
                      ${Static["org.apache.ofbiz.party.party.PartyHelper"].getPartyName(delegator, orderList.partyId, false)!}[${orderList.partyId}]
                    </td>  -->
                    <td class="text-center">
                      <input type="button" class="btn btn-main" value="${uiLabelMap.CommonView}" onclick="javascript: location.href = '<@ofbizUrl>orderstatus?orderId=${orderList.orderId}</@ofbizUrl>';"/>
                      <button type="button" class="btn btn-main" id="${orderList.orderId!}" data-toggle="modal" data-target="#trackingModal">${uiLabelMap.FacilityShip}</button>
                    </td>
                  </tr>
                  <!-- Modal -->
                  <div class="modal fade" id="trackingModal" role="dialog">
                    <div class="modal-dialog">
                      <!-- Modal content-->
                      <div class="modal-content">
                        <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal">&times;</button>
                          <h4 class="modal-title">Add New Tracking Code</h4>
                        </div>
                        <div class="modal-body">
                          <div class="row">
                            <div class="col-lg-12 col-md-12 col-sm-12">
                              <input type="hidden" id="orderId" value=""/>
                              <input class="form-control required" id="trackingNumber" placeholder="Tracking Number" type="text"/>
                            </div>
                          </div>
                        </div>
                        <div class="modal-footer">
                          <button type="button" id="btn" class="btn btn-primary" onclick="javascript: quickShipped()">Save</button>
                          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </#list>
              </#if>
            </tbody>
          </table>
        </div>
    </div>
  </div>
</div>

<script>
    function quickShipped() {
        var orderId = $("#orderId").val();
        var trackingNumber = $("#trackingNumber").val();
        if (trackingNumber != "") {
            $.ajax({
                url: 'shippedOrder',
                type: 'POST',
                data: "orderId="+orderId + "&trackingNumber=" + trackingNumber,
                async: false,
                success: function(data) {
                    location.reload();
                }
            });
        } else {
            alert('Please insert tracking number');
        }
    }

    $('#trackingModal').on('show.bs.modal', function(e) {
        $("#orderId").val(e.relatedTarget.id);
    });
</script>
