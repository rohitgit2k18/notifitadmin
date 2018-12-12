using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Catalog;

using CommerceBuilder.Utility;
using CommerceBuilder.UI.WebControls;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Catalog
{
public partial class EditLink : CommerceBuilder.UI.AbleCommerceAdminPage
{

    private int _LinkId;
    private Link _Link;

    protected void Page_Init(object sender, EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);
        AbleCommerce.Code.PageHelper.SetPageDefaultButton(Page, SaveButton);
     
        if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Description, LinkDescriptionHtml);
        else LinkDescriptionHtml.Visible = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _LinkId = AlwaysConvert.ToInt(Request.QueryString["LinkId"]);
        _Link = LinkDataSource.Load(_LinkId);
        if (_Link == null) Response.Redirect("Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId().ToString());


        if (!Page.IsPostBack)
        {
            UpdateCaption();
            //NAME
            Name.Focus();
            Name.Text = _Link.Name;
            //VISIBILITY
            Visibility.SelectedIndex = (int)_Link.Visibility;
            //NAVIGATE URL
            TargetUrl.Text = _Link.TargetUrl;
            //TARGET
            ListItem targetItem = TargetWindow.Items.FindByValue(_Link.TargetWindow);
            if (targetItem != null) TargetWindow.SelectedIndex = TargetWindow.Items.IndexOf(targetItem);
            //THUMBNAIL
            ThumbnailUrl.Text = _Link.ThumbnailUrl;
            ThumbnailAltText.Text = _Link.ThumbnailAltText;
            //SUMARY
            Summary.Text = _Link.Summary;
            SummaryCharCount.Text = ((int)(Summary.MaxLength - Summary.Text.Length)).ToString();
            Description.Text = _Link.Description;
            //META
            MetaKeywordsValue.Text = _Link.MetaKeywords;
            MetaDescriptionValue.Text = _Link.MetaDescription;
            MetaDescriptionCharCount.Text = ((int)(MetaDescriptionValue.MaxLength - MetaDescriptionValue.Text.Length)).ToString();
            MetaKeywordsCharCount.Text = ((int)(MetaKeywordsValue.MaxLength - MetaKeywordsValue.Text.Length)).ToString();
            HtmlHead.Text = _Link.HtmlHead;
            //DISPLAY PAGE
            BindDisplayPage();
            UpdateDescription();
            //THEMES
            BindThemes();

            // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
            if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addlink.aspx"))
            {
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(Summary, SummaryCharCount);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
    }
    
    protected void Page_PreRender(object sender, EventArgs e)
    {
        PreviewButton.NavigateUrl = UrlGenerator.GetBrowseUrl(_LinkId, CatalogNodeType.Link, _Link.Name);
        PreviewButton2.NavigateUrl = UrlGenerator.GetBrowseUrl(_LinkId, CatalogNodeType.Link, _Link.Name);
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        // RETURN TO BROWSE PARENT CATEGORY
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId().ToString());
    }

    protected void FinishButton_Click(object sender, EventArgs e)
    {
        SaveButton_Click(sender, e);
        // RETURN TO BROWSE PARENT CATEGORY
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId().ToString());
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        _Link.Name = Name.Text;
        _Link.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
        _Link.TargetUrl = TargetUrl.Text;
        _Link.TargetWindow = TargetWindow.SelectedValue;
        _Link.DisplayPage = DisplayPage.SelectedValue;
        _Link.Theme = LocalTheme.SelectedValue;
        _Link.Summary = StringHelper.Truncate(Summary.Text, Summary.MaxLength);
        _Link.Description = Description.Text;
        _Link.ThumbnailUrl = ThumbnailUrl.Text;
        _Link.ThumbnailAltText = ThumbnailAltText.Text;
        _Link.MetaDescription = MetaDescriptionValue.Text.Trim();
        _Link.MetaKeywords = MetaKeywordsValue.Text.Trim();
        _Link.HtmlHead = HtmlHead.Text.Trim();
        _Link.Save();
		SavedMessage.Visible = true;
		SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
    }

    protected void UpdateCaption()
    {
        string shortLinkName = _Link.Name;
        if (shortLinkName.Length > 45) shortLinkName = shortLinkName.Substring(0, 40) + "...";
        Caption.Text = string.Format(Caption.Text, shortLinkName);
    }

    protected void BindDisplayPage()
    {
        IList<CommerceBuilder.UI.DisplayPage> displayPages = CommerceBuilder.UI.DisplayPageDataSource.Load();
        foreach (CommerceBuilder.UI.DisplayPage displayPage in displayPages)
        {
            if (displayPage.NodeType == CatalogNodeType.Link)
            {
                string displayName = string.Format("{0}", displayPage.Name);
                DisplayPage.Items.Add(new ListItem(displayName, displayPage.DisplayPageFile));
            }
        }
        if (!Page.IsPostBack)
        {
            string currentDisplayPage = _Link.DisplayPage;
            ListItem selectedItem = DisplayPage.Items.FindByValue(currentDisplayPage);
            if (selectedItem != null) DisplayPage.SelectedIndex = DisplayPage.Items.IndexOf(selectedItem);
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
            CommerceBuilder.UI.DisplayPage page = CommerceBuilder.UI.DisplayPageDataSource.ParseFromFile(Server.MapPath("~/" + DisplayPage.SelectedValue), "/");
            if (page != null)
            {
                DisplayPageDescription.Text = "<strong>" + DisplayPage.SelectedItem.Text + ":</strong> " + page.Description;
            }
        }
        else
        {
            DisplayPageDescription.Text = "<strong>" + DisplayPage.Items[0].Text + ":</strong> Displays a direct link to the specified url, eliminating the need for a display page.";
        }
    }

    protected void BindThemes()
    {
        LocalTheme.DataSource = AbleCommerce.Code.StoreDataHelper.GetStoreThemes();
        LocalTheme.DataBind();
        if (!Page.IsPostBack)
        {
            string currentTheme = _Link.Theme;
            ListItem selectedItem = LocalTheme.Items.FindByValue(currentTheme);
            if (selectedItem != null) LocalTheme.SelectedIndex = LocalTheme.Items.IndexOf(selectedItem);
        }
    }

}
}
