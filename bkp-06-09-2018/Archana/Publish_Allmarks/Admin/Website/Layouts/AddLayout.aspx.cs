namespace AbleCommerce.Admin.Website.Layouts
{
    using System;
    using System.IO;
    using System.Text;
    using System.Web;
    using System.Web.Services;
    using System.Web.UI;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;
    using AbleCommerce.Code;

    public partial class AddLayout : AbleCommerceAdminPage
    {   
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Save())
            {
                // REDIRECT TO EDIT PAGE
                string layoutName = LayoutName.Text;
                layoutName = layoutName.Replace("  ", " ") + ".master";
                Response.Redirect("~/Admin/Website/Layouts/EditLayout.aspx?name=" + "~/Layouts/" + layoutName);
            }
        }

        protected void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            if (Save())
            {
                Response.Redirect("~/Admin/Website/Layouts/Default.aspx");
            }
        }

        private bool Save()
        {
            if (Page.IsValid)
            {
                // 

                // CHECK IF A FILE WITH THE GIVEN NAME ALREADY EXISTS
                string layoutName = LayoutName.Text;
                layoutName = layoutName.Replace("  ", " ") + ".master";
                string layoutPath = Server.MapPath("~/Layouts/" + layoutName);
                if (!File.Exists(layoutPath))
                {
                    LayoutHelper.CreateAndSave(layoutPath, Description.Text, HeaderControlsDialog.SelectedControls, LeftControlsDialog.SelectedControls, RightControlsDialog.SelectedControls, FooterControlsDialog.SelectedControls);
                    SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow.ToShortTimeString());
                    SavedMessage.Visible = true;
                    return true;
                }
                else
                {
                    ExistingLayoutNameValidator.IsValid = false;
                }
            }
            return false;
        }

        [WebMethod]
        public static bool IsValidLayoutName(string name)
        {
            string mappedPath = HttpContext.Current.Server.MapPath("~/Layouts");
            string layoutPath = Path.Combine(mappedPath, name + ".master");
            return !File.Exists(layoutPath);
        }
    }
}