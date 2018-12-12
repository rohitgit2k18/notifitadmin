using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Shipping;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Marketing;

namespace AbleCommerce.Admin.People.Users
{
    public partial class EditUser : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _tabIndex = 0;
        private int _UserId;
        private User _User;

        protected void Page_Init(object sender, EventArgs e)
        {
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
            _User = UserDataSource.Load(_UserId);
            if (_User == null) Response.Redirect("Default.aspx");

            if (!string.IsNullOrEmpty(Request.QueryString["Tab"]))
            {
                _tabIndex = AlwaysConvert.ToInt(Request.QueryString["Tab"]);
                if (_tabIndex > 0 && _tabIndex <= Tabs.Tabs.Count)
                {
                    Tabs.ActiveTabIndex = _tabIndex - 1;
                }
            }

            // ONLY SECURITY ADMINS CAN EDIT ADMIN USERS
            if (_User.IsAdmin && (AbleContext.Current.User.Id != _User.Id && !AbleContext.Current.User.IsSecurityAdmin)) Response.Redirect("Default.aspx");

            // NON SUPER USERS CANNOT EDIT SUPER USERS ACCOUNT
            if (_User.IsSystemAdmin && !AbleContext.Current.User.IsSystemAdmin) Response.Redirect("Default.aspx");

            // INITIALIZE CAPTION
            Caption1.Text = string.Format(Caption1.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
            Caption2.Text = string.Format(Caption2.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
            Caption3.Text = string.Format(Caption3.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
            Caption4.Text = string.Format(Caption4.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
            Caption5.Text = string.Format(Caption5.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
            Caption6.Text = string.Format(Caption6.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
            Caption7.Text = string.Format(Caption7.Text, _User.IsAnonymous ? "anonymous" : _User.UserName);
        }
    }
}