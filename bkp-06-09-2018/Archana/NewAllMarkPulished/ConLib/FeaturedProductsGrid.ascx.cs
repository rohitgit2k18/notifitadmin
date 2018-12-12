namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Products;

    [Description("Displays featured products")]
    public partial class FeaturedProductsGrid : System.Web.UI.UserControl
    {
        private string _Caption;
        private int _Size = 4;
        private int _Columns = -1;
        private bool _includeOutOfStockItems = false;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("If true out of stock items are also included for display")]
        public bool IncludeOutOfStockItems
        {
            get { return _includeOutOfStockItems; }
            set { _includeOutOfStockItems = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Featured Products")]
        [Description("The caption / title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(4)]
        [Description("Same as MaxItems")]
        public int Size
        {
            get { return _Size; }
            set { _Size = value; }
        }

        [Browsable(true), DefaultValue(4)]
        [Description("The maximum number of featured products that can be shown.")]
        public int MaxItems
        {
            get
            {
                if (_Size < 1) _Size = 1;
                return _Size;
            }
            set { _Size = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(2)]
        [Description("The number of columns to display in the grid.")]
        public int Columns
        {
            get
            {
                if (_Columns < 0) return ProductList.RepeatColumns;
                return _Columns;
            }
            set
            {
                _Columns = value;
                ProductList.RepeatColumns = Columns;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.Caption)) CaptionLabel.Text = this.Caption;
            ProductList.RepeatColumns = this.Columns;
            ProductList.ItemStyle.Width = new System.Web.UI.WebControls.Unit(100 / this.Columns, System.Web.UI.WebControls.UnitType.Percentage);
            var products = ProductDataSource.GetRandomFeaturedProducts(0, true, IncludeOutOfStockItems, this.Size);
            this.Visible = products != null && products.Count > 0;
            ProductList.DataSource = products;
            ProductList.DataBind();
        }
    }
}