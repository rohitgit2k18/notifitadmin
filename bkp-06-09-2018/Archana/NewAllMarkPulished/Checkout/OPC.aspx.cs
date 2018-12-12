using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Extensions;
using CommerceBuilder.Orders;
using CommerceBuilder.Services;
using CommerceBuilder.Shipping;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Services.Checkout;
using AbleCommerce.ConLib.Checkout;
using CommerceBuilder.Stores;
using AbleCommerce.Code;
using System.Web.Security;
using CommerceBuilder.Marketing;
using CommerceBuilder.UI.WebControls;
using System.Text;
using CommerceBuilder.Taxes;

namespace AbleCommerce.Checkout
{
    public partial class OPC : CommerceBuilder.UI.AbleCommercePage
    {
        User _user = null;
        Basket _basket = null;
        IBasketService _basketService = null;
        StoreSettingsManager _settings;

        // key is the shipment id, list of qutoes
        Dictionary<int, List<LocalShipRateQuote>> _SavedShipRates = new Dictionary<int, List<LocalShipRateQuote>>();

        // holds saved basket hash
        private string _SavedBasketHash = string.Empty;

        // hold the calculated basket hash
        private string _CurrentBasketHash = string.Empty;

        bool _SelectUseExistingAddr = false;

        protected void Page_Init(object sender, EventArgs e)
        {
           Control[] controls = PageHelper.FindControls(Page, typeof(SearchKeywordValidator));
           if(controls != null)
           {
               foreach(Control control in controls)
               {
                   ((SearchKeywordValidator)control).KeywordRequired = false;
               }
           }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _SelectUseExistingAddr = false;
            _user = AbleContext.Current.User;
            _basket = _user.Basket;
            _basketService = AbleContext.Resolve<IBasketService>();
            _settings = AbleContext.Current.Store.Settings;

            // IF THERE ARE NO PRODUCTS, SEND THEN TO SEE EMPTY BASKET
            if (_basket.Items.FirstOrDefault(item => item.OrderItemType == OrderItemType.Product) == null)
                Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());

            bool redirected = ValidateOrderMinMaxAmounts();
            if (redirected) return;

            //WE CANNOT RELY ON TRADITIONAL VIEWSTATE IN THE INIT METHOD
            //SO WE WILL USE HIDDEN FORM VARIABLES INSTEAD
            LoadCustomViewState();

            if(!_user.IsAnonymous || _user.PrimaryAddress.IsValid) BillingAddress.AddressId = _user.PrimaryAddressId;
            BillingAddress.OnAddressUpdate += new AddressUpdateEventHandler(BillingAddress_AddressUpdate);
            BillingAddress.OnAddressCancel += new EventHandler(BillingAddress_AddressCancel);
            ShippingAddress.OnAddressUpdate += new AddressUpdateEventHandler(ShippingAddress_AddressUpdate);
            ShippingAddress.OnAddressCancel += new EventHandler(ShippingAddress_AddressCancel);

            PaymentWidget.Basket = _basket;
            PaymentWidget.CheckingOut += new CheckingOutEventHandler(CheckingOut);
            PaymentWidget.CheckedOut += new CheckedOutEventHandler(CheckedOut);
            PaymentWidget.CouponApplied += new CouponAppliedEventHandler(PaymentWidget_CouponApplied);
            
            bool hasValidBillingAddress = _user.PrimaryAddress != null && _user.PrimaryAddress.IsValid;
            bool hasShippableProducts = _basket.Items.HasShippableProducts();
            UseBillingAsShippingAddress.Visible = hasShippableProducts;
            //UseBillingAsShippingAddress.Visible = hasShippableProducts && hasValidBillingAddress;
            ShipMultiPanel.Visible = hasShippableProducts && _settings.EnableShipToMultipleAddresses && _basket.Items.ShippableProductCount() > 1;
            
