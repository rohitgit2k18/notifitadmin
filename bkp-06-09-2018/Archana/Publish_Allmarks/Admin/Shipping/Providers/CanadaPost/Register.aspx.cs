namespace AbleCommerce.Admin.Shipping.Providers._CanadaPost
{
    using System.Collections.Generic;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.CanadaPost;
    using CommerceBuilder.Utility;

    public partial class Register : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            // VERIFY THIS PROVIDER IS NOT ALREADY REGISTERED
            string classId = Misc.GetClassId(typeof(CanadaPost));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count > 0)
            {
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateways[0].Id);
            }

            Logo.ImageUrl = new CanadaPost().GetLogoUrl(this.Page.ClientScript);
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        protected void RegisterButton_Click(object sender, System.EventArgs e)
        {
            CanadaPost provider = new CanadaPost();
            provider.MerchantCPCID = MerchantId.Text;
            provider.AccountActive = true;
            ShipGateway gateway = new ShipGateway();
            gateway.Name = provider.Name;
            gateway.ClassId = Misc.GetClassId(typeof(CanadaPost));
            gateway.UpdateConfigData(provider.GetConfigData());
            gateway.Enabled = true;
            gateway.Save();
            Response.Redirect("Configure.aspx?ShipGatewayId=" + gateway.Id);
        }
    }
}