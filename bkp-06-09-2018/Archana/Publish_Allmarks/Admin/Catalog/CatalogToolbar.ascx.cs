namespace AbleCommerce.Admin.Catalog {
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.DomainModel;

    public partial class CatalogToolbar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, System.EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
                Category category = EntityLoader.Load<Category>(categoryId);
                if (category != null)
                {
                    CaptionLabel.Text = category.Name;
                    EditLink.NavigateUrl = (EditLink.NavigateUrl + ("?CategoryId=" + categoryId.ToString()));
                    PreviewLink.NavigateUrl = UrlGenerator.GetBrowseUrl(categoryId, categoryId, CatalogNodeType.Category, category.Name);
                    if (categoryId == 0)
                    {
                        AddCategory.Text = "Category";
                    }
                    AddCategory.NavigateUrl = (AddCategory.NavigateUrl + ("?CategoryId=" + categoryId.ToString()));
                    AddProduct.NavigateUrl = (AddProduct.NavigateUrl + ("?CategoryId=" + categoryId.ToString()));
                    AddWebpage.NavigateUrl = (AddWebpage.NavigateUrl + ("?CategoryId=" + categoryId.ToString()));
                    AddLink.NavigateUrl = (AddLink.NavigateUrl + ("?CategoryId=" + categoryId.ToString()));
                    AbleCommerce.Code.PageHelper.SetDefaultButton(SearchPhrase, SearchButton.ClientID);
                }
                else
                {
                    throw new CommerceBuilder.Exceptions.InvalidCategoryException();
                }
            }
        }

        protected void SearchButton_Click(object sender, System.Web.UI.ImageClickEventArgs e)
        {
            Response.Redirect(("~/Admin/Search.aspx?k=" + Server.UrlEncode(SearchPhrase.Text)));
        }
    }  
}
