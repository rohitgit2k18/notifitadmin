namespace AbleCommerce.Mobile.UserControls
{
    using System;
    using CommerceBuilder.Products;

    public partial class FeaturedProducts : System.Web.UI.UserControl
    {
        private string _Caption;
        private int _Size = 2;
        private bool _includeOutOfStockItems = false;

        public bool IncludeOutOfStockItems
        {
            get { return _includeOutOfStockItems; }
            set { _includeOutOfStockItems = value; }
        }

        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        public int Size
        {
            get { return _Size; }
            set { _Size = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.Caption)) CaptionLabel.Text = this.Caption;
            ProductList.DataSource = ProductDataSource.GetRandomFeaturedProducts(0, true, IncludeOutOfStockItems, this.Size);
            ProductList.DataBind();
        }
    }
}