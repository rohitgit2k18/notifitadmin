namespace AbleCommerce.Admin.UserControls
{
    using System;
    using System.IO;
    using System.Web.UI.WebControls;
    using CommerceBuilder.UI;

    public partial class PrintableLogo : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string logoPath = GetLogoPath();
            if (!string.IsNullOrEmpty(logoPath))
            {
                Image logoImage = new Image();
                logoImage.ImageUrl = logoPath;
                LogoPanel.Controls.Add(logoImage);
            }
        }

        private string GetLogoPath()
        {
            string defaultTheme = ThemeManager.GetDefaultStoreTheme();
            string baseVirtualPath = "~/App_Themes/" + defaultTheme + "/images/printlogo";
            string basePhysicalPath = Server.MapPath(baseVirtualPath);
            if (File.Exists(basePhysicalPath + ".gif"))
                return baseVirtualPath + ".gif";
            else if (File.Exists(basePhysicalPath + ".jpg"))
                return baseVirtualPath + ".jpg";
            else if (File.Exists(basePhysicalPath + ".png"))
                return baseVirtualPath + ".png";
            else return string.Empty;
        }
    }
}