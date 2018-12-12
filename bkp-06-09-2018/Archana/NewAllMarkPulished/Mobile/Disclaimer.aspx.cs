using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile
{
    public partial class Disclaimer : CommerceBuilder.UI.AbleCommercePage
    {
        private string ReturnUrl
        {
            get
            {
                return NavigationHelper.GetReturnUrl(NavigationHelper.GetHomeUrl());
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DisclaimerText.Text = AbleContext.Current.Store.Settings.SiteDisclaimerMessage;
                if (string.IsNullOrEmpty(DisclaimerText.Text)) Response.Redirect(ReturnUrl);
            }
            trNoCookies.Visible = !Request.Browser.Cookies;
            trDisclaimerMessage.Visible = Request.Browser.Cookies;
        }

        protected void OkButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(ReturnUrl);
        }
    }
}