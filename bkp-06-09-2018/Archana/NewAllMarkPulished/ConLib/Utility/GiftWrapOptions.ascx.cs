namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.ComponentModel;

    [Description("Displays gift wrapping options")]        
    public partial class GiftWrapOptions : System.Web.UI.UserControl
    {
        private string _FreeFormat = "{0}";
        private string _CostFormat = "{0} {1}";
        private int _WrapStyleId = 0;
        private IList<WrapStyle> _WrapStyles;

        public int BasketItemId
        {
            get
            {
                if (ViewState["BasketItemId"] == null) return 0;
                return (int)ViewState["BasketItemId"];
            }
            set { ViewState["BasketItemId"] = value; }
        }

        public int WrapGroupId
        {
            get
            {
                if (ViewState["WrapGroupId"] == null) return 0;
                return (int)ViewState["WrapGroupId"];
            }
            set { ViewState["WrapGroupId"] = value; }
        }

        public int WrapStyleId
        {
            get
            {
                if (NoGiftWrapPanel.Visible) return 0;
                if (OneGiftWrapPanel.Visible)
                {
                    if (!AddGiftWrap.Checked) return 0;
                    return AlwaysConvert.ToInt(AddGiftWrapStyleId.Value);
                }
                else
                {
                    return AlwaysConvert.ToInt(Request.Form[this.UniqueID + "_Wrap" + this.BasketItemId.ToString()]);
                }
            }
            set { _WrapStyleId = value; }
        }

        public String GiftMessage
        {
            get
            {
                GiftMessageText.Text = StringHelper.StripHtml(GiftMessageText.Text);
                return GiftMessageText.Text;
            }
            set { GiftMessageText.Text = value; }
        }

        public void CreateControls()
        {
            LoadWrapStyles();
            if (_WrapStyles == null)
            {
                //NO GIFT WRAP AVAILABLE
                OneGiftWrapPanel.Visible = false;
                MultiGiftWrapPanel.Visible = false;
            }
            else
            {
                NoGiftWrapPanel.Visible = false;
                if (_WrapStyles.Count == 1)
                {
                    //ONE GIFT WRAP OPTION, OFF OR ON
                    MultiGiftWrapPanel.Visible = false;
                    AddGiftWrapStyleId.Value = _WrapStyles[0].Id.ToString();
                    AddGiftWrapLabel.Text = string.Format(AddGiftWrapLabel.Text, _WrapStyles[0].Name);
                    if (_WrapStyles[0].Price > 0)
                    {
                        decimal shopPrice = TaxHelper.GetShopPrice(_WrapStyles[0].Price, (_WrapStyles[0].TaxCode != null) ? _WrapStyles[0].TaxCode.Id : 0, null, this.ShipTaxAddress);
                        AddGiftWrapPrice.Text = string.Format(AddGiftWrapPrice.Text, shopPrice.LSCurrencyFormat("ulc"));
                    }
                    else
                    {
                        AddGiftWrapPrice.Visible = false;
                    }
                    if (!String.IsNullOrEmpty(_WrapStyles[0].ThumbnailUrl))
                    {
                        string imageUrl = this.Page.ResolveUrl(_WrapStyles[0].ThumbnailUrl);
                        OneGiftWrapThumbnail.ImageUrl = imageUrl;

                        if (!String.IsNullOrEmpty(imageUrl))
                        {
                            string popup = AbleCommerce.Code.PageHelper.GetPopUpScript(this.Page.ResolveUrl(_WrapStyles[0].ImageUrl), "giftwrapimage", 300, 300);
                            OneGiftWrapThumbnailLink.Attributes.Add("onclick", popup);
                            OneGiftWrapThumbnailLink.Attributes.Add("href", "#");
                        }
                    }
                    else
                    {
                        trGiftWrapImage.Visible = false;
                    }
                }
                else
                {
                    OneGiftWrapPanel.Visible = false;
                    BuildWrapStyleList();
                }
            }
        }


        protected void BuildWrapStyleList()
        {
            WrapStyleRepeater.DataSource = _WrapStyles;
            WrapStyleRepeater.DataBind();
        }

        protected string GetStyleName(Object dataItem)
        {
            WrapStyle style = (WrapStyle)dataItem;
            if (style.Price > 0)
            {
                //NAME WITH PRICE
                decimal shopPrice = TaxHelper.GetShopPrice(style.Price, (style.TaxCode != null) ? style.TaxCode.Id : 0, null, this.ShipTaxAddress);
                return string.Format(_CostFormat, style.Name, shopPrice.LSCurrencyFormat("ulc"));
            }
            else
            {
                //JUST NAME
                return string.Format(_FreeFormat, style.Name);
            }
        }

        protected string GetCheckedStatus(int id)
        {
            return (_WrapStyleId == id) ? " checked" : string.Empty;
        }

        private void LoadWrapStyles()
        {
            WrapGroup wrapGroup = WrapGroupDataSource.Load(this.WrapGroupId);
            if (wrapGroup != null) _WrapStyles = wrapGroup.WrapStyles;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if ((!Page.IsPostBack) && (OneGiftWrapPanel.Visible))
            {
                if (AddGiftWrapStyleId.Value == _WrapStyleId.ToString()) AddGiftWrap.Checked = true;
            }
            //INIT GIFT MESSAGE COUNTDOWN
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(GiftMessageText, GiftMessageCharCount);
            GiftMessageCharCount.Text = ((int)(GiftMessageText.MaxLength - GiftMessageText.Text.Length)).ToString();
        }

        TaxAddress _ShipAddress = null;
        private TaxAddress ShipTaxAddress
        {
            get
            {
                if (_ShipAddress == null)
                {
                    User user = AbleContext.Current.User;
                    int basketItemId = this.BasketItemId;
                    foreach (BasketItem bi in user.Basket.Items)
                    {
                        if (bi.Id == BasketItemId)
                        {
                            if ((bi.Shipment != null) && (bi.Shipment.Address != null))
                            {
                                _ShipAddress = new TaxAddress(bi.Shipment.Address);
                            }
                        }
                    }
                    //IF WE STILL HAVEN'T FOUND SHIP ADDRESS, USE BILLING
                    if (_ShipAddress == null) _ShipAddress = new TaxAddress(user.PrimaryAddress);
                }
                return _ShipAddress;
            }
        }

        protected void WrapStyleRepeater_ItemCreated(Object sender, RepeaterItemEventArgs e)
        {

            WrapStyle style = (WrapStyle)e.Item.DataItem;
            if (!string.IsNullOrEmpty(style.ThumbnailUrl))
            {
                Image wrapStyleImage = (Image)e.Item.FindControl("WrapStyleImage");
                wrapStyleImage.Width = new Unit(AbleContext.Current.Store.Settings.ThumbnailImageWidth);
                wrapStyleImage.Height = new Unit(AbleContext.Current.Store.Settings.ThumbnailImageHeight);

                HyperLink wrapStyleImageLink = (HyperLink)e.Item.FindControl("WrapStyleImageLink");
                if (!string.IsNullOrEmpty(style.ImageUrl))
                {
                    string popup = AbleCommerce.Code.PageHelper.GetPopUpScript(this.Page.ResolveUrl(style.ImageUrl), "giftwrapimage", 300, 300);
                    wrapStyleImageLink.Attributes.Add("onclick", popup);
                }
                wrapStyleImageLink.Attributes.Add("href", "#");
            }
        }

        protected bool HasThumbnail(Object dataItem)
        {
            WrapStyle style = (WrapStyle)dataItem;
            return !string.IsNullOrEmpty(style.ThumbnailUrl);
        }
    }
}