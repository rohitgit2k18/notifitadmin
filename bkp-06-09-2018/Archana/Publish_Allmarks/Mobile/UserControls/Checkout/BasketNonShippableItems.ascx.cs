namespace AbleCommerce.Mobile.UserControls.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;

    public partial class BasketNonShippableItems : System.Web.UI.UserControl
    {
        private bool _ShowSku = true;
        public bool ShowSku
        {
            get { return _ShowSku; }
            set { _ShowSku = value; }
        }

        private bool _ShowTaxes = false;
        public bool ShowTaxes
        {
            get { return _ShowTaxes; }
            set { _ShowTaxes = value; }
        }

        private bool _ShowPrice = true;
        public bool ShowPrice
        {
            get { return _ShowPrice; }
            set { _ShowPrice = value; }
        }

        private bool _ShowTotal = true;
        public bool ShowTotal
        {
            get { return _ShowTotal; }
            set { _ShowTotal = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Basket basket = AbleContext.Current.User.Basket;

            // BIND NONSHIPPING ITEMS
            IList<BasketItem> nonShippingItems = AbleCommerce.Code.BasketHelper.GetNonShippingItems(basket);
            if (nonShippingItems.Count > 0)
            {
                nonShippingItems.Sort(new BasketItemComparer());
                NonShippingItemsPanel.Visible = true;
                NonShippingItemsGrid.DataSource = nonShippingItems;
                NonShippingItemsGrid.DataBind();
            }
            else
            {
                NonShippingItemsPanel.Visible = false;
            }
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }

        public Repeater NonShippingItemsGridControl
        {
            get 
            {
                return this.NonShippingItemsGrid;
            }
        }

        protected string GetTaxHeader()
        {
            return TaxHelper.TaxColumnHeader;
        }
    }
}