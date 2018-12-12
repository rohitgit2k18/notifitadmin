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

namespace AbleCommerce.Admin.Website.ContentPages.CategoryPages
{
    public partial class CategoryPageUsage : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _webpageId;

        protected void Page_Load(object sender, EventArgs e)
        {
            _webpageId = AbleCommerce.Code.PageHelper.GetWebpageId();
            if (!Page.IsPostBack)
            {
                CategoryPageList.DataBind();
                ListItem item = CategoryPageList.Items.FindByValue(_webpageId.ToString());
                if (item != null)
                    item.Selected = true;
                CategoriesGrid.DataBind();
            }
            
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            UpdateSelectedPanel.Visible = (CategoriesGrid.Rows.Count > 0);
        }

        protected void WebpagesDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["webpageType"] = WebpageType.CategoryDisplay;
        }

        protected void CategoryDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            bool any = false;
            int webpageId = AlwaysConvert.ToInt(CategoryPageList.SelectedValue);

            if (CategoryPageList.SelectedValue == "Any")
                any = true;
            else
                any = false;
            
            e.InputParameters["any"] = any;
            e.InputParameters["webpageId"] = webpageId;
        }

        protected void CategoryPageList_SelectedIndexChanged(object sender, EventArgs e)
        {
            CategoriesGrid.DataBind();
        }

        protected void Update_Click(object sender, EventArgs e)
        {
            List<Object> dataKeys = CategoriesGrid.GetSelectedDataKeyValues();
            foreach (Object dataKey in dataKeys)
            {
                int categoryId = AlwaysConvert.ToInt(dataKey);
                Category category = CategoryDataSource.Load(categoryId);
                category.Webpage = WebpageDataSource.Load(AlwaysConvert.ToInt(CategoryDisplayPages.SelectedValue));
                category.Save();
            }

            CategoriesGrid.DataBind();
        }

        protected string GetDisplayPage(object value)
        {
            Webpage webpage = value as Webpage;
            if (webpage == null) return string.Empty;
            return webpage.Name;
        }
    }
}