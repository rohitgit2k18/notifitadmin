namespace AbleCommerce.Admin.SEO
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Seo;
    using CommerceBuilder.Utility;

    public partial class FixedRedirects : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // DISPLAY WARNING MESSAGE FOR IIS VERSION BELOW 7
            double iisVersion = HttpContextHelper.GetIISVersion(Request.ServerVariables["SERVER_SOFTWARE"]);
            IISVersionWarning.Visible = iisVersion > 0.0d && iisVersion < 7.0d;

            // STATISTICS TRACKING ENABLED
            if (!AbleContext.Current.Store.Settings.SeoTrackStatistics)
            {
                RedirectsGrid.Columns[3].Visible = false;
                RedirectsGrid.Columns[4].Visible = false;
            }
        }

        protected void SaveButton_Click(Object sender, EventArgs e)
        {
            // VALIDATE UNIQUE REQUEST PATH
            if (RedirectDataSource.LoadForSourceUrl(SourcePath.Text.Trim()) != null)
            {
                UniqueSourcePathValidator.IsValid = false;
                return;
            }

            if (Page.IsValid)
            {
                Redirect redirect = new Redirect();
                redirect.SourceUrl = SourcePath.Text;
                redirect.TargetUrl = TargetPath.Text;
                redirect.UseRegEx = false;
                redirect.Store = AbleContext.Current.Store;
                redirect.Save();

                // RESET THE ADD NEW FORM
                SourcePath.Text = String.Empty;
                TargetPath.Text = String.Empty;
                RedirectsGrid.DataBind();
            }
        }

        protected bool ShowDate(object value)
        {
            if (value == null) return false;
            return !((DateTime)value).Equals(DateTime.MinValue);
        }
    }
}