            if (!Page.IsPostBack)
            {                   
                _basketService.Package(_basket, false);
                if (hasShippableProducts)
                {
                    BasketShipment shipment = _basket.Shipments.FirstOrDefault();
                    if (shipment != null)
                    {
                        BindShippingMethods(shipment.Address, false);
                    }
                    else
                    {
                        BindShippingMethods(null, false);
                    }
                    DeliveryInstructionsForm.Visible = _settings.EnableShipMessage;
                }
                else
                {
                    DelieveryMethodsPanel.Visible = false;
                }

                // checkout terms and conditions
                if (!string.IsNullOrEmpty(_settings.CheckoutTermsAndConditions))
                {
                    TermsAndConditions.Text = _settings.CheckoutTermsAndConditions;                    
                    TermsAndConditionsSection.Visible = true;                    
                    string TCScript = "function toggleTC(c) { document.getElementById(\"" + AcceptTC.ClientID + "\").checked = c; }\r\n" +
                        "function validateTC(source, args) { args.IsValid = document.getElementById(\"" + AcceptTC.ClientID + "\").checked; }";
                    this.Page.ClientScript.RegisterStartupScript(this.GetType(), "TCScript", TCScript, true);
                }
            }

            _CurrentBasketHash = _basket.GetContentHash(OrderItemType.Product);
        }

        void PaymentWidget_CouponApplied(object sender, EventArgs e)
        {
            // recalculate and repopulate the basket
            RecalculateBasket(true);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            bool hasValidBillingAddress = _user.PrimaryAddress != null && _user.PrimaryAddress.IsValid;            

            LoginPanel.Visible = _user.IsAnonymous && !EmailRegisteredPanel.Visible;
            LoginLink.NavigateUrl = "~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.AbsolutePath);
            LoginLink2.NavigateUrl = "~/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.AbsolutePath);

            if (!Page.IsPostBack)
            {
                IntializeEmailLists();
            }

            BasketShipment shipment = _basket.Shipments.FirstOrDefault();
            if (shipment != null && shipment.Address != null && shipment.Address.IsValid)
            {
                SetFormattedShipAddress(shipment.Address);

                if (!Page.IsPostBack)
                {
                    UseBillingAsShippingAddress.Checked = (shipment.Address.Id == _user.PrimaryAddress.Id);
                }

                if (shipment.AddressId == _user.PrimaryAddress.Id)
                {
                    ShippingAddressTextPanel.Visible = false;
                }
            }
            else
            {                
                ShippingAddressTextPanel.Visible = false;
            }

            if (BillingAddress.Visible)
            {
                UseBillingAsShippingAddress.Visible = false;
            }

            ShippingAddressPanel.Visible = UseBillingAsShippingAddress.Visible && !UseBillingAsShippingAddress.Checked;

            if (!Page.IsPostBack)
            {
                if (hasValidBillingAddress)
                {
                    BillingAddressTextPanel.Visible = true;
                    FormattedBillingAddress.Text = GetFormattedAddressString(_user.PrimaryAddress);
                    BillingAddress.Visible = false;
                    UseBillingAsShippingAddress.Visible = true;
                }
                else
                {
                    BillingAddressTextPanel.Visible = false;
                    BillingAddress.Visible = true;
                    UseBillingAsShippingAddress.Visible = false;
                }

                ShippingAddressPanel.Visible = UseBillingAsShippingAddress.Visible && !UseBillingAsShippingAddress.Checked;
                if (ShippingAddressPanel.Visible)
                {
                    if (UseExistingAddress.Checked)
                    {
                        trAddressList.Visible = true;
                        trShippingAddress.Visible = false;
                        BindShippingAddreses();
                    }
                    else if(UseNewAddress.Checked)
                    {
                        trAddressList.Visible = false;
                        trShippingAddress.Visible = true;
                    }
                }
            }

            if (_SelectUseExistingAddr)
            {
                UseExistingAddress.Checked = true;
                UseNewAddress.Checked = false;
            }

            PageOverlay.Visible = BillingAddress.Visible || trShippingAddress.Visible;

            //PERSIST VALUES TO FORM
            SaveCustomViewState();
        }

        private static string GetFormattedAddressString(Address address)
        {
            string pattern = address.Country.AddressFormat;
            if (!string.IsNullOrEmpty(address.Email) && !pattern.Contains("[Email]") && !pattern.Contains("[Email_U]")) pattern += "\r\n[Email]";
            if (!string.IsNullOrEmpty(address.Phone) && !pattern.Contains("[Phone]") && !pattern.Contains("[Phone_U]")) pattern += "\r\nPhone: [Phone]";
            if (!string.IsNullOrEmpty(address.Fax) && !pattern.Contains("[Fax]") && !pattern.Contains("[Fax_U]")) pattern += "\r\nFax: [Fax]";

            return address.ToString(pattern, true); 
        }

