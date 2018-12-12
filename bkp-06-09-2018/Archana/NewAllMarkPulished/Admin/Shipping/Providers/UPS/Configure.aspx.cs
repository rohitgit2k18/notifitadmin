namespace AbleCommerce.Admin.Shipping.Providers._UPS
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.UPS;
    using CommerceBuilder.Utility;

    public partial class Configure : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private ShipGateway _ShipGateway;

        protected void Page_Load(object sender, EventArgs e)
        {
            // LOCATE THE SHIP GATEWAY INFORMATION
            string classId = Misc.GetClassId(typeof(UPS));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count == 0)
            {
                Response.Redirect("License.aspx");
            }
            _ShipGateway = gateways[0];
            UPS provider = (UPS)_ShipGateway.GetProviderInstance();

            // INITIALIZE THE PROVIDER SHIP METHOD CONTROL
            ShipMethods.ShipGatewayId = _ShipGateway.Id;

            // INITIALIZE THE FORM FIELDS ON FIRST VISIT
            UserId.Text = provider.UserId;
            AccessKey.Text = provider.AccessKey;
            if (!Page.IsPostBack)
            {
                if ((provider.CustomerType == UPS.UpsCustomerType.DailyPickup))
                {
                    CustomerType_DailyPickup.Checked = true;
                }
                else if ((provider.CustomerType == UPS.UpsCustomerType.Occasional))
                {
                    CustomerType_Occasional.Checked = true;
                }
                else if ((provider.CustomerType == UPS.UpsCustomerType.Retail))
                {
                    CustomerType_Retail.Checked = true;
                }
                else 
                {
                    CustomerType_Negotiated.Checked = true;
                }
                UseInsurance.Checked = provider.UseInsurance;
                UseDebugMode.Checked = provider.UseDebugMode;
                UseTestMode.Checked = provider.UseTestMode;
                LiveServerURL.Text = provider.LiveModeUrl;
                TestServerURL.Text = provider.TestModeUrl;
                TrackingURL.Text = provider.TrackingUrl;
                ShipperNumber.Text = provider.ShipperNumber;
                EnableLabels.Checked = provider.EnableShipping;
                MaxWeight.Text = provider.MaxPackageWeight.ToString();
                MinWeight.Text = provider.MinPackageWeight.ToString();
                EnablePackaging.Checked = provider.EnablePackageBreakup;
                //EnableAddressValidation.Checked = provider.EnableAddressValidation;
                //AddressServiceTestUrl.Text = provider.AddressServiceTestUrl;
                //AddressServiceLiveUrl.Text = provider.AddressServiceLiveUrl;
            }
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            SaveGateWayUPS();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        public void SaveAndCloseButton_Click(object sender, System.EventArgs e)
        {
            SaveGateWayUPS();
            Response.Redirect("../Default.aspx");
        }

        private void SaveGateWayUPS()
        {
            UPS provider = (UPS)_ShipGateway.GetProviderInstance();
            int customerTypeIndex;
            if (CustomerType_DailyPickup.Checked)
            {
                customerTypeIndex = 0;
            }
            else if (CustomerType_Occasional.Checked)
            {
                customerTypeIndex = 1;
            }
            else if (CustomerType_Retail.Checked)
            {
                customerTypeIndex = 2;
            }
            else
            {
                customerTypeIndex = 3;
            }
            provider.CustomerType = ((UPS.UpsCustomerType)(customerTypeIndex));
            provider.UseInsurance = UseInsurance.Checked;
            provider.UseDebugMode = UseDebugMode.Checked;
            provider.UseTestMode = UseTestMode.Checked;
            provider.LiveModeUrl = LiveServerURL.Text;
            provider.TestModeUrl = TestServerURL.Text;
            provider.TrackingUrl = TrackingURL.Text;
            provider.ShipperNumber = ShipperNumber.Text;
            provider.EnableShipping = EnableLabels.Checked;
            provider.MaxPackageWeight = AlwaysConvert.ToDecimal(MaxWeight.Text, (decimal)provider.MaxPackageWeight);
            provider.MinPackageWeight = AlwaysConvert.ToDecimal(MinWeight.Text, (decimal)provider.MinPackageWeight);
            provider.EnablePackageBreakup = EnablePackaging.Checked;
            //provider.EnableAddressValidation = EnableAddressValidation.Checked;
            //provider.AddressServiceTestUrl = AddressServiceTestUrl.Text;
            //provider.AddressServiceLiveUrl = AddressServiceLiveUrl.Text;
            _ShipGateway.UpdateConfigData(provider.GetConfigData());
            _ShipGateway.Save();
        }
    }
}