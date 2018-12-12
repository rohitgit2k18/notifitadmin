namespace AbleCommerce.Admin.Orders
{
    using System;
    using System.Collections.Specialized;
    using System.Text;
    using System.Web.UI;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Payments;
    using CommerceBuilder.Utility;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Products;
    using System.Collections.Generic;
    using CommerceBuilder.Common;

    public partial class OrderMenu : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool hasSubscription = false;
            bool hasGiftCertificate = false;
            Order order = LoadOrder();
            IList<OrderItem> items = order.Items;

            if (order != null)
            {
                NameValueCollection menuLinks = new NameValueCollection();
                menuLinks.Add("Summary", "ViewOrder.aspx");
                menuLinks.Add("Payments", "Payments/Default.aspx");
                menuLinks.Add("Shipments", "Shipments/Default.aspx");
                menuLinks.Add("Items", "Edit/EditOrderItems.aspx");
                menuLinks.Add("Returns", "Edit/ReturnItems.aspx");
                menuLinks.Add("Notes", "OrderHistory.aspx");
                menuLinks.Add("Addresses", "EditAddresses.aspx");

                foreach (OrderItem item in items)
                {
                    if (item.Subscriptions.Count > 0 || (item.Product != null && item.Product.IsSubscription))
                        hasSubscription = true;

                    if (item.GiftCertificates.Count > 0 || (item.Product != null && item.Product.IsGiftCertificate))
                        hasGiftCertificate = true;
                }

                if (hasSubscription)
                    menuLinks.Add("Subscriptions", "ViewSubscriptions.aspx");

                if (DigitalGoodDataSource.CountForStore(AbleContext.Current.StoreId) > 0)
                    menuLinks.Add("Digital Goods", "ViewDigitalGoods.aspx");

                if (hasGiftCertificate)
                    menuLinks.Add("Gift Certificates", "ViewGiftCertificates.aspx");
               
                string suffix = "?OrderNumber=" + order.OrderNumber.ToString();
                string activeMenu = GetActiveMenu(Request.Url);
                StringBuilder menu = new StringBuilder();
                menu.AppendLine("<div class=\"secondaryMenu\">");
                menu.AppendLine("<ul>");
                foreach (string key in menuLinks.AllKeys)
                {
                    if (key == activeMenu)
                    {
                        menu.Append("<li class=\"active\">");
                    }
                    else
                    {
                        menu.Append("<li>");
                    }
                    menu.AppendLine("<a href=\"" + Page.ResolveUrl("~/Admin/Orders/" + menuLinks[key]) + suffix + "\">" + key + "</a></li>");
                }

                // customer profile link should only show if there is a user
                // and this link can never be active
                if (order.User != null)
                {
                    menu.AppendLine("<li><a href=\"" + Page.ResolveUrl("~/Admin/People/Users/EditUser.aspx?UserId=" + order.User.Id) + "\">Customer Profile</a></li>");
                }

                menu.AppendLine("</ul>");
                menu.AppendLine("</div>");
                MenuContent.Text = menu.ToString();

            }
            else
            {
                // no order, do not display menu
                this.Controls.Clear();
            }
        }

        private Order LoadOrder()
        {
            // FIRST CHECK FOR ORDER
            Order order = AbleCommerce.Code.OrderHelper.GetOrderFromContext();
            if (order == null)
            {
                // NEXT CHECK FOR PAYMENT
                int paymentId = AlwaysConvert.ToInt(Request.QueryString["PaymentId"]);
                Payment payment = PaymentDataSource.Load(paymentId);
                if (payment != null)
                {
                    order = payment.Order;
                }
                else
                {
                    // NEXT CHECK FOR SHIPMENT
                    int orderShipmentId = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
                    OrderShipment orderShipment = OrderShipmentDataSource.Load(orderShipmentId);
                    if (orderShipment != null)
                    {
                        order = orderShipment.Order;
                    }
                }
            }
            return order;
        }

        private string GetActiveMenu(Uri url)
        {
            string fileName = url.Segments[url.Segments.Length - 1].ToLowerInvariant();
            switch (fileName)
            {
                case "addpayment.aspx":
                case "editpayment.aspx":
                case "capturepayment.aspx":
                case "voidpayment.aspx":
                case "refundpayment.aspx":
                    return "Payments";
                case "default.aspx":
                    string filePath = Request.Url.AbsolutePath.ToString().ToLowerInvariant();
                    if (filePath.EndsWith("payments/default.aspx")) return "Payments";
                    else if (filePath.EndsWith("shipments/default.aspx")) return "Shipments";
                    break;
                case "addshipment.aspx":
                case "deleteshipment.aspx":
                case "editshipment.aspx":
                case "mergeshipment.aspx":
                case "splitshipment.aspx":
                case "returnshipment.aspx":
                case "shiporder.aspx":
                    return "Shipments";
                case "editorderitems.aspx":
                    return "Items";
                case "returnitems.aspx":
                    return "Returns";
                case "viewdigitalgoods.aspx":
                case "adddigitalgoods.aspx":
                case "adddigitalgoodserialkey.aspx":
                case "viewdigitalgoodserialkey.aspx":
                case "viewdownloads.aspx":
                    return "Digital Goods";
                case "orderhistory.aspx":
                    return "Notes";
                    case "editaddresses.aspx":
                    return "Addresses";
                case "viewsubscriptions.aspx":
                    return "Subscriptions";
                case "addproduct.aspx":
                case "findproduct.aspx":
                case "addother.aspx":
                    string tempFilePath = Request.Url.AbsolutePath.ToString();
                    if (tempFilePath.Contains("/Shipments/")) return "Shipments";
                    else return "Edit Order Items";
                case "viewgiftcertificates.aspx":
                    return "Gift Certificates";
            }

            // default case
            return "Summary";
        }
    }
}