        protected void UseBillingAsShippingAddress_CheckedChanged(object sender, EventArgs e)
        {
            if (!UseBillingAsShippingAddress.Checked)
            {
                BindShippingAddreses();
                if (AddressList.Items.Count > 0) AddressList_SelectedIndexChanged(sender, e);
            }
            else
            {
                _basketService.Package(_basket, true);
                BindShippingMethods(_user.PrimaryAddress, true);
            }
        }

        protected void EditBillAddress_Click(object sender, EventArgs e)
        {
            BillingAddressTextPanel.Visible = false;
            BillingAddress.Visible = true;
        }

        protected void BillingAddress_AddressUpdate(object sender, AddressEventArgs e)
        {
            // update the user instance, user instance might be changed if a new account is registered
            _user = AbleContext.Current.User;
            _basket = _user.Basket;

            if (e.Address.IsValid)
            {
                // if anonymous user or guest checkout then validate email address, check if it is not already registerd
                string email = e.Address.Email;
                if (_user.IsAnonymousOrGuest && UserDataSource.IsEmailRegistered(email))
                {
                    EmailRegisteredPanel.Visible = true;
                }
                else
                {
                    // Update user primary address
                    Address address = _user.PrimaryAddress;
                    if (address.Id != e.Address.Id)
                    {                        
                        address.FirstName = e.Address.FirstName;
                        address.LastName = e.Address.LastName;
                        address.Nickname = e.Address.Nickname;
                        address.FullName = e.Address.FullName;
                        address.Address1 = e.Address.Address1;
                        address.Address2 = e.Address.Address2;
                        address.City = e.Address.City;
                        address.Company = e.Address.Company;
                        address.Country = e.Address.Country;
                        address.Email = e.Address.Email;
                        address.Fax = e.Address.Fax;
                        address.IsBilling = e.Address.IsBilling;
                        address.Phone = e.Address.Phone;
                        address.PostalCode = e.Address.PostalCode;
                        address.Province = e.Address.Province;
                    }
                    address.Save();

                    BillingAddressTextPanel.Visible = true;
                    FormattedBillingAddress.Text = GetFormattedAddressString(e.Address);
                    BillingAddress.Visible = false;

                    _basketService.Package(_basket, true);
                    BasketShipment shipment = _basket.Shipments.FirstOrDefault();
                    if (shipment != null)
                    {
                        if (shipment.Address == null || shipment.Address.Id == address.Id)
                        {
                            BindShippingMethods(address, true);
                        }
                    }
                    IntializeEmailLists();
                }
            }
        }

        protected void BillingAddress_AddressCancel(object sender, EventArgs e)
        {
            Address billingAddress = AbleContext.Current.User.PrimaryAddress;
            if (billingAddress == null || !billingAddress.IsValid)
            {
                Response.Redirect(NavigationHelper.GetBasketUrl());
            }
            else
            {
                BillingAddressTextPanel.Visible = true;
                FormattedBillingAddress.Text = GetFormattedAddressString(billingAddress);
                BillingAddress.Visible = false;
            }
        }

        protected void EditShipAddress_Click(object sender, EventArgs e)
        {
            ShippingAddressTextPanel.Visible = false;
            trShippingAddress.Visible = true;            

            BasketShipment shipment = _basket.Shipments.FirstOrDefault();
            if (shipment != null)
            {
                ShippingAddress.AddressId = shipment.AddressId;
                ShippingAddress.Reload();
            }
        }

        protected void ShippingAddress_AddressUpdate(object sender, AddressEventArgs e)
        {
            e.Address.User = _user;
            e.Address.Save();
            if (!_user.Addresses.Contains(e.Address))
            {
                _user.Addresses.Add(e.Address);
            }
                        
            BindShippingMethods(e.Address, true);
            if (e.Address.IsValid)
            {
                FormattedShippingAddress.Text = GetFormattedAddressString(e.Address);
                ShippingAddressTextPanel.Visible = true;
                trShippingAddress.Visible = false;
                UseExistingAddress.Checked = true;
                _SelectUseExistingAddr = true;

                trUseExistingAddress.Visible = true;
                trNewAddress.Visible = true;
                trAddressList.Visible = true;
                BindShippingAddreses();          
            }
            else
            {
                ShippingAddressTextPanel.Visible = false;
                trShippingAddress.Visible = true;
            }
        }

