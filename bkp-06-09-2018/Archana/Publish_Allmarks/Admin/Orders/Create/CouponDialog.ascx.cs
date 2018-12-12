namespace AbleCommerce.Admin.Orders.Create
{
    using System;
    using CommerceBuilder.Common;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class CouponDialog : System.Web.UI.UserControl
    {
        private int _UserId;
        private User _User;
        Basket _Basket;

        protected void Page_Load(object sender, EventArgs e)
        {
            // LOCATE THE USER THAT THE ORDER IS BEING PLACED FOR
            _UserId = AlwaysConvert.ToInt(Request.QueryString["UID"]);
            _User = UserDataSource.Load(_UserId);
            if (_User == null)
            {
                // UNKNOWN USER, HIDE THIS CONTROL
                this.Controls.Clear();
            }
            else
            {
                _Basket = _User.Basket;
                CouponCode.Attributes.Add("autocomplete", "off");
            }
        }

        protected void ApplyCouponButton_Click(object sender, EventArgs e)
        {
            ValidCouponMessage.Visible = false;
            CouponCode.Text = StringHelper.StripHtml(CouponCode.Text);
            Coupon coupon = CouponDataSource.LoadForCouponCode(CouponCode.Text);
            String couponValidityMessage = String.Empty;
            ICouponCalculator couponCalculator = AbleContext.Resolve<ICouponCalculator>();
            if (coupon != null)
            {
                if (!couponCalculator.IsCouponAlreadyUsed(_Basket, coupon))
                {
                    if (couponCalculator.IsCouponValid(_Basket, coupon, out couponValidityMessage))
                    {
                        BasketCoupon recentCoupon = new BasketCoupon(_Basket, coupon);
                        _Basket.BasketCoupons.Add(recentCoupon);
                        // APPLY COUPON COMBINE RULE
                        //THE RULE: 
                        //If most recently applied coupon is marked "do not combine", then all previously
                        //entered coupons must be removed from _Basket.

                        //If most recently applied coupon is marked "combine", then remove any applied
                        //coupon that is marked "do not combine".  (Logically, in this instance there
                        //could be at most one other coupon of this type...)
                        string previousCouponsRemoved = "";

                        if (recentCoupon.Coupon.AllowCombine)
                        {
                            //IF ALLOW COMBINE, REMOVE ALL PREVIOUS NOCOMBINE COUPONS
                            for (int i = (_Basket.BasketCoupons.Count - 1); i >= 0; i--)
                            {
                                if (!_Basket.BasketCoupons[i].Coupon.AllowCombine)
                                {
                                    if (previousCouponsRemoved.Length > 0)
                                    {
                                        previousCouponsRemoved += "," + _Basket.BasketCoupons[i].Coupon.Name;
                                    }
                                    else
                                    {
                                        previousCouponsRemoved = _Basket.BasketCoupons[i].Coupon.Name;
                                    }

                                    _Basket.BasketCoupons.DeleteAt(i);
                                }
                            }
                        }
                        else
                        {
                            //IF NOT ALLOW COMBINE, REMOVE ALL EXCEPT THIS COUPON
                            for (int i = (_Basket.BasketCoupons.Count - 1); i >= 0; i--)
                            {
                                if (_Basket.BasketCoupons[i] != recentCoupon)
                                {
                                    if (previousCouponsRemoved.Length > 0)
                                    {
                                        previousCouponsRemoved += "," + _Basket.BasketCoupons[i].Coupon.Name;
                                    }
                                    else
                                    {
                                        previousCouponsRemoved = _Basket.BasketCoupons[i].Coupon.Name;
                                    }
                                    _Basket.BasketCoupons.DeleteAt(i);
                                }
                            }
                        }

                        _Basket.Save();
                        IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
                        preCheckoutService.Recalculate(_Basket);
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
                    InvalidCouponMessage.Text = "The coupon code you've entered is already in use.<br /><br />";
                }
            }
            else
            {
                InvalidCouponMessage.Text = "The coupon code you've entered is invalid.<br /><br />";
            }
            CouponCode.Text = string.Empty;
            InvalidCouponMessage.Visible = !ValidCouponMessage.Visible;
        }
    }
}