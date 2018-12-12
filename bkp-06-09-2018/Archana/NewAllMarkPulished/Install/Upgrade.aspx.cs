using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI;
using CommerceBuilder.Utility;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.UI;
using CommerceBuilder.Search;
using CommerceBuilder.Stores;
using CommerceBuilder.Services;
using CommerceBuilder.Configuration;

public partial class Install_Upgrade : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        
    }

    protected void UpgradeButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            List<string> errorList = new List<string>();
            List<string> warningList = new List<string>();

            //PROCESS SQL UPDATES
            string upgradeSqlFile = Server.MapPath("~/Install/Upgrade_AC7_AC708.sql");
            if (File.Exists(upgradeSqlFile))
            {
                //RUN THE SCRIPT
                string connectionString = ConfigurationManager.ConnectionStrings["AbleCommerce"].ConnectionString;
                errorList = RunScript(connectionString, upgradeSqlFile);

                // ADD DEFAULT DATA FOR WEB PAGES
                Webpage categoryWebpage = AddNewWebpage("Category Grid (Deep Item Display)", "Displays products for the selected category and all of it's sub-categories. Items are displayed in a grid format with breadcrumb links, sorting, page navigation, and sub-category link options.", "[[ConLib:CategoryGridPage]]", null, WebpageType.CategoryDisplay, errorList);
                AddNewWebpage("Category Details Page", "Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a left-aligned, row format, with descriptions and images.", "[[ConLib:CategoryDetailsPage]]", null, WebpageType.CategoryDisplay, errorList);
                AddNewWebpage("Category Grid (Shallow Item Display)", "Displays products for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, page navigation, and sub-category link options.", "[[ConLib:CategoryGridPage2]]", null, WebpageType.CategoryDisplay, errorList);
                AddNewWebpage("Category Grid (Deep Item Display) With Add To Basket", "Displays products for the selected category and all of it's sub-categories. Items are displayed in a grid format, each with a quantity box so user can purchase multiple items with one click.  Includes breadcrumb links, sorting, page navigation, and sub-cat", "[[ConLib:CategoryGridPage3]]", null, WebpageType.CategoryDisplay, errorList);
                AddNewWebpage("Category Grid (Shallow Item Display) With Category Data", "Displays categories, products, webpages, and links for only the selected category.  Items are displayed in a grid format with breadcrumb links, sorting, and page navigation.", "[[ConLib:CategoryGridPage4]]", null, WebpageType.CategoryDisplay, errorList);
                AddNewWebpage("Category List", "Displays products for only the selected category.  Items are displayed in a row format with columns for SKU, manufacturer, and pricing.  Includes breadcrumb links, sorting, page navigation, and sub-category link options.", "[[ConLib:CategoryListPage]]", null, WebpageType.CategoryDisplay, errorList);
                Webpage productWebpage = AddNewWebpage("Basic Product", "A product display page that shows the basic product details.", "[[ConLib:ProductPage]]", null, WebpageType.ProductDisplay, errorList);
                AddNewWebpage("Product with Options Grid", "A product display page that shows all variants of a product in a grid layout.  This display page should not be used with products having more than 8 options.", "[[ConLib:ProductPage OptionsView=\"TABULAR\"]]", null, WebpageType.ProductDisplay, errorList);
                AddNewWebpage("Product Display in Rows", "A product display page that shows the product details in rows.", "[[ConLib:ProductRow]]", null, WebpageType.ProductDisplay, errorList);

                // ADD HOME PAGE
                Webpage homepage = AddNewWebpage("Home Page", "<p>Hello and welcome to your store! To edit this text, log in to the merchant administration. From the menu bar, select Website &gt; Webpages. Then you can edit the Home Page to modify this content.</p>", "[[ConLib:FeaturedProductsGrid]]", "~/Layouts/LeftSidebar.master", WebpageType.Content, errorList);

                // ADD CONTACT US PAGE
                Webpage contactusPage = AddNewWebpage("Contact Us", "Standard contact us page.", "<h2>Contact Us</h2>\r\n<p>Need help placing your order or have a question about an order you placed? You can call us toll free at 1-800-555-0199. </p><p>Our Business Address Is:<br />123 Anywhere Lane<br />Corona, CA 92882 </p><p>You can also email us at <a href=\"#\">help@mydomain.xyz</a> </p><p>To edit this text, log in to the merchant administration. From the menu bar, select Website &gt; Webpages. Then you can edit the Contact Us page to modify this content.</p> ", "~/Layouts/OneColumn.master", WebpageType.Content, errorList);

                try
                {
                    // ADD CUSTOM URL's FOR HOME PAGE AND CONTACTUS PAGE
                    if (homepage != null)
                    {
                        CustomUrl url1 = new CustomUrl(AbleContext.Current.Store, homepage.Id, (byte)CatalogNodeType.Webpage, "Default.aspx");
                        url1.Save();
                    }

                    if (contactusPage != null)
                    {
                        CustomUrl url2 = new CustomUrl(AbleContext.Current.Store, contactusPage.Id, (byte)CatalogNodeType.Webpage, "ContactUs.aspx");
                        url2.Save();
                    }
                }
                catch (Exception ex)
                {
                    errorList.Add(string.Format("An error occurred while adding custorm url(s), error: {0}", ex.Message));
                }

                // UPDATE STORE SETTINGS 
                IList<StoreSetting> settings = StoreSettingDataSource.LoadAll();
                CheckAndAddSetting(settings, "WebpagesDefaultLayout", "~/Layouts/LeftSidebar.master", errorList);
                CheckAndAddSetting(settings, "CategoriesDefaultLayout", "~/Layouts/Category.master", errorList);
                CheckAndAddSetting(settings, "ProductsDefaultLayout", "~/Layouts/Product.master", errorList);
                CheckAndAddSetting(settings, "EnableCustomerOrderNotes", "True", errorList);

                Store store = AbleContext.Current.Store;
                string storeUrl = GetStoreUrl();
                store.StoreUrl = storeUrl;
                string storeUrlKey = "Store_StoreUrl";
                StoreSetting storeUrlSt = settings.Find<StoreSetting>(delegate(StoreSetting s) { return s.FieldName == storeUrlKey; });
                if (storeUrlSt == null)
                {
                    storeUrlSt = new StoreSetting(AbleContext.Current.Store, storeUrlKey, storeUrl);
                    store.Settings.Add(storeUrlSt);
                }
                else
                {
                    storeUrlSt.FieldValue = storeUrl;
                }
                storeUrlSt.Save();

                //store.Settings.Save();

                if (categoryWebpage != null) CheckAndAddSetting(settings, "CategoryWebpageId", categoryWebpage.Id.ToString(), errorList);
                else errorList.Add("Can not add CategoryWebpageId store setting as adding respective webpage failed.");

                if (productWebpage != null) CheckAndAddSetting(settings, "ProductWebpageId", productWebpage.Id.ToString(), errorList);
                else errorList.Add("Can not add ProductWebpageId store setting as adding respective webpage failed.");
            }
            else
            {
                HandleError("<b>Can not continue with upgrade, SQL script file does not exist: " + upgradeSqlFile + " .</b><br/><br />");
                return;
            }

            if (ApplicationSettings.Instance.SearchProvider == "LuceneSearchProvider")
            {
                AbleContext.Container.Resolve<IFullTextSearchService>().AsyncReindex();
                IndexesInfoPanel.Visible = true;
            }

            // Recreate/Reindex the SQL FTS Catalog if search provider is SQL FTS
            if (ApplicationSettings.Instance.SearchProvider == "SqlFtsSearchProvider")
            {
                try
                {
                    if (KeywordSearchHelper.EnsureCatalog())
                    {
                        KeywordSearchHelper.EnsureIndexes();                            
                    }
                }
                catch (Exception ex)
                {
                    warningList.Add(string.Format("An error occurred creating/updating SQL FTS Search Indexes. You may have to run the re-indexing manually. Error: {0}", ex.Message));
                }
            }

            //SHOW ANY ERRORS
            if (errorList.Count > 0)
            {
                UpgradeErrorList.Text = string.Join("<br /><br />", errorList.ToArray());
                UpgradeErrorPanel.Visible = true;
            }
            //SHOW ANY WARNINGS
            if (warningList.Count > 0)
            {   
                UpgradeWarnList.Text = string.Join("<br /><br />", warningList.ToArray());
                UpgradeWarningPanel.Visible = true;
            }

            UpgradeCompletePanel.Visible = true;
            phUpgrade.Visible = false;
        }
    }

    private string GetStoreUrl()
    {
        string tempUrl = Request.Url.ToString();
        int index = tempUrl.IndexOf("?");
        if (index > -1)
        {
            tempUrl = tempUrl.Substring(0, index);
        }
        tempUrl = tempUrl.ToLowerInvariant().Replace("install/upgrade.aspx", string.Empty);
        return tempUrl;
    }

    private void CheckAndAddSetting(IList<StoreSetting> settings, string key, string value, IList<string> errorList)
    {
        try
        {
            if (settings.Find<StoreSetting>(delegate(StoreSetting s) { return s.FieldName == key; }) == null)
            {
                StoreSetting setting = new StoreSetting(AbleContext.Current.Store, key, value);
                setting.Save();
                AbleContext.Current.Store.Settings.Add(setting);
            }
        }
        catch (Exception ex)
        {
            errorList.Add(string.Format("An error occurred while adding store setting key: '{0}', value: '{1}', error: {2}", key, value, ex.Message));
        }
    }

    private Webpage AddNewWebpage(string name, string summary, string description, string layoutpath, WebpageType webpageType, IList<string> errorList)
    {
        try
        {
            Layout layout = null;
            if (!string.IsNullOrEmpty(layoutpath)) layout = new Layout(layoutpath);
            Webpage webpage = new Webpage(AbleContext.Current.Store, name, summary, description, null, null, layout, null, (byte)CatalogVisibility.Public);
            webpage.WebpageTypeId = (byte)webpageType;
            webpage.Save();

            return webpage;
        }
        catch (Exception ex)
        {
            errorList.Add(string.Format("An error occurred while adding webpage: '{0}', error: {1}", name, ex.Message));
        }
        return null;
    }



    private List<string> RunScript(string connectionString, string sqlScriptFile)
    {
        // initialize the error list
        List<string> errorList = new List<string>();

        // load up the specified scriptfile
        string sqlScript = FileHelper.ReadText(sqlScriptFile);

        // REMOVE SCRIPT COMMENTS
        sqlScript = Regex.Replace(sqlScript, @"/\*.*?\*/", string.Empty);

        // SPLIT INTO COMMANDS
        string[] commands = StringHelper.Split(sqlScript, "\r\nGO\r\n");

        // SETUP DATABASE CONNECTION
        int errorCount = 0;
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            // Run each command on the database
            conn.Open();
            foreach (string sql in commands)
            {
                if (!string.IsNullOrEmpty(sql.Trim().Trim('\r', '\n')))
                {
                    try
                    {
                        SqlCommand command = new SqlCommand(sql, conn);
                        command.CommandTimeout = 0;
                        command.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        errorCount++;
                        errorList.Add("<b>SQL:</b> " + sql);
                        errorList.Add("<b>Error:</b> " + ex.Message);
                    }
                }
            }
            conn.Close();
        }
        return errorList;
    }

    /// <summary>
    /// Displays an error message
    /// </summary>
    /// <param name="errorMessage">Displays a validation error</param>
    private void HandleError(string errorMessage)
    {
        MessagePanel.Visible = true;
        phUpgrade.Visible = false;
        ReponseMessage.Text = errorMessage;
    }
}