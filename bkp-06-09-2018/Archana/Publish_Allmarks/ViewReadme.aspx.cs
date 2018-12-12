using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Utility;

namespace AbleCommerce
{
    public partial class ViewReadme : CommerceBuilder.UI.AbleCommercePage
    {
        protected string ReturnUrl
        {
            get
            {
                string url = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(url))
                {
                    return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(url));
                }
                return "~/Default.aspx";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int readmeId = AlwaysConvert.ToInt(Request.QueryString["ReadmeId"]);
            Readme readme = ReadmeDataSource.Load(readmeId);
            if (readme == null) Response.Redirect(ReturnUrl);
            Page.Title = readme.DisplayName;
            ReadmeText.Text = readme.ReadmeText;
            OkButton.NavigateUrl = ReturnUrl;
        }
    }
}