        protected void ShippingAddress_AddressCancel(object sender, EventArgs e)
        {
            Address billingAddress = AbleContext.Current.User.PrimaryAddress;
            Address shipAddress = null;
            foreach (BasketShipment shipment in _basket.Shipments)
            {
                if (shipment.Address != null && shipment.Address.IsValid)
                {
                    shipAddress = shipment.Address;
                    break;
                }
            }

            if (shipAddress == null)
            {                
                if (billingAddress != null && billingAddress.IsValid)
                {
                    shipAddress = billingAddress;                    
                }
                UseBillingAsShippingAddress.Checked = true;
            }
            else if(billingAddress!= null && billingAddress.Id == shipAddress.Id)
            {
                UseBillingAsShippingAddress.Checked = true;
            }
            else
            {
                FormattedShippingAddress.Text = GetFormattedAddressString(shipAddress);
                ShippingAddressTextPanel.Visible = true;
                trShippingAddress.Visible = false;
                UseExistingAddress.Checked = true;
                _SelectUseExistingAddr = true;

                trUseExistingAddress.Visible = true;
                trNewAddress.Visible = true;
                trAddressList.Visible = true;
            }
        }

        protected void AddressList_SelectedIndexChanged(object sender, EventArgs e)
        {            
            var address = AddressDataSource.Load(AlwaysConvert.ToInt(AddressList.SelectedValue));
            BindShippingMethods(address, true);
            
            trUseExistingAddress.Visible = true;
            trAddressList.Visible = true;
            ShippingAddressTextPanel.Visible = true;
            trShippingAddress.Visible = false;            
        }

        protected void UseExistingAddress_CheckedChanged(object sender, EventArgs e)
        {
            trAddressList.Visible = UseExistingAddress.Checked;
            trShippingAddress.Visible = !UseExistingAddress.Checked;
            if (UseExistingAddress.Checked)
            {
                ShippingAddressTextPanel.Visible = true;
            }
        }

        protected void UseNewAddress_CheckedChanged(object sender, EventArgs e)
        {
            trAddressList.Visible = !UseNewAddress.Checked;
            trShippingAddress.Visible = UseNewAddress.Checked;
            if (UseNewAddress.Checked)
            {
                ShippingAddressTextPanel.Visible = false;
                ShippingAddress.AddressId = 0;
                ShippingAddress.Reload();
            }
        }

        protected void SetFormattedShipAddress(int addressId)
        {
            Address addr = AddressDataSource.Load(addressId);
            if (addr != null)
            {
                SetFormattedShipAddress(addr);
            }
        }

        protected void SetFormattedShipAddress(Address address)
        {
            if (address != null)
            {
                FormattedShippingAddress.Text = GetFormattedAddressString(address);
            }
        }

        protected void BindShippingMethods(bool recalculateShipRates)
        {
            BasketShipment shipment = _basket.Shipments.FirstOrDefault();
            if (shipment != null)
            {
                BindShippingMethods(shipment.Address, recalculateShipRates);
            }
            else
            {
                BindShippingMethods(null, recalculateShipRates);
            }
        }

        protected void BindShippingMethods(Address address, bool recalculateShipRates)
        {       
            if(address == null || !address.IsValid) address = _user.PrimaryAddress;

            if (_basket.Items.HasShippableProducts() && address!=null && address.IsValid)
            {
                DelieveryMethodsPanel.Visible = true;
                List<Tuple<BasketShipment, List<ListItem>>> shipmentBindings = new List<Tuple<BasketShipment, List<ListItem>>>();
                foreach (BasketShipment shipment in _basket.Shipments)
                {
                    if (address != null && address.IsValid)
                    {
                        shipment.Address = address;
                        shipment.Save();
                    }
                    List<ListItem> shipMethods = GetShipMethodList(shipment, recalculateShipRates);
                    Tuple<BasketShipment, List<ListItem>> item = new Tuple<BasketShipment, List<ListItem>>(shipment, shipMethods);
                    shipmentBindings.Add(item);
                }
                _basketService.Recalculate(_basket);
                _CurrentBasketHash = _basket.GetContentHash(OrderItemType.Product);

                ShipmentsRepeater.DataSource = shipmentBindings;
                ShipmentsRepeater.DataBind();
            }
            else
            {
                DelieveryMethodsPanel.Visible = false;                
            }
        }

