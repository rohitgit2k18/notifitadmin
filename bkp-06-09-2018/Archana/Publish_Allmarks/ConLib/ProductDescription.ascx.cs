namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using System.Web.UI;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    [Description("A control to display product descriptions.")]
    public partial class ProductDescription : System.Web.UI.UserControl
    {
        private string _DescriptionCaption = "Description";
        private string _MoreDetailCaption = "More Details";
        private bool _ShowCustomFields = true;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Description")]
        [Description("Caption for description")]
        public string DescriptionCaption
        {
            get { return _DescriptionCaption; }
            set { _DescriptionCaption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("More Details")]
        [Description("Caption for detailed description")]
        public string MoreDetailCaption
        {
            get { return _MoreDetailCaption; }
            set { _MoreDetailCaption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("If true custom fields will be shown")]
        public bool ShowCustomFields
        {
            get { return _ShowCustomFields; }
            set { _ShowCustomFields = value; }
        }

        private bool ShowMore
        {
            get
            {
                if (ViewState["ShowMore"] == null) return false;
                return (bool)ViewState["ShowMore"];
            }
            set
            {
                ViewState["ShowMore"] = value;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if ((!Page.IsPostBack) && (Request.QueryString["More"] == "1")) ShowMore = true;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            int _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            Product _Product = ProductDataSource.Load(_ProductId);
            if (_Product != null)
            {
                bool hasMoreInfo = !string.IsNullOrEmpty(_Product.ExtendedDescription);
                if (this.ShowMore && hasMoreInfo)
                {
                    phCaption.Text = MoreDetailCaption;
                    phDescription.Text = _Product.ExtendedDescription;
                    More.Visible = false;
                    Less.Visible = true;
                }
                else
                {
                    phCaption.Text = DescriptionCaption;
                    phDescription.Text = _Product.Description;
                    More.Visible = hasMoreInfo;
                    Less.Visible = false;
                }
            }
        }

        protected void More_Click(object sender, EventArgs e)
        {
            ShowMore = true;
        }

        protected void Less_Click(object sender, EventArgs e)
        {
            ShowMore = false;
        }
    }
}