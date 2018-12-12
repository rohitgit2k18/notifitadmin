namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Search;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;

    public partial class EditProductAccessories : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;
        private int productId;
        private string _IconPath = string.Empty;

        protected void Page_Init(object sender, EventArgs e)
        {
            productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            InstructionText.Text = string.Format(InstructionText.Text, _Product.Name);
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
            FindAssignProducts1.AssignmentValue = _Product.Id;
            FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
            FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
            FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
        }

        protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
        {
            SetLink(e.ProductId, e.Link);
        }

        protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
        {
            e.Link = IsProductLinked(e.Product);
        }

        protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
        {
            Response.Redirect("EditProductAccessories.aspx?ProductId=" + productId);
        }

        protected void UpsellProductGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MoveUp")
            {
                IList<UpsellProduct> UpsellProducts = _Product.UpsellProducts;
                int itemIndex = AlwaysConvert.ToInt(e.CommandArgument);
                if ((itemIndex < 1) || (itemIndex > UpsellProducts.Count - 1)) return;
                UpsellProduct selectedItem = UpsellProducts[itemIndex];
                UpsellProduct swapItem = UpsellProducts[itemIndex - 1];
                UpsellProducts.RemoveAt(itemIndex - 1);
                UpsellProducts.Insert(itemIndex, swapItem);
                for (int i = 0; i < UpsellProducts.Count; i++)
                {
                    UpsellProducts[i].OrderBy = (short)i;
                }
                UpsellProducts.Save();
                UpsellProductGrid.DataBind();
            }
            else if (e.CommandName == "MoveDown")
            {
                IList<UpsellProduct> UpsellProducts = _Product.UpsellProducts;
                int itemIndex = AlwaysConvert.ToInt(e.CommandArgument);
                if ((itemIndex > UpsellProducts.Count - 2) || (itemIndex < 0)) return;
                UpsellProduct selectedItem = UpsellProducts[itemIndex];
                UpsellProduct swapItem = UpsellProducts[itemIndex + 1];
                UpsellProducts.RemoveAt(itemIndex + 1);
                UpsellProducts.Insert(itemIndex, swapItem);
                for (int i = 0; i < UpsellProducts.Count; i++)
                {
                    UpsellProducts[i].OrderBy = (short)i;
                }
                UpsellProducts.Save();
                UpsellProductGrid.DataBind();
            }
        }

        private void SetLink(int upsellProductId, bool linked)
        {
            int index = _Product.UpsellProducts.IndexOf(_Product.Id, upsellProductId);
            if (linked && (index < 0))
            {
                _Product.UpsellProducts.Add(new UpsellProduct(_Product.Id, upsellProductId));
                _Product.Save();
            }
            else if (!linked && (index > -1))
            {
                _Product.UpsellProducts.DeleteAt(index);
            }
        }

        protected bool IsProductLinked(Product product)
        {
            return (_Product.UpsellProducts.IndexOf(_Product.Id, product.Id) > -1);
        }

        protected void UpsellProductGrid_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int upsellProductId = (int)e.Keys[0];
            SetLink(upsellProductId, false);
            //CHECK THE SEARCH RESULTS GRID TO SEE IF THIS ITEMS APPEARS
            int tempIndex = 0;
            foreach (DataKey key in UpsellProductGrid.DataKeys)
            {
                int tempId = (int)key.Value;
                if (upsellProductId == tempId)
                {
                    //CHANGE THE REMOVE BUTTON TO ADD FOR THIS ROW
                    ImageButton removeButton = UpsellProductGrid.Rows[tempIndex].FindControl("RemoveButton") as ImageButton;
                    if (removeButton != null) removeButton.Visible = false;
                    ImageButton attachButton = UpsellProductGrid.Rows[tempIndex].FindControl("AttachButton") as ImageButton;
                    if (attachButton != null) attachButton.Visible = true;
                    break;
                }
                tempIndex++;
            }
            UpsellProductGrid.DataBind();
            e.Cancel = true;
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

        protected string GetVisibilityIconUrl(object dataItem)
        {
            return _IconPath + "Cms" + (((Product)dataItem).Visibility) + ".gif";
        }

        protected string GetPreviewUrl(object dataItem)
        {
            Product product = (Product)dataItem;
            return Page.ResolveUrl(product.NavigateUrl);
        }

        protected void FindAssignButton_Click(object sender, EventArgs e) 
        {
            FindAssignPanel.Visible = true;
            UpsellProductsPanel.Visible = false;
        }
    }
}