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
public partial class AddCategory : CommerceBuilder.UI.AbleCommerceAdminPage
{
    int _ParentCategoryId;
    Category _ParentCategory;

    protected void Page_Init(object sender, EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
        AbleCommerce.Code.PageHelper.SetPageDefaultButton(Page, FinishButton);
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        _ParentCategoryId = AlwaysConvert.ToInt(Request.QueryString["ParentCategoryId"]);
        if (_ParentCategoryId != 0)
        {
            _ParentCategory = CategoryDataSource.Load(_ParentCategoryId);
        }
        else
        {
            _ParentCategory = new Category();
            _ParentCategory.Name = "Catalog";
        }
        if (!Page.IsPostBack)
        {
            Caption.Text = string.Format(Caption.Text, _ParentCategory.Name);
            Visibility.SelectedIndex = 0;
            Name.Focus();
            BindDisplayPage();
            UpdateDescription();
        }
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Visibility);
        AbleCommerce.Code.PageHelper.DisableValidationScrolling(this);
        MetaKeywordsCharCount.Text = ((int)(MetaKeywordsValue.MaxLength - MetaKeywordsValue.Text.Length)).ToString();
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
        MetaDescriptionCharCount.Text = ((int)(MetaDescriptionValue.MaxLength - MetaDescriptionValue.Text.Length)).ToString();
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);

        if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Summary, SummaryHtmlButton);
        else SummaryHtmlButton.Visible = false;

        if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Description, DescriptionHtmlButton);
        else DescriptionHtmlButton.Visible = false;
    }

    protected void BindDisplayPage()
    {
        DisplayPage.DataSource = WebpageDataSource.LoadForWebpageType(WebpageType.CategoryDisplay);
        DisplayPage.DataBind();
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
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + _ParentCategoryId.ToString());
    }

    protected void FinishButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            Category category = new Category();
            category.ParentId = _ParentCategoryId;
            category.Name = Name.Text;
            category.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
            category.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(DisplayPage.SelectedValue));
            category.ThumbnailUrl = ThumbnailUrl.Text;
            category.ThumbnailAltText = ThumbnailAltText.Text;
            category.CustomUrl = CustomUrl.Text;
            category.Summary = StringHelper.Truncate(Summary.Text, Summary.MaxLength);
            category.Description = Description.Text;
            category.Title = CategoryTitle.Text.Trim();
            category.MetaDescription = MetaDescriptionValue.Text.Trim();
            category.MetaKeywords = MetaKeywordsValue.Text.Trim();
            category.HtmlHead = HtmlHead.Text.Trim();
            category.Save();
            Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + _ParentCategoryId.ToString());
        }
    }
}
}
