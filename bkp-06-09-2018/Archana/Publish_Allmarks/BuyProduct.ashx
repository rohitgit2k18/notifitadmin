<%@ WebHandler Language="C#" Class="AbleCommerce.BuyProduct" %>

using System;
using System.Collections.Generic;
using System.Web;
using CommerceBuilder.Common;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Utility;

namespace AbleCommerce
{
    public class BuyProduct : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string lastShoppingUrl = AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl();
            //GET THE PRODUCT ID FROM THE URL
            int productId = AlwaysConvert.ToInt(context.Request.QueryString["p"]);
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                if (product.HasChoices || product.IsSubscription || product.DisablePurchase || product.UseVariablePrice)
                {
                    //CANT ADD DIRECTLY TO BASKET, SEND TO MORE INFO
                    context.Response.Redirect(product.NavigateUrl);
                }
                BasketItem basketItem = GetBasketItem(productId);

                // DETERMINE IF THE LICENSE AGREEMENT MUST BE REQUESTED
                IList<LicenseAgreement> basketItemLicenseAgreements = new List<LicenseAgreement>();
                basketItemLicenseAgreements.BuildCollection(basketItem, LicenseAgreementMode.OnAddToBasket);
                if ((basketItemLicenseAgreements.Count > 0))
                {
                    // THESE AGREEMENTS MUST BE ACCEPTED TO ADD TO BASKET
                    List<BasketItem> basketItems = new List<BasketItem>();
                    basketItems.Add(basketItem);
                    string guidKey = Guid.NewGuid().ToString("N");
                    context.Cache.Add(guidKey, basketItems, null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(0, 10, 0), System.Web.Caching.CacheItemPriority.NotRemovable, null);
                    string acceptUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Basket.aspx"));
                    string declineUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(lastShoppingUrl));
                    context.Response.Redirect("~/BuyWithAgreement.aspx?Items=" + guidKey + "&AcceptUrl=" + acceptUrl + "&DeclineUrl=" + declineUrl);
                }
                Basket basket = AbleContext.Current.User.Basket;
                basket.Items.Add(basketItem);
                basket.Save();

                //Determine if there are associated Upsell products
                if (basketItem.Product.GetUpsellProducts(basket).Count > 0)
                {
                    //redirect to upsell page
                    string returnUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(lastShoppingUrl));
                    context.Response.Redirect("ProductAccessories.aspx?ProductId=" + basketItem.Product.Id + "&ReturnUrl=" + returnUrl);
                }

                context.Response.Redirect("~/Basket.aspx");
            }
            context.Response.Redirect(lastShoppingUrl);
        }

        private BasketItem GetBasketItem(int productId)
        {
            BasketItem basketItem = BasketItemDataSource.CreateForProduct(productId, 1);
            return basketItem;
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

    }
}