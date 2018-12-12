namespace AbleCommerce.Admin.Catalog
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class Browse : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private string _IconPath = string.Empty;
        private Category _CurrentCategory = null;

        protected Category CurrentCategory
        {
            get
            {
                if (_CurrentCategory == null)
                {
                    int currentCategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
                    if (currentCategoryId == 0)
                    {
                        _CurrentCategory = new Category();
                        _CurrentCategory.Id = 0;
                        _CurrentCategory.Name = "Catalog";
                        _CurrentCategory.Visibility = CatalogVisibility.Public;
                        _CurrentCategory.CatalogNodes.AddRange(CatalogNodeDataSource.LoadForCategory(0));
                    }
                    else _CurrentCategory = CategoryDataSource.Load(currentCategoryId);
                }
                return _CurrentCategory;
            }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // GET THE ICON PATH           
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
            
            // REGISTER DELETE SCRIPTS
            StringBuilder script = new StringBuilder();
            script.Append("function CD1(n) { return confirm(\"Are you sure you want to delete '\" + n + \"'?\") }\r\n");
            script.Append("function CD2(n) { return confirm(\"Are you sure you want to delete '\" + n + \"' and all its contents?\") }\r\n");
            Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "ConfirmDelete", script.ToString(), true);
        }

        protected string GetCatalogIconUrl(object dataItem)
        {
            CatalogNodeType nodeType = ((CatalogNode)dataItem).CatalogNodeType;
            switch (nodeType)
            {
                case CatalogNodeType.Category:
                    return _IconPath + "Category.gif";
                case CatalogNodeType.Product:
                    return _IconPath + "Product.gif";
                case CatalogNodeType.Webpage:
                    return _IconPath + "Webpage.gif";
                case CatalogNodeType.Link:
                    return _IconPath + "Link.gif";
            }
            return string.Empty;
        }

        protected string GetVisibilityIconUrl(object dataItem)
        {
            return _IconPath + "Cms" + (((CatalogNode)dataItem).Visibility) + ".gif";
        }

        protected string GetIconUrl(string icon)
        {
            return _IconPath + icon;
        }

        protected string GetBrowseUrl(object dataItem)
        {
            CatalogNode node = (CatalogNode)dataItem;
            switch (node.CatalogNodeType)
            {
                case CatalogNodeType.Category:
                    return "~/Admin/Catalog/Browse.aspx?CategoryId=" + node.CatalogNodeId.ToString();
                case CatalogNodeType.Product:
                    return "~/Admin/Products/EditProduct.aspx?CategoryId=" + CurrentCategory.Id.ToString() + "&ProductId=" + node.CatalogNodeId.ToString();
                case CatalogNodeType.Webpage:
                    return "~/Admin/Catalog/EditWebpage.aspx?CategoryId = " + CurrentCategory.Id.ToString() + "&WebpageId=" + node.CatalogNodeId.ToString();
                case CatalogNodeType.Link:
                    return "~/Admin/Catalog/EditLink.aspx?CategoryId = " + CurrentCategory.Id.ToString() + "&LinkId=" + node.CatalogNodeId.ToString();
            }
            return string.Empty;
        }

        protected string GetEditUrl(object dataItem, object dataItemId)
        {
            CatalogNodeType nodeType = (CatalogNodeType)dataItem;
            int catalogNodeId = (int)dataItemId;
            string url;
            switch (nodeType)
            {
                case CatalogNodeType.Category:
                    url = "~/Admin/Catalog/EditCategory.aspx?CategoryId=" + catalogNodeId.ToString();
                    break;
                case CatalogNodeType.Product:
                    url = "~/Admin/products/EditProduct.aspx?ProductId=" + catalogNodeId.ToString() + "&CategoryId=" + this.CurrentCategory.Id.ToString();
                    break;
                case CatalogNodeType.Webpage:
                    url = "~/Admin/Catalog/EditWebpage.aspx?WebpageId=" + catalogNodeId.ToString() + "&CategoryId=" + this.CurrentCategory.Id.ToString();
                    break;
                case CatalogNodeType.Link:
                    url = "~/Admin/Catalog/EditLink.aspx?LinkId=" + catalogNodeId.ToString() + "&CategoryId=" + this.CurrentCategory.Id.ToString();
                    break;
                default:
                    url = "~/Admin/Catalog/Browse.aspx";
                    break;
            }
            return Page.ResolveUrl(url);
        }

        protected string GetPreviewUrl(object dataItem, object dataItemId, object dataItemName)
        {
            CatalogNodeType nodeType = (CatalogNodeType)dataItem;
            int catalogNodeId = (int)dataItemId;
            string nodeName = (string)dataItemName;
            string url = UrlGenerator.GetBrowseUrl(catalogNodeId, nodeType, nodeName);
            return Page.ResolveUrl(url);
        }

        protected void CGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName.StartsWith("Do_"))
            {
                string[] args = e.CommandArgument.ToString().Split("|".ToCharArray());
                CatalogNodeType catalogNodeType = (CatalogNodeType)AlwaysConvert.ToInt(args[0]);
                int catalogNodeId = AlwaysConvert.ToInt(args[1]);
                int index;
                switch (e.CommandName)
                {
                    case "Do_Copy":
                        CatalogDataSource.Copy(catalogNodeId, catalogNodeType, CurrentCategory.Id);
                        break;
                    case "Do_Delete":
                        DoDelete(catalogNodeType, catalogNodeId);
                        break;
                    case "Do_Up":
                        index = CurrentCategory.CatalogNodes.IndexOf(CurrentCategory.Id, catalogNodeId, (byte)catalogNodeType);
                        if (index > 0)
                        {
                            CatalogNode tempNode = CurrentCategory.CatalogNodes[index - 1];
                            CurrentCategory.CatalogNodes[index - 1] = CurrentCategory.CatalogNodes[index];
                            CurrentCategory.CatalogNodes[index] = tempNode;
                            short newOrderBy = 0;
                            foreach (CatalogNode node in CurrentCategory.CatalogNodes)
                            {
                                node.OrderBy = newOrderBy;
                                node.Save();
                                newOrderBy++;
                            }

                            // recalculate orderby for impacted child products
                            RecalculateOrderBy(CurrentCategory.CatalogNodes[index - 1]);
                            RecalculateOrderBy(CurrentCategory.CatalogNodes[index]);
                        }
                        break;
                    case "Do_Down":
                        index = CurrentCategory.CatalogNodes.IndexOf(CurrentCategory.Id, catalogNodeId, (byte)catalogNodeType);
                        if (index < CurrentCategory.CatalogNodes.Count - 1)
                        {
                            CatalogNode tempNode = CurrentCategory.CatalogNodes[index + 1];
                            CurrentCategory.CatalogNodes[index + 1] = CurrentCategory.CatalogNodes[index];
                            CurrentCategory.CatalogNodes[index] = tempNode;
                            short newOrderBy = 0;
                            foreach (CatalogNode node in CurrentCategory.CatalogNodes)
                            {
                                node.OrderBy = newOrderBy;
                                node.Save();
                                newOrderBy++;
                            }

                            // recalculate orderby for impacted child products
                            RecalculateOrderBy(CurrentCategory.CatalogNodes[index + 1]);
                            RecalculateOrderBy(CurrentCategory.CatalogNodes[index]);
                        }
                        break;
                    case "Do_Pub":
                        index = CurrentCategory.CatalogNodes.IndexOf(CurrentCategory.Id, catalogNodeId, (byte)catalogNodeType);
                        if (index > -1)
                        {
                            CatalogNode node = CurrentCategory.CatalogNodes[index];
                            //FOR CATEGORIES, WE MUST FIND OUT MORE INFORMATION
                            if (node.CatalogNodeType == CatalogNodeType.Category)
                                Response.Redirect("ChangeVisibility.aspx?CategoryId=" + CurrentCategory.Id.ToString() + String.Format("&Objects={0}:{1}", node.CatalogNodeId, (byte)node.CatalogNodeType));
                            //FOR OTHER OBJECTS, WE CAN ADJUST
                            switch (node.Visibility)
                            {
                                case CatalogVisibility.Public:
                                    node.Visibility = CatalogVisibility.Hidden;
                                    break;
                                case CatalogVisibility.Hidden:
                                    node.Visibility = CatalogVisibility.Private;
                                    break;
                                default:
                                    node.Visibility = CatalogVisibility.Public;
                                    break;
                            }
                            node.ChildObject.Visibility = node.Visibility;
                            node.Save(true);
                        }
                        break;
                }
            }
        }

        protected void CGrid_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // UPDATE DELETE BUTTON WARNING
                CatalogNode node = (CatalogNode)e.Row.DataItem;
                LinkButton deleteButton = e.Row.FindControl("D") as LinkButton;
                if (deleteButton != null)
                {
                    string name = StringHelper.EscapeSpecialCharacters(node.Name);
                    if (node.CatalogNodeType != CatalogNodeType.Category) deleteButton.Attributes.Add("onclick", "return CD1(\"" + name + "\")");
                    else deleteButton.Attributes.Add("onclick", "return CD2(\"" + name + "\")");
                }
            }
            else
                if (e.Row.RowType == DataControlRowType.EmptyDataRow)
                {
                    HyperLink addCategoryLink = e.Row.FindControl("AddCategoryLink") as HyperLink;
                    addCategoryLink.NavigateUrl = "AddCategory.aspx?ParentCategoryId=" + CurrentCategory.Id.ToString();
                    HyperLink addProductLink = e.Row.FindControl("AddProductLink") as HyperLink;
                    HyperLink addWebpageLink = e.Row.FindControl("AddWebpageLink") as HyperLink;
                    HyperLink addLinkLink = e.Row.FindControl("AddLinkLink") as HyperLink;
                    if (CurrentCategory.Id > 0)
                    {
                        addProductLink.Visible = true;
                        addProductLink.NavigateUrl += "?CategoryId=" + CurrentCategory.Id.ToString();
                        addWebpageLink.Visible = true;
                        addWebpageLink.NavigateUrl += "?CategoryId=" + CurrentCategory.Id.ToString();
                        addLinkLink.Visible = true;
                        addLinkLink.NavigateUrl += "?CategoryId=" + CurrentCategory.Id.ToString();
                    }
                    else
                    {
                        addCategoryLink.Visible = false;
                        addProductLink.Visible = false;
                        addWebpageLink.Visible = false;
                        addLinkLink.Visible = false;
                    }
                }
        }

        protected void DoDelete(CatalogNodeType catalogNodeType, int catalogNodeId)
        {
            switch (catalogNodeType)
            {
                case CatalogNodeType.Category:
                    Category category = CategoryDataSource.Load(catalogNodeId);
                    if (category != null) category.Delete();
                    break;
                case CatalogNodeType.Product:
                    Product product = ProductDataSource.Load(catalogNodeId);
                    if (product != null)
                    {
                        if (product.Categories.Count > 1)
                        {
                            product.Categories.Remove(CurrentCategory.Id);
                            product.Categories.Save();
                        }
                        else product.Delete();
                    }
                    break;
                case CatalogNodeType.Webpage:
                    Webpage webpage = WebpageDataSource.Load(catalogNodeId);
                    if (webpage != null)
                    {
                        if (webpage.Categories.Count > 1)
                        {
                            webpage.Categories.Remove(CurrentCategory.Id);
                            webpage.Categories.Save();
                        }
                        else webpage.Delete();
                    }
                    break;
                case CatalogNodeType.Link:
                    Link link = LinkDataSource.Load(catalogNodeId);
                    if (link != null)
                    {
                        if (link.Categories.Count > 1)
                        {
                            link.Categories.Remove(CurrentCategory.Id);
                            link.Categories.Save();
                        }
                        else link.Delete();
                    }
                    break;
            }
        }

        protected void AddCategory_Click(object sender, EventArgs e)
        {
            string tempName = AddCategoryName.Text.Trim();
            if (tempName.Length > 0)
            {
                Category newCategory = new Category();
                newCategory.ParentId = this.CurrentCategory.Id;
                newCategory.Name = AddCategoryName.Text;
                newCategory.Visibility = CatalogVisibility.Public;
                newCategory.Save();
                CategoryAddedMessage.Visible = true;
                CategoryAddedMessage.Text = string.Format(CategoryAddedMessage.Text, newCategory.Name);
                AddCategoryName.Text = string.Empty;
            }
        }

        protected void Search_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(SearchPhrase.Text))
            {
                List<string> typeFilter = new List<string>();
                if (IncludeCategories.Checked) typeFilter.Add("0");
                if (IncludeProducts.Checked) typeFilter.Add("1");
                if (IncludeWebpages.Checked) typeFilter.Add("2");
                if (IncludeLinks.Checked) typeFilter.Add("3");
                string types = string.Join(",", typeFilter.ToArray());
                if (!string.IsNullOrEmpty(types))
                {
                    Response.Redirect("Search.aspx?CategoryId=" + CurrentCategory.Id.ToString() + "&k=" + Server.UrlEncode(SearchPhrase.Text) + "&titles=" + (TitlesOnly.Checked ? "1" : "0") + "&recurse=" + (Recursive.Checked ? "1" : "0") + "&types=" + types);
                }
            }
        }

        protected void CatalogDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["categoryId"] = CurrentCategory.Id;
        }

        #region "PreRender"
        protected void Page_PreRender(object sender, EventArgs e)
        {
            BindCategoryHeader();
            BindCGrid();
            BindActionMenu();
        }

        protected void BindCategoryHeader()
        {
            CategoryName.Text = CurrentCategory.Name;
            if (CurrentCategory.Id != 0)
            {
                ViewCategory.Visible = true;
                EditCategory.Visible = true;
                ViewCategory.NavigateUrl = UrlGenerator.GetBrowseUrl(CurrentCategory.Id, CurrentCategory.Name);
                EditCategory.NavigateUrl = "EditCategory.aspx?CategoryId=" + CurrentCategory.Id;
            }
            else
            {
                ViewCategory.Visible = false;
                EditCategory.Visible = false;
            }
            SortCategoryButton.NavigateUrl = string.Format(SortCategoryButton.NavigateUrl, CurrentCategory.Id);
        }

        protected void BindCGrid()
        {
            ParentCategory.Visible = (CurrentCategory != null && CurrentCategory.Id > 0);
            ContentsCaption.Text = string.Format(ContentsCaption.Text, CurrentCategory.Name);
            CGrid.DataBind();
        }

        protected void BindActionMenu()
        {
            AddCategoryLink.NavigateUrl = "AddCategory.aspx?ParentCategoryId=" + CurrentCategory.Id.ToString();
            if (CurrentCategory.Id > 0)
            {
                AddProductLink.Visible = true;
                AddProductLink.NavigateUrl += "?CategoryId=" + CurrentCategory.Id.ToString();
                AddWebpageLink.Visible = true;
                AddWebpageLink.NavigateUrl += "?CategoryId=" + CurrentCategory.Id.ToString();
                AddLinkLink.Visible = true;
                AddLinkLink.NavigateUrl += "?CategoryId=" + CurrentCategory.Id.ToString();
            }
            else
            {
                AddProductLink.Visible = false;
                AddWebpageLink.Visible = false;
                AddLinkLink.Visible = false;
            }
        }
        #endregion

        protected void CGrid_DataBound(object sender, EventArgs e)
        {
            List<string> categories = new List<string>();
            List<string> products = new List<string>();
            List<string> links = new List<string>();
            List<string> webpages = new List<string>();
            for (int i = 0; i < CGrid.Rows.Count; i++)
            {
                GridViewRow gvr = CGrid.Rows[i];
                CheckBox cb = (CheckBox)gvr.FindControl("Selected");

                DataKey dataKey = ((GridView)sender).DataKeys[gvr.DataItemIndex];
                int catalogNodeId = (int)dataKey.Values[0];
                CatalogNodeType catalogNodeType = (CatalogNodeType)dataKey.Values[1];
                switch (catalogNodeType)
                {
                    case CatalogNodeType.Category:
                        categories.Add(cb.ClientID);
                        break;
                    case CatalogNodeType.Product:
                        products.Add(cb.ClientID);
                        break;
                    case CatalogNodeType.Link:
                        links.Add(cb.ClientID);
                        break;
                    case CatalogNodeType.Webpage:
                        webpages.Add(cb.ClientID);
                        break;
                }
            }
            if (categories.Count > 0)
            {
                string catsArray = "new Array('" + String.Join("','", categories.ToArray()) + "')";
                SelectCategories.OnClientClick = "selectCatalogItems(" + catsArray + ");return false;";
            }
            else
                SelectCategories.OnClientClick = "return false;";

            if (products.Count > 0)
            {
                string productsArray = "new Array('" + String.Join("','", products.ToArray()) + "')";
                SelectProducts.OnClientClick = "selectCatalogItems(" + productsArray + ");return false;";
            }
            else
                SelectProducts.OnClientClick = "return false;";

            if (links.Count > 0)
            {
                string linksArray = "new Array('" + String.Join("','", links.ToArray()) + "')";
                SelectLinks.OnClientClick = "selectCatalogItems(" + linksArray + ");return false;";
            }
            else
                SelectLinks.OnClientClick = "return false;";

            if (webpages.Count > 0)
            {
                string catsArray = "new Array('" + String.Join("','", webpages.ToArray()) + "')";
                SelectWebpages.OnClientClick = "selectCatalogItems(" + catsArray + ");return false;";
            }
            else
                SelectWebpages.OnClientClick = "return false;";
        }

        protected void GoButton_Click(Object sender, EventArgs e)
        { 
            String selectedOption = BulkOptions.SelectedValue;
            if (!String.IsNullOrEmpty(selectedOption))
            {
                List<DataKey> selectedItems = GetSelectedItems();
                if (selectedItems.Count > 0)
                {
                    switch (selectedOption)
                    {
                        case "Move":
                            Response.Redirect("MoveCatalogObjects.aspx?CategoryId=" + CurrentCategory.Id + "&Objects=" + FormatSelectedItems(selectedItems));
                            break;
                        case "Delete":
                            IDatabaseSessionManager database = AbleContext.Current.Database;
                            database.BeginTransaction();
                            foreach (DataKey item in selectedItems)
                            {
                                DoDelete((CatalogNodeType)item.Values[1], (int)item.Values[0]);
                            }
                            database.CommitTransaction();
                            break;
                        case "ChangeVisibility":
                            Response.Redirect("ChangeVisibility.aspx?CategoryId=" + CurrentCategory.Id + "&Objects=" + FormatSelectedItems(selectedItems));
                            break;
                    }
                }
            }

            BulkOptions.SelectedIndex = 0;

            // DETERMINE IF THE CURRENT PAGE INDEX IS TOO FAR
            if (CGrid.PageIndex > 0)
            {
                decimal pageSize = (decimal)CGrid.PageSize;
                decimal totalObjects = (decimal)CatalogNodeDataSource.CountForCategory(CurrentCategory.Id);
                int lastPageIndex = (int)Math.Ceiling(totalObjects / pageSize) - 1;
                if (CGrid.PageIndex > lastPageIndex)
                {
                    // ALL ITEMS ON CURRENT PAGE > 1 WERE DELETED
                    // SET TO LAST CALCULATED PAGE INDEX
                    CGrid.PageIndex = lastPageIndex;
                }
            }
        }

        private string FormatSelectedItems(List<DataKey> selectedItems)
        {
            StringBuilder itemsBuilder = new StringBuilder();
            for (int i = 0; i < selectedItems.Count; i++)
            {
                DataKey item = selectedItems[i];
                // APPEND IN FORMAT "CatalogNodeId:CatalogNodeType"
                if (i == selectedItems.Count - 1) itemsBuilder.AppendFormat("{0}:{1}", item.Values[0], (byte)item.Values[1]);
                else itemsBuilder.AppendFormat("{0}:{1},", item.Values[0], (byte)item.Values[1]);
            }
            return itemsBuilder.ToString();
        }

        protected List<DataKey> GetSelectedItems()
        {
            List<DataKey> selectedItems = new List<DataKey>();
            foreach (GridViewRow row in CGrid.Rows)
            {
                CheckBox selected = (CheckBox)AbleCommerce.Code.PageHelper.RecursiveFindControl(row, "Selected");
                if ((selected != null) && selected.Checked)
                {
                    selectedItems.Add(CGrid.DataKeys[row.DataItemIndex]);
                }
            }
            return selectedItems;
        }

        /// <summary>
        /// Recalculates the order by for child product objects
        /// </summary>
        private void RecalculateOrderBy(CatalogNode node)
        {
            if (node.CatalogNodeType == CatalogNodeType.Product)
            {
                Product tempProduct = node.ChildObject as Product;
                if (tempProduct != null)
                {
                    tempProduct.RecalculateOrderBy();
                    tempProduct.Save();
                }
            }
        }

        protected void ParentCategory_Click(object sender, EventArgs e)
        {
            Response.Redirect("Browse.aspx" + ((CurrentCategory.ParentId > 0) ? string.Format("?CategoryId={0}", CurrentCategory.ParentId) : string.Empty));
        }
    }
}