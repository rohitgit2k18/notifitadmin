namespace AbleCommerce.Admin
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Search;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using CommerceBuilder.Catalog;

    public partial class Search : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected IList<SearchAreaResults> _SearchAreaResults;
        private string ProductUrl = string.Empty;
        private string UserUrl = string.Empty;
        private string OrderUrl = string.Empty;
        private string CategoryUrl = string.Empty;
        private string LinkUrl = string.Empty;
        private string WebpageUrl = string.Empty;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            string keywords = Request.QueryString["k"];
            if (string.IsNullOrEmpty(keywords)) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl());
            SearchArea searchArea = SearchArea.All;
            if (!string.IsNullOrEmpty(Request.QueryString["a"]))
            {
                searchArea = AlwaysConvert.ToEnum<SearchArea>(Request.QueryString["a"], SearchArea.All);
            }

            Caption.Text = String.Format(Caption.Text, keywords);
            _SearchAreaResults = SearchDataSource.Search(keywords, searchArea, 100);
            ProductUrl = Page.ResolveUrl("~/Admin/Products/EditProduct.aspx?ProductId={0}");
            UserUrl = Page.ResolveUrl("~/Admin/People/Users/EditUser.aspx?UserId={0}");
            OrderUrl = Page.ResolveUrl("~/Admin/Orders/ViewOrder.aspx?OrderNumber={0}");
            CategoryUrl = Page.ResolveUrl("~/Admin/Catalog/EditCategory.aspx?CategoryId={0}");
            LinkUrl = Page.ResolveUrl("~/Admin/Catalog/EditLink.aspx?LinkId={0}");
            WebpageUrl = Page.ResolveUrl("~/Admin/Catalog/EditWebpage.aspx?WebpageId={0}");
            SearchAreasRepeater.DataSource = _SearchAreaResults;
            SearchAreasRepeater.DataBind();
        }

        protected string GetLinkUrl(object untypedEntity)
        {
            Entity entity = (Entity)untypedEntity;
            if (entity is Product)
            {
                return String.Format(ProductUrl, entity.Id);
            }
            else if (entity is User)
            {
                return String.Format(UserUrl, entity.Id);
            }
            else if (entity is Order)
            {
                return String.Format(OrderUrl, ((Order)entity).OrderNumber);
            }
            else if (entity is Category)
            {
                return String.Format(CategoryUrl, ((Category)entity).Id);
            }
            else if (entity is Link)
            {
                return String.Format(LinkUrl, ((Link)entity).Id);
            }
            else if (entity is Webpage)
            {
                return String.Format(WebpageUrl, ((Webpage)entity).Id);
            }
            return string.Empty;
        }

        protected bool ShowMoreMatches(object dataItem)
        {
            SearchAreaResults result = (SearchAreaResults)dataItem;
            return result.TotalMatches > result.SearchResults.Count;
        }
    }
}