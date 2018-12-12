namespace AbleCommerce.Admin.Shipping.Providers
{
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected List<string> GetShipMethodList(object dataItem)
        {
            ShipGateway gateway = (ShipGateway)dataItem;
            List<string> ShipMethods = new List<string>();
            foreach (ShipMethod method in gateway.ShipMethods)
            {
                ShipMethods.Add(method.Name);
            }
            return ShipMethods;
        }

        protected string GetConfigReference(object dataItem)
        {
            IShippingProvider provider = ((ShipGateway)dataItem).GetProviderInstance();
            if (provider != null)
            {
                return provider.Description;
            }
            return string.Empty;
        }

        protected string GetConfigUrl(object dataItem)
        {
            ShipGateway gateway = (ShipGateway)dataItem;
            IShippingProvider provider = gateway.GetProviderInstance();
            if (provider != null)
            {
                return provider.GetConfigUrl(Page.ClientScript) + "?ShipGatewayId=" + gateway.Id.ToString();
            }
            return string.Empty;
        }

        protected string GetLogoUrl(object dataItem)
        {
            ShipGateway gateway = (ShipGateway)dataItem;
            IShippingProvider provider = gateway.GetProviderInstance();
            if (provider != null)
            {
                return provider.GetLogoUrl(Page.ClientScript);
            }
            return string.Empty;
        }
    }
}