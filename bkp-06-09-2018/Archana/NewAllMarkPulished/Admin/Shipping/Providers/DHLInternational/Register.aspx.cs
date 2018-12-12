namespace AbleCommerce.Admin.Shipping.Providers._DHLInternational
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.DHLInternational;
    using CommerceBuilder.Utility;

    public partial class Register : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // VERIFY THIS PROVIDER IS NOT ALREADY REGISTERED
            string classId = Misc.GetClassId(typeof(DHLInternational));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count > 0)
            {
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateways[0].Id);
            }

            Logo.ImageUrl = new DHLInternational().GetLogoUrl(this.Page.ClientScript);
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        protected void RegisterButton_Click(object sender, System.EventArgs e)
        {
            if (Page.IsValid)
            {
                DHLInternational provider = new DHLInternational();
                provider.UserID = DHLUserID.Text;
                provider.Password = DHLPassword.Text;
                ShipGateway gateway = new ShipGateway();
                gateway.Name = provider.Name;
                gateway.ClassId = Misc.GetClassId(typeof(DHLInternational));
                gateway.UpdateConfigData(provider.GetConfigData());
                gateway.Enabled = true;
                gateway.Save();
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateway.Id);
            }
        }
    }
}