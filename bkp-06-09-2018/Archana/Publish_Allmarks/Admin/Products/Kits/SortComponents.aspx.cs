namespace AbleCommerce.Admin.Products.Kits
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class SortComponents : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _CategoryId;
        private Category _Category;
        private int _ProductId;
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            _Category = CategoryDataSource.Load(_CategoryId);
            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product == null) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetAdminUrl("Catalog/Browse.aspx?CategoryId=" + _CategoryId.ToString()));
            Caption.Text = string.Format(Caption.Text, _Product.Name);
            if (!Page.IsPostBack)
            {
                BindComponentList();
            }
            this.Page.ClientScript.RegisterClientScriptInclude(this.GetType(), "selectbox", this.ResolveUrl("~/Scripts/selectbox.js"));
        }

        protected void CancelButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditKit.aspx?CategoryId=" + _CategoryId.ToString() + "&ProductId=" + _ProductId.ToString());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(SortOrder.Value))
            {
                IList<ProductKitComponent> components = _Product.ProductKitComponents;
                string[] componentIds = SortOrder.Value.Split(",".ToCharArray());
                int order = 0;
                foreach (string sPartId in componentIds)
                {
                    int componentId = AlwaysConvert.ToInt(sPartId);
                    ProductKitComponent kitComponent = _Product.ProductKitComponents.FirstOrDefault(pkc => pkc.KitComponentId == componentId);
                    if (kitComponent != null)
                    {
                        kitComponent.OrderBy = (short)order;
                        order++;
                    }
                }
                components.Save();
            }
            Response.Redirect("EditKit.aspx?CategoryId=" + _CategoryId.ToString() + "&ProductId=" + _ProductId.ToString());
        }

        protected void QuickSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            IList<KitComponent> components = new List<KitComponent>();
            foreach (ProductKitComponent pc in _Product.ProductKitComponents)
            {
                components.Add(pc.KitComponent);
            }
            switch (QuickSort.SelectedIndex)
            {
                case 2:
                    components.Sort("Name", CommerceBuilder.Common.SortDirection.DESC);
                    break;
                default:
                    components.Sort("Name", CommerceBuilder.Common.SortDirection.ASC);
                    break;
            }
            KitComponentList.DataSource = components;
            KitComponentList.DataBind();
            QuickSort.SelectedIndex = 0;
        }

        private void BindComponentList()
        {
            IList<KitComponent> components = new List<KitComponent>();
            foreach (ProductKitComponent pc in _Product.ProductKitComponents)
            {
                components.Add(pc.KitComponent);
            }
            KitComponentList.DataSource = components;
            KitComponentList.DataBind();
        }
    }
}