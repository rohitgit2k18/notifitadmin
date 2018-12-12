namespace AbleCommerce.Admin.Products.Reviews
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class EditReview : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _ProductReviewId;
        private ProductReview _ProductReview;

        protected void Page_Init(object sender, System.EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetHtmlEditor(ReviewBody, ReviewBodyHtml);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _ProductReviewId = AlwaysConvert.ToInt(Request.QueryString["ReviewId"]);
            _ProductReview = ProductReviewDataSource.Load(_ProductReviewId);
            if (_ProductReview == null) Response.Redirect("Default.aspx");
            if (!Page.IsPostBack)
            {
                ReviewerProfile profile = _ProductReview.ReviewerProfile;
                ProductLink.NavigateUrl = string.Format(ProductLink.NavigateUrl, _ProductReview.ProductId);
                ProductLink.Text = _ProductReview.Product.Name;
                ReviewDate.Text = string.Format(ReviewDate.Text, _ProductReview.ReviewDate);
                Approved.Checked = _ProductReview.IsApproved;
                ReviewerEmail.Text = profile.Email;
                ReviewerName.Text = profile.DisplayName;
                ReviewerLocation.Text = profile.Location;
                Rating.Text = string.Format(Rating.Text, _ProductReview.Rating);
                ReviewTitle.Text = _ProductReview.ReviewTitle;
                ReviewBody.Text = _ProductReview.ReviewBody;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            Save();
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        protected void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            Save();
            Response.Redirect("Default.aspx");
        }

        private void Save()
        {
            //FIRST UPDATE THE PROFILE
            ReviewerProfile profile = _ProductReview.ReviewerProfile;
            profile.Email = ReviewerEmail.Text;
            profile.DisplayName = ReviewerName.Text;
            profile.Location = ReviewerLocation.Text;
            profile.Save();
            //NEXT UPDATE THE REVIEW
            _ProductReview.IsApproved = Approved.Checked;
            _ProductReview.ReviewTitle = ReviewTitle.Text;
            _ProductReview.ReviewBody = ReviewBody.Text;
            _ProductReview.Save();
            SuccessMessage.Text = string.Format(SuccessMessage.Text, LocaleHelper.LocalNow);
            SuccessMessage.Visible = true;
        }
    }
}