        protected List<ListItem> GetShipMethodList(BasketShipment shipment, bool forceRecalcualte)
        {
            List<ListItem> methodList = new List<ListItem>();
            bool hasSelected = false;

            if (shipment != null)
            {
                IShipRateQuoteCalculator shippingCalculator = AbleContext.Resolve<IShipRateQuoteCalculator>();
                List<LocalShipRateQuote> localQuotes = null;
                _SavedShipRates.TryGetValue(shipment.Id, out localQuotes);
                if (forceRecalcualte  || localQuotes == null)
                {
                    //RECALCULATE THE RATES
                    localQuotes = new List<LocalShipRateQuote>();
                    ICollection<ShipRateQuote> rateQuotes = shippingCalculator.QuoteForShipment(shipment);
                    foreach (ShipRateQuote quote in rateQuotes)
                    {
                        decimal totalRate = TaxHelper.GetShopPrice(quote.TotalRate, quote.ShipMethod.TaxCodeId, null, new TaxAddress(shipment.Address));
                        string formattedRate = totalRate.LSCurrencyFormat("ulc");
                        string methodName = (totalRate > 0) ? quote.Name + ": " + formattedRate : quote.Name;
                        localQuotes.Add(new LocalShipRateQuote(quote.ShipMethodId, methodName, formattedRate));
                    }
                    _SavedShipRates[shipment.Id] = localQuotes;
                }

                foreach (LocalShipRateQuote quote in localQuotes)
                {
                    ListItem item = new ListItem(quote.Name, quote.ShipMethodId.ToString());
                    if (shipment.ShipMethodId != 0 && shipment.ShipMethodId == quote.ShipMethodId)
                    {
                        item.Selected = true;
                        hasSelected = true;
                    }
                    methodList.Add(item);
                }

                if (!hasSelected)
                {
                    if (methodList.Count > 0)
                    {
                        methodList[0].Selected = true;
                        shipment.ShipMethodId = AlwaysConvert.ToInt(methodList[0].Value);
                        shipment.Save();
                    }
                }
            }
            
            return methodList;
        }

        private void SaveCustomViewState()
        {
            UrlEncodedDictionary customViewState = new UrlEncodedDictionary();
            customViewState.Add("SavedBasketHash", _CurrentBasketHash);
            customViewState.Add("SavedShipRates", EncodeSavedShipRates());
            VS_CustomState.Value = EncryptionHelper.EncryptAES(customViewState.ToString());
        }

        private string EncodeSavedShipRates()
        {
            StringBuilder encodedRates = new StringBuilder();
            string separator = string.Empty;
            foreach (int shipmentNumber in _SavedShipRates.Keys)
            {
                if (_SavedShipRates[shipmentNumber].Count > 0)
                {
                    encodedRates.Append(separator);
                    encodedRates.Append(shipmentNumber.ToString() + "__");
                    string separator2 = string.Empty;
                    StringBuilder encodedQuotes = new StringBuilder();
                    foreach (LocalShipRateQuote quoteItem in _SavedShipRates[shipmentNumber])
                    {
                        encodedQuotes.Append(separator2);
                        encodedQuotes.Append(quoteItem.Encode());
                        separator2 = "||";
                    }
                    encodedRates.Append(encodedQuotes.ToString());
                    separator = "__";
                }
            }
            return encodedRates.ToString();
        }
        
        private void LoadCustomViewState()
        {
            User user = AbleContext.Current.User;
            _CurrentBasketHash = user.Basket.GetContentHash(OrderItemType.Product);
            if (Page.IsPostBack)
            {
                UrlEncodedDictionary customViewState = new UrlEncodedDictionary(EncryptionHelper.DecryptAES(Request.Form[VS_CustomState.UniqueID]));                
                string savedBasketHash = customViewState.TryGetValue("SavedBasketHash");
                if (savedBasketHash == _CurrentBasketHash)
                {
                    string savedShipRates = customViewState.TryGetValue("SavedShipRates");
                    ParseSavedShipRates(savedShipRates);
                }
                _SavedBasketHash = savedBasketHash;
            }
        }

