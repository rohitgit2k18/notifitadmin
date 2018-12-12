namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Text.RegularExpressions;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;

    [Description("The common control used for creating an add-to-cart link for a product")]
    public partial class AddToCartLink : System.Web.UI.UserControl
    {
        public int ProductId { get; set; }

        protected void Page_Init(object sender, EventArgs e)
        {
            // MAKE SURE PROCESSING OF ADD TO CART ONLY HAPPENS ONCE
            // THERE CAN ONLY BE ONE EVENT TARGET IN A POSTBACK, BUT
            // THE ADD TO CART LINK MAY APPEAR MULTIPLE TIMES ON A PAGE
            if (Context.Items["AddToCart"] == null)
            {
                string eventTarget = Request.Form["__EVENTTARGET"];
                if (eventTarget != null)
                {
                    Match addRequest = Regex.Match(eventTarget, "\\$AddToCart_([0-9]+)$");
                    if (addRequest.Success)
                    {
                        int productId = AlwaysConvert.ToInt(addRequest.Groups[1].Value);
                        DoAddToCart(productId);
                        Context.Items["AddToCart"] = productId;
                    }
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Product product = ProductDataSource.Load(this.ProductId);
            if (product == null)
            {
                AC.Visible = false;
                MD.Visible = false;
            }
            else
            {
                if (AbleContext.Current.Store.Settings.ProductPurchasingDisabled
                    || product.DisablePurchase
                    || product.HasChoices
                    || product.UseVariablePrice
                    || product.IsSubscription
                    || (product.InventoryMode == InventoryMode.Product && product.InStock <= 0))
                {
                    // cannot click to add the indicated item to the cart
                    AC.Visible = false;
                    MD.Visible = true;
                    MD.NavigateUrl = product.NavigateUrl;
                }
                else
                {
                    AC.ID = "AddToCart_" + this.ProductId;
                    AC.Visible = true;
                    MD.Visible = false;
                }
            }
        }

        private void DoAddToCart(int productId)
        {
            //GET THE PRODUCT ID FROM THE URL
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                string lastShoppingUrl = AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl();
                if (product.HasChoices || product.UseVariablePrice)
                {
                    //CANT ADD DIRECTLY TO BASKET, SEND TO MORE INFO
                    Response.Redirect(product.NavigateUrl);
                }
                BasketItem basketItem = BasketItemDataSource.CreateForProduct(productId, 1);
                if (basketItem != null)
                {
                    // DETERMINE IF THE LICENSE AGREEMENT MUST BE REQUESTED
                    IList<LicenseAgreement> basketItemLicenseAgreements = new List<LicenseAgreement>();
                    basketItemLicenseAgreements.BuildCollection(basketItem, LicenseAgreementMode.OnAddToBasket);
                    if ((basketItemLicenseAgreements.Count > 0))
                    {
                        // THESE AGREEMENTS MUST BE ACCEPTED TO ADD TO CART
                        List<BasketItem> basketItems = new List<BasketItem>();
                        basketItems.Add(basketItem);
                        string guidKey = Guid.NewGuid().ToString("N");
                        Cache.Add(guidKey, basketItems, null, System.Web.Caching.Cache.NoAbsoluteExpiration, new TimeSpan(0, 10, 0), System.Web.Caching.CacheItemPriority.NotRemovable, null);
                        string acceptUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Basket.aspx"));
                        string declineUrl = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(Page.ResolveUrl(product.NavigateUrl)));
                        Response.Redirect("~/BuyWithAgreement.aspx?Items=" + guidKey + "&AcceptUrl=" + acceptUrl + "&DeclineUrl=" + declineUrl);
                    }

                    //ADD ITEM TO BASKET
                    Basket basket = AbleContext.Current.User.Basket;
                    basketItem.Basket = basket;
                    basket.Items.Add(basketItem);
                    basket.Save();

                    //Determine if there are associated Upsell products
                    if (AbleContext.Current.StoreMode == StoreMode.Standard && basketItem.Product.GetUpsellProducts(basket).Count > 0)
                    {
                        //redirect to upsell page
                        string returnUrl = AbleCommerce.Code.NavigationHelper.GetEncodedReturnUrl();
                        Response.Redirect("~/ProductAccessories.aspx?ProductId=" + basketItem.Product.Id + "&ReturnUrl=" + returnUrl);
                    }

                    // IF BASKET HAVE SOME VALIDATION PROBLEMS MOVE TO BASKET PAGE
                    IBasketService service = AbleContext.Resolve<IBasketService>();
                    ValidationResponse response = service.Validate(basket);
                    if (!response.Success)
                    {
                        Session["BasketMessage"] = response.WarningMessages;
                        Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
                    }

                    //IF THERE IS NO REGISTERED BASKET CONTROL, WE MUST GO TO BASKET PAGE
                    if (!AbleCommerce.Code.PageHelper.HasBasketControl(Page)) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetBasketUrl());
                }
            }
        }
    }
}