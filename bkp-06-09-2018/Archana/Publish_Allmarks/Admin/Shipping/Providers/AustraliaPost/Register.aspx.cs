namespace AbleCommerce.Admin.Shipping.Providers._AustraliaPost
{
    using System.Collections.Generic;
    using CommerceBuilder.Common;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.AustraliaPost;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class Register : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            // VERIFY THIS PROVIDER IS NOT ALREADY REGISTERED
            string classId = Misc.GetClassId(typeof(AustraliaPost));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count > 0)
            {
                Response.Redirect("Configure.aspx?ShipGatewayId=" + gateways[0].Id);
            }

            ConditionText.Text = string.Format(ConditionText.Text, AbleContext.Current.Store.Name);
            Logo.ImageUrl = new AustraliaPost().GetLogoUrl(this.Page.ClientScript);
        }

        protected void CancelButton_Click(object sender, System.EventArgs e)
        {
            Response.Redirect("../Default.aspx");
        }

        protected void RegisterButton_Click(object sender, System.EventArgs e)
        {
            // make sure conditions appear for store
            Store store =  AbleContext.Current.Store;
            string conditions = store.Settings.CheckoutTermsAndConditions;
            if (string.IsNullOrEmpty(conditions))
            {
                conditions = ConditionText.Text;
            }
            else
            {
                if (!conditions.Contains(ConditionText.Text))
                {
                    conditions += "\r\n\r\n<p>" + ConditionText.Text + "</p>";
                }
            }
            store.Settings.CheckoutTermsAndConditions = conditions;
            store.Save();

            AustraliaPost provider = new AustraliaPost();
            provider.AccountActive = true;
            ShipGateway gateway = new ShipGateway();
            gateway.Name = provider.Name;
            gateway.ClassId = Misc.GetClassId(provider.GetType());
            gateway.UpdateConfigData(provider.GetConfigData());
            gateway.Enabled = true;
            gateway.Save();
            Response.Redirect("Configure.aspx?ShipGatewayId=" + gateway.Id.ToString());
        }
    }
}