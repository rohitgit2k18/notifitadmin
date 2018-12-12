namespace AbleCommerce.Admin.Products.Specials
{
    using System;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class AddSpecial : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            int productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect("../../Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId());
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _Product.Name);
                BasePriceMessage.Text = string.Format(BasePriceMessage.Text, _Product.Price.LSCurrencyFormat("lc"));
            }
            Groups.Attributes.Add("onclick", SelectedGroups.ClientID + ".checked = true");
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId() + "&ProductId=" + _Product.Id.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Special special = new Special();
                special.Product = _Product;
                special.Price = AlwaysConvert.ToDecimal(Price.Text);
                special.StartDate = StartDate.SelectedDate;
                special.EndDate = EndDate.SelectedEndDate;
                if (SelectedGroups.Checked)
                {
                    foreach (ListItem item in Groups.Items)
                    {
                        CommerceBuilder.Users.Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) special.Groups.Add(group);
                    }
                }
                special.Save();
                CancelButton_Click(sender, e);
            }
        }
    }
}