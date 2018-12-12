<%@ WebHandler Language="C#" Class="AbleCommerce.TaxCloudCertsList" %>
namespace AbleCommerce
{
    using System.Collections.Generic;
    using System.Reflection;
    using System.Web;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes.Providers.TaxCloud;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;

    public class TaxCloudCertsList : IHttpHandler
	{
        public void ProcessRequest(HttpContext context)
        {
            TaxCloudProvider taxCloudProvider = GetTaxCloudProvider();
            if (taxCloudProvider != null)
            {
                context.Response.Clear();
                context.Response.ContentType = "application/json";
                var data = taxCloudProvider.GetExemptionCertificatsJson(AbleContext.Current.User);
                context.Response.Write(data);
                context.Response.Flush();
            }
        }

        public bool IsReusable
        {
            get { return true; }
        }

        private TaxCloudProvider GetTaxCloudProvider()
        {
            TaxGateway taxGateway = null;
            TaxCloudProvider taxProvider = null;
            int taxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(TaxCloudProvider)));
            if (taxGatewayId > 0) taxGateway = TaxGatewayDataSource.Load(taxGatewayId);
            if (taxGateway != null) taxProvider = taxGateway.GetProviderInstance() as TaxCloudProvider;
            return taxProvider;
        }
	}
}