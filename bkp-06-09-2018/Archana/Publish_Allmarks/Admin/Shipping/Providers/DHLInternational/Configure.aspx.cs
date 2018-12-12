namespace AbleCommerce.Admin.Shipping.Providers._DHLInternational
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.DHLInternational;
    using CommerceBuilder.Utility;

    public partial class Configure : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private ShipGateway _ShipGateway;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            // LOCATE THE SHIP GATEWAY INFORMATION
            string classId = Misc.GetClassId(typeof(DHLInternational));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count == 0)
            {
                Response.Redirect("Register.aspx");
            }
            _ShipGateway = gateways[0];

            // INITIALIZE THE PROVIDER SHIP METHOD CONTROL
            ShipMethods.ShipGatewayId = _ShipGateway.Id;

            // INITIALIZE THE FORM FIELDS ON FIRST VISIT
            if (!Page.IsPostBack)
            {
                DHLInternational provider = (DHLInternational)_ShipGateway.GetProviderInstance();
                UseDebugMode.Checked = provider.UseDebugMode;
                UseTestMode.Checked = provider.UseTestMode;
                EnablePackaging.Checked = provider.EnablePackageBreakup;
                UserID.Text = provider.UserID;
                Password.Text = provider.Password;
                ShippingKey.Text = provider.ShippingKey;
                AccountNumber.Text = provider.AccountNumber;
                DaysToShip.Text = provider.DaysToShip.ToString();
                LiveServerURL.Text = provider.LiveModeUrl;
                TestServerURL.Text = provider.TestModeUrl;
                TrackingURL.Text = provider.TrackingUrl;
                MaxWeight.Text = provider.MaxPackageWeight.ToString();
                MinWeight.Text = provider.MinPackageWeight.ToString();
                DutiableFlag.Checked = provider.DutiableFlag;
                CustomsValueMultiplier.Text = provider.CustomsValueMultiplier.ToString();
                CommerceLicensed.Checked = provider.CommerceLicensed;
                BindFilingType(provider.FilingType);
                FTRExemptionCode.Text = provider.FTRExemptionCode;
                ITNNumber.Text = provider.ITNNumber;
                EINCode.Text = provider.EINCode;
            }
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            SaveGateWayProviderDHL();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            SaveGateWayProviderDHL();
            Response.Redirect("../Default.aspx");
        }

        private void SaveGateWayProviderDHL()
        {
            DHLInternational provider = (DHLInternational)_ShipGateway.GetProviderInstance();
            provider.UseDebugMode = UseDebugMode.Checked;
            provider.UseTestMode = UseTestMode.Checked;
            provider.EnablePackageBreakup = EnablePackaging.Checked;
            provider.ShippingKey = ShippingKey.Text;
            provider.AccountNumber = AccountNumber.Text;
            provider.UserID = UserID.Text;
            provider.Password = Password.Text;
            provider.DaysToShip = AlwaysConvert.ToInt(DaysToShip.Text, 1);
            if (provider.DaysToShip < 1) provider.DaysToShip = 1;
            DaysToShip.Text = provider.DaysToShip.ToString();
            provider.LiveModeUrl = LiveServerURL.Text;
            provider.TestModeUrl = TestServerURL.Text;
            provider.TrackingUrl = TrackingURL.Text;
            provider.MaxPackageWeight = AlwaysConvert.ToDecimal(MaxWeight.Text, (decimal)provider.MaxPackageWeight);
            provider.MinPackageWeight = AlwaysConvert.ToDecimal(MinWeight.Text, (decimal)provider.MinPackageWeight);
            provider.DutiableFlag = DutiableFlag.Checked;
            provider.CustomsValueMultiplier = AlwaysConvert.ToDecimal(CustomsValueMultiplier.Text, 1);
            provider.CommerceLicensed = CommerceLicensed.Checked;
            provider.FilingType = (DHLInternational.FilingTypeFlags)AlwaysConvert.ToEnum(typeof(DHLInternational.FilingTypeFlags), FilingType.SelectedValue, DHLInternational.FilingTypeFlags.ITN);
            provider.FTRExemptionCode = FTRExemptionCode.Text;
            provider.ITNNumber = ITNNumber.Text;
            provider.EINCode = EINCode.Text;
            _ShipGateway.UpdateConfigData(provider.GetConfigData());
            _ShipGateway.Save();
        }

        protected void BindFilingType(DHLInternational.FilingTypeFlags pType)
        {
            FilingType.Items.Clear();
            foreach (DHLInternational.FilingTypeFlags pkgType in Enum.GetValues(typeof(DHLInternational.FilingTypeFlags)))
            {
                ListItem newItem = new ListItem(pkgType.ToString(), pkgType.ToString());
                FilingType.Items.Add(newItem);
                if (pkgType == pType)
                {
                    newItem.Selected = true;
                }
            }
        }
    }
}