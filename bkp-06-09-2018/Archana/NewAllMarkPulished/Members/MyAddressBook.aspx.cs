namespace AbleCommerce.Members
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class MyAddressBook : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // BIND ADDRESSES FOR SELECTION
            BindAddressBook();
        }

        protected void BindAddressBook()
        {
            // bind billing address
            User user = AbleContext.Current.User;
            if (user.PrimaryAddress.IsValid)
            {
                PrimaryAddress.Text = user.PrimaryAddress.ToString(true);
            }

            // bind shipping addresses, sorted by last name
            if (user.Addresses.Count > 1)
            {
                List<Address> shippingAddresses = new List<Address>();
                shippingAddresses.AddRange(user.Addresses);
                int billingIndex = shippingAddresses.IndexOf(user.PrimaryAddressId);
                if (billingIndex > -1)
                {
                    shippingAddresses.RemoveAt(billingIndex);
                }
                shippingAddresses.Sort("LastName");
                AddressList.DataSource = shippingAddresses;
                AddressList.DataBind();
            }
            else
            {
                AddressList.Visible = false;
            }
        }

        protected void NewAddressButton_Click(object sender, EventArgs e)
        {
            ShowEditPanel(0);
        }

        protected void AddressList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int addressId = AlwaysConvert.ToInt(e.CommandArgument);
                if (addressId != 0)
                {
                    User user = AbleContext.Current.User;
                    int index = user.Addresses.IndexOf(addressId);
                    if (index > -1)
                    {
                        Address address = user.Addresses[index];

                        // MAKE SURE NO BASKET SHIPMENT IS ASSOCIATED WITH THIS ADDRESS
                        // OR ELSE IT WILL RESULT IN A FK VIOLATION
                        Basket basket = AbleContext.Current.User.Basket;
                        foreach (BasketShipment shipment in basket.Shipments)
                        {
                            Address shippingAddress = shipment.Address;
                            if (shippingAddress != null)
                            {
                                if (shippingAddress.Equals(address))
                                {
                                    shipment.Address = null;
                                }
                            }
                        }
                        basket.Save();

                        // DELETE THE ADDRESS
                        AbleContext.Current.User.Addresses.DeleteAt(index);
                    }
                    BindAddressBook();
                }
            }
            else if (e.CommandName == "Edit")
            {
                int addressId = AlwaysConvert.ToInt(e.CommandArgument);
                if (addressId != 0) ShowEditPanel(addressId);
            }
        }

        protected void ShowEditPanel(int addressId)
        {
            string queryString = (addressId != 0) ? "?AddressId=" + addressId.ToString() : string.Empty;
            Response.Redirect("~/Members/EditMyAddress.aspx" + queryString);
        }

        protected bool IsBillingAddress(object dataItem)
        {
            Address address = (Address)dataItem;
            return (address.Id == AlwaysConvert.ToInt(AbleContext.Current.User.PrimaryAddressId));
        }

        protected void EditPrimaryAddressButton_Click(object sender, EventArgs e)
        {
            ShowEditPanel(AlwaysConvert.ToInt(AbleContext.Current.User.PrimaryAddressId));
        }
    }
}