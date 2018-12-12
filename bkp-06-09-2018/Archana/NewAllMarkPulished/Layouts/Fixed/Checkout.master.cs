using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Orders;

namespace AbleCommerce.Layouts.Fixed
{
    public partial class Checkout : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool isBootstrap = AbleCommerce.Code.PageHelper.IsResponsiveTheme(this.Page);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            Basket basket = user.Basket;
            int itemsCount = 0;

            foreach (BasketItem item in basket.Items)
            {
                if (item.OrderItemType == OrderItemType.Product)
                {
                    bool countItem = !item.IsChildItem;
                    if (!countItem)
                    {
                        BasketItem parentItem = item.GetParentItem(false);
                        if (parentItem != null)
                        {
                            countItem = parentItem.Product.IsKit && parentItem.Product.Kit.ItemizeDisplay;
                        }
                    }

                    if (countItem)
                    {
                        itemsCount += item.Quantity;
                    }
                }
            }
        }         
    }
}