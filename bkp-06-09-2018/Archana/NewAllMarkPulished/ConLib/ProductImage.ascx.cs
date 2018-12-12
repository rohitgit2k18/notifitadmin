namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    [Description("Displays one of the specified product image.")]
    public partial class ProductImageControl : System.Web.UI.UserControl
    {
        private StoreSettingsManager _settings;

        //can be icon, thumbnail, or image
        private string _ShowImage = "thumbnail";
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("thumbnail")]
        [Description("The image to display. Possible values are icon, thumbnail, image.")]
        public string ShowImage
        {
            get { return _ShowImage; }
            set { _ShowImage = value; }
        }

        [Browsable(true), DefaultValue("click on thumbnail to zoom")]
        [Description("The text for the instruction text link for cliking thumbnail")]
        public string ThumbnailClickInstructionText { get; set; }


        int _ProductId;
        Product _Product;
        public Product Product
        {
            get
            {
                if (_Product == null)
                {
                    // IF NOT SPECIFIED THEN CHECK QUERY STRING.
                    _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
                    _Product = ProductDataSource.Load(_ProductId);
                }
                return _Product;
            }
            set { _Product = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (Product != null)
            {
                List<CommerceBuilder.Products.ProductImage> images = (from i in Product.Images select i).ToList<CommerceBuilder.Products.ProductImage>();
                if (images.Count > 0 && !string.IsNullOrEmpty(Product.ImageUrl)) images.Insert(0, new CommerceBuilder.Products.ProductImage() { ImageUrl = Product.ImageUrl, ImageAltText = Product.ImageAltText });

                if (images == null || images.Count == 0)
                {
                    phAdditionalImages.Visible = false;
                }
                else
                {
                    //InstructionTextLabel.Visible = images.Count > 0;
                    //if (!string.IsNullOrEmpty(ThumbnailClickInstructionText))
                    //    InstructionTextLabel.Text = ThumbnailClickInstructionText;
                    MoreImagesList.DataSource = images;
                    MoreImagesList.DataBind();
                }
            }

            _settings = AbleContext.Current.Store.Settings;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Product != null)
            {
                string checkImage = this.ShowImage.ToLowerInvariant();
                string calculatedImageUrl = string.Empty;
                string imageAltText = string.Empty;
                string optionList = Request.QueryString["Options"];

                ProductVariant variant = null;
                if (!string.IsNullOrEmpty(optionList))
                {
                    variant = ProductVariantDataSource.LoadForOptionList(Product.Id, optionList);
                }

                if (checkImage == "icon")
                {
                    if (variant != null && !string.IsNullOrEmpty(variant.IconUrl))
                    {
                        calculatedImageUrl = variant.IconUrl;
                        imageAltText = Product.IconAltText;
                    }
                    else if (!string.IsNullOrEmpty(Product.IconUrl))
                    {
                        calculatedImageUrl = Product.IconUrl;
                        imageAltText = Product.IconAltText;
                    }
                    else
                    {
                        NoIcon.Visible = true;
                    }
                }
                else if (checkImage == "thumbnail")
                {
                    if (variant != null && !string.IsNullOrEmpty(variant.ThumbnailUrl))
                    {
                        calculatedImageUrl = variant.ThumbnailUrl;
                        imageAltText = Product.ThumbnailAltText;
                    }
                    else if (!string.IsNullOrEmpty(Product.ThumbnailUrl))
                    {
                        calculatedImageUrl = Product.ThumbnailUrl;
                        imageAltText = Product.ThumbnailAltText;
                    }
                    else
                    {
                        NoThumbnail.Visible = true;
                    }
                }
                else
                {
                    if (variant != null && !string.IsNullOrEmpty(variant.ImageUrl))
                    {
                        calculatedImageUrl = variant.ImageUrl;
                        imageAltText = Product.ImageAltText;
                    }
                    else if (!string.IsNullOrEmpty(Product.ImageUrl))
                    {
                        calculatedImageUrl = Product.ImageUrl;
                        imageAltText = Product.ImageAltText;
                    }
                    else
                    {
                        NoImage.Visible = true;
                    }
                }
                if (!string.IsNullOrEmpty(calculatedImageUrl))
                {
                    // check if it is an absolute URL, then do not try to resize
                    if (calculatedImageUrl.ToLowerInvariant().StartsWith("http"))
                    {
                        this.ProductImage.ImageUrl = calculatedImageUrl;
                    }
                    else
                        this.ProductImage.ImageUrl = string.Format("~/GetImage.ashx?Path={0}&maintainAspectRatio=true", Server.UrlEncode(calculatedImageUrl));
                    this.ProductImage.AlternateText = Server.HtmlEncode(imageAltText);
                    ProductImageUrl.Attributes.Add("rel", "gallery");
                    this.ProductImageUrl.HRef = GetLargeImageUrl(calculatedImageUrl);
                    this.ProductImageUrl.Title = Server.HtmlEncode(imageAltText);
                    this.ProductImageUrl.Visible = true;
                }
                else
                {
                    this.ProductImage.Visible = false;
                    this.ProductImageUrl.Visible = false;
                }
            }

            if (!Page.ClientScript.IsClientScriptBlockRegistered("JQUERY_FANCY_BOX_JS_CSS"))
            {
                this.Page.Header.Controls.Add(new LiteralControl("<link href='" + Page.ResolveUrl("~/scripts/fancybox/") + "jquery.fancybox.css' rel='stylesheet' type='text/css' />"));
                string scriptText = "<script src='" + ResolveUrl("~/scripts/fancybox/") + "jquery.fancybox.js' language='javascript'/>";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "JQUERY_FANCY_BOX_JS_CSS", scriptText, false);
            }
        }

        protected string GetLargeImageUrl(string url)
        {
            return this.Page.ResolveUrl(url);
        }

        protected string GetResizedImage(string url)
        {
            // check if it is an absolute URL, then do not try to resize
            if (url.ToLowerInvariant().StartsWith("http"))
            {
                return url;
            }
            else
            {
                string ResizedImageUrl = string.Format("~/GetImage.ashx?maintainAspectRatio=true&Path={0}", Server.UrlEncode(url));
                return this.Page.ResolveUrl(ResizedImageUrl);
            }
        }

        protected string GetThumbnailUrl(string url)
        {
            // check if it is an absolute URL, then do not try to resize
            if (url.ToLowerInvariant().StartsWith("http"))
            {
                return url;
            }
            else
            {
                string thumbnailUrl = string.Format("~/GetImage.ashx?Path={0}&height={1}&width={2}", Server.UrlEncode(url), 105, 60);
                return this.Page.ResolveUrl(thumbnailUrl);
            }
        }

        protected void MoreImagesList_OnItemCreated(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item && e.Item.ItemIndex == 0)
            {
                HtmlImage miImage = (HtmlImage)e.Item.FindControl("miImage");
                miImage.Attributes.Add("itemprop", "logo");
            }
        }
    }
}