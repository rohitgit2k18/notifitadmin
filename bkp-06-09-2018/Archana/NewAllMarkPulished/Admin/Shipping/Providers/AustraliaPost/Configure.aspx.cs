namespace AbleCommerce.Admin.Shipping.Providers._AustraliaPost
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.AustraliaPost;
    using CommerceBuilder.Utility;

    public partial class Configure : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        ShipGateway _ShipGateway;

        protected void Page_Load(object sender, EventArgs e)
        {
            // LOCATE THE SHIP GATEWAY INFORMATION
            string classId = Misc.GetClassId(typeof(AustraliaPost));
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
                AustraliaPost provider = (AustraliaPost)_ShipGateway.GetProviderInstance();
                UseDebugMode.Checked = provider.UseDebugMode;
                EnablePackaging.Checked = provider.EnablePackageBreakup;
                MaxWeight.Text = provider.MaxPackageWeight.ToString();
                MinWeight.Text = provider.MinPackageWeight.ToString();
            }
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        protected void SaveButton_Click(object sender, System.EventArgs e)
        {
            SaveShipGateWay();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        public void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            SaveShipGateWay();
            Response.Redirect("../Default.aspx");
        }

        private void SaveShipGateWay()
        {
            AustraliaPost provider = (AustraliaPost)_ShipGateway.GetProviderInstance();
            provider.UseDebugMode = UseDebugMode.Checked;
            provider.EnablePackageBreakup = EnablePackaging.Checked;
            provider.MaxPackageWeight = AlwaysConvert.ToDecimal(MaxWeight.Text, (decimal)provider.MaxPackageWeight);
            provider.MinPackageWeight = AlwaysConvert.ToDecimal(MinWeight.Text, (decimal)provider.MinPackageWeight);
            _ShipGateway.UpdateConfigData(provider.GetConfigData());
            _ShipGateway.Save();
        }
    }
}