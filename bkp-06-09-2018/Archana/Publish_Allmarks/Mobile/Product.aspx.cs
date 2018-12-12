using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.UI;
using CommerceBuilder.Products;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Users;
using CommerceBuilder.Stores;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile
{
    public partial class ProductPage : AbleCommercePage
    {
        Product _product = null;
        StoreSettingsManager _settings;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            _settings = AbleContext.Current.Store.Settings;
            _product = ProductDataSource.Load(AbleCommerce.Code.PageHelper.GetProductId());
            if (_product != null)
            {
                if ((_product.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
                }
            }
            else AbleCommerce.Code.NavigationHelper.Trigger404(Response, "Invalid Product");
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (_product != null)
            {
                Page.Title = string.IsNullOrEmpty(_product.Title) ? _product.Name : _product.Title;
                ProductName.Text = _product.Name;
                moreDetails.NavigateUrl = NavigationHelper.GetMobileStoreUrl("~/ProductDescription.aspx?ProductId=" + _product.Id);
                if (_settings.MobileStoreProductUseSummary)
                {
                    ProductSummary.Text = _product.Summary;
                }
                else
                {
                    ProductSummary.Text = _product.Description;
                    if (string.IsNullOrEmpty(_product.ExtendedDescription)) moreDetails.Visible = false;
                    descriptionHeader.Visible = !string.IsNullOrEmpty(_product.Description);
                    moreDetails.Visible = !string.IsNullOrEmpty(_product.Description); 
                }
                if (_settings.ProductReviewEnabled != CommerceBuilder.Users.UserAuthFilter.None)
                {
                    RatingPanel.Visible = true;
                    ProductRating.Rating = _product.Rating;
                }
                if (_product.Manufacturer != null && !string.IsNullOrEmpty(_product.Manufacturer.Name))
                {
                    phManufacturer.Visible = true;
                    ManufLink.Text = _product.Manufacturer.Name;
                    ManufLink.NavigateUrl = Page.ResolveUrl(NavigationHelper.GetMobileStoreUrl(string.Format("~/Search.aspx?m={0}",_product.Manufacturer.Id)));
                }

                // PRODUCT REVIEWS
                if (_settings.ProductReviewEnabled != UserAuthFilter.None)
                {
                    int count = ProductReviewDataSource.SearchCount(_product.Id, BitFieldState.True);
                    if (count > 0)
                    {
                        ProductReviewsPanel.Visible = true;
                        ProductRatingStars1.Rating = _product.Rating;
                        TotalReviews.Text = count.ToString();
                        MoreDetailsLink.NavigateUrl = string.Format("ProductReviews.aspx?ProductId={0}", _product.Id);
                    }
                    else
                    {
                        NoReviewsPanel.Visible = true;
                        averageRating.Visible = false;
                        reviewsTotal.Visible = false;
                        MoreDetailsLink.Text = "Add Reviews";
                        MoreDetailsLink.NavigateUrl = string.Format("ProductReviews.aspx?ProductId={0}", _product.Id);
                    }
                }
                else
                {
                    ProductReviewsPanel.Visible = false;
                }

                //REGISTER THE PAGEVISIT
                AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_product.Id, CatalogNodeType.Product, _product.Name);
                AbleCommerce.Code.PageHelper.BindMetaTags(this, _product);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ProductReviewsPanel.Visible = _settings.ProductReviewEnabled != UserAuthFilter.None && _product != null && _product.AllowReviews;
        }
    }
}
