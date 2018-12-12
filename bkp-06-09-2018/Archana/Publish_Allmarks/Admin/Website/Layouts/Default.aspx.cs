namespace AbleCommerce.Admin.Website.Layouts
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Stores;
    using CommerceBuilder.UI;
    using CommerceBuilder.Services;

    public partial class Default : AbleCommerceAdminPage
    {
        IList<Layout> _Layouts;
        string _LayoutsBasePath = AppDomain.CurrentDomain.BaseDirectory + "Layouts\\";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindLayouts();
            }
        }

        private void BindLayouts()
        {
            _Layouts = LayoutDataSource.LoadAll();
            
            LayoutsGrid.DataBind();

            // INIT DEFAULTS
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;

            WebpagesDefault.DataSource = _Layouts;
            WebpagesDefault.DataBind();
            if (!string.IsNullOrEmpty(settings.WebpagesDefaultLayout)) SelectItem(WebpagesDefault, settings.WebpagesDefaultLayout);

            CategoriesDefault.DataSource = _Layouts;
            CategoriesDefault.DataBind();
            if (!string.IsNullOrEmpty(settings.CategoriesDefaultLayout)) SelectItem(CategoriesDefault, settings.CategoriesDefaultLayout);

            ProductsDefault.DataSource = _Layouts;
            ProductsDefault.DataBind();
            if (!string.IsNullOrEmpty(settings.ProductsDefaultLayout)) SelectItem(ProductsDefault, settings.ProductsDefaultLayout);

        }

        protected string GetSafeFileName(string rawFilename)
        {
            rawFilename = rawFilename.Trim();
            string SafeFilePattern = "[^a-zA-Z0-9\\-_ ]";
            string SafeFilePattern2 = "^[a-zA-Z0-9\\-_ ]+$";

            string extension = Path.GetExtension(rawFilename);
            if (!string.IsNullOrEmpty(extension))
                rawFilename = rawFilename.Substring(0, rawFilename.Length - extension.Length);

            else extension = string.Empty;
            rawFilename = Regex.Replace(rawFilename, SafeFilePattern, string.Empty);
            if (Regex.Match(rawFilename, SafeFilePattern2).Success) return rawFilename + ".Master";
            return string.Empty;
        }

        protected void UpdateDefaultsButton_Click(object sender, EventArgs e)
        {
            // SAVE SETTINGS
            StoreSettingsManager settings = AbleContext.Current.Store.Settings;

            settings.WebpagesDefaultLayout = WebpagesDefault.SelectedValue;
            settings.CategoriesDefaultLayout = CategoriesDefault.SelectedValue;
            settings.ProductsDefaultLayout = ProductsDefault.SelectedValue;

            settings.Save();

            // RELOAD THE STORE SETTINGS, TO ENSURE SYCHRONIZATION WITH THE IN MEMORY CACHE
            IStoreSettingsProvider provider = AbleContext.Resolve<IStoreSettingsProvider>();
            provider.Reload();

            SelectItem(WebpagesDefault, settings.WebpagesDefaultLayout);
            SelectItem(CategoriesDefault, settings.CategoriesDefaultLayout);
            SelectItem(ProductsDefault, settings.ProductsDefaultLayout);

            LayoutsGrid.DataBind();
        }

        private void SelectItem(DropDownList list, string valueToSelect)
        {
            // WE NEED TO SELECT BY DISPLAY NAME
            Layout tempLayout = new Layout(valueToSelect);

            ListItem selectedItem = list.Items.FindByText(tempLayout.DisplayName);
            if (selectedItem != null) selectedItem.Selected = true;
        }

        protected void LayoutsGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string filePath = e.CommandArgument.ToString();

            if (e.CommandName.ToLower() == "do_delete")
            {
                LayoutDataSource.Delete(filePath);                
            }

            BindLayouts();
        }

        protected string GetDefaults(Object dataItem)
        {
            Layout layout = (Layout)dataItem;

            if (layout != null && layout.DefaultFor != null)
                return string.Join(", ", layout.DefaultFor.ToArray());
            else
                return string.Empty;
        }

    }
}