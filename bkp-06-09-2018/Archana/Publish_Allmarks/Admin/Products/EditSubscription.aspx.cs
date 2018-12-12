namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Orders;

    public partial class EditSubscription : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            if (_Product.SubscriptionPlan != null)
            {
                SubscriptionsLink.Visible = true;
                SubscriptionsLink.NavigateUrl = Page.ResolveUrl(string.Format("~/Admin/People/Subscriptions/Default.aspx?PlanId={0}", _Product.SubscriptionPlan.Id));
            }
            else
                SubscriptionsLink.Visible = false;
        }

        protected void Page_PreRender(object sender, EventArgs e) 
        {
            decimal price = _Product.Price;
            BillingOption.Items[0].Text = string.Format("One-time charge of {0}", "<b>" + price.LSCurrencyFormat("lc") + "</b>");
            BillingOption.Items[1].Text = string.Format("Recurring charge of {0}", "<b>" + price.LSCurrencyFormat("lc") + "</b>");
            BillingOption.Items[2].Text = string.Format("Initial charge of {0} with recurring charge", "<b>" + price.LSCurrencyFormat("lc") + "</b>");
            OneTimePriceLabel2.Text = string.Format(OneTimePriceLabel2.Text, "<b>" + price.LSCurrencyFormat("lc") + "</b>");
            RecurringChargeLabel2.Text = string.Format(RecurringChargeLabel2.Text, "<b>" + price.LSCurrencyFormat("lc") + "</b>");

            if (_Product.SubscriptionPlan != null)
            {
                ShowEditForm();
            }
        }

        private void BindSubscriptionGroup()
        {
            SubscriptionGroup.Items.Clear();
            SubscriptionGroup.Items.Add(new ListItem(string.Empty));
            IList<CommerceBuilder.Users.Group> groupCol = GroupDataSource.LoadAll("Name");

            CommerceBuilder.Users.Group group;
            for (int i = groupCol.Count - 1; i >= 0; i--)
            {
                group = groupCol[i];
                if (group.Roles.Count > 0 && group.IsInRole(Role.AllAdminRoles) || Group.DefaultUserGroupName.Equals(group.Name))
                {
                    groupCol.RemoveAt(i);
                }
            }

            SubscriptionGroup.DataSource = groupCol;
            SubscriptionGroup.DataBind();
        }

        protected void ShowAddForm_Click(object sender, EventArgs e)
        {
            NoSubscriptionPlanPanel.Visible = false;
            SubscriptionPlanForm.Visible = true;
            Name.Text = _Product.Name;

            decimal price = _Product.Price;
            BillingOption.Items[0].Text = string.Format("One-time charge of {0}", price.LSCurrencyFormat("lc"));
            BillingOption.Items[1].Text = string.Format("Recurring charge of {0}", price.LSCurrencyFormat("lc"));
            BillingOption.Items[2].Text = string.Format("Initial charge of {0} with recurring charge", price.LSCurrencyFormat("lc"));
            BillingOption.SelectedIndex = 0;
            UpdateBillingOption();

            AddSubscriptionPlanButtons.Visible = true;
            EditSubscriptionPlanButtons.Visible = false;
        }

        private void ShowNoForm()
        {
            NoSubscriptionPlanPanel.Visible = true;
            SubscriptionPlanForm.Visible = false;
            AddSubscriptionPlanButtons.Visible = false;
            EditSubscriptionPlanButtons.Visible = false;
            SubscriptionsLink.Visible = false;
        }

        private void ShowEditForm()
        {
            NoSubscriptionPlanPanel.Visible = false;
            SubscriptionPlanForm.Visible = true;
            AddSubscriptionPlanButtons.Visible = false;
            EditSubscriptionPlanButtons.Visible = true;
            if (!Page.IsPostBack)
            {
                //INITIALIZE FORM
                SubscriptionPlan sp = _Product.SubscriptionPlan;
                Name.Text = sp.Name;
                //DETERMINE BILLING OPTION
                if (sp.NumberOfPayments == 1)
                    //ONETIME CHARGE
                    BillingOption.SelectedIndex = 0;
                else if (!sp.RecurringChargeSpecified)
                    //RECURRING USING INITIAL PAYMENT AMOUNT
                    BillingOption.SelectedIndex = 1;
                else
                    //RECURING WITH INITIAL PAYMENT AND SEPARATE RECURRING AMOUNT
                    BillingOption.SelectedIndex = 2;
                UpdateBillingOption();

                if (sp.PaymentFrequencyType == CommerceBuilder.Products.PaymentFrequencyType.Fixed)
                {
                    if (sp.PaymentFrequency > 0)
                        FixedPaymentFrequency.Text = sp.PaymentFrequency.ToString();
                    else
                        FixedPaymentFrequency.Text = string.Empty;
                    FixedFrequencyCheck.Checked = sp.PaymentFrequency > 0;
                    if (sp.PaymentFrequencyUnit == PaymentFrequencyUnit.Day) FixedPaymentFrequencyUnits.SelectedIndex = 0;
                    if (sp.PaymentFrequencyUnit == PaymentFrequencyUnit.Month) FixedPaymentFrequencyUnits.SelectedIndex = 1;
                }
                else
                {
                    if (!string.IsNullOrEmpty(sp.OptionalPaymentFrequencies))
                        CustomPaymentFrequency.Text = sp.OptionalPaymentFrequencies;
                    else
                        CustomPaymentFrequency.Text = string.Empty;
                    CustomFrequencyCheck.Checked = !string.IsNullOrEmpty(sp.OptionalPaymentFrequencies);
                    if (sp.PaymentFrequencyUnit == PaymentFrequencyUnit.Day) CustomPaymentFrequencyUnit.SelectedIndex = 0;
                    if (sp.PaymentFrequencyUnit == PaymentFrequencyUnit.Month) CustomPaymentFrequencyUnit.SelectedIndex = 1;
                    if (CustomFrequencyCheck.Checked)
                        FixedFrequencyCheck.Checked = false;
                }

                UpdateFrequencyValidators();
                
                if (sp.NumberOfPayments > 0) NumberOfPayments.Text = sp.NumberOfPayments.ToString();
                else NumberOfPayments.Text = string.Empty;
                RecurringCharge.Text = sp.RecurringCharge.ToString("F2");
                ListItem item = RecurringTaxCode.Items.FindByValue(sp.RecurringTaxCodeId.ToString());
                if (item != null) RecurringTaxCode.SelectedIndex = RecurringTaxCode.Items.IndexOf(item);
                item = OneTimePriceTaxCode.Items.FindByValue(sp.OneTimeChargeTaxCodeId.ToString());
                if (item != null) OneTimePriceTaxCode.SelectedIndex = OneTimePriceTaxCode.Items.IndexOf(item); 

                item = SubscriptionGroup.Items.FindByValue(sp.GroupId.ToString());
                if (item != null) SubscriptionGroup.SelectedIndex = SubscriptionGroup.Items.IndexOf(item);
                AllowOneTimePurchase.Checked = sp.IsOptional;
                trOneTimePrice.Visible = AllowOneTimePurchase.Checked;
                trOneTimeTaxCode.Visible = AllowOneTimePurchase.Checked;
                trSalePitch.Visible = AllowOneTimePurchase.Checked;
                OneTimePrice.Text = sp.OneTimeCharge.ToString("F2");
                OneTimePriceLabel2.Text = string.Format(OneTimePriceLabel2.Text, this._Product.Price.LSCurrencyFormat("lc"));
                if (sp.OneTimeChargeModeId != 0)
                {
                    OneTimePriceMode.ClearSelection();
                    item = OneTimePriceMode.Items.FindByValue(sp.OneTimeChargeModeId.ToString());
                    if (item != null) item.Selected = true;
                }
                if (sp.RecurringChargeModeId != 0)
                {
                    RecurringChargeMode.ClearSelection();
                    item = RecurringChargeMode.Items.FindByValue(sp.RecurringChargeModeId.ToString());
                    if (item != null) item.Selected = true;
                }
                SalePitch.Text = sp.Description;

                if (BillingOption.SelectedIndex == 0)
                {
                    if (sp.PaymentFrequency > 0) Expiration.Text = sp.PaymentFrequency.ToString();
                    else Expiration.Text = string.Empty;
                    if (sp.PaymentFrequencyUnit == PaymentFrequencyUnit.Day) ExpirationUnit.SelectedIndex = 0;
                    if (sp.PaymentFrequencyUnit == PaymentFrequencyUnit.Month) ExpirationUnit.SelectedIndex = 1;
                }
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            ShowNoForm();
        }

        private void Save(SubscriptionPlan sp)
        {
            sp.Id = _Product.Id;
            sp.Name = Name.Text;
            switch (BillingOption.SelectedIndex)
            {
                case 0:
                    // ONE TIME CHARGE
                    sp.NumberOfPayments = 1;
                    sp.RecurringCharge = 0;
                    sp.RecurringChargeSpecified = false;
                    sp.RecurringTaxCodeId = 0;
                    sp.PaymentFrequency = AlwaysConvert.ToInt16(Expiration.Text);
                    if (ExpirationUnit.SelectedIndex == 0) sp.PaymentFrequencyUnit = PaymentFrequencyUnit.Day;
                    else sp.PaymentFrequencyUnit = PaymentFrequencyUnit.Month;
                    break;
                case 1:
                    // RECURRING CHARGE
                    sp.NumberOfPayments = AlwaysConvert.ToInt16(NumberOfPayments.Text);
                    sp.RecurringCharge = 0;
                    sp.RecurringChargeSpecified = false;
                    sp.RecurringTaxCodeId = 0;
                    break;
                case 2:
                    // INITIAL CHARGE WITH DIFFERENT RECURRING CHARGE
                    sp.NumberOfPayments = AlwaysConvert.ToInt16(NumberOfPayments.Text);
                    sp.RecurringCharge = AlwaysConvert.ToDecimal(RecurringCharge.Text); ;
                    sp.RecurringChargeSpecified = true;
                    sp.RecurringChargeMode = (InheritanceMode)Enum.Parse(typeof(InheritanceMode), RecurringChargeMode.SelectedValue);                    
                    sp.RecurringTaxCodeId = AlwaysConvert.ToInt(RecurringTaxCode.SelectedValue);
                    break;
            }

            if (BillingOption.SelectedIndex != 0)
            {
                if (FixedFrequencyCheck.Checked)
                {
                    sp.PaymentFrequency = AlwaysConvert.ToInt16(FixedPaymentFrequency.Text);
                    sp.OptionalPaymentFrequencies = string.Empty;
                    sp.PaymentFrequencyType = CommerceBuilder.Products.PaymentFrequencyType.Fixed;
                    if (FixedPaymentFrequencyUnits.SelectedIndex == 0) sp.PaymentFrequencyUnit = PaymentFrequencyUnit.Day;
                    else sp.PaymentFrequencyUnit = PaymentFrequencyUnit.Month;

                }
                else
                    if (CustomFrequencyCheck.Checked)
                    {
                        sp.OptionalPaymentFrequencies = CustomPaymentFrequency.Text;
                        sp.PaymentFrequency = 0;
                        sp.PaymentFrequencyType = CommerceBuilder.Products.PaymentFrequencyType.Optional;
                        if (CustomPaymentFrequencyUnit.SelectedIndex == 0) sp.PaymentFrequencyUnit = PaymentFrequencyUnit.Day;
                        else sp.PaymentFrequencyUnit = PaymentFrequencyUnit.Month;
                    }
                    else
                    {
                        sp.PaymentFrequencyType = CommerceBuilder.Products.PaymentFrequencyType.Fixed;
                    }
            }

            sp.GroupId = AlwaysConvert.ToInt(SubscriptionGroup.SelectedValue);
            sp.IsOptional = AllowOneTimePurchase.Checked;
            sp.OneTimeCharge = AlwaysConvert.ToDecimal(OneTimePrice.Text);
            sp.OneTimeChargeMode = (InheritanceMode)Enum.Parse(typeof(InheritanceMode), OneTimePriceMode.SelectedValue);
            sp.Description = SalePitch.Text;
            sp.OneTimeChargeTaxCodeId = AlwaysConvert.ToInt(OneTimePriceTaxCode.SelectedValue);
            sp.Save();
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            SavedMessage.Visible = true;
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            SubscriptionPlan sp = new SubscriptionPlan(_Product);
            this.Save(sp);
            ShowEditForm();
            SubscriptionsLink.Visible = true;
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            if (_Product.SubscriptionPlan != null)
                this.Save(_Product.SubscriptionPlan);
            else ShowNoForm();
        }

        protected void DeleteButton_Click(object sender, EventArgs e)
        {
            if (_Product.SubscriptionPlan != null)
            {
                if (_Product.SubscriptionPlan.Subscriptions == null || _Product.SubscriptionPlan.Subscriptions.Count == 0)
                {
                    _Product.SubscriptionPlan.Delete();
                    ShowNoForm();
                }
                else
                {
                    ErrorMessage.Text = "Subscription plan can not be deleted because it is currently active.";
                    ErrorMessage.Visible = true;
                }
            }
        }

        protected void NewGroupButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(NewName.Value))
            {
                CommerceBuilder.Users.Group group = new CommerceBuilder.Users.Group();
                group.Name = NewName.Value;
                group.Save();
                BindSubscriptionGroup();
                ListItem item = SubscriptionGroup.Items.FindByValue(group.Id.ToString());
                if (item != null) SubscriptionGroup.SelectedIndex = SubscriptionGroup.Items.IndexOf(item);
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            //WE DO THIS EACH TIME SO THAT LIST ITEMS DO NOT HAVE TO RESIDE IN VIEWSTATE
            BindSubscriptionGroup();
            IList<TaxCode> taxCodes = TaxCodeDataSource.LoadAll("Name");
            RecurringTaxCode.DataSource = taxCodes;
            RecurringTaxCode.DataBind();
            OneTimePriceTaxCode.DataSource = taxCodes;
            OneTimePriceTaxCode.DataBind();
        }

        protected void BillingOption_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateBillingOption();
            UpdateFrequencyValidators();
        }

        private void UpdateBillingOption()
        {
            if (BillingOption.SelectedIndex == 0)
            {
                // ONE TIME CHARGE
                trExpiration.Visible = true;
                trFrequency.Visible = false;
                trRecurringCharge.Visible = false;
                trNumberOfPayments.Visible = false;
            }
            else if (BillingOption.SelectedIndex == 1)
            {
                // RECURRING CHARGE
                trExpiration.Visible = false;
                trFrequency.Visible = true;
                trRecurringCharge.Visible = false;
                trNumberOfPayments.Visible = true;
                if (!FixedFrequencyCheck.Checked && !CustomFrequencyCheck.Checked)
                    FixedFrequencyCheck.Checked = true;
            }
            else
            {
                // INITIAL CHARGE WITH DIFFERENT RECURRING CHARGE
                trExpiration.Visible = false;
                trFrequency.Visible = true;
                trRecurringCharge.Visible = true;
                trNumberOfPayments.Visible = true;
                if (!FixedFrequencyCheck.Checked && !CustomFrequencyCheck.Checked)
                    FixedFrequencyCheck.Checked = true;
            }
        }

        protected void AllowOneTimePurchase_Changed(object sender, EventArgs e)
        {
            trOneTimePrice.Visible = AllowOneTimePurchase.Checked;
            trOneTimeTaxCode.Visible = AllowOneTimePurchase.Checked;
            trSalePitch.Visible = AllowOneTimePurchase.Checked;
        }

        protected void PaymentFrequencyType_Changed(object sender, EventArgs e)
        {
            UpdateFrequencyValidators();
        }

        private void UpdateFrequencyValidators() 
        {
            CustomFrequencyCheckRequiredField.Enabled = CustomFrequencyCheck.Checked;
            FixedFrequencyRequiredField.Enabled = FixedFrequencyCheck.Checked;
            FixedPaymentFrequencyRange.Enabled = FixedFrequencyCheck.Checked;
        }
    }
}