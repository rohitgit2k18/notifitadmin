using CommerceBuilder.Common;
using CommerceBuilder.Orders;
using CommerceBuilder.Services.Checkout;
using CommerceBuilder.Taxes.Providers.TaxCloud;
using System;
using System.Text;
using System.Configuration;
using System.Web.Configuration;
using System.Collections.Generic;
using CommerceBuilder.Taxes;
using CommerceBuilder.Extensions;
using CommerceBuilder.Utility;

namespace AbleCommerce
{
    public partial class TaxCloudExemption : System.Web.UI.Page
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            var provider = ProviderHelper.LoadTaxProvider<TaxCloudProvider>();
            if (provider == null || !provider.EnableTaxCloud || !provider.UseTaxExemption)
            {
                Response.Redirect("Default.aspx");
            }

            Dictionary<string, decimal> taxes = new Dictionary<string, decimal>();
            decimal totalTaxAmount = 0;
            Basket basket = AbleContext.Current.User.Basket;
            foreach (BasketItem item in basket.Items)
            {
                decimal extendedPrice = AbleCommerce.Code.InvoiceHelper.GetInvoiceExtendedPrice(item);
                if (item.OrderItemType == OrderItemType.Tax)
                {
                    totalTaxAmount += extendedPrice;
                }
            }

            TaxAmount.Text = totalTaxAmount.LSCurrencyFormat("ulc");
            BasketId.Text = AbleContext.Current.User.Basket.Id.ToString();
        }
    }
}