namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Common;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;

    [Description("Control that implements the product detail page. Instead of tabs, separate rows are used to display different sections of information.")]
    public partial class ProductRow : System.Web.UI.UserControl
    {
        private int _ProductId;
        private Product _Product;
        private StoreSettingsManager _settings;
        private User _user;
        private bool _showVariantThumbnail = false;

        private string _OptionsView = "DROPDOWN";
        [Browsable(true), DefaultValue("DROPDOWN")]
        [Description("Indicates whether the product options will be displayed as dropdowns or you want to show variants in a grid. Possible values are 'DROPDOWN' and 'TABULAR'")]
        public string OptionsView 
        {
            get { return _OptionsView;  }
            set { _OptionsView = value; }
        }

        [Browsable(true), DefaultValue(false)]
        [Description("If true thumbnails will be shown for variants. This setting only works for 'TABULAR' view.")]
        public bool ShowVariantThumbnail
        {
            get { return _showVariantThumbnail; }
            set { _showVariantThumbnail = value; }
        }

        private bool _ShowAddAndUpdateButtons = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true inventory is add button will be shown while editing basket items")]
        public bool ShowAddAndUpdateButtons
        {
            get { return _ShowAddAndUpdateButtons; }
            set { _ShowAddAndUpdateButtons = value; }
        }

        private bool _ShowPartNumber = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true Part/Model number is displayed")]
        public bool ShowPartNumber
        {
            get { return _ShowPartNumber; }
            set { _ShowPartNumber = value; }
        }

        private string _GTINName = "GTIN";
        [Browsable(true), DefaultValue("GTIN")]
        [Description("Indicates the display name. Possible values are 'GTIN', 'UPC' and 'ISBN'")]
        public string GTINName
        {
            get { return _GTINName; }
            set { _GTINName = value; }
        }

        private bool _ShowGTIN = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true GTIN number is displayed")]
        public bool ShowGTIN
        {
            get { return _ShowGTIN; }
            set { _ShowGTIN = value; }
        }

        private bool _DisplayBreadCrumbs = true;
        /// <summary>
        /// Indicates whether the breadcrumbs should be displayed or not, default value is true
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates whether the breadcrumbs should be displayed or not, default value is true.")]
        public bool DisplayBreadCrumbs
        {
            get { return _DisplayBreadCrumbs; }
            set { _DisplayBreadCrumbs = value; }
        }

        protected void Page_InIt(object sender, EventArgs e)
        {
            switch (OptionsView.ToUpper())
            { 
                case "DROPDOWN":
                    BuyProductDialog1.Visible = true;
                    BuyProductDialog1.ShowAddAndUpdateButtons = ShowAddAndUpdateButtons;
                    BuyProductDialog1.ShowPartNumber = ShowPartNumber;
                    BuyProductDialog1.ShowGTIN = ShowGTIN;
                    BuyProductDialog1.GTINName = GTINName;
                    BuyProductDialogOptionsList1.Visible = false;
                    break;

                case "TABULAR":
                    BuyProductDialog1.Visible = false;
                    BuyProductDialogOptionsList1.Visible = true;
                    BuyProductDialogOptionsList1.ShowThumbnail = ShowVariantThumbnail;
                    BuyProductDialogOptionsList1.ShowPartNumber = ShowPartNumber;
                    BuyProductDialogOptionsList1.GTINName = GTINName;
                    BuyProductDialog1.ShowGTIN = ShowGTIN;
                    break;

                default:
                    BuyProductDialog1.Visible = true;
                    BuyProductDialog1.ShowAddAndUpdateButtons = ShowAddAndUpdateButtons;
                    BuyProductDialog1.ShowPartNumber = ShowPartNumber;
                    BuyProductDialog1.ShowGTIN = ShowGTIN;
                    BuyProductDialog1.GTINName = GTINName;
                    BuyProductDialogOptionsList1.Visible = false;
                    break;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _ProductId = AbleCommerce.Code.PageHelper.GetProductId();
            _Product = ProductDataSource.Load(_ProductId);
            _settings = AbleContext.Current.Store.Settings;
            _user = AbleContext.Current.User;
            if(_Product != null)
            {
                CategoryBreadCrumbs1.Visible = DisplayBreadCrumbs;

                ProductName.Text = _Product.Name;
                
                if (_Product.Manufacturer != null)
                {
                    Manufacturer manufacturer = _Product.Manufacturer;
                    ManufacturerDetails.Controls.Add(new LiteralControl("Other products by "));
                    ManufacturerDetails.Controls.Add(new LiteralControl(string.Format("<a href='{0}?m={1}' itemprop='manufacturer'>{2}</a><br />", Page.ResolveUrl("~/Search.aspx"), manufacturer.Id, manufacturer.Name)));
                }
            }
        }
    }
}