namespace AbleCommerce.Admin.Products.ProductTemplates
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Search;
    using System.Web.Script.Serialization;
    using System.Web.Services;
    using CommerceBuilder.Common;
    using System.Collections.Generic;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;

    public partial class ViewProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _ProductTemplateId;
        private ProductTemplate _ProductTemplate;
        private string _IconPath = string.Empty;

        protected void Page_Init(object sender, EventArgs e)
        {
            _ProductTemplateId = AlwaysConvert.ToInt(Request.QueryString["ProductTemplateId"]);
            _ProductTemplate = ProductTemplateDataSource.Load(_ProductTemplateId);
            if (_ProductTemplate == null) Response.Redirect("Default.aspx");
            Caption.Text = string.Format(Caption.Text, _ProductTemplate.Name);
            _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
            FindAssignProducts1.AssignmentValue = _ProductTemplateId;
            FindAssignProducts1.OnAssignProduct += new AssignProductEventHandler(FindAssignProducts1_AssignProduct);
            FindAssignProducts1.OnLinkCheck += new AssignProductEventHandler(FindAssignProducts1_LinkCheck);
            FindAssignProducts1.OnCancel += new EventHandler(FindAssignProducts1_CancelButton);
        }

        protected void FindAssignProducts1_AssignProduct(object sender, FindAssignProductEventArgs e)
        {
            UpdateProductTemplateAssociation(e.ProductId, _ProductTemplateId, e.Link);
        }

        protected void FindAssignProducts1_LinkCheck(object sender, FindAssignProductEventArgs e)
        {
            e.Link = IsProductLinked(e.Product);
        }

        protected void FindAssignProducts1_CancelButton(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }

        private static void UpdateProductTemplateAssociation(int productId, int productTemplateId, bool linked)
        {
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                int templateIndex = product.ProductTemplates.IndexOf(productTemplateId);
                if (linked && templateIndex < 0)
                {
                    ProductTemplate pt = ProductTemplateDataSource.Load(productTemplateId);
                    product.ProductTemplates.Add(pt);
                    pt.Save();
                }
                else if (!linked && templateIndex > -1)
                {
                    product.ProductTemplates.RemoveAt(templateIndex);
                    product.Save();
                }
            }
        }

        protected bool IsProductLinked(Product product)
        {
            if (product != null)
            {
                foreach (ProductTemplate pt in product.ProductTemplates)
                {
                    if (pt.Id == _ProductTemplateId) return true;
                }
            }
            return false;
        }
    }
}