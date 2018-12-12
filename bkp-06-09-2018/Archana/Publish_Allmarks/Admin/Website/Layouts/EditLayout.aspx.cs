namespace AbleCommerce.Admin.Website.Layouts
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

    public partial class EditLayout : AbleCommerceAdminPage
    {
        Layout _Layout = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            // initialize the layout
            string layoutPath = Request.QueryString["name"];
            if (!File.Exists(Server.MapPath(layoutPath))) Response.Redirect("~/Admin/Website/Layouts/Default.aspx");
            _Layout = new Layout(layoutPath);
            if (!Page.IsPostBack)
            {
                LayoutName.Text = _Layout.DisplayName;
                Description.Text = _Layout.Description;
                DescriptionCharCount.Text = (AlwaysConvert.ToInt(DescriptionCharCount.Text) - Description.Text.Length).ToString();
                AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(Description, DescriptionCharCount);

                // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
                if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addlayout.aspx"))
                {
                    SavedMessage.Visible = true;
                    SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                }
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            Save();
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
                LayoutHelper.CreateAndSave(Server.MapPath(_Layout.FilePath), Description.Text, HeaderControlsDialog.SelectedControls, LeftControlsDialog.SelectedControls, RightControlsDialog.SelectedControls, FooterControlsDialog.SelectedControls);
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow.ToShortTimeString());
                SavedMessage.Visible = true;
                return true;
            }
            return false;
        }
    }
}