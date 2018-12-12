using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Stores;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Website.ContentPages.CategoryPages
{
public partial class _Default : AbleCommerceAdminPage
{
    Dictionary<string, string> _DisplayPages;
    StoreSettingsManager _Settings;

    protected void Page_Load(object sender, EventArgs e)
    {
        _Settings = AbleContext.Current.Store.Settings;
        _DisplayPages = new Dictionary<string, string>();
        IList<DisplayPage> displayPages = DisplayPageDataSource.Load("~/Layouts/Webpages");
        foreach (DisplayPage displayPage in displayPages)
        {
            if (displayPage.NodeType == CatalogNodeType.Webpage)
            {
                string displayName = string.Format("{0}", displayPage.Name);
                _DisplayPages[displayPage.DisplayPageFile] = displayName;
            }
        }
        displayPages = DisplayPageDataSource.Load();
        foreach (DisplayPage displayPage in displayPages)
        {
            if (displayPage.NodeType == CatalogNodeType.Webpage)
            {
                string displayName = string.Format("{0} (webparts)", displayPage.Name);
                _DisplayPages[displayPage.DisplayPageFile] = displayName;
            }
        }
    }

    protected void NewPageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddCategoryPage.aspx");
    }

    protected void WebpagesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int webPageId = AlwaysConvert.ToInt(e.CommandArgument);

        if (e.CommandName.ToLower() == "dodelete")
        {
            WebpageDataSource.Delete(webPageId);
            WebpagesGrid.DataBind();
        }

        else if (e.CommandName.ToLower() == "docopy")
        {
            Webpage page = Webpage.Copy(webPageId);
            page.Name = string.Format("Copy of {0}", page.Name);
            page.Save();
            WebpagesGrid.DataBind();
        }
    }

    protected string GetLayout(object dataItem)
    {
        Webpage webpage = (Webpage)dataItem;
        if (webpage.Layout != null)
            return webpage.Layout.DisplayName;
        return "default";
    }

    protected string GetTheme(object dataItem)
    {
        Webpage webpage = (Webpage)dataItem;
        return webpage.Theme;
    }

    protected string GetPageType(object dataItem)
    {
        Webpage webpage = (Webpage)dataItem;
        if (_Settings.CategoryWebpageId == webpage.Id || _Settings.ProductWebpageId == webpage.Id)
        { 
            return StringHelper.SpaceName(webpage.WebpageType.ToString()) + "<span style='color:red!important;'><i>(default)</i></span>";
        }

        return StringHelper.SpaceName(webpage.WebpageType.ToString());
    }

    protected void UpdateDefaultsButton_Click(Object sender, EventArgs e)
    {
        _Settings.CategoryWebpageId = AlwaysConvert.ToInt(CategoriesDefault.SelectedValue);
        _Settings.Save();
        WebpagesGrid.DataBind();
    }

    protected void BindDisplayPage()
    {
        CategoriesDefault.DataSource = WebpageDataSource.LoadForWebpageType(WebpageType.CategoryDisplay);
        CategoriesDefault.DataBind();
        ListItem selectedItem = null;
        selectedItem = CategoriesDefault.Items.FindByValue(_Settings.CategoryWebpageId.ToString());
        if (selectedItem != null) CategoriesDefault.SelectedIndex = CategoriesDefault.Items.IndexOf(selectedItem);
    }

    protected void ChangeDefaultButton_Click(Object sender, EventArgs e) 
    {
        BindDisplayPage();
        ChangeDefaultPopup.Show();
    }

    protected bool IsDefault(Object dataItem) 
    {
        Webpage webpage = (Webpage)dataItem;
        return _Settings.CategoryWebpageId == webpage.Id;
    }

    protected void WebpagesDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        e.InputParameters["webpageType"] = WebpageType.CategoryDisplay;
    }

    protected int GetCategoryCount(Object dataItem)
    {
        Webpage webpage = (Webpage)dataItem;
        return CategoryDataSource.CountForDisplayPage(webpage.Id, false);
    }
}}
