//-----------------------------------------------------------------------
// <copyright file="Configure1.aspx.cs" company="Able Solutions Corporation">
//     Copyright (c) 2011-2014 Able Solutions Corporation. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace AbleCommerce.Install
{
    using System;
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.IO;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Configuration;
    using CommerceBuilder.Licensing;
    using CommerceBuilder.Utility;

    public partial class Configure1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                PageCaption.Text = string.Format(PageCaption.Text, AbleContext.Current.ReleaseLabel + " (build " + AbleContext.Current.Version.Revision.ToString() + ")");
            }
        }

        protected void DatabaseChoiceChanged(object sender, EventArgs e)
        {
            string radio = ((RadioButton)sender).ID;
            DbSimplePanel.Visible = radio.Equals("DbSimple");
            DbAdvancedPanel.Visible = radio.Equals("DbAdvanced");
            DbLocalPanel.Visible = radio.Equals("DbLocal");
        }

        protected void KeyChoiceChanged(object sender, EventArgs e)
        {
            string radio = ((RadioButton)sender).ID;
            DemoKeyPanel.Visible = radio.Equals("DemoKeyOption");
            LicenseKeyPanel.Visible = radio.Equals("LicenseKeyOption");
            UploadKeyPanel.Visible = radio.Equals("UploadKeyOption");
            InstallButton.Visible = !UploadKeyPanel.Visible;
            FullPostbackInstallButton.Visible = UploadKeyPanel.Visible;
        }

        protected void InstallButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (PCIAcknowledgement.Checked)
                {
                    // VALIDATE THE CONNECTION
                    string connectionString = GenerateConnectionString();
                    string connectionMessage;
                    if (ConfigUtility.ValidateConnection(connectionString, out connectionMessage))
                    {
                        if (ValidateKey())
                        {
                            // hide the configuration form
                            FormPanel.Visible = false;

                            // SETUP THE DATABASE
                            List<string> errorList = new List<string>();
                            if (IsNewInstall()) errorList = RunScript(connectionString, Server.MapPath("~/Install/AbleCommerce.sql"));

                            // WRITE WEB.CONFIG
                            ConfigUtility.UpdateConnectionString(connectionString, true);

                            // IF ITS EXISTING AC7 INSTALL THEN REDIRECT TO UPGRADE PAGE
                            if (!IsNewInstall())
                            {
                                // VALIDATE IF WE HAVE A VALID VERSION OF THE DATABASE TO UPGRADE
                                if (ValidateExistingDatabase(connectionString, errorList))
                                    Response.Redirect("Upgrade.aspx", true);
                                else ContinueButton2.Visible = false;
                            }

                            // update results
                            if (errorList.Count == 0)
                            {
                                ConfigurationCompletePanel.Visible = true;
                            }
                            else
                            {
                                ConfigurationErrorPanel.Visible = true;
                                ConfigurationErrorList.Text = "<p>" + string.Join("</p><p>", errorList.ToArray()) + "</p>";
                            }
                        }
                    }
                    else
                    {
                        HandleError("<p style=\"color:#FF0000;\">The specified database connection could not be opened.</p><p style=\"color:#FF0000;\">Connection String: " + connectionString + "</p><p style=\"color:#FF0000;\">Message: " + connectionMessage + "</p>");
                    }
                }
                else
                {
                    HandleError("<p style=\"color:#FF0000;\">You must acknowledge that you have reviewed the secure implementation guide.</p>");
                }
            }
        }

        private bool IsNewInstall()
        {
            return DbLocal.Checked || (DbSimple.Checked && NewInstall1.Checked) || (DbAdvanced.Checked && NewInstall2.Checked);
        }

        private bool ValidateExistingDatabase(string connectionString, List<string> errorList)
        {
            bool isValidDatabase = false;

            // SETUP DATABASE CONNECTION
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Run each command on the database
                conn.Open();

                // CHECK IF ITS AC7.0.3 OR HIGHER DATABSE
                bool isValidAC7Database = false;
                string sql = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_Kits'";
                try
                {
                    SqlCommand command = new SqlCommand(sql, conn);
                    string tableName = (string)command.ExecuteScalar();

                    if (string.IsNullOrEmpty(tableName) || tableName != "ac_Kits")
                    {
                        errorList.Add("<b>The specified database is not a valid version. The upgrade only works on databases from AC7.0.3 or higher.</b>");
                        isValidAC7Database = false;
                    }
                    else isValidAC7Database = true;
                }
                catch (Exception ex)
                {
                    errorList.Add("<b>SQL:</b> " + sql);
                    errorList.Add("<b>Error:</b> " + ex.Message);
                }

                if (isValidAC7Database)
                {
                    // CHECK IF ITS ALREADY UPGRADED TO  AC708
                    sql = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ac_Languages'";
                    try
                    {
                        SqlCommand command = new SqlCommand(sql, conn);
                        string tableName = (string)command.ExecuteScalar();

                        if(string.IsNullOrEmpty(tableName))
                            isValidDatabase = true;
                        else
                            errorList.Add("<b>The specified database has already been upgraded to Gold.  Please click <a href='../default.aspx'>here</a> to continue.</b>");
                    }
                    catch (Exception ex)
                    {
                        errorList.Add("<b>SQL:</b> " + sql);
                        errorList.Add("<b>Error:</b> " + ex.Message);
                    }
                }

                conn.Close();
            }

            return isValidDatabase;
        }

        /// <summary>
        /// Displays an error message
        /// </summary>
        /// <param name="errorMessage">Displays a validation error</param>
        private void HandleError(string errorMessage)
        {
            MessagePanel.Visible = true;
            ReponseMessage.Text = errorMessage;
        }

        /// <summary>
        /// Generates a connection string based on the user input
        /// </summary>
        /// <returns>The connection string as configured by the installing user</returns>
        private string GenerateConnectionString()
        {
            if (DbSimple.Checked)
            {
                return string.Format("Server={0};Database={1};Uid={2};Pwd={3};", DbServerName.Text, DbDatabaseName.Text, DbUserName.Text, DbPassword.Text);
            }
            else if (DbAdvanced.Checked)
            {
                return DbConnectionString.Text;
            }
            else
            {
                return string.Format(@"Data Source={0};Integrated Security=True;AttachDbFileName=|DataDirectory|\AbleCommerce.mdf;User Instance=true;", DbLocalInstanceName.Text);
            }
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
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Run each command on the database
                conn.Open();
                foreach (string sql in commands)
                {
                    try
                    {
                        SqlCommand command = new SqlCommand(sql, conn);
                        command.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        errorList.Add("<b>SQL:</b> " + sql);
                        errorList.Add("<b>Error:</b> " + ex.Message);
                    }
                }
                conn.Close();
            }
            return errorList;
        }

        private bool ValidateKey()
        {
            if (DemoKeyOption.Checked) return RequestDemoKey();
            else if (LicenseKeyOption.Checked) return RequestKey();
            else return UploadLicense();
        }

        private bool RequestDemoKey()
        {
            DemoKeyRequest keyRequest = new DemoKeyRequest();
            keyRequest.Name = Name.Text;
            keyRequest.Company = Company.Text;
            keyRequest.Email = Email.Text;
            keyRequest.Phone = Phone.Text;
            keyRequest.Host = Request.Url.Host;
            keyRequest.Port = Request.Url.Port;
            KeyReply keyReply = KeyService.RequestDemoKey(keyRequest);
            if (keyReply.Success)
            {
                // request succeeded, save new license to file
                string filePath = Server.MapPath("~/App_Data/CommerceBuilder.lic");
                File.WriteAllText(filePath, keyReply.LicenseKey);
                return true;
            }
            else
            {
                HandleError(keyReply.Message);
                return false;
            }
        }

        private bool RequestKey()
        {
            KeyReply keyReply = KeyService.RequestKey(LicenseKey.Text);
            if (keyReply.Success)
            {
                // request succeeded, save new license to file
                string filePath = Server.MapPath("~/App_Data/CommerceBuilder.lic");
                File.WriteAllText(filePath, keyReply.LicenseKey);
                return true;
            }
            else
            {
                HandleError(keyReply.Message);
                return false;
            }
        }

        private bool UploadLicense()
        {
            // upload key option
            if (Request.Files.Count > 0)
            {
                // get the file from the stream
                string licenseXml;
                using (StreamReader stream = new StreamReader(Request.Files[0].InputStream))
                {
                    licenseXml = stream.ReadToEnd();
                }

                // validate the license content
                License lic = new License(licenseXml);
                if (lic.IsValid)
                {
                    // license is valid, save to file
                    string filePath = Server.MapPath("~/App_Data/CommerceBuilder.lic");
                    File.WriteAllText(filePath, licenseXml);
                    return true;
                }
                else
                {
                    HandleError("The key file you uploaded is not a valid license key.");
                    return false;
                }
            }
            else
            {
                HandleError("No key file was uploaded.");
                return false;
            }
        }
    }
}