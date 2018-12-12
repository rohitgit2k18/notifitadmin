using System;
using System.Data;
using System.Linq;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Products;
using CommerceBuilder.Catalog;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;
using CommerceBuilder.Extensions;

namespace AbleCommerce.Admin.Products.Kits
{
public partial class EditKit : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected int _CategoryId = 0;
    protected int _ProductId = 0;
    private Product _Product;
    private Kit _Kit;

    protected void Page_Load(object sender, EventArgs e)
    {
        AddExistingComponentButton.NavigateUrl = "AttachComponent.aspx?ProductId=" + _ProductId.ToString();
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
        _Product = ProductDataSource.Load(_ProductId);
        _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
        if (_Product == null) Response.Redirect("../../Catalog/Browse.aspx?CategoryId=" + _CategoryId);

        // PREVENT CREATION OF RECURSIVE KITS (MEMBER PRODUCTS CANNOT BE MASTER PRODUCTS)
        if (_Product.KitStatus == KitStatus.Member) Response.Redirect("ViewKitProduct.aspx?CategoryId=" + _CategoryId + "&ProductId=" + _ProductId.ToString());
        _Kit = _Product.Kit;

        // INITIALIZE PAGE ELEMENTS
        Caption.Text = string.Format(Caption.Text, _Product.Name);
        SortComponents.NavigateUrl += "?ProductId=" + _ProductId;
        if (!Page.IsPostBack)
        {
            if(_Kit != null)
                ItemizedDisplayOption.SelectedIndex = _Kit.ItemizeDisplay ? 1 : 0;
        }
        AttachLink.NavigateUrl += "?CategoryId=" + _CategoryId + "&ProductId=" + _ProductId;

        // POPULATE THE ADD COMPONENT INPUT TYPE LIST
        foreach (string inputName in Enum.GetNames(typeof(KitInputType)))
        {
            AddComponentInputTypeId.Items.Add(new ListItem(FixInputTypeName(inputName), Enum.Parse(typeof(KitInputType), inputName).ToString()));
        }
        AddComponentInputTypeId.SelectedIndex = 1;

        if (Page.IsPostBack)
        {
            BindComponentList();
        }
 
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        if (_Kit != null)
            ItemizedDisplay.Text = _Kit.ItemizeDisplay ? "Itemized" : "Bundle";
        BindComponentList();
    }

    protected string FixInputTypeName(string name)
    {
        switch (name.ToUpperInvariant())
        {
            case "INCLUDEDHIDDEN":
                return "Included - Hidden";
            case "INCLUDEDSHOWN":
                return "Included - Shown";
            default:
                return Regex.Replace(name, "([A-Z])", " $1").Trim();
        }
    }

    protected void BindComponentList()
    {
        List<KitComponent> components = new List<KitComponent>();
        foreach (ProductKitComponent pkc in _Product.ProductKitComponents)
        {
            KitComponent kc = pkc.KitComponent;
            if (kc != null)
            {
                kc.RemoveInvalidKitProducts();
                components.Add(kc);
            }
        }
        if (components.Count > 0)
        {
            if (_Kit == null)
            {
                // WE MUST HAVE KIT TO BIND COMPONENTS
                _Kit = new Kit(_Product, false);
                _Kit.Save();
            }
            ComponentList.DataSource = components;
            ComponentList.DataBind();
            SortComponents.Visible = (components.Count > 1);
            PriceRange.Text = string.Format("{0} - {1}", _Kit.MinPrice.LSCurrencyFormat("lc"), _Kit.MaxPrice.LSCurrencyFormat("lc"));
            DefaultPrice.Text = _Kit.DefaultPrice.LSCurrencyFormat("lc");
            WeightRange.Text = string.Format("{0:F2} - {1:F2}", _Kit.MinWeight, _Kit.MaxWeight);
            DefaultWeight.Text = string.Format("{0:F2}", _Kit.DefaultWeight);
            ExistingKitPanel.Visible = true;
            NewKitPanel.Visible = false;
        }
        else
        {
            ExistingKitPanel.Visible = false;
            NewKitPanel.Visible = true;
        }
    }

    protected void MoveKitProduct(KitProduct kitProduct, int direction)
    {
        //MAKE SURE ALL KIT PRODUCTS ARE IN CORRECT ORDER
        short orderBy = -1;
        int index = -1;
        KitComponent kitComponent = kitProduct.KitComponent;
        foreach (KitProduct kp in kitComponent.KitProducts)
        {
            orderBy += 1;
            kp.OrderBy = orderBy;
            if (kp.Id.Equals(kitProduct.Id)) index = orderBy;
        }
        //LOCATE THE DESIRED ITEM
        if (index > -1)
        {
            KitProduct temp = null;
            if (direction < 0 && index > 0)
            {
                //MOVE UP
                temp = kitComponent.KitProducts[index];
                temp.OrderBy -= 1;
                kitComponent.KitProducts[index] = kitComponent.KitProducts[index - 1];
                kitComponent.KitProducts[index].OrderBy += 1;
                kitComponent.KitProducts[index - 1] = temp;
                kitComponent.KitProducts.Save();
            }
            else if (direction > 0 && index < kitComponent.KitProducts.Count - 1)
            {
                //MOVEDOWN
                temp = kitComponent.KitProducts[index];
                temp.OrderBy += 1;
                kitComponent.KitProducts[index] = kitComponent.KitProducts[index + 1];
                kitComponent.KitProducts[index].OrderBy -= 1;
                kitComponent.KitProducts[index + 1] = temp;
                kitComponent.KitProducts.Save();
            }
        }
    }

