namespace AbleCommerce.ConLib
{
    using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using CommerceBuilder.Common;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Extensions;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Services.Checkout;
using CommerceBuilder.Taxes;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
    using System.Web.UI.HtmlControls;
    using AbleCommerce.Code;
    using CommerceBuilder.UI.WebControls;

    [Description("Displays product basic details and add-to-cart buttons for each variant combination. This control should not be used with products having more than 8 options.")]
    public partial class BuyProductDialogOptionsList : System.Web.UI.UserControl
    {
        int _ProductId = 0;
        Product _Product = null;
        List<int> _SelectedKitProducts = null;
        ProductVariantManager _VariantManager;
        IList<ProductVariant> _AvailableVariants;
        DataTable _DataTable;
        IList<ProductOption> _ProdOptions;

        private bool _ShowSku = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true SKU is displayed")]
        public bool ShowSku
        {
            get { return _ShowSku; }
            set { _ShowSku = value; }
        }

        private bool _ShowPartNumber = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true Part/Model number is displayed")]
        public bool ShowPartNumber
        {
            get { return _ShowPartNumber; }
            set { _ShowPartNumber = value; }
        }

        private string _GTINName = "GTIN";
        [Browsable(true), DefaultValue("GTIN")]
        [Description("Indicates the display name. Possible values are 'GTIN', 'UPC' and 'ISBN'")]
        public string GTINName
        {
            get { return _GTINName; }
            set { _GTINName = value; }
        }

        private bool _ShowGTIN = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true GTIN number is displayed")]
        public bool ShowGTIN
        {
            get { return _ShowGTIN; }
            set { _ShowGTIN = value; }
        }

        private bool _ShowPrice = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true Price is displayed")]
        public bool ShowPrice
        {
            get { return _ShowPrice; }
            set { _ShowPrice = value; }
        }

        private bool _ShowSubscription = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true product description is displayed")]
        public bool ShowSubscription
        {
            get { return _ShowSubscription; }
            set { _ShowSubscription = value; }
        }

        private bool _ShowMSRP = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true MSRP is displayed")]
        public bool ShowMSRP
        {
            get { return _ShowMSRP; }
            set { _ShowMSRP = value; }
        }

        private bool _ShowThumbnail = false;
        [Browsable(true), DefaultValue(false)]
        [Description("If true thumbnail is displayed")]
        public bool ShowThumbnail
        {
            get { return _ShowThumbnail; }
            set { _ShowThumbnail = value; }
        }

        private bool _ShowInventoryMessage = true;
        [Browsable(true), DefaultValue(true)]
        [Description("If true inventory message is displayed")]
        public bool ShowInventoryMessage
        {
            get { return _ShowInventoryMessage; }
            set { _ShowInventoryMessage = value; }
        }

