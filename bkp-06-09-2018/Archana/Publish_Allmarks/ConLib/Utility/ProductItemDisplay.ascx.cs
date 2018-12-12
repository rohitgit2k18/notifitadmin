namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using System.Linq;

    [Description("Displays a product item")]
    public partial class ProductItemDisplay : System.Web.UI.UserControl
    {
        public Product Item { get; set; }

        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true product name is displayed")]
        public bool ShowName { get; set; }

        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true product image is displayed")]
        public bool ShowImage { get; set; }
        
        [Browsable(true)]
        [DefaultValue("THUMBNAIL")]
        [Description("The type of image to display. Valid values are THUMBNAIL, ICON and IMAGE")]
        public string ImageType { get; set; }
        
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true price is displayed")]
        public bool ShowPrice { get; set; }
        
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true SKU is displayed")]
        public bool ShowSku { get; set; }
        
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true manufacturer is displayed")]
        public bool ShowManufacturer { get; set; }
        
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true rating stars are displayed")]
        public bool ShowRating { get; set; }
        
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true summary text is displayed")]
        public bool ShowSummary { get; set; }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true add-to-cart button is displayed")]
        public bool ShowAddToCart { get; set; }

        /// <summary>
        /// Specify the maximum lenght if you want truncate the summary text.
        /// </summary>
        [Browsable(true)]
        [DefaultValue(-1)]
        [Description("Maximum number of characters to display for summary. Value of 0 or less means no restriction.")]
        public int MaxSummaryLength { get; set; }

        public ProductItemDisplay() 
        {
            ShowName = true;
            ShowImage = true;
            ImageType = "THUMBNAIL";
            ShowPrice = true;
            ShowSku = true;
            ShowRating = true;
            ShowManufacturer = false;
            ShowSummary = false;
            ShowAddToCart = false;
            MaxSummaryLength = -1;
        }

        protected void Page_PreRender(Object sender, EventArgs e)
        {
            if (Item == null)
            {
                this.Visible = false;
                return;
            }

            ProductPrice.Product = Item;
            ProductAddToCart.ProductId = Item.Id;

            // SHOW PRODUCT THUMBNAIL, ICON OR IMAGE
            ThumbnailPanel.Visible = ShowImage;
            if (ShowImage)
            {
                ThumbnailPanel.Visible = true;
                
                ProductThumbnailLink.Visible = true;
                ProductThumbnail.Visible = true;

                switch (ImageType.ToUpper())
                {
                    case "THUMBNAIL":
                        if (!string.IsNullOrEmpty(Item.ThumbnailUrl))
                        {
                            ProductThumbnail.ImageUrl = Item.ThumbnailUrl;
                            ProductThumbnail.AlternateText = Item.ThumbnailAltText;
                        }
                        else
                        {
                            ProductThumbnail.Visible = false;
                            NoThumbnail.Visible = true;
                        }
                        break;

                    case "ICON":
                        if (!string.IsNullOrEmpty(Item.IconUrl))
                        {
                            ProductThumbnail.ImageUrl = Item.IconUrl;
                            ProductThumbnail.AlternateText = Item.IconAltText;
                        }
                        else
                        {
                            ProductThumbnail.Visible = false;
                            NoIcon.Visible = true;
                        }
                        break;

                    case "IMAGE":
                        if (!string.IsNullOrEmpty(Item.ImageUrl))
                        {
                            ProductThumbnail.ImageUrl = Item.ImageUrl;
                            ProductThumbnail.AlternateText = Item.ImageAltText;
                        }
                        else
                        {
                            ProductThumbnail.Visible = false;
                            NoImage.Visible = true;
                        }
                        break;
                        
                    default:
                        if (!string.IsNullOrEmpty(Item.ThumbnailUrl))
                        {
                            ProductThumbnail.ImageUrl = Item.ThumbnailUrl;
                            ProductThumbnail.AlternateText = Item.ThumbnailAltText;
                        }
                        else
                        {
                            ProductThumbnail.Visible = false;
                            NoThumbnail.Visible = true;
                        }
                        break;
                }

                ProductThumbnailLink.NavigateUrl = Item.NavigateUrl;
            }

            // SHOW PRODUCT NAME
            NamePanel.Visible = ShowName;
            if (ShowName)
            {
                if (!string.IsNullOrEmpty(Item.Name))
                {
                    ProductName.Text = Item.Name;
                    ProductName.NavigateUrl = Item.NavigateUrl;
                }
                else
                    NamePanel.Visible = false;
            }

            //SHOW PRODUCT MANUFACTURER
            ManufacturerPanel.Visible = ShowManufacturer;
            if(ShowManufacturer)
            {
                Manufacturer manufacturer = Item.Manufacturer;
                if (manufacturer != null)
                {
                    ProductManufacturer.Text = manufacturer.Name;
                    ProductManufacturer.NavigateUrl = NavigationHelper.GetSearchPageUrl() + string.Format("?m={0}", manufacturer.Id);
                }
                else
                    ManufacturerPanel.Visible = false;
            }

            // SHOW PRODUCT PRICE
            PricePanel.Visible = ShowPrice;
            if (ShowPrice)
            {
                if (!string.IsNullOrEmpty(Item.Price.ToString()))
                    ProductPrice.Visible = true;
                else
                    PricePanel.Visible = false;
            }

            // SHOW PRODUCT SKU
            SkuPanel.Visible = ShowSku;
            if (ShowSku)
            {
                if (!string.IsNullOrEmpty(Item.Sku))
                    ProductSku.Text = Item.Sku;
                else
                    SkuPanel.Visible = false;
            }

            // SHOW PRODUCT RATINGS
            RatingPanel.Visible = false;
            if (ShowRating)
            {
                if (AbleContext.Current.Store.Settings.ProductReviewEnabled != CommerceBuilder.Users.UserAuthFilter.None)
                {
                    RatingPanel.Visible = true;
                    ProductRating.Rating = Item.Rating;

                    // SHOW TOTAL REVIEWS
                    ProductRating.TotalReviews = Item.Reviews.Where(pr => pr.IsApproved).Count();
                }
            }

            // SHOW PRODUCT SUMMARY
            SummaryPanel.Visible = ShowSummary;
            if (ShowSummary)
            {
                if (!string.IsNullOrEmpty(Item.Summary))
                {
                    if (MaxSummaryLength > 0 && Item.Summary.Length > MaxSummaryLength) ProductSummary.Text = Item.Summary.Substring(0, MaxSummaryLength) + "...";
                    else ProductSummary.Text = Item.Summary;
                }
                else
                    SummaryPanel.Visible = false;
            }

            // SHOW ADD TO CART
            ActionsPanel.Visible = ShowAddToCart;
        }
    }
}