<%@ WebHandler Language="C#" Class="AbleCommerce.Admin.Shipping.Providers._AustraliaPost.Default" %>

namespace AbleCommerce.Admin.Shipping.Providers._AustraliaPost
{
    using System.Collections.Generic;
    using System.Web;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Shipping.Providers.AustraliaPost;
    using CommerceBuilder.Utility;

    /// <summary>
    /// Choose the correct location for configuration.
    /// </summary>
    public class Default : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            // DEFAULT PAGE, REDIRECT TO APPROPRIATE LOCATION
            string classId = Misc.GetClassId(typeof(AustraliaPost));
            IList<ShipGateway> gateways = ShipGatewayDataSource.LoadForClassId(classId);
            if (gateways.Count > 0)
            {
                context.Response.Redirect("Configure.aspx?ShipGatewayId=" + gateways[0].Id);
            }
            context.Response.Redirect("Register.aspx");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}