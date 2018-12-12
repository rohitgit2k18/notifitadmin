namespace AbleCommerce.Admin.Shipping.Providers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers;
    using CommerceBuilder.Utility;

    public partial class AddGateway : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IList<IShippingProvider> allProviders = ShippingProviderDataSource.GetShippingProviders();
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadAll();
            List<IShippingProvider> availableProviders = new List<IShippingProvider>();
            foreach (IShippingProvider provider in allProviders)
            {
                string providerClassId = Misc.GetClassId(provider.GetType());
                if (gateways.Where(gw => gw.ClassId.Equals(providerClassId)).Count() == 0)
                {
                    availableProviders.Add(provider);
                }
            }
            ProviderGrid.DataSource = availableProviders;
            ProviderGrid.DataBind();
        }

        protected string GetLogoUrl(object dataItem)
        {
            IShippingProvider provider = (IShippingProvider)dataItem;
            return provider.GetLogoUrl(Page.ClientScript);
        }

        protected string GetConfigUrl(object dataItem)
        {
            IShippingProvider provider = (IShippingProvider)dataItem;
            return provider.GetConfigUrl(Page.ClientScript);
        }
    }
}