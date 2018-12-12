using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI.WebControls.WebParts;
using CommerceBuilder.Catalog;
using CommerceBuilder.UI;
using CommerceBuilder.Products;

namespace AbleCommerce.Mobile.UserControls
{
    public partial class SimpleCategoryList : System.Web.UI.UserControl
    {
        private string _CssClass;
        private string _HeaderCssClass;
        private string _HeaderText;      
        private int _CategoryId = -1;
        private bool _ShowHeader = true;

        public int CategoryId
        {
            get { return _CategoryId; }
            set { _CategoryId = value; }
        }

        [Personalizable(), WebBrowsable()]
        public string CssClass
        {
            get { return _CssClass; }
            set { _CssClass = value; }
        }

        [Personalizable(), WebBrowsable()]
        public string HeaderCssClass
        {
            get { return _HeaderCssClass; }
            set { _HeaderCssClass = value; }
        }

        [Personalizable(), WebBrowsable()]
        public string HeaderText
        {
            get { return _HeaderText; }
            set { _HeaderText = value; }
        }

        [Personalizable(), WebBrowsable()]
        public bool ShowHeader
        {
            get { return _ShowHeader; }
            set { _ShowHeader = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(CssClass)) MainPanel.CssClass = CssClass;
            if (!string.IsNullOrEmpty(HeaderCssClass)) HeaderPanel.CssClass = HeaderCssClass;
            if (!string.IsNullOrEmpty(HeaderText)) HeaderTextLabel.Text = HeaderText;
            HeaderPanel.Visible = ShowHeader;
            if (_CategoryId < 0) _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            if (_CategoryId != 0)
            {
                Category cat = CategoryDataSource.Load(_CategoryId);
                if (cat != null)
                {
                    HeaderTextLabel.Text = cat.Name;
                }
            }
            IList<Category> subCategories = GetSubcategories(_CategoryId);

            IList<AccordionCategory> acCategories = new List<AccordionCategory>();
            foreach (Category cat in subCategories)
            {
                AccordionCategory item = new AccordionCategory();
                item.Id = cat.Id;
                item.Name = cat.Name;
                item.NavigateUrl = cat.NavigateUrl;
                item.SubCategories = GetSubcategories(cat.Id);
                acCategories.Add(item);
            }

            if (acCategories.Count == 0)
            {
                this.Controls.Clear();
            }
            else
            {
                CategoryAccordian.DataSource = acCategories;
                CategoryAccordian.DataBind();
            }
        }

        protected IList<Category> GetSubcategories(int categoryId)
        {
            return CategoryDataSource.LoadForParent(categoryId, true);
        }

        protected bool HasChildCategories(Category cat)
        {            
            if (cat == null) return false;
            return CategoryDataSource.CountForParent(cat.Id, true) > 0;
        }

        protected bool HasChildProducts(Category cat)
        {            
            if (cat == null) return false;
            return ProductDataSource.CountForCategory(cat.Id, false, true) > 0;
        }

        protected bool IsExpandable(Object obj)
        {
            Category cat = obj as Category;
            if (cat == null) return false;
            return (HasChildCategories(cat) && !HasChildProducts(cat));            
        }

        protected class AccordionCategory
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string NavigateUrl { get; set; }
            public IList<Category> SubCategories { get; set; }

            public bool HasChildCategories
            {
                get
                {
                    return SubCategories != null && SubCategories.Count > 0;
                }
            }

            public bool IsExpandable 
            {
                get
                {
                    return HasChildCategories && !HasChildProducts;
                }
            }

            private int childProdCount = -1;
            public bool HasChildProducts 
            {
                get
                {
                    if (childProdCount == -1)
                    {
                        childProdCount = ProductDataSource.CountForCategory(Id, false, true);
                    }

                    return childProdCount > 0;
                }
            }
        }
    }
}
