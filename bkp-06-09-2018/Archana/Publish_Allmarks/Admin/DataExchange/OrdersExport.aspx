<%@ Page Title="Export Orders" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="OrdersExport.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.OrdersExport" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function toggleSelected(checkState) {
            var inputs = document.forms[0].elements;
            for (var i = 0; i < inputs.length; i++)
                if (inputs[i].type == "checkbox") inputs[i].checked = checkState;
        }

        function ValidateFieldNames(source, args) {
            var fieldNamesList = document.getElementById('<%= FieldNamesList.ClientID %>');
            var checkboxes = fieldNamesList.getElementsByTagName("input");
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    args.IsValid = true;
                    return;
                }
            }
            args.IsValid = false;
        }

    </script>
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Export Orders"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/export" />
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="section">
                <asp:PlaceHolder ID="ExportOptionsPanel" runat="server">
                    <p>
                        Click the export all orders button to start export, or click filter orders button
                        if you want export some selected orders. It will take you to order manager page
                        where you can filter the orders using the search panel and then proceed with export.</p>
                    <asp:HyperLink ID="ExportAllButton" runat="server" SkinID="Button" Text="Export All Orders"
                        NavigateUrl="~/Admin/DataExchange/OrdersExport.aspx?type=all" EnableViewState="false" />
                    <asp:HyperLink ID="ExportSelectedButton" runat="server" SkinID="Button" Text="Filter Orders"
                        NavigateUrl="~/Admin/Orders/Default.aspx" EnableViewState="false" />
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="FieldSelectionPanel" runat="server" Visible="false">
                    <div class="header">
                        <h2>
                            <asp:Localize ID="ExportCaption" runat="server" Text="Export {0} Orders"></asp:Localize></h2>
                    </div>
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th style="width:140px;">
                                    <cb:ToolTipLabel ID="ExportFormatLabel" runat="server" Text="Export Format:" ToolTip="Choose desired export format from CSV or XML"
                                        EnableViewState="false" SkinID="FieldHeader" />
                                </th>
                                <td>
                                    <asp:DropDownList ID="ExportFormat" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ExportFormat_SelectedIndexChanged">
                                        <asp:ListItem Text="CSV" Value="CSV"></asp:ListItem>
                                        <asp:ListItem Text="XML" Value="XML"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <cb:ToolTipLabel ID="FileTagLabel" runat="server" Text="File Tag:" ToolTip="Provide a file tag which will help you identify and manage the export files in future."
                                        EnableViewState="false" SkinID="FieldHeader" />
                                </th>
                                <td>
                                    <asp:TextBox ID="FileTag" runat="server" Columns="20" MaxLength="20"></asp:TextBox>(optional)
                                </td>
                            </tr>
                            <tr id="trExportAccountData" runat="server" visible="false" enableviewstate="false">
                                <th>
                                    <cb:ToolTipLabel ID="ExportAccountDataLabel" runat="server" Text="Export Account Data:" ToolTip="Choose whether to export sensitive payment account data (e.g. credit card data etc.) or not."
                                        EnableViewState="false" SkinID="FieldHeader" />
                                </th>
                                <td>
                                    <asp:CheckBox ID="ExportAccountData" runat="server" Checked="false" EnableViewState="false" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:PlaceHolder ID="CSVFieldsPanel" runat="server">
                                        <p>
                                            Please select the fields to be included in order export.<asp:CustomValidator runat="server"
                                                ID="FieldNamesValidator" ClientValidationFunction="ValidateFieldNames" ErrorMessage="Select at least one field name."
                                                Text="*" ValidationGroup="Export"></asp:CustomValidator></p>
                                        <asp:CheckBoxList ID="FieldNamesList" runat="server" RepeatLayout="Table" RepeatColumns="6">
                                        </asp:CheckBoxList>
                                        <asp:Label ID="SelectLabel" runat="server" Text="Select :" EnableViewState="false"
                                            SkinID="FieldHeader" />
                                        <a href="javascript:toggleSelected(true);">All</a>&nbsp; <a href="javascript:toggleSelected(false);">
                                            None</a>
                                        <asp:HiddenField ID="ExportAll" runat="server" />
                                    </asp:PlaceHolder>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:ValidationSummary ID="ExportValidationSummary" runat="server" EnableViewState="false"
                                        ValidationGroup="Export" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Button ID="StartExportButton" runat="server" Text="Export Orders" OnClick="StartExportButton_Click"
                                        ValidationGroup="Export" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="ProgressPanel" runat="server" Visible="false">
                    <p>
                        Export operation is in progress, please be patient while the process completes.</p>
                    <p>
                        <asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
                    <p>
                        <asp:Localize ID="ProgressLabel" runat="server" Text="Total Orders: {0} Exported: {1}"
                            EnableViewState="false"></asp:Localize></p>
                    <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick">
                    </asp:Timer>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="MessagesPanel" runat="server" Visible="false">
                <asp:BulletedList ID="Messages" runat="server" style="color: red">
                </asp:BulletedList>
                <asp:Button ID="FinishButton" runat="server" Text="Finish" OnClick="FinishButton_Click" />
            </asp:PlaceHolder>
                <cb:Notification ID="ExportCompleteMessage" runat="server" Text="Orders export complete at {0:t}"
                    SkinID="GoodCondition" Visible="false" EnableViewState="false">
                </cb:Notification>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="section">
        <div class="header">
            <h2>
                <asp:Localize ID="ManageExportCaption" runat="server" Text="Manage Export Files"></asp:Localize></h2>
        </div>
        <div class="content">
            <asp:UpdatePanel ID="BackupFilesPanel" runat="server">
                <Triggers>
                </Triggers>
                <ContentTemplate>
                    <cb:AbleGridView ID="BackupFilesGrid" runat="server" AutoGenerateColumns="False"
                        AllowPaging="false" AllowSorting="false" TotalMatchedFormatString=" {0} backup files."
                        SkinID="PagedList" ShowWhenEmpty="true" OnRowCommand="BackupFilesGrid_RowCommand"
                        Width="100%">
                        <Columns>
                            <asp:BoundField HeaderText="File Name" DataField="FileName" HeaderStyle-HorizontalAlign="Left" />
                            <asp:BoundField HeaderText="Size" DataField="FormattedFileSize" HeaderStyle-HorizontalAlign="Center"
                                ItemStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="Action">
                                <ItemStyle HorizontalAlign="Center" Width="100" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="DownloadLink" runat="server" NavigateUrl='<%# Eval("FileName", "BackupDownloader.ashx?File=DataExchange/Download/{0}") %>'>
                                        <asp:Image ID="DownloadIcon" runat="server" SkinID="DownloadIcon" /></asp:HyperLink>
                                    <asp:ImageButton ID="DeleteButton" runat="server" ToolTip="Delete" CommandName="Do_Delete"
                                        CommandArgument='<%#Eval("FileName")%>' SkinID="DeleteIcon" OnClientClick='<%# Eval("FileName", "return confirm(\"Are you sure you want to delete {0}?\")") %>'>
                                    </asp:ImageButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Localize ID="NoBackupMessage" runat="server" Text="No files available."></asp:Localize>
                        </EmptyDataTemplate>
                    </cb:AbleGridView>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
