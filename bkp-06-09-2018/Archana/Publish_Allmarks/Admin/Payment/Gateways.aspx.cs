using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Payments.Providers;
using CommerceBuilder.Payments;
using System.Collections.Generic;
using NHibernate;
using CommerceBuilder.DomainModel;
using NHibernate.Criterion;

namespace AbleCommerce.Admin._Payment
{
public partial class Gateways : CommerceBuilder.UI.AbleCommerceAdminPage
{

    
    protected void Page_Init(object sender, EventArgs e)
    {
        GatewayGrid.DataSource = LoadGateways();
        GatewayGrid.DataBind();
    }

    protected IList<PaymentGateway> LoadGateways()
    {
        string classId = GetGiftCertPayGatewayId();
        ICriteria criteria = NHibernateHelper.CreateCriteria<PaymentGateway>();
        criteria.Add(Restrictions.Not(Restrictions.Eq("Name", "Gift Certificate Payment Provider")));
        criteria.Add(Restrictions.Not(Restrictions.Eq("ClassId", StringHelper.SafeSqlString((classId)))));
        List<PaymentGateway> filteredGateways = new List<PaymentGateway>();
        IList<PaymentGateway> gateways = PaymentGatewayDataSource.LoadAll();
        for (int i = gateways.Count -1; i >= 0; i--)
        {
            if (gateways[i].Name.Equals("Gift Certificate Payment Provider"))
            {
                continue;
            }
            if (gateways[i].ClassId.Equals(classId))
            {
                continue;
            }

            filteredGateways.Add(gateways[i]);
        }

        return filteredGateways;
    }

    private string GetGiftCertPayGatewayId()
    {
        return Misc.GetClassId(typeof(CommerceBuilder.Payments.Providers.GiftCertificatePaymentProvider));
    }
    
    protected string GetSupportedTransactions(object dataItem)
    {
        IPaymentProvider provider = ((PaymentGateway)dataItem).GetInstance();
        List<string> supportedFeatures = new List<string>();
        if (provider != null)
        {
            if ((provider.SupportedTransactions & SupportedTransactions.Authorize) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Authorize.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.AuthorizeCapture) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.AuthorizeCapture.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.Capture) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Capture.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.PartialCapture) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.PartialCapture.ToString()));
            if ((provider.SupportedTransactions & SupportedTransactions.Void) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Void.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.Refund) != SupportedTransactions.None) supportedFeatures.Add(SupportedTransactions.Refund.ToString());
            if ((provider.SupportedTransactions & SupportedTransactions.PartialRefund) != SupportedTransactions.None) supportedFeatures.Add(StringHelper.SpaceName(SupportedTransactions.PartialRefund.ToString()));
        }
        if (supportedFeatures.Count == 0) return string.Empty;
        return string.Join(", ", supportedFeatures.ToArray());
    }

    protected string GetPaymentMethods(object dataItem)
    {
        PaymentGateway gateway = (PaymentGateway)dataItem;
        List<string> paymentMethods = new List<string>();
        foreach(PaymentMethod method in gateway.PaymentMethods)
        {
            paymentMethods.Add(method.Name);
        }
        if (paymentMethods.Count == 0) return string.Empty;
        return string.Join(", ", paymentMethods.ToArray());
    }

    protected string GetConfigReference(object dataItem)
    {
        IPaymentProvider provider = ((PaymentGateway)dataItem).GetInstance();
        if (provider != null)
        {
            return provider.ConfigReference;
        }
        return string.Empty;        
    }

    protected void GatewayGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int gatewayId = (int)GatewayGrid.DataKeys[e.RowIndex].Value;
        //FIND THE OPTION
        IList<PaymentGateway> gateways = LoadGateways();
        int index = -1;
        int i = 0;
        while ((i < gateways.Count) && (index < 0))
        {
            if (gateways[i].Id == gatewayId) index = i;
            i++;
        }
        if (index >= 0)
        {
            gateways.DeleteAt(index);
            GatewayGrid.DataSource = gateways;
            GatewayGrid.DataBind();
        }
    }

}
}
