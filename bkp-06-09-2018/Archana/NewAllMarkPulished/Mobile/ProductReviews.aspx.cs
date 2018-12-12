using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Products;
using AbleCommerce.Code;
using CommerceBuilder.Utility;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Common;

namespace AbleCommerce.Mobile
{
    public partial class ProductReviews : CommerceBuilder.UI.AbleCommercePage
    {        
        public event EventHandler ReviewSubmitted;
        private int _ProductId;
        private int _ProductReviewId;
        private ProductReview _ProductReview;
        private Product _Product;

        protected bool FormInitialized
        {
            get { return AlwaysConvert.ToBool(ViewState["FormInitialized"], false); }
            set { ViewState["FormInitialized"] = value; }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            NoReviewsPanel.Visible = ProductReviewDataSource.SearchCount(_ProductId, BitFieldState.True) == 0;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _ProductReviewId = AlwaysConvert.ToInt(Request.QueryString["ReviewId"]);
            _ProductReview = ProductReviewDataSource.Load(_ProductReviewId);

            if (_ProductReview != null) _ProductId = _ProductReview.Product.Id;
            else _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);

            if (_Product == null)
                Response.Redirect(NavigationHelper.GetMobileStoreUrl("~/Default.aspx"));

            if (!Page.IsPostBack) InitializeForm();

            //INIT ReviewBody COUNTDOWN
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(ReviewBody, ReviewMessageCharCount);
            ReviewMessageCharCount.Text = ((int)(ReviewBody.MaxLength - ReviewBody.Text.Length)).ToString();

            ProductName.Text = _Product.Name;

            if (AbleContext.Current.Store.Settings.ProductReviewTermsAndConditions != string.Empty)
            {
                ReviewTermsLink.Visible = true;
                ReviewTermsLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl(string.Format("~/ReviewTerms.aspx?ProductId={0}", _Product.Id));
            }
            else
            {
                ReviewTermsLink.Visible = false;
                reviewInstruction.Visible = false;
            }
        }

        public void InitializeForm()
        {
            LoginLink.NavigateUrl = NavigationHelper.GetMobileStoreUrl(string.Format("~/Login.aspx?ReturnUrl={0}", Server.UrlEncode("ProductReviews.aspx?ProductId=" + _Product.Id)));

            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
            if (settings.ProductReviewEnabled != UserAuthFilter.None && _Product.AllowReviews)
            {
                if ((settings.ProductReviewEnabled == UserAuthFilter.Registered) && (AbleContext.Current.User.IsAnonymous))
                {
                    RegisterPanel.Visible = true;
                    ReviewPanel.Visible = false;
                }
                else
                {
                    //THE REVIEW FORM WILL BE ENABLED
                    User user = AbleContext.Current.User;
                    //DETERMINE IF WE NEED TO SUPPORT THE IMAGE CAPTCHA
                    trCaptcha.Visible = (ProductReviewHelper.ImageVerificationRequired(user));
                    if (trCaptcha.Visible)
                    {
                        //GENERATE A RANDOM NUMBER FOR IMAGE VERIFICATION
                        CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
                    }                                 
                    //CHECK TO SEE IF WE CAN PREPOPULATE THE FORM
                    ReviewerProfile profile = user.ReviewerProfile;
                    if (profile != null)
                    {
                        //EMAIL ADDRESS IS ONLY VISIBLE FOR ANONYMOUS USERS
                        trEmailAddress1.Visible = (user.IsAnonymous || String.IsNullOrEmpty(GetUserEmail()));
                        trEmailAddress2.Visible = (user.IsAnonymous || String.IsNullOrEmpty(GetUserEmail()));
                        Email.Text = profile.Email;
                        Name.Text = profile.DisplayName;
                        Location.Text = profile.Location;
                        //CHECK FOR EXISTING REVIEW
                        if (_ProductReview == null) _ProductReview = ProductReviewDataSource.LoadForProductAndReviewerProfile(_ProductId, profile.Id);
                        if (_ProductReview != null)
                        {
                            //EXISTING REVIEW FOUND, INITIALIZE FORM VALUES
                            //(THESE VALUES MAY BE OVERRIDEN BY FORM POST)
                            ListItem item = Rating.Items.FindByValue(_ProductReview.Rating.ToString("F0"));
                            if (item != null) Rating.SelectedIndex = (Rating.Items.IndexOf(item));
                            ReviewTitle.Text = _ProductReview.ReviewTitle;
                            ReviewBody.Text = _ProductReview.ReviewBody;
                        }
                    }
                    else if (!user.IsAnonymous)
                    {
                        trEmailAddress1.Visible = String.IsNullOrEmpty(GetUserEmail());
                        trEmailAddress2.Visible = String.IsNullOrEmpty(GetUserEmail());
                        Name.Text = user.PrimaryAddress.FirstName;
                        Location.Text = user.PrimaryAddress.City;
                    }
                }
            }
            else
            {
                this.Controls.Clear();
            }
            this.FormInitialized = true;
        }

