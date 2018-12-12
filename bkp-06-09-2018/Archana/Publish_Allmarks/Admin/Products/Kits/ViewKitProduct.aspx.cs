namespace AbleCommerce.Admin.Products.Kits
{
    using System;
    using System.Collections.Generic;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class ViewKitProduct : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            Product product = ProductDataSource.Load(productId);
            if (product == null) Response.Redirect("../../Catalog/Browse.aspx?CategoryId=" + AbleCommerce.Code.PageHelper.GetCategoryId());
            Caption.Text = string.Format(Caption.Text, product.Name);

            // build list of kits
            List<KitMemberInfo> kitMemberships = new List<KitMemberInfo>();
            IList<KitComponent> components = KitComponentDataSource.LoadForMemberProduct(productId);
            foreach (KitComponent component in components)
            {
                foreach (ProductKitComponent pkc in component.ProductKitComponents)
                {
                    kitMemberships.Add(new KitMemberInfo(pkc.ProductId, pkc.Product.Name, component.Name));
                }
            }
            kitMemberships.Sort(new KitMemberInfoComparer());
            KitMembershipList.DataSource = kitMemberships;
            KitMembershipList.DataBind();
        }

        protected class KitMemberInfo
        {
            public int ProductId { get; set; }
            public string ProductName { get; set; }
            public string ComponentName { get; set; }

            public KitMemberInfo(int productId, string productName, string componentName)
            {
                this.ProductId = productId;
                this.ProductName = productName;
                this.ComponentName = componentName;
            }
        }

        private class KitMemberInfoComparer : IComparer<KitMemberInfo>
        {
            public int Compare(KitMemberInfo x, KitMemberInfo y)
            {
                int result = x.ProductName.CompareTo(y.ProductName);
                if (result == 0) return x.ComponentName.CompareTo(y.ComponentName);
                else return result;
            }
        }
    }
}