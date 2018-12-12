namespace AbleCommerce.Admin._Store.OrderStatuses
{
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Utility;

    public partial class DeleteOrderStatus : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _OrderStatusId = 0;
        OrderStatus _OrderStatus;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            _OrderStatusId = AlwaysConvert.ToInt(Request.QueryString["OrderStatusId"]);
            _OrderStatus = OrderStatusDataSource.Load(_OrderStatusId);
            if (_OrderStatus == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, _OrderStatus.Name);
            InstructionText.Text = string.Format(InstructionText.Text, _OrderStatus.Name);
            BindOrderStatuses();
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected void DeleteButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid)
            {
                _OrderStatus.Delete(AlwaysConvert.ToInt(OrderStatusList.SelectedValue));
                Response.Redirect("Default.aspx");
            }
        }

        private void BindOrderStatuses()
        {
            IList<OrderStatus> orderStatuses = OrderStatusDataSource.LoadAll("Name");
            int index = orderStatuses.IndexOf(_OrderStatusId);
            if (index > -1) orderStatuses.RemoveAt(index);
            OrderStatusList.DataSource = orderStatuses;
            OrderStatusList.DataBind();
        }
    }
}