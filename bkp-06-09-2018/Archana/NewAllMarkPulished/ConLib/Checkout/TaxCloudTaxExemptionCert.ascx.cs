namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;
    using System.Text;

    [Description("The TaxCloud Tax exemption certificates Link.")]
    public partial class TaxCloudTaxExemptionCert : System.Web.UI.UserControl
    {
        public void Page_Init(object sender, EventArgs e)
        {
            if (!Page.ClientScript.IsClientScriptIncludeRegistered("TAX_JQUERY_FANCY_BOX_JS_CSS"))
            {
                this.Page.Header.Controls.Add(new System.Web.UI.LiteralControl("<link href='" + Page.ResolveUrl("~/scripts/fancybox/") + "jquery.fancybox.css' rel='stylesheet' type='text/css' />"));
                Page.ClientScript.RegisterClientScriptInclude("TAX_JQUERY_FANCY_BOX_JS_CSS", ResolveUrl("~/scripts/fancybox/jquery.fancybox.js"));
            }
        }
    }
}