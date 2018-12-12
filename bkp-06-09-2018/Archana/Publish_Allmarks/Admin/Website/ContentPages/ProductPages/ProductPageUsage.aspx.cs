using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Utility;
using System.Collections.Specialized;
using CommerceBuilder.Products;

namespace AbleCommerce.Admin.Website.ContentPages.ProductPages
{
    public partial class ProductPageUsage : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _webpageId;

        protected void Page_Load(object sender, EventArgs e)
        {
            _webpageId = AbleCommerce.Code.PageHelper.GetWebpageId();
            if (!Page.IsPostBack)
            {
                ProductPageList.DataBind();
                ListItem item = ProductPageList.Items.FindByValue(_webpageId.ToString());
                if (item != null)
                    item.Selected = true;
                ProductsGrid.DataBind();
            }
            
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            UpdateSelectedPanel.Visible = (ProductsGrid.Rows.Count > 0);
        }

        protected void WebpagesDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["webpageType"] = WebpageType.ProductDisplay;
        }

        protected void ProductDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            bool any = false;
            int webpageId = AlwaysConvert.ToInt(ProductPageList.SelectedValue);

            if (ProductPageList.SelectedValue == "Any")
                any = true;
            else
                any = false;
            
            e.InputParameters["any"] = any;
            e.InputParameters["webpageId"] = webpageId;
        }

        protected void ProductPageList_SelectedIndexChanged(object sender, EventArgs e)
        {
            ProductsGrid.DataBind();
        }

        protected void Update_Click(object sender, EventArgs e)
        {
            List<Object> dataKeys = ProductsGrid.GetSelectedDataKeyValues();
            foreach (Object dataKey in dataKeys)
            {
                int productId = AlwaysConvert.ToInt(dataKey);
                Product product = ProductDataSource.Load(productId);
                product.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(ProductDisplayPages.SelectedValue));
                product.Save();
            }

            ProductsGrid.DataBind();
        }

        protected string GetDisplayPage(object value)
        {
            Webpage webpage = value as Webpage;
            if (webpage == null) return string.Empty;
            return webpage.Name;
        }
    }
}