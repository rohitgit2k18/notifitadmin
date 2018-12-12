using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Web.UI.WebControls;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.DataExchange;
using CommerceBuilder.Utility;
using ICSharpCode.SharpZipLib.Zip;
using System.Web;
using System.Web.UI;
using System.Linq;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class VariantsImport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {   
            BindFileList();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (ProductVariantsImportManager.Instance.IsImportRunning)
                {
                    ProgressPanel.Visible = true;
                    ProgressLabel.Text = string.Format(ProgressLabel.Text, ProductVariantsImportManager.Instance.ImportInfo.TotalItems, ProductVariantsImportManager.Instance.ImportInfo.ItemsImported);
                    if (!Timer1.Enabled) Timer1.Enabled = true;
                }
                OptionsPanel.Visible = !ProgressPanel.Visible;
            }
            UploadMaxSize.Text = String.Format(UploadMaxSize.Text, AbleContext.Current.Store.Settings.MaxRequestLength);
        }

        protected void BindFileList()
        {
            string mappedPath = Server.MapPath("~/App_Data/DataExchange/Upload/");
            if (Directory.Exists(mappedPath))
            {
                string fileTypes = "*.zip|*.csv";
                string[] backupFilePaths = fileTypes.Split('|').SelectMany(filter => Directory.GetFiles(mappedPath, filter, SearchOption.TopDirectoryOnly)).ToArray();
                if (backupFilePaths != null)
                {
                    IList<FileInfo> backupFiles = new List<FileInfo>();
                    // GET FILE NAMES
                    for (int i = 0; i < backupFilePaths.Length; i++)
                    {
                        FileInfo fileInfo = new FileInfo(backupFilePaths[i]);
                        backupFiles.Add(fileInfo);
                    }

                    backupFiles.Sort("CreationTime", CommerceBuilder.Common.SortDirection.DESC);
                    FileList.DataTextField = "Name";
                    FileList.DataValueField= "Name";
                    FileList.DataSource = backupFiles;
                    FileList.DataBind();
                    NoFileFound.Visible = backupFiles.Count == 0;
                }
            }
        }

        protected void SelectButton_Click(object sender, EventArgs e)
        {
            string fileName = FileList.SelectedValue;
            if (!string.IsNullOrEmpty(fileName))
            {
                SelectedFileName.Text = fileName;
            }
            else
            {
                FileSelectionValidator.IsValid = false;
                SelectFilePopup.Show();
            }

        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (ProductVariantsImportManager.Instance.IsImportRunning)
            {
                if (ProductVariantsImportManager.Instance.ImportInfo.TotalItems > 0) ProgressLabel.Text = string.Format(ProgressLabel.Text, ProductVariantsImportManager.Instance.ImportInfo.TotalItems, ProductVariantsImportManager.Instance.ImportInfo.ItemsImported);
                else ProgressLabel.Text = string.Format("Records Processed: {0}", ProductVariantsImportManager.Instance.ImportInfo.ItemsImported);
            }
            else
            {
                Timer1.Enabled = false;
                ProgressPanel.Visible = false;
                OptionsPanel.Visible = false;
                MessagesPanel.Visible = true;

                // show confirmation
                Messages.DataSource = ProductVariantsImportManager.Instance.ImportInfo.Messages;
                Messages.DataBind();
            }
        }

        protected void FileSeletionModeChanged(object sender, EventArgs e)
        {
            if (FileUpload.Checked)
            {
                DataFile.Enabled = true;
                phFileUpload.Visible = true;
                phFileSelect.Visible = false;
            }
            else if(FileSelectExisting.Checked)
            {
                DataFile.Enabled = false;
                phFileUpload.Visible = false;
                phFileSelect.Visible = true;
            }
        }

        protected bool StartImport()
        {
            bool started = false;
            // IMPORT UPLOADED FILE
            if (FileUpload.Checked)
            {
                if (ValidateUploadFile())
                {
                    string fileName = DataFile.FileName;
                    // check if its zipped file, save it at server
                    if (fileName.EndsWith(".zip", StringComparison.InvariantCultureIgnoreCase) ||
                        fileName.EndsWith(".csv", StringComparison.InvariantCultureIgnoreCase))
                    {
                        string saveFilePath = fileName.StartsWith("VARIANTS_", StringComparison.InvariantCultureIgnoreCase) ? fileName : "VARIANTS_" + fileName;
                        saveFilePath = Server.MapPath(Path.Combine("~/App_Data/DataExchange/Upload/", saveFilePath));

                        HttpPostedFile file = Request.Files[0];
                        int fileLength = file.ContentLength;
                        Byte[] buffer = new byte[fileLength];
                        file.InputStream.Read(buffer, 0, fileLength);
                        File.WriteAllBytes(saveFilePath, buffer);

                        if (File.Exists(saveFilePath))
                        {
                            ProductVariantsImportOptions importOptions = GetImportOptions();
                            importOptions.DeleteSourceFile = true;
                            ProductVariantsImportManager.Instance.BeginImportAsync(saveFilePath, importOptions);

                            Timer1.Enabled = true;
                            ProgressLabel.Text = "Started import process.";
                            SelectedFileName.Text = string.Empty;
                            started = true;
                        }
                    }
                }
                else
                {
                    DataFileValidator.IsValid = false;
                }
            }
            else
            {
                string fileName = SelectedFileName.Text;
                // ITS COMPRESSED ZIP FILE, UNPACK AND VALIDATE CSV FILE
                string importFilePath = Server.MapPath("~/App_Data/DataExchange/Upload/" + fileName);
                if (File.Exists(importFilePath))
                {
                    ProductVariantsImportOptions importOptions = GetImportOptions();
                    ProductVariantsImportManager.Instance.BeginImportAsync(importFilePath, importOptions);
                    
                    Timer1.Enabled = true;
                    ProgressLabel.Text = "Started import process.";
                    started = true;
                }
            }

            return started;
        }

        private bool ValidateUploadFile()
        {
            bool isValid = false;

            if (DataFile.HasFile)
            {
                string fileName = DataFile.FileName;
                // VALIDATE FILE
                if (FileHelper.IsExtensionValid(fileName, "csv,zip"))
                {
                    isValid = true;
                }
            }

            return isValid;
        }

        private ProductVariantsImportOptions GetImportOptions()
        {
            ProductVariantsImportOptions importOptions = new ProductVariantsImportOptions();

            importOptions.TextDelimiter = ',';
            importOptions.TextQualifier = '"';
            importOptions.ImportMode = ImportMode.UpdateImport;
            switch (SelectedImportMode.SelectedValue)
            {
                case "Insert":
                    importOptions.ImportMode = ImportMode.ImportOnly;
                    break;
                case "Update":
                    importOptions.ImportMode = ImportMode.UpdateOnly;
                    break;
            }

            return importOptions;
        }

        protected void CancelImportButton_Click(object sender, EventArgs e)
        {
            if(ProductVariantsImportManager.Instance.IsImportRunning)
            {
                ProductVariantsImportManager.Instance.CancelImport();
            }

            ProgressLabel.Text = "Cancelling import process.";
            CancelImportButton.Visible = false;
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            ProgressPanel.Visible = false;
            OptionsPanel.Visible = true;
            MessagesPanel.Visible = false;
        }

        protected void StartButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                StartImport();

                ProgressPanel.Visible = true;
                OptionsPanel.Visible = false;
                MessagesPanel.Visible = false;
            }
        }
    }

}