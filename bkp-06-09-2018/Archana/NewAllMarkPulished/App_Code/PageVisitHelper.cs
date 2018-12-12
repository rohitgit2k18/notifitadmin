//-----------------------------------------------------------------------
// <copyright file="PageVisitHelper.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Code
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using CommerceBuilder.Catalog;
    using System.Web;
    using System.Web.SessionState;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.DomainModel;

    /// <summary>
    /// Helper class to track catalog page visits using session.
    /// </summary>
    public class PageVisitHelper
    {
        private const string _sessionKey = "AC_USER_PAGE_VISITS";
        private const int _cacheSize = 20;

        /// <summary>
        /// Registers the catalog page visit
        /// </summary>
        /// <param name="nodeId">ID of the catalog node</param>
        /// <param name="nodeType">Type of the catalog node</param>
        /// <param name="pageTitle">Title of the page</param>
        /// <remarks>This is intended for use with page tracking</remarks>
        public static void RegisterPageVisit(int nodeId, CatalogNodeType nodeType, string pageTitle)
        {
            //REGISTER THE PAGEVIEW FOR PERSISTENT PAGE TRACKING
            CommerceBuilder.Reporting.PageView.RegisterCatalogNode(nodeId, nodeType);

            HttpContext context = HttpContext.Current;
            string uriStem = context.Request.Url.AbsolutePath;
            string uriQuery = context.Request.Url.Query.TrimStart("?".ToCharArray());

            // CHECK IF ITS ALREADY IN LIST
            IList<PageVisit> pageVisits = GetUserPageVisits();
            PageVisit pageVisit = pageVisits.FirstOrDefault(p => (p.UriStem == uriStem && p.UriQuery == uriQuery));

            if (pageVisit != null)
            {
                pageVisit.ActivityDate = LocaleHelper.LocalNow;
                pageVisit.VisitCount++;
                pageVisits.Sort();
            }
            else
            {
                // ADD THE NEW PAGE VISIT
                pageVisit = new PageVisit();
                pageVisit.ActivityDate = LocaleHelper.LocalNow;
                pageVisit.CatalogNodeId = nodeId;
                pageVisit.CatalogNodeType = nodeType;
                pageVisit.PageTitle = pageTitle;
                pageVisit.UriStem = uriStem;
                pageVisit.UriQuery = uriQuery;
                pageVisit.VisitCount = 1;
                pageVisits.Sort();

                // ADD IT TO COLLECTION
                pageVisits.Add(pageVisit);

                // ENSURE MAXIMUM SIZE, REMOVE FROM END IF IT EXCEEDS THE SIZE
                if (pageVisits.Count > _cacheSize)
                {
                    for (int i = _cacheSize; i < pageVisits.Count; i++)
                    {
                        pageVisits.RemoveAt(i);
                    }
                }
            }
        }

        /// <summary>
        /// Get a list of all catalog page visits by the user
        /// </summary>
        /// <returns>A list of all catalog page visits by the user</returns>
        public static IList<PageVisit> GetUserPageVisits()
        {
            HttpContext context = HttpContext.Current;
            HttpSessionState session = context.Session;

            IList<PageVisit> pageVisits = session[_sessionKey] as IList<PageVisit>;

            if (pageVisits == null)
            {
                pageVisits = new List<PageVisit>();

                // ADD TO SESSION
                session[_sessionKey] = pageVisits;
            }
                
            return pageVisits;
        }

        /// <summary>
        /// Get the last visited Product Id
        /// </summary>
        public static int LastVisitedProductId
        {
            get
            {
                IList<PageVisit> pageVisits = GetUserPageVisits();
                foreach (PageVisit pageVisit in pageVisits)
                {
                    if (pageVisit.CatalogNodeType == CatalogNodeType.Product)
                    {
                        return pageVisit.CatalogNodeId.Value;
                    }
                }

                return 0;
            }
        }

        /// <summary>
        /// Get the last visited Product
        /// </summary>
        public static Product LastVisitedProduct
        {
            get
            {
                IList<PageVisit> pageVisits = GetUserPageVisits();
                foreach (PageVisit pageVisit in pageVisits)
                {
                    if (pageVisit.CatalogNodeType == CatalogNodeType.Product)
                    {
                        return (Product)pageVisit.CatalogNode;
                    }
                }

                return null;
            }
        }

        /// <summary>
        /// Get the last visited Category
        /// </summary>
        public static int LastVisitedCategoryId
        {
            get
            {
                IList<PageVisit> pageVisits = GetUserPageVisits();
                foreach (PageVisit pageVisit in pageVisits)
                {
                    if (pageVisit.CatalogNodeType == CatalogNodeType.Category)
                    {
                        return pageVisit.CatalogNodeId.Value;
                    }
                }

                return 0;
            }
        }

        /// <summary>
        /// Get the last visited Category
        /// </summary>
        public static Category LastVisitedCategory
        {
            get
            {
                IList<PageVisit> pageVisits = GetUserPageVisits();
                foreach (PageVisit pageVisit in pageVisits)
                {
                    if (pageVisit.CatalogNodeType == CatalogNodeType.Category)
                    {
                        return (Category)pageVisit.CatalogNode;
                    }
                }

                return null;
            }
        }

        /// <summary>
        /// Get the last visited webpage Id
        /// </summary>
        public static int LastVisitedWebpageId
        {
            get
            {
                IList<PageVisit> pageVisits = GetUserPageVisits();
                foreach (PageVisit pageVisit in pageVisits)
                {
                    if (pageVisit.CatalogNodeType == CatalogNodeType.Webpage)
                    {
                        return pageVisit.CatalogNodeId.Value;
                    }
                }

                return 0;
            }
        }

        /// <summary>
        /// Get the last visited webpage
        /// </summary>
        public static Webpage LastVisitedWebpage
        {
            get
            {
                IList<PageVisit> pageVisits = GetUserPageVisits();
                foreach (PageVisit pageVisit in pageVisits)
                {
                    if (pageVisit.CatalogNodeType == CatalogNodeType.Webpage)
                    {
                        return (Webpage)pageVisit.CatalogNode;
                    }
                }

                return null;
            }
        }
    }
}
