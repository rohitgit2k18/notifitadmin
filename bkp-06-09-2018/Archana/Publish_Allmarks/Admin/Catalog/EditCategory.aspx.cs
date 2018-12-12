using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Utility;
using System.Collections.Generic;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Catalog
{
public partial class EditCategory : CommerceBuilder.UI.AbleCommerceAdminPage
{
    int _CategoryId;
    Category _Category;

    protected void Page_Init(object sender, EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
        AbleCommerce.Code.PageHelper.SetPageDefaultButton(Page, FinishButton);
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        _CategoryId = AlwaysConvert.ToInt(Request.QueryString["CategoryId"]);
        _Category = CategoryDataSource.Load(_CategoryId);
        if (_Category == null) Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=0");
        if (!Page.IsPostBack)
        {
            Caption.Text = string.Format(Caption.Text, _Category.Name);
            Name.Text = _Category.Name;
            Name.Focus();
            Visibility.SelectedIndex = (int)_Category.Visibility;
            CategoryTitle.Text = _Category.Title;
            MetaDescriptionValue.Text = _Category.MetaDescription;
            MetaKeywordsValue.Text = _Category.MetaKeywords;
            HtmlHead.Text = _Category.HtmlHead;
            //DISPLAY PAGE
            BindDisplayPage();
            UpdateDescription();
            //THUMBNAIL
            ThumbnailUrl.Text = _Category.ThumbnailUrl;
            ThumbnailAltText.Text = _Category.ThumbnailAltText;
            //CUSTOM URL
            CustomUrl.Text = _Category.CustomUrl;
            CustomUrlValidator.OriginalValue = _Category.CustomUrl;
            //SUMARY
            Summary.Text = _Category.Summary;
            Description.Text = _Category.Description;
            MetaDescriptionCharCount.Text = ((int)(MetaDescriptionValue.MaxLength - MetaDescriptionValue.Text.Length)).ToString();
            MetaKeywordsCharCount.Text = ((int)(MetaKeywordsValue.MaxLength - MetaKeywordsValue.Text.Length)).ToString();
            string confirmationJS = String.Format("return confirm('Are you sure you want to delete category \"{0}\" and all its contents?');", _Category.Name);
            DeleteButton.Attributes.Add("onclick", confirmationJS);
            DeleteButton1.Attributes.Add("onclick", confirmationJS);

            // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
            if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addcategory.aspx"))
            {
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Visibility);
        AbleCommerce.Code.PageHelper.DisableValidationScrolling(this);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);

        if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Summary, SummaryHtmlButton);
        else SummaryHtmlButton.Visible = false;

        if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Description, DescriptionHtmlButton);
        else DescriptionHtmlButton.Visible = false;
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        PreviewButton.NavigateUrl = UrlGenerator.GetBrowseUrl(_Category.Id, _Category.Name);
        PreviewButton1.NavigateUrl = PreviewButton.NavigateUrl;
    }

    protected void BindDisplayPage()
    {
        DisplayPage.DataSource = WebpageDataSource.LoadForWebpageType(WebpageType.CategoryDisplay);
        DisplayPage.DataBind();

        if (!Page.IsPostBack)
        {
            Webpage webpage = _Category.Webpage;
            if (webpage != null)
            {
                ListItem selectedItem = DisplayPage.Items.FindByValue(webpage.Id.ToString());
                if (selectedItem != null) DisplayPage.SelectedIndex = DisplayPage.Items.IndexOf(selectedItem);
            }
        }
    }

    protected void DisplayPage_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdateDescription();
    }

    private void UpdateDescription()
    {
        DisplayPageDescription.Text = "&nbsp;";
        if (DisplayPage.SelectedValue != string.Empty)
        {
            Webpage page = WebpageDataSource.Load(AlwaysConvert.ToInt(DisplayPage.SelectedValue));
            if (page != null)
            {
                DisplayPageDescription.Text = page.Summary;
            }
        }
        else
        {
            DisplayPageDescription.Text = "Uses the default display page configured for the store.";
        }
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        // RETURN TO BROWSE PARENT CATEGORY
        RedirectBack();
    }

    protected void FinishButton_Click(object sender, System.EventArgs e)
    {
        SaveCategory(sender, e);
        RedirectBack();
    }

    protected void SaveButton_Click(object sender, System.EventArgs e)
    {
        SaveCategory(sender, e);
        SavedMessage.Visible = true;
        SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
    }

    protected void DeleteButton_Click(object sender, System.EventArgs e)
    {
        int parentId = _Category.ParentId;
        _Category.Delete();
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + parentId.ToString());
    }

    private void SaveCategory(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            _Category.Name = Name.Text;
            _Category.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
            _Category.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(DisplayPage.SelectedValue));
            _Category.Title = CategoryTitle.Text.Trim();
            _Category.MetaDescription = MetaDescriptionValue.Text.Trim();
            _Category.MetaKeywords = MetaKeywordsValue.Text.Trim();
            _Category.HtmlHead = HtmlHead.Text.Trim();
            _Category.ThumbnailUrl = ThumbnailUrl.Text;
            _Category.ThumbnailAltText = ThumbnailAltText.Text;
            _Category.CustomUrl = CustomUrl.Text;
            CustomUrlValidator.OriginalValue = _Category.CustomUrl;
            _Category.Summary = StringHelper.Truncate(Summary.Text, Summary.MaxLength);
            _Category.Description = Description.Text;
            _Category.Save();
        }
    }

    private void RedirectBack()
    {
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + _Category.ParentId.ToString());
    }
}}
