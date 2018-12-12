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
using CommerceBuilder.Orders;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class OrdersExport : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        OrderExportManager _orderExportManager = null;
        string _userOrderFieldsKey = "SelectedOrderCSVFields";

        protected void Page_Load(object sender, EventArgs e)
        {
            _orderExportManager = OrderExportManager.Instance;
            if (!Page.IsPostBack)
            {
                // check if the page export request is sent from order manager page
                string exportType = Request.QueryString["Type"];
                if (!string.IsNullOrEmpty(exportType))
                {
                    ExportOptionsPanel.Visible = false;
                    FieldSelectionPanel.Visible = true;
                    ExportCaption.Text = string.Format(ExportCaption.Text, OrderDataSource.CountForFilter(DeserializeFilter()));
                }

                FieldNamesList.DataSource = _orderExportManager.CsvEnabledFields;
                FieldNamesList.DataBind();

                // SELECT FIELDS BASED ON USER SETTINGS
                string listSelectedFields = AbleContext.Current.User.Settings.GetValueByKey(_userOrderFieldsKey, string.Empty);
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

            trExportAccountData.Visible = ExportFormat.SelectedValue == "XML";
        }

        protected void StartExportButton_Click(object sender, EventArgs e)
        {
            OrderFilter criteria = DeserializeFilter();
            DoExport(criteria);
        }

        private OrderFilter DeserializeFilter()
        {
            OrderFilter criteria = new OrderFilter();
            string exportType = Request.QueryString["Type"];
            if (!string.IsNullOrEmpty(exportType) && exportType == "selected")
            {
                string orderIds = string.Join(",", AbleContext.Current.Session.SelectedOrderIds);
                criteria = new OrderFilter();
                criteria.OrderIdRange = orderIds;
            }
            else if (!string.IsNullOrEmpty(Request.QueryString["filter"]))
            {
                var serializer = new JavaScriptSerializer();
                criteria = serializer.Deserialize(Request.QueryString["filter"], typeof(OrderFilter)) as OrderFilter;
            }
            return criteria;
        }

        private void DoExport(OrderFilter criteria)
        {
            OrderExportOptions exportOptions = new OrderExportOptions();
            exportOptions.FileTag = FileTag.Text.Trim();
            exportOptions.SelectionCriteria = criteria;

            if (ExportFormat.SelectedValue == "CSV")
            {
                List<string> fieldNames = new List<string>();
                foreach (ListItem item in FieldNamesList.Items)
                {
                    if (item.Selected)
                        fieldNames.Add(item.Value);
                }

                exportOptions.DataFormat = DataFormat.CSV;
                exportOptions.SelectedFields = fieldNames.ToArray();    

                _orderExportManager.BeginExportAsync(exportOptions);
                if (fieldNames.Count > 0)
                {
                    Timer1.Enabled = true;
                    ProgressLabel.Text = "Starting order export.";
                    ProgressPanel.Visible = true;
                    FieldSelectionPanel.Visible = false;
                    ExportOptionsPanel.Visible = false;
                }
                
                AbleContext.Current.User.Settings.SetValueByKey(_userOrderFieldsKey, string.Join(",", fieldNames.ToArray()));
                AbleContext.Current.User.Settings.Save();
            }
            else
            {
                exportOptions.DataFormat = DataFormat.XML;
                _orderExportManager.ExportPaymentAccountData = ExportAccountData.Checked;
                _orderExportManager.BeginExportAsync(exportOptions);
                Timer1.Enabled = true;
                ProgressLabel.Text = "Starting order export.";
                ProgressPanel.Visible = true;
                FieldSelectionPanel.Visible = false;
                ExportOptionsPanel.Visible = false;
            }
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            if (_orderExportManager.IsExportRunning)
            {
                ProgressLabel.Text = string.Format(ProgressLabel.Text, _orderExportManager.ExportInfo.TotalItems, _orderExportManager.ExportInfo.ItemsExported);
            }
            else
            {
                Timer1.Enabled = false;
                ProgressPanel.Visible = false;

                IList<string> messages = _orderExportManager.ExportInfo.Messages;
                if (messages != null && messages.Count > 0)
                {
                    MessagesPanel.Visible = true;
                    Messages.DataSource = _orderExportManager.ExportInfo.Messages;
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

        protected void ExportFormat_SelectedIndexChanged(object sender, EventArgs e)
        {
            CSVFieldsPanel.Visible = ExportFormat.SelectedValue == "CSV";
        }

        #region Backup files grid

        protected void BindBackFilesGrid()
        {
            string mappedPath = Server.MapPath("~/App_Data/DataExchange/Download/");
            if (Directory.Exists(mappedPath))
            {
                string[] backupFilePaths = Directory.GetFiles(mappedPath, "ORDERS_*.zip", SearchOption.TopDirectoryOnly);
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