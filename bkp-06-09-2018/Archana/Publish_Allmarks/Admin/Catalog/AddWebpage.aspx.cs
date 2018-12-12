using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.UI;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Catalog
{
    public partial class AddWebpage : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CategoryId = 0;
        private Category _Category = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _Category = CategoryDataSource.Load(_CategoryId);
            CancelButton.NavigateUrl = "Browse.aspx?CategoryId=" + _CategoryId.ToString();
            CancelButton2.NavigateUrl = "Browse.aspx?CategoryId=" + _CategoryId.ToString();
            if (_Category == null)
            {
                Response.Redirect(CancelButton.NavigateUrl);
                Response.Redirect(CancelButton2.NavigateUrl);
            }

            if (!Page.IsPostBack)
            {
                LayoutList.DataBind();
                BindThemes();
                CategoryTree1.SelectedCategories = new int[] { _CategoryId };
                CommerceBuilder.Users.User user = AbleContext.Current.User;
                PublishedBy.Text = user.PrimaryAddress.FirstName + " " + user.PrimaryAddress.LastName;
            }

            AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);

            if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(WebpageContent, ContentHtmlButton);
            else ContentHtmlButton.Visible = false;

            if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Summary, SummaryHtmlButton);
            else SummaryHtmlButton.Visible = false;
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Webpage webpage = new Webpage();
                webpage.Name = Name.Text;
                webpage.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
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
                webpage.Categories.AddRange(CategoryTree1.SelectedCategories);
                webpage.Summary = Summary.Text;
                webpage.Theme = LocalTheme.SelectedValue;
                webpage.PublishedBy = PublishedBy.Text.Trim();
                webpage.PublishDate = PublishDate.SelectedDate;
                webpage.Save();

                Response.Redirect(string.Format("EditWebpage.aspx?WebpageId={0}", webpage.Id));
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
