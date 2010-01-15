package org.ofbiz.productfromthailand;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.StringUtil;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;

/**
 * ControlServlet.java - Master servlet for the web application.
 */
@SuppressWarnings("serial")
public class LocaleUrlServlet extends HttpServlet{
    public static final String module = LocaleUrlServlet.class.getName();

    public static final String LOCALE_URL_MOUNT_POINT = "site";
    public static final String CONTROL_MOUNT_POINT = "control";
    public static final String TH_REQUEST = "th";
    public static final String EN_REQUEST = "en";
    
    public LocaleUrlServlet(){
        super();
    }

    /**
     * @see javax.servlet.Servlet#init(javax.servlet.ServletConfig)
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    /**
     * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        List<String> pathElements = StringUtil.split(pathInfo, "/");

        // look for localeString
        String localeString = null;
        if(pathElements !=null){
            String lastPathElement = pathElements.get(pathElements.size() - 1);
            if (lastPathElement != null) {
                localeString = lastPathElement;
                pathElements.remove(pathElements.size() - 1);
            }
        }

        // set current locale
        if (localeString != null) {
            if (UtilValidate.isNotEmpty(localeString)) {
                UtilHttp.setLocale(request, localeString);

                // update the UserLogin object
                GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
                if (userLogin == null) {
                    userLogin = (GenericValue) request.getSession().getAttribute("autoUserLogin");
                }
                if (userLogin != null) {
                    GenericValue ulUpdate = GenericValue.create(userLogin);
                    ulUpdate.set("lastLocale", localeString);
                    try {
                        ulUpdate.store();
                        userLogin.refreshFromCache();
                    } catch (GenericEntityException e) {
                        Debug.logWarning(e, module);
                    }
                }
            }
            request.getSession().setAttribute("localeString", localeString);
        }
        
        RequestDispatcher rd = request.getRequestDispatcher("/" + CONTROL_MOUNT_POINT + "/" + (localeString != null ? EN_REQUEST : TH_REQUEST));
        rd.forward(request, response);
    }

    /**
     * @see javax.servlet.Servlet#destroy()
     */
    @Override
    public void destroy() {
        super.destroy();
    }
    
    public static String makeLocaleUrl(HttpServletRequest request, String localeString) {
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(request.getSession().getServletContext().getContextPath());
        if (urlBuilder.charAt(urlBuilder.length() - 1) != '/') {
            urlBuilder.append("/");
        }
        
        urlBuilder.append(LOCALE_URL_MOUNT_POINT);
        
        if (UtilValidate.isNotEmpty(localeString)) {
            urlBuilder.append("/");
            urlBuilder.append(localeString);
        }

        return urlBuilder.toString();
    }
}
