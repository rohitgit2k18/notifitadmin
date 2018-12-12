<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Website._FileManager" Title="Themes File Manager" EnableViewState="false" CodeFile="FileManager.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="javascript" type="text/javascript">
        var clientid;
        function fnSetFocus(txtClientId) { clientid = txtClientId; setTimeout("fnFocus()", 500); }
        function fnFocus() { eval("document.getElementById('" + clientid + "').focus()"); }

        function IsValidFileName(fldId) {
            var fldValue = document.getElementById(fldId).value;
            // TRIM THE VALUE
            fldValue = fldValue.replace(/^\s*/, "").replace(/\s*$/, "");
            document.getElementById(fldId).value = fldValue;
            if (fldValue == "") {
                return false;
            }
            return true;
        }

        function FilesChecked() {
            var count = 0;
            for (i = 0; i < document.forms[0].elements.length; i++) {
                var e = document.forms[0].elements[i];
                var name = e.name;
                if ((e.type == 'checkbox') && (name.indexOf('selected') == (name.length - 8)) && (e.checked)) {
                    count++;
                }
            }
            return (count > 0);
        }
    </script>
    <div class="pageHeader">
	    <div class="caption">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Manage Files for Theme '{0}'"></asp:Localize></h1>
	    </div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="HeaderAjax" runat="server" UpdateMode="Always">
            <ContentTemplate>
                <asp:Label ID="CurrentFolderLabel" runat="server" Text="Current Folder:" SkinID="FieldHeader"></asp:Label>
                <asp:Localize ID="CurrentFolder" runat="server" Text=""></asp:Localize>
                <asp:HiddenField ID="VS_CustomState" runat="server" EnableViewState="false" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="grid_4 alpha">
        <div class="leftColumn">
            <asp:UpdatePanel ID="FileListAjax" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="NewFolderOKButton" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="DeleteSelectedButton" EventName="Click" />
                    <asp:PostBackTrigger ControlID="UploadButton" />
                </Triggers>
                <ContentTemplate>
                    <div class="section">
                        <div class="header">
                            <h2 class="browse">
                                <asp:Localize ID="BrowseCaption" runat="server" Text="Folder Contents"></asp:Localize>
                            </h2>
                        </div>
                        <div style="overflow:auto;height:300px;" class="content">
                            <table width="100%">
                                <asp:Repeater ID="FileListRepeater" runat="server" OnItemCommand="FileListRepeater_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td width="10px">
                                                <input type="checkbox" name="selected" value='<%#Eval("Name")%>'<%# IsDeleteDisabled(Container) %> />
                                            </td>
                                            <td width="30px" align="center">
		                                        <asp:Image ID="DirectoryIcon" runat="server" Visible='<%#ShowFileIcon(Container.DataItem, FileItemType.Directory)%>' SkinID="CategoryIcon" />
		                                        <asp:Image ID="ImageIcon" runat="server" Visible='<%#ShowFileIcon(Container.DataItem, FileItemType.Image)%>' SkinID="ImageIcon" />
		                                        <asp:Image ID="FileIcon" runat="server" Visible='<%#ShowFileIcon(Container.DataItem, FileItemType.Other)%>' SkinID="WebpageIcon" />
                                            </td>
                                            <td>
		                                        <asp:LinkButton ID="FileItem" runat="server" Text='<%#Eval("Name")%>' CommandName='<%#Eval("FileItemType")%>' CommandArgument='<%#Eval("Name")%>' Enabled='<%# IsBrowseableItem(Container.DataItem) %>'></asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </table>
                            <asp:Button ID="NewFolderButton" runat="server" Text="New Folder" />
                            <asp:Button ID="DeleteSelectedButton" runat="server" Text="Delete Selected" OnClick="DeleteSelectedButton_Click" OnClientClick="if(FilesChecked()){return  confirm('Are you sure you want to delete the selected items?');} else {alert ('Please select at least one folder or file.'); return false;}" />
                            <asp:Label ID="ErrorMessage2" runat="server" EnableViewState="false" Visible="false" SkinID="errorCondition" Text="<br/>Invalid name, folder not created."></asp:Label>
	                    </div>
                    </div>
                    <asp:Panel ID="NewFolderDialog" runat="server" Style="display: none" CssClass="modalPopup">
                        <asp:Panel ID="NewFolderDialogHeader" runat="server" CssClass="modalPopupHeader">
                            Add Folder
                        </asp:Panel>
                        <div align="center">
                            <br />
	                        <asp:Label ID="NewFolderNameLabel" runat="server" Text="Name: " AssociatedControlID="NewFolderName" SkinID="FieldHeader"></asp:Label>
	                        <asp:TextBox ID="NewFolderName" runat="server" MaxLength="100" ValidationGroup="NewFolderName"></asp:TextBox>
	                        <asp:Button ID="NewFolderOKButton" runat="server" Text="OK" OnClick="NewFolderOKButton_Click" ValidationGroup="NewFolderName"  />
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
                    <asp:Panel ID="phUpload" runat="server" CssClass="section">
                        <div class="header">
                            <h2 class="uplode">Upload</h2>
                        </div>
                        <div class="content">
                            <asp:ValidationSummary ID="UploadValidationSummary" runat="server" ValidationGroup="Upload" />
                            <asp:Label ID="ValidFilesLabel" runat="server" Text="Valid Files:" SkinID="fieldHeader" EnableViewState="false"></asp:Label>
                            <asp:Literal ID="ValidFiles" runat="server" EnableViewState="false"></asp:Literal>
                            <asp:PlaceHolder ID="phValidFiles" runat="server"></asp:PlaceHolder><br />
                            <div style="margin-bottom:6px;"><asp:FileUpload ID="UploadedFile" runat="server" Size="25" /></div>
                            <asp:Button ID="UploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click" /><br />
                            <asp:Label ID="ErrorMessage" runat="server" Visible="false" EnableViewState="false" SkinID="ErrorCondition"></asp:Label>
                        </div>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="grid_8 omega">
        <div class="rightColumn">
            <asp:UpdatePanel ID="FileDetailsAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <cb:Notification ID="SavedMessage" runat="server" Text="Saved at {0:t}" SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                    <cb:Notification ID="FileErrorMessage" runat="server" Visible="false" SkinID="ErrorCondition" EnableViewState="false"></cb:Notification>
                    <div class="section">
                        <div class="header">
                            <h2 class="filedetails">File Details</h2>
                        </div>
                        <div class="content">
                            <asp:PlaceHolder runat="server" ID="NoFileSelectedPanel" Visible="false">
                                <asp:Localize ID="NoFileSelectedMessage" runat="server" Text="Select a file from the directory list to preview or edit here."></asp:Localize>
                            </asp:PlaceHolder>
                            <asp:Panel runat="server" ID="FileDetails" Visible="false">
                                <asp:Label ID="FileName" runat="server" SkinID="FieldHeader"></asp:Label> <asp:Label ID="Dimensions" runat="server"></asp:Label> <asp:Literal ID="FileSize" runat="server"></asp:Literal>
                                &nbsp;<asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                                &nbsp;<asp:Button ID="CopyButton" runat="server" Text="Copy" />
                                &nbsp;<asp:Button ID="RenameButton" runat="server" Text="Rename" />
                                <asp:Panel ID="RenameDialog" runat="server" Style="display: none" CssClass="modalPopup">
                                    <asp:Panel ID="RenameDialogHeader" runat="server" CssClass="modalPopupHeader">
                                        Rename File
                                    </asp:Panel>
                                    <br />
                                    <div style="margin:6px">
                                        <asp:ValidationSummary ID="RenameValidationSummary" runat="server" ValidationGroup="Rename" />
                                        <asp:Label ID="RenameValidFilesLabel" runat="server" Text="Valid Extensions:" SkinID="fieldHeader" EnableViewState="false"></asp:Label>
                                        <asp:Literal ID="RenameValidFiles" runat="server" EnableViewState="false"></asp:Literal>
                                        <asp:PlaceHolder ID="phRenameValidFiles" runat="server"></asp:PlaceHolder><br /><br />
                                        <asp:Label ID="RenameNameLabel" runat="server" Text="Rename To: " AssociatedControlID="RenameName" SkinID="FieldHeader"></asp:Label>
                                        <asp:TextBox ID="RenameName" runat="server"></asp:TextBox>
                                        <asp:Button ID="RenameOKButton" runat="server" Text="OK" OnClick="RenameOKButton_Click" />
                                        <asp:Button ID="RenameCancelButton" runat="server" Text="Cancel" /><br /><br />
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
                                        <asp:TextBox ID="CopyName" runat="server"></asp:TextBox>
                                        <asp:Button ID="CopyOKButton" runat="server" Text="OK" OnClick="CopyOKButton_Click" />
                                        <asp:Button ID="CopyCancelButton" runat="server" Text="Cancel" /><br /><br />
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
                                <asp:PlaceHolder ID="phImagePreview" runat="server">
                                    <div style="max-height:400px;overflow:auto;border:solid 1px gray;padding:2px;">
                                        <asp:Image ID="ImagePreview" CssClass="image_view" runat="server" />
                                    </div>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phTextEditor" runat="server">
                                    <asp:TextBox ID="TextEditor" runat="server" TextMode="MultiLine" Width="100%" Height="500px" Wrap="false"></asp:TextBox>
                                </asp:PlaceHolder>
                            </asp:Panel>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>