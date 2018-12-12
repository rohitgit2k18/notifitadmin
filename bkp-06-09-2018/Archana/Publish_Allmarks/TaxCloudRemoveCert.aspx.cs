using CommerceBuilder.Common;
using CommerceBuilder.Taxes;
using CommerceBuilder.Taxes.Providers.TaxCloud;
using CommerceBuilder.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce
{
    public partial class TaxCloudRemoveCert : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string certID = Request["certificateID"];

            TaxGateway taxGateway = null;
            TaxCloudProvider taxProvider = null;
            int taxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(TaxCloudProvider)));
            if (taxGatewayId > 0) taxGateway = TaxGatewayDataSource.Load(taxGatewayId);
            if (taxGateway != null) taxProvider = taxGateway.GetProviderInstance() as TaxCloudProvider;

            if (taxProvider != null) taxProvider.RemoveExemptionCert(certID);
        }
    }
}