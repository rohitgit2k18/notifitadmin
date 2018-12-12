using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using CommerceBuilder.Common;
using CommerceBuilder.Localization;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Localization
{
    public partial class Resources : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        int _LanguageId = 0;
        Language _Language;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            _LanguageId = AlwaysConvert.ToInt(Request.QueryString["LanguageId"]);
            _Language = LanguageDataSource.Load(_LanguageId);
            if (_Language == null) Response.Redirect("Languages.aspx");

            Caption.Text = string.Format(Caption.Text, _Language.Name);

            //ResourcesGrid.ShowFooter = false;
        }

        protected void AddButton_Click(object sender, EventArgs e)
        {
            ResourcesGrid.ShowFooter = true;
            ResourcesGrid.DataBind();
        }

        protected void ExportXmlButton_Click(object sender, EventArgs e)
        {
            if(_Language != null)
            {
                XmlDocument xml = LanguageManager.ExportResourcesXml(_Language);

                Response.Clear();
                Response.AddHeader("Cache-Control", "private");
                Response.AddHeader("Pragma", "cache");
                Response.AddHeader("Expires", "0");
                Response.ContentType = "text/xml";
                Response.AddHeader("Content-Disposition", "attachment;filename=Language_" + _Language.Name + ".xml");

                // Flush the HEAD information to the client...
                Response.Flush();

                Response.Write(xml.OuterXml);
                Response.Flush();
                Response.Close();
            }
        }

        protected void ExportCsvButton_Click(object sender, EventArgs e)
        {
            if (_Language != null)
            {
                string contents = LanguageManager.ExportResourcesCsv(_Language);

                Response.Clear();
                Response.AddHeader("Cache-Control", "private");
                Response.AddHeader("Pragma", "cache");
                Response.AddHeader("Expires", "0");
                Response.ContentType = "text/csv";
                Response.AddHeader("Content-Disposition", "attachment;filename=Language_" + _Language.Name + ".csv");

                // Flush the HEAD information to the client...
                Response.Flush();

                Response.Write(contents);
                Response.Flush();
                Response.Close();
            }
        }

        protected void ResourcesGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {            
            int resourceId = (int)ResourcesGrid.DataKeys[e.RowIndex].Value;
            LanguageString languageString = LanguageStringDataSource.Load(resourceId);
            if (languageString != null)
            {
                GridViewRow row = (GridViewRow)ResourcesGrid.Rows[e.RowIndex];
                TextBox name = (TextBox)row.FindControl("Name");
                TextBox value = (TextBox)row.FindControl("Translation");

                languageString.ResourceName = name.Text.Trim();
                languageString.Translation = value.Text.Trim();

                languageString.Save();
            }
            ResourcesGrid.EditIndex = -1;
            e.Cancel = true;
            ResourcesGrid.DataBind();
        }

        protected void ResourcesGrid_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("EmptyInsert"))
            {
                TextBox nameField = ResourcesGrid.Controls[0].Controls[0].FindControl("Name") as TextBox;
                TextBox valueField = ResourcesGrid.Controls[0].Controls[0].FindControl("Translation") as TextBox;

                LanguageString languageString = new LanguageString();
                languageString.ResourceName = nameField.Text.Trim();
                languageString.Translation = valueField.Text.Trim();
                languageString.Language = _Language;
                languageString.Save();
                ResourcesGrid.DataBind();
                ResourcesGrid.ShowFooter = false;
            }
            else if (e.CommandName.Equals("Insert"))
            {
                TextBox nameField = ResourcesGrid.FooterRow.FindControl("Name") as TextBox;
                TextBox valueField = ResourcesGrid.FooterRow.FindControl("Translation") as TextBox;                


                // check if a resource with same key already exists
                if (AbleContext.Resolve<ILanguageStringRepository>().Load(nameField.Text.Trim()) == null)
                {
                    LanguageString languageString = new LanguageString();
                    languageString.ResourceName = nameField.Text.Trim();
                    languageString.Translation = valueField.Text.Trim();
                    languageString.Language = _Language;
                    languageString.Save();
                    ResourcesGrid.DataBind();
                }
                else
                {
                    RequiredFieldValidator NameValidator = ResourcesGrid.FooterRow.FindControl("NameValidator") as RequiredFieldValidator;
                    NameValidator.IsValid = false;
                    NameValidator.ErrorMessage = "<br/>Name already exists.";
                }
            }
            else if (e.CommandName.Equals("Cancel"))
            {
                ResourcesGrid.ShowFooter = false;
            }
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // SET THE PATH
                string uploadPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data\\Temp");

                // SAVE THE BINARY FILE DATA
                HttpPostedFile file = null;
                if (Request.Files.Count > 0) file = Request.Files[0];
                bool fileUploaded = ((file != null) && (file.ContentLength > 0));
                if (fileUploaded)
                {
                    string fileName = Path.GetFileName(file.FileName);
                    if (FileHelper.IsExtensionValid(fileName, "csv, xml"))
                    {
                        StreamReader reader = new StreamReader(file.InputStream);
                        string contents = reader.ReadToEnd();

                        string cleanExtension = Path.GetExtension(fileName.Replace(" ", string.Empty)).ToLowerInvariant();
                        if (cleanExtension.StartsWith(".")) cleanExtension = cleanExtension.Substring(1);
                        if (cleanExtension == "xml")
                        {
                            // import xml
                            try
                            {
                                XmlDocument doc = new XmlDocument();
                                doc.LoadXml(contents);
                                UploadCompleteMessage.Text = string.Format(UploadCompleteMessage.Text, LanguageManager.ImportResourcesXml(_Language, doc));
                                UploadCompleteMessage.Visible = true;
                                ResourcesGrid.DataBind();
                            }
                            catch (Exception ex)
                            {
                                CustomValidator xmlValidator = new CustomValidator();
                                xmlValidator.IsValid = false;
                                xmlValidator.ControlToValidate = "UploadFile";
                                xmlValidator.ErrorMessage = "An error has occured while uploading Xml resources from file. " + ex.Message;
                                xmlValidator.Text = "*";
                                xmlValidator.ValidationGroup = "Upload";
                                phUploadFileTypes.Controls.Add(xmlValidator);
                                UploadPopup.Show();
                            }
                        }
                        else
                        {
                            // import csv
                            try
                            {   
                                UploadCompleteMessage.Text = string.Format(UploadCompleteMessage.Text, LanguageManager.ImportResourcesCsv(_Language, contents));
                                UploadCompleteMessage.Visible = true;
                                ResourcesGrid.DataBind();
                            }
                            catch (Exception ex)
                            {
                                CustomValidator xmlValidator = new CustomValidator();
                                xmlValidator.IsValid = false;
                                xmlValidator.ControlToValidate = "UploadFile";
                                xmlValidator.ErrorMessage = "An error has occured while uploading Csv resources from file. " + ex.Message;
                                xmlValidator.Text = "*";
                                xmlValidator.ValidationGroup = "Upload";
                                phUploadFileTypes.Controls.Add(xmlValidator);
                                UploadPopup.Show();
                            }
                        }

                    }
                    else
                    {
                        CustomValidator filetype = new CustomValidator();
                        filetype.IsValid = false;
                        filetype.ControlToValidate = "UploadFile";
                        filetype.ErrorMessage = "The target file '" + fileName + "' does not have a valid file extension.";
                        filetype.Text = "*";
                        filetype.ValidationGroup = "Upload";
                        phUploadFileTypes.Controls.Add(filetype);
                        UploadPopup.Show();
                    }
                }
            }

            else UploadPopup.Show();
        }

        protected void SearchButton_Click(object sender, EventArgs e)
        {
            ResourcesGrid.DataBind();
        }
    }
}