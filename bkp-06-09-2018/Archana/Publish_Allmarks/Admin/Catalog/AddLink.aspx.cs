using System;
using System.Collections;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Utility;
using System.Collections.Generic;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Catalog
{
public partial class AddLink : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private int _CategoryId;
    private Category _Category;

    protected void Page_Init(object sender, EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetPickImageButton(ThumbnailUrl, BrowseThumbnailUrl);        
        AbleCommerce.Code.PageHelper.SetPageDefaultButton(Page, FinishButton);

        if (!AbleContext.Current.Store.Settings.EnableWysiwygEditor) AbleCommerce.Code.PageHelper.SetHtmlEditor(Description, LinkDescriptionHtml);
        else LinkDescriptionHtml.Visible = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
        _Category = CategoryDataSource.Load(_CategoryId);
        if (_Category == null) Response.Redirect("Browse.aspx");
        if (!Page.IsPostBack)
        {
            Name.Focus();
            Caption.Text = string.Format(Caption.Text, _Category.Name);
            BindDisplayPage();
            BindThemes();
            UpdateDescription();
        }
        AbleCommerce.Code.PageHelper.ConvertEnterToTab(Name);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(Summary, SummaryCharCount);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaKeywordsValue, MetaKeywordsCharCount);
        AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(MetaDescriptionValue, MetaDescriptionCharCount);
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        // RETURN TO BROWSE PARENT CATEGORY
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + _CategoryId.ToString());
    }

    protected void FinishButton_Click(object sender, EventArgs e)
    {
        Link link = new Link();
        link.Name = Name.Text;
        link.Visibility = (CatalogVisibility)Visibility.SelectedIndex;
        link.TargetUrl = TargetUrl.Text;
        link.TargetWindow = TargetWindow.SelectedValue;
        link.DisplayPage = DisplayPage.SelectedValue;
        link.Theme = LocalTheme.SelectedValue;
        link.Summary = StringHelper.Truncate(Summary.Text, Summary.MaxLength);
        link.Description = Description.Text;
        link.ThumbnailUrl = ThumbnailUrl.Text;
        link.ThumbnailAltText = ThumbnailAltText.Text;
        link.MetaDescription = MetaDescriptionValue.Text.Trim();
        link.MetaKeywords = MetaKeywordsValue.Text.Trim();
        link.Categories.Add(_CategoryId);
        link.HtmlHead = HtmlHead.Text.Trim();
        link.Save();
        // RETURN TO BROWSE PARENT CATEGORY
        Response.Redirect("~/Admin/Catalog/Browse.aspx?CategoryId=" + _CategoryId.ToString());
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
    }
}
}
