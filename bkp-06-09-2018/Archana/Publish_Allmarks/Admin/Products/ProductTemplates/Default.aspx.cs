namespace AbleCommerce.Admin.Products.ProductTemplates
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void AddButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                ProductTemplate pt = new ProductTemplate();
                pt.Name = AddName.Text;
                pt.Save();
                Response.Redirect("EditProductTemplate.aspx?ProductTemplateId=" + pt.Id.ToString());
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AbleCommerce.Code.PageHelper.SetDefaultButton(AddName, AddButton.ClientID);
        }

        protected int CountMerchantFields(object dataItem)
        {
            ProductTemplate template = (ProductTemplate)dataItem;
            int count = 0;
            foreach (InputField field in template.InputFields)
            {
                if (field.IsMerchantField) count++;
            }
            return count;
        }

        protected int CountCustomerFields(object dataItem)
        {
            ProductTemplate template = (ProductTemplate)dataItem;
            int count = 0;
            foreach (InputField field in template.InputFields)
            {
                if (!field.IsMerchantField) count++;
            }
            return count;
        }

        protected int CountProducts(object dataItem)
        {
            return ProductDataSource.CountForProductTemplate(((ProductTemplate)dataItem).Id);
        }

        protected void ProductTemplateGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Copy")
            {
                int productTemplateId = AlwaysConvert.ToInt(e.CommandArgument);
                ProductTemplate copy = ProductTemplate.Copy(productTemplateId, true);
                if (copy != null)
                {
                    String newName = "Copy of " + copy.Name;
                    if (newName.Length > 100)
                    {
                        newName = newName.Substring(0, 97) + "...";
                    }
                    copy.Name = newName;
                    copy.Save();
                    ProductTemplateGrid.DataBind();
                }
            }
        }
    }
}