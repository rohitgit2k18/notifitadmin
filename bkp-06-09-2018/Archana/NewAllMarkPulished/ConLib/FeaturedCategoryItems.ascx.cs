namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using System.ComponentModel;

    [Description("Displays featured items in a category.")]
    public partial class FeaturedCategoryItems : System.Web.UI.UserControl
    {
        private string _Caption = "Featured Items";
        private int _MaxItems = 3;
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
        [Browsable(true), DefaultValue("Featured Items")]
        [Description("The caption / title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(3)]
        [Description("The maximum number of featured items that can be shown.")]
        public int MaxItems
        {
            get
            {
                if (_MaxItems < 1) _MaxItems = 1;
                return _MaxItems;
            }
            set { _MaxItems = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(3)]
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
            int _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            Category _Category = CategoryDataSource.Load(_CategoryId);

            if (_Category != null)
            {
                //GET FEATURED PRODUCTS IN CATEGORY
                IList<Product> featured = ProductDataSource.GetFeaturedProducts(_CategoryId, true, IncludeOutOfStockItems, _MaxItems, 0);
                //MAKE SURE WE HAVE SOMETHING TO SHOW
                if (featured.Count > 0)
                {
                    //SET CAPTION
                    phCaption.Text = this.Caption;
                    //BIND THE PRODUCTS
                    ProductList.RepeatColumns = this.Columns;
                    ProductList.DataSource = featured;
                    ProductList.DataBind();
                }
                else
                {
                    //THERE ARE NOT ANY ITEMS TO DISPLAY
                    phContent.Visible = false;
                }
            }
        }

        private string _Width = string.Empty;
        protected string Width
        {
            get { return _Width; }
        }
    }
}