        protected void VariantGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string optionList;
            if (e.CommandName.Equals("AddToBasket"))
            {
                optionList = e.CommandArgument.ToString();
                ProductVariant variant = _VariantManager.GetVariantFromOptions(optionList);
                if (variant != null)
                {
                    BasketItem basketItem = GetBasketItem(optionList, e);
                    if (basketItem != null)
                    {
                        // DETERMINE IF THE LICENSE AGREEMENT MUST BE REQUESTED
                        IList<LicenseAgreement> basketItemLicenseAgreements = new List<LicenseAgreement>();
                        basketItemLicenseAgreements.BuildCollection(basketItem, LicenseAgreementMode.OnAddToBasket);
                        if ((basketItemLicenseAgreements.Count > 0))
                        {
                            // THESE AGREEMENTS MUST BE ACCEPTED TO ADD TO CART
                            List<BasketItem> basketItems = new List<BasketItem>();
                            basketItems.Add(basketItem);
                            string guidKey = Guid.NewGuid().ToString("N");
                            Cache.Add(guidKey, basketItems, null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(0, 10, 0), System.Web.Caching.CacheItemPriority.NotRemovable, null);
                            string acceptUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Basket.aspx"));
                            string declineUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Page.ResolveUrl(_Product.NavigateUrl)));
                            Response.Redirect("~/BuyWithAgreement.aspx?Items=" + guidKey + "&AcceptUrl=" + acceptUrl + "&DeclineUrl=" + declineUrl);
                        }

                        //ADD ITEM TO BASKET
                        Basket basket = AbleContext.Current.User.Basket;
                        basket.Items.Add(basketItem);
                        basket.Save();

                        //Determine if there are associated Upsell products
                        if (basketItem.Product.GetUpsellProducts(basket).Count > 0)
                        {
                            //redirect to upsell page
                            string returnUrl = AbleCommerce.Code.NavigationHelper.GetEncodedReturnUrl();
                            Response.Redirect("~/ProductAccessories.aspx?ProductId=" + basketItem.Product.Id + "&ReturnUrl=" + returnUrl);
                        }

                        // IF BASKET HAVE SOME VALIDATION PROBLEMS MOVE TO BASKET PAGE
                        IBasketService service = AbleContext.Resolve<IBasketService>();
                        ValidationResponse response = service.Validate(basket);
                        if (!response.Success)
                        {
                            Session["BasketMessage"] = response.WarningMessages;
                            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
                        }

                        //IF THERE IS NO REGISTERED BASKET CONTROL, WE MUST GO TO BASKET PAGE
                        if (!AbleCommerce.Code.PageHelper.HasBasketControl(this.Page)) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
                    }
                }
            }
            if (e.CommandName.Equals("AddToWishlist"))
            {
                optionList = e.CommandArgument.ToString();
                ProductVariant variant = _VariantManager.GetVariantFromOptions(optionList);
                if (variant != null)
                {
                    BasketItem wishlistItem = GetBasketItem(optionList, e);
                    if (wishlistItem != null)
                    {
                        Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
                        wishlist.WishlistItems.Add(wishlistItem);
                        wishlist.Save();
                        Response.Redirect("~/Members/MyWishlist.aspx");
                    }
                }
            }

           else if (e.CommandName.Equals("NotifyMe"))
           {
               HtmlTableRow row = (HtmlTableRow)((Control)e.CommandSource).Parent.Parent;
               optionList = e.CommandArgument.ToString(); 
               string email = GetInputControlValue(row, "EmailText");
               Label subscribedMessage = (Label)PageHelper.RecursiveFindControl(row, "messageLabel");
               LinkButton notifyLink = (LinkButton)PageHelper.RecursiveFindControl(row, "NotificationLink");
               ProductVariant variant = _VariantManager.GetVariantFromOptions(optionList);

               if (RestockNotifyDataSource.LoadVariantForEmail(variant.Id, email) == null)
               { 
                   RestockNotify notification = new RestockNotify(_Product, variant, email);
                   notification.Save();

                   subscribedMessage.Text = string.Format(subscribedMessage.Text, email);
                   subscribedMessage.Visible = true;
                   notifyLink.Visible = false;
               }
               else if (!string.IsNullOrEmpty(email))
               {
                   subscribedMessage.Text = string.Format(subscribedMessage.Text, email);
                   subscribedMessage.Visible = true;
                   notifyLink.Visible = false;
               }
            }
        }

        private string GetInputControlValue(HtmlTableRow row, string controlId)
        {
            TextBox tb = row.FindControl(controlId) as TextBox;
            if (tb != null)
            {
                return tb.Text;
            }
            return string.Empty;
        }

        protected void VariantGrid_RowCreated(Object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes.Add("itemscope itemprop", "offers");
                e.Row.Attributes.Add("itemtype", "http://schema.org/Offer");
            }
        }

        protected BasketItem GetBasketItem(string optionList, GridViewCommandEventArgs e)
        {
            //GET THE QUANTITY
            GridViewRow row = (GridViewRow)((Control)e.CommandSource).Parent.Parent;
            int tempQuantity = GetControlValue(row, "Quantity", 1);
            if (tempQuantity < 1) return null;
            if (tempQuantity > System.Int16.MaxValue) tempQuantity = System.Int16.MaxValue;

            //CREATE THE BASKET ITEM WITH GIVEN OPTIONS
            BasketItem basketItem = BasketItemDataSource.CreateForProduct(_ProductId, (short)tempQuantity, optionList, AlwaysConvert.ToList(",", _SelectedKitProducts));
            if (basketItem != null)
            {
                basketItem.Basket = AbleContext.Current.User.Basket;

                //ADD IN VARIABLE PRICE
                //if (_Product.UseVariablePrice) basketItem.Price = AlwaysConvert.ToDecimal(VariablePrice.Text);
                // COLLECT ANY ADDITIONAL INPUTS
                AbleCommerce.Code.ProductHelper.CollectProductTemplateInput(basketItem, this);
            }
            return basketItem;
        }

        private int GetControlValue(GridViewRow row, string controlId, int defaultValue)
        {
            TextBox tb = row.FindControl(controlId) as TextBox;
            if (tb != null)
            {
                return AlwaysConvert.ToInt(tb.Text, defaultValue);
            }
            return 0;
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (this.Visible)
            {
                _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
                _Product = ProductDataSource.Load(_ProductId);
                if (_Product != null)
                {
                    _VariantManager = new ProductVariantManager(_ProductId);
                    _AvailableVariants = _VariantManager.LoadAvailableVariantGrid();
                    CreateDynamicGrid();
                }
                else
                {
                    this.Controls.Clear();
                }
            }
            else
            {
                this.Controls.Clear();
            }
        }

        private void CreateDynamicGrid()
        {
            if (_AvailableVariants == null) return;
            _DataTable = new DataTable();

            DataColumn dcol;
            dcol = new DataColumn("OptionList", typeof(System.String));
            _DataTable.Columns.Add(dcol);

            if (ShowThumbnail)
            {
                dcol = new DataColumn("Thumbnail", typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }

            if (ShowSku)
            {
                dcol = new DataColumn("Sku", typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }

            if (ShowPartNumber)
            {
                dcol = new DataColumn("PartNumber", typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }

            if (ShowGTIN)
            {
                dcol = new DataColumn("GTIN", typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }

            if (_ProdOptions == null) _ProdOptions = _Product.ProductOptions;
            foreach (ProductOption option in _ProdOptions)
            {
                dcol = new DataColumn(option.Option.Name, typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }

            if (ShowPrice)
            {
                dcol = new DataColumn("Price", typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }
            if (ShowMSRP)
            {
                dcol = new DataColumn("Retail", typeof(System.String));
                _DataTable.Columns.Add(dcol);
            }
            
            DataRow drow;
            foreach (ProductVariant variant in _AvailableVariants)
            {
                drow = _DataTable.NewRow();
                drow["OptionList"] = variant.OptionList;
                if (ShowThumbnail) drow["Thumbnail"] = string.IsNullOrEmpty(variant.ThumbnailUrl) ? string.Empty : variant.ThumbnailUrl;
                if (ShowSku) drow["Sku"] = string.IsNullOrEmpty(variant.Sku) ? variant.Sku : string.Format("<span itemprop='sku'>{0}</span>", variant.Sku);

                if (ShowPartNumber) drow["PartNumber"] = string.IsNullOrEmpty(variant.ModelNumber) ? variant.ModelNumber : string.Format("<span itemprop='mpn'>{0}</span>", variant.ModelNumber);
                if (ShowGTIN)
                {
                    if(string.IsNullOrEmpty(variant.GTIN))
                    {
                        drow["GTIN"] = variant.GTIN;
                    }
                    else
                    {
                        string gtinType = string.Empty;
                        switch (variant.GTIN.Length)
                        {
                            case 8:
                                gtinType = "gtin8";
                                break;
                            case 13:
                                gtinType = "gtin13";
                                break;
                            case 14:
                                gtinType = "gtin14";
                                break;
                            default:
                                gtinType = "gtin13";
                                break;
                        }
                        drow["GTIN"] = string.Format("<span itemprop='{0}'>{1}</span>", gtinType, variant.GTIN);
                    }
                }

                if (ShowPrice)
                {
                    decimal price = variant.Price.HasValue ? variant.Price.Value : 0;
                    drow["Price"] = price.LSCurrencyFormat("ulc");
                }
                if (ShowMSRP)
                {
                    decimal msrp = variant.MSRP.HasValue ? variant.MSRP.Value : 0;
                    drow["Retail"] = msrp.LSCurrencyFormat("ulc");
                }
                foreach (ProductOption option in _ProdOptions)
                {
                    drow[option.Option.Name] = variant.GetSelectedOptionChoiceName(option.Option.Choices);
                }
                _DataTable.Rows.Add(drow);
            }

            TemplateField tf;
            if (ShowThumbnail)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new ThumbnailTemplate(DataControlRowType.Header, "Thumbnail");
                tf.ItemTemplate = new ThumbnailTemplate(DataControlRowType.DataRow, "Thumbnail");
                VariantGrid.Columns.Add(tf);
            }

            if (ShowSku)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new LabelTemplate(DataControlRowType.Header, "Model");
                tf.ItemTemplate = new LabelTemplate(DataControlRowType.DataRow, "Sku");
                VariantGrid.Columns.Add(tf);
            }

            if (ShowPartNumber)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new LabelTemplate(DataControlRowType.Header, "Part&nbsp;#");
                tf.ItemTemplate = new LabelTemplate(DataControlRowType.DataRow, "PartNumber");
                VariantGrid.Columns.Add(tf);
            }

            if (ShowGTIN)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new LabelTemplate(DataControlRowType.Header, GTINName);
                tf.ItemTemplate = new LabelTemplate(DataControlRowType.DataRow, "GTIN");
                VariantGrid.Columns.Add(tf);
            }

            if (_ProdOptions == null) _ProdOptions = _Product.ProductOptions;
            foreach (ProductOption option in _ProdOptions)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new LabelTemplate(DataControlRowType.Header, option.Option.Name);
                tf.ItemTemplate = new LabelTemplate(DataControlRowType.DataRow, option.Option.Name);
                VariantGrid.Columns.Add(tf);
            }

            tf = new TemplateField();
            tf.HeaderTemplate = new QtyBoxTemplate(DataControlRowType.Header, "Qty");
            tf.ItemTemplate = new QtyBoxTemplate(DataControlRowType.DataRow, "Quantity");
            VariantGrid.Columns.Add(tf);

            if (ShowPrice)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new PriceLabelTemplate(DataControlRowType.Header, "Price", _ProductId);
                tf.ItemTemplate = new PriceLabelTemplate(DataControlRowType.DataRow, "Price", _ProductId);
                VariantGrid.Columns.Add(tf);
            }

            if (ShowMSRP)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new PriceLabelTemplate(DataControlRowType.Header, "Retail", _ProductId, true);
                tf.ItemTemplate = new PriceLabelTemplate(DataControlRowType.DataRow, "MSRP", _ProductId, true);
                VariantGrid.Columns.Add(tf);
            }

            bool inventoryEnabled = _Product.InventoryMode == InventoryMode.Variant && !_Product.AllowBackorder;
            if (inventoryEnabled && ShowInventoryMessage)
            {
                tf = new TemplateField();
                tf.HeaderTemplate = new MessageLabelTemplate(DataControlRowType.Header, "Inventory Status", _ProductId, true);
                tf.ItemTemplate = new MessageLabelTemplate(DataControlRowType.DataRow, "", _ProductId, true);
                VariantGrid.Columns.Add(tf);
            }

            tf = new TemplateField();
            tf.HeaderTemplate = new ButtonsBoxTemplate(DataControlRowType.Header, "");
            tf.ItemTemplate = new ButtonsBoxTemplate(DataControlRowType.DataRow, "");
            VariantGrid.Columns.Add(tf);

            //Initialize the DataSource
            VariantGrid.DataSource = _DataTable;
            //Bind the datatable with the GridView.
            VariantGrid.DataBind();
        }

        private class LabelTemplate : ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;

            public LabelTemplate(DataControlRowType type, string colname)
            {
                templateType = type;
                columnName = colname;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        // build the header for this column
                        Literal lc = new Literal();
                        //lc.Text = "<b>" + BreakCamelCase(columnName) + "</b>";
                        lc.Text = "<b>" + columnName + "</b>";
                        container.Controls.Add(lc);
                        break;
                    case DataControlRowType.DataRow:
                        // build one row in this column
                        Label l = new Label();
                        // register an event handler to perform the data binding
                        l.DataBinding += new EventHandler(this.l_DataBinding);
                        container.Controls.Add(l);
                        break;
                    default:
                        break;
                }
            }

            private void l_DataBinding(Object sender, EventArgs e)
            {
                // get the control that raised this event
                Label l = (Label)sender;
                // get the containing row
                GridViewRow row = (GridViewRow)l.NamingContainer;
                // get the raw data value and make it pretty
                string RawValue = DataBinder.Eval(row.DataItem, columnName).ToString();
                l.Text = RawValue;
            }
        }

        private class ThumbnailTemplate : ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;

            public ThumbnailTemplate(DataControlRowType type, string colname)
            {
                templateType = type;
                columnName = colname;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        // build the header for this column
                        Literal lc = new Literal();
                        //lc.Text = "<b>" + BreakCamelCase(columnName) + "</b>";
                        lc.Text = "<b>" + columnName + "</b>";
                        container.Controls.Add(lc);
                        break;
                    case DataControlRowType.DataRow:
                        // build one row in this column
                        Image image = new Image();
                        // register an event handler to perform the data binding
                        image.DataBinding += new EventHandler(this.image_DataBinding);
                        container.Controls.Add(image);
                        break;
                    default:
                        break;
                }
            }

            private void image_DataBinding(Object sender, EventArgs e)
            {
                // get the control that raised this event
                Image image = (Image)sender;
                // get the containing row
                GridViewRow row = (GridViewRow)image.NamingContainer;
                // get the raw data value and make it pretty
                string RawValue = DataBinder.Eval(row.DataItem, columnName).ToString();
                image.ImageUrl = RawValue;
            }
        }

        private class QtyBoxTemplate : System.Web.UI.ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;

            public QtyBoxTemplate(DataControlRowType type, string colname)
            {
                templateType = type;                
                columnName = colname;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        // build the header for this column
                        Literal lc = new Literal();
                        //lc.Text = "<b>" + BreakCamelCase(columnName) + "</b>";
                        lc.Text = "<b>" + columnName + "</b>";
                        container.Controls.Add(lc);
                        break;
                    case DataControlRowType.DataRow:
                        CommerceBuilder.UI.WebControls.UpDownControl updown = new CommerceBuilder.UI.WebControls.UpDownControl();
                        updown.Width = new Unit(30);
                        updown.ID = "Quantity";

                        // SET IMAGE FROM THEME
                        string theme = AbleCommerce.Code.StoreDataHelper.GetCurrentStoreTheme();
                        if (container.Page != null)
                        {
                            theme = container.Page.Theme;
                            if (string.IsNullOrEmpty(theme)) theme = container.Page.StyleSheetTheme;
                        }
                        updown.CssClass = "quantityUpDown";
                        updown.Columns = 2;
                        updown.MaxLength = 5;
                        updown.MaxValue = System.Int16.MaxValue;
                        updown.Text = "1";
                        updown.Attributes.Add("onfocus", "this.select()");
                        container.Controls.Add(updown);
                        break;
                    default:
                        break;
                }
            }
        }

        private class MessageLabelTemplate : ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;
            private int productId;
            private bool showInventoryMessage = true;

            public MessageLabelTemplate(DataControlRowType type, string colname, int productid, bool showinventorymessage)
            {
                templateType = type;
                columnName = colname;
                productId = productid;
                showInventoryMessage = showinventorymessage;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        // build the header for this column
                        Label lc = new Label();
                        //lc.Text = "<b>" + BreakCamelCase(columnName) + "</b>";
                        lc.Text = "<b>" + columnName + "</b>";
                        container.Controls.Add(lc);
                        break;
                    case DataControlRowType.DataRow:
                        // build one row in this column
                        Label l = new Label();
                        // register an event handler to perform the data binding
                        l.DataBinding += new EventHandler(this.msg_DataBinding);
                        container.Controls.Add(l);

                        var user = AbleContext.Current.User;
                        string emailText = string.Empty;
                        if (user!= null && !user.IsAnonymous)
                        {
                           emailText = AbleContext.Current.User.Email;
                        }

                        string validatorId = Guid.NewGuid().ToString();
                        TextBox emailbox = new TextBox();
                        emailbox.ID = "EmailText";
                        emailbox.SkinID = "NotifyEmail";
                        emailbox.ValidationGroup = "RestockNotify" + validatorId;
                        emailbox.Text = emailText;

                        LinkButton notify = new LinkButton();
                        notify.ID = "Notify";
                        notify.Text = "Notify";
                        notify.CommandName = "NotifyMe";
                        notify.CssClass = "button linkButton";
                        notify.ValidationGroup = "RestockNotify" + validatorId;
                        notify.DataBinding += new EventHandler(this.btn_DataBinding);

                        EmailAddressValidator emailRequired = new EmailAddressValidator();
                        emailRequired.ID = "UserEmailValidator";
                        emailRequired.ControlToValidate = "EmailText";
                        emailRequired.Required = true;
                        emailRequired.ErrorMessage = "Email address should be in the format of name@domain.tld.";
                        emailRequired.Text = "Email address should be in the format of name@domain.tld.";
                        emailRequired.ValidationGroup = "RestockNotify" + validatorId;

                        HtmlTable tableNotify = new HtmlTable();
                        tableNotify.Border = 0;

                        HtmlTableRow row = new HtmlTableRow();
                        HtmlTableCell cell = new HtmlTableCell();
                        cell.Style.Add("padding", "0");
                        cell.Style.Add("border", "none");
                        cell.Controls.Add(emailbox);
                        row.Cells.Add(cell);

                        cell = new HtmlTableCell();
                        cell.Style.Add("padding", "0");
                        cell.Style.Add("border", "none");
                        cell.Controls.Add(notify);
                        row.Cells.Add(cell);

                        HtmlTableRow row2 = new HtmlTableRow();
                        cell = new HtmlTableCell();
                        cell.Style.Add("padding", "0");
                        cell.Style.Add("border", "none");
                        cell.Controls.Add(emailRequired);
                        cell.ColSpan = 2;
                        row2.Cells.Add(cell);

                        tableNotify.Rows.Add(row);
                        tableNotify.Rows.Add(row2);
                        tableNotify.Attributes.Add("style", "display:none;");
                        container.Controls.Add(tableNotify);

                        container.Controls.Add(new LiteralControl("<br />"));

                        Label messageLabel = new Label();
                        messageLabel.ID = "messageLabel";
                        messageLabel.CssClass = "goodCondition";
                        messageLabel.Text = "Restock notification will be sent to '{0}' <br />";
                        messageLabel.Visible = false;
                        container.Controls.Add(messageLabel);

                        LinkButton button = new LinkButton();
                        button.ID = "NotificationLink";
                        button.CssClass = "linkButton";
                        button.OnClientClick = "return ShowNotification(this);";
                        button.Text = AbleContext.Current.Store.Settings.InventoryRestockNotificationLink;
                        button.EnableViewState = false;
                        container.Controls.Add(button);

                        break;
                    default:
                        break;
                }
            }

            private void msg_DataBinding(Object sender, EventArgs e)
            {
                if (showInventoryMessage)
                {
                    // get the control that raised this event
                    Label l = (Label)sender;
                    // get the containing row
                    GridViewRow row = (GridViewRow)l.NamingContainer;
                    // get the raw data value 
                    string optionlist = DataBinder.Eval(row.DataItem, "OptionList").ToString();
                    l.Text = GetInventoryMessage(optionlist);
                }
            }

            private void btn_DataBinding(Object sender, EventArgs e)
            {
                if (showInventoryMessage)
                {
                    // get the control that raised this event
                    LinkButton l = (LinkButton)sender;
                    // get the containing row
                    GridViewRow row = (GridViewRow)l.NamingContainer;
                    // get the raw data value 
                    string optionlist = DataBinder.Eval(row.DataItem, "OptionList").ToString();
                    l.CommandArgument = optionlist;
                }
            }

            private string GetInventoryMessage(string optionlist)
            {
                string message = string.Empty;
                Label label = new Label();
                if (!string.IsNullOrEmpty(optionlist) && showInventoryMessage)
                {
                    ProductVariant variant = ProductVariantDataSource.LoadForOptionList(productId, optionlist);
                    Product _Product = ProductDataSource.Load(productId);
                    bool inventoryEnabled = _Product.InventoryMode == InventoryMode.Variant && !_Product.AllowBackorder;
                    if (inventoryEnabled)
                    {
                        if (variant.InStock > 0)
                        {
                            string inStockformat = AbleContext.Current.Store.Settings.InventoryInStockMessage;
                            string inStockMessage = string.Format(inStockformat, variant.InStock);
                            message = inStockMessage;
                        }
                        else if (!variant.Available || variant.InStock <= 0)
                        {
                            string outOfStockformat = AbleContext.Current.Store.Settings.InventoryOutOfStockMessage;
                            string outOfStockMessage = string.Format(outOfStockformat, variant.InStock);
                            message = outOfStockMessage;

                            if (variant != null && variant.AvailabilityDate.HasValue && variant.AvailabilityDate >= LocaleHelper.LocalNow)
                            {
                                string availabilityMessageFormat = AbleContext.Current.Store.Settings.InventoryAvailabilityMessage;
                                string availabilityMessage = string.Format(availabilityMessageFormat, variant.AvailabilityDate.Value.ToShortDateString());
                                message += availabilityMessage;
                            }
                        }
                    }
                }
                return string.Format("<span class='errorCondition'>{0}</span>", message);
            }
        }

        private class PriceLabelTemplate : ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;
            private int _ProductId;
            private bool _showMSRP = false;

            public PriceLabelTemplate(DataControlRowType type, string colname, int productId)
            {
                templateType = type;
                columnName = colname;
                _ProductId = productId;
            }

            public PriceLabelTemplate(DataControlRowType type, string colname, int productId, bool showMSRP)
                :this(type, colname, productId)
            {
                _showMSRP = showMSRP;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        // build the header for this column
                        Literal lc = new Literal();
                        //lc.Text = "<b>" + BreakCamelCase(columnName) + "</b>";
                        lc.Text = "<b>" + columnName + "</b>";
                        container.Controls.Add(lc);
                        break;
                    case DataControlRowType.DataRow:
                        // build one row in this column
                        Label l = new Label();
                        l.Attributes.Add("itemprop", "price");
                        // register an event handler to perform the data binding
                        l.DataBinding += new EventHandler(this.l_DataBinding);
                        container.Controls.Add(l);
                        break;
                    default:
                        break;
                }
            }

            private void l_DataBinding(Object sender, EventArgs e)
            {
                if (_showMSRP)
                {
                    // get the control that raised this event
                    Label l = (Label)sender;
                    // get the containing row
                    GridViewRow row = (GridViewRow)l.NamingContainer;
                    // get the raw data value and make it pretty            
                    string optionList = DataBinder.Eval(row.DataItem, "OptionList").ToString();
                    l.Text = GetVariantPrice(optionList);
                }
                else
                {
                    // get the control that raised this event
                    Label l = (Label)sender;
                    // get the containing row
                    GridViewRow row = (GridViewRow)l.NamingContainer;
                    // get the raw data value and make it pretty            
                    string optionList = DataBinder.Eval(row.DataItem, "OptionList").ToString();
                    l.Text = GetVariantPrice(optionList);
                }
            }

            protected string GetVariantPrice(string optionList)
            {
                ProductCalculator pcalc = null;
                if (!string.IsNullOrEmpty(optionList) && _showMSRP)
                {
                    pcalc = ProductCalculator.LoadForProduct(_ProductId, 1, optionList, string.Empty);
                    return pcalc.MSRP.LSCurrencyFormat("ulc");
                }
                else if (!string.IsNullOrEmpty(optionList))
                {
                    Product p = ProductDataSource.Load(_ProductId);
                    pcalc = ProductCalculator.LoadForProduct(_ProductId, 1, optionList, string.Empty);
                    return TaxHelper.GetShopPrice(pcalc.Price, p.TaxCode != null ? p.TaxCode.Id : 0).LSCurrencyFormat("ulc");
                }
                return "";
            }
        }

        private class ButtonsBoxTemplate : System.Web.UI.ITemplate
        {
            private DataControlRowType templateType;
            private string columnName;

            public ButtonsBoxTemplate(DataControlRowType type, string colname)
            {
                templateType = type;
                columnName = colname;
            }

            public void InstantiateIn(System.Web.UI.Control container)
            {
                switch (templateType)
                {
                    case DataControlRowType.Header:
                        // build the header for this column
                        Literal lc = new Literal();
                        //lc.Text = "<b>" + BreakCamelCase(columnName) + "</b>";
                        lc.Text = "<b>" + columnName + "</b>";
                        container.Controls.Add(lc);
                        break;
                    case DataControlRowType.DataRow:
                        LinkButton lb1 = new LinkButton();
                        lb1.ID = "AddToBasketButton";
                        lb1.CommandName = "AddToBasket";
                        lb1.CssClass = "button linkButton";
                        lb1.Text = "Add to Cart";
                        lb1.EnableViewState = false;
                        lb1.ValidationGroup = "AddToBasket";
                        lb1.DataBinding += new EventHandler(this.lb_DataBinding);
                        container.Controls.Add(lb1);

                        if (AbleContext.Current.Store.Settings.WishlistsEnabled)
                        {
                            LinkButton lb2 = new LinkButton();
                            lb2.ID = "AddToWishlistButton";
                            lb2.CommandName = "AddToWishlist";
                            lb2.CssClass = "button linkButton";
                            lb2.Text = "Add to Wishlist";
                            lb2.EnableViewState = false;
                            lb2.ValidationGroup = "AddToBasket";
                            lb2.DataBinding += new EventHandler(this.lb_DataBinding);
                            container.Controls.Add(lb2);
                        }
                        break;
                    default:
                        break;
                }
            }

            private void lb_DataBinding(Object sender, EventArgs e)
            {
                // get the control that raised this event
                LinkButton l = (LinkButton)sender;
                // get the containing row
                GridViewRow row = (GridViewRow)l.NamingContainer;
                // get the raw data value 
                string optionList = DataBinder.Eval(row.DataItem, "OptionList").ToString();
                l.CommandArgument = optionList;
            }
        }

        protected void VariantGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                bool inventoryEnabled = _Product.InventoryMode == InventoryMode.Variant && !_Product.AllowBackorder;
                string optionList = DataBinder.Eval(e.Row.DataItem, "OptionList").ToString();
                ProductVariant variant = ProductVariantDataSource.LoadForOptionList(_ProductId, optionList);
                Control addToBasketButton = e.Row.FindControl("AddToBasketButton");
                Control notificationLink = e.Row.FindControl("NotificationLink");
                
                if (inventoryEnabled && (!variant.Available || (variant.InStock <= 0))
                    && ShowInventoryMessage && addToBasketButton != null)
                {
                    addToBasketButton.Visible = false;  
                }

                bool isAvailabilityDateSpecified = (variant.AvailabilityDate.HasValue && variant.AvailabilityDate >= LocaleHelper.LocalNow);
                if (notificationLink != null)
                    notificationLink.Visible = !addToBasketButton.Visible && isAvailabilityDateSpecified && variant.Product.EnableRestockNotifications;
            }
        }       
    }
}