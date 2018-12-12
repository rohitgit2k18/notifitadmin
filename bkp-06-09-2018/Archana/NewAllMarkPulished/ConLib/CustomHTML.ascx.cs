namespace AbleCommerce.ConLib
{
    using System;
    using CommerceBuilder.UI;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using System.Web.UI;

    public partial class CustomHTML : System.Web.UI.UserControl, ISidebarControl, IHeaderControl, IFooterControl
    {
        private int _WebPageId = -1;
        private string _Caption;
        private Webpage _Webpage;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Sample Header Text")]
        [Description("The caption / title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(-1)]
        [Description("The id of the web page to load custom HTML in sidebar panel.")]
        public int WebPageId
        {
            get { return _WebPageId; }
            set { _WebPageId = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.Caption)) CaptionLabel.Text = this.Caption;
            if (_WebPageId > 0) _Webpage = WebpageDataSource.Load(_WebPageId);
            if (_Webpage != null && !string.IsNullOrEmpty(_Webpage.Description))
            {
                CustomHTMLPanel.Controls.Clear();
                CustomHTMLPanel.Controls.Add(new LiteralControl(_Webpage.Description));
            }
        }
    }
}