<%@ Page Title="Edit Layout" Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Admin.Master" CodeFile="EditLayout.aspx.cs" Inherits="AbleCommerce.Admin.Website.Layouts.EditLayout" %>
<%@ Register Src="~/Admin/Website/Layouts/ControlSelectionDialog.ascx" TagName="ControlSelectionDialog" TagPrefix="uc1" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">    
<style type="text/css">
	
	table.layoutArea
	{
		background-color:#FAFAFA; 
		width:100%;
		border:2px solid;
	}
	
	table.layoutArea td {border:2px dashed;}
	table.layoutArea .modalPopup td {border:none;}
		
	div.controlSection div.header
	{		
		font-weight: bold; 
		text-align: center; 
		margin-bottom: 2px; 
		padding: 2px; 
		color: white; 
		background-color: #B7AB81;
	}	
	div.controlSection div.content
	{
		padding:2px 0 0;
	}
	div.controlSection {padding:6px;}	
	table.layoutArea div.controlSection .pagedList td {border:1px solid;}
	
</style>

    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Layout"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
    <cb:Notification ID="SavedMessage" runat="server" Text="Layout saved at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
        <table border="0" class="inputForm">
            <tr>
                <th width="20%">
                    <cb:ToolTipLabel ID="LayoutNameLabel" runat="server" Text="Name: " AssociatedControlID="LayoutName" ToolTip="Name of the layout." />
                </th>
                <td>
                    <asp:Label ID="LayoutName" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="DescriptionLabel" runat="server" Text="Description:" ToolTip="Enter a description for this layout.">
                    </cb:ToolTipLabel>
                </th>
                <td>
                    <asp:TextBox ID="Description" runat="server" Text="" TextMode="multiLine"
                        Rows="3" Columns="140" Width="100%" MaxLength="256"></asp:TextBox>
                    <asp:Label ID="DescriptionCharCount" runat="server" Text="256"></asp:Label>
                    <asp:Label ID="DescriptionCharCountLabel" runat="server" Text="characters remaining"></asp:Label><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="DescriptionRequired" runat="server" Text="*" Display="Dynamic"
                        ErrorMessage="Description is required." ControlToValidate="Description" ValidationGroup="AddLayout"></asp:RequiredFieldValidator>
                    <br />
                </td>
            </tr>
        </table>
        <table class="layoutArea" >
            <tr>
                <td colspan="3"><uc1:ControlSelectionDialog ID="HeaderControlsDialog" runat="server" PageSection="Header" Caption="Header Controls"></uc1:ControlSelectionDialog></td>
            </tr>
            <tr>
                <td valign="top" style="width:47%;">
                     <uc1:ControlSelectionDialog ID="LeftControlsDialog" runat="server" PageSection="LeftSideBar" Caption="Left Sidebar Controls"></uc1:ControlSelectionDialog>
                </td>
                <td valign="top" style="width:6%;">
                     
                </td>
                <td valign="top" style="width:47%;">
                     <uc1:ControlSelectionDialog ID="RightControlsDialog" runat="server" PageSection="RightSidebar" Caption="Right Sidebar Controls"></uc1:ControlSelectionDialog>
                </td>
            </tr>
            <tr>
                <td colspan="3"><uc1:ControlSelectionDialog ID="FooterControlsDialog" runat="server" PageSection="Footer" Caption="Footer Controls"></uc1:ControlSelectionDialog></td>
            </tr>
        </table>
        <table border="0" class="inputForm">
            <tr>
                <td colspan="2" align="center">  
                    <asp:ValidationSummary ID="LayoutValidationSummary" runat="server" ValidationGroup="AddLayout" />
                    <asp:Button ID="SaveButton" runat="server" Text="Save" ValidationGroup="AddLayout" OnClick="SaveButton_Click" />
                    <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" ValidationGroup="AddLayout" OnClick="SaveAndCloseButton_Click" />
                    <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="~/Admin/Website/Layouts/Default.aspx"/>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>