namespace AbleCommerce
{
    using System;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

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
            Response.Redirect(ReturnUrl, true);
        }
    }
}