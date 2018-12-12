namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;

    [Description("Display top seller products.")]    
    public partial class PopularProductsDialog : System.Web.UI.UserControl, ISidebarControl
    {
        private string _Caption = "Top Sellers";
        private int _MaxItems = 3;
        private int _Columns = -1;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(1)]
        [Description("The number of columns to display.")]
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

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Top Sellers")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(3)]
        [Description("The maximum number of products that can be shown.")]
        public int MaxItems
        {
            get { return _MaxItems; }
            set { _MaxItems = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int prefferedCategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            IList<Product> products = ProductDataSource.GetPopularProducts(this.MaxItems, prefferedCategoryId);
            if (products != null && products.Count > 0)
            {
                CaptionLabel.Text = this.Caption;
                ProductList.RepeatColumns = Columns;
                ProductList.DataSource = products;
                ProductList.DataBind();
            }
            else
            {
                this.Visible = false;
            }
        }
    }
}