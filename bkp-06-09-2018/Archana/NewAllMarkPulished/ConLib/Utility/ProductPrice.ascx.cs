namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;
    using System.ComponentModel;
    using System.Linq;

    [Description("Control to display product price")]
    public partial class ProductPrice : System.Web.UI.UserControl
    {
        private int _ProductId = 0;
        private Product _Product = null;
        private string _OptionList = string.Empty;
        private List<int> _SelectedKitProducts = new List<int>();
        private bool _EnableDefaultKitProducts = true;
        // FORMAT SPECIFIERS FOR FIXED (VISIBLE) PRICE
        private bool _ShowRetailPrice = false;
        private string _RetailPriceFormat = "<span class=\"msrp\">{0}</span> ";
        private string _PriceFormat = "{0}";
        private string _BasePriceFormat = "<span class=\"msrp\">{0}</span> ";
        private string _SpecialPriceFormat = "{0} ends {1:d}";
        private string _SpecialPriceFormat2 = "{0}";
        // FORMAT SPECIFIES FOR HIDDEN (POPUP) PRICE
        private bool _ShowPopupRetailPrice = true;
        private string _PopupRetailPriceLabel = "<b>List Price:</b>";
        private string _PopupRetailPriceFormat = "{0}";
        private string _PopupPriceLabel = "<b>Our Price:</b>";
        private string _PopupPriceFormat = "{0}";
        private string _PopupBasePriceLabel = "<b>Regular Price:</b>";
        private string _PopupBasePriceFormat = "{0}";
        private string _PopupSpecialPriceLabel = "<b>Sale Price:</b>";
        private string _PopupSpecialPriceFormat = "{0} ends {1:d}";
        private string _PopupSpecialPriceFormat2 = "{0}";
        private string _PopupAmountSavedLabel = "<b>You Save:</b>";
        private string _PopupAmountSavedFormat = "{0} ({1:F0}%)";
        private bool _CalculateOneTimePrice = false;

        /* properties that specify what product to show price for */
        public int ProductId
        {
            set
            {
                _ProductId = AlwaysConvert.ToInt(value);
                _Product = ProductDataSource.Load(_ProductId);
            }
        }

        public object Product
        {
            set
            {
                _Product = value as Product;
                if (_Product == null)
                {
                    CatalogNode node = value as CatalogNode;
                    if (node != null) _Product = node.ChildObject as Product;
                }
                if (_Product != null) _ProductId = _Product.Id;
                else _ProductId = 0;
            }
        }

        public string OptionList
        {
            set { _OptionList = value; }
        }

        public List<int> SelectedKitProducts
        {
            set { _SelectedKitProducts = value; }
        }

        public bool EnableDefaultKitProducts
        {
            set { _EnableDefaultKitProducts = value; }
            get { return _EnableDefaultKitProducts; }
        }

        public bool IncludeRichSnippetsWraper { get; set; }

        /* display properties */

        private bool _hideZeroPrice = true;
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true zero price value isn't displayed")]
        public bool HideZeroPrice
        {
            get { return _hideZeroPrice; }
            set { _hideZeroPrice = value; }
        }

        private bool _showQuoteOnZeroPrice = true;
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true zero price value will instead show Request Quote message")]
        public bool ShowQuoteOnZeroPrice
        {
            get { return _showQuoteOnZeroPrice; }
            set { _showQuoteOnZeroPrice = value; }
        }

        [Browsable(true)]
        [DefaultValue("Click to see price")]
        [Description("The text to use for show price link in the instance when price display is hidden")]
        public string ShowPriceLinkText
        {
            get { return ShowPriceLink.Text; }
            set { ShowPriceLink.Text = value; }
        }

        [Browsable(true)]
        [DefaultValue(false)]
        [Description("If true retail price is displayed")]
        public bool ShowRetailPrice
        {
            get { return _ShowRetailPrice; }
            set { _ShowRetailPrice = value; }
        }
        
        [Browsable(true)]
        [DefaultValue("<span class=\"msrp\">{0}</span> ")]
        [Description("The format text for retail price.")]
        public string RetailPriceFormat
        {
            get { return _RetailPriceFormat; }
            set { _RetailPriceFormat = value; }
        }
        
        [Browsable(true)]
        [DefaultValue("{0}")]
        [Description("The format text for standard price.")]
        public string PriceFormat
        {
            get { return _PriceFormat; }
            set { _PriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("<span class=\"msrp\">{0}</span> ")]
        [Description("The format text for base price.")]
        public string BasePriceFormat
        {
            get { return _BasePriceFormat; }
            set { _BasePriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0} ends {1:d}")]
        [Description("The format text for special price.")]
        public string SpecialPriceFormat
        {
            get { return _SpecialPriceFormat; }
            set { _SpecialPriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0}")]
        [Description("The format text for special price without end date specified.")]
        public string SpecialPriceFormat2
        {
            get { return _SpecialPriceFormat2; }
            set { _SpecialPriceFormat2 = value; }
        }

        // PROPERTIES FOR HIDDEN (POPUP) PRICE
        [Browsable(true)]
        [DefaultValue(true)]
        [Description("If true retail price is displayed in the popup price dialog")]
        public bool ShowPopupRetailPrice
        {
            get { return _ShowPopupRetailPrice; }
            set { _ShowPopupRetailPrice = value; }
        }

        [Browsable(true)]
        [DefaultValue("<b>List Price:</b>")]
        [Description("The label for retail price in popup price dialog")]
        public string PopupRetailPriceLabel
        {
            get { return _PopupRetailPriceLabel; }
            set { _PopupRetailPriceLabel = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0}")]
        [Description("The format for retail price in popup price dialog")]
        public string PopupRetailPriceFormat
        {
            get { return _PopupRetailPriceFormat; }
            set { _PopupRetailPriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("<b>Our Price:</b>")]
        [Description("The label for price in popup price dialog")]
        public string PopupPriceLabel
        {
            get { return _PopupPriceLabel; }
            set { _PopupPriceLabel = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0}")]
        [Description("The format for price in popup price dialog")]
        public string PopupPriceFormat
        {
            get { return _PopupPriceFormat; }
            set { _PopupPriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("<b>Regular Price:</b>")]
        [Description("The label for base price in popup price dialog")]
        public string PopupBasePriceLabel
        {
            get { return _PopupBasePriceLabel; }
            set { _PopupBasePriceLabel = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0}")]
        [Description("The format for base price in popup price dialog")]
        public string PopupBasePriceFormat
        {
            get { return _PopupBasePriceFormat; }
            set { _PopupBasePriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("<b>Sale Price:</b>")]
        [Description("The label for special price in popup price dialog")]
        public string PopupSpecialPriceLabel
        {
            get { return _PopupSpecialPriceLabel; }
            set { _PopupSpecialPriceLabel = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0} ends {1:d}")]
        [Description("The format for special price in popup price dialog")]
        public string PopupSpecialPriceFormat
        {
            get { return _PopupSpecialPriceFormat; }
            set { _PopupSpecialPriceFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("{0}")]
        [Description("The format for special price without end date specified in popup price dialog")]
        public string PopupSpecialPriceFormat2
        {
            get { return _PopupSpecialPriceFormat2; }
            set { _PopupSpecialPriceFormat2 = value; }
        }

        [Browsable(true)]
        [DefaultValue("<b>You Save:</b>")]
        [Description("The label for amount saved value in popup price dialog")]
        public string PopupAmountSavedLabel
        {
            get { return _PopupAmountSavedLabel; }
            set { _PopupAmountSavedLabel = value; }
        }
        
        [Browsable(true)]
        [DefaultValue("{0} ({1:F0}%)")]
        [Description("The format for amount saved value in popup price dialog")]
        public string PopupAmountSavedFormat
        {
            get { return _PopupAmountSavedFormat; }
            set { _PopupAmountSavedFormat = value; }
        }

        [Browsable(true)]
        [DefaultValue("False")]
        [Description("Indicates if we need to calculate one time price for the subscription product")]
        public bool CalculateOneTimePrice
        {
            get { return _CalculateOneTimePrice; }
            set { _CalculateOneTimePrice = value; }
        }

        public string UserCurrencyCode
        {
            get { return AbleContext.Current.User.UserCurrency.ISOCode; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            LoadCustomViewState();

            string scrollScript = @"var _lastWin;
function initPricePopup(divid)
{
    _lastWin = divid;
    reposPricePopup();
    window.onscroll = reposPricePopup;
}
function reposPricePopup()
{
    var div = document.getElementById(_lastWin);
    var st = document.body.scrollTop;
    if (st == 0) {
        if (window.pageYOffset) st = window.pageYOffset;
        else st = (document.body.parentElement) ? document.body.parentElement.scrollTop : 0;
    }
    div.style.top = 150 + st + ""px"";
}";

            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "PricePopup", scrollScript, true);
            ShowPriceLink.OnClientClick = "initPricePopup('" + PricePopup.ClientID + "');document.getElementById('" + PricePopup.ClientID + "').style.display='block';return false;";
            ClosePopUpLink.OnClientClick = "document.getElementById('" + PricePopup.ClientID + "').style.display='none';return false;";
            ShowPriceLink.Enabled = false;
            ShowPriceLink.Visible = false;
        }

        //save these from viewstate to process add request
        private int _AddProductId;
        private string _AddOptionList;
        private List<int> _AddKitProducts = new List<int>();
        private void LoadCustomViewState()
        {
            if (Page.IsPostBack)
            {
                string vsContent = Request.Form[VS.UniqueID];
                string decodedContent = EncryptionHelper.DecryptAES(vsContent);
                UrlEncodedDictionary customViewState = new UrlEncodedDictionary(decodedContent);
                _AddProductId = AlwaysConvert.ToInt(customViewState.TryGetValue("PID"));
                _AddOptionList = customViewState.TryGetValue("OL");
                int[] skp = AlwaysConvert.ToIntArray(customViewState.TryGetValue("SKP"));
                if (skp != null && skp.Length > 0)
                {
                    _AddKitProducts.AddRange(skp);
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (_Product != null)
            {
                if (!_Product.UseVariablePrice || _Product.IsSubscription)
                {
                    if(_showQuoteOnZeroPrice && !(_Product.VolumeDiscounts.Any() && _Product.VolumeDiscounts[0].Levels.Any()))
                    {
                        if (_Product.Price == 0)
                        {
                            Price.Text = "Request a quote";
                            return;
                        }
                    }

                    if (_hideZeroPrice)
                    {
                        if (_Product.Price == 0 && _Product.ProductOptions.Count > 0)
                        {
                            this.Visible = false;
                            return;
                        }
                    }
                    // UPDATE THE INCLUDED KITPRODUCTS (Included-Hidden and Included-Shown)
                    if (_SelectedKitProducts.Count == 0 && this.EnableDefaultKitProducts) UpdateIncludedKitOptions();
                    ProductCalculator pcalc = ProductCalculator.LoadForProduct(_Product.Id, 1, _OptionList, AlwaysConvert.ToList(",", _SelectedKitProducts), AbleContext.Current.UserId, true, this.CalculateOneTimePrice);

                    //IF REQUIRED MAKE ADJUSTMENTS TO DISPLAYED PRICE TO INCLUDE VAT
                    decimal basePriceWithVAT = TaxHelper.GetShopPrice(_Product.Price, (_Product.TaxCode != null) ? _Product.TaxCode.Id : 0);
                    decimal priceWithVAT = pcalc.PriceWithTax;
                    decimal msrpWithVAT = TaxHelper.GetShopPrice(_Product.MSRP, (_Product.TaxCode != null) ? _Product.TaxCode.Id : 0);
                    if (!_Product.HidePrice)
                    {
                        //PRICE IS VISIBLE, NO POPUP
                        phPricePopup.Visible = false;
                        //SHOW RETAIL PRICE IF INDICATED
                        if (_ShowRetailPrice && msrpWithVAT > 0 && !_Product.UseVariablePrice)
                        {
                            RetailPrice1.Text = string.Format(_RetailPriceFormat, msrpWithVAT.LSCurrencyFormat("ulc"));
                        }
                        else RetailPrice1.Text = string.Empty;
                        //SHOW THE PRICE
                        if (pcalc.AppliedSpecial != null)
                        {
                            // SHOW THE BASE PRICE AND SPECIAL PRICE
                            RetailPrice1.Text = string.Format(_BasePriceFormat, basePriceWithVAT.LSCurrencyFormat("ulc"));
                            if (pcalc.AppliedSpecial.EndDate != DateTime.MinValue)
                            {
                                Price.Text = string.Format(_SpecialPriceFormat, priceWithVAT.LSCurrencyFormat("ulc"), pcalc.AppliedSpecial.EndDate);
                            }
                            else
                            {
                                Price.Text = string.Format(_SpecialPriceFormat2, priceWithVAT.LSCurrencyFormat("ulc"), null);
                            }
                        }
                        else
                        {
                            Price.Text = string.Format(_PriceFormat, priceWithVAT.LSCurrencyFormat("ulc"));
                        }
                    }
                    else
                    {
                        // HIDDEN PRICE, USE POPUP
                        Price.Visible = false;
                        ProductName.Text = _Product.Name;
                        // THESE VARIABLES WILL TRACK SAVINGS OFF LISTED OR REGULAR PRICE
                        decimal amountSaved = 0;
                        decimal percentSaved = 0;
                        // DETERMINE IF A SALE OR SPECIAL PRICE IS APPLIED
                        bool salePriceEffective = (pcalc.AppliedSpecial != null);
                        // DETERMINE IF MSRP IS AVAILABLE FOR DISPLAY
                        if (_ShowRetailPrice && msrpWithVAT > 0 && !salePriceEffective)
                        {
                            trRetailPrice.Visible = true;
                            HiddenRetailPriceLabel.Text = PopupRetailPriceLabel;
                            HiddenRetailPrice.Text = string.Format(PopupRetailPriceFormat, msrpWithVAT.LSCurrencyFormat("ulc"));
                            // CALCULATE AMOUNT SAVED OVER MSRP
                            amountSaved = (msrpWithVAT - priceWithVAT);
                            percentSaved = ((decimal)(amountSaved / msrpWithVAT)) * 100;
                        }
                        else trRetailPrice.Visible = false;
                        // CHECK IF A SALE PRICE IS APPLIED
                        if (salePriceEffective)
                        {
                            // SPECIAL APPLIED, SHOW THE PRODUCT BASE PRICE AND THE SPECIAL PRICE
                            trSpecialPrice.Visible = true;
                            HiddenPriceLabel.Text = PopupBasePriceLabel;
                            HiddenPrice.Text = string.Format(PopupBasePriceFormat, basePriceWithVAT.LSCurrencyFormat("ulc"));
                            SpecialPriceLabel.Text = PopupSpecialPriceLabel;
                            if (pcalc.AppliedSpecial.EndDate != DateTime.MinValue)
                            {
                                SpecialPrice.Text = string.Format(PopupSpecialPriceFormat, priceWithVAT.LSCurrencyFormat("ulc"), pcalc.AppliedSpecial.EndDate);
                            }
                            else
                            {
                                SpecialPrice.Text = string.Format(PopupSpecialPriceFormat2, priceWithVAT.LSCurrencyFormat("ulc"), null);
                            }
                            // CALCULATE AMOUNT SAVED WITH SALE PRICE
                            amountSaved = (basePriceWithVAT - priceWithVAT);
                            percentSaved = ((decimal)(amountSaved / basePriceWithVAT)) * 100;
                        }
                        else
                        {
                            // NO SPECIAL, SO JUST SHOW THE CALCULATED PRICE
                            HiddenPriceLabel.Text = PopupPriceLabel;
                            HiddenPrice.Text = string.Format(PopupPriceFormat, priceWithVAT.LSCurrencyFormat("ulc"));
                        }
                        // SEE IF WE HAVE AN AMOUNT SAVED VALUE
                        if (amountSaved > 0)
                        {
                            trAmountSaved.Visible = true;
                            AmountSavedLabel.Text = PopupAmountSavedLabel;
                            AmountSaved.Text = string.Format(PopupAmountSavedFormat, amountSaved.LSCurrencyFormat("ulc"), percentSaved);
                        }
                        else trAmountSaved.Visible = false;
                    }
                }
                else
                {
                    //DO NOT DISPLAY THIS CONTROL IF THE PRODUCT HAS VARIABLE PRICE
                    this.Controls.Clear();
                }
            }
            else
            {
                //DO NOT DISPLAY THIS CONTROL IF THE PRODUCT IS UNAVAILABLE
                this.Controls.Clear();
            }
            SaveCustomViewState();
        }

        private void SaveCustomViewState()
        {
            UrlEncodedDictionary customViewState = new UrlEncodedDictionary();
            customViewState["PID"] = _ProductId.ToString();
            customViewState["OL"] = string.Empty + _OptionList;
            customViewState["SKP"] = GetCommaDelimitedKitProducts();
            VS.Value = EncryptionHelper.EncryptAES(customViewState.ToString());
        }

        private string GetCommaDelimitedKitProducts()
        {
            if (_SelectedKitProducts.Count == 0) return string.Empty;
            List<string> stringArray = new List<string>();
            foreach (int item in _SelectedKitProducts) stringArray.Add(item.ToString());
            return string.Join(",", stringArray.ToArray());
        }

        /// <summary>
        /// Update the SelectedKitProducts by including the hidden and shown included parts.
        /// These are not included on pages other then category pages.
        /// </summary>
        protected void UpdateIncludedKitOptions()
        {
            //COLLECT ANY KIT VALUES
            Kit kit = _Product.Kit;
            if (kit == null)
                return;
            IList<KitProduct> defaultProducts = kit.GetDefaultKitProducts();
            foreach (KitProduct p in defaultProducts)
            {
                _SelectedKitProducts.Add(p.Id);
            }
        }
    }
}