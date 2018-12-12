using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using CommerceBuilder.Utility;

namespace AbleCommerce.Mobile
{
    public partial class Webpage : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_InIt(Object sender, EventArgs e)
        {            
            string appPath = "/";
            HttpRequest httpRequest = HttpContextHelper.SafeGetRequest();
            if (httpRequest != null)
            {
                appPath = httpRequest.ApplicationPath;
                if (!appPath.EndsWith("/")) appPath += "/";
            }
            
            string appRelativeUrl = UrlHelper.GetAppRelativeUrl(Request.RawUrl, appPath);
            string query = UrlHelper.GetQueryString(Request.RawUrl);

            if (appRelativeUrl.StartsWith("mobile/"))
            {                
                appRelativeUrl = appRelativeUrl.Substring(7);                
            }

            NameValueCollection nvc = new NameValueCollection();
            if(!string.IsNullOrEmpty(query))
            {
                nvc = HttpUtility.ParseQueryString(query);
            }

            nvc.Add("FSIntent", "true");

            Response.Redirect(appPath + appRelativeUrl + UrlHelper.ToQueryString(nvc));
        }
    }
}
