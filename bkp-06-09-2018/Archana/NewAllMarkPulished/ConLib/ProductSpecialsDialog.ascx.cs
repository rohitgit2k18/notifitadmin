namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;

    [Description("Displays product specials")]
    public partial class ProductSpecialsDialog : System.Web.UI.UserControl, ISidebarControl
    {
        private string _Caption;
        private int _MaxItems = 3;
        private int _Columns = -1;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Product Specials")]
        [Description("The caption / title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Browsable(true), DefaultValue(3)]
        [Description("The maximum number of product specials that can be shown.")]
        public int MaxItems
        {
            get { return _MaxItems; }
            set { _MaxItems = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(1)]
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
                if (value >= 1)
                {
                    _Columns = value;
                    ProductList.RepeatColumns = Columns;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {   
            ProductList.ItemStyle.Width = new System.Web.UI.WebControls.Unit(100 / this.Columns, System.Web.UI.WebControls.UnitType.Percentage);
            var products = ProductDataSource.GetProductSpecials(this.MaxItems, 0);
            if (products != null && products.Count > 0)
            {
                if (!string.IsNullOrEmpty(this.Caption)) CaptionLabel.Text = this.Caption;
                ProductList.RepeatColumns = this.Columns;
                ProductList.DataSource = products;
                ProductList.DataBind();
            }
            else this.Visible = false;
        }
    }
}