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
using CommerceBuilder.UI;
using CommerceBuilder.Utility;
using CommerceBuilder.Products;
using CommerceBuilder.Common;
using System.Collections.Generic;
using AbleCommerce.Code;
using CommerceBuilder.Catalog;

namespace AbleCommerce.Admin.Marketing
{
public partial class FeaturedProducts : AbleCommerceAdminPage
{
    private string _IconPath = string.Empty;

    protected void Page_Init(object sender, EventArgs e)
    {
        _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        gridFooter.Visible = PG.Visible && PG.Rows.Count > 0;
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            InitializeCategoryTree();
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        PG.DataBind();
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        Name.Text = string.Empty;
        SearchDescriptions.Checked = false;
        Sku.Text = string.Empty;
        CategoriesList.SelectedIndex = 0;
        FromPrice.Text = string.Empty;
        ToPrice.Text = string.Empty;
        ManufacturerList.SelectedIndex = 0;
        VendorList.SelectedIndex = 0;
        ProductGroups.SelectedIndex = 0;
        TaxCodeList.SelectedIndex = 0;
        OnlyDigitalGoods.Checked = false;
        OnlyGiftCertificates.Checked = false;
        OnlyKits.Checked = false;
        OnlySubscriptions.Checked = false;
        FeaturedFilter.SelectedIndex = 1;
        ShowProductThumbnails.Checked = false;
        PG.DataBind();
    }

    protected void GoButton_Click(object sender, EventArgs e)
    {
        bool selectAll = AlwaysConvert.ToBool(SelectAll.Value, false);
        bool link = AlwaysConvert.ToBool(GridActions.SelectedValue, false);
        if (selectAll)
        {
            BitFieldState featured = (BitFieldState)Enum.Parse(typeof(BitFieldState), FeaturedFilter.SelectedValue);
            IList<Product> products = ProductDataSource.FindProducts(Name.Text.Trim(), SearchDescriptions.Checked, Sku.Text.Trim(), AlwaysConvert.ToInt(CategoriesList.SelectedValue), AlwaysConvert.ToInt(ManufacturerList.SelectedValue), AlwaysConvert.ToInt(VendorList.SelectedValue), featured, AlwaysConvert.ToInt(TaxCodeList.SelectedValue), AlwaysConvert.ToDecimal(FromPrice.Text), AlwaysConvert.ToDecimal(ToPrice.Text), OnlyDigitalGoods.Checked, OnlyGiftCertificates.Checked, OnlyKits.Checked, OnlySubscriptions.Checked, AlwaysConvert.ToInt(ProductGroups.SelectedValue));
            foreach (var product in products)
            {
                SetFeatured(product.Id, link);
            }
        }
        else
        {
            int indexPeg = PG.PageSize * PG.PageIndex;

            foreach (GridViewRow row in PG.Rows)
            {
                CheckBox selected = (CheckBox)PageHelper.RecursiveFindControl(row, "PID");
                if ((selected != null) && selected.Checked)
                {
                    int productId = (int)PG.DataKeys[row.DataItemIndex - indexPeg].Values[0];
                    SetFeatured(productId, link);
                }
            }
        }

        PG.DataBind();
    }

    protected string GetVisibilityIconUrl(object dataItem)
    {
        return _IconPath + "Cms" + (((Product)dataItem).Visibility) + ".gif";
    }

    protected void AttachButton_Click(object sender, EventArgs e)
    {
        ImageButton attachButton = (ImageButton)sender;
        int dataItemIndex = AlwaysConvert.ToInt(attachButton.CommandArgument);
        GridView grid = PG;
        int productId = (int)grid.DataKeys[dataItemIndex].Value;
        SetFeatured(productId, true);
        ImageButton removeButton = attachButton.Parent.FindControl("RemoveButton") as ImageButton;
        if (removeButton != null) removeButton.Visible = true;
        attachButton.Visible = false;
        PG.DataBind();
    }

    protected void RemoveButton_Click(object sender, EventArgs e)
    {
        ImageButton removeButton = (ImageButton)sender;
        int dataItemIndex = AlwaysConvert.ToInt(removeButton.CommandArgument);
        GridView grid = PG;
        int productId = (int)grid.DataKeys[dataItemIndex].Value;
        SetFeatured(productId, false);
        ImageButton attachButton = removeButton.Parent.FindControl("AttachButton") as ImageButton;
        if (attachButton != null) attachButton.Visible = true;
        removeButton.Visible = false;
        PG.DataBind();
    }

    private void SetFeatured(int productId, bool featured)
    {
        Product product = ProductDataSource.Load(productId);
        if (product != null)
        {
            product.IsFeatured = featured;
            product.Save();
        }
    }

    protected bool IsProductFeatured(int productId)
    {
        Product product = ProductDataSource.Load(productId);
        if (product != null) return product.IsFeatured;
        return false;
    }

    protected void ProductsDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
    {
        switch (FeaturedFilter.SelectedIndex)
        {
            case 1: e.InputParameters["featured"] = BitFieldState.True; break;
            case 2: e.InputParameters["featured"] = BitFieldState.False; break;
            default: e.InputParameters["featured"] = BitFieldState.Any; break;
        }
        PG.Columns[1].Visible = ShowProductThumbnails.Checked;
    }

    protected string GetGroups(Object dataItem)
    {
        Product product = (Product)dataItem;
        List<string> groupNames = new List<string>();
        foreach (var pg in product.ProductGroups)
        {
            groupNames.Add(pg.Group.Name);
        }

        return string.Join(",", groupNames.ToArray());
    }

    protected void PG_DataBound(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (PG.Rows.Count == 0)
            {
                FeaturedFilter.ClearSelection();
                ListItem item = FeaturedFilter.Items.FindByValue("Any");
                if (item != null)
                    item.Selected = true;
                PG.DataBind();
            }
        }
    }

    protected void InitializeCategoryTree()
    {
        ListItemCollection items = new ListItemCollection();
        int st = 1;
        IList<CategoryLevelNode> categories = CategoryParentDataSource.GetCategoryLevels(0);
        foreach (CategoryLevelNode node in categories)
        {
            string prefix = string.Empty;
            for (int i = st; i <= node.CategoryLevel; i++) prefix += " . . ";
            items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
        }

        CategoriesList.DataSource = items;
        CategoriesList.DataBind();
    }
}
}
