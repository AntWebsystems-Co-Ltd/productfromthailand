/*
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License.
*/

productCategoryId = request.getAttribute("productCategoryId") ?: parameters.productCategoryId;

cartResult = runService('getProductCategoryMembers', [categoryId : productCategoryId])
categoryMembers = cartResult.categoryMembers;

List productCategoryMembersRandomTemp = new ArrayList(categoryMembers);
List<Map<String, Object>> productCategoryMembersList = new LinkedList<Map<String,Object>>();
Random rand = new Random();
while(productCategoryMembersRandomTemp.size() > 0) {
    int index = rand.nextInt(productCategoryMembersRandomTemp.size());
    productCategoryMembersList.add(productCategoryMembersRandomTemp.remove(index))
}
categoryMembers = productCategoryMembersList;

context.productCategoryMembers = categoryMembers
context.productCategory = cartResult.productCategory