        protected void SubmitReviewButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                //VALIDATE CAPTCHA  
                if (ProductReviewHelper.ImageVerificationRequired(AbleContext.Current.User))
                {
                    if (CaptchaImage.Authenticate(CaptchaInput.Text))
                    {
                        HandleSubmitedReview();
                        ReviewsRepeater.DataBind();
                    }
                    else
                    {
                        CustomValidator invalidInput = new CustomValidator();
                        invalidInput.ID = Guid.NewGuid().ToString();
                        invalidInput.Text = "*";
                        invalidInput.ErrorMessage = "You did not input the number correctly.";
                        invalidInput.IsValid = false;
                        invalidInput.ValidationGroup = "ProductReviewForm";
                        phCaptchaValidators.Controls.Add(invalidInput);
                        RefreshCaptcha();
                    }
                    CaptchaInput.Text = string.Empty;
                }
                else
                {
                    HandleSubmitedReview();
                    ReviewsRepeater.DataBind();
                }
            }
        }

        private String GetUserEmail()
        {
            User user = AbleContext.Current.User;
            if (user.IsAnonymous) return String.Empty;

            if (!String.IsNullOrEmpty(user.Email)) return user.Email;

            // USE USER PRIMARY ADDRESS EMAIL 
            else if (!String.IsNullOrEmpty(user.PrimaryAddress.Email))
            {
                user.Email = user.PrimaryAddress.Email;
                user.Save();
                return user.Email;
            }
            // USE USER NAME IF IT IS AN EMAIL
            else if (ValidationHelper.IsValidEmail(user.UserName))
            {
                user.Email = user.UserName;
                user.Save();
                return user.Email;
            }
            else return String.Empty;
        }

        private void HandleSubmitedReview()
        {
            if (SaveReview())
            {
                User user = AbleContext.Current.User;
                bool email = (ProductReviewHelper.EmailVerificationRequired(_Profile, user));
                bool approve = (ProductReviewHelper.ApprovalRequired(user));
                if (email || approve)
                {
                    //ADDITIONAL INSTRUCTIONS MUST BE PROVIDED TO CUSTOMER
                    ConfirmPanel.Visible = true;
                    ReviewPanel.Visible = false;
                    ConfirmEmail.Visible = email;
                    ConfirmEmail.Text = string.Format(ConfirmEmail.Text, _Profile.Email);
                    ConfirmApproval.Visible = approve;
                }
                else
                {
                    //THE REVIEW WILL APPEAR ON PAGE, NO NEED TO HAVE CONFIRMATION MESSAGE
                    this.FormInitialized = false;
                    if (ReviewSubmitted != null) ReviewSubmitted(this, new EventArgs());
                }
            }
        }

        private ReviewerProfile _Profile;

        private bool SaveReview()
        {
            // SAVE REVIEWER PROFILE
            User user = AbleContext.Current.User;
            //MAKE SURE ANONYMOUS USER DOES NOT TRY TO USE REGISTERED USER EMAIL
            if (user.IsAnonymous)
            {
                IList<User> users = UserDataSource.LoadForEmail(Email.Text);
                if (users.Count > 0)
                {
                    CustomValidator invalidEmail = new CustomValidator();
                    invalidEmail.ID = Guid.NewGuid().ToString();
                    invalidEmail.Text = "*";
                    invalidEmail.ErrorMessage = "Your email address is already registered.  You must log in to post the review.";
                    invalidEmail.IsValid = false;
                    invalidEmail.ValidationGroup = "ProductReviewForm";
                    phEmailValidators.Controls.Add(invalidEmail);
                    return false;
                }
                user.Save();
            }
            _Profile = user.ReviewerProfile;
            // TRY TO LOAD PROFILE BY EMAIL
            if (_Profile == null)
            {
                _Profile = ReviewerProfileDataSource.LoadForEmail(Email.Text);
                if (_Profile != null)
                {
                    if (_ProductReview == null) _ProductReview = ProductReviewDataSource.LoadForProductAndReviewerProfile(_ProductId, _Profile.Id);

                    // ATTEMPT TO SUBMIT A 2ND REVIEW FOR THIS PRODUCT BY AN ANNONYMOUS USER
                    if (_ProductReview != null && String.IsNullOrEmpty(Request.Form[OverwriteReviewButton.UniqueID]))
                    {
                        // WARN THE USER THAT A REVIEW IS ALREADY SUBMITTED BY SAME EMAIL ADDRESS
                        CustomValidator reviewAlreadySubmitted = new CustomValidator();
                        reviewAlreadySubmitted.ID = Guid.NewGuid().ToString();
                        reviewAlreadySubmitted.Text = "*";
                        reviewAlreadySubmitted.ErrorMessage = "You have already submitted a review for this product, do you want to overwrite your previous review?";
                        reviewAlreadySubmitted.IsValid = false;
                        reviewAlreadySubmitted.ValidationGroup = "ProductReviewForm";
                        phEmailValidators.Controls.Add(reviewAlreadySubmitted);
                        OverwriteReviewButton.Visible = true;
                        SubmitReviewButton.Visible = false;
                        return false;
                    }
                }
            }
            if (_Profile == null) _Profile = new ReviewerProfile();
            _Profile.Email = ((user.IsAnonymous && String.IsNullOrEmpty(GetUserEmail())) ? Email.Text : GetUserEmail());
            _Profile.DisplayName = StringHelper.StripHtml(Name.Text, true);
            _Profile.Location = StringHelper.StripHtml(Location.Text, true);
            _Profile.Save();

            //IF PROFILE IS NULL, AN ERROR OCCURRED VALIDATING THE EMAIL
            if (_Profile != null)
            {
                //EITHER LOAD THE EXISTING REVIEW OR CREATE NEW            
                if (_ProductReview == null) _ProductReview = ProductReviewDataSource.LoadForProductAndReviewerProfile(_ProductId, _Profile.Id);

                if (_ProductReview == null) _ProductReview = new ProductReview();
                _ProductReview.ReviewerProfile = _Profile;
                _ProductReview.Product = _Product;
                _ProductReview.ReviewDate = LocaleHelper.LocalNow;
                _ProductReview.Rating = AlwaysConvert.ToByte(Rating.SelectedValue);
                _ProductReview.ReviewTitle = StringHelper.StripHtml(ReviewTitle.Text, true);
                _ProductReview.ReviewBody = StringHelper.StripHtml(ReviewBody.Text, true);
                _ProductReview.Save(AbleContext.Current.User, true, true);
                return true;
            }
            return false;
        }

        protected void ConfirmOk_Click(object sender, EventArgs e)
        {
            ReviewPanel.Visible = true;
            ConfirmPanel.Visible = false;
            this.FormInitialized = false;
            RefreshCaptcha();
            if (ReviewSubmitted != null) ReviewSubmitted(this, new EventArgs());
        }

        private void RefreshCaptcha()
        {
            CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
        }

        protected void ChangeImageLink_Click(object sender, EventArgs e)
        {
            RefreshCaptcha();
        }
    }
}