namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.ComponentModel;
    using System.Web.Caching;
    using CommerceBuilder.Common;

    [Description("Displays the store logo.")]
    public partial class StoreLogo : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            //GET THE CACHED LOGO
            string logoUrl = (string)Cache["StoreLogoUrl"];

            //verify theme is current
            if (!string.IsNullOrEmpty(logoUrl) && !logoUrl.StartsWith("~/App_Themes/" + Page.Theme + "/"))
            {
                //reset the logo path because the theme was changed
                logoUrl = string.Empty;
            }

            //FIND THE CORRECT LOGO
            if (string.IsNullOrEmpty(logoUrl))
            {
                //find the correct logo path
                string logoVirtualPath = "~/App_Themes/" + Page.Theme + "/images/logo";
                string logoFilePath = Server.MapPath(logoVirtualPath);
                if (System.IO.File.Exists(logoFilePath + ".jpg"))
                {
                    logoFilePath += ".jpg";
                    logoUrl = logoVirtualPath + ".jpg";
                }
                else if (System.IO.File.Exists(logoFilePath + ".png"))
                {
                    logoFilePath += ".png";
                    logoUrl = logoVirtualPath + ".png";
                }
                else
                {
                    logoFilePath += ".gif";
                    logoUrl = logoVirtualPath + ".gif";
                }
               if(System.IO.File.Exists(Server.MapPath("~/App_Themes/" + Page.Theme + "/")))
               {
                    CacheDependency dep = new CacheDependency(logoFilePath);
                    Cache.Insert("StoreLogoUrl", logoUrl, dep, Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.High, null);
               }
            }
            Logo.ImageUrl = logoUrl;
            Logo.AlternateText = AbleContext.Current.Store.Name + " Logo";
        }
    }
}