namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;

    [Description("Display new products.")]
    public partial class WhatsNewDialog : System.Web.UI.UserControl, ISidebarControl
    {
        private string _Caption;
        private int _MaxItems = 3;
        private int _Columns = -1;
        private int _Days = 30;
        private bool _UseDays = true;

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
        [Browsable(true), DefaultValue("What's New")]
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

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(30)]
        [Description("Indicates the number of days to take into consideration for deciding newness of products.")]
        public int Days
        {
            get { return _Days; }
            set { _Days = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("Indicates whether to use days for deciding the newness of products.")]
        public bool UseDays
        {
            get { return _UseDays; }
            set { _UseDays = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            IList<Product> products = ProductDataSource.GetNewProducts(this.UseDays, this.Days, this.MaxItems, 0, "CreatedDate DESC");
            if (products != null && products.Count > 0)
            {
                if (!string.IsNullOrEmpty(this.Caption)) CaptionLabel.Text = this.Caption;
                ProductList.RepeatColumns = Columns;
                ProductList.DataSource = products;
                ProductList.DataBind();
            }
            else this.Visible = false;
        }
    }
}