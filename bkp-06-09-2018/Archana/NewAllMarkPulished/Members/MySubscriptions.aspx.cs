namespace AbleCommerce.Members
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.ConLib.Account;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Products;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Linq;
    using CommerceBuilder.Messaging;
    using AbleCommerce.Code;

    public partial class MySubscriptions : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_Load(object sender, EventArgs e) 
        {
            if (!Page.IsPostBack)
            {
                var col = SubscriptionGrid.Columns[7];
                if (col != null)
                    col.Visible = AbleContext.Current.Store.Settings.ROCreateNewOrdersEnabled;

                // POPULATE EXPIRATON DATE DROPDOWN
                int thisYear = LocaleHelper.LocalNow.Year;
                for (int i = 0; (i <= 10); i++)
                {
                    ExpirationYear.Items.Add(new ListItem((thisYear + i).ToString()));
                }
            } 
        }

        protected void SubscriptionGrid_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // POPULATE VALUES FOR DELIVERY FREQUENCY
                DropDownList AutoDeliveryInterval = e.Row.FindControl("AutoDeliveryInterval") as DropDownList;
                LinkButton saveButton = e.Row.FindControl("SaveButton") as LinkButton;
                Subscription subscription = e.Row.DataItem as Subscription;
                Product product = subscription.Product;
                PaymentFrequencyUnit unit = product.SubscriptionPlan.PaymentFrequencyUnit;
                if (!string.IsNullOrEmpty(product.SubscriptionPlan.OptionalPaymentFrequencies))
                {
                    string[] frequencyValues = product.SubscriptionPlan.OptionalPaymentFrequencies.Split(',');
                    if (AutoDeliveryInterval != null && subscription != null)
                    {
                        AutoDeliveryInterval.Items.Clear();
                        AutoDeliveryInterval.Items.Add(new ListItem());
                        if (frequencyValues != null && frequencyValues.Length > 0)
                        {
                            foreach (string val in frequencyValues)
                            {
                                var frequencyValue = AlwaysConvert.ToInt(val);
                                if (frequencyValue > 0)
                                {
                                    string text = string.Format("{0} {1}{2}", frequencyValue, unit, frequencyValue > 1 ? "s" : string.Empty);
                                    AutoDeliveryInterval.Items.Add(new ListItem(text, frequencyValue.ToString()));
                                }
                            }
                        }

                        ListItem item = AutoDeliveryInterval.Items.FindByValue(subscription.PaymentFrequency.ToString());
                        if (item != null) item.Selected = true;
                    }

                    if (saveButton != null)
                        saveButton.Visible = true;
                }
                else
                {
                    Label NoFrequency = e.Row.FindControl("NoFrequency") as Label;
                    if (NoFrequency != null)
                    {
                        if (subscription.PaymentFrequency.HasValue && subscription.PaymentFrequencyUnit.HasValue)
                            NoFrequency.Text = string.Format("{0} {1}{2}", subscription.PaymentFrequency, subscription.PaymentFrequencyUnit, subscription.PaymentFrequency > 1 ? "s" : string.Empty);
                        NoFrequency.Visible = true;
                    }
                    if (AutoDeliveryInterval != null) AutoDeliveryInterval.Visible = false;
                    if(saveButton != null)
                        saveButton.Visible = false;
                }

                Label DeliveryFrequencyLabel = e.Row.FindControl("DeliveryFrequencyLabel") as Label;
                Label AutoDeliveryDescription = e.Row.FindControl("AutoDeliveryDescription") as Label;
                if (subscription.PaymentFrequency.HasValue && subscription.PaymentFrequencyUnit.HasValue)
                {
                    unit = subscription.PaymentFrequencyUnit.Value;
                    DeliveryFrequencyLabel = e.Row.FindControl("DeliveryFrequencyLabel") as Label;
                    if (DeliveryFrequencyLabel != null) DeliveryFrequencyLabel.Text = string.Format("{0} {1}{2}", subscription.PaymentFrequency, unit, subscription.PaymentFrequency > 1 ? "s" : string.Empty);

                    AutoDeliveryDescription = e.Row.FindControl("AutoDeliveryDescription") as Label;
                    if (AutoDeliveryDescription != null && subscription.SubscriptionPlan.IsRecurring)
                        AutoDeliveryDescription.Text = string.Format("Recurring payment amount {0}", subscription.RecurringChargeEx.LSCurrencyFormat("ulc"));
                }
                else 
                {
                    if (DeliveryFrequencyLabel != null) DeliveryFrequencyLabel.Text = "N/A";
                    if (AutoDeliveryDescription != null) AutoDeliveryDescription.Text = string.Empty;
                }

                if (Page.IsPostBack && SubscriptionGrid.EditIndex >= 0 && e.Row.RowIndex == SubscriptionGrid.EditIndex)
                {
                     AddEditableInformation(e);
                }
            }
        }

        private void AddEditableInformation(GridViewRowEventArgs e)
        {
            Subscription subscription = e.Row.DataItem as Subscription;

            EditSubscriptionDetails control = LoadControl("~/ConLib/Account/EditSubscriptionDetails.ascx") as EditSubscriptionDetails;
            control.ID = "EditSubscriptionDetails";
            control.SubscriptionId = subscription.Id;
            control.OnEditShipAddress += new EditShipAddressEventHandler(control_OnEditShipAddress);
            control.OnEditBillAddress += new EditBillAddressEventHandler(control_OnEditBillAddress);
            control.OnEditCardInfo += new EditCardInfoEventHandler(control_OnEditCardInfo);
            
            // CREATE A NEW TABLE ROW
            Table table = e.Row.Parent as Table;
            GridViewRow row = new GridViewRow(e.Row.RowIndex + 1, -1, DataControlRowType.EmptyDataRow, DataControlRowState.Normal);
            row.CssClass = e.Row.CssClass;
            TableCell column = new TableCell();
            column.ColumnSpan = SubscriptionGrid.Columns.Count;
            column.Controls.Add(control);
            row.Cells.Add(column);
            table.Rows.Add(row);
        }

        void control_OnEditShipAddress(object sender, SubscriptionDetailEventArgs e)
        {
            Subscription subscription = SubscriptionDataSource.Load(e.SubscriptionId);
            if (subscription != null)
            {
                HiddenSubscriptionId.Value = subscription.Id.ToString();
                EditCaption.Visible = true;
                EditBillingCaption.Visible = false;
                HiddenIsShipping.Value = "True";
                trIsBusiness.Visible = true;
                InitAddressForm(subscription.GetShippingAddress());
                EditAddressPopup.Show();
            }
            else HiddenSubscriptionId.Value = string.Empty;
        }

        void control_OnEditBillAddress(object sender, SubscriptionDetailEventArgs e)
        {
            Subscription subscription = SubscriptionDataSource.Load(e.SubscriptionId);
            if (subscription != null)
            {
                HiddenSubscriptionId.Value = subscription.Id.ToString();
                EditCaption.Visible = false;
                EditBillingCaption.Visible = true;
                HiddenIsShipping.Value = "False";
                trIsBusiness.Visible = false;
                InitAddressForm(subscription.GetBillingAddress());
                EditAddressPopup.Show();
            }
            else HiddenSubscriptionId.Value = string.Empty;
        }

        void control_OnEditCardInfo(object sender, CardInfoDetailEventArgs e)
        {
            GatewayPaymentProfile profile = GatewayPaymentProfileDataSource.Load(e.ProfileId);
            if (profile != null)
            {
                HiddenProfileId.Value = profile.Id.ToString();
                NameOnCardLabel.Text = string.Format("{0}", profile.NameOnCard);
                ReferenceLabel.Text = string.Format("Profile {0} ending in {1}", profile.InstrumentType, profile.ReferenceNumber);

                string profileExpiry = profile.Expiry.ToString();
                string[] dateParts = profileExpiry.Split('/');
                string expiryMonth = (dateParts[0].Length == 1) ? "0" + dateParts[0] : dateParts[0];
                string expiryDay = dateParts[1];
                string expiryYear =  dateParts[2].Substring(0, 4);

                ListItem selectedYear = ExpirationYear.Items.FindByValue(expiryYear);
                if (selectedYear != null)
                {
                    ExpirationYear.ClearSelection();
                    selectedYear.Selected = true;
                }

                ListItem selectedMonth = ExpirationMonth.Items.FindByValue(expiryMonth);
                if (selectedMonth != null)
                {
                    ExpirationMonth.ClearSelection();
                    selectedMonth.Selected = true;
                }

                EditCardInfoPopUp.Show();
            }
            else HiddenProfileId.Value = string.Empty;
        }

        protected void SubscriptionGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            SubscriptionGrid.EditIndex = e.NewEditIndex;
            SubscriptionGrid.DataBind();
        }

        protected void SubscriptionGrid_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            SubscriptionGrid.EditIndex = -1;
            SubscriptionGrid.DataBind();
        }

        protected void SubscriptionGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int subscriptionId = AlwaysConvert.ToInt(e.CommandArgument);
            Subscription subscription = SubscriptionDataSource.Load(subscriptionId);
            switch (e.CommandName)
            {
                case "CancelSubscription":
                    subscription.Delete();
                    SubscriptionGrid.DataBind();
                    break;
            }
        }

        protected void SubscriptionGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = SubscriptionGrid.Rows[e.RowIndex];
            
            int subscriptionId = (int)SubscriptionGrid.DataKeys[e.RowIndex].Value;
            Subscription subscription = SubscriptionDataSource.Load(subscriptionId);
            if (subscription != null)
            {   
                DropDownList AutoDeliveryInterval = row.FindControl("AutoDeliveryInterval") as DropDownList;
                if (AutoDeliveryInterval != null && !string.IsNullOrEmpty(AutoDeliveryInterval.SelectedValue))
                {
                    subscription.PaymentFrequency = AlwaysConvert.ToInt16(AutoDeliveryInterval.SelectedValue);
                    subscription.RecalculateNextOrderDueDate();
                    subscription.RecalculateExpiration();

                    try
                    {
                        EmailProcessor.NotifySubscriptionUpdated(subscription);
                    }
                    catch (Exception ex)
                    {
                        Logger.Error("Error sending subscription updated email.", ex);
                    }

                    subscription.Save();
                }
            }

            SubscriptionGrid.EditIndex = -1;
            e.Cancel = true;
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("MySubscriptions.aspx");
        }

        protected void AutoDeliveryInterval_Changed(object sender, EventArgs e)
        {
            GridViewRow gvr = (GridViewRow)(((Control)sender).NamingContainer);
            DropDownList AutoDeliveryInterval = (DropDownList)gvr.FindControl("AutoDeliveryInterval");
            var dataItem = gvr.DataItem;
        }

        protected void SubscriptionDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["userId"] = AbleContext.Current.UserId;
        }

        protected string GetNextOrderDate(object o)
        {
            Subscription subscription = o as Subscription;
            DateTime nextOrderDate = subscription.NextOrderDateForDisplay;
            if (nextOrderDate != DateTime.MinValue)
                return string.Format("{0:d}", nextOrderDate);
            return "N/A";
        }

        protected string GetExpiration(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription != null && subscription.ExpirationDate.HasValue && subscription.ExpirationDate != DateTime.MinValue && subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year)
                return string.Format("{0:d}", subscription.ExpirationDate);
            return "N/A";
        }

        protected bool CanChangeSubscription(object o)
        {
            Subscription subscription = o as Subscription;
            if (!subscription.IsActive && !subscription.IsLegacy) return true;
            int daysToChangeSubscription = AbleContext.Current.Store.Settings.ROSubscriptionChangesDays;

            if (subscription.PaymentFrequencyUnit.HasValue && subscription.PaymentFrequency.HasValue && daysToChangeSubscription > 0)
            {
                DateTime? nextRenewalDate = subscription.NextOrderDueDate;  
                return nextRenewalDate > LocaleHelper.LocalNow.AddDays(daysToChangeSubscription);
            }
            return false;
        }

        protected bool CanCancelSubscription(object o)
        {
            Subscription subscription = o as Subscription;
            if (!subscription.IsActive) return true;
            int daysToCancelSubscription = AbleContext.Current.Store.Settings.ROSubscriptionCancellationDays;

            if (subscription.PaymentFrequencyUnit.HasValue && subscription.PaymentFrequency.HasValue && daysToCancelSubscription > 0)
            {
                DateTime? nextRenewalDate = subscription.NextOrderDueDate;
                return nextRenewalDate > LocaleHelper.LocalNow.AddDays(daysToCancelSubscription);
            }
            return false;
        }

        protected string GetIsActive(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription.IsActive) return "YES";
            else return "NO";
        }

        protected string GetExpirationDate(object o)
        {
            Subscription subscription = o as Subscription;
            if (subscription.ExpirationDate.HasValue && subscription.ExpirationDate.Value > DateTime.MinValue && subscription.ExpirationDate.Value.Year != DateTime.MaxValue.Year)
                return string.Format("{0:d}", subscription.ExpirationDate);
            else return "N/A";
        }

        protected void SaveAddressButton_Click(object sender, EventArgs e)
        {
            Subscription subscription = SubscriptionDataSource.Load(AlwaysConvert.ToInt(HiddenSubscriptionId.Value));
            bool isShippingAddress = AlwaysConvert.ToBool(HiddenIsShipping.Value, false);
            if (Page.IsValid && subscription != null)
            {
                string buttonId = ((Button)sender).ID;
                string formattedProvinceName;
                if (ValidateProvince(Country, Province, Province2, out formattedProvinceName))
                {
                    string address1 = StringHelper.StripHtml(Address1.Text);
                    string address2 = StringHelper.StripHtml(Address2.Text);
                    string city = StringHelper.StripHtml(City.Text);
                    string postalCode = StringHelper.StripHtml(PostalCode.Text);

                    if (isShippingAddress)
                    {
                        subscription.ShipToFirstName = StringHelper.StripHtml(FirstName.Text);
                        subscription.ShipToLastName = StringHelper.StripHtml(LastName.Text);
                        subscription.ShipToAddress1 = address1;
                        subscription.ShipToAddress2 = address2;
                        subscription.ShipToCompany = StringHelper.StripHtml(Company.Text);
                        subscription.ShipToCity = city;
                        subscription.ShipToProvince = formattedProvinceName;
                        subscription.ShipToPostalCode = postalCode;
                        subscription.ShipToCountryCode = Country.SelectedValue;
                        subscription.ShipToPhone = StringHelper.StripHtml(Phone.Text);
                        subscription.ShipToFax = StringHelper.StripHtml(Fax.Text);
                        subscription.ShipToResidence = !IsBusiness.Checked;

                        try
                        {
                            EmailProcessor.NotifySubscriptionUpdated(subscription);
                        }
                        catch (Exception ex)
                        {
                            Logger.Error("Error sending subscription updated email.", ex);
                        }

                        subscription.Save();
                    }
                    else
                    {
                        subscription.BillToFirstName = StringHelper.StripHtml(FirstName.Text);
                        subscription.BillToLastName = StringHelper.StripHtml(LastName.Text);
                        subscription.BillToAddress1 = address1;
                        subscription.BillToAddress2 = address2;
                        subscription.BillToCompany = StringHelper.StripHtml(Company.Text);
                        subscription.BillToCity = city;
                        subscription.BillToProvince = formattedProvinceName;
                        subscription.BillToPostalCode = postalCode;
                        subscription.BillToCountryCode = Country.SelectedValue;
                        subscription.BillToPhone = StringHelper.StripHtml(Phone.Text);
                        subscription.BillToFax = StringHelper.StripHtml(Fax.Text);
                        subscription.BillToResidence = !IsBusiness.Checked;

                        try
                        {
                            EmailProcessor.NotifySubscriptionUpdated(subscription);
                        }
                        catch (Exception ex)
                        {
                            Logger.Error("Error sending subscription updated email.", ex);
                        }

                        subscription.Save();
                    }

                    //REBUILD ADDRESS BOOK
                    InitAddressForm(null);
                    EditAddressPopup.Hide();
                }
                else
                {
                    Province2Required.IsValid = false;
                    CountryChanged(null, null);
                }
            }
        }

        protected void InitAddressForm(Address address)
        {
            Country.DataBind();
            string newCountryCode;
            if (address == null)
            {
                FirstName.Text = string.Empty;
                LastName.Text = string.Empty;
                Company.Text = string.Empty;
                Address1.Text = string.Empty;
                Address2.Text = string.Empty;
                City.Text = string.Empty;
                Province.Text = string.Empty;
                PostalCode.Text = string.Empty;
                Phone.Text = string.Empty;
                Fax.Text = string.Empty;
                IsBusiness.Checked = false;
                newCountryCode = GetDefaultCountryCode();
            }
            else
            {
                FirstName.Text = address.FirstName;
                LastName.Text = address.LastName;
                Company.Text = address.Company;
                Address1.Text = address.Address1;
                Address2.Text = address.Address2;
                City.Text = address.City;
                Province.Text = address.Province;
                PostalCode.Text = address.PostalCode;
                Phone.Text = address.Phone;
                Fax.Text = address.Fax;
                IsBusiness.Checked = !address.Residence;
                if (string.IsNullOrEmpty(address.CountryCode))
                    address.CountryCode = AbleContext.Current.Store.DefaultWarehouse.CountryCode;
                newCountryCode = address.CountryCode;
            }
            ListItem defaultCountry = Country.Items.FindByValue(newCountryCode);
            if (defaultCountry != null) Country.SelectedIndex = Country.Items.IndexOf(defaultCountry);
            CountryChanged(null, null);
        }
        
        protected void CountryChanged(object sender, EventArgs e)
        {
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            PostalCodeRequired.Enabled = (Array.IndexOf(countries, Country.SelectedValue) > -1);
            USPostalCodeRequired.Enabled = (Country.SelectedValue == "US");
            CAPostalCodeRequired.Enabled = (Country.SelectedValue == "CA");
            //LOAD PROVINCES FOR SELECTED COUNTRY
            IList<Province> provinces = ProvinceDataSource.LoadForCountry(Country.SelectedValue, "Name");
            //WE WANT TO SHOW THE DROP DOWN IF THE COUNTRY HAS BEEN CHANGED BY THE CLIENT
            //AND ALSO IF PROVINCES ARE AVAILABLE FOR THIS COUNTRY
            if (provinces.Count > 0)
            {
                Province.Visible = false;
                ProvinceRequired.Enabled = false;
                Province2.Visible = true;
                Province2.Items.Clear();
                Province2.Items.Add(string.Empty);
                foreach (Province province in provinces)
                {
                    string provinceValue = (!string.IsNullOrEmpty(province.ProvinceCode) ? province.ProvinceCode : province.Name);
                    Province2.Items.Add(new ListItem(province.Name, provinceValue));
                }
                ListItem selectedProvince = Province2.Items.FindByValue(Province.Text);
                if (selectedProvince != null) selectedProvince.Selected = true;
                Province2Required.Enabled = true;
            }
            else
            {
                //WE ONLY WANT A TEXTBOX TO SHOW
                //REQUIRE THE TEXTBOX IF THERE ARE PROVINCES
                Province.Visible = true;
                ProvinceRequired.Enabled = (provinces.Count > 0);
                Province.Visible = true;
                Province2.Visible = false;
                Province2.Items.Clear();
                Province2Required.Enabled = false;
                //NOW THAT A TEXTBOX IS SHOWN, RESET THE FLAG TO DISPLAY DROPDOWN
                // _ShowProvinceList = false;
            }
            EditAddressPopup.Show();
            //UPDATE THE LAST SELECTED COUNTRY
            //_SelectedCountryCode = Country.SelectedValue;
        }

        private bool IsAddressValid(Address address)
        {
            if (string.IsNullOrEmpty(address.FirstName)) return false;
            if (string.IsNullOrEmpty(address.LastName)) return false;
            if (string.IsNullOrEmpty(address.Address1)) return false;
            if (string.IsNullOrEmpty(address.City)) return false;
            if (string.IsNullOrEmpty(address.CountryCode)) return false;
            //SEE WHETHER POSTAL CODE IS REQUIRED
            string[] countries = AbleContext.Current.Store.Settings.PostalCodeCountries.Split(",".ToCharArray());
            bool requirePostalCode = (Array.IndexOf(countries, address.CountryCode) > -1);
            if (requirePostalCode)
            {
                if (string.IsNullOrEmpty(address.PostalCode)) return false;
                if ((address.CountryCode == "US") && (!Regex.IsMatch(address.PostalCode, "^\\d{5}(-\\d{4})?$"))) return false;
                if ((address.CountryCode == "CA") && (!Regex.IsMatch(address.PostalCode, "^[A-Za-z][0-9][A-Za-z] ?[0-9][A-Za-z][0-9]$"))) return false;
            }
            //SEE WHETHER PROVINCE IS VALID
            if (ProvinceDataSource.CountForCountry(address.CountryCode) > 0)
            {
                int provinceId = ProvinceDataSource.GetProvinceIdByName(address.CountryCode, address.Province);
                if (provinceId == 0) return false;
            }
            return true;
        }

        /// <summary>
        /// Validates the current province value
        /// </summary>
        /// <returns></returns>
        private bool ValidateProvince(DropDownList CountryList, TextBox ProvinceText, DropDownList ProvinceList, out string provinceName)
        {
            provinceName = StringHelper.StripHtml(Request.Form[ProvinceText.UniqueID]);
            if (string.IsNullOrEmpty(provinceName)) provinceName = Request.Form[ProvinceList.UniqueID];
            string countryCode = CountryList.SelectedValue;
            if (ProvinceDataSource.CountForCountry(countryCode) == 0) return true;
            //CHECK THE VALUE
            int provinceId = ProvinceDataSource.GetProvinceIdByName(countryCode, provinceName);
            if (provinceId > 0)
            {
                //UPDATE VALUE
                Province p = ProvinceDataSource.Load(provinceId);
                if (p.ProvinceCode.Length > 0) provinceName = p.ProvinceCode;
                else provinceName = p.Name;
            }
            return (provinceId > 0);
        }

        private string GetDefaultCountryCode()
        {
            string defaultCountry = AbleContext.Current.User.PrimaryAddress.CountryCode;
            if (!string.IsNullOrEmpty(defaultCountry)) return defaultCountry;
            return AbleContext.Current.Store.DefaultWarehouse.CountryCode;
        }

        private class AddressComparer : IComparer, IComparer<Address>
        {
            private int _PrimaryAddressId;
            public AddressComparer(int primaryAddressId)
            {
                _PrimaryAddressId = primaryAddressId;
            }
            public int Compare(object x, object y)
            {
                return this.Compare(x as Address, y as Address);
            }
            public int Compare(Address x, Address y)
            {
                if (x.Id == y.Id) return 0;
                if (x.Id == _PrimaryAddressId) return -1;
                if (y.Id == _PrimaryAddressId) return 1;
                string nX = (string.IsNullOrEmpty(x.Company) ? string.Empty : x.Company + " ") + x.FullName;
                string nY = (string.IsNullOrEmpty(y.Company) ? string.Empty : y.Company + " ") + y.FullName;
                return string.Compare(nX, nY);
            }
        }

        protected void SaveCardButton_Click(object sender, EventArgs e)
        {
            int profileId = AlwaysConvert.ToInt(HiddenProfileId.Value);
            Label ProfileSuccessMessage = (Label)PageHelper.RecursiveFindControl(Page, "ProfileSuccessMessage");
            Label ProfileErrorMessage = (Label)PageHelper.RecursiveFindControl(Page, "ProfileErrorMessage");
            if (profileId > 0)
            {
                var profile = GatewayPaymentProfileDataSource.Load(profileId);
                if (profile != null)
                {
                    int gatewayId = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId(profile.GatewayIdentifier);
                    PaymentGateway gateway = PaymentGatewayDataSource.Load(gatewayId);

                    if (gateway != null)
                    {
                        var provider = gateway.GetInstance();
                        try
                        {
                            AccountDataDictionary cardDetails = new AccountDataDictionary();
                            cardDetails["AccountNumber"] = "XXX" + profile.ReferenceNumber.Replace("x", "X");
                            cardDetails["ExpirationMonth"] = ExpirationMonth.SelectedItem.Value;
                            cardDetails["ExpirationYear"] = ExpirationYear.SelectedItem.Value;
                            cardDetails["SecurityCode"] = SecurityCode.Text.Trim();
                            PaymentMethod method = PaymentMethodDataSource.Load(profile.InstrumentTypeId);
                            PaymentInstrumentData instr = PaymentInstrumentData.CreateInstance(cardDetails, method.PaymentInstrumentType, null);
                            var rsp = provider.DoUpdatePaymentProfile(new CommerceBuilder.Payments.Providers.UpdatePaymentProfileRequest(AbleContext.Current.User, instr, profile.CustomerProfileId, profile.PaymentProfileId));
                            if (rsp.Successful || rsp.ResponseCode == "E00040")
                            {
                                int id = profile.Id;
                                profile.Expiry = Misc.GetStartOfDate(new DateTime(AlwaysConvert.ToInt(ExpirationYear.SelectedItem.Value), AlwaysConvert.ToInt(ExpirationMonth.SelectedItem.Value), 1));
                                profile.Save();
                                if(ProfileSuccessMessage != null)
                                {
                                    ProfileSuccessMessage.Text = string.Format("Profile '{0} ending in {1}' updated successfully!", profile.InstrumentType, profile.ReferenceNumber);
                                    ProfileSuccessMessage.Visible = true;
                                    ProfileErrorMessage.Visible = false;
                                }
                            }
                            else
                            {
                                if (ProfileErrorMessage != null)
                                {
                                    ProfileErrorMessage.Text = string.Format("Somthing went wrong! Unable to update profile '{0} ending in {1}'", profile.InstrumentType, profile.ReferenceNumber);
                                    ProfileSuccessMessage.Visible = false;
                                    ProfileErrorMessage.Visible = true;
                                }
                                
                                Logger.Error(rsp.ResponseMessage);
                            }
                        }
                        catch (Exception exp)
                        {
                            Logger.Error(exp.Message);
                        }
                    }
                }
            }
            EditCardInfoPopUp.Hide();
        }
    }
}