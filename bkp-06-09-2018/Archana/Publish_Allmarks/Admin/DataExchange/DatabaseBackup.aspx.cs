using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Services;
using System.Configuration;
using CommerceBuilder.Utility;
using System.ComponentModel;
using System.IO;
using CommerceBuilder.Common;
using ICSharpCode.SharpZipLib.Zip;

namespace AbleCommerce.Admin.DataExchange
{
    public partial class DatabaseBackup : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        string sessionKey = "AC_DBBackupGenerator";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[sessionKey] != null)
            {
                UpdateProgress();
            }

            if (!Page.IsPostBack)
            {
                BindBackFilesGrid();
            }
        }

        #region Backup files grid

        protected void BindBackFilesGrid()
        {
            string mappedPath = Server.MapPath("~/App_Data/DbBackup/");
            if (Directory.Exists(mappedPath))
            {
                string[] backupFilePaths = Directory.GetFiles(mappedPath, "*.zip", SearchOption.TopDirectoryOnly);
                if (backupFilePaths != null)
                {
                    IList<BackupFile> backupFiles = new List<BackupFile>();
                    // GET FILE NAMES
                    for(int i = 0; i <backupFilePaths.Length; i++)
                    {
                        FileInfo fileInfo = new FileInfo(backupFilePaths[i]);
                        BackupFile file = new BackupFile(fileInfo.Name, (fileInfo.Length / 1024));
                        backupFiles.Add(file);
                    }

                    backupFiles.Sort("FileName", CommerceBuilder.Common.SortDirection.DESC);
                
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
                string mappedPath = Server.MapPath("~/App_Data/DbBackup/" + fileName);
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

            public BackupFile(string name, long size)
            {
                this.FileName = name;
                this.Size = size;
            }
        }
        # endregion


        # region Backup
        #endregion

        protected void BackupButton_Click(object sender, EventArgs e)
        {
            BackupFileName.Value = "DatabaseBackup_" + LocaleHelper.LocalNow.ToString("yyyyMMdd_HHmmss") + ".sql";
            SqlScriptGenerator bckupGenerator = new SqlScriptGenerator(ConfigurationManager.ConnectionStrings["AbleCommerce"].ConnectionString);
            bckupGenerator.AsyncGenerateSqlScripts(Server.MapPath("~/App_Data/DbBackup/" + BackupFileName.Value));
            HiddenStartedTime.Value = LocaleHelper.LocalNow.ToString();
            Session[sessionKey] = bckupGenerator;
            
            UpdateProgress();
        }

        private void UpdateProgress()
        {
            if (Session[sessionKey] != null)
            {
                SqlScriptGenerator bckupGenerator = (SqlScriptGenerator)Session[sessionKey];
                if (bckupGenerator.InProgress)
                {
                    DateTime startDate = DateTime.Parse(HiddenStartedTime.Value);
                    int seconds = 1;
                    seconds = (int)Math.Ceiling(LocaleHelper.LocalNow.Subtract(startDate).TotalSeconds);
                    int minutes = seconds / 60;
                    seconds = seconds - (60 * minutes);
                    ProgressLabel.Text = string.Format(ProgressLabel.Text, minutes, seconds);
                    ProgressPanel.Visible = true;
                    BackupPanel.Visible = false;
                    Timer1.Enabled = true;
                }
                else
                {
                    Session[sessionKey] = null;
                    Timer1.Enabled = false;

                    // update UI
                    ProgressPanel.Visible = false;
                    BackupPanel.Visible = true;
                    HiddenStartedTime.Value = string.Empty;

                    // show confirmation
                    BackupCompleteMessage.Visible = true;
                    BackupCompleteMessage.Text = string.Format(BackupCompleteMessage.Text, LocaleHelper.LocalNow);

                    CompressBackupFile();
                }
            }
        }

        protected void CompressBackupFile()
        {
            string sqlFileName = BackupFileName.Value;
            string sqlFilePath = Server.MapPath("~/App_Data/DbBackup/" + sqlFileName);
            if (File.Exists(sqlFilePath))
            {
                string destination = Server.MapPath(string.Format("~/App_Data/DbBackup/{0}.zip", sqlFileName.Substring(0, sqlFileName.Length - 4)));                
                FastZip fZip = new FastZip();
                fZip.CreateZip(destination, Server.MapPath("~/App_Data/DbBackup/"), false, sqlFileName);

                // delete the text file
                File.Delete(sqlFilePath);
            }
            BindBackFilesGrid();
        }


        protected void Timer1_Tick(object sender, EventArgs e)
        {
            // DISABLE THE TIMER IF INDEX CREATION IS COMPLETE
            if (Session[sessionKey] == null)
            {
                Timer1.Enabled = false;
            }
            else UpdateProgress();
        }
    }
}