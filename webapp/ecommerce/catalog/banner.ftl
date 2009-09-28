<table width="630" align="center">
    <tbody>
        <tr>
            <#if parameters._CURRENT_VIEW_=="main">
            <td valign="top" width="630" height="200" background="/pft/images/banner.gif">
                
                <div id="middle">
                  <#if !productStore?exists>
                    <h2>${uiLabelMap.EcommerceNoProductStore}</h2>
                  </#if>
                  <#if (productStore.title)?exists><div id="company-name">${productStore.title}</div></#if>
                  <#if (productStore.subtitle)?exists><div id="company-subtitle">${productStore.subtitle}</div></#if>
                  
            </td>
            </#if>
        </tr>
    </tbody>
</table>
