namespace AbleCommerce.Mobile.UserControls.Account
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Users;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Utility;

    public partial class mBillingAddress : System.Web.UI.UserControl
    {
        bool _ShowEditLink = false;

        public Order Order { get; set; }


        [Browsable(true), DefaultValue(false)]
        [Description("Indicates whether the edit link for billing address is shown.")]
        public bool ShowEditLink
        {
            get { return _ShowEditLink; }
            set { _ShowEditLink = value; }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                string pattern = this.Order.BillToCountry.AddressFormat;
                if (!string.IsNullOrEmpty(this.Order.BillToEmail) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\nEmail: [Email]";
                if (!string.IsNullOrEmpty(this.Order.BillToPhone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
                if (!string.IsNullOrEmpty(this.Order.BillToFax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";

                AddressData.Text = this.Order.FormatAddress(pattern, true);
                EditAddressLink.Visible = ShowEditLink;
            }
            else
            {
                this.Controls.Clear();
            }
        }

        protected void EditAddressButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetMobileStoreUrl("~/Members/EditBillingAddress.aspx?OrderNumber=" + Order.OrderNumber.ToString()));
        }
    }
}