        private void ParseSavedShipRates(string savedShipRates)
        {
            if (!string.IsNullOrEmpty(savedShipRates))
            {
                string[] shipRates = StringHelper.Split(savedShipRates, "__");
                for (int i = 0; i < shipRates.Length; i += 2)
                {
                    int shipmentNumber = AlwaysConvert.ToInt(shipRates[i]);
                    List<LocalShipRateQuote> shipRateQuoteItems = new List<LocalShipRateQuote>();
                    string[] encodedQuoteValues = StringHelper.Split(shipRates[i + 1], "||");
                    foreach (string encodedQuoteValue in encodedQuoteValues)
                    {
                        shipRateQuoteItems.Add(new LocalShipRateQuote(encodedQuoteValue));
                    }
                    _SavedShipRates[shipmentNumber] = shipRateQuoteItems;
                }
            }
        }

        protected List<ListItem> GetShipMethods(object data)
        {
            Tuple<BasketShipment, List<ListItem>> item = data as Tuple<BasketShipment, List<ListItem>>;
            if (item != null) return item.Item2;
            return new List<ListItem>();
        }

        protected int GetShipmentId(object data)
        {
            Tuple<BasketShipment, List<ListItem>> item = data as Tuple<BasketShipment, List<ListItem>>;
            if (item != null) return item.Item1.Id;
            return 0;
        }

        protected bool ShowDeliveryInstructions()
        {
            return _settings.EnableShipMessage;
        }

        protected void ShipMethods_Databound(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            if (ddl != null)
            {
                int shipmentId = AlwaysConvert.ToInt(ddl.Attributes["ShipmentId"]);
                BasketShipment shipment = _basket.Shipments.Find(a => a.Id == shipmentId);
                if (shipment != null)
                {
                    if (shipment.ShipMethod != null)
                    {
                        ListItem item = ddl.Items.FindByValue(shipment.ShipMethodId.ToString());
                        if (item != null)
                        {
                            item.Selected = true;
                        }
                    }
                    else
                    {
                        if (ddl.Items.Count > 0)
                        {
                            var shipMethod = ShipMethodDataSource.Load(AlwaysConvert.ToInt(ddl.Items[0].Value));
                            if (shipMethod != null)
                            {
                                shipment.ShipMethod = shipMethod;
                                shipment.Save();
                            }
                        }
                    }
                }
            }
        }

        private void BindShippingAddreses()
        {
            IList<Address> addresses = _user.Addresses.FindAll(a => a.Id != _user.PrimaryAddressId);
            if (addresses.Count > 0)
            {
                
                trUseExistingAddress.Visible = true;
                trNewAddress.Visible = true;
                trAddressList.Visible = UseExistingAddress.Checked;

                AddressList.Items.Clear();
                foreach (Address address in addresses)
                {
                    string company = string.IsNullOrEmpty(address.Company) ? string.Empty : address.Company + " ";
                    string tempAddress = company + address.FullName + " " + address.Address1;
                    if (tempAddress.Length > 45) tempAddress = tempAddress.Substring(0, 42) + "...";
                    string itemText = string.Format("{0} {1}", tempAddress, address.City);
                    ListItem listItem = new ListItem(itemText, address.Id.ToString());
                    AddressList.Items.Add(listItem);
                }

                BasketShipment shipment = _basket.Shipments.FirstOrDefault();
                if (shipment != null)
                {
                    if (shipment.AddressId > 0 && shipment.AddressId != _user.PrimaryAddressId)
                    {
                        ListItem item = AddressList.Items.FindByValue(shipment.AddressId.ToString());
                        if (item != null) item.Selected = true;
                    }
                    else if (AddressList.Items.Count > 0 && AddressList.SelectedValue == string.Empty)
                    {
                        AddressList.Items[0].Selected = true;
                        AddressList_SelectedIndexChanged(null, null);
                    }
                }
            }
            else
            {
                trShippingAddress.Visible = true;
                trAddressList.Visible = false;
                trUseExistingAddress.Visible = false;
                trNewAddress.Visible = false;
            }
        }

