namespace AbleCommerce.Code
{
    using System.Collections.Generic;
    using System.Web;
    using System.Web.SessionState;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public class ReorderHandler : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            HttpResponse Response = context.Response;
            //GET THE ORDER ID FROM THE URL
            int orderId = AlwaysConvert.ToInt(context.Request.QueryString["o"]);
            Order order = OrderDataSource.Load(orderId);
            if (order != null)
            {
                //MAKE SURE ORDER IS FOR CURRENT USER
                User user = AbleContext.Current.User;
                if (order.User != null && order.User.Id == user.Id)
                {
                    //CLEAR THE EXISTING BASKET
                    List<string> basketMessages = new List<string>();
                    Basket basket = user.Basket;
                    IBasketService basketService = AbleContext.Resolve<IBasketService>();
                    basketService.Clear(basket);
                    foreach (OrderItem item in order.Items)
                    {
                        if ((item.OrderItemType == OrderItemType.Product) && (!item.IsChildItem))
                        {
                            Product product = item.Product;
                            if ((product != null) && (product.Visibility != CommerceBuilder.Catalog.CatalogVisibility.Private))
                            {
                                BasketItem basketItem;
                                try
                                {
                                    basketItem = BasketItemDataSource.CreateForProduct(item.Product.Id, item.Quantity, item.OptionList, item.KitList);
                                    basketItem.IsSubscription = item.IsSubscription;
                                    if (!item.IsSubscription && item.Product != null)
                                        basketItem.IsSubscription = item.Product.IsSubscription;
                                    basketItem.Frequency = item.Frequency;
                                    basketItem.FrequencyUnit = item.FrequencyUnit;
                                }
                                catch
                                {
                                    string itemName = item.Name;
                                    if (!string.IsNullOrEmpty(item.VariantName)) itemName += " (" + item.VariantName + ")";
                                    basketMessages.Add("The item " + itemName + " is no longer available.");
                                    basketItem = null;
                                }
                                if (basketItem != null)
                                {
                                    //SEE IF A PRODUCT TEMPLATE IS ASSOCIATED
                                    foreach (ProductTemplate template in product.ProductTemplates)
                                    {
                                        if (template != null)
                                        {
                                            foreach (InputField inputField in template.InputFields)
                                            {
                                                if (!inputField.IsMerchantField)
                                                {
                                                    //COPY OVER ANY CUSTOMER INPUTS
                                                    BasketItemInput itemInput = new BasketItemInput();
                                                    itemInput.BasketItem = basketItem;
                                                    itemInput.InputField = inputField;
                                                    itemInput.InputValue = GetItemInputValue(item, inputField.Name);
                                                    basketItem.Inputs.Add(itemInput);
                                                }
                                            }
                                        }
                                    }
                                    if ((basketItem.OrderItemType == OrderItemType.Product) && (basketItem.Product.UseVariablePrice)) basketItem.Price = item.Price;
                                    basketItem.Basket = basket;
                                    basket.Items.Add(basketItem);
                                    //WE HAVE TO SAVE THE BASKET IN CASE IT IS NOT YET CREATED
                                    basket.Save();
                                }
                            }
                        }
                    }
                    if (context.Session != null) context.Session["BasketMessage"] = basketMessages;
                    Response.Redirect(NavigationHelper.GetBasketUrl());
                }
            }
            Response.Redirect(NavigationHelper.GetHomeUrl());
        }

        private static string GetItemInputValue(OrderItem item, string key)
        {
            foreach (OrderItemInput input in item.Inputs)
            {
                if (input.Name == key) return input.InputValue;
            }
            return string.Empty;
        }

        public bool IsReusable { get { return true; } }
    }
}