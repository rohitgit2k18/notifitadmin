using CommerceBuilder.UI;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace AbleCommerce.ConLib
{
    [Description("A UI control to configure and show PayPal banner ads.")]
    public partial class PayPalBannerAd : System.Web.UI.UserControl, IHeaderControl, IFooterControl, ISidebarControl
    {
        private string _PublisherId = string.Empty;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("")]
        [Description("The unique Paypal publisher Id, you can get it by logging in to your PayPal account at PayPal website.")]
        public string PublisherId
        {
            get { return _PublisherId; }
            set { _PublisherId = value; }
        }

        private string _BannerSize = "170x100";

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("170x100")]
        [Description("Choose from the defined available sizes of banner Ads, check PayPal financing portal for more information.(https://financing.paypal.com/ppfinportal/home/index)")]
        public string BannerSize
        {
            get { return _BannerSize; }
            set { _BannerSize = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.PublisherId) && !string.IsNullOrEmpty(this.BannerSize))
            {
                Header.Visible = false;
                Instructions.Visible = false;
                BannerScripts.Visible = true;
            }
            else if (string.IsNullOrEmpty(this.PublisherId))
            {
                Header.Visible = true;
                Instructions.Visible = true;
                BannerScripts.Visible = false;
            }
            else this.Visible = false;
        }
    }
}