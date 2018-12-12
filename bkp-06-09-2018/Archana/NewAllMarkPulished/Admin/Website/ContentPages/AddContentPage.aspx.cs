using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.UI;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Website.ContentPages
{
    public partial class AddContentPage : AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LayoutList.DataBind();
                BindThemes();
                CommerceBuilder.Users.User user = AbleContext.Current.User;
                PublishedBy.Text = user.PrimaryAddress.FirstName + " " + user.PrimaryAddress.LastName;
            }

            AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);

            if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(WebpageContent, HtmlButton);
            else HtmlButton.Visible = false;
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Webpage webpage = new Webpage();
                webpage.Name = Name.Text;
                webpage.CustomUrl = CustomUrl.Text;
                webpage.Description = WebpageContent.Value;
                webpage.WebpageType = WebpageType.Content;
                webpage.Title = PageTitle.Text.Trim();
                webpage.MetaDescription = MetaDescriptionValue.Text.Trim();
                webpage.MetaKeywords = MetaKeywordsValue.Text.Trim();
                webpage.HtmlHead = HtmlHead.Text.Trim();
                
                if (!string.IsNullOrEmpty(LayoutList.SelectedValue))
                    webpage.Layout = new Layout(LayoutList.SelectedValue);
                else
                    webpage.Layout = null;
                webpage.ThumbnailUrl = ThumbnailUrl.Text;
                webpage.ThumbnailAltText = ThumbnailAltText.Text;
                webpage.Summary = Summary.Text;
                webpage.Theme = LocalTheme.SelectedValue;
                webpage.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
                webpage.PublishedBy = PublishedBy.Text.Trim();
                webpage.PublishDate = PublishDate.SelectedDate;

                webpage.Save();
                
                 //update categories
                int[] selectedCategories = CategoryTree.SelectedCategories;
                if (selectedCategories.Length > 0)
                {
                    webpage.Categories.AddRange(selectedCategories);
                    webpage.Categories.Save();
                }

                Response.Redirect(string.Format("EditContentPage.aspx?WebpageId={0}", webpage.Id));
            }
        }

        protected void BindThemes()
        {
            LocalTheme.Items.Clear();
            LocalTheme.Items.Add(new ListItem("Use store default", ""));
            CommerceBuilder.UI.Theme[] themes = AbleCommerce.Code.StoreDataHelper.GetStoreThemes();
            foreach (CommerceBuilder.UI.Theme theme in themes)
            {
                LocalTheme.Items.Add(new ListItem(theme.DisplayName, theme.Name));
            }
        }
    }
}