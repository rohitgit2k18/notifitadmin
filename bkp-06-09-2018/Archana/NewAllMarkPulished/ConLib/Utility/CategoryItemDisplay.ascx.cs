namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Catalog;

    [Description("Displays a category item")]
    public partial class CategoryItemDisplay : System.Web.UI.UserControl
    {
        public Category Item { get; set; }
        
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true category image will be displayed")]        
        public bool ShowImage { get; set; }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true summary text will be displayed")]
        public bool ShowSummary { get; set; }

        /// <summary>
        /// Specify the maximum lenght if you want truncate the summary text.
        /// </summary>
        [Browsable(true)]
        [DefaultValue(-1)]
        [Description("Maximum number of characters to display for summary. Value of 0 or less means no restriction.")]
        public int MaxSummaryLength { get; set; }

        public CategoryItemDisplay() 
        {
            ShowImage = true;
            ShowSummary = false;
            MaxSummaryLength = -1;
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
                
                CategoryThumbnailLink.Visible = true;
                CategoryThumbnail.Visible = true;

                if (!string.IsNullOrEmpty(Item.ThumbnailUrl))
                {
                    CategoryThumbnail.ImageUrl = Item.ThumbnailUrl;
                    CategoryThumbnail.AlternateText = string.IsNullOrEmpty(Item.ThumbnailAltText) ? Item.Name : Item.ThumbnailAltText;
                    CategoryThumbnailLink.NavigateUrl = Item.NavigateUrl;
                }
                else
                {
                    CategoryThumbnail.Visible = false;
                    CategoryThumbnailLink.Visible = false;
                }
            }

            // SHOW PRODUCT NAME
            CategoryName.Text = Item.Name;
            CategoryName.NavigateUrl = Item.NavigateUrl;

            // SHOW PRODUCT SUMMARY
            SummaryPanel.Visible = ShowSummary;
            if (ShowSummary)
            {
                 if (!string.IsNullOrEmpty(Item.Summary))
                {
                    if (MaxSummaryLength > 0 && Item.Summary.Length > MaxSummaryLength) CategorySummary.Text = Item.Summary.Substring(0, MaxSummaryLength) + "...";
                    else CategorySummary.Text = Item.Summary;
                }
                else
                    SummaryPanel.Visible = false;
            }
        }
    }
}