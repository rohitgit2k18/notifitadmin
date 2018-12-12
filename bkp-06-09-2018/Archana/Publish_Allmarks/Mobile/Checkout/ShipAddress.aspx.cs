using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;
using CommerceBuilder.Users;
using CommerceBuilder.Common;
using CommerceBuilder.Utility;
using CommerceBuilder.Services.Checkout;
using CommerceBuilder.Orders;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.Checkout
{
    public partial class ShipAddress : AbleCommercePage
    {
        User _user;
        private Basket _Basket;

        protected void Page_Load(object sender, EventArgs e)
        {
            _user = AbleContext.Current.User;
            if (!Page.IsPostBack)
            {
                BindUserAddresses();
            }

            _Basket = AbleContext.Current.User.Basket;
            if (_Basket.Items.Count == 0)
            {
                Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Basket.aspx"));
            }

            AddNewAddressLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/Checkout/EditShipAddress.aspx");
        }

        protected void BindUserAddresses() 
        {
            ShipToAddressList.DataSource = AbleContext.Current.User.Addresses;
            ShipToAddressList.DataBind();
        }

        protected void ShipToAddressList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Pick")
            {
                int addressId = AlwaysConvert.ToInt(e.CommandArgument);
                User user = AbleContext.Current.User;
                int index = user.Addresses.IndexOf(addressId);
                if (index > -1)
                {
                    // RESET BASKET PACKAGING
                    IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                    preCheckoutService.Package(user.Basket, true);
                    Address address = user.Addresses[index];

                    // UPDATE DESTINATION TO SELECTED ADDRESS AND REDIRECT
                    foreach (BasketShipment shipment in user.Basket.Shipments)
                    {
                        shipment.Address = address;
                    }
                    user.Basket.Save();
                    Response.Redirect("ShipMethod.aspx");
                }
            }
            else if (e.CommandName == "Edit")
            {
                int addressId = AlwaysConvert.ToInt(e.CommandArgument);
                Response.Redirect(string.Format("EditShipAddress.aspx?AddressId={0}", addressId));
            }
        }
    }
}