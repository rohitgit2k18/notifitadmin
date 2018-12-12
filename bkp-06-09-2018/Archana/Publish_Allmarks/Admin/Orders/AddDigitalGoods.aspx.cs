namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Web.UI.WebControls;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Utility;

    public partial class AddDigitalGoods : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _OrderId;
        private Order _Order;

        protected void Page_Load(object sender, EventArgs e)
        {
            _OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            _Order = OrderDataSource.Load(_OrderId);
            if (_Order == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, _Order.OrderNumber);
            SearchName.Focus();
            CancelLink.NavigateUrl = string.Format(CancelLink.NavigateUrl, _Order.OrderNumber);
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            SearchResultsGrid.Visible = true;
            SearchResultsGrid.DataBind();
        }

        protected void OkButton_Click(object sender, EventArgs e)
        {
            // Looping through all the rows in the GridView
            foreach (GridViewRow row in SearchResultsGrid.Rows)
            {
                CheckBox checkbox = (CheckBox)row.FindControl("SelectCheckbox");
                if ((checkbox != null) && (checkbox.Checked))
                {
                    // Retreive the DigitalGood
                    int digitalGoodId = Convert.ToInt32(SearchResultsGrid.DataKeys[row.RowIndex].Value);
                    DigitalGood dg = DigitalGoodDataSource.Load(digitalGoodId);

                    // ( Bug 8262 ) CREATE A NEW ORDER ITEM FOR EACH DIGITAL GOOD
                    OrderItem oi = new OrderItem();
                    oi.OrderId = _OrderId;
                    oi.CustomFields["DigitalGoodIndicator"] = "1";
                    oi.Name = dg.Name;
                    oi.OrderItemType = OrderItemType.Product;
                    oi.Price = 0;
                    oi.Quantity = 1;
                    oi.Shippable = Shippable.No;
                    oi.IsHidden = true;
                    oi.Save();

                    OrderItemDigitalGood orderItemDigitalGood = new OrderItemDigitalGood();
                    orderItemDigitalGood.OrderItemId = oi.Id;
                    orderItemDigitalGood.DigitalGoodId = digitalGoodId;
                    orderItemDigitalGood.Name = dg.Name;
                    orderItemDigitalGood.Save();
                    orderItemDigitalGood.Save();
                }
            }
            Response.Redirect(string.Format("ViewDigitalGoods.aspx?OrderNumber={0}", _Order.OrderNumber));
        }
    }
}