namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    [Description("Display Upsell/Accessory products of a product. This page is normally displayed when a product that has Upsell/Accessories gets added to cart.")]
    public partial class ProductAccessoriesGrid : System.Web.UI.UserControl
    {
        private int _ProductId = 0;
        private Product _Product = null;

        private string _Caption;
        private int _Size = 6;
        private int _Columns = -1;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Consider purchasing for the {0}")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(6)]
        [Description("The maximum number of products that are shown.")]
        public int Size
        {
            get { return _Size; }
            set { _Size = value; }
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
            set { _Columns = value; }
        }

        protected void Page_Init(object sender, System.EventArgs e)
        {
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {            
            CaptionLabel.Text = string.Format(CaptionLabel.Text, _Product.Name);
            InstructionText.Text = string.Format(InstructionText.Text, _Product.Name);
            KeepShoppingLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetReturnUrl(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
            ProductList.RepeatColumns = this.Columns;
            ProductList.DataSource = _Product.GetUpsellProducts(true, true);
            ProductList.DataBind();
        }
    }
}