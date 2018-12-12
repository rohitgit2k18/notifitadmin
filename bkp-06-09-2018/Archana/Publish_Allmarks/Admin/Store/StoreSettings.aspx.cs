//-----------------------------------------------------------------------
// <copyright file="StoreSettings.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin._Store
{
    using System;
    using System.Collections;
    using System.Web.UI;
    using System.Linq;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.Search;
    using CommerceBuilder.Services;
    using CommerceBuilder.Users;
    using System.Collections.Generic;
    using CommerceBuilder.Payments;
using CommerceBuilder.Messaging;

    public partial class StoreSettings : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetHtmlEditor(SiteDisclaimerMessage, SiteDisclaimerHtml);
            AbleCommerce.Code.PageHelper.SetHtmlEditor(CheckoutTerms, CheckoutTermsHtml);
        }
        protected void Page_Load(object sender, System.EventArgs e)
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;

            // FULLTEXT SEARCH
            bool ftsIsInstalled = KeywordSearchHelper.IsFullTextSearchInstalled(false);
            bool ftsIsEnabled = false;
            if (ftsIsInstalled)
            {
                ftsIsEnabled = KeywordSearchHelper.IsFullTextSearchEnabled(false);
                if (!ftsIsEnabled)
                {
                    // ATTEMPT TO ENABLE FULLTEXT SEARCH IF POSSIBLE
                    KeywordSearchHelper.EnableFullTextSearch(false);
                    ftsIsEnabled = KeywordSearchHelper.IsFullTextSearchEnabled(false);
                }
            }

            ListItem sqlFtsProviderItem = SearchProvider.Items.FindByValue("SqlFtsSearchProvider");
            if (sqlFtsProviderItem != null && !(ftsIsInstalled && ftsIsEnabled))
            {
                SearchProvider.Items.Remove(sqlFtsProviderItem);
            }

            bool authorizeNetCIMEnabled = PaymentGatewayDataSource.GetPaymentGatewayIdByClassId("CommerceBuilder.Payments.Providers.AuthorizeNetCIM.AuthNetCIMProvider, CommerceBuilder.AuthorizeNetCIM") > 0;
            if (!authorizeNetCIMEnabled)
            {
                tdPaymentStorage.Attributes.Add("class", "inactive");
                PaymentStorageLabel.Text = "Only available with Authorize.Net CIM gateway";
            }

            PaymentStorage.Enabled = authorizeNetCIMEnabled;

            if (!Page.IsPostBack)
            {
                // GENERAL
                StoreName.Text = store.Name;
                if (AbleContext.Current.User.IsSecurityAdmin)
                {
                    StoreUrl.Text = store.StoreUrl;
                    StoreUrlLiteral.Visible = false;
                }
                else
                {
                    StoreUrlLiteral.Text = store.StoreUrl;
                    StoreUrl.Visible = false;
                }
                if (!string.IsNullOrEmpty(settings.SiteDisclaimerMessage))
                {
                    SiteDisclaimerMessage.Text = settings.SiteDisclaimerMessage;
                }

                // VOLUME DISCOUNTS
                DiscountMode.SelectedIndex = (int)store.VolumeDiscountMode;

                // INVENTORY
                EnableInventory.Checked = settings.EnableInventory;
                InventoryPanel.Visible = settings.EnableInventory;
                CurrentInventoryDisplayMode.SelectedIndex = settings.InventoryDisplayDetails ? 1 : 0;
                InStockMessage.Text = settings.InventoryInStockMessage;
                OutOfStockMessage.Text = settings.InventoryOutOfStockMessage;
                InventoryAvailabilityMessage.Text = settings.InventoryAvailabilityMessage;
                RestockNotificationLink.Text = settings.InventoryRestockNotificationLink;

                IList<EmailTemplate> emailTemplates = EmailTemplateDataSource.LoadAll();
                foreach (EmailTemplate template in emailTemplates)
                {
                    RestockNotificationEmail.Items.Add(new ListItem(template.Name, template.Id.ToString()));
                }

                RestockNotificationEmail.ClearSelection();
                ListItem item = RestockNotificationEmail.Items.FindByValue(settings.InventoryRestockNotificationEmailTemplateId.ToString());
                if (item != null) item.Selected = true;

                // ORDER SETTINGS
                UpdateNextOrderNumber(store);

                OrderIdIncrement.Text = store.OrderIdIncrement.ToString();
                OrderMinAmount.Text = (settings.OrderMinimumAmount > 0) ? settings.OrderMinimumAmount.ToString() : string.Empty;
                OrderMaxAmount.Text = (settings.OrderMaximumAmount > 0) ? settings.OrderMaximumAmount.ToString() : string.Empty;                
                EnableOnePageCheckout.Checked = settings.EnableOnePageCheckout;
                
                // GUEST CHECKOUT OPTIONS
                AllowGuestCheckout.Checked = settings.AllowAnonymousCheckout;
                LimitedGuestCheckout.Checked = !settings.AllowAnonymousCheckoutForDigitalGoods && settings.AllowAnonymousCheckout;
                DisableGuestCheckout.Checked = !settings.AllowAnonymousCheckout;

                // CHECKOUT PAYMENT SETTINGS
                AllowOnlyFullPayments.Checked = !settings.AcceptOrdersWithInvalidPayment;
                IgnoreFailedPayments.Checked = settings.AcceptOrdersWithInvalidPayment;
                AllowPartialPaymnets.Checked = settings.EnablePartialPaymentCheckouts && !settings.AcceptOrdersWithInvalidPayment;

                EnableShipMessage.Checked = settings.EnableShipMessage;
                EnableShipToMultipleAddresses.Checked = settings.EnableShipToMultipleAddresses;
                if (!string.IsNullOrEmpty(settings.CheckoutTermsAndConditions))
                {
                    CheckoutTerms.Text = settings.CheckoutTermsAndConditions;
                }

                EnableOrderNotes.Checked = settings.EnableCustomerOrderNotes;

                // UNITS
                WeightUnit.DataSource = EnumToHashtable(typeof(CommerceBuilder.Shipping.WeightUnit));
                WeightUnit.DataTextField = "Key";
                WeightUnit.DataValueField = "Value";
                WeightUnit.DataBind();

                MeasurementUnit.DataSource = EnumToHashtable(typeof(CommerceBuilder.Shipping.MeasurementUnit));
                MeasurementUnit.DataTextField = "Key";
                MeasurementUnit.DataValueField = "Value";
                MeasurementUnit.DataBind();

                item = WeightUnit.Items.FindByValue(store.WeightUnitId.ToString());
                if (item != null) item.Selected = true;
                item = MeasurementUnit.Items.FindByValue(store.MeasurementUnitId.ToString());
                if (item != null) item.Selected = true;
                BindTimeZone();

                PostalCodeCountries.Text = settings.PostalCodeCountries;

                // PRODUCTS PURCHASING
                ProductPurchasingDisabled.Checked = settings.ProductPurchasingDisabled;

                // WISHLISTS ENABLED
                WishlistsEnabled.Checked = settings.WishlistsEnabled;

                // SEARCH SETTINGS
                EnableWishlistSearch.Checked = settings.WishlistSearchEnabled;
                MinimumSearchLength.Text = settings.MinimumSearchLength.ToString();
                PopularSearchThreshold.Text = settings.PopularSearchThreshold.ToString();
                CategorySearchDisplayLimit.Text = settings.CategorySearchDisplayLimit.ToString();

                item = SearchProvider.Items.FindByValue(ApplicationSettings.Instance.SearchProvider);
                if (item != null)
                    item.Selected = true;

                // RESTRICT STORE ACCESS
                ListItem option = RestrictStoreAccessOptions.Items.FindByValue(settings.RestrictStoreAccess.ToString());
                if (option != null) option.Selected = true;


                IList<Group> allGroups = GroupDataSource.LoadForStore(AbleContext.Current.StoreId, "Name ASC");
                IList<Group> nonAdminGroups = allGroups.FindAll(grp => !grp.IsInRole(Role.AllAdminRoles)) as IList<Group>;
                IList<Group> authorizedGroups = allGroups.FindAll(grp => grp.IsInRole(Role.CustomerRoles));
                AuthorizedGroups.DataSource = nonAdminGroups as IList<Group>;
                AuthorizedGroups.DataBind();
                foreach(ListItem groupItem in AuthorizedGroups.Items)
                {
                    int groupId = AlwaysConvert.ToInt(groupItem.Value);
                    foreach (Group group in authorizedGroups)
                    {
                        if (groupId == group.Id) { groupItem.Selected = true; break; }
                    }
                }

                PaymentStorage.Checked = settings.EnablePaymentProfilesStorage;

                EnableHtmlEditor.Checked = settings.EnableWysiwygEditor;
            }
        }

        protected void RestrictStoreAccess_Changed(object sender, EventArgs e)
        {
            // disable the selection of groups if store access is not restricted
            AuthorizedGroups.Attributes.Remove("disabled");
            AccessRestrictionType selectedVal = (AccessRestrictionType)Enum.Parse(typeof(AccessRestrictionType), RestrictStoreAccessOptions.SelectedValue);
            if (selectedVal != AccessRestrictionType.AuthorizedGroupsOnly) AuthorizedGroups.Attributes.Add("disabled", "true");
        }

        protected void EnableInventory_CheckChanged(object sender, EventArgs e)
        {
            InventoryPanel.Visible = EnableInventory.Checked;
        }

        protected Hashtable EnumToHashtable(Type enumType)
        {
            // get the names from the enumeration
            string[] names = Enum.GetNames(enumType);

            // get the values from the enumeration
            Array values = Enum.GetValues(enumType);

            // turn it into a hash table
            Hashtable ht = new Hashtable();
            for (int i = 0; i < names.Length; i++)
            {
                // note the cast to integer here is important
                // otherwise we'll just get the enum string back again
                ht.Add(names[i], (int)values.GetValue(i));
            }

            // return the dictionary to be bound to
            return ht;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            // if admin theme changes we should refresh the page
            // so that the new theme shows up
            SaveSettings();
            SavedMessage.Visible = true;
        }

        protected void BindTimeZone()
        {
            for (int i = -12; i < 13; i++)
            {
                int position = (int)Math.Abs(i);
                double halfSet;
                if (i < 0)
                {
                    halfSet = i - 0.5;
                    if (position < 12) TimeZoneOffset.Items.Add(new ListItem(string.Format("UTC - {0}:30", position), halfSet.ToString()));
                    TimeZoneOffset.Items.Add(new ListItem(string.Format("UTC - {0}", position), i.ToString()));
                }
                else if (i > 0)
                {
                    halfSet = i + 0.5;
                    TimeZoneOffset.Items.Add(new ListItem(string.Format("UTC + {0}", i), i.ToString()));
                    if (position < 12) TimeZoneOffset.Items.Add(new ListItem(string.Format("UTC + {0}:30", i), halfSet.ToString()));
                }
                else
                {
                    TimeZoneOffset.Items.Add(new ListItem("UTC", "0"));
                    TimeZoneOffset.Items.Add(new ListItem("UTC + 0:30", "0.5"));
                }
            }

            // UPDATE SELECTED
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            string tempCode = settings.TimeZoneCode;
            if (!string.IsNullOrEmpty(tempCode))
            {
                ListItem selected = TimeZoneOffset.Items.FindByValue(tempCode);
                if (selected != null) selected.Selected = true;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            int maxOrderId = StoreDataSource.GetMaxOrderNumber();
            int nextOrderId = StoreDataSource.GetNextOrderNumber(false);
            if (maxOrderId >= nextOrderId)
            {
                NextOrderNumberWarning.Text = string.Format(NextOrderNumberWarning.Text, nextOrderId, maxOrderId, (maxOrderId + 1));
            }
            else NextOrderNumberWarning.Visible = false;

            // disable the selection of groups if store access is not restricted
            AuthorizedGroups.Attributes.Remove("disabled");
            AccessRestrictionType selectedVal = (AccessRestrictionType)Enum.Parse(typeof(AccessRestrictionType), RestrictStoreAccessOptions.SelectedValue);
            if (selectedVal != AccessRestrictionType.AuthorizedGroupsOnly) AuthorizedGroups.Attributes.Add("disabled", "true");
        }

        private void UpdateNextOrderNumber(Store store)
        {
            OrigNextOrderNumber.Value = store.NextOrderId.ToString();
            NextOrderNumberRangeValidator1.MinimumValue = (StoreDataSource.GetMaxOrderNumber() + 1).ToString();
            NextOrderNumberRangeValidator1.ErrorMessage = string.Format(NextOrderNumberRangeValidator1.ErrorMessage, NextOrderNumberRangeValidator1.MinimumValue);
            NextOrderId.Text = OrigNextOrderNumber.Value;
            if (store.NextOrderId > 99999999)
            {
                NextOrderIdLabel.Text = OrigNextOrderNumber.Value;
                NextOrderIdLabel.Visible = true;
                NextOrderId.Visible = false;
                NextOrderNumberRangeValidator1.Enabled = false;
                NextOrderNumberRangeValidator1.Visible = false;
            }
        }

        private double GetTimeZoneOffset(string timeZoneCode)
        {
            switch (timeZoneCode)
            {
                case "AST": return -4;
                case "ADT": return -3;
                case "AKST": return -9;
                case "AKDT": return -8;
                case "CST": return -6;
                case "CDT": return -5;
                case "EST": return -5;
                case "EDT": return -4;
                case "HAST": return -10;
                case "HADT": return -9;
                case "MST": return -7;
                case "MDT": return -6;
                case "NST": return -3.5;
                case "NDT": return -2.5;
                case "PST": return -8;
                case "PDT": return -7;
                default: return AlwaysConvert.ToDouble(timeZoneCode);
            }
        }

        private void SaveSettings()
        {
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            store.Name = StoreName.Text;
            store.VolumeDiscountMode = (VolumeDiscountMode)DiscountMode.SelectedIndex;
            store.WeightUnit = (WeightUnit)AlwaysConvert.ToInt(WeightUnit.SelectedValue);
            store.MeasurementUnit = (MeasurementUnit)AlwaysConvert.ToInt(MeasurementUnit.SelectedValue);
            settings.TimeZoneCode = TimeZoneOffset.SelectedValue;
            settings.TimeZoneOffset = GetTimeZoneOffset(TimeZoneOffset.SelectedValue);
            settings.PostalCodeCountries = PostalCodeCountries.Text.Replace(" ", string.Empty);
            settings.SiteDisclaimerMessage = SiteDisclaimerMessage.Text.Trim();

            // INVENTORY        
            store.Settings.EnableInventory = EnableInventory.Checked;
            settings.InventoryDisplayDetails = CurrentInventoryDisplayMode.SelectedIndex == 1;
            settings.InventoryInStockMessage = InStockMessage.Text;
            settings.InventoryOutOfStockMessage = OutOfStockMessage.Text;
            settings.InventoryAvailabilityMessage = InventoryAvailabilityMessage.Text;
            settings.InventoryRestockNotificationLink = RestockNotificationLink.Text;
            settings.InventoryRestockNotificationEmailTemplateId = AlwaysConvert.ToInt(RestockNotificationEmail.SelectedValue);

            // ORDERS        
            short increment = AlwaysConvert.ToInt16(OrderIdIncrement.Text);
            if (increment >= 1) store.OrderIdIncrement = increment;
            settings.CheckoutTermsAndConditions = CheckoutTerms.Text.Trim();
            settings.OrderMinimumAmount = AlwaysConvert.ToDecimal(OrderMinAmount.Text);
            settings.OrderMaximumAmount = AlwaysConvert.ToDecimal(OrderMaxAmount.Text);
            settings.AcceptOrdersWithInvalidPayment = IgnoreFailedPayments.Checked;
            settings.EnablePartialPaymentCheckouts = AllowPartialPaymnets.Checked;

            settings.EnableOnePageCheckout = EnableOnePageCheckout.Checked;
            settings.AllowAnonymousCheckout = AllowGuestCheckout.Checked || LimitedGuestCheckout.Checked;
            settings.AllowAnonymousCheckoutForDigitalGoods = !LimitedGuestCheckout.Checked;
            settings.EnableCustomerOrderNotes = EnableOrderNotes.Checked;
            settings.EnableShipMessage = EnableShipMessage.Checked;
            settings.EnableShipToMultipleAddresses = EnableShipToMultipleAddresses.Checked;

            // PRODUCTS PURCHASING
            settings.ProductPurchasingDisabled = ProductPurchasingDisabled.Checked;

            // WISHLISTS ENABLED
            settings.WishlistsEnabled = WishlistsEnabled.Checked;

            // RESTRICT STORE ACCESS
            settings.RestrictStoreAccess = (AccessRestrictionType)Enum.Parse(typeof(AccessRestrictionType), RestrictStoreAccessOptions.SelectedValue);
            if (settings.RestrictStoreAccess == AccessRestrictionType.AuthorizedGroupsOnly)
            {
                IList<Group> allGroups = GroupDataSource.LoadForStore(AbleContext.Current.StoreId, "Name ASC");
                IList<Group> nonAdminGroups = allGroups.FindAll(grp => !grp.IsInRole(Role.AllAdminRoles)) as IList<Group>;

                // remove permissions for all non-admin groups
                Role authorizedUserRole = RoleDataSource.LoadForRolename(Role.CustomerRoles[0]);
                foreach (Group group in nonAdminGroups) group.Roles.Remove(authorizedUserRole);
                foreach (ListItem item in AuthorizedGroups.Items)
                {
                    if (item.Selected)
                    {
                        int groupId = AlwaysConvert.ToInt(item.Value);
                        foreach (Group group in nonAdminGroups)
                        {
                            // add permissions for selected groups
                            if (groupId == group.Id) group.Roles.Add(authorizedUserRole);
                        }
                    }
                }
                nonAdminGroups.Save();
            }

            // SEARCH SETTINGS
            settings.WishlistSearchEnabled = EnableWishlistSearch.Checked;
            settings.MinimumSearchLength = AlwaysConvert.ToInt(MinimumSearchLength.Text);
            settings.PopularSearchThreshold = AlwaysConvert.ToInt(PopularSearchThreshold.Text);
            settings.CategorySearchDisplayLimit = AlwaysConvert.ToInt(CategorySearchDisplayLimit.Text);
            settings.EnablePaymentProfilesStorage = PaymentStorage.Checked;

            // HTML EDITOR SETTING
            settings.EnableWysiwygEditor = EnableHtmlEditor.Checked;

            store.Save();

            // CHECK NEXT ORDER NUMBER
            if (OrigNextOrderNumber.Value != NextOrderId.Text)
            {
                // NEXT ORDER NUMBER WAS UPDATED
                store.NextOrderId = StoreDataSource.SetNextOrderNumber(AlwaysConvert.ToInt(NextOrderId.Text));
                OrigNextOrderNumber.Value = store.NextOrderId.ToString();
            }
            else
            {
                // DETERMINE CORRECT VALUE FOR NEXT ORDER NUMBER
                OrigNextOrderNumber.Value = StoreDataSource.GetNextOrderNumber(false).ToString();
            }
            OrderIdIncrement.Text = store.OrderIdIncrement.ToString();
            UpdateNextOrderNumber(store);
            store.Save();

            if (SearchProvider.SelectedValue != ApplicationSettings.Instance.SearchProvider)
            {
                ApplicationSettings.Instance.SearchProvider = SearchProvider.SelectedValue;
                ApplicationSettings.Instance.Save();

                if (SearchProvider.SelectedValue == "SqlFtsSearchProvider")
                {
                    bool fullTextSearch = false;
                    // FTS IS TURNED ON, MAKE SURE THE CATALOG IS AVAILABLE
                    if (KeywordSearchHelper.EnsureCatalog())
                    {
                        // CATALOG IS FOUND, MAKE SURE INDEXES ARE AVAILABLE
                        if (KeywordSearchHelper.EnsureIndexes())
                        {
                            // FTS CAN BE SAFELY ENABLED
                            fullTextSearch = true;
                        }
                    }

                    if (!fullTextSearch) KeywordSearchHelper.RemoveCatalog();
                }

                if (SearchProvider.SelectedValue == "LuceneSearchProvider")
                {
                    AbleContext.Resolve<IFullTextSearchService>().AsyncReindex();
                }
            }
        }

        protected void SearchProvider_SelectedIndexChanged(object sender, EventArgs e)
        {
            trReindexingMessage.Visible = SearchProvider.SelectedValue == "LuceneSearchProvider";
        }
    }
}