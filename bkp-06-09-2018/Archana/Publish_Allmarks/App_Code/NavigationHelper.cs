namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using System.Text.RegularExpressions;
    using System.Web;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;

    /// <summary>
    /// Utility methods to assist with navigation around the store when URIs may require dynamic construction.
    /// </summary>
    public static class NavigationHelper
    {
        /// <summary>
        /// Gets the current URL encoded for inclusion in the query string.
        /// </summary>
        public static string GetEncodedReturnUrl()
        {
            string returnUrl = AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl();
            return Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(returnUrl));
        }

        /// <summary>
        /// checks for a return url specified in the query string
        /// </summary>
        /// <param name="defaultUrl">default value if no url found in query string</param>
        /// <returns>The return url specified, or the default url if none found in query string.</returns>
        public static string GetReturnUrl(string defaultUrl)
        {
            HttpContext context = HttpContext.Current;
            if (context == null) return defaultUrl;
            HttpRequest request = context.Request;
            string encodedUrl = request.QueryString["ReturnUrl"];
            string decodedUrl;
            try
            {
                decodedUrl = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(encodedUrl));
            }
            catch
            {
                decodedUrl = encodedUrl;
            }
            if (string.IsNullOrEmpty(decodedUrl)) decodedUrl = defaultUrl;
            string baseUrl;
            if (!request.IsSecureConnection)
            {
                int port = request.Url.Port;
                if (port == 80) baseUrl = "http://" + request.Url.Authority;
                else baseUrl = "http://" + request.Url.Authority + ":" + port.ToString();
            }
            else
            {
                int port = request.Url.Port;
                if (port == 443) baseUrl = "https://" + request.Url.Authority;
                else baseUrl = "https://" + request.Url.Authority + ":" + port.ToString();
            }
            if (decodedUrl.StartsWith(baseUrl)) decodedUrl = decodedUrl.Substring(baseUrl.Length);
            return decodedUrl;
        }

        /// <summary>
        /// Gets the base admin URL
        /// </summary>
        /// <returns>A string containing the base admin url</returns>
        public static string GetAdminUrl()
        {
            return GetAdminUrl(string.Empty);
        }

        /// <summary>
        /// Gets the admin url for the given path
        /// </summary>
        /// <param name="path">The path to the admin file, relative to the base admin folder.</param>
        /// <returns>A string containing the admin url</returns>
        public static string GetAdminUrl(string path)
        {
            return "~/Admin/" + path;
        }


        /// <summary>
        /// Gets the mobile store home page url
        /// </summary>
        /// <returns>A string containing the mobile store home page url</returns>
        public static string GetMobileStoreUrl()
        {
            return GetMobileStoreUrl(string.Empty);
        }

        /// <summary>
        /// Gets the mobiel store url for the given path
        /// </summary>
        /// <param name="path">The path to the more store file, relative to the base mobile store folder.</param>
        /// <returns>A string containing the mobile store url</returns>
        public static string GetMobileStoreUrl(string path)
        {
            if (!path.StartsWith("~/"))
            {
                if (path.StartsWith("/"))
                {
                    path = "~" + path;
                }
                else
                {
                    path = "~/" + path;
                }
            }

            string mobileDomain = AbleContext.Current.Store.Settings.MobileStoreDomain;
            if (string.IsNullOrEmpty(mobileDomain))
            {
                if (!path.ToLower().StartsWith("~/mobile/"))
                    return path.Insert(2, "mobile/");
            }
            else
            {
                mobileDomain = string.Format("http://{0}/", mobileDomain);
                return path.Replace("~/", mobileDomain);
            }

            return path;
        }

        /// <summary>
        /// Gets the url to the store home page
        /// </summary>
        /// <returns>A string containing the url to the store home page</returns>
        public static string GetStoreUrl(Page page)
        {
            return page.ResolveUrl(GetHomeUrl());
        }

        /// <summary>
        /// Gets the url for the given path
        /// </summary>
        /// <param name="path">The path to the file, relative to the store folder.</param>
        /// <returns>A string containing the admin url</returns>
        public static string GetStoreUrl(Page page, string path)
        {
            return page.ResolveUrl("~/" + path);
        }

        /// <summary>
        /// Gets the url to the store homepage.
        /// </summary>
        /// <returns>A string containting the url to the store homepage</returns>
        public static string GetHomeUrl()
        {
            return IsMobileStoreMode() ? GetMobileStoreUrl("~/Default.aspx") : "~/Default.aspx";
        }

        /// <summary>
        /// Gets the url required to begin checkout
        /// </summary>
        /// <returns>A string containing the checkout url</returns>
        public static string GetBasketUrl()
        {
            return IsMobileStoreMode() ? GetMobileStoreUrl("~/Basket.aspx") : "~/Basket.aspx";
        }

        /// <summary>
        /// Gets the url for setting ship methods within the checkout process.
        /// </summary>
        /// <returns>A string containing the ship methods url</returns>
        public static string GetShipMethodUrl()
        {
            if (AbleContext.Current.StoreMode == StoreMode.Mobile) return GetMobileStoreUrl("~/Checkout/ShipMethod.aspx");
            return "~/Checkout/ShipMethod.aspx";
        }

        /// <summary>
        /// Gets the url for submitting payment within the checkout process.
        /// </summary>
        /// <returns>A string containing the payment url</returns>
        public static string GetPaymentUrl()
        {
            if (AbleContext.Current.StoreMode == StoreMode.Mobile) return GetMobileStoreUrl("~/Checkout/Payment.aspx");
            return "~/Checkout/Payment.aspx";
        }

        /// <summary>
        /// Gets the url required to view an order.
        /// </summary>
        /// <param name="orderId">The ID of the order to be viewed.</param>
        /// <returns>A string containing the view order url</returns>
        public static string GetViewOrderUrl(int orderId)
        {
            int orderNumber = OrderDataSource.LookupOrderNumber(orderId);
            if (AbleContext.Current.StoreMode == StoreMode.Standard)
                return string.Format("~/Members/MyOrder.aspx?OrderNumber={0}", orderNumber);
            else
                return GetMobileStoreUrl(string.Format("~/Members/MyOrder.aspx?OrderNumber={0}", orderNumber));
        }

        /// <summary>
        /// Gets the url to display a receipt to the customer.
        /// </summary>
        /// <param name="orderId">The order number to display a receipt for.</param>
        /// <returns>A string containing the url to display an order receipt</returns>
        public static string GetReceiptUrl(int orderNumber)
        {
            if(AbleContext.Current.StoreMode == StoreMode.Standard)
                return string.Format("~/Checkout/Receipt.aspx?OrderNumber={0}", orderNumber);
            else
                return GetMobileStoreUrl(string.Format("~/Checkout/Receipt.aspx?OrderNumber={0}", orderNumber));
        }

        /// <summary>
        /// Gets the url required to begin checkout
        /// </summary>
        /// <returns>A string containing the checkout url</returns>
        public static string GetCheckoutUrl()
        {
            return GetCheckoutUrl(HttpContext.Current.User.Identity.IsAuthenticated);
        }

        /// <summary>
        /// Gets the url required to begin checkout
        /// </summary>
        /// <param name="isAuthenticated">A flag indicating whether the URL should be returned for an authenticated user.</param>
        /// <returns>A string containing the checkout url</returns>
        /// <remarks>Authenticated users may have a different checkout starting point than anonymous users.</remarks>
        public static string GetCheckoutUrl(bool isAuthenticated)
        {
            StoreMode mode = AbleContext.Current.StoreMode;
            if (isAuthenticated)
            {
                return mode == StoreMode.Standard ? GetStandardCheckoutUrl(true) : GetMobileStoreUrl("~/Checkout/EditBillAddress.aspx");
            }
            return mode == StoreMode.Standard ? GetStandardCheckoutUrl(false) : GetMobileStoreUrl("~/Checkout/Default.aspx");
        }

        /// <summary>
        /// Gets the last shopping url for the current user.
        /// </summary>
        /// <returns>The last shopping url for the current user.</returns>
        public static string GetLastShoppingUrl()
        {
            string searchUrl = GetSearchPageUrl();
            string viewWishlistUrl = IsMobileStoreMode() ? GetMobileStoreUrl("~/ViewWishlist.aspx") : "~/ViewWishlist.aspx";

            HttpContext context = HttpContext.Current;
            if (context == null) return GetHomeUrl() ;
            Page page = context.Handler as Page;
            if (page == null) return GetHomeUrl();
            IList<PageVisit> pageViews = PageVisitHelper.GetUserPageVisits();
            pageViews.Sort("ActivityDate", CommerceBuilder.Common.SortDirection.DESC);
            string homePage = page.ResolveUrl(GetHomeUrl());
            string searchPage = page.ResolveUrl(searchUrl);
            string wishlistPage = page.ResolveUrl(viewWishlistUrl);
            foreach (PageVisit pageView in pageViews)
            {
                if ((pageView.UriStem == homePage) || (pageView.UriStem == searchPage) || (pageView.UriStem == wishlistPage)) return pageView.UriStem + "?" + pageView.UriQuery;
                if (pageView.CatalogNodeId != 0)
                {
                    ICatalogable node = pageView.CatalogNode;
                    if ((node != null) && ((pageView.CatalogNodeType == CatalogNodeType.Category) || (pageView.CatalogNodeType == CatalogNodeType.Product)))
                    {
                        // WE NEED TO APPEND THE QUERYSTRING PARAMETERS  (EXCEPT CATALOGE NODE ID RELATED PARAM)
                        return node.NavigateUrl + RemoveCatalogNodeParameters(pageView.UriQuery);
                    }
                }
            }
            return homePage;
        }

        [Obsolete("Use IsMobileStoreMode instead")]
        public static bool IsMobileStore()
        {
            return AbleContext.Current.StoreMode == StoreMode.Mobile;
        }

        public static bool IsMobileStoreMode()
        {
            return AbleContext.Current.StoreMode == StoreMode.Mobile;
        }

        public static string GetSearchPageUrl()
        {
            return IsMobileStoreMode() ? GetMobileStoreUrl("~/Search.aspx") : "~/Search.aspx";
        }

        

        /// <summary>
        /// Remove the catalog node id information from string
        /// </summary>
        /// <param name="originalUriQuery"></param>
        /// <returns></returns>
        private static string RemoveCatalogNodeParameters(string originalUriQuery)
        {
            if (string.IsNullOrEmpty(originalUriQuery)) return string.Empty;
            string result = "?" + originalUriQuery;
            try
            {
                Match match = Regex.Match(result, "(.*?)(categoryid|productid|linkid|webpageid)=(\\d+)(.*)", RegexOptions.IgnoreCase);
                while (match.Success)
                {
                    if (string.IsNullOrEmpty(match.Groups[1].Value) && string.IsNullOrEmpty(match.Groups[4].Value))
                        result = string.Empty;
                    else
                    {
                        result = match.Groups[1].Value + match.Groups[4].Value;
                        result = result.Replace("?&", "?");
                        result = result.Replace("&&", "&");
                    }
                    match = Regex.Match(result, "(.*?)(categoryid|productid|linkid|webpageid)=(\\d+)(.*)", RegexOptions.IgnoreCase);
                }
            }
            catch (ArgumentException)
            {
                // ignore Syntax error in the regular expression
            }

            if (result == "?") return string.Empty;
            else return result;
        }

        public static string GetPublishIconUrl(object catalogNode)
        {
            return GetPublishIconUrl(((CatalogNode)catalogNode).Visibility);
        }

        public static string GetPublishIconUrl(CatalogVisibility visibility)
        {
            HttpContext context = HttpContext.Current;
            Page page = context.Handler as Page;
            if (page != null)
            {
                string theme = page.Theme;
                if (string.IsNullOrEmpty(theme)) theme = page.StyleSheetTheme;
                string baseImagesFolder = (string.IsNullOrEmpty(theme) ? "~/Images/Icons/" : "~/App_Themes/" + theme + "/Images/Icons/");
                switch (visibility)
                {
                    case CatalogVisibility.Public:
                        return baseImagesFolder + "CmsPublic.png";
                    case CatalogVisibility.Hidden:
                        return baseImagesFolder + "CmsHidden.png";
                    default:
                        return baseImagesFolder + "CmsPrivate.png";
                }
            }
            return string.Empty;
        }

        /// <summary>
        /// Gets an image from the current theme, if set.
        /// </summary>
        /// <param name="relativeImagePath">Image path relative to the base theme iamges folder</param>
        /// <returns>An absolute url for the image resource</returns>
        public static string GetThemeImageUrl(string relativeImagePath)
        {
            HttpContext context = HttpContext.Current;
            Page page = context.Handler as Page;
            if (page != null)
            {
                string theme = page.Theme;
                if (string.IsNullOrEmpty(theme)) theme = page.StyleSheetTheme;
                string baseImagesFolder = (string.IsNullOrEmpty(theme) ? "~/Images/" : "~/App_Themes/" + theme + "/Images/");
                return page.ResolveUrl(baseImagesFolder + relativeImagePath);
            }
            return relativeImagePath;
        }

        public static List<PagerLinkData> GetPaginationLinks(int currentPagerIndex, int totalPages, string baseUrl)
        {
            List<PagerLinkData> pagerLinkData = new List<PagerLinkData>();

            baseUrl += "p=";
            string navigateUrl;
            // CALCULATE THE START AND END INDEX FOR PAGER
            int startPagerIndex = 0;
            int lastPagerIndex = totalPages - 1;

            int pagerRange = 5; // NUMBER OF LINKS BEFORE AND AFTER THE CURRENT PAGE LINK

            if (currentPagerIndex > pagerRange) startPagerIndex = currentPagerIndex - pagerRange;

            if (lastPagerIndex > (currentPagerIndex + pagerRange)) lastPagerIndex = currentPagerIndex + pagerRange;

            if (startPagerIndex > 0)
            {
                navigateUrl = baseUrl + (currentPagerIndex - 1).ToString();
                pagerLinkData.Add(new PagerLinkData("<", navigateUrl, (currentPagerIndex - 1), true));
            }

            int pageIndexCounter = startPagerIndex;
            while (pageIndexCounter <= lastPagerIndex)
            {
                string linkText = ((int)(pageIndexCounter + 1)).ToString();
                if (pageIndexCounter != currentPagerIndex)
                {
                    navigateUrl = baseUrl + pageIndexCounter.ToString();
                    pagerLinkData.Add(new PagerLinkData(linkText, navigateUrl, pageIndexCounter, (pageIndexCounter != currentPagerIndex)));
                }
                else
                {
                    navigateUrl = "#";
                    pagerLinkData.Add(new PagerLinkData(linkText, navigateUrl, pageIndexCounter, (pageIndexCounter != currentPagerIndex), "current"));
                }
                pageIndexCounter++;
            }
            if (lastPagerIndex < (totalPages - 1))
            {
                navigateUrl = baseUrl + (currentPagerIndex + 1).ToString();
                pagerLinkData.Add(new PagerLinkData(">", navigateUrl, currentPagerIndex + 1, true));
            }
            return pagerLinkData;
        }

        public static void Trigger404(HttpResponse response, string statusDescription)
        {
            if (HttpContext.Current.IsCustomErrorEnabled)
            {
                throw new HttpException(404, statusDescription);
            }
            else
            {
                response.Clear();
                response.Status = "404 Not Found";
                response.StatusDescription = statusDescription;
                response.End();
            }
        }

        public static void Trigger403(HttpResponse response, string statusDescription)
        {
            response.Clear();
            response.Status = "403 Forbidden";
            response.StatusDescription = statusDescription;
            response.End();
        }

        private static string GetStandardCheckoutUrl(bool isAuthenticated)
        {
            if (AbleContext.Current.Store.Settings.EnableOnePageCheckout)
            {
                return isAuthenticated ? "~/Checkout/OPC.aspx" : "~/Checkout/OPC.aspx";
            }
            else
            {
                return isAuthenticated ? "~/Checkout/EditBillAddress.aspx" : "~/Checkout/Default.aspx";
            }
        }

        /// <summary>
        /// Gets the url for the quote page.
        /// </summary>
        /// <returns>A string containing the quote pages url</returns>
        public static string GetQuotePageUrl()
        {
            if (AbleContext.Current.StoreMode == StoreMode.Mobile) return GetMobileStoreUrl("~/Quote.aspx");
            return "~/Quote.aspx";
        }
    }

    public class PagerLinkData
    {
        private string _Text;
        private int _PageIndex;
        private string _NavigateUrl;
        public int PageIndex { get { return _PageIndex; } }
        private bool _Enabled;
        public string Text { get { return _Text; } }
        public string NavigateUrl { get { return _NavigateUrl; } }
        public bool Enabled { get { return _Enabled; } }
        private string _tagClass;
        public string TagClass { get { return _tagClass; } set { _tagClass = value; } }
        public PagerLinkData(string text, string navigateUrl, int pageIndex, bool enabled)
        {
            _Text = text;
            _NavigateUrl = navigateUrl;
            _PageIndex = pageIndex;
            _Enabled = enabled;
        }

        public PagerLinkData(string text, string navigateUrl, int pageIndex, bool enabled, string tagClass)
        {
            _Text = text;
            _NavigateUrl = navigateUrl;
            _PageIndex = pageIndex;
            _Enabled = enabled;
            _tagClass = tagClass;
        }
    }
}