namespace AbleCommerce.ConLib.Utitlity
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;

    [Description("Displays product rating stars")]
    public partial class ProductRatingStars : System.Web.UI.UserControl
    {
        private bool _ShowRatingText = false;
        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true rating text is displayed")]
        public bool ShowRatingText
        {
            get { return _ShowRatingText; }
            set { _ShowRatingText = value; }
        }

        private int _TotalReviews = 0;
        public int TotalReviews
        {
            get { return _TotalReviews; }
            set { _TotalReviews = value; }
        }

        /// <summary>
        /// The value of the product rating (from 0 to 10).
        /// </summary>
        public decimal? Rating { get; set; }
        
        protected string GetRatingClass()
        {
            if (this.Rating.HasValue)
                return string.Format("ratingStar{0}", String.Format("{0:00}", this.Rating));
            else
                return "ratingStarNone";

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (this.Rating.HasValue) this.RatingText.Text = string.Format(RatingText.Text, this.Rating);
            RatingText.Visible = this.ShowRatingText && this.Rating.HasValue;
            NoRatingText.Visible = this.ShowRatingText && !this.Rating.HasValue;
            if (TotalReviews > 0)
            {
                TotalReviewsLabel.Text = string.Format(TotalReviewsLabel.Text, TotalReviews, ((TotalReviews > 1) ? "s" : ""));
                TotalReviewsLabel.Visible = true;
            }
            else
            {
                TotalReviewsLabel.Visible = false;
            }
        }
    }
}