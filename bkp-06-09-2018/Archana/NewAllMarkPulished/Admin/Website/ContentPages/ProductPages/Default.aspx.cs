using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Website.ContentPages.ProductPages
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
        Response.Redirect("AddProductPage.aspx");
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

    protected void UpdateDefaultsButton_Click(Object sender, EventArgs e)
    {
        _Settings.ProductWebpageId = AlwaysConvert.ToInt(ProductsDefault.SelectedValue);
        _Settings.Save();
        WebpagesGrid.DataBind();
    }

    protected void BindDisplayPage()
    {
        ProductsDefault.DataSource = WebpageDataSource.LoadForWebpageType(WebpageType.ProductDisplay);
        ProductsDefault.DataBind();
        ListItem selectedItem = ProductsDefault.Items.FindByValue(_Settings.ProductWebpageId.ToString());
        if (selectedItem != null) ProductsDefault.SelectedIndex = ProductsDefault.Items.IndexOf(selectedItem);
    }

    protected void ChangeDefaultButton_Click(Object sender, EventArgs e) 
    {
        BindDisplayPage();
        ChangeDefaultPopup.Show();
    }

    protected bool IsDefault(Object dataItem) 
    {
        Webpage webpage = (Webpage)dataItem;
        return _Settings.ProductWebpageId == webpage.Id;
    }

    protected void WebpagesDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        e.InputParameters["webpageType"] = WebpageType.ProductDisplay;
    }

    protected int GetProductCount(Object dataItem) 
    {
        Webpage webpage = (Webpage)dataItem;
        return ProductDataSource.CountForDisplayPage(webpage.Id, false);
    }
}
}
