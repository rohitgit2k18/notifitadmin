namespace AbleCommerce.Admin.Orders.Edit
{
    using System;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class FindProductControl : System.Web.UI.UserControl
    {
        private int _OrderId;
        private int _OrderShipmentId;
        private Order _Order;
        private OrderShipment _OrderShipment;

        protected int OrderId
        {
            set
            {
                _OrderId = value;
                _Order = OrderDataSource.Load(_OrderId);
            }
            get { return _OrderId; }
        }

        protected int OrderShipmentId
        {
            set
            {
                _OrderShipmentId = value;
                _OrderShipment = OrderShipmentDataSource.Load(_OrderShipmentId);
                if (_OrderShipment != null) _Order = _OrderShipment.Order;
            }
            get { return _OrderShipmentId; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (_Order == null) OrderId = AbleCommerce.Code.PageHelper.GetOrderId();
            if (_OrderShipment == null) OrderShipmentId = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
            if (_Order == null) Response.Redirect("~/Admin/Orders/Default.aspx");
        }

        protected void FindProductSearchButton_Click(object sender, EventArgs e)
        {
            string name = string.Empty;
            string sku = string.Empty;
            if (FindProductSearchField.SelectedIndex == 0)
            {
                name = FindProductSearchText.Text;
            }
            else
            {
                sku = FindProductSearchText.Text;
            }
            HiddenName.Value = name;
            HiddenSku.Value = sku;
            FindProductSearchResults.Visible = true;
            FindProductSearchResults.DataBind();
        }

        protected string GetAddLinkURL(int productId)
        {
            if (_OrderShipment != null) return "~/Admin/Orders/Shipments/AddProduct.aspx?OrderShipmentId=" + _OrderShipmentId + "&ProductId=" + productId;
            else return "~/Admin/Orders/Edit/AddProduct.aspx?OrderNumber=" + _Order.OrderNumber + "&ProductId=" + productId;
        }
    }
}