namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using System.Text;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;

    [Obsolete("This control is obsolete.")]
    [Description("Displays social media icon-links")]
    public partial class SocialMediaLinks : System.Web.UI.UserControl
    {
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true facebook icon-link is displayed")]
        public bool ShowFacebook
        {
            get { return phFacebook.Visible; }
            set { phFacebook.Visible = value; }
        }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true google icon-link is displayed")]
        public bool ShowGoogle
        {
            get { return phGoogle.Visible; }
            set { phGoogle.Visible = value; }
        }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true twitter icon-link is displayed")]
        public bool ShowTwitter
        {
            get { return phTwitter.Visible; }
            set { phTwitter.Visible = value; }
        }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true pinterest icon-link is displayed")]
        public bool ShowPinterest
        {
            get { return phPinterest.Visible; }
            set { phPinterest.Visible = value; }
        }

        //protected string PinterestUrl
        //{
        //    get
        //    {
        //        Product p = ProductDataSource.Load(AbleCommerce.Code.PageHelper.GetProductId());
        //        if (p != null)
        //        {
        //            string storeUrl = AbleContext.Current.Store.StoreUrl;
        //            if (!storeUrl.EndsWith("/")) storeUrl += "/";
        //            StringBuilder sb = new StringBuilder();
        //            sb.Append("http://pinterest.com/pin/create/button/?url=");
        //            sb.Append(Server.UrlEncode(storeUrl + p.NavigateUrl.Substring(2)));
        //            if (!string.IsNullOrEmpty(p.ImageUrl))
        //            {
        //                string url = p.ImageUrl;
        //                if (url.StartsWith("~/"))
        //                {
        //                    url = storeUrl + url.Substring(2);
        //                }
        //                sb.Append("&media=" + Server.UrlEncode(url));
        //            }
        //            sb.Append("&description=" + Server.UrlEncode(p.Name));
        //            return sb.ToString();
        //        }
        //        else
        //        {
        //            return string.Empty;
        //        }
        //    }
        //}

        protected string PageUrl
        {
            get
            {
                return Server.UrlEncode(Request.Url.ToString());
            }
        }

        protected string PageTitle
        {
            get
            {
                Product p = ProductDataSource.Load(AbleCommerce.Code.PageHelper.GetProductId());
                return p.Name;
            }
        }

        protected string ProductImage
        {
            get
            {
                Product p = ProductDataSource.Load(AbleCommerce.Code.PageHelper.GetProductId());
                string storeUrl = AbleContext.Current.Store.StoreUrl;
                if (!storeUrl.EndsWith("/")) storeUrl += "/";
                string url = p.ImageUrl;
                if (url.StartsWith("~/"))
                {
                    url = storeUrl + url.Substring(2);
                }

                return url;
            }
        }

        //protected void Page_PreRender(object sender, EventArgs e)
        //{
        //    if (this.ShowPinterest && string.IsNullOrEmpty(this.PinterestUrl)) this.ShowPinterest = false;
        //}
    }
}