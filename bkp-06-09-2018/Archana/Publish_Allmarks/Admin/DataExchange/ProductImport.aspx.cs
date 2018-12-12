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

    public partial class ProductImport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _PreviousWizardStepIndex = -1;
        protected void Page_Init(object sender, EventArgs e)
        {
            BindCategories();
            BindMatchFields();
            BindFileList();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (ProductImportManager.Instance.IsImportRunning)
                {
                    ImportWizard.ActiveStepIndex = 5;
                    Timer1.Enabled = true;
                    ProgressLabel.Text = string.Format(ProgressLabel.Text, ProductImportManager.Instance.ImportInfo.TotalItems, ProductImportManager.Instance.ImportInfo.ItemsImported);
                }
                else ImportWizard.ActiveStepIndex = 0;
            }
            UploadMaxSize.Text = String.Format(UploadMaxSize.Text, AbleContext.Current.Store.Settings.MaxRequestLength);
            ImportWizard.HeaderText = ImportWizard.ActiveStep.Title;
        }

        protected void BindCategories()
        {
            IList<CategoryLevelNode> categories = CategoryParentDataSource.GetCategoryLevels(0);
            int st = 1;
            foreach (CategoryLevelNode node in categories)
            {
                string prefix = string.Empty;
                for (int i = st; i <= node.CategoryLevel; i++) prefix += " . . ";
                InsertCategories.Items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
                UpdateCategories.Items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
                MixCategories.Items.Add(new ListItem(prefix + node.Name, node.CategoryId.ToString()));
            }
        }

        protected void BindMatchFields()
        {
            string[] matchFields = ProductImportManager.Instance.MatchFields;
            InsertMatchFields.Items.Clear();
            InsertMatchFields.DataSource = matchFields;
            InsertMatchFields.DataBind();

            UpdateMatchFields.Items.Clear();
            UpdateMatchFields.DataSource = matchFields;
            UpdateMatchFields.DataBind();

            MixMatchFields.Items.Clear();
            MixMatchFields.DataSource = matchFields;
            MixMatchFields.DataBind();

        }

        protected void BindFileList()
        {
            string mappedPath = Server.MapPath("~/App_Data/DataExchange/Upload/");
            if (Directory.Exists(mappedPath))
            {
                string fileTypes = "*.zip|*.csv|*.txt";
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
            if (ProductImportManager.Instance.IsImportRunning)
            {
                if (ProductImportManager.Instance.ImportInfo.TotalItems > 0) ProgressLabel.Text = string.Format(ProgressLabel.Text, ProductImportManager.Instance.ImportInfo.TotalItems, ProductImportManager.Instance.ImportInfo.ItemsImported);
                else ProgressLabel.Text = string.Format("Records Processed: {0}", ProductImportManager.Instance.ImportInfo.ItemsImported);
            }
            else
            {
                Timer1.Enabled = false;
                //ProgressPanel.Visible = false;
                //// ImportInputPanel.Visible = false;
                //MessagesPanel.Visible = true;
                ImportWizard.ActiveStepIndex = ImportWizard.ActiveStepIndex + 1;

                // show confirmation
                Messages.DataSource = ProductImportManager.Instance.ImportInfo.Messages;
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
                        fileName.EndsWith(".txt", StringComparison.InvariantCultureIgnoreCase) ||
                        fileName.EndsWith(".csv", StringComparison.InvariantCultureIgnoreCase))
                    {
                        string saveFilePath = fileName.StartsWith("PRODUCTS_", StringComparison.InvariantCultureIgnoreCase) ? fileName : "PRODUCTS_" + fileName;
                        saveFilePath = Server.MapPath(Path.Combine("~/App_Data/DataExchange/Upload/", saveFilePath));

                        HttpPostedFile file = Request.Files[0];
                        int fileLength = file.ContentLength;
                        Byte[] buffer = new byte[fileLength];
                        file.InputStream.Read(buffer, 0, fileLength);
                        File.WriteAllBytes(saveFilePath, buffer);

                        if (File.Exists(saveFilePath))
                        {
                            ProductImportOptions importOptions = GetImportOptions();
                            importOptions.DeleteSourceFile = true;
                            ProductImportManager.Instance.BeginImportAsync(saveFilePath, importOptions);

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
                    ProductImportOptions importOptions = GetImportOptions();
                    ProductImportManager.Instance.BeginImportAsync(importFilePath, importOptions);
                    
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
                if (FileHelper.IsExtensionValid(fileName, "csv,zip,txt"))
                {
                    isValid = true;
                }
            }

            return isValid;
        }

        private ProductImportOptions GetImportOptions()
        {
            ProductImportOptions importOptions = new ProductImportOptions();

            // SELECTED IMPORT MODE
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

            importOptions.TextDelimiter = ',';
            importOptions.TextQualifier = '"';
            switch (TextDelimiter.SelectedValue)
            {
                case ",": importOptions.TextDelimiter = ','; break;
                case ";": importOptions.TextDelimiter = ';'; break;
                case "|": importOptions.TextDelimiter = '|'; break;
                case "": importOptions.TextDelimiter = '\t'; break;
            }

            switch (TextQualifier.SelectedValue)
            {
                case "'": importOptions.TextQualifier = '\''; break;
                case "&quot;":
                case "\"": importOptions.TextQualifier = '"'; break;
            }

            // MATCH FIELDS, CategoryUpdateMode, AND AddToCustomCategories, selected categories
            switch (importOptions.ImportMode)
            {
                case ImportMode.ImportOnly:
                    if (InsertMatchMode.SelectedIndex == 0) importOptions.SelectedMatchFields = new string[0];
                    else importOptions.SelectedMatchFields = GetSelectedMatchFields(InsertMatchFields).ToArray();

                    importOptions.AddToCustomCategories = CategoryAddMode.SelectedValue == "1";

                    importOptions.SelectedCategories = GetSelectedCategories(InsertCategories).ToArray();
                    break;
                case ImportMode.UpdateOnly:
                    if (UpdateMatchMode.SelectedIndex == 0) importOptions.SelectedMatchFields = new string[]{"ProductId"};
                    else importOptions.SelectedMatchFields = GetSelectedMatchFields(UpdateMatchFields).ToArray();

                    importOptions.CategoryUpdateMode = GetSelectedCategoryUpdateMode(UpdateCategoryUpdateMode);
                    importOptions.SelectedCategories = GetSelectedCategories(UpdateCategories).ToArray();
                    break;
                case ImportMode.UpdateImport:
                    if (MixMatchMode.SelectedIndex == 0) importOptions.SelectedMatchFields = new string[] { "ProductId" };
                    else importOptions.SelectedMatchFields = GetSelectedMatchFields(MixMatchFields).ToArray(); 

                    importOptions.AddToCustomCategories = MixCategoryInsertMode.SelectedValue == "1";
                    importOptions.CategoryUpdateMode = GetSelectedCategoryUpdateMode(MixCategoryUpdateMode);
                    importOptions.SelectedCategories = GetSelectedCategories(MixCategories).ToArray();
                    break;
            }

            return importOptions;
        }

        private List<String> GetSelectedMatchFields(ListBox matchFieldsList)
        {
            List<String> matchFields = new List<string>();
            foreach (ListItem item in matchFieldsList.Items)
            {
                if (item.Selected)
                {
                    matchFields.Add(item.Value);
                }
            }

            return matchFields;
        }

        private List<int> GetSelectedCategories(ListBox categoriesList)
        {
            List<int> categories = new List<int>();
            foreach (ListItem item in categoriesList.Items)
            {
                if (item.Selected)
                {
                    categories.Add(AlwaysConvert.ToInt(item.Value));
                }
            }

            return categories;
        }

        

        private CategoryUpdateMode GetSelectedCategoryUpdateMode(RadioButtonList list)
        {
            switch (list.SelectedValue)
            {
                case "0": return CommerceBuilder.DataExchange.CategoryUpdateMode.NoUpdate;
                case "1": return CommerceBuilder.DataExchange.CategoryUpdateMode.UpdateAsUploadData;
                case "2": return CommerceBuilder.DataExchange.CategoryUpdateMode.CustomUpdate;
            }
            return CategoryUpdateMode.NoUpdate;
        }

        protected void CancelImportButton_Click(object sender, EventArgs e)
        {
            if(ProductImportManager.Instance.IsImportRunning)
            {
                ProductImportManager.Instance.CancelImport();
            }

            ProgressLabel.Text = "Cancelling import process.";
            CancelImportButton.Visible = false;
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            ImportWizard.ActiveStepIndex = 0;
        }

        protected void ImportWizard_FinishButtonClick(object sender, WizardNavigationEventArgs e)
        {
            if (!Page.IsValid || !StartImport())
            {
                e.Cancel = true;
                return;
            }
        }

        protected void ImportWizard_NextButtonClick(object sender, WizardNavigationEventArgs e)
        {
            if (!Page.IsValid)
            {
                e.Cancel = true;
                return;
            }

            if (ImportWizard.ActiveStepIndex == 0)
            {
                string mode = SelectedImportMode.SelectedValue;
                switch(mode)
                {
                    case "Insert": ImportWizard.ActiveStepIndex = 1; break;
                    case "Update": ImportWizard.ActiveStepIndex = 2; break;
                    case "Mix": ImportWizard.ActiveStepIndex = 3; break;
                }
            }
            else if (ImportWizard.ActiveStepIndex == 1
                || ImportWizard.ActiveStepIndex == 2
                || ImportWizard.ActiveStepIndex == 3)
            {
                _PreviousWizardStepIndex = ImportWizard.ActiveStepIndex;
                ImportWizard.ActiveStepIndex = 4;
            }
        }

        protected void ImportWizard_PreviousButtonClick(object sender, WizardNavigationEventArgs e)
        {
            if (ImportWizard.ActiveStepIndex == 1
                || ImportWizard.ActiveStepIndex == 2
                || ImportWizard.ActiveStepIndex == 3)
            {   
                ImportWizard.ActiveStepIndex = 0;
            }
        }

        protected string GetStepTitle()
        {
            if (ImportWizard.ActiveStepIndex == 4 && _PreviousWizardStepIndex > 0) return ImportWizard.WizardSteps[_PreviousWizardStepIndex].Title;
            else return ImportWizard.ActiveStep.Title;
        }
    }

}