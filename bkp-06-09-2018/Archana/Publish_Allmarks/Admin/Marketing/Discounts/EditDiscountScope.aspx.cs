namespace AbleCommerce.Admin.Marketing.Discounts
{
    using System;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.UI;

    public partial class EditDiscountScope : AbleCommerceAdminPage
    {
        private VolumeDiscount _VolumeDiscount;
        private int _VolumeDiscountId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            _VolumeDiscountId = AlwaysConvert.ToInt(Request.QueryString["VolumeDiscountId"]);
            _VolumeDiscount = VolumeDiscountDataSource.Load(_VolumeDiscountId);
            if (_VolumeDiscount == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, _VolumeDiscount.Name);
            if (!Page.IsPostBack)
            {
                // initialize the category tree
                CategoryTree.SelectedCategories = _VolumeDiscount.Categories.Select(x => x.Id).ToList().ToArray();
            }

            FindAssignProducts1.AssignmentValue = _VolumeDiscountId;
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
            e.Link = IsProductLinked(e.ProductId);
        }

        protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
        {
            Response.Redirect("EditDiscount.aspx?VolumeDiscountId=" + _VolumeDiscountId);
        }

        private void SetLink(int productId, bool linked)
        {
            int index = _VolumeDiscount.Products.IndexOf(productId);
            if (linked && (index < 0))
            {
                Product product = ProductDataSource.Load(productId);
                _VolumeDiscount.Products.Add(product);
                _VolumeDiscount.Save();
            }
            else if (!linked && (index > -1))
            {
                _VolumeDiscount.Products.RemoveAt(index);
                _VolumeDiscount.Save();
            }
        }

        protected bool IsProductLinked(int productId)
        {
            return (_VolumeDiscount.Products.IndexOf(productId) > -1);
        }

        protected void UpdateCategories()
        {
            // UPDATE CATEGORIES
            _VolumeDiscount.Categories.Clear();
            foreach (int categoryId in CategoryTree.SelectedCategories)
            {
                Category category = CategoryDataSource.Load(categoryId);
                _VolumeDiscount.Categories.Add(category);
            }
            _VolumeDiscount.Save();
        }

        protected void SaveCategoriesButton_Click(object sender, EventArgs e) 
        {
            UpdateCategories();
            CategoriesSavedMessage.Text = string.Format(CategoriesSavedMessage.Text, DateTime.Now);
            CategoriesSavedMessage.Visible = true;
        }

        protected void SaveAndCloseButton_Click(object sender, EventArgs e)
        {
            UpdateCategories();
            if (!string.IsNullOrEmpty(Request.QueryString["Edit"]))
            {
                Response.Redirect("EditDiscount.aspx?VolumeDiscountId=" + _VolumeDiscountId);
            }
            Response.Redirect("Default.aspx");
        }
    }
}