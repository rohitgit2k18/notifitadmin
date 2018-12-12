namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    [Description("Display additional details of assets of a product like digital goods, read me files and license agreements.")]
    public partial class ProductAssets : System.Web.UI.UserControl
    {
        private string _Caption = "Additional Details";

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Additional Details")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            Product _Product = ProductDataSource.Load(_ProductId);
            if (_Product != null)
            {
                List<AbleCommerce.Code.ProductAssetWrapper> assetList = AbleCommerce.Code.ProductHelper.GetAssets(this.Page, _Product, "javascript:window.close()");
                if (assetList.Count > 0)
                {
                    CaptionText.Text = this.Caption;
                    AssetLinkList.DataSource = assetList;
                    AssetLinkList.DataBind();
                    ProductAssetsPanel.Visible = true;
                }
            }
        }
    }
}