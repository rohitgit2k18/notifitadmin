namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Catalog;

    [Description("Displays a web page item")]
    public partial class WebpageItemDisplay : System.Web.UI.UserControl
    {
        public Webpage Item { get; set; }

        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true image for the webpage item is displayed")]
        public bool ShowImage { get; set; }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true summary text is displayed")]
        public bool ShowSummary { get; set; }
        
        public WebpageItemDisplay() 
        {
            ShowImage = true;
            ShowSummary = false;
        }

        protected void Page_PreRender(Object sender, EventArgs e)
        {
            if (Item == null)
            {
                this.Visible = false;
                return;
            }

            // SHOW PRODUCT THUMBNAIL, ICON OR IMAGE
            ThumbnailPanel.Visible = ShowImage;
            if (ShowImage)
            {
                ThumbnailPanel.Visible = true;
                string imageUrl = string.Empty;
                string imageAltText = string.Empty;
                
                WebpageThumbnailLink.Visible = true;
                WebpageThumbnail.Visible = true;

                if (!string.IsNullOrEmpty(Item.ThumbnailUrl))
                {
                    WebpageThumbnail.ImageUrl = Item.ThumbnailUrl;
                    WebpageThumbnail.AlternateText = Item.ThumbnailAltText;
                    WebpageThumbnailLink.NavigateUrl = Item.NavigateUrl;
                }
                else
                {
                    WebpageThumbnail.Visible = false;
                    WebpageThumbnailLink.Visible = false;
                }
            }

            // SHOW PRODUCT NAME
            WebpageName.Text = Item.Name;
            WebpageName.NavigateUrl = Item.NavigateUrl;

            // SHOW PRODUCT SUMMARY
            SummaryPanel.Visible = ShowSummary;
            if (ShowSummary)
            {
                if (!string.IsNullOrEmpty(Item.Summary))
                    WebpageSummary.Text = Item.Summary;
                else
                    SummaryPanel.Visible = false;
            }
        }
    }
}