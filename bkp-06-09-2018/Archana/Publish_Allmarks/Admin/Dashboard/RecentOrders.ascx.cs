namespace AbleCommerce.Admin.Dashboard
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Common;

    public partial class RecentOrders : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IList<Order> orders = OrderDataSource.LoadForStore(AbleContext.Current.StoreId, 5, 0, "OrderDate DESC");
            RecentOrdersGrid.DataSource = orders;
            RecentOrdersGrid.DataBind();
        }
    }
}