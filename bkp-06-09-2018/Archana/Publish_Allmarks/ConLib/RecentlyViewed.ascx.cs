namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Configuration;
    using System.Data;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.UI;

    [Description("Displays a list or grid of recently viewed products.")]
    public partial class RecentlyViewed : System.Web.UI.UserControl, ISidebarControl
    {
        private string _Caption = "Recently Viewed";
        private int _MaxItems = 5;
        private int _Columns = -1;

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
                _Columns = value;
                ProductList.RepeatColumns = Columns;
            }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Recently Viewed")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(5)]
        [Description("The maximum number of products that can be shown.")]
        public int MaxItems
        {
            get { return _MaxItems; }
            set { _MaxItems = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            phCaption.Text = this.Caption;
            int userId = AbleContext.Current.UserId;
            if (userId != 0)
            {
                IList<Product> products = PageViewDataSource.GetRecentlyViewedProducts(userId, this.MaxItems, 0, "ActivityDate DESC");
                if (products.Count > 0)
                {
                    ProductList.RepeatColumns = Columns;
                    ProductList.DataSource = products;
                    ProductList.DataBind();
                }
                else phContent.Visible = false;
            }
            else phContent.Visible = false;
        }
    }
}