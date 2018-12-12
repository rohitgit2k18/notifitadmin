namespace AbleCommerce.Admin.Products.Assets
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Text.RegularExpressions;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;

    public partial class AssetManager : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private const string ParentFolderText = "<< Parent Folder";
        private const string SafeDirectoryPattern = "[^a-zA-Z0-9\\-_]";

        private string _CurrentPath = string.Empty;
        private string _FullCurrentPath = string.Empty;
        private string _CurrentFileName = string.Empty;
        private string _FullCurrentFileName = string.Empty;
        //THESE SUPPORT THE BROWSE FEATURE
        private string _BrowseImageId = string.Empty;
        private string _BrowseField = string.Empty;
        //SAVES THE LIST OF FILE ITEMS TO PROCESS DELETES
        private List<string> _FileNameList = new List<string>();
        //SAVES THE PATH FROM VIEWSTATE TO PROCESS DELETES
        private string _VSCurrentPath = string.Empty;
        private List<string> _VSFileNameList = new List<string>();

        //STORE IN CUSTOM VIEWSTATE
        protected string CurrentPath
        {
            get { return _CurrentPath; }
            set
            {
                _CurrentPath = value;
                _FullCurrentPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "Assets\\", value);
            }
        }

        protected string FullCurrentPath
        {
            get
            {
                if (string.IsNullOrEmpty(_FullCurrentPath))
                {
                    _FullCurrentPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "Assets\\", this.CurrentPath);
                }
                return _FullCurrentPath;
            }
        }

        //STORE IN CUSTOM VIEWSTATE
        protected string CurrentFileName
        {
            get { return _CurrentFileName; }
            set
            {
                _CurrentFileName = value;
                if (!string.IsNullOrEmpty(value)) _FullCurrentFileName = Path.Combine(this.FullCurrentPath, value);
                else _FullCurrentFileName = string.Empty;
            }
        }

        protected string FullCurrentFileName
        {
            get
            {
                if (string.IsNullOrEmpty(_FullCurrentFileName) && !string.IsNullOrEmpty(this.CurrentFileName))
                    _FullCurrentFileName = Path.Combine(this.FullCurrentPath, this.CurrentFileName);
                return _FullCurrentFileName;
            }
        }

        protected string GetRelativeImagePath()
        {
            if (string.IsNullOrEmpty(CurrentPath))
                return "~/Assets/" + CurrentFileName;
            return "~/Assets/" + CurrentPath.Replace("\\", "/") + "/" + CurrentFileName;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            ScriptManager.GetCurrent(this.Page).EnablePartialRendering = true;
            // EXTRA MEASURE TO PROTECT AGAINST MISCONFIGURED SECURITY POLICY
            if (!AbleContext.Current.User.IsAdmin) AbleCommerce.Code.NavigationHelper.Trigger403(Response, "Admin user rights required.");
            // MAKE SURE THE ASSETS FOLDER EXISTS
            if (!Directory.Exists(FullCurrentPath)) Directory.CreateDirectory(FullCurrentPath);

            LoadCustomViewState();
            BrowseImagePanel.Visible = !string.IsNullOrEmpty(_BrowseImageId);
            BindFileListRepeater(false);
            BindCurrentFile();
            //DETERMINE WHICH RADIO IS SELECTED
            UpdateResizePanels();
            NewFolderButton.OnClientClick = "fnSetFocus('" + NewFolderName.ClientID + "');";

            // PREVENT FIREFOX DOUBLE POSTING, FIREFOX POSTS TWICE WHEN WE ADD CLIENT SIDE MANUAL POSTING
            // SO, ADD IT ONLY FOR BROWSERS OTHER THEN FIREFOX
            if (Request.Browser.Browser != "Firefox") NewFolderOKButton.OnClientClick = String.Format("if(IsValidFileName('" + NewFolderName.ClientID + "'))__doPostBack('{0}','{1}');", NewFolderOKButton.UniqueID, "");
            else NewFolderOKButton.OnClientClick = "if(!IsValidFileName('" + NewFolderName.ClientID + "'))  return false;";

            RenameButton.OnClientClick = "fnSetFocus('" + RenameName.ClientID + "');";
            RenameOKButton.OnClientClick = String.Format("__doPostBack('{0}','{1}')", RenameOKButton.UniqueID, "");
            CopyButton.OnClientClick = "fnSetFocus('" + CopyName.ClientID + "');";
            CopyOKButton.OnClientClick = String.Format("__doPostBack('{0}','{1}')", CopyOKButton.UniqueID, "");
            ValidFiles.Text = AbleContext.Current.Store.Settings.FileExt_Assets;
            if (string.IsNullOrEmpty(ValidFiles.Text)) ValidFiles.Text = "any";
            RenameValidFiles.Text = ValidFiles.Text;
            CopyValidFiles.Text = ValidFiles.Text;

            FileDataMaxSize.Text = String.Format(FileDataMaxSize.Text, AbleContext.Current.Store.Settings.MaxRequestLength);
            AbleCommerce.Code.PageHelper.SetDefaultButton(NewFolderName, NewFolderOKButton);
        }

        private void LoadCustomViewState()
        {
            if (Page.IsPostBack)
            {
                UrlEncodedDictionary customViewState = new UrlEncodedDictionary(EncryptionHelper.DecryptAES(Request.Form[VS_CustomState.UniqueID]));
                this.CurrentPath = customViewState.TryGetValue("CurrentPath");
                this.CurrentFileName = customViewState.TryGetValue("CurrentFileName");
                _BrowseImageId = customViewState.TryGetValue("BrowseImageId");
                _BrowseField = customViewState.TryGetValue("BrowseField");
                //THIS LIST OF NAMES IS USED TO PROCESS DELETES
                string[] fileNames = customViewState.TryGetValue("FileNameList").Split("|".ToCharArray());
                _VSFileNameList.AddRange(fileNames);
            }
            else
            {
                _BrowseImageId = Request.QueryString["ImageId"];
                if (_BrowseImageId == null) _BrowseImageId = string.Empty;
                else _BrowseImageId = _BrowseImageId.ToUpperInvariant();
                _BrowseField = Request.QueryString["Field"];
            }
            //THIS IS TO DOUBLE CHECK PATH WAS NOT MODIFIED BEFORE DELETE IS PROCESSED
            _VSCurrentPath = this.CurrentPath;
        }

        protected void BindFileListRepeater(bool updateAjax)
        {
            List<MyFileItem> fileItems = new List<MyFileItem>();
            if (!string.IsNullOrEmpty(this.CurrentPath))
            {
                //ADD IN THE PARENT DIRECTORY
                fileItems.Add(new MyFileItem(ParentFolderText, FileItemType.Directory));
            }
            //GET DIRECTORIES
            string[] directories = System.IO.Directory.GetDirectories(FullCurrentPath);
            foreach (string dir in directories)
            {
                DirectoryInfo dirInfo = new DirectoryInfo(dir);
                fileItems.Add(new MyFileItem(dirInfo.Name, FileItemType.Directory));
                _FileNameList.Add(dirInfo.Name);
            }
            //GET FILES
            string[] files = System.IO.Directory.GetFiles(FullCurrentPath);
            foreach (string file in files)
            {
                FileInfo fileInfo = new FileInfo(Path.Combine(FullCurrentPath, file));
                if (fileInfo.Exists)
                {
                    FileItemType thisType = FileHelper.IsImageFile(Path.Combine(FullCurrentPath, file)) ? FileItemType.Image : FileItemType.Other;
                    fileItems.Add(new MyFileItem(fileInfo.Name, thisType));
                    _FileNameList.Add(fileInfo.Name);
                }
            }
            FileListRepeater.DataSource = fileItems;
            FileListRepeater.DataBind();
            if (updateAjax) FileListAjax.Update();
            //UPDATE ASSOCIATED PATH CONTROLS
            CurrentFolder.Text = "\\" + CurrentPath.Replace("\\", "<wbr>\\");
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            SaveCustomViewState();
        }

        private void SaveCustomViewState()
        {
            UrlEncodedDictionary customViewState = new UrlEncodedDictionary();
            customViewState["CurrentPath"] = this.CurrentPath;
            customViewState["CurrentFileName"] = this.CurrentFileName;
            customViewState["BrowseImageId"] = _BrowseImageId;
            customViewState["BrowseField"] = _BrowseField;
            //WE WILL PARSE THE FILE NAME LIST WHEN DELETE BUTTON IS CLICKED
            customViewState["FileNameList"] = string.Join("|", _FileNameList.ToArray());
            VS_CustomState.Value = EncryptionHelper.EncryptAES(customViewState.ToString());
        }

        public class MyFileItem
        {
            private string _Name;
            private FileItemType _FileItemType;
            public string Name
            {
                get { return _Name; }
            }
            public FileItemType FileItemType
            {
                get { return _FileItemType; }
            }
            public MyFileItem(string name, FileItemType fileItemType)
            {
                _Name = name;
                _FileItemType = fileItemType;
            }
        }

        public enum FileItemType
        {
            Directory, Image, Other
        }

        protected bool ShowFileIcon(object dataItem, FileItemType iconType)
        {
            FileItemType itemType = ((MyFileItem)dataItem).FileItemType;
            return (itemType == iconType);
        }

        protected void NewFolderOKButton_Click(object sender, EventArgs e)
        {
            string safeFolderName = Regex.Replace(NewFolderName.Text, SafeDirectoryPattern, string.Empty);
            if (!string.IsNullOrEmpty(safeFolderName))
            {
                string newFullCurrentPath = Path.Combine(FullCurrentPath, safeFolderName);
                if (!Directory.Exists(newFullCurrentPath))
                {
                    Directory.CreateDirectory(newFullCurrentPath);
                    if (safeFolderName != NewFolderName.Text)
                    {
                        SuccessMessage.Text = "Folder created, invalid characters removed from name.";
                        SuccessMessage.Visible = true;
                    }
                    else
                    {
                        SuccessMessage.Text = "Folder created Successfully.";
                        SuccessMessage.Visible = true;
                    }
                }
                else
                {
                    ErrorMessage2.Text = "<br/>Folder not created, another folder with same name already exists.";
                    ErrorMessage2.Visible = true;
                }
            }
            else
            {
                ErrorMessage2.Visible = true;
            }

            NewFolderName.Text = string.Empty;
            BindFileListRepeater(true);
        }

        private string FormatSize(long bytes)
        {
            if (bytes < 1000) return string.Format("{0} bytes", bytes);
            int kb = (int)Math.Round((double)(bytes / 1000), 0);
            if (kb < 1000) return string.Format("{0}kb", kb);
            int mb = (int)Math.Round((double)(kb / 1000), 0);
            return string.Format("{0}mb", mb);
        }

        protected string GetParentPath()
        {
            if (string.IsNullOrEmpty(this.CurrentPath)) return string.Empty;
            //FIND THE LAST INSTANCE OF \
            int lastIndex = CurrentPath.LastIndexOf("\\");
            if (lastIndex < 0) return string.Empty;
            return CurrentPath.Substring(0, lastIndex);
        }

        protected void FileListRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Directory":
                    if (e.CommandArgument.Equals(ParentFolderText))
                    {
                        CurrentPath = GetParentPath();
                    }
                    else
                    {
                        string safeFolderName = Regex.Replace(e.CommandArgument.ToString(), SafeDirectoryPattern, string.Empty);
                        string newFullCurrentPath = Path.Combine(FullCurrentPath, safeFolderName);
                        if (Directory.Exists(newFullCurrentPath))
                            CurrentPath = Path.Combine(CurrentPath, safeFolderName);
                    }
                    BindFileListRepeater(true);
                    this.CurrentFileName = string.Empty;
                    BindCurrentFile();
                    break;
                case "Image":
                case "Other":
                    this.CurrentFileName = e.CommandArgument.ToString();
                    this.BindCurrentFile();
                    break;
            }
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (UploadedFile.HasFile)
                {
                    string safeFileName = FileHelper.GetSafeBaseImageName(BaseFileName.Text, true);
                    if (string.IsNullOrEmpty(safeFileName))
                        safeFileName = FileHelper.GetSafeBaseImageName(UploadedFile.FileName, true);
                    if (!string.IsNullOrEmpty(safeFileName))
                    {
                        if (FileHelper.IsExtensionValid(safeFileName, AbleContext.Current.Store.Settings.FileExt_Assets))
                        {
                            string safeFilePath = Path.Combine(FullCurrentPath, safeFileName);
                            if (!NoResize.Checked)
                            {
                                //RESIZE MAY BE REQUIRED IF THIS IS AN IMAGE FILE
                                //SAVE TO TEMPORARY PATH TO PERFORM RESIZE
                                string tempImagePath = Path.Combine(FullCurrentPath, Guid.NewGuid().ToString("N") + ".tmp");
                                try
                                {
                                    UploadedFile.SaveAs(tempImagePath);
                                }
                                catch (UnauthorizedAccessException ex)
                                {
                                    Logger.Warn("Exception while saving uploaded file: " + tempImagePath, ex);
                                    ErrorMessage.Text = "Unable to upload, access to the path '" + tempImagePath + "' is denied.";
                                    ErrorMessage.Visible = true;
                                    return;
                                }
                                //CHECK IF THIS IS AN IMAGE FILE
                                if (FileHelper.IsImageFile(tempImagePath))
                                {
                                    string extension = Path.GetExtension(safeFileName);
                                    if (StandardResize.Checked)
                                    {
                                        //USE STANDARD IMAGE SIZES
                                        using (System.Drawing.Image originalImage = System.Drawing.Image.FromFile(tempImagePath))
                                        {
                                            //GET SETTINGS FOR IMAGE SIZES
                                            StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                                            bool aspect = StandardMaintainAspectRatio.Checked;
                                            int quality = AlwaysConvert.ToInt(StandardJpgQuality.Text);
                                            //GENERATE ICON
                                            if (ResizeIcon.Checked)
                                                FileHelper.WriteImageFile(originalImage, Path.Combine(this.FullCurrentPath, safeFileName.Replace(extension, "_i" + extension)), settings.IconImageWidth, settings.IconImageHeight, aspect, 100);
                                            //GENERATE THUMBNAIL
                                            if (ResizeThumbnail.Checked)
                                                FileHelper.WriteImageFile(originalImage, Path.Combine(this.FullCurrentPath, safeFileName.Replace(extension, "_t" + extension)), settings.ThumbnailImageWidth, settings.ThumbnailImageHeight, aspect, quality);
                                            //GENERATE STANDARD IMAGE
                                            if (ResizeStandard.Checked)
                                                FileHelper.WriteImageFile(originalImage, Path.Combine(this.FullCurrentPath, safeFileName), settings.StandardImageWidth, settings.StandardImageHeight, aspect, quality);
                                            originalImage.Dispose();
                                        }
                                    }
                                    else
                                    {
                                        //CUSTOM RESIZE
                                        using (System.Drawing.Image originalImage = System.Drawing.Image.FromFile(tempImagePath))
                                        {
                                            bool aspect = CustomMaintainAspectRatio.Checked;
                                            int quality = AlwaysConvert.ToInt(CustomJpgQuality.Text);
                                            FileHelper.WriteImageFile(originalImage, safeFilePath, AlwaysConvert.ToInt(CustomUploadWidth.Text), AlwaysConvert.ToInt(CustomUploadHeight.Text), aspect, quality);
                                            originalImage.Dispose();
                                        }
                                    }
                                    //NOW REMOVE THE TEMPORARY FILE
                                    try
                                    {
                                        File.Delete(tempImagePath);
                                    }
                                    catch (Exception ex)
                                    {
                                        Logger.Warn("Could not delete temporary image file " + tempImagePath, ex);
                                    }
                                }
                                else
                                {
                                    //NOT AN IMAGE FILE, SO MOVE TO DESTINATION
                                    if (File.Exists(safeFilePath)) File.Delete(safeFilePath);
                                    File.Move(tempImagePath, safeFilePath);
                                }
                            }
                            else
                            {
                                try
                                {
                                    //NO RESIZING, JUST SAVE THE FILE
                                    UploadedFile.SaveAs(safeFilePath);
                                }
                                catch (UnauthorizedAccessException ex)
                                {
                                    Logger.Warn("Exception while saving uploaded file: " + safeFilePath, ex);
                                    ErrorMessage.Text = "Unable to upload, access to the path '" + safeFilePath + "' is denied.";
                                    ErrorMessage.Visible = true;
                                    return;
                                }
                            }
                            BindFileListRepeater(true);
                            this.CurrentFileName = safeFileName;
                            BaseFileName.Text = string.Empty;
                            BindCurrentFile();
                        }
                        else
                        {
                            CustomValidator filetype = new CustomValidator();
                            filetype.IsValid = false;
                            filetype.ControlToValidate = "BaseFileName";
                            filetype.ErrorMessage = "The target file '" + safeFileName + "' does not have a valid file extension.";
                            filetype.Text = "*";
                            phValidFiles.Controls.Add(filetype);
                        }
                    }
                }
            }
        }

        protected void UpdateResizePanels()
        {
            StandardResize.Checked = (Request.Form[StandardResize.UniqueID.Replace("$Standard", "$")] == "StandardResize");
            CustomResize.Checked = (Request.Form[CustomResize.UniqueID.Replace("$Custom", "$")] == "CustomResize");
            NoResize.Checked = (!(StandardResize.Checked || CustomResize.Checked));
            StandardResizePanel.Visible = StandardResize.Checked;
            if (StandardResizePanel.Visible)
            {
                StoreSettingsManager settings = AbleContext.Current.Store.Settings;
                ResizeIcon.Text = string.Format(ResizeIcon.Text, settings.IconImageWidth, settings.IconImageHeight);
                ResizeThumbnail.Text = string.Format(ResizeThumbnail.Text, settings.ThumbnailImageWidth, settings.ThumbnailImageHeight);
                ResizeStandard.Text = string.Format(ResizeStandard.Text, settings.StandardImageWidth, settings.StandardImageHeight);
            }
            CustomResizePanel.Visible = CustomResize.Checked;
        }

        private void ShowPickImage()
        {
            SelectImageButton.Visible = true;
            SelectImageButton.OnClientClick = "top.window.opener.document.forms[0]." + _BrowseField + ".value = '" + GetRelativeImagePath() + "'; window.close();";
        }

        protected void BindCurrentFile()
        {
            //HIDE FILE DETAILS BY DEFAULT
            FileDetails.Visible = false;
            //DETERMINE IF WE HAVE DETAILS TO DISPLAY
            if (!string.IsNullOrEmpty(this.CurrentFileName))
            {
                //UPDATE IMAGE PANELS
                FileInfo fileInfo = new FileInfo(this.FullCurrentFileName);
                if (fileInfo.Exists)
                {
                    FileDetails.Visible = true;
                    FileName.Text = fileInfo.Name;
                    FileSize.Text = FormatSize(fileInfo.Length);
                    System.Drawing.Image thisImage = null;
                    try
                    {
                        thisImage = System.Drawing.Image.FromFile(fileInfo.FullName);
                        ImagePreview.ImageUrl = "~/Assets/" + CurrentPath.Replace("\\", "/") + "/" + this.CurrentFileName + "?ts=" + DateTime.Now.ToString("hhmmss");
                        ImagePreview.Visible = true;
                        Dimensions.Visible = true;
                        Dimensions.Text = string.Format("({0}w X {1}h)", thisImage.Width, thisImage.Height);
                        ShowPickImage();
                    }
                    catch
                    {
                        ImagePreview.Visible = false;
                        Dimensions.Visible = false;
                    }
                    finally
                    {
                        if (thisImage != null)
                        {
                            thisImage.Dispose();
                            thisImage = null;
                        }
                    }
                }
            }
            NoFileSelectedPanel.Visible = !FileDetails.Visible;
            FileDetailsAjax.Update();
        }

        protected void RenameOKButton_Click(object sender, EventArgs e)
        {
            string targetFileName = FileHelper.GetSafeBaseImageName(RenameName.Text, true);
            if (!string.IsNullOrEmpty(targetFileName) && FileHelper.IsExtensionValid(targetFileName, AbleContext.Current.Store.Settings.FileExt_Themes))
            {
                string fullTargetFileName = Path.Combine(this.FullCurrentPath, targetFileName);
                if (fullTargetFileName != this.FullCurrentFileName)
                {
                    if (!File.Exists(fullTargetFileName))
                    {
                        File.Move(this.FullCurrentFileName, fullTargetFileName);
                        this.CurrentFileName = targetFileName;
                        BindCurrentFile();
                        BindFileListRepeater(true);
                    }
                    else
                    {
                        FileErrorMessage.Text = "Target file already exists.";
                        FileErrorMessage.Visible = true;
                    }
                }
                else
                {
                    FileErrorMessage.Text = "Souce and target file names are same.";
                    FileErrorMessage.Visible = true;
                }
            }
            else
            {
                FileErrorMessage.Text = "File name is missing or invalid.";
                FileErrorMessage.Visible = true;
                CustomValidator filetype = new CustomValidator();
                filetype.IsValid = false;
                filetype.ControlToValidate = "RenameName";
                filetype.ErrorMessage = "'" + targetFileName + "' is not a valid file name.";
                filetype.Text = "*";
                filetype.ValidationGroup = "Rename";
                phRenameValidFiles.Controls.Add(filetype);
                RenamePopup.Show();
            }
            RenameName.Text = string.Empty;
        }

        protected void CopyOKButton_Click(object sender, EventArgs e)
        {
            string targetFileName = FileHelper.GetSafeBaseImageName(CopyName.Text, true);
            if (!string.IsNullOrEmpty(targetFileName) && FileHelper.IsExtensionValid(targetFileName, AbleContext.Current.Store.Settings.FileExt_Themes))
            {
                string fullTargetFileName = Path.Combine(this.FullCurrentPath, targetFileName);
                if (fullTargetFileName != this.FullCurrentFileName)
                {
                    if (!File.Exists(fullTargetFileName))
                    {
                        File.Copy(this.FullCurrentFileName, fullTargetFileName);
                        this.CurrentFileName = targetFileName;
                        BindCurrentFile();
                        BindFileListRepeater(true);
                    }
                    else
                    {
                        FileErrorMessage.Text = "Target file already exists.";
                        FileErrorMessage.Visible = true;
                    }
                }
                else
                {
                    FileErrorMessage.Text = "Source and target file names are same.";
                    FileErrorMessage.Visible = true;
                }
            }
            else
            {
                CustomValidator filetype = new CustomValidator();
                filetype.IsValid = false;
                filetype.ControlToValidate = "CopyName";
                filetype.ErrorMessage = "'" + targetFileName + "' is not a valid file name.";
                filetype.Text = "*";
                filetype.ValidationGroup = "Copy";
                phCopyValidFiles.Controls.Add(filetype);
                CopyPopup.Show();
            }
            CopyName.Text = string.Empty;
        }

        protected void DeleteSelectedButton_Click(object sender, EventArgs e)
        {
            string selectedItems = Request.Form["selected"];
            if (!string.IsNullOrEmpty(selectedItems))
            {
                //VERIFY THE CURRENT PATH IS THE SAME AS IT WAS AT VIEWSTATE LOAD TIME
                if (_VSCurrentPath == this.CurrentPath)
                {
                    //GET THE NAMES OF THE ITEMS TO DELETE
                    string[] deleteNames = selectedItems.Split(",".ToCharArray());
                    foreach (string deleteName in deleteNames)
                    {
                        //MAKE SURE THE DELETE NAME APPEARED IN THE ORIGINAL LIST
                        if (_VSFileNameList.IndexOf(deleteName) > -1)
                        {
                            //OK TO DELETE
                            string fullDeletePath = Path.Combine(this.FullCurrentPath, deleteName);
                            try
                            {
                                if (Directory.Exists(fullDeletePath))
                                    //TRY TO DELETE CATEGORY
                                    Directory.Delete(fullDeletePath, true);
                                else if (File.Exists(fullDeletePath))
                                    //TRY TO DELETE FILE
                                    File.Delete(fullDeletePath);
                            }
                            catch { }
                        }
                    }
                    //REBIND THE PAGE
                    BindFileListRepeater(true);
                    this.CurrentFileName = string.Empty;
                    BindCurrentFile();
                }
            }
        }

        protected void CustomMaintainAspectRatio_CheckedChanged(Object sender, EventArgs e)
        {
            CustomUploadWidthRequired.Enabled = !CustomMaintainAspectRatio.Checked;
            CustomUploadHeightRequired.Enabled = !CustomMaintainAspectRatio.Checked;
            MaintainAspectRatioValidator.Enabled = CustomMaintainAspectRatio.Checked;
        }

        protected void MaintainAspectRatioValidator_ServerValidate(Object sender, ServerValidateEventArgs e)
        {
            if (CustomResize.Checked)
            {
                e.IsValid = !string.IsNullOrEmpty(CustomUploadWidth.Text) || !string.IsNullOrEmpty(CustomUploadHeight.Text);
            }
            MaintainAspectRatioValidator.Enabled = CustomResize.Checked;
        }
    }
}