namespace AbleCommerce.Admin.Products.Kits
{
    using System;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class AttachComponent : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected int _CategoryId;
        protected Category _Category;
        protected int _ProductId;
        protected Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _Category = CategoryDataSource.Load(_CategoryId);
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx?CategoryId=" + _CategoryId.ToString()));
            SearchResultsGrid.Visible = Page.IsPostBack;
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

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            SearchResultsGrid.DataBind();
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(string.Format("EditKit.aspx?CategoryId={0}&ProductId={1}", _CategoryId, _ProductId));
        }

        protected void SearchResultsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("Attach"))
            {
                EnsureKit();
                int index = AlwaysConvert.ToInt(e.CommandArgument);
                int kitComponentId = (int)SearchResultsGrid.DataKeys[index].Value;
                KitComponent kitComponent = KitComponentDataSource.Load(kitComponentId);
                if (kitComponent != null)
                {
                    _Product.ProductKitComponents.Add(new ProductKitComponent(_Product, kitComponent));
                    _Product.Save();
                    CancelButton_Click(sender, e);
                }
            }
            else if (e.CommandName.Equals("Copy"))
            {
                EnsureKit();
                int index = AlwaysConvert.ToInt(e.CommandArgument);
                int kitComponentId = (int)SearchResultsGrid.DataKeys[index].Value;
                KitComponent kitComponent = KitComponentDataSource.Load(kitComponentId);
                if (kitComponent != null)
                {
                    // copy the component
                    KitComponent branchedComponent = kitComponent.Copy(true);
                    branchedComponent.Name = "Copy of " + kitComponent.Name;
                    branchedComponent.Save();

                    // attach to the product
                    _Product.ProductKitComponents.Add(new ProductKitComponent(_Product, branchedComponent));
                    _Product.Save();
                    CancelButton_Click(sender, e);
                }
            }
        }

        private void EnsureKit()
        {
            if (_Product.Kit == null)
            {
                // WE MUST HAVE KIT TO HAVE KIT COMPONENTS
                _Product.Kit = new Kit(_Product, false);
            }
        }
    }
}