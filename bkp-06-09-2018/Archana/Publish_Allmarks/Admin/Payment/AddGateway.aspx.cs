namespace AbleCommerce.Admin._Payment
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Payments;
    using System.Linq;

    public partial class AddGateway : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                ProviderList.DataSource = LoadGateways();
                ProviderList.DataBind();
            }
        }

        /// <summary>
        /// Homogenizes the list of items to the same concretee type
        /// for binding in the datagrid.
        /// </summary>
        /// <returns>List of gateway items</returns>
        private IList<GatewayItem> LoadGateways()
        {
            IList<PaymentGateway> configuredGateways = PaymentGatewayDataSource.LoadAll();
            List<GatewayItem> gatewayItems = new List<GatewayItem>();
            IList<IPaymentProvider> providers = PaymentProviderDataSource.GetProviders(true);
            string epayProviderClassId = Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.EPaymentIntegrator.EPayProvider));
            foreach (var provider in providers)
            {
                string classId = Misc.GetClassId(provider.GetType());

                // PROVIDER IS NOT CONFIGURED ALREADY, ALLOW MULTIPLE INSTANCES OF IBIZ PROVIDER
                if(!configuredGateways.Any(g => g.ClassId == classId) || classId == epayProviderClassId)
                    gatewayItems.Add(new GatewayItem(Misc.GetClassId(provider.GetType()), provider.Name, provider.GetLogoUrl(Page.ClientScript), GetSupportedTransactions(provider)));
            }
            return gatewayItems;
        }

        private string GetSupportedTransactions(IPaymentProvider provider)
        {
            List<string> supportedFeatures = new List<string>();
            if ((provider.SupportedTransactions & SupportedTransactions.Authorize) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Authorize.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.AuthorizeCapture) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.AuthorizeCapture.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.Capture) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Capture.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.PartialCapture) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.PartialCapture.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.Void) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Void.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.Refund) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Refund.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.PartialRefund) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.PartialRefund.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.RecurringBilling) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.RecurringBilling.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.RecurringBillingCallbackManaged) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.RecurringBillingCallbackManaged.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.RecurringBillingProbeManaged) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.RecurringBillingProbeManaged.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.RecurringBillingProfileManaged) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.RecurringBillingProfileManaged.ToString()));
            if (supportedFeatures.Count == 0) return string.Empty;
            return string.Join(", ", supportedFeatures.ToArray());
        }

        protected void ProviderList_RowCommand(object source, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("Add"))
            {
                Guid sessionKey = Guid.NewGuid();
                Session[sessionKey.ToString()] = (string)e.CommandArgument;
                Response.Redirect("AddGateway2.aspx?ProviderClassId=" + sessionKey.ToString());
            }
        }

        protected class GatewayItem
        {
            public string ClassId { get; set; }
            public string Name { get; set; }
            public string LogoUrl { get; set; }
            public string SupportedTransactions { get; set; }
            public GatewayItem(string classId, string name, string logoUrl, string supportedTransactions)
            {
                this.ClassId = classId;
                this.Name = name;
                this.LogoUrl = logoUrl;
                this.SupportedTransactions = supportedTransactions;
            }
        }
    }
}