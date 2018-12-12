using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CommerceBuilder.Orders;
using CommerceBuilder.Taxes;

namespace AbleCommerce.Mobile.UserControls.Account
{
    public partial class OrderNonShippableItems : System.Web.UI.UserControl
    {
        public Order Order { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Order != null)
            {
                //BIND NONSHIPPING ITEMS
                IList<OrderItem> nonShippingItems = AbleCommerce.Code.OrderHelper.GetNonShippingItems(this.Order);
                if (nonShippingItems.Count > 0)
                {
                    NonShippingItemsGrid.DataSource = nonShippingItems;
                    NonShippingItemsGrid.DataBind();
                }
                else
                {
                    NonShippingItemsPanel.Visible = false;
                }
            }
            else NonShippingItemsPanel.Visible = false;
        }

        protected void ItemsGrid_DataBinding(object sender, EventArgs e)
        {
            GridView grid = (GridView)sender;
            grid.Columns[3].Visible = TaxHelper.ShowTaxColumn;
            grid.Columns[3].HeaderText = TaxHelper.TaxColumnHeader;
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            OrderItem item = (OrderItem)dataItem;
            return item.OrderItemType == OrderItemType.Product
                && item.Product != null;
        }
    }
}