    protected void KitProductList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DoDelete")
        {
            int kitProductId = AlwaysConvert.ToInt(e.CommandArgument);
            KitProduct kitProduct = KitProductDataSource.Load(kitProductId);
            if (kitProduct != null)
            {
                int index = kitProduct.KitComponent.KitProducts.IndexOf(kitProductId);
                if (index >= 0) kitProduct.KitComponent.KitProducts.RemoveAt(index);

                kitProduct.Delete();
            }
        }
    }

    protected void ComponentList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int kitComponentId = AlwaysConvert.ToInt(e.CommandArgument);
        KitComponent kitComponent = KitComponentDataSource.Load(kitComponentId);
        if (kitComponent != null)
        {
            switch (e.CommandName)
            {
                case "Branch":
                    // locate the product relationship
                    ProductKitComponent pkc = _Product.ProductKitComponents.FirstOrDefault(x => x.KitComponentId == kitComponent.Id);
                    if (pkc != null)
                    {
                        // create a copy of the component
                        KitComponent branchedComponent = kitComponent.Copy(true);
                        branchedComponent.Save();

                        // update the product relationship
                        _Product.ProductKitComponents.Add(new ProductKitComponent(_Product, branchedComponent, pkc.OrderBy));
                        _Product.ProductKitComponents.DeleteAt(_Product.ProductKitComponents.IndexOf(pkc));
                        _Product.Save();
                    }
                    break;
                case "Delete":
                    AbleContext.Current.Database.BeginTransaction();
                    ProductKitComponent matchingComponent = _Product.ProductKitComponents.FirstOrDefault(x => x.KitComponentId == kitComponentId);
                    if (matchingComponent != null)
                    {
                        int index = _Product.ProductKitComponents.IndexOf(matchingComponent);
                        if (index > -1)
                        {
                            _Product.ProductKitComponents.RemoveAt(index);
                            _Product.Save();
                        }
                    }
                    kitComponent.Delete();

                    // DELETE THE KIT RECORD IF NO COMPONENTS REMAINING
                    if (_Product.ProductKitComponents.Count == 0)
                    {
                        Kit kit = _Product.Kit;
                        _Product.Kit = null;
                        _Product.Save();
                        kit.Delete();
                    }
                    AbleContext.Current.Database.CommitTransaction();
                    ComponentList.DataBind();
                    break;
            }
        }
    }

    protected string GetDeleteSharedComponentLink(object dataItem)
    {
        KitComponent kc = (KitComponent)dataItem;
        return string.Format("DeleteSharedComponent.aspx?CategoryId={0}&ProductId={1}&KitComponentId={2}", _CategoryId, _ProductId, kc.Id);
    }

    protected string GetEditKitProductLink(object dataItem)
    {
        KitProduct kp = (KitProduct)dataItem;
        return string.Format("EditKitProduct.aspx?CategoryId={0}&ProductId={1}&KitComponentId={2}&KitProductId={3}", _CategoryId, _ProductId, kp.KitComponentId, kp.Id);
    }

    #region Add Component
    protected void AddComponentButton_Click(object sender, EventArgs e)
    {
        AddComponentPopup.Show();
    }

    protected void AddComponentCancelButton_Click(object sender, EventArgs e)
    {
        // RESET THE ADD COMPONENT DIALOG
        AddComponentName.Text = string.Empty;
        AddComponentInputTypeId.SelectedIndex = 1;
        AddComponentPopup.Hide();
    }

    protected void AddComponentSaveButton_Click(object sender, EventArgs e)
    {
        if (_Kit == null)
        { 
            // WE MUST HAVE KIT TO HAVE KIT COMPONENTS
            _Kit = new Kit(_Product, false);
            _Kit.Save();
        }

        // CREATE THE KIT COMPONENT
        KitComponent component = new KitComponent();
        component.Name = AddComponentName.Text;
        component.InputTypeId = (short)(AddComponentInputTypeId.SelectedIndex);
        //component.HeaderOption = HeaderOption.Text;
        component.Save();

        // ASSOCIATE KIT COMPONENT TO THE PRODUCT
        _Product.ProductKitComponents.Add(new ProductKitComponent(_Product, component));
        _Product.Save();

        // RESET THE ADD COMPONENT DIALOG
        AddComponentName.Text = string.Empty;
        AddComponentInputTypeId.SelectedIndex = 1;
    }
    #endregion

    protected void ItemizedDisplayOkButton_Click(object sender, EventArgs e)
    {
        _Kit.ItemizeDisplay = (AlwaysConvert.ToInt(ItemizedDisplayOption.SelectedValue) != 0);
        _Kit.Save();
    }

}
}
