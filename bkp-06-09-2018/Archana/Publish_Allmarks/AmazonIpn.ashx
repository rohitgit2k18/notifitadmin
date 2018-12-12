<%@ WebHandler Language="C#" Class="AbleCommerce.AmazonIpn" %>
namespace AbleCommerce
{
    using System.Collections.Generic;
    using System.Reflection;
    using System.Web;
    using CommerceBuilder.Common;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Stores;
    
    public class AmazonIpn : IHttpHandler
	{
        public void ProcessRequest(HttpContext context)
        {
            IPaymentProvider amazonProvider = GetAmazonProvider();
            if (amazonProvider != null)
            {
                MethodInfo processIpnMethod = amazonProvider.GetType().GetMethod("ProcessIpn");
                object[] parameters = new object[] { context };
                processIpnMethod.Invoke(amazonProvider, parameters);
            }
        }

        public bool IsReusable
        {
            get { return true; }
        }

        private IPaymentProvider GetAmazonProvider()
        {
            Store store = AbleContext.Current.Store;
            IList<PaymentGateway> gatewayList = store.PaymentGateways;
            foreach (PaymentGateway gateway in gatewayList)
            {
                if (gateway.ClassId.EndsWith("CommerceBuilder.Amazon"))
                {
                    return gateway.GetInstance();
                }
            }
            return null;
        }
	}
}