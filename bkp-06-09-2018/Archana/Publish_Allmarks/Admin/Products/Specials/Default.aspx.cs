namespace AbleCommerce.Admin.Products.Specials
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CategoryId;
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            int productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect("../../Catalog/Browse.aspx?CategoryId=" + _CategoryId);
            if (!Page.IsPostBack)
            {
                Caption.Text = string.Format(Caption.Text, _Product.Name);
                AddLink.NavigateUrl += "?CategoryId=" + _CategoryId + "&ProductId=" + productId.ToString();
            }
        }

        protected string GetDate(object dataItem)
        {
            DateTime date = (DateTime)dataItem;
            if (date.Equals(DateTime.MinValue)) return string.Empty;
            return string.Format("{0:d}", date);
        }

        protected string GetNames(object dataItem)
        {
            Special special = (Special)dataItem;
            List<string> groupNames = new List<string>();
            foreach (CommerceBuilder.Users.Group group in special.Groups)
            {
                groupNames.Add(group.Name);
            }
            return string.Join(", ", groupNames.ToArray());
        }

        protected string GetEditLink(object dataItem)
        {
            Special special = (Special)dataItem;
            return "EditSpecial.aspx?SpecialId=" + special.Id + "&CategoryId=" + _CategoryId + "&ProductId=" + special.ProductId;
        }
    }
}