namespace AbleCommerce.ConLib
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Utility;

    [Description("Displays a form where a customer can enter coupon or promotional codes.")]
    public partial class CouponDialog : System.Web.UI.UserControl
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            string valueFromPost = Request.Form[ApplyCouponButton.UniqueID];
            if (valueFromPost == this.ApplyCouponButton.Text)
            {
                // APPLY COUPON WAS CLICKED, INTERCEPT BEFORE OTHER PROCESSING
                ApplyCoupon();
                Context.Items["CouponApplied"] = true;
            }
            AbleCommerce.Code.PageHelper.SetDefaultButton(CouponCode, ApplyCouponButton.ClientID);
            CouponCode.Attributes.Add("autocomplete", "off");
        }

        protected void ApplyCouponButton_Click(object sender, EventArgs e)
        {
            if (!Context.Items.Contains("CouponApplied"))
            {
                ApplyCoupon();
            }
            CouponCode.Text = string.Empty;
        }

        private void ApplyCoupon()
        {
            ValidCouponMessage.Visible = false;
            string couponCode = StringHelper.StripHtml(Request.Form[CouponCode.UniqueID]);
            Coupon coupon = CouponDataSource.LoadForCouponCode(couponCode);
            String couponValidityMessage = String.Empty;

            InvalidCouponMessage.Text = "Invalid coupon code.";
            if (coupon != null)
            {
                ICouponCalculator couponCalculator = AbleContext.Resolve<ICouponCalculator>();
                if (!couponCalculator.IsCouponAlreadyUsed(AbleContext.Current.User.Basket, coupon))
                {
                    if (couponCalculator.IsCouponValid(AbleContext.Current.User.Basket, coupon, out couponValidityMessage))
                    {
                        Basket basket = AbleContext.Current.User.Basket;
                        BasketCoupon recentCoupon = new BasketCoupon(AbleContext.Current.User.Basket, coupon);
                        recentCoupon.AppliedDate = LocaleHelper.LocalNow;
                        basket.BasketCoupons.Add(recentCoupon);
                        // APPLY COUPON COMBINE RULE
                        //THE RULE: 
                        //If most recently applied coupon is marked "do not combine", then all previously
                        //entered coupons must be removed from basket.

                        //If most recently applied coupon is marked "combine", then remove any applied
                        //coupon that is marked "do not combine".  (Logically, in this instance there
                        //could be at most one other coupon of this type...)
                        string previousCouponsRemoved = "";

                        if (recentCoupon.Coupon.AllowCombine)
                        {
                            //IF ALLOW COMBINE, REMOVE ALL PREVIOUS NOCOMBINE COUPONS
                            for (int i = (basket.BasketCoupons.Count - 1); i >= 0; i--)
                            {
                                if (!basket.BasketCoupons[i].Coupon.AllowCombine)
                                {
                                    if (previousCouponsRemoved.Length > 0)
                                    {
                                        previousCouponsRemoved += "," + basket.BasketCoupons[i].Coupon.Name;
                                    }
                                    else
                                    {
                                        previousCouponsRemoved = basket.BasketCoupons[i].Coupon.Name;
                                    }

                                    basket.BasketCoupons.DeleteAt(i);
                                }
                            }
                        }
                        else
                        {
                            //IF NOT ALLOW COMBINE, REMOVE ALL EXCEPT THIS COUPON
                            for (int i = (basket.BasketCoupons.Count - 1); i >= 0; i--)
                            {
                                if (basket.BasketCoupons[i] != recentCoupon)
                                {
                                    if (previousCouponsRemoved.Length > 0)
                                    {
                                        previousCouponsRemoved += "," + basket.BasketCoupons[i].Coupon.Name;
                                    }
                                    else
                                    {
                                        previousCouponsRemoved = basket.BasketCoupons[i].Coupon.Name;
                                    }
                                    basket.BasketCoupons.DeleteAt(i);
                                }
                            }
                        }

                        basket.Save();
                        IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                        preCheckoutService.Recalculate(basket);
                        if (previousCouponsRemoved.Length > 0)
                        {
                            if (recentCoupon.Coupon.AllowCombine)
                            {
                                CombineCouponRemoveMessage.Text = String.Format(CombineCouponRemoveMessage.Text, recentCoupon.Coupon.Name, previousCouponsRemoved, previousCouponsRemoved);
                                CombineCouponRemoveMessage.Visible = true;
                            }
                            else
                            {
                                NotCombineCouponRemoveMessage.Text = String.Format(NotCombineCouponRemoveMessage.Text, recentCoupon.Coupon.Name, previousCouponsRemoved);
                                NotCombineCouponRemoveMessage.Visible = true;
                            }
                        }
                        ValidCouponMessage.Visible = true;
                    }
                    else
                    {
                        InvalidCouponMessage.Text = couponValidityMessage + "<br /><br />";
                    }
                }
                else
                {
                    InvalidCouponMessage.Text = string.Format(InvalidCouponMessage.Text, "The coupon code you've entered is already in use.");
                }
            }
            else
            {
                InvalidCouponMessage.Text = string.Format(InvalidCouponMessage.Text, "The coupon code you've entered is invalid.");
            }
            InvalidCouponMessage.Visible = !ValidCouponMessage.Visible;
        }
    }
}