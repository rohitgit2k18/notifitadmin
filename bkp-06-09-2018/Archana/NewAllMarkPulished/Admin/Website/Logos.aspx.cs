namespace AbleCommerce.Admin.Website
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;

    public partial class Logos : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private IList<Theme> _themes;

        protected void Page_Init(object sender, EventArgs e)
        {
            _themes = ThemeDataSource.LoadAll(BitFieldState.False);
            ActiveTheme.DataSource = _themes;
            ActiveTheme.DataBind();
        }
        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // INITIALIZE FORM ON FIRST VISIT
                string defaultTheme = ThemeManager.GetDefaultStoreTheme();
                ListItem selected = ActiveTheme.Items.FindByValue(defaultTheme);
                if (selected != null) selected.Selected = true;
            }
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            if (NewWebsiteLogo.HasFile)
            {
                string extension = System.IO.Path.GetExtension(NewWebsiteLogo.FileName).ToLowerInvariant();
                if (extension == ".gif" || extension == ".jpg" || extension == ".png")
                {
                    //DELETE EXISTING LOGO FILES
                    string logoPath = GetWebsiteLogoPhysicalPath();
                    System.IO.File.Delete(logoPath + ".jpg");
                    System.IO.File.Delete(logoPath + ".png");
                    System.IO.File.Delete(logoPath + ".gif");
                    NewWebsiteLogo.SaveAs(logoPath + extension);
                }
            }
            if (NewPrintableLogo.HasFile)
            {
                string extension = System.IO.Path.GetExtension(NewPrintableLogo.FileName).ToLowerInvariant();
                if (extension == ".gif" || extension == ".jpg" || extension == ".png")
                {
                    // DELETE EXISTING LOGO FILES
                    string logoPath = GetPrintableLogoPhysicalPath();
                    System.IO.File.Delete(logoPath + ".jpg");
                    System.IO.File.Delete(logoPath + ".png");
                    System.IO.File.Delete(logoPath + ".gif");
                    NewPrintableLogo.SaveAs(logoPath + extension);
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // BIND LOGOS
            BindWebsiteLogo();
            BindPrintableLogo();
        }

        private string GetActiveTheme()
        {
            string theme = ActiveTheme.SelectedValue;
            Theme validTheme = _themes.FirstOrDefault(t => t.Name.Equals(theme));
            if (validTheme != null) return validTheme.Name;
            return ThemeManager.GetDefaultStoreTheme();
        }

        private string GetPrintableLogoPhysicalPath()
        {
            return Server.MapPath("~/App_Themes/" + GetActiveTheme() + "/images/printlogo");
        }

        private string GetPrintableLogoVirtualPath()
        {
            return "~/App_Themes/" + GetActiveTheme() + "/images/printlogo";
        }

        private string GetWebsiteLogoPhysicalPath()
        {
            return Server.MapPath("~/App_Themes/" + GetActiveTheme() + "/images/logo");
        }

        private string GetWebsiteLogoVirtualPath()
        {
            return "~/App_Themes/" + GetActiveTheme() + "/images/logo";
        }

        private void BindWebsiteLogo()
        {
            WebsiteLogo.Controls.Clear();
            //find the correct logo path
            string logoUrl = string.Empty;
            string logoFilePath = GetWebsiteLogoPhysicalPath();
            if (System.IO.File.Exists(logoFilePath + ".gif"))
                logoUrl = GetWebsiteLogoVirtualPath() + ".gif";
            else if (System.IO.File.Exists(logoFilePath + ".jpg"))
                logoUrl = GetWebsiteLogoVirtualPath() + ".jpg";
            else if (System.IO.File.Exists(logoFilePath + ".png"))
                logoUrl = GetWebsiteLogoVirtualPath() + ".png";
            //UPDATE CACHE
            if (!string.IsNullOrEmpty(logoUrl))
            {
                Image logo = new Image();
                logo.ImageUrl = logoUrl + "?tag=" + StringHelper.RandomNumber(6);
                WebsiteLogo.Controls.Add(logo);
            }
            else
            {
                WebsiteLogo.Controls.Add(new LiteralControl("A custom logo has not been uploaded."));
            }
        }

        private void BindPrintableLogo()
        {
            PrintableLogo.Controls.Clear();
            //find the correct logo path
            string logoUrl = string.Empty;
            string logoFilePath = GetPrintableLogoPhysicalPath();
            if (System.IO.File.Exists(logoFilePath + ".gif"))
                logoUrl = GetPrintableLogoVirtualPath() + ".gif";
            else if (System.IO.File.Exists(logoFilePath + ".jpg"))
                logoUrl = GetPrintableLogoVirtualPath() + ".jpg";
            else if (System.IO.File.Exists(logoFilePath + ".png"))
                logoUrl = GetPrintableLogoVirtualPath() + ".png";
            //UPDATE CACHE
            if (!string.IsNullOrEmpty(logoUrl))
            {
                Image logo = new Image();
                logo.ImageUrl = logoUrl + "?tag=" + StringHelper.RandomNumber(6);
                PrintableLogo.Controls.Add(logo);
            }
            else
            {
                PrintableLogo.Controls.Add(new LiteralControl("A printable logo has not been uploaded."));
            }
        }
    }
}