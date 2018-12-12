namespace AbleCommerce.Admin.Catalog
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Products;
    
    public partial class SortCategory : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CategoryId;
        private Category _Category;
        private IList<CatalogNode> _CatalogNodes;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _Category = CategoryDataSource.Load(_CategoryId);
            _CatalogNodes = CatalogDataSource.LoadForCategory(_CategoryId, false);
            if (_CatalogNodes != null && _CatalogNodes.Count > 0)
            {
                if (_Category == null)
                    Caption.Text += " Sort Items in Root Category";
                else
                    Caption.Text += " Sort Items in " + _Category.Name;
                if (!Page.IsPostBack)
                {
                    BindCatalogNodesList();
                }
            }
            else
                Response.Redirect("Browse.aspx");
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Browse.aspx?CategoryId=" + _CategoryId.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(SortOrder.Value))
            {
                AbleContext.Current.Database.BeginTransaction();
                IList<CatalogNode> catalogNodes = _CatalogNodes;
                string[] catalogNodesIds = SortOrder.Value.Split(",".ToCharArray());
                int order = 0;
                int tempId = 0;
                int index = -1;
                foreach (string sPartId in catalogNodesIds)
                {
                    foreach (CatalogNode cn in _CatalogNodes)
                    {
                        tempId = AlwaysConvert.ToInt(sPartId);
                        if (cn.CatalogNodeId == tempId)
                        {
                            index = catalogNodes.IndexOf(cn);
                            if (index > -1)
                            {
                                catalogNodes[index].OrderBy = (short)order;
                            }
                            order++;
                        }
                        cn.Save();
                    }

                    // recalculate orderby for child products
                    foreach (CatalogNode cn in _CatalogNodes)
                    {
                        if (cn.CatalogNodeType == CatalogNodeType.Product)
                        {
                            Product tempProduct = cn.ChildObject as Product;
                            if (tempProduct != null)
                            {
                                tempProduct.RecalculateOrderBy();
                                tempProduct.Save();
                            }
                        }
                    }
                }

                AbleContext.Current.Database.CommitTransaction();
            }
            
            Response.Redirect("Browse.aspx?CategoryId=" + _CategoryId.ToString());
        }

        protected void QuickSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            IList<CatalogNode> catalogNodes = new List<CatalogNode>();
            foreach (CatalogNode catalogNode in _CatalogNodes)
            {
                catalogNodes.Add(catalogNode);
            }
            switch (QuickSort.SelectedIndex)
            {
                case 2:
                    catalogNodes.Sort("Name", CommerceBuilder.Common.SortDirection.DESC);
                    break;
                default:
                    catalogNodes.Sort("Name", CommerceBuilder.Common.SortDirection.ASC);
                    break;
            }
            CatalogNodeList.DataSource = catalogNodes;
            CatalogNodeList.DataBind();
            QuickSort.SelectedIndex = 0;
        }

        private void BindCatalogNodesList()
        {
            IList<CatalogNode> catalogNodes = new List<CatalogNode>();
            foreach (CatalogNode catalogNode in _CatalogNodes)
            {
                catalogNodes.Add(catalogNode);
            }
            CatalogNodeList.DataSource = catalogNodes;
            CatalogNodeList.DataBind();
        }
    }
}