
namespace AbleCommerce.ConLib.Utility
{
    using System;
    using CommerceBuilder.Catalog;
    using System.ComponentModel;

    [Description("Displays a link item")]
    public partial class LinkItemDisplay : System.Web.UI.UserControl
    {
        public Link Item { get; set; }

        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true link image will be displayed")]
        public bool ShowImage { get; set; }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true summary text will be displayed")]
        public bool ShowSummary { get; set; }

        public LinkItemDisplay() 
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
                
                LinkThumbnailLink.Visible = true;
                LinkThumbnail.Visible = true;

                if (!string.IsNullOrEmpty(Item.ThumbnailUrl))
                {
                    LinkThumbnail.ImageUrl = Item.ThumbnailUrl;
                    LinkThumbnail.AlternateText = Item.ThumbnailAltText;
                    LinkThumbnailLink.NavigateUrl = Item.NavigateUrl;
                    LinkThumbnailLink.Target = Item.TargetWindow;
                }
                else
                {
                    LinkThumbnail.Visible = false;
                    LinkThumbnailLink.Visible = false;
                }
            }

            // SHOW PRODUCT NAME
            LinkName.Text = Item.Name;
            LinkName.NavigateUrl = Item.NavigateUrl;

            // SHOW PRODUCT SUMMARY
            SummaryPanel.Visible = ShowSummary;
            if (ShowSummary)
            {
                if (!string.IsNullOrEmpty(Item.Summary))
                    LinkSummary.Text = Item.Summary;
                else
                    SummaryPanel.Visible = false;
            }
        }
    }
}