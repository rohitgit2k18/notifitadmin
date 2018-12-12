using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.ConLib
{
    public partial class CategoryTree : System.Web.UI.UserControl
    {
        public int[] SelectedCategories
        {
            get
            {
                List<int> categories = new List<int>();
                foreach (TreeNode node in t.CheckedNodes)
                {
                    categories.Add(Convert.ToInt32(node.Value));
                }
                return categories.ToArray();
            }
            set
            {
                // uncheck any checked nodes
                foreach (TreeNode node in t.CheckedNodes)
                {
                    node.Checked = false;
                }
                if (value != null && value.Length > 0)
                {
                    foreach (int categoryId in value)
                    {
                        TreeNodeCollection treeNodes = t.Nodes;
                        IList<CatalogPathNode> path = CatalogDataSource.GetPath(categoryId, false);
                        for (int i = 0; i< path.Count-1; i++)
                        {
                            int parentId = path[i].CatalogNodeId;
                            TreeNode treeNode = FindTreeNode(treeNodes, parentId);
                            if (treeNode != null)
                            {
                                PopulateNode(treeNode);
                                treeNodes = treeNode.ChildNodes;
                            }
                        }
                        TreeNode targetNode = FindTreeNode(treeNodes, categoryId);
                        if (targetNode != null)
                        {
                            targetNode.Checked = true;
                        }
                    }
                }
            }
        }

        private TreeNode FindTreeNode(TreeNodeCollection nodes, int categoryId)
        {
            foreach (TreeNode node in nodes)
            {
                if (node.Value == categoryId.ToString()) return node;
            }
            return null;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                IList<Category> categories = CategoryDataSource.LoadForParent(0, false);
                foreach (Category category in categories)
                {
                    TreeNode node = new TreeNode(category.Name, category.Id.ToString());
                    node.PopulateOnDemand = true;
                    node.SelectAction = TreeNodeSelectAction.SelectExpand;
                    t.Nodes.Add(node);
                }
            }
        }

        protected void PopulateNode(object sender, TreeNodeEventArgs e)
        {
            PopulateNode(e.Node);
        }

        protected void PopulateNode(TreeNode node)
        {
            if (node.ChildNodes.Count == 0)
            {
                int categoryId = Convert.ToInt32(node.Value);
                Category category = CategoryDataSource.Load(categoryId);
                foreach (CatalogNode catalogNode in category.CatalogNodes.Where(x => x.CatalogNodeType == CatalogNodeType.Category))
                {
                    Category subcategory = (Category)catalogNode.ChildObject;
                    TreeNode childNode = new TreeNode(subcategory.Name, subcategory.Id.ToString());
                    childNode.PopulateOnDemand = true;
                    childNode.SelectAction = TreeNodeSelectAction.SelectExpand;
                    node.ChildNodes.Add(childNode);
                }
            }
            node.PopulateOnDemand = false;
            node.Expanded = true;
        }
    }
}