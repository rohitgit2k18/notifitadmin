using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using AbleCommerce.Code;

namespace AbleCommerce.Mobile.UserControls
{
    public partial class SearchBox : System.Web.UI.UserControl
    {
        string searchMessage = "Search {0}";
        protected void Page_Load(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetDefaultButton(Keywords, SearchButton.ClientID);            
            searchMessage = string.Format(searchMessage, AbleContext.Current.Store.Name);
            if (!Page.IsPostBack)
            {
                Keywords.Text = searchMessage;
                Keywords.Attributes.Add("onfocus", "this.");
            }
            PageHelper.SetWatermarkedTextBox(Keywords, searchMessage, "watermarkedInput");
              
            int minLength = AbleContext.Current.Store.Settings.MinimumSearchLength; 
            SearchPhraseValidator.MinimumLength = minLength;
            SearchPhraseValidator.ErrorMessage = String.Format("Search keyword must be at least {0} characters in length excluding spaces and wildcards.", minLength);
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            string keyword = Keywords.Text;
            if (string.IsNullOrEmpty(keyword) || keyword == searchMessage)
            {
                SearchPhraseValidator.IsValid = false;
            }
            else Response.Redirect(string.Format(NavigationHelper.GetMobileStoreUrl("~/Search.aspx?k={0}"), keyword), true);
        }
    }
}