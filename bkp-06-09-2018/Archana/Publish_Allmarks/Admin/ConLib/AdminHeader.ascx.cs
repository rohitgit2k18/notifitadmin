namespace AbleCommerce.Admin.ConLib
{
    using System;
    using CommerceBuilder.Utility;
using CommerceBuilder.Search;

    public partial class AdminHeader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DashboardLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("default.aspx");
            OrdersLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("orders/default.aspx");
            StoreLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page);
            UsersLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("people/users/default.aspx");
            CatalogLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("catalog/browse.aspx");
            ProductsLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("products/manageproducts.aspx");
            LogoutLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetAdminUrl("logout.aspx");
        }

        protected void SearchButton_Click(SearchArea searchArea)
        {
            string safeSearchPhrase = StringHelper.StripHtml(SearchPhrase.Text);
            int orderNumber = AlwaysConvert.ToInt(safeSearchPhrase, 0);
            if (orderNumber > 0 && (searchArea == SearchArea.All || searchArea == SearchArea.Orders))
            {
                int orderId = CommerceBuilder.Orders.OrderDataSource.LookupOrderId(orderNumber);
                if (orderId > 0)
                {
                    Response.Redirect(string.Format("~/Admin/Orders/ViewOrder.aspx?OrderId={0}", orderId));
                }
            }

            string parameters = string.Empty;
            if (searchArea != SearchArea.All)
            {
                parameters = "?a=" + searchArea.ToString();
            }

            if (!string.IsNullOrEmpty(safeSearchPhrase))
            {
                parameters += (string.IsNullOrEmpty(parameters) ? "?" : "&") + "k=" + Server.UrlEncode(safeSearchPhrase);
            }

            Response.Redirect("~/Admin/Search.aspx" + parameters);
        }

        protected void SearchLinks_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.Links);
        }        

        protected void SearchAll_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.All);
        }

        protected void SearchOrders_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.Orders);
        }

        protected void SearchUsers_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.Users);
        }

        protected void SearchProducts_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.Products);
        }

        protected void SearchCategories_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.Categories);
        }

        protected void SearchWebpages_Click(object sender, EventArgs e)
        {
            SearchButton_Click(SearchArea.Webpages);
        }
    }
}