using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.UI;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Website.ContentPages.ProductPages
{
    public partial class EditProductPage : AbleCommerceAdminPage
    {
        private int _WebpageId;
        private Webpage _Webpage;

        protected void Page_Load(object sender, EventArgs e)
        {
            _WebpageId = AlwaysConvert.ToInt(Request.QueryString["WebpageId"]);
            _Webpage = WebpageDataSource.Load(_WebpageId);
            if (_Webpage == null) Response.Redirect("Default.aspx");

            if (!Page.IsPostBack)
            {
                //INITIALIZE FORM ON FIRST VISIT
                Name.Focus();
                UpdateCaption();
                Name.Text = _Webpage.Name;
                Summary.Text = _Webpage.Summary;
                SummaryCharCount.Text = (AlwaysConvert.ToInt(SummaryCharCount.Text) - Summary.Text.Length).ToString();
                WebpageContent.Text = _Webpage.Description;
                LayoutList.DataBind();
                BindThemes();
                string layout = _Webpage.Layout != null ? _Webpage.Layout.FilePath : string.Empty;
                ListItem item = LayoutList.Items.FindByValue(layout);
                if (item != null)
                    item.Selected = true;                
                Name.Focus();

                // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
                if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addproductpage.aspx"))
                {
                    SavedMessage.Visible = true;
                    SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                }
            }
            
            AbleCommerce.Code.PageHelper.SetMaxLengthCountDown(Summary, SummaryCharCount);
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            SaveButton_Click(sender, e);
            // RETURN TO BROWSE PARENT CATEGORY
            Response.Redirect("Default.aspx");
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                _Webpage.Name = Name.Text;
                _Webpage.Summary = Summary.Text;
                _Webpage.Description = WebpageContent.Text;
                if(!string.IsNullOrEmpty(LayoutList.SelectedValue))
                    _Webpage.Layout = new Layout(LayoutList.SelectedValue);
                else
                    _Webpage.Layout = null;
                _Webpage.Theme = LocalTheme.SelectedValue;
                _Webpage.Save();
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }

        protected void UpdateCaption()
        {
            string shortWebpageName = _Webpage.Name;
            if (shortWebpageName.Length > 45) shortWebpageName = shortWebpageName.Substring(0, 40) + "...";
            Caption.Text = string.Format(Caption.Text, shortWebpageName);
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
            if (_Webpage != null && !Page.IsPostBack)
            {

                string currentTheme = _Webpage.Theme;
                ListItem selectedItem = LocalTheme.Items.FindByValue(currentTheme);
                if (selectedItem != null) LocalTheme.SelectedIndex = LocalTheme.Items.IndexOf(selectedItem);
            }
        }
    }
}