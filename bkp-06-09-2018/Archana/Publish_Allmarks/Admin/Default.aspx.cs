namespace AbleCommerce.Admin
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _tabIndex = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["t"]))
                {
                    _tabIndex = AlwaysConvert.ToInt(Request.QueryString["t"]);
                    if (_tabIndex > 0 && _tabIndex <= Tabs.Tabs.Count)
                    {
                        Tabs.ActiveTabIndex = _tabIndex - 1;
                    }
                }
            }

            WelcomeMessage.Text = string.Format(WelcomeMessage.Text, GetUserName(), LocaleHelper.LocalNow);
            ReportsPanel.Visible = AbleContext.Current.User.IsInRole(Role.ReportAdminRoles);
        }

        private string GetUserName()
        {
            User user = AbleContext.Current.User;
            string name = user.PrimaryAddress.FullName;
            if (!string.IsNullOrEmpty(name)) return name;
            return user.UserName;
        }
    }
}