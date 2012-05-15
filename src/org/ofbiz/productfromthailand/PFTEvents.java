package org.ofbiz.productfromthailand;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.util.EntityUtil;

public class PFTEvents {
    
    public static final String module = PFTEvents.class.getName();
    /** Simple event to set the users per-session locale setting. The user's locale
     * setting should be passed as a "localeString" session attribute. */
    public static String setProductStoreAndSessionLocale(HttpServletRequest request, HttpServletResponse response) {
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        HttpSession session = request.getSession();
        
        String defaultLocaleString = (String) session.getAttribute("localeString");
        GenericValue productStore = null;
        GenericValue webSite = null;
        try {
            productStore = EntityUtil.getFirst(delegator.findByAnd("ProductStore", UtilMisc.toMap("defaultLocaleString", defaultLocaleString), null, false));
        } catch (GenericEntityException e) {
            Debug.logError(e, "Problems getting ProductStore", module);
            return "error";
        }
        
        if(productStore != null){
            session.setAttribute("productStoreId", productStore.getString("productStoreId"));
            session.setAttribute("currencyUom", productStore.getString("defaultCurrencyUomId"));
            try {
                webSite = EntityUtil.getFirst(productStore.getRelatedByAnd("WebSite", UtilMisc.toMap("productStoreId", productStore.getString("productStoreId"))));
            } catch (GenericEntityException e) {
                Debug.logError(e, "Problems getting WebSite", module);
                return "error";
            }
        }
        session.getServletContext().setAttribute("webSiteId", webSite.get("webSiteId"));
        
        return "success";
    }
}