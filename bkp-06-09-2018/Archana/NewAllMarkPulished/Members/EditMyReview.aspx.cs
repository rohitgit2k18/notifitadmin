namespace AbleCommerce.Members
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class EditMyReview : CommerceBuilder.UI.AbleCommercePage
    {
        int _ProductReviewId;
        ProductReview _ProductReview;
        Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            ReviewerProfile profile = AbleContext.Current.User.ReviewerProfile;
            _ProductReviewId = AlwaysConvert.ToInt(Request.QueryString["ReviewId"]);
            _ProductReview = ProductReviewDataSource.Load(_ProductReviewId);
            if (_ProductReview == null || _ProductReview.ReviewerProfileId != profile.Id)
                Response.Redirect("~/Members/MyProductReviews.aspx");
            _Product = ProductDataSource.Load(_ProductReview.ProductId);
            if (_Product == null) Response.Redirect("~/Members/MyProductReviews.aspx");
            ProductName.Text = _Product.Name;
            ProductReviewForm1.ReviewCancelled += new EventHandler(ProductReviewForm1_ReviewCancelled);
            ProductReviewForm1.ReviewSubmitted += new EventHandler(ProductReviewForm1_ReviewSubmitted);
        }

        void ProductReviewForm1_ReviewSubmitted(object sender, EventArgs e)
        {
            Response.Redirect("~/Members/MyProductReviews.aspx");
        }

        void ProductReviewForm1_ReviewCancelled(object sender, EventArgs e)
        {
            Response.Redirect("~/Members/MyProductReviews.aspx");
        }
    }
}