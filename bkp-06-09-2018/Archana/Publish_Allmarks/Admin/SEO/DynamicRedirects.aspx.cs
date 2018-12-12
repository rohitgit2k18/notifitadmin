namespace AbleCommerce.Admin.SEO
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Seo;
    using CommerceBuilder.Utility;
    using NHibernate;
    using NHibernate.Criterion;

    public partial class DynamicRedirects : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // DISPLAY WARNING MESSAGE FOR IIS VERSION BELOW 7
            double iisVersion = HttpContextHelper.GetIISVersion(Request.ServerVariables["SERVER_SOFTWARE"]);
            IISVersionWarning.Visible = iisVersion > 0.0d && iisVersion < 7.0d;

            // STATISTICS TRACKING ENABLED
            if (!AbleContext.Current.Store.Settings.SeoTrackStatistics)
            {
                RedirectsGrid.Columns[4].Visible = false;
                RedirectsGrid.Columns[5].Visible = false;
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
                redirect.SourceUrl = SourcePath.Text.Trim();
                redirect.TargetUrl = TargetPath.Text.Trim();
                redirect.UseRegEx = true;
                redirect.Store = AbleContext.Current.Store;
                redirect.Save();

                // RESET THE ADD NEW FORM
                SourcePath.Text = String.Empty;
                TargetPath.Text = String.Empty;
                RedirectsGrid.DataBind();
            }
        }

        protected void RedirectsGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName.StartsWith("Do_"))
            {
                int redirectId = (int)AlwaysConvert.ToInt(e.CommandArgument);
                int index;
                switch (e.CommandName)
                {
                    case "Do_Up":
                        ICriteria criteria = NHibernateHelper.CreateCriteria<Redirect>(string.Empty, "OrderBy");
                        criteria.Add(Restrictions.Eq("UseRegEx", true));
                        criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
                        IList<Redirect> redirectRules = RedirectDataSource.LoadForCriteria(criteria);
                        index = redirectRules.IndexOf(redirectId);
                        if (index > 0)
                        {
                            Redirect tempRedirect = redirectRules[index - 1];
                            redirectRules[index - 1] = redirectRules[index];
                            redirectRules[index] = tempRedirect;
                        }
                        index = 0;
                        foreach (Redirect redirect in redirectRules)
                        {
                            redirect.OrderBy = (short)index;
                            redirect.Save();
                            index++;
                        }
                        RedirectsGrid.DataBind();
                        break;
                    case "Do_Down":
                        ICriteria criteria2 = NHibernateHelper.CreateCriteria<Redirect>(string.Empty, "OrderBy");
                        criteria2.Add(Restrictions.Eq("UseRegEx", true));
                        criteria2.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
                        redirectRules = RedirectDataSource.LoadForCriteria(criteria2);
                        index = redirectRules.IndexOf(redirectId);
                        if (index < redirectRules.Count - 1)
                        {
                            Redirect tempRedirect = redirectRules[index + 1];
                            redirectRules[index + 1] = redirectRules[index];
                            redirectRules[index] = tempRedirect;
                        }
                        index = 0;
                        foreach (Redirect redirect in redirectRules)
                        {
                            redirect.OrderBy = (short)index;
                            redirect.Save();
                            index++;
                        }
                        RedirectsGrid.DataBind();
                        break;
                }
            }
        }

        protected bool ShowDate(object value)
        {
            if (value == null) return false;
            return !((DateTime)value).Equals(DateTime.MinValue);
        }
    }
}