<div id="recentlyproducts" class="screenlet" style="-moz-border-radius: 5px;">
    <div class="screenlet-title-bar">
<ul>
<li class="h3">Recently Products</li>
</ul>
</div>
<div class="screenlet-body">
<#assign x=0>
<#list productlist as product>
    <#assign productUrl = Static["org.ofbiz.product.category.CatalogUrlServlet"].makeCatalogUrl(request, product.productId, categoryId, "")/>
<div class="recentproduct">
    <div class="recentproductimage">
        <#if product.smallImageUrl?exists>
        <a href="${productUrl}"><img src="${product.smallImageUrl}"/></a>
        <#else>
        <a href="${productUrl}"><img src="/images/defaultImage.jpg"/></a>
        </#if>
    </div>
    <div id="recentproductdetail">
         <h3><a href="${productUrl?if_exists}">${product.internalName?if_exists}</a></h3>
         <p>${product.description?if_exists}</p>
    </div>
</div>
<#assign x= x+1>
<#if x=3><#break></#if>
</#list>
</div>
</div> <#-- end screenlet -->

<div><img src="/images/"/></div>