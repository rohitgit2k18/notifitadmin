namespace AbleCommerce.Admin.Shipping.Providers._USPS
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.USPS;
    using CommerceBuilder.Utility;

    public partial class Configure : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        ShipGateway _ShipGateway;

        protected void Page_Load(object sender, EventArgs e)
        {
            // LOCATE THE SHIP GATEWAY INFORMATION
            string classId = Misc.GetClassId(typeof(USPS));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count == 0)
            {
                Response.Redirect("Register.aspx");
            }
            _ShipGateway = gateways[0];
            USPS provider = (USPS)_ShipGateway.GetProviderInstance();

            // INITIALIZE THE PROVIDER SHIP METHOD CONTROL
            ShipMethods.ShipGatewayId = _ShipGateway.Id;

            // INITIALIZE THE FORM FIELDS ON FIRST VISIT
            if (!Page.IsPostBack)
            {
                UseDebugMode.Checked = provider.UseDebugMode;
                UseTestMode.Checked = provider.UseTestMode;
                UserId.Text = provider.UserId;
                LiveServerURL.Text = provider.LiveModeUrl;
                TestServerURL.Text = provider.TestModeUrl;
                TrackingURL.Text = provider.TrackingUrl;
                MaxWeight.Text = provider.MaxPackageWeight.ToString();
                MinWeight.Text = provider.MinPackageWeight.ToString();
                EnablePackaging.Checked = provider.EnablePackageBreakup;
                EnableAddressValidation.Checked = provider.EnableAddressValidation;
                AddressServiceUrl.Text = provider.AddressServiceUrl;
                UseOnlineRates.Checked = provider.UseOnlineRate;
                var item = IntlMailType.Items.FindByValue(provider.IntlMailType);
                if (item != null)
                    item.Selected = true;
            }
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            // RETURN TO MAIN MENU
            Response.Redirect("../Default.aspx");
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveGateWayUSPS();
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        public void SaveAndCloseButton_Click(object sender, System.EventArgs e)
        {
            SaveGateWayUSPS();
            Response.Redirect("../Default.aspx");
        }

        private void SaveGateWayUSPS()
        {
            USPS provider = (USPS)_ShipGateway.GetProviderInstance();
            provider.UseDebugMode = UseDebugMode.Checked;
            provider.UseTestMode = UseTestMode.Checked;
            provider.UserId = UserId.Text;
            provider.LiveModeUrl = LiveServerURL.Text;
            provider.TestModeUrl = TestServerURL.Text;
            provider.TrackingUrl = TrackingURL.Text;
            provider.MaxPackageWeight = AlwaysConvert.ToDecimal(MaxWeight.Text, (decimal)provider.MaxPackageWeight);
            provider.MinPackageWeight = AlwaysConvert.ToDecimal(MinWeight.Text, (decimal)provider.MinPackageWeight);
            provider.EnablePackageBreakup = EnablePackaging.Checked;
            provider.EnableAddressValidation = EnableAddressValidation.Checked;
            provider.AddressServiceUrl = AddressServiceUrl.Text;
            provider.UseOnlineRate = UseOnlineRates.Checked;
            provider.IntlMailType = IntlMailType.SelectedValue;
            _ShipGateway.UpdateConfigData(provider.GetConfigData());
            _ShipGateway.Save();
        }
    }
}