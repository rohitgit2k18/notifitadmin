namespace AbleCommerce.ConLib
{
    using CommerceBuilder.Common;
    using CommerceBuilder.Search;
    using CommerceBuilder.UI;
    using CommerceBuilder.Utility;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class StoreSearch : System.Web.UI.UserControl, ISidebarControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string safeSearchPhrase = StringHelper.StripHtml(SearchPhrase.Text.Trim());
            if (!string.IsNullOrEmpty(safeSearchPhrase))
            {
                SearchHistory record = new SearchHistory(safeSearchPhrase, AbleContext.Current.User);
                record.Save();
                Response.Redirect("~/Search.aspx?k=" + Server.UrlEncode(safeSearchPhrase));
            }
            Response.Redirect("~/Search.aspx");
        }
    }
}