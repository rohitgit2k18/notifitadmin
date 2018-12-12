//-----------------------------------------------------------------------
// <copyright file="BillingAddress.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    [Description("Displays the billing address")]    
    public partial class BillingAddress : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            Address address = user.PrimaryAddress;

            // try to inject edit link into formatted address
            AddressData.Text = address.ToString(true);
            int insertIndex = AddressData.Text.IndexOf("<br />");
            if (insertIndex > -1)
            {
                string editUrl = this.Page.ResolveUrl("~/Checkout/EditBillAddress.aspx");
                if (user.IsAnonymous) editUrl += "?GC=0";
                string editLink = " <span class=\"editLink\"><a href=\"" + editUrl + "\">Edit</a></span>";
                AddressData.Text = AddressData.Text.Insert(insertIndex, editLink);
            }
            
            // APPEND EMAIL
            AddressData.Text += "<br/>" + address.Email;
        }
    }
}