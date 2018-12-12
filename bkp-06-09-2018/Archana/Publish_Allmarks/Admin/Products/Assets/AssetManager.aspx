<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Products.Assets.AssetManager" Title="Asset Manager" EnableViewState="false" CodeFile="AssetManager.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">    
    var clientid;
    function fnSetFocus(txtClientId) { clientid=txtClientId; setTimeout("fnFocus()",500); }
    function fnFocus() { eval("document.getElementById('"+clientid+"').focus()"); }
    
    function IsValidFileName(fldId)
    {
        var fldValue = document.getElementById(fldId).value;
        // TRIM THE VALUE
        fldValue = fldValue.replace(/^\s*/, "").replace(/\s*$/, "");
        document.getElementById(fldId).value = fldValue;
        if(fldValue == ""){
            return false;
        }
        return true;
    }
    
    var lastName = "";
    function setName()
    {
        var filePath = document.getElementById("<%= UploadedFile.ClientID %>").value;
        if (filePath.length > 0) {
	        var fileName;
	        var charIndex = filePath.lastIndexOf("\\");
	        if (charIndex < 0) {
		        charIndex = filePath.lastIndexOf("/");
		        if (charIndex < 0) {
			        fileName = filePath;
		        } else {
			        fileName = filePath.substring(charIndex+1);
		        }
	        } else {
		        fileName = filePath.substring(charIndex+1);
	        }
	        //SET DISPLAY NAME
	        var ctlName = document.getElementById("<%= BaseFileName.ClientID %>");
	        if ((ctlName.value.length == 0) || (ctlName.value == lastName)) {
	            fileName = fileName.replace(/ /g, "_");
    	        ctlName.value = fileName;
    	        lastName = fileName;
    	    }
        }
    }
    
    function FilesChecked()
    {
        var count = 0;
        for(i = 0; i< document.forms[0].elements.length; i++){
            var e = document.forms[0].elements[i];
            var name = e.name;
            if ((e.type == 'checkbox') && (name == 'selected') && (e.checked))
            {
                count ++;
            }
        }
        return (count > 0);
    }
</script>
<div class="pageHeader">
	<div class="caption">
		<h1><asp:Localize ID="Caption" runat="server" Text="Image and Asset Manager"></asp:Localize></h1>
        <div class="links">
            <cb:NavigationLink ID="ImagesLink" runat="server" Text="Images and Assets" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
            <cb:NavigationLink ID="ProductTemplates" runat="server" Text="Product Templates" SkinID="Button" NavigateUrl="../ProductTemplates/Default.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="GiftWrap" runat="server" Text="Gift Wrap" SkinID="Button" NavigateUrl="../GiftWrap/Default.aspx"></cb:NavigationLink>
        </div>
	</div>
</div>

