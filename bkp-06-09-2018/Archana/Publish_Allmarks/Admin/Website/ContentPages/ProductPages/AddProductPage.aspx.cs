using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.UI;

namespace AbleCommerce.Admin.Website.ContentPages.ProductPages
{
    public partial class AddProductPage : AbleCommerceAdminPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LayoutList.DataBind();
                BindThemes();
            }

            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(Summary, SummaryCharCount);
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Webpage webpage = new Webpage();
                webpage.Name = Name.Text;
                webpage.Summary = Summary.Text;
                webpage.Visibility = CatalogVisibility.Public;
                webpage.WebpageType = WebpageType.ProductDisplay;
                webpage.Description = WebpageContent.Text;
                if (!string.IsNullOrEmpty(LayoutList.SelectedValue))
                    webpage.Layout = new Layout(LayoutList.SelectedValue);
                else
                    webpage.Layout = null;
                webpage.Theme = LocalTheme.SelectedValue;
                webpage.Save();
                Response.Redirect(string.Format("EditProductPage.aspx?WebpageId={0}", webpage.Id));
            }
        }

        protected void BindThemes()
        {
            LocalTheme.Items.Clear();
            LocalTheme.Items.Add(new ListItem("Use store default", ""));
            CommerceBuilder.UI.Theme[] themes = AbleCommerce.Code.StoreDataHelper.GetStoreThemes();
            foreach (CommerceBuilder.UI.Theme theme in themes)
            {
                LocalTheme.Items.Add(new ListItem(theme.DisplayName, theme.Name));
            }
        }
    }
}