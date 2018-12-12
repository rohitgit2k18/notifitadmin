using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.DataExchange;
using CommerceBuilder.Utility;
using CommerceBuilder.Search;
using System.IO;
using System.Web.Script.Serialization;
using CommerceBuilder.Common;
using CommerceBuilder.Users;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class UsersExport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        UserExportManager _userExportManager = null;
        string _selectedUserFieldsKey = "SelectedUserCSVFields";

        protected void Page_Load(object sender, EventArgs e)
        {
            _userExportManager = UserExportManager.Instance;
            if (!Page.IsPostBack)
            {
                // check if the page export request is sent from user manager page
                string exportType = Request.QueryString["Type"];
                if (!string.IsNullOrEmpty(exportType))
                {
                    ExportOptionsPanel.Visible = false;
                    FieldSelectionPanel.Visible = true;
                    ExportCaption.Text = string.Format(ExportCaption.Text, GetExportCount());
                }

                FieldNamesList.DataSource = _userExportManager.CsvEnabledFields;
                FieldNamesList.DataBind();

                // SELECT FIELDS BASED ON USER SETTINGS
                string listSelectedFields = AbleContext.Current.User.Settings.GetValueByKey(_selectedUserFieldsKey, string.Empty);
                if (!string.IsNullOrEmpty(listSelectedFields))
                {
                    string[] userLastSelectedFields = listSelectedFields.Split(',');
                    foreach (ListItem item in FieldNamesList.Items)
                    {
                        if (userLastSelectedFields.Contains(item.Value)) item.Selected = true;
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
            string exportType = Request.QueryString["Type"];
            string ids = Session["EXPORT_USER_IDS"] as string;
            if (!string.IsNullOrEmpty(exportType) && !string.IsNullOrEmpty(ids) && exportType == "selected")
            {
                return AlwaysConvert.ToIntArray(ids).Length;
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                var serializer = new JavaScriptSerializer();
                UserSearchCriteria criteria = serializer.Deserialize(Request.QueryString["filter"], typeof(UserSearchCriteria)) as UserSearchCriteria;
                return UserDataSource.SearchCount(criteria);
            }
            else
            {
                return UserDataSource.CountAll();
            }
        }

        protected void StartExportButton_Click(object sender, EventArgs e)
        {
            DoExport();
        }

        private UserSearchCriteria DeserializeFilter()
        {
            UserSearchCriteria criteria = new UserSearchCriteria();
            if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                var serializer = new JavaScriptSerializer();
                criteria = serializer.Deserialize(Request.QueryString["filter"], typeof(UserSearchCriteria)) as UserSearchCriteria;
            }
            return criteria;
        }

        private void DoExport()
        {
            UserSearchCriteria criteria = null;
            UserExportOptions exportOptions = new UserExportOptions();

            string exportType = Request.QueryString["Type"];
            if (!string.IsNullOrEmpty(exportType) && exportType == "selected")
            {
                string userIds = Session["EXPORT_USER_IDS"] as string;
                exportOptions.UserIdRange = userIds;
            }
            else criteria = DeserializeFilter();

            
            exportOptions.FileTag = FileTag.Text.Trim();
            exportOptions.SelectionCriteria = criteria;
            
            List<string> fieldNames = new List<string>();
            foreach (ListItem item in FieldNamesList.Items)
            {
                if (item.Selected)
                    fieldNames.Add(item.Value);
            }

            exportOptions.DataFormat = DataFormat.CSV;
            exportOptions.SelectedFields = fieldNames.ToArray();    

            _userExportManager.BeginExportAsync(exportOptions);
            if (fieldNames.Count > 0)
            {
                Timer1.Enabled = true;
                ProgressLabel.Text = "Starting user export.";
                ProgressPanel.Visible = true;
                FieldSelectionPanel.Visible = false;
                ExportOptionsPanel.Visible = false;
            }
                
            AbleContext.Current.User.Settings.SetValueByKey(_selectedUserFieldsKey, string.Join(",", fieldNames.ToArray()));
            AbleContext.Current.User.Settings.Save();
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (_userExportManager.IsExportRunning)
            {
                ProgressLabel.Text = string.Format(ProgressLabel.Text, _userExportManager.ExportInfo.TotalItems, _userExportManager.ExportInfo.ItemsExported);
            }
            else
            {
                Timer1.Enabled = false;
                ProgressPanel.Visible = false;

                IList<string> messages = _userExportManager.ExportInfo.Messages;
                if (messages != null && messages.Count > 0)
                {
                    MessagesPanel.Visible = true;
                    Messages.DataSource = _userExportManager.ExportInfo.Messages;
                    Messages.DataBind();
                }
                else
                {
                    ExportOptionsPanel.Visible = true;
                    // show confirmation
                    ExportCompleteMessage.Visible = true;
                    ExportCompleteMessage.Text = string.Format(ExportCompleteMessage.Text, LocaleHelper.LocalNow);
                }

                BindBackFilesGrid();
            }
        }

        protected void FinishButton_Click(object sender, EventArgs e)
        {
            ProgressPanel.Visible = false;
            ExportOptionsPanel.Visible = true;
            MessagesPanel.Visible = false;
        }

        #region Backup files grid

        protected void BindBackFilesGrid()
        {
            string mappedPath = Server.MapPath("~/App_Data/DataExchange/Download/");
            if (Directory.Exists(mappedPath))
            {
                string[] backupFilePaths = Directory.GetFiles(mappedPath, "USERS_*.zip", SearchOption.TopDirectoryOnly);
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
            public DateTime CreatedDate { get; set;}
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