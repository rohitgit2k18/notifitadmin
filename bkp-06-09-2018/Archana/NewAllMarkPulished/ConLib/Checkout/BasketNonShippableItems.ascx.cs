namespace AbleCommerce.ConLib.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Taxes;

    [Description("Displays non-shippable items in a basket")]
    public partial class BasketNonShippableItems : System.Web.UI.UserControl
    {
        private bool _ShowSku = true;
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true SKU is shown")]
        public bool ShowSku
        {
            get { return _ShowSku; }
            set { _ShowSku = value; }
        }

        private bool _ShowTaxes = false;
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true taxes are shown")]
        public bool ShowTaxes
        {
            get { return _ShowTaxes; }
            set { _ShowTaxes = value; }
        }

        private bool _ShowPrice = true;
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true price is shown")]
        public bool ShowPrice
        {
            get { return _ShowPrice; }
            set { _ShowPrice = value; }
        }

        private bool _ShowTotal = true;
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true total is shown")]
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

                NonShippingItemsGrid.Columns[2].Visible = this.ShowSku;
                
                //HIDE THE COLUMNS BASED ON SETTING
                NonShippingItemsGrid.Columns[3].HeaderText = TaxHelper.TaxColumnHeader;
                NonShippingItemsGrid.Columns[3].Visible = TaxHelper.ShowTaxColumn && this.ShowTaxes;

                NonShippingItemsGrid.Columns[4].Visible = this.ShowPrice;
                NonShippingItemsGrid.Columns[6].Visible = this.ShowTotal;
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

        public GridView NonShippingItemsGridControl
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