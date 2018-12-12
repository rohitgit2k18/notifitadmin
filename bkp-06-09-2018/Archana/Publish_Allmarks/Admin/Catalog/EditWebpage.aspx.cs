using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;


namespace AbleCommerce.Admin.Catalog
{
    public partial class EditWebpage : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _WebpageId;
        private Webpage _Webpage;

        protected void Page_Load(object sender, EventArgs e)
        {
            _WebpageId = AlwaysConvert.ToInt(Request.QueryString["WebpageId"]);
            _Webpage = WebpageDataSource.Load(_WebpageId);
            if (_Webpage == null)
            {
                Response.Redirect(Page.ResolveUrl("~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId().ToString()));
            }
            if (!Page.IsPostBack)
            {
                //INITIALIZE FORM ON FIRST VISIT
                Name.Focus();
                UpdateCaption();
                Name.Text = _Webpage.Name;
                CustomUrl.Text = _Webpage.CustomUrl;
                if (CustomUrl.Text.StartsWith("~/")) CustomUrl.Text = CustomUrl.Text.Substring(2);
                CustomUrlValidator.OriginalValue = _Webpage.CustomUrl;
                WebpageContent.Value = _Webpage.Description;
                Visibility.SelectedIndex = (int)_Webpage.Visibility;
                CategoryTree.SelectedCategories = _Webpage.Categories.ToArray();

                PageTitle.Text = _Webpage.Title;
                MetaKeywordsValue.Text = _Webpage.MetaKeywords;
                MetaDescriptionValue.Text = _Webpage.MetaDescription;
                HtmlHead.Text = _Webpage.HtmlHead;
                ThumbnailUrl.Text = _Webpage.ThumbnailUrl;
                ThumbnailAltText.Text = _Webpage.ThumbnailAltText;
                Summary.Text = _Webpage.Summary;

                PublishedBy.Text = _Webpage.PublishedBy;
                PublishDate.SelectedDate = _Webpage.PublishDate.HasValue ? _Webpage.PublishDate.Value : DateTime.MinValue;

                LayoutList.DataBind();
                BindThemes();
                string layout = _Webpage.Layout != null ? _Webpage.Layout.FilePath : string.Empty;
                ListItem item = LayoutList.Items.FindByValue(layout);
                if (item != null)
                    item.Selected = true;
                Name.Focus();

                // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
                if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addwebpage.aspx"))
                {
                    SavedMessage.Visible = true;
                    SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                }
            }

            MetaKeywordsCharCount.Text = ((int)(MetaKeywordsValue.MaxLength - MetaKeywordsValue.Text.Length)).ToString();
            MetaDescriptionCharCount.Text = ((int)(MetaDescriptionValue.MaxLength - MetaDescriptionValue.Text.Length)).ToString();
            AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
            AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
            AbleCommerce.Code.PageHelper.SetPageDefaultButton(Page, SaveButton);
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);

            if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(WebpageContent, ContentHtmlButton);
            else ContentHtmlButton.Visible = false;

            if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Summary, SummaryHtmlButton);
            else SummaryHtmlButton.Visible = false;

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            if (categoryId > 0)
            {
                CancelButton.NavigateUrl = "Browse.aspx?CategoryId=" + categoryId.ToString();
                CancelButton2.NavigateUrl = "Browse.aspx?CategoryId=" + categoryId.ToString();
            }
            else
            {
                CancelButton.NavigateUrl = "~/Admin/Website/ContentPages/Default.aspx";
                CancelButton2.NavigateUrl = "~/Admin/Website/ContentPages/Default.aspx";
            }

            PreviewButton.NavigateUrl = UrlGenerator.GetBrowseUrl(_WebpageId, CatalogNodeType.Webpage, _Webpage.Name);
            PreviewButton2.NavigateUrl = UrlGenerator.GetBrowseUrl(_WebpageId, CatalogNodeType.Webpage, _Webpage.Name);
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            SaveButton_Click(sender, e);
            // RETURN TO BROWSE PARENT CATEGORY
            int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            if (categoryId > 0)
                Response.Redirect(Page.ResolveUrl("~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId().ToString()));
            else
                Response.Redirect(Page.ResolveUrl("~/Admin/Website/ContentPages/Default.aspx"));
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                _Webpage.Name = Name.Text;
                _Webpage.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
                if (_Webpage.NavigateUrl != "~/" + CustomUrl.Text)
                    _Webpage.CustomUrl = CustomUrl.Text;
                _Webpage.Description = WebpageContent.Value;
                _Webpage.Title = PageTitle.Text.Trim();
                _Webpage.MetaDescription = MetaDescriptionValue.Text.Trim();
                _Webpage.MetaKeywords = MetaKeywordsValue.Text.Trim();
                _Webpage.HtmlHead = HtmlHead.Text.Trim();
                if (!string.IsNullOrEmpty(LayoutList.SelectedValue))
                    _Webpage.Layout = new Layout(LayoutList.SelectedValue);
                else
                    _Webpage.Layout = null;
                _Webpage.ThumbnailUrl = ThumbnailUrl.Text;
                _Webpage.ThumbnailAltText = ThumbnailAltText.Text;
                _Webpage.Summary = Summary.Text;

                _Webpage.PublishedBy = PublishedBy.Text.Trim();
                _Webpage.PublishDate = PublishDate.SelectedDate;

                _Webpage.Theme = LocalTheme.SelectedValue;
                _Webpage.Save();

                // update categories
                int[] selectedCategories = CategoryTree.SelectedCategories;
                if (selectedCategories.Length > 0)
                {
                    _Webpage.Categories.Clear();
                    _Webpage.Categories.AddRange(selectedCategories);
                    _Webpage.Categories.Save();
                }
                else
                {
                    _Webpage.Categories.Clear();
                    _Webpage.Categories.Save();
                }

                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        protected void UpdateCaption()
        {
            string shortWebpageName = _Webpage.Name;
            if (shortWebpageName.Length > 45) shortWebpageName = shortWebpageName.Substring(0, 40) + "...";
            Caption.Text = string.Format(Caption.Text, shortWebpageName);
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
            if (_Webpage != null && !Page.IsPostBack)
            {

                string currentTheme = _Webpage.Theme;
                ListItem selectedItem = LocalTheme.Items.FindByValue(currentTheme);
                if (selectedItem != null) LocalTheme.SelectedIndex = LocalTheme.Items.IndexOf(selectedItem);
            }
        }
    }
}
