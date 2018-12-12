namespace AbleCommerce.Admin.People.Users
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Reporting;
    using CommerceBuilder.Utility;

    public partial class SearchHistoryDialog : System.Web.UI.UserControl
    {
        //private int _UserId;

        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    _UserId = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
        //    if (!Page.IsPostBack)
        //    {
        //        IList<PageView> pageViews = PageViewDataSource.LoadForUser(_UserId, 30, 0, "ActivityDate DESC");
        //        ViewsGrid.DataSource = pageViews;
        //        ViewsGrid.DataBind();
        //        CompleteHistoryLink.Visible = pageViews.Count > 0;
        //        CompleteHistoryLink.NavigateUrl = "~/Admin/Reports/CustomerHistory.aspx?UserId=" + _UserId.ToString();
        //    }
        //}

        //protected string GetUri(object dataItem)
        //{
        //    PageView pageView = (PageView)dataItem;
        //    if (!string.IsNullOrEmpty(pageView.UriQuery))
        //        return pageView.UriStem + "<wbr>?" + pageView.UriQuery.Replace("&", "<wbr>&").Replace("%", "<wbr>%");
        //    else return pageView.UriStem;
        //}
    }
}