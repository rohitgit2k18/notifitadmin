<%@ WebHandler Language="C#" Class="AbleCommerce.CategorySuggest" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using CommerceBuilder.Catalog;
using CommerceBuilder.Utility;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.DomainModel;
using CommerceBuilder.Utility;
using NHibernate;
using NHibernate.Criterion;
using NHibernate.Transform;

namespace AbleCommerce
{
    /// <summary>
    /// A generic hanlder to suggest categories for provided search term
    /// </summary>
    public class CategorySuggest : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string term = context.Request.QueryString["term"];
            term = StringHelper.StripHtml(term);
            if(string.IsNullOrEmpty(term)) return;
            

            var suggestedCategories = SuggestCategories(term);
            if(suggestedCategories.Count > 0)
            {
                context.Response.ContentType = "application/json";
                var serializer = new JavaScriptSerializer();
                context.Response.Write(serializer.Serialize(suggestedCategories));
            }
        }

        /// <summary>
        /// Returns suggested category names and ids for the given term(s)
        /// </summary>
        /// <param name="term">the search term</param>
        /// <returns>suggested category names and ids</returns>
        private static IList<KeyValuePair<string, int>> SuggestCategories(string term)
        {
            term = StringHelper.FixSearchPattern(term);
            ICriteria criteria = NHibernateHelper.CreateCriteria<Category>(8, 0, string.Empty);
            criteria.Add(Restrictions.Eq("Store", AbleContext.Current.Store));
            criteria.Add(Restrictions.Like("Name", term, MatchMode.Anywhere));
            if (!AbleContext.Current.User.IsAdmin) criteria.Add(Restrictions.Eq("VisibilityId", (byte)CatalogVisibility.Public));

            criteria.SetProjection(Projections.Distinct(Projections.ProjectionList()
                .Add(Projections.Alias(Projections.Property("Name"), "key"))
                .Add(Projections.Alias(Projections.Property("Id"), "value"))));

            System.Collections.IList objects = criteria.List();
            List<KeyValuePair<string, int>> results = new List<KeyValuePair<string, int>>();
            foreach (var o in objects)
            {
                object[] values = (object[])o;
                results.Add(new KeyValuePair<string, int>(AlwaysConvert.ToString(values[0]), AlwaysConvert.ToInt(values[1])));
            }

            return results;            
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