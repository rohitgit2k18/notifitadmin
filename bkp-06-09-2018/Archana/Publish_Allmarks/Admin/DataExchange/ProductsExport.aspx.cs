using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.DataExchange;
using CommerceBuilder.Utility;
using System.IO;
using CommerceBuilder.Common;
using CommerceBuilder.Search;
using CommerceBuilder.Users;
using System.Web.Script.Serialization;
using CommerceBuilder.Products;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class ProductsExport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        string _userProductFieldsKey = "SelectedProductCSVFields";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // check if the page export request is sent from product manager page
                string exportType = Request.QueryString["Type"];
                if (!string.IsNullOrEmpty(exportType))
                {
                    ExportOptionsPanel.Visible = false;
                    FieldSelectionPanel.Visible = true;
                    ExportCaption.Text = string.Format(ExportCaption.Text, GetExportCount());
                }

                FieldNamesList.DataSource = ProductExportManager.Instance.CsvEnabledFields;
                FieldNamesList.DataBind();

                // SELECT FIELDS BASED ON USER SETTINGS
                User user = AbleContext.Current.User;
                string listSelectedFields = user.Settings.GetValueByKey(_userProductFieldsKey, string.Empty);
                if (!string.IsNullOrEmpty(listSelectedFields))
                {
                    string[] userLastSelectedFields = listSelectedFields.Split(',');
                    foreach (ListItem item in FieldNamesList.Items)
                    {
                        if(userLastSelectedFields.Contains(item.Value)) item.Selected = true;
                    }
                }
                else
                {
                    // SELECT ALL AT START
                    foreach (ListItem item in FieldNamesList.Items)
                    {
                        item.Selected = true; 
                    }
                }
                
                BindBackFilesGrid();
            }
        }

        protected int GetExportCount()
        {
            int count = 0;
            ProductFilter criteria = null;
            string exportType = Request.QueryString["Type"];
            if (!string.IsNullOrEmpty(exportType) && exportType == "selected")
            {
                string ids = Session["EXPORT_PRODUCT_IDS"] as string;
                if (!string.IsNullOrEmpty(ids))
                {
                    criteria = new ProductFilter();
                    criteria.ProductIdRange = ids; 
                }
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                var serializer = new JavaScriptSerializer();
                criteria = serializer.Deserialize(Request.QueryString["filter"], typeof(ProductFilter)) as ProductFilter;
            }
            else
            {
                return ProductDataSource.CountAll();
            }

            if (criteria != null && !string.IsNullOrEmpty(criteria.ProductIdRange))
            {
                // use specific product list
                int[] productIds = AlwaysConvert.ToIntArray(criteria.ProductIdRange);
                count = productIds.Length;
            }
            else if (criteria != null)
            {
                // use search results
                IProductRepository productRepository = AbleContext.Container.Resolve<IProductRepository>();
                count = productRepository.FindProductsCount(criteria.Name, criteria.SearchDescriptions, criteria.Sku, criteria.CategoryId, criteria.ManufacturerId, criteria.VendorId, criteria.Featured, 0, criteria.FromPrice, criteria.ToPrice, criteria.DigitalGoodsOnly, criteria.GiftCertificatesOnly, criteria.KitsOnly, criteria.SubscriptionsOnly);
            }
            
            return count;
        }

        protected void StartExportButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                ProductFilter criteria = null;
                string exportType = Request.QueryString["Type"];
                if (!string.IsNullOrEmpty(exportType) && exportType == "selected")
                {
                    string ids = Session["EXPORT_PRODUCT_IDS"] as string;
                    if (!string.IsNullOrEmpty(ids))
                    {
                        criteria = new ProductFilter();
                        criteria.ProductIdRange = ids;
                    }
                }
                else if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
                {
                    var serializer = new JavaScriptSerializer();
                    criteria = serializer.Deserialize(Request.QueryString["filter"], typeof(ProductFilter)) as ProductFilter;
                }
                if (criteria == null) criteria = new ProductFilter();

                if (StandardProductExport.Checked)
                {
                    // validate field selection
                    int selectedCount = 0;
                    List<string> fieldNames = new List<string>();
                    foreach (ListItem item in FieldNamesList.Items)
                    {
                        if (item.Selected)
                        {
                            selectedCount++;
                            fieldNames.Add(item.Value);
                        }
                    }
                    if (selectedCount == 0)
                    {
                        FieldNamesValidator.IsValid = false;
                        return;
                    }

                    string[] selectedFields = fieldNames.ToArray();

                    ProductExportOptions exportOptions = new ProductExportOptions();
                    exportOptions.DataFormat = DataFormat.CSV;
                    exportOptions.FileTag = FileTag.Text.Trim();
                    exportOptions.SelectedFields = selectedFields;
                    exportOptions.SelectionCriteria = criteria;
                    ProductExportManager.Instance.BeginExportAsync(exportOptions);

                    // SAVE SELECTED FIELDS IN USER SETTINGS
                    User user = AbleContext.Current.User;
                    user.Settings.SetValueByKey(_userProductFieldsKey, string.Join(",", selectedFields));
                    user.Save();
                }
                else
                {
                    ProductVariantsExportOptions exportOptions = new ProductVariantsExportOptions();
                    exportOptions.DataFormat = DataFormat.CSV;
                    exportOptions.FileTag = FileTag.Text.Trim();
                    exportOptions.SelectionCriteria = criteria;
                    ProductVariantsExportManager.Instance.BeginExportAsync(exportOptions);
                }

                Timer1.Enabled = true;
                ProgressLabel.Text = "Starting product export.";
                ProgressPanel.Visible = true;
                FieldSelectionPanel.Visible = false;
                ExportOptionsPanel.Visible = false;
            }
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            bool standardExportRunning = ProductExportManager.Instance.ExportInfo != null && ProductExportManager.Instance.IsExportRunning;
            bool variantExportRunning = ProductVariantsExportManager.Instance.ExportInfo != null && ProductVariantsExportManager.Instance.IsExportRunning;

            if (standardExportRunning)
            {
                ProgressLabel.Text = string.Format(ProgressLabel.Text, ProductExportManager.Instance.ExportInfo.TotalItems, ProductExportManager.Instance.ExportInfo.ItemsExported);
            }
            else if (variantExportRunning)
            {
                ProgressLabel.Text = string.Format(ProgressLabel.Text, ProductVariantsExportManager.Instance.ExportInfo.TotalItems, ProductVariantsExportManager.Instance.ExportInfo.ItemsExported);
            }
            else
            {
                Timer1.Enabled = false;
                ProgressPanel.Visible = false;
                ExportOptionsPanel.Visible = true;

                // show confirmation
                ExportCompleteMessage.Visible = true;
                ExportCompleteMessage.Text = string.Format(ExportCompleteMessage.Text, LocaleHelper.LocalNow);

                BindBackFilesGrid();
            }
        }

        protected void OnExportTypeChanged(object sender, EventArgs e)
        {
            trFieldList.Visible = StandardProductExport.Checked;
            trVariantSlectionOptions.Visible = ProductVariantsExport.Checked;
        }   

        #region Backup files grid

        protected void BindBackFilesGrid()
        {
            string mappedPath = Server.MapPath("~/App_Data/DataExchange/Download/");
            if (Directory.Exists(mappedPath))
            {
                string fileTypes = "PRODUCTS_*.zip|VARIANTS_*.zip";
                string[] backupFilePaths = fileTypes.Split('|').SelectMany(filter => Directory.GetFiles(mappedPath, filter, SearchOption.TopDirectoryOnly)).ToArray();
                if (backupFilePaths != null)
                {
                    IList<BackupFile> backupFiles = new List<BackupFile>();
                    // GET FILE NAMES
                    for (int i = 0; i < backupFilePaths.Length; i++)
                    {
                        FileInfo fileInfo = new FileInfo(backupFilePaths[i]);
                        BackupFile file = new BackupFile(fileInfo.Name, fileInfo.Length, fileInfo.CreationTime.ToLocalTime());
                        backupFiles.Add(file);
                    }

                    backupFiles.Sort("CreatedDate", CommerceBuilder.Common.SortDirection.DESC);

                    BackupFilesGrid.DataSource = backupFiles;
                    BackupFilesGrid.DataBind();
                }
            }
        }

        protected void BackupFilesGrid_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string fileName = e.CommandArgument.ToString();

            if (e.CommandName.ToLower() == "do_delete")
            {
                string mappedPath = Server.MapPath("~/App_Data/DataExchange/Download/" + fileName);
                if (File.Exists(mappedPath))
                {
                    File.Delete(mappedPath);
                    BindBackFilesGrid();
                }
            }
        }

        protected class BackupFile
        {
            public string FileName { get; set; }
            public long Size { get; set; }
            public DateTime CreatedDate { get; set; }
            public string FormattedFileSize { get; set; }

            public BackupFile(string name, long size, DateTime createdDate)
            {
                this.FileName = name;
                this.Size = size;
                this.CreatedDate = createdDate;
                this.FormattedFileSize = FileHelper.FormatFileSize(this.Size);
            }
        }
        # endregion
    }
}