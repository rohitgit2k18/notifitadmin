namespace AbleCommerce
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Web.UI;
    using System.Collections.Specialized;
    using System.Linq;
    using System.Web;
    using System.IO;
    using System.Web.Services;
    using System.Web.UI.WebControls.WebParts;
    using System.ComponentModel;
    using System.Net.Mail;
    using CommerceBuilder.Messaging;
    using System.Web.Script.Serialization;
    using System.Web.Security;

    public partial class BasketPage : CommerceBuilder.UI.AbleCommercePage
    {
        private OrderItemType[] displayItemTypes = { OrderItemType.Product, OrderItemType.Discount, OrderItemType.Coupon, OrderItemType.GiftWrap };

        IList<BasketItem> _DisplayedBasketItems;
        private bool _isBootstrapEnabled = false;
        private bool _volumeDiscountError = false;

        private bool _enableCaptcha = false;
        private bool _enableConfirmationEmail = false;
        private int _confirmationEmailTemplateId = 0;

        private string _subject = "New Contact Message";
        private string _sendTo;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("Indicates whether the captcha input field is enabled for protection from spam messages.")]
        public bool EnableCaptcha
        {
            get { return _enableCaptcha; }
            set { _enableCaptcha = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("Indicates whether the confirmation email is enabled. If true then a confirmation email will be sent back to customer.")]
        public bool EnableConfirmationEmail
        {
            get { return _enableConfirmationEmail; }
            set { _enableConfirmationEmail = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(0)]
        [Description("If confirmation email is enabled, the email template will be used to generate confirmation email.")]
        public int ConfirmationEmailTemplateId
        {
            get { return _confirmationEmailTemplateId; }
            set { _confirmationEmailTemplateId = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("New Contact Message")]
        [Description("Default email subject for the contact us email message.")]
        public string Subject
        {
            get { return _subject; }
            set { _subject = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Store email address")]
        [Description("Single or a comma separated list of email addresses, use the format like 'info@ourstore.com,sales@ourstore.com' to specify email addresses. If no value is specified store default email address will be used.")]
        public string SendTo
        {
            get { return _sendTo; }
            set { _sendTo = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //TOGGLE VAT COLUMN
            _isBootstrapEnabled = PageHelper.IsResponsiveTheme(this);

            CaptchaPanel.Visible = EnableCaptcha;

            if (!Page.IsPostBack)
            {
                SaveUploadedFile(Request.Files);
                User user = AbleContext.Current.User;
                Email.CssClass += " contact-field";
                Phone.CssClass += " contact-field";
                FirstName.CssClass += " contact-field";
                LastName.CssClass += " contact-field";
            }
        }

        private void BindBasketGrid()
        {
            //BIND THE GRID
            IList<BasketItem> items = GetBasketItems();
            items = ValidateVolumeOrder(items);
            BasketGrid.DataSource = items;
            BasketGrid.DataBind();
        }

        private IList<BasketItem> ValidateVolumeOrder(IList<BasketItem> items)
        {
            IList<BasketItem> newBasketItems = new List<BasketItem>();
            List<string> warningMessages = new List<string>();
            foreach (var rec in items)
            {
                if (rec.OrderItemType == OrderItemType.Product)
                {
                    decimal MinQuantity = 0;

                    if (rec.Product.VolumeDiscounts.Any() && rec.Product.VolumeDiscounts[0].Levels.Any())
                    {
                        VolumeDiscount VolumeDiscount = rec.Product.VolumeDiscounts[0];
                        MinQuantity = VolumeDiscount.Levels.First().MinValue;
                    }
                    else
                    {
                        MinQuantity = rec.Product.MinQuantity;
                    }

                    if (rec.Quantity < MinQuantity)
                    {
                        _volumeDiscountError = true;
                        warningMessages.Add(String.Format("Cannot order '{0}' below the minumum quantity amount of '{1}'.", rec.Name, MinQuantity.ToString("0")));
                    }
                }
                //Remove Discount row from Basket
                if (rec.OrderItemType != OrderItemType.Discount)
                    newBasketItems.Add(rec);
            }

            OrderVolumeAmountMessageList.DataSource = warningMessages;
            OrderVolumeAmountMessageList.DataBind();

            return newBasketItems;
        }

        private IList<BasketItem> GetBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Combine(basket);
            _DisplayedBasketItems = BasketHelper.GetDisplayItems(basket, false);
            return _DisplayedBasketItems;
        }

        protected void BasketGrid_DataBound(object sender, EventArgs e)
        {
            if (BasketGrid.Rows.Count > 0)
            {
                ClearBasketButton.Visible = true;
                UpdateButton.Visible = true;
                EmptyBasketPanel.Visible = false;
            }
            else
            {
                ClearBasketButton.Visible = false;
                UpdateButton.Visible = false;
                EmptyBasketPanel.Visible = true;
            }
        }

        protected void BasketGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            Basket basket;
            int index;
            switch (e.CommandName)
            {
                case "SaveItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        basket.Items.MoveToWishlist(index, AbleContext.Current.User.PrimaryWishlist);
                    }
                    break;
                case "DeleteItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        basket.Items.DeleteAt(index);
                    }
                    break;
                case "DeleteCoupon":
                    // get coupon to be deleted
                    string couponCode = e.CommandArgument.ToString();

                    // delete the coupon
                    basket = AbleContext.Current.User.Basket;
                    for (int i = basket.BasketCoupons.Count - 1; i >= 0; i--)
                    {
                        BasketCoupon cpn = basket.BasketCoupons[i];
                        if (cpn.Coupon.CouponCode == couponCode)
                        {
                            basket.BasketCoupons.DeleteAt(i);
                            break;
                        }
                    }

                    // delete items associated with the coupon
                    for (int i = basket.Items.Count - 1; i >= 0; i--)
                    {
                        BasketItem bitem = basket.Items[i];
                        if (bitem.OrderItemType == OrderItemType.Coupon && bitem.Sku == couponCode)
                        {
                            basket.Items.RemoveAt(i);
                        }
                    }
                    basket.Save();
                    break;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //GET ANY MESSAGES FROM SESSION
            IList<string> sessionMessages = Session["BasketMessage"] as IList<string>;
            //GET THE BASKET
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            //VALIDATE THE BASKET
            ValidationResponse response = preCheckoutService.Validate(basket);
            //DISPLAY ANY WARNING MESSAGES
            if ((!response.Success) || (sessionMessages != null))
            {
                if (sessionMessages != null)
                {
                    Session.Remove("BasketMessage");
                    sessionMessages.AddRange(response.WarningMessages);
                    WarningMessageList.DataSource = sessionMessages;
                }
                else
                {
                    WarningMessageList.DataSource = response.WarningMessages;
                }
                WarningMessageList.DataBind();
            }
            BindBasketGrid();
        }

        protected void ClearBasketButton_Click(object sender, EventArgs e)
        {
            IBasketService basketService = AbleContext.Resolve<IBasketService>();
            basketService.Clear(AbleContext.Current.User.Basket);
            BindBasketGrid();
        }

        protected void KeepShoppingButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            AbleCommerce.Code.BasketHelper.SaveBasket(BasketGrid);
            BindBasketGrid();
        }

        //protected void CheckoutButton_Click(object sender, EventArgs e)
        //{
        //    AbleCommerce.Code.BasketHelper.SaveBasket(BasketGrid);
        //    IBasketService service = AbleContext.Resolve<IBasketService>();
        //    ValidationResponse response = service.Validate(AbleContext.Current.User.Basket);
        //    if (response.Success) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetCheckoutUrl());
        //    else Session["BasketMessage"] = response.WarningMessages;
        //}

        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }

        protected bool IsProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return item.OrderItemType == OrderItemType.Product;
        }

        protected string GetProductUrl(object dataItem)
        {          
            BasketItem item = (BasketItem)dataItem;
            if (item.OrderItemType == OrderItemType.Product && item.Product != null)
            {
                NameValueCollection nvc = new NameValueCollection();
                nvc.Add("ItemId", item.Id.ToString());
                if (!string.IsNullOrEmpty(item.OptionList) && !string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Kits", item.KitList);
                    nvc.Add("Options", item.OptionList.Replace(",0", string.Empty));
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                else if (!string.IsNullOrEmpty(item.OptionList) && string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Options", item.OptionList.Replace(",0", string.Empty));
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                else if (string.IsNullOrEmpty(item.OptionList) && !string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Kits", item.KitList);
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                
                return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
            }
            else return string.Empty;
        }

        protected bool IsParentProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return (item.OrderItemType == OrderItemType.Product && !item.IsChildItem);
        }

        #region CONTACT RELATED
        private void RefreshCaptcha()
        {
            CaptchaImage.ChallengeText = StringHelper.RandomNumber(6);
        }

        protected void ChangeImageLink_Click(object sender, EventArgs e)
        {
            RefreshCaptcha();
        }
        protected void Submit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (EnableCaptcha)
                {
                    if (CaptchaImage.Authenticate(CaptchaInput.Text))
                    {
                        SaveEnquiry();
                        CaptchaInput.Text = "";
                        RefreshCaptcha();
                    }
                    else
                    {
                        //CAPTCHA IS VISIBLE AND DID NOT AUTHENTICATE
                        CustomValidator invalidInput = new CustomValidator();
                        invalidInput.Text = "*";
                        invalidInput.ErrorMessage = "You did not input the verification number correctly.";
                        invalidInput.IsValid = false;
                        phCaptchaValidators.Controls.Add(invalidInput);
                        CaptchaInput.Text = "";
                        RefreshCaptcha();
                    }
                }
                else if (!EnableCaptcha)
                {
                    SaveEnquiry();
                }

            }
        }

        private void SaveEnquiry()
        {
            var showMessagePanel = false;
            Basket basket = AbleContext.Current.User.Basket;

            Boolean hasItems = false;
            if (basket.Items.Count > 0)
                hasItems = true;

            basket.User.Email = StringHelper.StripHtml(Email.Text);

            //PROCESS THE CHECKOUT
            try
            {
                Order order = new Order();
                if (hasItems)
                {
                    foreach (var rec in basket.Items)
                    {
                        order.Items.Add(new OrderItem() { ProductId = rec.ProductId,
                                                            Product = rec.Product,
                                                            Quantity = rec.Quantity,
                                                            Name = rec.Name,
                                                            Sku = rec.Sku
                                                            });
                    }
                }

                order.BillToCountryCode = "AU";
                order.BillToCountry = new CommerceBuilder.Shipping.Country() { Id = "AU", CountryCode = "AU" };
                
                CreateAccount();

                // Add the contact details to the saved order.
                order.BillToEmail = StringHelper.StripHtml(Email.Text);
                order.BillToFirstName = StringHelper.StripHtml(FirstName.Text);
                order.BillToLastName = StringHelper.StripHtml(LastName.Text);
                order.BillToPhone = StringHelper.StripHtml(Phone.Text);
                order.BillToCompany = StringHelper.StripHtml(Company.Text);
                order.OrderDate = DateTime.Now;

                // The list of files that have been uploaded are included in the HiddenFilesField.
                var files = (List<FileAttachment>)Session["UPLOADED_QUOTE"];
                if (files == null)
                {
                    files = new List<FileAttachment>();
                }

                CrmHelper.SaveEnquiry(order, StringHelper.StripHtml(Comments.Text), files, AbleContext.Current.Store);

                FailureMessage.Visible = false;
                SuccessMessage.Visible = true;
                showMessagePanel = true;

                IBasketService basketService = AbleContext.Resolve<IBasketService>();
                basketService.Clear(AbleContext.Current.User.Basket);
                BindBasketGrid();

            }
            catch (Exception exp)
            {
                Logger.Error("ContactUs Control Exception: Exp" + Environment.NewLine + exp.Message);
                FailureMessage.Visible = true;
                SuccessMessage.Visible = false;
                showMessagePanel = true;
            }

            if (showMessagePanel)
            {
                MessagePanel.Visible = true;
                ContactFormPanel.Visible = false;
                BasketPanel.Visible = false;
            }
        }

        private bool CreateAccount()
        {
            // NEED TO REGISTER USER
            if (AbleContext.Current.User.IsAnonymous)
            {
                // VALIDATE EMAIL, IF EMAIL IS ALREADY REGISTERED, ASK FOR LOGIN
                string newEmail = StringHelper.StripHtml(Email.Text);
                if (UserDataSource.IsEmailRegistered(newEmail))
                {
                    IList<string> warningMessages = new List<string>();
                    warningMessages.Add("The email address you have provided is already registered.Please sign in to access your account.");
                    WarningMessageList.DataSource = warningMessages;
                    WarningMessageList.DataBind();
                    return false;
                }

                // ANONYMOUS USER SELECTING GUEST CHECKOUT, CREATE TEMPORARY ACCOUNT
                User oldUser = AbleContext.Current.User;
                string newUserName = "zz_anonymous_" + Guid.NewGuid().ToString("N") + "@domain.xyz";
                string newPassword = Guid.NewGuid().ToString("N");
                MembershipCreateStatus createStatus;
                User newUser = UserDataSource.CreateUser(newUserName, newEmail, newPassword, string.Empty, string.Empty, true, 0, out createStatus);

                // IF THE CREATE FAILS, IGNORE AND CONTINUE CREATING THE ORDER
                if (createStatus == MembershipCreateStatus.Success)
                {
                    // CHANGE THE NAME AND EMAIL TO SOMETHING MORE FRIENDLY THAN GUID
                    newUser.UserName = "zz_anonymous_" + newUser.Id.ToString() + "@domain.xyz";
                    newUser.PrimaryAddress.Email = newEmail;
                    newUser.PrimaryAddress.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                    newUser.PrimaryAddress.IsBilling = true;
                    newUser.PrimaryAddress.Residence = true;
                    newUser.Save();
                    CommerceBuilder.Users.User.Migrate(oldUser, newUser, true, true);
                    AbleContext.Current.User = newUser;
                    FormsAuthentication.SetAuthCookie(newUser.UserName, false);
                }
            }

            return true;
        }

        [WebMethod]
        public static void RemoveFile(string name)
        {
            var originalDirectory = new DirectoryInfo(string.Format("{0}", HttpContext.Current.Server.MapPath(@"\")));
            string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "upload");
            var path = string.Format("{0}\\{1}", pathString, name);
            FileInfo TheFile = new FileInfo(path);
            if (TheFile.Exists)
            {
                // File found so delete it.
                TheFile.Delete();
            }

        }

        public void SaveUploadedFile(HttpFileCollection httpFileCollection)
        {
            // Clear Session data if no file uploades are made (IsPostBack does not work, need to clear session data on page re-load)
            List<FileAttachment> fileAttachments = new List<FileAttachment>();
            if (httpFileCollection.Count == 0)
            {
                // Delete previously uploaded files in SESSION to be erased
                fileAttachments = (List<FileAttachment>)Session["UPLOADED_QUOTE"];
                if (fileAttachments != null && fileAttachments.Count > 0)
                {
                    foreach (var file in fileAttachments)
                    {
                        FileInfo TheFile = new FileInfo(file.path);
                        if (TheFile.Exists)
                        {
                            // File found so delete it.
                            TheFile.Delete();
                        }
                    }
                }

                Session["UPLOADED_QUOTE"] = null;
            }
            fileAttachments = (List<FileAttachment>)Session["UPLOADED_QUOTE"];

            string fName = "";
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                //Save file content goes here
                fName = file.FileName;
                if (file != null && file.ContentLength > 0)
                {

                    var originalDirectory = new DirectoryInfo(string.Format("{0}", Server.MapPath(@"\")));

                    string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "ClientUploadedFiles");

                    var fileName1 = Path.GetFileName(file.FileName);


                    bool isExists = System.IO.Directory.Exists(pathString);

                    if (!isExists)
                        System.IO.Directory.CreateDirectory(pathString);

                    var path = string.Format("{0}\\{1}", pathString, file.FileName);

                    // Get file attachments
                    if (fileAttachments == null)
                    {
                        fileAttachments = new List<FileAttachment>();
                    }

                    fileAttachments.Add(new FileAttachment() { name = fileName1, target_name = fileName1, size = file.ContentLength, path = path });
                    Session["UPLOADED_QUOTE"] = fileAttachments;
                    file.SaveAs(path);
                }

            }
        }
        #endregion
    }
}