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
using CommerceBuilder.Orders;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class UpsWsExport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        UpsWsExportManager _upsWsExportManager = null;

        protected void Page_Init(object sender, EventArgs e)
        {
            //GET ORDER STATUSES FOR STORE
            IList<OrderStatus> statuses = OrderStatusDataSource.LoadAll();
            IList<OrderStatus> validStatuses = new List<OrderStatus>();
            IList<OrderStatus> invalidStatuses = new List<OrderStatus>();
            //BUILD STATUS FILTER
            String statusNamePrefix = "- ";
            foreach (OrderStatus status in statuses)
            {
                if (status.IsValid)
                {
                    validStatuses.Add(status);
                }
                else
                {
                    invalidStatuses.Add(status);
                }
            }
            // ADD VALID STATUSES
            StatusFilter.Items.Add(new ListItem("All Valid", "-2"));
            foreach (OrderStatus status in validStatuses)
            {
                StatusFilter.Items.Add(new ListItem(statusNamePrefix + status.Name, status.Id.ToString()));
            }
            // ADD INVALID STATUSES
            StatusFilter.Items.Add(new ListItem("All Invalid", "-3"));
            foreach (OrderStatus status in invalidStatuses)
            {
                StatusFilter.Items.Add(new ListItem(statusNamePrefix + status.Name, status.Id.ToString()));
            }
            // SET THE DEFAULT AS ALL-VALID
            StatusFilter.SelectedIndex = 1;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _upsWsExportManager = UpsWsExportManager.Instance;
            if (!Page.IsPostBack)
            {
                FileTag.Text = AbleContext.Current.User.Settings.GetValueByKey("UPSWS_EXPORT_FILE_NAME");
                if (_upsWsExportManager.IsExportRunning)
                {
                    ProgressPanel.Visible = true;
                    Timer1.Enabled = true;
                    ProgressLabel.Text = string.Format(ProgressLabel.Text, _upsWsExportManager.ExportInfo.TotalItems, _upsWsExportManager.ExportInfo.ItemsExported);
                }
                InputPanel.Visible = !ProgressPanel.Visible;

                BindBackFilesGrid();
            }
        }

        protected void OnQVNStatusChanged(object sender, EventArgs e)
        {
            QnvOptions.Enabled = EnableQvn.Checked;
        }

        protected void StartExportButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                UpsWsExportOptions exportOptions = new UpsWsExportOptions();
                exportOptions.DataFormat = DataFormat.CSV;
                exportOptions.TextDelimiter = ',';
                exportOptions.TextQualifier = '"';

                exportOptions.FileTag = FileTag.Text.Trim();

                if (OrderStartDate.SelectedStartDate > DateTime.MinValue)
                    exportOptions.FromDate = OrderStartDate.SelectedStartDate;
                if (OrderEndDate.SelectedEndDate > DateTime.MinValue && OrderEndDate.SelectedEndDate < DateTime.MaxValue)
                    exportOptions.EndDate = OrderEndDate.SelectedEndDate;

                exportOptions.IncludeExportedOrders = IncludeExported.Checked;
                exportOptions.IncludeUnpaidOrders = IncludeUnpaidOrders.Checked;
                exportOptions.MarkExported = MarkExported.Checked;
                exportOptions.OnlyUPSShipments = OnlyUpsShipments.Checked;
                exportOptions.OrderNumbers = OrderNumberFilter.Text.Trim();
                exportOptions.OrderStatusId = AlwaysConvert.ToInt(StatusFilter.SelectedValue);

                // QVN OPTIONS
                exportOptions.EnableQVN = EnableQvn.Checked;
                exportOptions.QVNSubject = SubjectLine.SelectedValue;
                exportOptions.QVNFailedEmail = NotificationEmail.Text.Trim();
                exportOptions.QVN1D = DeliveryNotification.Checked;
                exportOptions.QVN1E = ExceptionNotification.Checked;
                exportOptions.QVN1S = ShipmentNotification.Checked;

                if (!string.IsNullOrEmpty(exportOptions.FileTag))
                {
                    var settings = AbleContext.Current.User.Settings;
                    settings.SetValueByKey("UPSWS_EXPORT_FILE_NAME", exportOptions.FileTag);
                    settings.Save();
                }
                
                _upsWsExportManager.BeginExport(exportOptions);

                
                Timer1.Enabled = true;
                ProgressLabel.Text = "Starting export.";
                ProgressPanel.Visible = true;
                InputPanel.Visible = false;
            }
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (_upsWsExportManager.ExportInfo != null &&_upsWsExportManager.IsExportRunning)
            {
                ProgressLabel.Text = string.Format(ProgressLabel.Text, _upsWsExportManager.ExportInfo.TotalItems, _upsWsExportManager.ExportInfo.ItemsExported);
            }
            else
            {                
                Timer1.Enabled = false;
                ProgressPanel.Visible = false; 

                IList<string> messages = _upsWsExportManager.ExportInfo.Messages;
                if (messages != null && messages.Count > 0)
                {
                    MessagesPanel.Visible = true;
                    Messages.DataSource = _upsWsExportManager.ExportInfo.Messages;
                    Messages.DataBind();
                }
                else
                {
                    InputPanel.Visible = true;
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
            InputPanel.Visible = true;
            MessagesPanel.Visible = false;
        }

        #region Backup files grid

        protected void BindBackFilesGrid()
        {
            string mappedPath = Server.MapPath("~/App_Data/DataExchange/Download/");
            if (Directory.Exists(mappedPath))
            {
                string[] backupFilePaths = Directory.GetFiles(mappedPath, "UPSWS_*.zip", SearchOption.TopDirectoryOnly);
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