<div class="grid_4 alpha">
    <div class="leftColumn">
        <div class="section">
            <div class="header">
                <h2 class="browse">
                    <asp:Localize ID="BrowseCaption" runat="server" Text="Folder Contents"></asp:Localize>
                </h2>
            </div>
            <asp:UpdatePanel ID="FileListAjax" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="NewFolderOKButton" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="DeleteSelectedButton" EventName="Click" />
                </Triggers>
                <ContentTemplate>
                    <div class="content">
                        <div style="max-height:300px;overflow:auto;">
                            <table>
                                <asp:Repeater ID="FileListRepeater" runat="server" OnItemCommand="FileListRepeater_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td width="10px">
                                                <asp:PlaceHolder ID="selectBox" runat="server" Visible='<%# (Container.ItemIndex > 0) || (string.IsNullOrEmpty(this.CurrentPath)) %>'>
                                                    <input type="checkbox" name="selected" value='<%#Eval("Name")%>' />
                                                </asp:PlaceHolder>
                                            </td>
                                            <td>
		                                        <asp:Image ID="DirectoryIcon" runat="server" Visible='<%#ShowFileIcon(Container.DataItem, FileItemType.Directory)%>' SkinID="CategoryIcon" />
		                                        <asp:Image ID="ImageIcon" runat="server" Visible='<%#ShowFileIcon(Container.DataItem, FileItemType.Image)%>' SkinID="ImageIcon" />
		                                        <asp:Image ID="FileIcon" runat="server" Visible='<%#ShowFileIcon(Container.DataItem, FileItemType.Other)%>' SkinID="WebpageIcon" />
                                            </td>
                                            <td>
		                                        <asp:LinkButton ID="FileItem" runat="server" Text='<%#Eval("Name")%>' CommandName='<%#Eval("FileItemType")%>' CommandArgument='<%#Eval("Name")%>'></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                        <asp:Button ID="NewFolderButton" runat="server" Text="New Folder" />
                        <asp:Button ID="DeleteSelectedButton" runat="server" Text="Delete Selected" OnClick="DeleteSelectedButton_Click" OnClientClick="if(FilesChecked()){return  confirm('Are you sure you want to delete the selected items?');} else {alert ('Please select at least one folder or file.'); return false;}" />
                        <cb:Notification ID="ErrorMessage2" runat="server" EnableViewState="false" Visible="false" SkinID="errorCondition" Text="Invalid name, folder not created."></cb:Notification>
                        <cb:Notification ID="SuccessMessage" runat="server" EnableViewState="false" Visible="false" SkinID="GoodCondition" Text="Folder created."></cb:Notification>
	                </div>
                    <asp:Panel ID="NewFolderDialog" runat="server" Style="display: none" CssClass="modalPopup">
                        <asp:Panel ID="NewFolderDialogHeader" runat="server" CssClass="modalPopupHeader">
                            Add Folder
                        </asp:Panel>
                        <div align="center">
                            <br />
	                        <asp:Label ID="NewFolderNameLabel" runat="server" Text="Name: " AssociatedControlID="NewFolderName" SkinID="FieldHeader"></asp:Label>
	                        <asp:TextBox ID="NewFolderName" runat="server" MaxLength="100" ValidationGroup="NewFolderName"></asp:TextBox>
	                        <asp:Button ID="NewFolderOKButton" runat="server" Text="OK" OnClick="NewFolderOKButton_Click" ValidationGroup="NewFolderName" />
	                        <asp:Button ID="NewFolderCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" /><br />
	                        <asp:RequiredFieldValidator ID="FolderNameValidator" runat="server" Text="Please specify valid folder name." ErrorMessage="Please specify folder name." ValidationGroup="NewFolderName" ControlToValidate="NewFolderName" EnableViewState="false"></asp:RequiredFieldValidator>
	                        <br />
                        </div>
                    </asp:Panel>
                    <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender" runat="server" 
                        TargetControlID="NewFolderButton"
                        PopupControlID="NewFolderDialog" 
                        BackgroundCssClass="modalBackground" 
                        CancelControlID="NewFolderCancelButton" 
                        DropShadow="true"
                        PopupDragHandleControlID="NewFolderDialogHeader" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="section">
            <div class="header">
                <h2>Upload New File</h2>
            </div>
            <div class="content">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <asp:Label ID="ValidFilesLabel" runat="server" Text="Valid Files:" EnableViewState="false"></asp:Label>
                        </th>
                        <td>
                            <asp:Literal ID="ValidFiles" runat="server" EnableViewState="false"></asp:Literal>
                            <asp:PlaceHolder ID="phValidFiles" runat="server"></asp:PlaceHolder><br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:FileUpload ID="UploadedFile" runat="server" OnBlur="setName()" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="BaseFileNameLabel" runat="server" Text="Save as:" AssociatedControlID="BaseFileName"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="BaseFileName" runat="server" MaxLength="100"></asp:TextBox>                
                            <asp:RegularExpressionValidator ID="FileNameValidator" runat="server" ControlToValidate="BaseFileName"
                                    ErrorMessage="Invalid save as name. A valid name can only contain Uppercase (A - Z), Lowercase (a - z), Numbers (0 - 9), and Symbols (underscore, minus). It may not contain path information." ValidationExpression="^[A-Za-z0-9_\- ]+(\.[A-Za-z0-9_]+)*$">*</asp:RegularExpressionValidator><br />
                        </td>
                    </tr>
                </table>
                <asp:UpdatePanel ID="ResizeAjax" runat="server">
                    <ContentTemplate>
                        <fieldset style="border: 0; padding:2px;">
                            <legend style="border: 0;">Image Options -</legend>
                            <asp:RadioButton ID="NoResize" runat="server" GroupName="Resize" Text="Do not resize" AutoPostBack="true" /><br />
                            <asp:RadioButton ID="StandardResize" runat="server" GroupName="Resize" Text="Standard image sizes" AutoPostBack="true" Checked="true" /><br />
                            <asp:PlaceHolder ID="StandardResizePanel" runat="server" EnableViewState="false">
                                <div style="padding-left:25px;">
                                    <asp:CheckBox ID="ResizeIcon" runat="server" Text="Icon ({0}w X {1}h)" Checked="true" /><br />
                                    <asp:CheckBox ID="ResizeThumbnail" runat="server" Text="Thumbnail ({0}w X {1}h)" Checked="true" /><br />
                                    <asp:CheckBox ID="ResizeStandard" runat="server" Text="Standard ({0}w X {1}h)" Checked="true" /><br />
                                    <asp:CheckBox ID="StandardMaintainAspectRatio" runat="server" Text="Maintain Aspect Ratio" Checked="true" /><br />
                                    <asp:Label ID="StandardJpgQualityLabel" runat="server" Text="Quality: " EnableViewState="false" AssociatedControlID="StandardJpgQuality"></asp:Label>
                                    <asp:TextBox ID="StandardJpgQuality" runat="server" Width="30px" Text="100" EnableViewState="false"></asp:TextBox>
                                    <asp:RangeValidator ID="StandardJpgQualityValidator" runat="server" Type="integer" MinimumValue="0" MaximumValue="100" Text="*" ErrorMessage="Please enter a valid value (from 0 to 100) for quality." ControlToValidate="StandardJpgQuality"></asp:RangeValidator>
                                    <asp:Label ID="StandardJpgQualityHelpText" runat="server" Text="% (jpg only)" EnableViewState="false"></asp:Label>
                                </div>
                            </asp:PlaceHolder>
                            <asp:RadioButton ID="CustomResize" runat="server" GroupName="Resize" Text="Custom size" AutoPostBack="true" />
                            <asp:CustomValidator ID="MaintainAspectRatioValidator" runat="server" Text="*" ErrorMessage="You need to provide at least one of width or height with a valid value (from 1 to 1200)." Enabled="true" OnServerValidate="MaintainAspectRatioValidator_ServerValidate"></asp:CustomValidator>
                            <br />
                            <asp:PlaceHolder ID="CustomResizePanel" runat="server" Visible="false">
                                <div style="padding-left:25px;">
                                    <asp:TextBox ID="CustomUploadWidth" runat="server" Columns="1" MaxLength="4">&nbsp;</asp:TextBox>
                                    <asp:RequiredFieldValidator ID="CustomUploadWidthRequired" runat="server" Type="integer" Text="*" ErrorMessage="Please enter a valid value (from 1 to 1200) for width." ControlToValidate="CustomUploadWidth" Enabled="false" />
                                    <asp:RangeValidator ID="CustomUploadWidthValidator1" runat="server" Type="integer" MinimumValue="1" MaximumValue="1200" Text="*" ErrorMessage="Please enter a valid value (from 1 to 1200) for width." ControlToValidate="CustomUploadWidth" ></asp:RangeValidator>&nbsp;w&nbsp;&nbsp;
                                    <asp:TextBox ID="CustomUploadHeight" runat="server" Columns="1" MaxLength="4">&nbsp;</asp:TextBox>
                                    <asp:RequiredFieldValidator ID="CustomUploadHeightRequired" runat="server" Type="integer" Text="*" ErrorMessage="Please enter a valid value (from 1 to 1200) for height." ControlToValidate="CustomUploadHeight" Enabled="false" />
                                    <asp:RangeValidator ID="CustomUploadHeightValidator" runat="server" Type="integer" MinimumValue="1" MaximumValue="1200" Text="*" ErrorMessage="Please enter a valid value (from 1 to 1200) for height." ControlToValidate="CustomUploadHeight"></asp:RangeValidator>&nbsp;h<br />
                                    <asp:CheckBox ID="CustomMaintainAspectRatio" runat="server" Text="Maintain Aspect Ratio" Checked="true" AutoPostBack="true" OnCheckedChanged="CustomMaintainAspectRatio_CheckedChanged" /><br />
                                    <asp:Label ID="CustomJpgQualityLabel" runat="server" Text="Quality: " EnableViewState="false" AssociatedControlID="CustomJpgQuality"></asp:Label>
                                    <asp:TextBox ID="CustomJpgQuality" runat="server" Width="30px" Text="100" EnableViewState="false" MaxLength="3"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="CustomJpgQualityRequired" runat="server" Type="integer" Text="*" ErrorMessage="Please enter a valid value (from 0 to 100) for quality." ControlToValidate="CustomJpgQuality" />
                                    <asp:RangeValidator ID="CustomJpgQualityValidator" runat="server" Type="integer" MinimumValue="0" MaximumValue="100" Text="*" ErrorMessage="Please enter a valid value (from 0 to 100) for quality." ControlToValidate="CustomJpgQuality"></asp:RangeValidator>
                                    <asp:Label ID="CustomJpgQualityHelpText" runat="server" Text="% (jpg only)" EnableViewState="false"></asp:Label>
                                </div>
                            </asp:PlaceHolder>
                        </fieldset>
                    </ContentTemplate>
                </asp:UpdatePanel>           
                <asp:Button ID="UploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click" />
                <asp:Localize ID="FileDataMaxSize" runat="server" Text="(max file size: {0}KB)" EnableViewState="false"></asp:Localize>
                <cb:Notification ID="ErrorMessage" runat="server" Visible="false" EnableViewState="false" SkinID="ErrorCondition"></cb:Notification>
            </div>
        </div>
    </div>
