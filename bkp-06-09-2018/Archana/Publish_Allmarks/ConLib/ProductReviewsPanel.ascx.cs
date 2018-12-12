namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Web.UI;

    [Description("Displays all reviews for a product.")]
    public partial class ProductReviewsPanel : System.Web.UI.UserControl
    {
        private int _ProductId;
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            if (settings.ProductReviewEnabled != UserAuthFilter.None
                && _Product != null
                && _Product.AllowReviews)
            {
                AbleCommerce.Code.PageHelper.DisableValidationScrolling(this.Page);
                ProductReviewForm1.ReviewCancelled += new EventHandler(ProductReviewForm1_ReviewCancelled);
                ProductReviewForm1.ReviewSubmitted += new EventHandler(ProductReviewForm1_ReviewSubmitted);
            }
            else
            {
                Widget.Visible = false;
            }
        }

        void ProductReviewForm1_ReviewSubmitted(object sender, EventArgs e)
        {
            HideReviewForm();
            ReviewsGrid.DataBind();
        }

        void ProductReviewForm1_ReviewCancelled(object sender, EventArgs e)
        {
            HideReviewForm();
        }

        private void UpdatePageIndex()
        {
            if (ReviewsGrid.Rows.Count > 0)
            {
                int startIndex = ((ReviewsGrid.PageIndex * ReviewsGrid.PageSize) + 1);
                int endIndex = startIndex + ReviewsGrid.Rows.Count - 1;
                int rowCount = ProductReviewDataSource.SearchCount(_ProductId, BitFieldState.True);
                ReviewsCaptionPanel.Visible = true;
                ReviewCount.Text = string.Format(ReviewCount.Text, rowCount, ((rowCount > 1) ? "s" : ""));
                if (rowCount > ReviewsGrid.PageSize)
                {
                    ReviewsCaption.Visible = false;
                    PagedReviewsCaption.Visible = true;
                    int toIndex = startIndex + ReviewsGrid.PageSize - 1;
                    if (toIndex > rowCount) toIndex = rowCount;
                    PagedReviewsCaption.Text = string.Format(PagedReviewsCaption.Text, startIndex, toIndex, rowCount);
                }
                else
                {
                    ReviewsCaption.Visible = true;
                    PagedReviewsCaption.Visible = false;
                    ReviewsCaption.Text = string.Format(ReviewsCaption.Text, rowCount, ((rowCount > 1) ? "s" : ""));
                }
                AverageRatingPanel.Visible = true;
                ProductRating.Rating = _Product.Rating;
                decimal rating = 0;
                if (_Product.Rating.HasValue)
                    rating = _Product.Rating.Value;
                PHRichSnippets.Controls.Add(new LiteralControl(string.Format("<meta itemprop='ratingValue' content='{0}' />", rating)));
                PHRichSnippets.Controls.Add(new LiteralControl(string.Format("<meta itemprop='reviewCount' content='{0}' />", rowCount)));
            }
            else
            {
                ReviewsCaptionPanel.Visible = false;
                AverageRatingPanel.Visible = false;
            }
        }

        protected void ReviewLink_Click(object sender, EventArgs e)
        {
            ShowReviewForm();
        }

        private void ShowReviewForm()
        {
            ShowReviewsPanel.Visible = false;
            ReviewProductPanel.Visible = true;
            ProductReviewForm1.InitializeForm();
        }

        private void HideReviewForm()
        {
            ShowReviewsPanel.Visible = true;
            ReviewProductPanel.Visible = false;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Widget.Visible) UpdatePageIndex();
        }

        protected decimal? GetRating(Object dataItem) 
        {
            ProductReview review = (ProductReview)dataItem;
            return (decimal?)review.Rating;
        }
    }
}