using System;
using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Members
{
    public partial class MySerialKey : CommerceBuilder.UI.AbleCommercePage
    {
        private int _OrderItemDigitalGoodId;
        private OrderItemDigitalGood _OrderItemDigitalGood;

        protected void Page_Init(object sender, EventArgs e)
        {
            _OrderItemDigitalGoodId = AlwaysConvert.ToInt(Request.QueryString["OrderItemDigitalGoodId"]);
            _OrderItemDigitalGood = OrderItemDigitalGoodDataSource.Load(_OrderItemDigitalGoodId);
            if (_OrderItemDigitalGood == null) Response.Redirect("MyAccount.aspx");
            if ((_OrderItemDigitalGood.OrderItem.Order.UserId != AbleContext.Current.UserId) && (!AbleContext.Current.User.IsInRole(Role.OrderAdminRoles))) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page, "Members/MyAccount.aspx"));
            //UPDATE CAPTION
            Caption.Text = String.Format(Caption.Text, _OrderItemDigitalGood.DigitalGood.Name);
            SerialKeyData.Text = _OrderItemDigitalGood.SerialKeyData;
        }
    }
}