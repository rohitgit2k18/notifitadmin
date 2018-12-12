namespace AbleCommerce.Admin.Products.Kits
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class SortKitProducts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CategoryId;
        private Category _Category;
        private int _ProductId;
        private Product _Product;
        private int _KitComponentId;
        private KitComponent _KitComponent;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _Category = CategoryDataSource.Load(_CategoryId);
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx"));
            _KitComponentId = AlwaysConvert.ToInt(Request.QueryString["KitComponentId"]);
            _KitComponent = KitComponentDataSource.Load(_KitComponentId);
            if (_KitComponent == null) Response.Redirect("Default.aspx?CategoryId=" + _CategoryId.ToString() + "&ProductId=" + _ProductId.ToString());
            Caption.Text = string.Format(Caption.Text, _KitComponent.Name);
            if (!Page.IsPostBack)
            {
                KitParts.DataSource = _KitComponent.KitProducts;
                KitParts.DataBind();
            }
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditKit.aspx?CategoryId=" + _CategoryId.ToString() + "&ProductId=" + _ProductId.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(SortOrder.Value))
            {
                IList<KitProduct> parts = _KitComponent.KitProducts;
                string[] partIds = SortOrder.Value.Split(",".ToCharArray());
                int order = 0;
                foreach (string sPartId in partIds)
                {
                    int partId = AlwaysConvert.ToInt(sPartId);
                    int index = parts.IndexOf(partId);
                    if (index > -1) parts[index].OrderBy = (short)order;
                    order++;
                }
                parts.Save();
            }
            Response.Redirect("EditKit.aspx?CategoryId=" + _CategoryId.ToString() + "&ProductId=" + _ProductId.ToString());
        }

        protected void QuickSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            IList<KitProduct> parts = _KitComponent.KitProducts;
            switch (QuickSort.SelectedIndex)
            {
                case 2:
                    parts.Sort("DisplayName", CommerceBuilder.Common.SortDirection.DESC);
                    break;
                case 3:
                    parts.Sort("CalculatedPrice", CommerceBuilder.Common.SortDirection.ASC);
                    break;
                case 4:
                    parts.Sort("CalculatedPrice", CommerceBuilder.Common.SortDirection.DESC);
                    break;
                default:
                    parts.Sort("DisplayName", CommerceBuilder.Common.SortDirection.ASC);
                    break;
            }
            KitParts.DataSource = parts;
            KitParts.DataBind();
            QuickSort.SelectedIndex = 0;
        }
    }
}