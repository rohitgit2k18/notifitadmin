namespace AbleCommerce.Checkout
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI.WebControls;
    using AbleCommerce.ConLib.Checkout;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;

    public partial class GiftOptions : CommerceBuilder.UI.AbleCommercePage
    {
        BasketItem _BasketItem;

        protected void Page_Load(object sender, EventArgs e)
        {
            // locate the basket item to set gift options for
            int basketItemId = AlwaysConvert.ToInt(Request.QueryString["i"]);
            Basket basket = AbleContext.Current.User.Basket;
            _BasketItem = basket.Items.FirstOrDefault(bi => bi.Id.Equals(basketItemId));
            if (_BasketItem == null || _BasketItem.Product == null || _BasketItem.Product.WrapGroup == null)
            {
                // unknown item or item is not eligible for gift wrap
                Response.Redirect("ShipMethod.aspx");
            }

            // update shipping address
            ShippingAddress.ShipmentId = _BasketItem.ShipmentId;

            // bind list
            GiftItemsGrid.DataSource = GetGiftItemsList(_BasketItem);
            GiftItemsGrid.DataBind();
        }

        private IList<BasketItemGiftOption> GetGiftItemsList(BasketItem basketItem)
        {
            // create the list of items
            List<BasketItemGiftOption> giftItems = new List<BasketItemGiftOption>();
            for (int i = 0; i < basketItem.Quantity; i++)
            {
                giftItems.Add(new BasketItemGiftOption(basketItem));
            }
            return giftItems;
        }

        protected void ContinueButton_Click(object sender, EventArgs e)
        {
            // LOOP EACH ITEM ROW TO DETERMINE GIFT OPTIONS
            List<BasketItemGiftOption> giftOptions = new List<BasketItemGiftOption>();
            foreach (GridViewRow row in GiftItemsGrid.Rows)
            {
                GiftWrapChoices wrapOptions = (GiftWrapChoices)row.FindControl("GiftWrapChoices");
                int wrapStyleId = wrapOptions.WrapStyleId;
                string giftMessage = wrapOptions.GiftMessage;
                BasketItemGiftOption optionItem = new BasketItemGiftOption(_BasketItem, wrapStyleId, giftMessage);
                int existingIndex = giftOptions.IndexOf(optionItem);
                if (existingIndex > -1) giftOptions[existingIndex].Quantity++;
                else giftOptions.Add(optionItem);
            }

            // LOOP THROUGH GIFT OPTIONS AND UPDATE BASKET ITEMS
            Basket basket = AbleContext.Current.User.Basket;
            for (int i = 0; i < giftOptions.Count; i++)
            {
                BasketItemGiftOption giftOptionItem = giftOptions[i];
                if (i == 0)
                {
                    // FOR FIRST GIFT OPTION, UPDATE THE ORIGINAL BASKET ITEM
                    _BasketItem.Quantity = giftOptionItem.Quantity;
                    _BasketItem.WrapStyleId = giftOptionItem.WrapStyleId;
                    _BasketItem.GiftMessage = giftOptionItem.GiftMessage;
                }
                else
                {
                    // FOR ADDTIONAL GIFT OPTIONS, CREATE COPIES OF THE ORIGINAL BASKET ITEM
                    BasketItem newItem = _BasketItem.Copy();
                    newItem.Quantity = giftOptionItem.Quantity;
                    newItem.GiftMessage = giftOptionItem.GiftMessage;
                    newItem.WrapStyleId = giftOptionItem.WrapStyleId;
                    basket.Items.Add(newItem);
                }
            }

            // SAVE, COMBINE, AND RETURN TO THE SHIP METHODS PAGE
            basket.Save();
            IBasketService basketService = AbleContext.Resolve<IBasketService>();
            basketService.Combine(basket);
            Response.Redirect("ShipMethod.aspx");
        }

        /// <summary>
        /// Used to divide up the basket items with differing gift options.
        /// </summary>
        private class BasketItemGiftOption
        {
            public BasketItem BasketItem { get; private set; }
            public int WrapStyleId { get; private set; }
            public string GiftMessage { get; private set; }
            public short Quantity { get; set; }
            public Product Product { get { return this.BasketItem.Product; } }

            public BasketItemGiftOption(BasketItem basketItem)
                : this(basketItem, basketItem.WrapStyleId, basketItem.GiftMessage)
            { }

            public BasketItemGiftOption(BasketItem basketItem, int wrapStyleId, string giftMessage)
            {
                this.BasketItem = basketItem;
                this.WrapStyleId = wrapStyleId;
                this.GiftMessage = giftMessage;
                this.Quantity = 1;
            }

            public override bool Equals(object obj)
            {
                BasketItemGiftOption other = (BasketItemGiftOption)obj;
                return this.WrapStyleId.Equals(other.WrapStyleId) && this.GiftMessage.Equals(other.GiftMessage);
            }

            public override int GetHashCode()
            {
                string hashable = this.WrapStyleId.ToString() + "_" + this.GiftMessage;
                return hashable.GetHashCode();
            }
        }
    }
}