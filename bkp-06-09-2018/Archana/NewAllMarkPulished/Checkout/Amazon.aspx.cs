namespace AbleCommerce.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.Reflection;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Payments.Providers;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

    public partial class Amazon : CommerceBuilder.UI.AbleCommercePage
    {
        private IPaymentProvider _AmazonProvider = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            // verify the provider is configured
            _AmazonProvider = GetAmazonProvider();
            if (_AmazonProvider == null) Response.Redirect(NavigationHelper.GetBasketUrl());

            // package the basket on first visit
            Basket basket = AbleContext.Current.User.Basket;
            if (!Page.IsPostBack)
            {
                IBasketService basketService = AbleContext.Resolve<IBasketService>();
                basketService.Package(basket, true);
                basketService.Combine(basket);
                foreach (var shipment in basket.Shipments)
                {
                    shipment.ShipMethod = null;
                }
                basket.Save();
                basketService.Recalculate(basket);
            }

            // bind the amazon widgets
            MethodInfo buttonMethod = _AmazonProvider.GetType().GetMethod("GetAddressWidget");
            string eventHandler = "document.getElementById('" + RecalculateShippingButton.ClientID + "').click();";
            object[] parameters = new object[] { basket, eventHandler, false };
            PlaceHolder addressWidget = (PlaceHolder)buttonMethod.Invoke(_AmazonProvider, parameters);
            this.ShippingAddress.Controls.Add(addressWidget);
            BindBasketGrid();
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

        protected void RecalculateShippingButton_Click(object sender, EventArgs e)
        {
            if (_AmazonProvider != null)
            {
                // make sure payment panel is hidden
                PaymentPanel.Visible = false;

                // need to get the address where we are shipping
                User user = AbleContext.Current.User;
                string purchaseContractId = Request.QueryString["purchaseContractId"];
                MethodInfo getAddressMethod = _AmazonProvider.GetType().GetMethod("GetDestinationAddress");
                object[] parameters = new object[] { user, purchaseContractId };
                Address address = (Address)getAddressMethod.Invoke(_AmazonProvider, parameters);

                // make sure we have a valid address
                if (address != null)
                {
                    // make sure the basket is packaged
                    Basket basket = AbleContext.Current.User.Basket;
                    IBasketService basketService = AbleContext.Resolve<IBasketService>();
                    basketService.Package(basket);

                    // set all shipments to the right destination
                    foreach (BasketShipment shipment in basket.Shipments)
                    {
                        shipment.Address = address;
                    }
                    basket.Save();

                    // calculate shipping
                    ShippingMethodPanel.Visible = true;
                    IShipRateQuoteCalculator shippingCalculator = AbleContext.Resolve<IShipRateQuoteCalculator>();
                    ICollection<ShipRateQuote> rateQuotes = shippingCalculator.QuoteForShipment(AbleContext.Current.User.Basket.Shipments[0]);
                    ShipMethodsList.DataSource = GetShipMethodListDs(rateQuotes);
                    ShipMethodsList.DataBind();
                }
            }
        }

        protected void ShipMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            int currentShipMethod = AlwaysConvert.ToInt(ShipMethodsList.SelectedValue);
            CommerceBuilder.Shipping.ShipMethod method = ShipMethodDataSource.Load(currentShipMethod);
            if (method != null)
            {
                // set all shipments to the right shipping method
                Basket basket = AbleContext.Current.User.Basket;
                foreach (BasketShipment shipment in basket.Shipments)
                {
                    shipment.ShipMethod = method;
                }
                basket.Save();

                IBasketService service = AbleContext.Resolve<IBasketService>();
                service.Recalculate(basket);

                PaymentPanel.Visible = true;
                BindBasketGrid();

                MethodInfo widgetMethod = _AmazonProvider.GetType().GetMethod("GetPaymentWidget");
                string eventHandler = "document.getElementById('" + PlaceOrderButton.ClientID + "').style.display = 'block';";
                //string eventHandler = "alert('payment chosen');";
                object[] parameters = new object[] { AbleContext.Current.User.Basket, eventHandler, false };
                PlaceHolder paymentWidget = (PlaceHolder)widgetMethod.Invoke(_AmazonProvider, parameters);
                this.phPaymentWidget.Controls.Add(paymentWidget);
            }
        }

        private void BindBasketGrid()
        {
            BasketItemsGrid.DataSource = BasketHelper.GetDisplayItems(AbleContext.Current.User.Basket, true, true);
            BasketItemsGrid.DataBind();
            BasketItemsGrid.Columns[3].Visible = TaxHelper.ShowTaxColumn;
        }

        protected void PlaceOrderButton_Click(object sender, EventArgs e)
        {
            MethodInfo widgetMethod = _AmazonProvider.GetType().GetMethod("Checkout");
            string purchaseContractId = Request.QueryString["purchaseContractId"];
            object[] parameters = new object[] { AbleContext.Current.User.Basket, purchaseContractId };
            CheckoutResponse result = (CheckoutResponse)widgetMethod.Invoke(_AmazonProvider, parameters);
            if (!result.Success) PlaceOrderButton.Text = result.WarningMessages[0];
            else Response.Redirect("~/Members/MyOrder.aspx?OrderNumber=" + result.Order.OrderNumber);
        }
        
        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }

        protected string GetTaxHeader()
        {
            return CommerceBuilder.Taxes.TaxHelper.TaxColumnHeader;
        }

        private List<KeyValuePair<int, string>> GetShipMethodListDs(ICollection<ShipRateQuote> rateQuotes)
        {
            List<KeyValuePair<int, string>> ds = new List<KeyValuePair<int, string>>();
            foreach (ShipRateQuote quote in rateQuotes)
            {
                ds.Add(new KeyValuePair<int, string>(quote.ShipMethodId, quote.Name + " " + quote.TotalRate.LSCurrencyFormat("ulc")));
            }
            return ds;
        }

        protected decimal GetBasketSubtotal()
        {
            decimal basketTotal = 0;
            IList<BasketItem> displayItems = BasketHelper.GetDisplayItems(AbleContext.Current.User.Basket, true, true);
            foreach (BasketItem bi in displayItems)
            {
                basketTotal += InvoiceHelper.GetInvoiceExtendedPrice(bi);
            }

            return basketTotal;
        }
    }
}