﻿namespace AbleCommerce
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Common;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;

    public partial class BuyWithAgreement : CommerceBuilder.UI.AbleCommercePage
    {
        private List<BasketItem> _BasketItems;
        private int[] _LicenseAgreementIds = null;
        private string _CacheKey = string.Empty;

        protected int DisplayIndex
        {
            get
            {
                if (ViewState["DisplayIndex"] == null) return 0;
                return (int)ViewState["DisplayIndex"];
            }
            set { ViewState["DisplayIndex"] = value; }
        }

        protected string AcceptUrl
        {
            get { return GetUrl("AcceptUrl"); }
        }

        protected string DeclineUrl
        {
            get { return GetUrl("DeclineUrl"); }
        }

        private string GetUrl(string paramName)
        {
            string url = Request.QueryString[paramName];
            if (!string.IsNullOrEmpty(url))
            {
                return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(url));
            }

            return  NavigationHelper.GetMobileStoreUrl("Default.aspx");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //INITIALIZE FORM
            if (!InitializeAgreements()) Response.Redirect(DeclineUrl);
            UpdateAgreementText();
        }

        private bool InitializeAgreements()
        {
            _CacheKey = Request.QueryString["Items"];
            if (!string.IsNullOrEmpty(_CacheKey))
            {
                //FIRST LOOK FOR ITEMS IN THE APPLICATION CACHE
                _BasketItems = (List<BasketItem>)Cache[_CacheKey];
                //VALIDATE THAT WE FOUND ITEMS
                if ((_BasketItems != null) && (_BasketItems.Count > 0))
                {
                    IList<LicenseAgreement> agreements = new List<LicenseAgreement>();
                    agreements.BuildCollection(_BasketItems[0], LicenseAgreementMode.OnAddToBasket);
                    _LicenseAgreementIds = agreements.GetLicenseAgreementIds();
                    //LOAD IS SUCCESSFUL IF WE FIND AGREEMENTS AND WE ARE WITHIN THE DISPLAY RANGE
                    return ((_LicenseAgreementIds != null) && (_LicenseAgreementIds.Length > 0) && (this.DisplayIndex < _LicenseAgreementIds.Length));
                }
            }
            return false;
        }

        private void UpdateAgreementText()
        {
            LicenseAgreement licenseAgreement = LicenseAgreementDataSource.Load(_LicenseAgreementIds[this.DisplayIndex]);
            if (licenseAgreement != null)
            {
                Page.Title = licenseAgreement.DisplayName;
                AgreementText.Text = licenseAgreement.AgreementText;
            }
        }

        protected void AcceptButton_Click(object sender, EventArgs e)
        {
            this.DisplayIndex++;
            if (this.DisplayIndex < _LicenseAgreementIds.Length)
            {
                //SHOW THE NEXT AGREEMENT
                UpdateAgreementText();
            }
            else
            {
                //ALL AGREEMENTS HAVE BEEN ACCEPTED
                //CLEAR ITEMS FROM APPLICATION CACHE
                Cache.Remove(_CacheKey);
                bool addToWishlist = AlwaysConvert.ToBool(Request.QueryString["ToWishlist"], false);

                if (addToWishlist)
                {
                    Wishlist wishlist = AbleContext.Current.User.PrimaryWishlist;
                    foreach (BasketItem item in _BasketItems)
                    {
                        wishlist.WishlistItems.Add(item);
                    }
                    wishlist.Save();
                }
                else
                {
                    //ADD PRODUCTS TO BASKET
                    Basket basket = AbleContext.Current.User.Basket;
                    foreach (BasketItem item in _BasketItems)
                    {
                        basket.Items.Add(item);
                    }
                    basket.Save();
                }
                //ROUTE TO ACCEPT URL
                Response.Redirect(AcceptUrl);
            }
        }

        protected void DeclineButton_Click(object sender, EventArgs e)
        {
            //AGREEMENT HAS BEEN DECLINED
            //CLEAR ITEMS FROM APPLICATION CACHE
            Cache.Remove(_CacheKey);
            //ROUTE TO DECLINE URL
            Response.Redirect(DeclineUrl);
        }
    }
}