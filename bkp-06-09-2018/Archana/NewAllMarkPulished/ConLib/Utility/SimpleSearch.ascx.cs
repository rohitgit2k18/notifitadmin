namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Common;
    using CommerceBuilder.Search;
    using CommerceBuilder.Utility;

    [Description("Displays a simple search box")]
    public partial class SimpleSearch : System.Web.UI.UserControl
    {
        public bool IsBootstrap { get; private set; }

        protected void Page_Init()
        {
            string uniqueId = string.Empty;
            IsBootstrap = AbleCommerce.Code.PageHelper.IsResponsiveTheme(this.Page);
            if (IsBootstrap)
            {
                SearchButton.Visible = false;
                SearchLink.Visible = true;
                uniqueId = SearchLink.ClientID;
                SearchPhrase.Style.Add("width", "100%");
            }
            else
            {
                SearchButton.Visible = true;
                SearchLink.Visible = false;
                uniqueId = SearchButton.UniqueID;
                SearchPhrase.Style.Remove("width");
            }

            string handleEnterScript = "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('"
                + uniqueId + "').click();return false;}} else {return true}; ";
            SearchPhrase.Attributes.Add("onkeydown", handleEnterScript);
            int minimumSearchLength = AbleContext.Current.Store.Settings.MinimumSearchLength;
            //SearchPhraseValidator.MinimumLength = minimumSearchLength;
            //SearchPhraseValidator.ErrorMessage = string.Format(SearchPhraseValidator.ErrorMessage, minimumSearchLength);
            string searchUrl = this.Page.ResolveUrl("~/Search.aspx");
            SearchButton.OnClientClick = string.Format(SearchButton.OnClientClick, searchUrl, SearchPhrase.ClientID);
            SearchLink.OnClientClick = string.Format(SearchLink.OnClientClick, searchUrl, SearchPhrase.ClientID);
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