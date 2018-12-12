namespace AbleCommerce.Admin.Shipping.Providers._USPS
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.USPS;
    using CommerceBuilder.Utility;

    public partial class Register : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            // VERIFY THIS PROVIDER IS NOT ALREADY REGISTERED
            string classId = Misc.GetClassId(typeof(USPS));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count > 0)
            {
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateways[0].Id);
            }

            Logo.ImageUrl = new USPS().GetLogoUrl(this.Page.ClientScript);
        }

        protected void NextButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                USPS provider = new USPS();
                provider.UserId = UserId.Text;
                provider.UserIdActive = true;
                ShipGateway gateway = new ShipGateway();
                gateway.Name = provider.Name;
                gateway.ClassId = Misc.GetClassId(typeof(USPS));
                gateway.UpdateConfigData(provider.GetConfigData());
                gateway.Enabled = true;
                gateway.Save();
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateway.Id);
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }
    }
}