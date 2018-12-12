namespace AbleCommerce.Admin.Orders
{
    using System;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class ViewDownloads : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private OrderItemDigitalGood _OrderItemDigitalGood;
        private int _OrderItemDigitalGoodId = 0;

        protected OrderItemDigitalGood OrderItemDigitalGood
        {
            get
            {
                if (_OrderItemDigitalGood == null)
                {
                    _OrderItemDigitalGood = OrderItemDigitalGoodDataSource.Load(this.OrderItemDigitalGoodId);
                }
                return _OrderItemDigitalGood;
            }
        }

        protected int OrderItemDigitalGoodId
        {
            get
            {
                if (_OrderItemDigitalGoodId.Equals(0))
                {
                    _OrderItemDigitalGoodId = AlwaysConvert.ToInt(Request.QueryString["OrderItemDigitalGoodId"]);
                }
                return _OrderItemDigitalGoodId;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (OrderItemDigitalGood == null) Response.Redirect("Default.aspx");
            string name = (OrderItemDigitalGood.DigitalGood != null) ? OrderItemDigitalGood.DigitalGood.Name : OrderItemDigitalGood.OrderItem.Name;
            Caption.Text = string.Format(Caption.Text, name);
            DownloadsGrid.DataSource = OrderItemDigitalGood.Downloads;
            DownloadsGrid.DataBind();
            Order order = OrderItemDigitalGood.OrderItem.Order;
            DigitalGoodsLink.NavigateUrl += "?OrderNumber=" + order.OrderNumber.ToString();
        }
    }
}