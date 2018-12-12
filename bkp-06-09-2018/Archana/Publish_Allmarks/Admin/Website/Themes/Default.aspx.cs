//-----------------------------------------------------------------------
// <copyright file="Default.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------

namespace AbleCommerce.Admin.Website.Themes
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
    using CommerceBuilder.Utility;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using System.Configuration;
    using System.Xml;

    public partial class Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private string _themesBasePath;
        private const string SafeDirectoryPattern = "[^a-zA-Z0-9\\-_]";

        protected void Page_Init(object sender, EventArgs e)
        {
            _themesBasePath = Server.MapPath("~/App_Themes/");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _themesBasePath = Server.MapPath("~/App_Themes/");
            if (!Page.IsPostBack)
            {
                StoreTheme.DataBind();
                Template.DataBind();

                // SET THE DEFAULT THEMES ON INITIAL POST
                string storeTheme = ThemeManager.GetDefaultStoreTheme();
                SelectItem(StoreTheme, storeTheme);
                Template.SelectedIndex = 0;                
            }
        }

        private void SelectItem(DropDownList list, string storeTheme)
        {
            ListItem selectedItem = list.Items.FindByValue(storeTheme);
            if (selectedItem != null) selectedItem.Selected = true;
        }

        protected void BindThemes() 
        {
            ThemesGrid.DataBind();
            StoreTheme.Items.Clear();
            StoreTheme.DataBind();
            Template.Items.Clear();
            Template.DataBind();
        }

        protected void ThemesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("Do_Delete"))
            {
                string theme = e.CommandArgument.ToString();
                if (!string.IsNullOrEmpty(theme))
                {
                    string fullDeletePath = Path.Combine(_themesBasePath, theme);
                    try
                    {
                        if (Directory.Exists(fullDeletePath))
                            Directory.Delete(fullDeletePath, true);
                        else if (File.Exists(fullDeletePath))
                            File.Delete(fullDeletePath);
                    }
                    catch(Exception exp)
                    {
                        Logger.Error(exp.Message, exp);
                    }
                }

                BindThemes();
            }
        }

        protected void CreateThemeButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string safeFolderName = Regex.Replace(Name.Text.Trim(), SafeDirectoryPattern, string.Empty);
                string themePath = Path.Combine(_themesBasePath, safeFolderName);
                switch (Template.SelectedValue)
                {
                    case "blank":
                        {
                            Directory.CreateDirectory(themePath);
                            string filePath = Path.Combine(themePath, "style.css");
                            if (!File.Exists(filePath))
                            {
                                using (FileStream fs = File.Create(filePath))
                                {
                                    if (fs != null)
                                        fs.Close();
                                }
                            }
                            
                            if (Directory.Exists(themePath))
                            {
                                Directory.CreateDirectory(Path.Combine(themePath,"images"));
                            }
                        }
                        break;

                    default:
                        if (!string.IsNullOrEmpty(Template.SelectedValue))
                        {
                            string sourceTheme = Path.Combine(_themesBasePath, Template.SelectedValue);
                            FileHelper.CopyDirectory(sourceTheme, themePath);
                        }
                        break;
                }
                Name.Text = string.Empty;
                BindThemes();
            }
        }      

        protected void ImportThemeButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string safeFolderName = Regex.Replace(ImportAsName.Text.Trim(), SafeDirectoryPattern, string.Empty);
                string themePath = Path.Combine(_themesBasePath, safeFolderName);

                if (TemplateUpload.HasFile && string.Compare(Path.GetExtension(TemplateUpload.FileName), ".zip") == 0)
                {
                    Directory.CreateDirectory(themePath);
                    string zipFilePath = string.Format("{0}\\{1}", themePath, TemplateUpload.FileName);
                    TemplateUpload.SaveAs(zipFilePath);
                    CompressionHelper.ExtractArchive(zipFilePath, themePath);
                    File.Delete(zipFilePath);
                }
                ImportAsName.Text = string.Empty;
                BindThemes();
            }
        }

        protected void UpdateDefaultThemesButton_Click(object sender, EventArgs e)
        {
            // SAVE SETTINGS AND REDIRECT IF REQUIRED            
            string storeTheme = StoreTheme.SelectedValue;
            ThemeManager.SetDefaultStoreTheme(storeTheme);
            BindThemes();
            SelectItem(StoreTheme, storeTheme);
        }

        protected void UpdateAdminThemesButton_Click(object sender, EventArgs e)
        {
            // SAVE SETTINGS AND REDIRECT IF REQUIRED            
            Store store = AbleContext.Current.Store;
            StoreSettingsManager settings = store.Settings;
            settings.AdminTheme = AdminTheme.SelectedValue;
            settings.Save();
            Response.Redirect("~/Admin/Website/Themes/Default.aspx");
        }  

        protected void UniqueNameValidator_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string[] directories = Directory.GetDirectories(_themesBasePath, args.Value);
            args.IsValid = (directories == null || directories.Length == 0);
            if (!args.IsValid)
            {
                AddThemePopup.Show();
            }
        }

        protected void UniqueNameValidator2_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string[] directories = Directory.GetDirectories(_themesBasePath, args.Value);
            args.IsValid = (directories == null || directories.Length == 0);
            if (!args.IsValid)
            {
                ImportThemePopup.Show();
            }
        }
        
        protected bool ShowDeleteButton(object dataItem)
        {
            return (!IsDefault(dataItem) && !IsWebConfigDefault(dataItem) && !(GetWebPagesCount(dataItem) > 0));
        }

        protected bool IsDefault(object dataItem)
        {
            Theme theme = (Theme)dataItem;
            if (ThemeManager.IsDefault(theme)) return true;
            if (string.IsNullOrEmpty(ThemeManager.GetDefaultStoreTheme()))
            {
                if (IsWebConfigDefault(dataItem)) 
                    return true;
            }
            return false;
        }

        protected bool IsWebConfigDefault(object dataItem)
        {
            Theme theme = (Theme)dataItem;
            return (theme.Name.ToLower().Trim().Equals(GetWebConfigDefaultTheme().ToLower().Trim()));
        }
        
        protected int GetWebPagesCount(object dataItem)
        {
            Theme theme = (Theme)dataItem;
            return WebpageDataSource.CountForTheme(theme.Name);
        }

        protected string GetPreviewUrl(object dataItem)
        {
            Theme theme = (Theme)dataItem;
            string storeUrl = AbleCommerce.Code.NavigationHelper.GetStoreUrl(this.Page);
            return storeUrl + "?theme=" + theme.Name;
        }

        protected string GetWebConfigDefaultTheme()
        {
            string webConfigPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "web.config");
            if (File.Exists(webConfigPath))
            {   
                XmlDocument webConfig = new XmlDocument();
                webConfig.Load(webConfigPath);
                
                XmlElement pagesElement = XmlUtility.GetElement(webConfig.DocumentElement, "system.web/pages", false);
                if (pagesElement != null)
                {   
                    return XmlUtility.GetAttributeValue(pagesElement, "theme", string.Empty);
                }
            }
            return string.Empty;
        }

        protected void ThemesDS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            e.InputParameters["isAdmin"] = BitFieldState.False;
        }

        protected void Template_DataBound(object sender, EventArgs e)
        {
            Template.Items.Insert(0, new ListItem(string.Empty, "blank"));
        }

        protected void StoreTheme_DataBound(object sender, EventArgs e)
        {
            StoreTheme.Items.Insert(0, new ListItem("Use default set in web.config", string.Empty));
        }

        protected void AdminTheme_DataBound(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string currentAdminTheme = AbleContext.Current.Store.Settings.AdminTheme;
                ListItem selectedItem = AdminTheme.Items.FindByValue(currentAdminTheme);
                if (selectedItem != null)
                {
                    AdminTheme.SelectedIndex = AdminTheme.Items.IndexOf(selectedItem);
                }
            }
        }
    }
}