        protected void ShipMethodsList_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = sender as DropDownList;
            int shipmentId = AlwaysConvert.ToInt(ddl.Attributes["ShipmentId"]);           
            var shipMethod = ShipMethodDataSource.Load(AlwaysConvert.ToInt(ddl.SelectedValue));
            if(shipMethod == null) return;
            foreach (BasketShipment shipment in _basket.Shipments)
            {
                if (shipment.Id == shipmentId)
                {
                    shipment.ShipMethodId = shipMethod.Id;
                    shipment.Save();
                    _basketService.Recalculate(_basket);
                    _CurrentBasketHash = _basket.GetContentHash(OrderItemType.Product);
                    break;
                }
            }
            _basket.Save();
        } 

        protected void ValidateTC(object source, ServerValidateEventArgs args)
        {
            args.IsValid = AcceptTC.Checked;
        }

        protected void CheckingOut(object sender, CheckingOutEventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid)
            {
                e.Cancel = true;
                return;
            }

            if (Page.IsValid)
            {
                if (!string.IsNullOrEmpty(Comments.Text))
                {
                    foreach (BasketShipment shipment in _basket.Shipments)
                    {
                        shipment.ShipMessage = StringHelper.StripHtml(Comments.Text);
                        shipment.Save();
                    }
                }
            }

            //Make sure basket hasn't changed during checkout
            if (_CurrentBasketHash != _SavedBasketHash)
            {
                e.Cancel = true;
                CheckoutMessagePanel.Visible = true;
                CheckoutMessage.Text = "Your order has not been completed and payment was not processed.<br /><br />Your cart appears to have been modified during checkout.  Please verify the contents of your order and resubmit your payment.";
                RecalculateBasket(true);

                return;
            }

            //Make sure that a valid billing address is set
            User user = AbleContext.Current.User;
            if (user.PrimaryAddress == null || !user.PrimaryAddress.IsValid)
            {
                e.Cancel = true;
                
                CheckoutMessagePanel.Visible = true;
                CheckoutMessage.Text = "Your order has not been completed and payment was not processed.<br /><br />The billing address is invalid.  Please correct the address and resubmit your payment.";
                
                return;
            }
            
            if(AbleContext.Current.User.IsAnonymous)
            {
                // ANONYMOUS USER SELECTING GUEST CHECKOUT, CREATE TEMPORARY ACCOUNT
                User oldUser = AbleContext.Current.User;
                string newUserName = "zz_anonymous_" + Guid.NewGuid().ToString("N") + "@domain.xyz";
                string newEmail = StringHelper.StripHtml(oldUser.PrimaryAddress.Email);
                string newPassword = Guid.NewGuid().ToString("N");
                MembershipCreateStatus createStatus;
                User newUser = UserDataSource.CreateUser(newUserName, newEmail, newPassword, string.Empty, string.Empty, true, 0, out createStatus);

                // IF THE CREATE FAILS, IGNORE AND CONTINUE CREATING THE ORDER
                if (createStatus == MembershipCreateStatus.Success)
                {
                    // CHANGE THE NAME AND EMAIL TO SOMETHING MORE FRIENDLY THAN GUID
                    newUser.UserName = "zz_anonymous_" + newUser.Id.ToString() + "@domain.xyz";
                    newUser.Save();
                    CommerceBuilder.Users.User.Migrate(oldUser, newUser, true, true, true);
                    AbleContext.Current.User = newUser;
                    FormsAuthentication.SetAuthCookie(newUser.UserName, false);
                }
            }
        }

        private void RecalculateBasket(bool rebindPaymentForms)
        {
            //UPDATE SHIPPING RATES
            if (DelieveryMethodsPanel.Visible)
            {
                int shipmentIndex = 0;
                foreach (RepeaterItem item in ShipmentsRepeater.Items)
                {
                    BasketShipment shipment = _basket.Shipments[shipmentIndex];
                    DropDownList ShipMethodList = (DropDownList)item.FindControl("ShipMethodList");
                    if (ShipMethodList != null)
                    {
                        shipment.ShipMethodId = AlwaysConvert.ToInt(ShipMethodList.SelectedValue);
                        shipment.Save();
                    }
                    shipmentIndex++;
                }
            }
            //RECALCULATE SHIPPING, TAXES, DISCOUNTS, ETC.
            _basketService.Recalculate(_basket);
            _CurrentBasketHash = _basket.GetContentHash(OrderItemType.Product);
            
            if (rebindPaymentForms) PaymentWidget.DataBind();
        }

        protected void CheckedOut(object sender, CheckedOutEventArgs e)
        {
            // MAILING LIST SIGNUP
            if (EmailListsPanel.Visible && EmailLists.Items.Count > 0)
            {
                string email = string.IsNullOrEmpty(AbleContext.Current.User.Email) ? AbleContext.Current.User.PrimaryAddress.Email : AbleContext.Current.User.Email;
                int listIndex = 0;
                IList<EmailList> emailLists = GetPublicEmailLists();
                if (emailLists != null && emailLists.Count > 0)
                {
                    foreach (ListViewDataItem item in EmailLists.Items)
                    {
                        EmailList list = emailLists[listIndex];
                        CheckBox selected = (CheckBox)item.FindControl("Selected");
                        if (selected != null)
                        {
                            if (selected.Checked)
                                list.ProcessSignupRequest(email);
                            else
                                list.RemoveMember(email);
                        }
                        else list.RemoveMember(email);
                        listIndex++;
                    }
                }
            }
        }

        protected void MultipleShipmentsButton_Click(object sender, EventArgs e)
        {
            if (AbleContext.Current.User.IsAnonymous)
            {
                Response.Redirect("~/Checkout/Default.aspx");
            }
            
            Response.Redirect("~/Checkout/ShipAddresses.aspx");
        }

        
        private void IntializeEmailLists()
        {
            IList<EmailList> lists = GetPublicEmailLists();
            if ((lists.Count > 0) && (!AbleContext.Current.User.IsAnonymous || AbleContext.Current.User.PrimaryAddress.IsValid))
            {
                EmailLists.DataSource = lists;
                EmailLists.DataBind();
                EmailListsPanel.Visible = true;
            }
            else
            {
                EmailListsPanel.Visible = false;
            }
        }

        private IList<EmailList> GetPublicEmailLists()
        {
            IList<EmailList> emailLists = new List<EmailList>();
            IList<EmailList> allLists = EmailListDataSource.LoadAll("Name");
            foreach (EmailList list in allLists)
            {
                if (list.IsPublic)
                    emailLists.Add(list);
            }
            return emailLists;
        }

        protected bool IsEmailListChecked(object dataItem)
        {
            User user = AbleContext.Current.User;
            if (user.IsAnonymous) return true;
            EmailList list = (EmailList)dataItem;
            return (list.IsMember(user.Email));
        }

        protected bool HasDescription(object dataItem)
        {
            EmailList list = (EmailList)dataItem;
            return !string.IsNullOrEmpty(list.Description);
        }

        private bool ValidateOrderMinMaxAmounts()
        {
            // IF THE ORDER AMOUNT DOES NOT FALL IN VALID RANGE SPECIFIED BY THE MERCHENT
            OrderItemType[] args = new OrderItemType[] { OrderItemType.Charge, 
                                                    OrderItemType.Coupon, OrderItemType.Credit, OrderItemType.Discount, 
                                                    OrderItemType.GiftCertificate, OrderItemType.GiftWrap, OrderItemType.Handling, 
                                                    OrderItemType.Product, OrderItemType.Shipping, OrderItemType.Tax };
            decimal orderTotal = AbleContext.Current.User.Basket.Items.TotalPrice(args);
            decimal minOrderAmount = _settings.OrderMinimumAmount;
            decimal maxOrderAmount = _settings.OrderMaximumAmount;
            if ((minOrderAmount > orderTotal) || (maxOrderAmount > 0 && maxOrderAmount < orderTotal))
            {
                // REDIRECT TO BASKET PAGE
                Response.Redirect("~/Basket.aspx");
                return true;
            }
            return false;
        }

        public class LocalShipRateQuote
        {
            private int _ShipMethodId;
            private string _Name;
            private string _FormattedRate;
            public int ShipMethodId { get { return _ShipMethodId; } }
            public string Name { get { return _Name; } }
            public string FormattedRate { get { return _FormattedRate; } }
            public LocalShipRateQuote(int shipMethodId, string name, string formattedRate)
            {
                _ShipMethodId = shipMethodId;
                _Name = name;
                _FormattedRate = formattedRate;
            }
            public LocalShipRateQuote(string encodedData)
            {
                string[] values = StringHelper.Split(encodedData, "~~");
                _ShipMethodId = AlwaysConvert.ToInt(values[0]);
                _Name = values[1];
                _FormattedRate = values[2];
            }
            public string Encode()
            {
                return _ShipMethodId.ToString() + "~~" + _Name + "~~" + _FormattedRate;
            }
        }
    }
}