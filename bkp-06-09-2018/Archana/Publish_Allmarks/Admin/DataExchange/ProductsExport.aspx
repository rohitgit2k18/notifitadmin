<%@ Page Title="Export Products" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="ProductsExport.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.ProductsExport" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    function toggleSelected(checkState) {
        var inputs = document.forms[0].elements;
        for (var i = 0; i < inputs.length; i++)
            if (inputs[i].type == "checkbox") inputs[i].checked = checkState;
    }
</script>
<div class="pageHeader">
    <div class="caption">
    	<h1><asp:Localize ID="Caption" runat="server" Text="Export Products/Variants"></asp:Localize></h1>
        <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/export" />
    </div>
</div>

    
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div class="section">
            <asp:PlaceHolder ID="ExportOptionsPanel" runat="server">
                <p>Click the export all products button to start export, or click filter products button if you want export some selected products. It will take you to product manager page where you can filter the products using the search panel and then proceed with export.</p>
                <asp:HyperLink ID="ExportAllButton" runat="server" SkinID="Button" Text="Export All Products" NavigateUrl="~/Admin/DataExchange/ProductsExport.aspx?type=all" EnableViewState="false" />
                <asp:HyperLink ID="ExportSelectedButton" runat="server" SkinID="Button" Text="Filter Products" NavigateUrl="~/Admin/Products/ManageProducts.aspx" EnableViewState="false" />
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="FieldSelectionPanel" runat="server" Visible="false">
                <div class="header">
                    <h2><asp:Localize ID="ExportCaption" runat="server" Text="Preparing to export {0} products"></asp:Localize></h2>
                </div>
                <div class="content">
                    <table class="inputForm">
                        <tr>    
                            <th style="width:100px">
                                 <asp:Label ID="ExportTypeLabel" runat="server" Text="Export Type:" EnableViewState="false"></asp:Label>
                            </th> 
                            <td>
                                <asp:RadioButton ID="StandardProductExport" runat="server" Text="Standard Product Export" Checked="true" GroupName="ExportType" AutoPostBack="true" OnCheckedChanged="OnExportTypeChanged" />
                                &nbsp;
                                <asp:RadioButton ID="ProductVariantsExport" runat="server" Text="Product Variants Export" GroupName="ExportType" AutoPostBack="true" OnCheckedChanged="OnExportTypeChanged"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="FileTagLabel" runat="server" Text="File Tag:" ToolTip="Provide a file tag which will help you identify and manage the export files in future." EnableViewState="false"/>
                            </th>
                            <td>
                                <asp:TextBox ID="FileTag" runat="server" Columns="20" MaxLength="20"></asp:TextBox>(optional)
                            </td>
                        </tr>
                        <tr id="trVariantSlectionOptions" runat="server" visible="false">
                            <td colspan="2">
                                <asp:Label ID="VariantSlectionOptions" runat="server" Text="Field selection options are not available for variants export."></asp:Label>
                            </td>
                        </tr>
                        <tr id="trFieldList" runat="server">
                            <td colspan="2">
                                <p>
                                    Please select the fields to be included in products export.
                                    <asp:CustomValidator ID="FieldNamesValidator" runat="server" ErrorMessage="No export fields are selected." Text="*" ValidationGroup="Export"></asp:CustomValidator>
                                </p>
                                <asp:CheckBoxList ID="FieldNamesList" runat="server" RepeatLayout="Table" RepeatColumns="6">
                                </asp:CheckBoxList>
                                <br />
                                <asp:Label ID="Label1" runat="server" Text="Select :" EnableViewState="false" SkinID="fieldHeader"/>
                                <a href="javascript:toggleSelected(true);">All</a>&nbsp;
                                <a href="javascript:toggleSelected(false);">None</a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:ValidationSummary ID="ExportValidationSummary" runat="server" EnableViewState="false" ValidationGroup="Export" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:Button ID="StartExportButton" runat="server" Text="Start Export" OnClick="StartExportButton_Click" ValidationGroup="Export"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="ProgressPanel" runat="server" Visible="false">
                <p>Export operation is in progress, please be patient while the process completes.</p>
                <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
                <p><asp:Localize ID="ProgressLabel" runat="server" Text="Total Products: {0} Exported: {1}" EnableViewState="false"></asp:Localize></p>
                <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            </asp:PlaceHolder>
            <cb:Notification ID="ExportCompleteMessage" runat="server" Text="Products export complete at {0:t}" SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<div class="section">
    <div class="header">
        <h2><asp:Localize ID="ManageExportCaption" runat="server" Text="Manage Export Files"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="BackupFilesPanel" runat="server">
            <Triggers></Triggers>
            <ContentTemplate>
                <cb:AbleGridView ID="BackupFilesGrid" runat="server"
                    AutoGenerateColumns="False"
                    AllowPaging="false"
                    AllowSorting="false"
                    TotalMatchedFormatString=" {0} backup files."
                    SkinID="PagedList"
                    ShowWhenEmpty="true"
                    OnRowCommand="BackupFilesGrid_RowCommand"
                    Width="100%">
                    <Columns>
                        <asp:BoundField HeaderText="File Name" DataField="FileName" HeaderStyle-HorizontalAlign="Left"/>
                        <asp:BoundField HeaderText="Size" DataField="FormattedFileSize" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"/>
                        <asp:TemplateField HeaderText="Action">
                            <ItemStyle HorizontalAlign="Center" Width="100" />
                            <ItemTemplate>
                                <asp:HyperLink ID="DownloadLink" runat="server" NavigateUrl='<%# Eval("FileName", "BackupDownloader.ashx?File=DataExchange/Download/{0}") %>'><asp:Image ID="DownloadIcon" runat="server" SkinID="DownloadIcon" /></asp:HyperLink>
                                <asp:ImageButton ID="DeleteButton" runat="server" ToolTip="Delete" CommandName="Do_Delete" CommandArgument='<%#Eval("FileName")%>' SkinID="DeleteIcon" OnClientClick='<%# Eval("FileName", "return confirm(\"Are you sure you want to delete {0}?\")") %>'></asp:ImageButton>
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
