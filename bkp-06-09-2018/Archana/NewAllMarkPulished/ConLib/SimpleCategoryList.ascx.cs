namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.UI;

    [Description("A simple category list suitable for displaying in sidebar. It which shows the nested categories under the selected category.")]
    public partial class SimpleCategoryList : System.Web.UI.UserControl, ISidebarControl
    {
        private string _CssClass;
        private string _HeaderCssClass;
        private string _HeaderText;
        private string _ContentCssClass;

        private int _CategoryId = -1;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("-1")]
        [Description("The category id from which you want to list child categories")]
        public int CategoryId
        {
            get { return _CategoryId; }
            set { _CategoryId = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("innerSection")]
        [Description("The css class to apply on the main outer panel.")]
        public string CssClass
        {
            get { return _CssClass; }
            set { _CssClass = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("header")]
        [Description("The css class to apply on the header panel.")]
        public string HeaderCssClass
        {
            get { return _HeaderCssClass; }
            set { _HeaderCssClass = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Categories")]
        [Description("Title Text for the header.")]
        public string HeaderText
        {
            get { return _HeaderText; }
            set { _HeaderText = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("content")]
        [Description("The css class to apply on the content panel.")]
        public string ContentCssClass
        {
            get { return _ContentCssClass; }
            set { _ContentCssClass = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(CssClass)) MainPanel.CssClass = CssClass;
            if (!string.IsNullOrEmpty(HeaderCssClass)) HeaderPanel.CssClass = HeaderCssClass;
            if (!string.IsNullOrEmpty(HeaderText)) HeaderTextLabel.Text = HeaderText;
            if (!string.IsNullOrEmpty(ContentCssClass)) ContentPanel.CssClass = ContentCssClass;
            if (_CategoryId < 0) _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            IList<Category> subCategories = GetSubcategories(_CategoryId);
            CategoryList.DataSource = subCategories;
            CategoryList.DataBind();
            if (subCategories.Count == 0)
            {
                CategoryList.Visible = false;
                NoSubcategoryMessage.Visible = true;
            }
        }

        private IList<Category> GetSubcategories(int categoryId)
        {
            // GET ALL NODES IN THE CATEGORY
            IList<CatalogNode> allNodes = CatalogDataSource.LoadForCategory(categoryId, true, "OrderBy");

            // EXTRACT THE CATEGORY NODES
            IList<Category> categoryNodes = new List<Category>();
            foreach (CatalogNode node in allNodes)
            {
                if (node.CatalogNodeType == CatalogNodeType.Category && node.ChildObject != null)
                {
                    categoryNodes.Add((Category)node.ChildObject);
                }
            }
            return categoryNodes;
        }
    }
}