</div>
<div class="grid_8 omega">
    <div class="rightColumn">
        <asp:UpdatePanel ID="HeaderAjax" runat="server" UpdateMode="Always">
            <ContentTemplate>
                <asp:Panel ID="BrowseImagePanel" runat="server" CssClass="searchPanel">
	                <asp:Label ID="BrowseImageCaption" runat="server" Text="Select a file from Folder Contents."></asp:Label>
                    <asp:Button ID="SelectImageButton" runat="server" Text="Use Current Image" Visible="false" />
	                <asp:Button ID="CancelBrowseButton" runat="server" Text="Back" OnClientClick="window.close();return false;" />
                </asp:Panel>
                <div class="section">
                    <div class="header">
                        <h2>File Location</h2>
                    </div>
                    <div class="content" style="overflow:auto;">
                        <asp:Label ID="CurrentFolderLabel" runat="server" Text="Current Folder:" SkinID="FieldHeader"></asp:Label>
                        <asp:Localize ID="CurrentFolder" runat="server" Text="\"></asp:Localize>
                        <asp:HiddenField ID="VS_CustomState" runat="server" EnableViewState="false" />
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div class="section">
            <div class="header">
                <h2>File Details</h2>
            </div>
            <div class="content">
                <asp:UpdatePanel ID="FileDetailsAjax" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <cb:Notification ID="FileErrorMessage" runat="server" Visible="false" SkinID="ErrorCondition"></cb:Notification>
                        <asp:PlaceHolder runat="server" ID="NoFileSelectedPanel" Visible="false">
                            <p><asp:Localize ID="NoFileSelectedMessage" runat="server" Text="Select a file from the Folder Content's list to preview it here."></asp:Localize></p>
                        </asp:PlaceHolder>
                        <asp:Panel runat="server" ID="FileDetails" Visible="false">
                            <asp:Label ID="FileName" runat="server" SkinID="FieldHeader"></asp:Label> <asp:Label ID="Dimensions" runat="server"></asp:Label> <asp:Literal ID="FileSize" runat="server"></asp:Literal>
                            <asp:Button ID="CopyButton" runat="server" Text="Copy" />
                            <asp:Button ID="RenameButton" runat="server" Text="Rename" />
                            <div style="max-height:500px;overflow:auto;">
                                <asp:Image ID="ImagePreview" CssClass="image_view" runat="server" />
                            </div>
                            <asp:Panel ID="RenameDialog" runat="server" Style="display: none" CssClass="modalPopup">
                                <asp:Panel ID="RenameDialogHeader" runat="server" CssClass="modalPopupHeader">
                                    Rename File
                                </asp:Panel>
                                <div style="margin:6px">
                                    <asp:ValidationSummary ID="RenameValidationSummary" runat="server" ValidationGroup="Rename" />
                                    <asp:Label ID="RenameValidFilesLabel" runat="server" Text="Valid Extensions:" SkinID="fieldHeader" EnableViewState="false"></asp:Label>
                                    <asp:Literal ID="RenameValidFiles" runat="server" EnableViewState="false"></asp:Literal>
                                    <asp:PlaceHolder ID="phRenameValidFiles" runat="server"></asp:PlaceHolder><br /><br />
                                    <asp:Label ID="RenameNameLabel" runat="server" Text="Rename To: " AssociatedControlID="RenameName" SkinID="FieldHeader"></asp:Label>
                                    <asp:TextBox ID="RenameName" runat="server" MaxLength="100"></asp:TextBox>
                                    <asp:Button ID="RenameOKButton" runat="server" Text="OK" OnClick="RenameOKButton_Click" />
                                    <asp:Button ID="RenameCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" /><br /><br />
                                </div>
                            </asp:Panel>
                            <ajaxToolkit:ModalPopupExtender ID="RenamePopup" runat="server" 
                                TargetControlID="RenameButton"
                                PopupControlID="RenameDialog" 
                                BackgroundCssClass="modalBackground" 
                                OkControlID="RenameOKButton"
                                CancelControlID="RenameCancelButton" 
                                DropShadow="true"
                                PopupDragHandleControlID="RenameDialogHeader" />
                            <asp:Panel ID="CopyDialog" runat="server" Style="display: none" CssClass="modalPopup">
                                <asp:Panel ID="CopyDialogHeader" runat="server" CssClass="modalPopupHeader">
                                    Copy File
                                </asp:Panel>
                                <div style="margin:6px">
                                    <asp:ValidationSummary ID="CopyValidationSummary" runat="server" ValidationGroup="Copy" />
                                    <asp:Label ID="CopyValidFilesLabel" runat="server" Text="Valid Extensions:" SkinID="fieldHeader" EnableViewState="false"></asp:Label>
                                    <asp:Literal ID="CopyValidFiles" runat="server" EnableViewState="false"></asp:Literal>
                                    <asp:PlaceHolder ID="phCopyValidFiles" runat="server"></asp:PlaceHolder><br /><br />
                                    <asp:Label ID="CopyNameLabel" runat="server" Text="Copy To: " AssociatedControlID="CopyName" SkinID="FieldHeader"></asp:Label>
                                    <asp:TextBox ID="CopyName" runat="server" MaxLength="100"></asp:TextBox>
                                    <asp:Button ID="CopyOKButton" runat="server" Text="OK" OnClick="CopyOKButton_Click" />
                                    <asp:Button ID="CopyCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" /><br /><br />
                                </div>
                            </asp:Panel>
                            <ajaxToolkit:ModalPopupExtender ID="CopyPopup" runat="server" 
                                TargetControlID="CopyButton"
                                PopupControlID="CopyDialog" 
                                BackgroundCssClass="modalBackground" 
                                OkControlID="CopyOKButton"
                                CancelControlID="CopyCancelButton" 
                                DropShadow="true"
                                PopupDragHandleControlID="CopyDialogHeader" />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</div>
</asp:Content>