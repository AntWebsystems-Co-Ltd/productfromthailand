<div id="recentlyproducts" class="screenlet" style="-moz-border-radius: 5px;">
    <div class="screenlet-title-bar">
<ul>
<li class="h3">${uiLabelMap.PFTRecentlyAddedItems}</li>
</ul>
</div>
<div class="screenlet-body">
<#assign x=0>
<#list productlist as product>
${setRequestAttribute("optProductId", product.productId)}
${screens.render(recentlyproductScreen)}
<#assign x= x+1>
<#if x=3><#break></#if>
</#list>
</div>
</div> <#-- end screenlet -->

<#--div><a href="#"><img src="/images/adver.gif" width="240px"/></a></div-->
    <object width="240">
        <param name="movie" value="https://www.youtube.com/v/NA0UC4dIcbQ&hl=en&fs=1&"></param>
        <param name="allowFullScreen" value="true"></param>
        <param name="allowscriptaccess" value="always"></param>
        <embed src="https://www.youtube.com/v/NA0UC4dIcbQ&hl=en&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="240">
    </embed>
    </object><br/>
    <#--div style="float:right">
        <a href="#"><h2>More Videos...</h2></a>
    </div-->
