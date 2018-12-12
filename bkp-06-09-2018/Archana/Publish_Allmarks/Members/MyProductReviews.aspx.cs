namespace AbleCommerce.Members
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class MyProductReviews : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            User user = AbleContext.Current.User;
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            if (settings.ProductReviewEnabled == UserAuthFilter.None
                || settings.ProductReviewEnabled == UserAuthFilter.Registered && user.IsAnonymous)
            {
                Response.Redirect("~/Members/MyAccount.aspx");
            }
            BindReviews();
        }

        private void BindReviews()
        {
            ReviewerProfile profile = AbleContext.Current.User.ReviewerProfile;
            if (profile != null)
            {
                ReviewsGrid.DataSource = profile.ProductReviews;
            }
            else
            {
                // empty dataset to show empty grid message
                ReviewsGrid.DataSource = new List<ProductReview>();
            }
            ReviewsGrid.DataBind();
        }

        protected void ReviewsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DoDelete")
            {
                ReviewerProfile profile = AbleContext.Current.User.ReviewerProfile;
                int index = profile.ProductReviews.IndexOf(AlwaysConvert.ToInt(e.CommandArgument));
                if (index > -1)
                {
                    profile.ProductReviews.DeleteAt(index);
                }
                BindReviews();
            }
        }

        protected string GetApprovedText(bool isApproved)
        {
            return (isApproved ? "yes" : "no");
        }

        protected decimal? GetRating(Object dataItem)
        {
            ProductReview review = (ProductReview)dataItem;
            return (decimal?)review.Rating;
        }
    }
}