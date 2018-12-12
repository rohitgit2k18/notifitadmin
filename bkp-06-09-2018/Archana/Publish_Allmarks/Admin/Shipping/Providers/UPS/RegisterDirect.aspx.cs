namespace AbleCommerce.Admin.Shipping.Providers._UPS
{
    using System;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.UPS;
    using CommerceBuilder.Utility;
    using System.Collections.Generic;

    public partial class RegisterDirect : CommerceBuilder.UI.AbleCommerceAdminPage
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

            if (!Page.IsPostBack)
            {
                UPS provider = (UPS)_ShipGateway.GetProviderInstance();

                // INITIALIZE THE FORM FIELDS ON FIRST VISIT
                UserId.Text = provider.UserId;
                AccessKey.Text = provider.AccessKey;
                Password.Text = provider.Password;
                EnableAddressValidation.Checked = provider.EnableAddressValidation;
                AddressServiceTestUrl.Text = provider.AddressServiceTestUrl;
                AddressServiceLiveUrl.Text = provider.AddressServiceLiveUrl;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UPS provider = (UPS)_ShipGateway.GetProviderInstance();
                provider.UserId = UserId.Text;
                provider.Password = Password.Text;
                provider.AccessKey = AccessKey.Text;
                provider.EnableAddressValidation = EnableAddressValidation.Checked;
                provider.AddressServiceTestUrl = AddressServiceTestUrl.Text;
                provider.AddressServiceLiveUrl = AddressServiceLiveUrl.Text;

                _ShipGateway.UpdateConfigData(provider.GetConfigData());
                _ShipGateway.Save();
                Response.Redirect("Configure.aspx?ShipGatewayId=" + _ShipGateway.Id);
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Configure.aspx?ShipGatewayId=" + _ShipGateway.Id);
        }
    }
}