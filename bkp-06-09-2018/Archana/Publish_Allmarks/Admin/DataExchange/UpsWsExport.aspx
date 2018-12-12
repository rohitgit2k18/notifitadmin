<%@ Page Title="UPS WorldShip Export" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="UpsWsExport.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.UpsWsExport" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
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
    	<h1><asp:Localize ID="Caption" runat="server" Text="UPS WorldShip&reg; Export"></asp:Localize></h1>
        <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/export" />
    </div>
</div>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div class="section">
            <asp:PlaceHolder ID="InputPanel" runat="server" Visible="false">
                <table class="inputForm">
                    <tr>
                        <td colspan="4">
                            <p>
                                Enter search criteria to find the orders you want to export. Then configure the desired options for exporting the WorldShip&reg; data. For detailed configuration instructions, see how to <a href="#config">configure UPS WorldShip&reg;</a> for Ablecommerce, for more information about export feature <a href="http://help.ablecommerce.com/mergedProjects/ablecommerceGold/index.htm#catalog/data_exchange/export_worldship_data.htm" target="_blank">click here</a>.
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="FileTagLabel" runat="server" Text="File Tag:" ToolTip="Provide a file tag which will help you identify and manage the export files in future." EnableViewState="false"/>
                        </th>
                        <td>
                            <asp:TextBox ID="FileTag" runat="server" Columns="20" MaxLength="20"></asp:TextBox>(optional)
                        </td>
                        <th>
                            <asp:Label ID="OrderDateLabel" runat="server" Text="Order Date:" EnableViewState="false"></asp:Label>
                        </th>
                        <td>
                            from <uc1:PickerAndCalendar ID="OrderStartDate" runat="server" /> to <uc1:PickerAndCalendar ID="OrderEndDate" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="OrderNumberFilterLabel" runat="server" Text="Order Number(s):" AssociatedControlID="OrderNumberFilter"
                                ToolTip="You can enter order number(s) to filter the list.  Separate multiple orders with a comma.  You can also enter ranges like 4-10 for all orders numbered 4 through 10."  EnableViewState="false"/>
                        </th>
                        <td>
                            <asp:TextBox ID="OrderNumberFilter" runat="server" Text="" Width="200px" AutoComplete="off"></asp:TextBox>
                            <cb:IdRangeValidator ID="OrderNumberFilterValidator" runat="server" Required="false"
                                ControlToValidate="OrderNumberFilter" Text="*" 
                                ErrorMessage="The range is invalid.  Enter a specific order number or a range of numbers like 4-10.  You can also include mulitple values separated by a comma."></cb:IdRangeValidator>
                        </td>
                        <th>
                            <cb:ToolTipLabel ID="StatusFilterLabel" runat="server" Text="Order Status:" AssociatedControlID="StatusFilter" ToolTip="Filter by order status." />
                        </th>
                        <td>
                            <asp:DropDownList ID="StatusFilter" runat="server">
                                <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="OnlyUpsShipmentsLabel" runat="server" Text="Only Include UPS Shipments" EnableViewState="false"></asp:Label>
                        </th>
                        <td>
                            <asp:CheckBox ID="OnlyUpsShipments" runat="server" Checked="true"/>
                        </td>
                        <th>
                            <asp:Label ID="IncludeExportedLabel" runat="server" Text="Include Orders Already Exported" EnableViewState="false"></asp:Label>
                        </th>
                        <td>
                            <asp:CheckBox ID="IncludeExported" runat="server" Checked="false"  />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="MarkExportedLabel" runat="server" Text="Mark as Exported on Download" EnableViewState="false"></asp:Label>
                        </th>
                        <td>
                            <asp:CheckBox ID="MarkExported" runat="server" Checked="true" />
                        </td>
                        <th>
                            <asp:Label ID="IncludeUnpaidOrdersLabel" runat="server" Text="Include Unpaid Orders" EnableViewState="false"></asp:Label>
                        </th>
                        <td>
                            <asp:CheckBox ID="IncludeUnpaidOrders" runat="server" Checked="false"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <fieldset>
                                <legend>WorldShip&reg; Options</legend>
                                <asp:UpdatePanel ID="WorldShipOptionsAjax" runat="server">
                                <ContentTemplate>
                                    <asp:CheckBox ID="EnableQvn" runat="server" Checked="false" Text="Enable Quantum View Notification(QVN)" AutoPostBack="true" OnCheckedChanged="OnQVNStatusChanged" />
                                    <br /><br />
                                    <asp:Panel ID="QnvOptions" runat="server" Enabled="false">
                                    <table class="inputForm" cellpadding="5" cellspacing="5">
                                        <tr>
                                            <th style="width:30%">
                                                <asp:Label ID="CustomerNotificationsLabel" runat="server" Text="Customer Notifications:" EnableViewState="false"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:CheckBox ID="ShipmentNotification" runat="server" Checked="false" Text="Shipment"/>
                                                <asp:CheckBox ID="DeliveryNotification" runat="server" Checked="false" Text="Delivery"/>
                                                <asp:CheckBox ID="ExceptionNotification" runat="server" Checked="false" Text="Exception"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <asp:Label ID="SubjectLineLabel" runat="server" Text="Subject Line :" EnableViewState="false"></asp:Label>
                                            </th>
                                            <td>
                                                <asp:DropDownList ID="SubjectLine" runat="server" >
                                                    <asp:ListItem Text="Tracking Number" Value="Tracking Number" />
                                                    <asp:ListItem Text="Order Number (Reference #1)" Value="Order Number (Reference #1)" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <p><asp:Localize ID="QNVEmailHelpText" runat="server" Text="If notificatiuon to the customer should fail, UPS will alert the merchant at the email address given below." EnableViewState="false"></asp:Localize></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <asp:Label ID="FailureNotificationEmailLabel" runat="server" Text="Failure Notification Email:" EnableViewState="false" ></asp:Label>
                                            </th>
                                            <td>
                                                <asp:TextBox ID="NotificationEmail" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                    </asp:Panel>
                                </ContentTemplate>
                                </asp:UpdatePanel>
                            </fieldset>
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
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="ProgressPanel" runat="server" Visible="false">
                <p>Export operation is in progress, please be patient while the process completes.</p>
                <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
                <p><asp:Localize ID="ProgressLabel" runat="server" Text="Total Records: {0} Exported: {1}" EnableViewState="false"></asp:Localize></p>
                <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="MessagesPanel" runat="server" Visible="false">
                <asp:BulletedList ID="Messages" runat="server" style="color: red">
                </asp:BulletedList>
                <asp:Button ID="FinishButton" runat="server" Text="Finish" OnClick="FinishButton_Click" />
            </asp:PlaceHolder>
            <cb:Notification ID="ExportCompleteMessage" runat="server" Text="UPS WorldShip&reg; export complete at {0:t}" SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
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
<div class="section">
    <div class="header">
        <h2><asp:Localize ID="ConfigCaption" runat="server" Text="UPS WorldShip ® 2010 Configuration"></asp:Localize></h2>
    </div>
    <div class="content">
        <a id="config"></a>
        <p>AbleCommerce is integrated with UPS WorldShip to automate the process of entering your shipments and recording tracking numbers.  Before using WorldShip with AbleCommerce, you must perform a few configuration steps.</p>
        <p>Note: The steps below are performed on the computer where WorldShip is installed. It is not necessary for AbleCommerce to be installed on the same server as WorldShip.</p>
        <h3>To configure UPS WorldShip to work with AbleCommerce:</h3>
        <ol>
            <li>Locate the directory where WorldShip is installed.  The default location for this folder is C:\UPS\WSTD\ . 
            </li>
            <li>In the WorldShip directory, make a sub-directory called AbleCommerce.  For example, C:\UPS\WSTD\AbleCommerce .  This directory will be used to transfer data between AbleCommerce and UPS WorldShip. 
            </li>
            <li>From the WorldShip directory, find the &#8220; ImpExp\Shipment &#8221; subdirectory.  Copy the files <a href="BackupDownloader.ashx?File=DataExchange/ablecommerce_to_ups.dat">ablecommerce_to_ups.dat</a> and <a href="BackupDownloader.ashx?File=DataExchange/ups_to_ablecommerce.dat">ups_to_ablecommerce.dat</a> to this folder.  For example, C:\UPS\WSTD\ImpExp\Shipment 
            </li>
            <li>Create an ODBC System Data Source using the following procedure:</li>
            <ol type="a">
                <li>Open the ODBC Data Sources Control Panel.</li>
                <li>Click the &#8220;System DSN&#8221; tab.  A list of the current system data sources is displayed. 
                </li>
                <li>Click the &#8220;Add&#8221; button.  The Create New Data Source screen is displayed. 
                </li>
                <li>Select the &#8220;Microsoft Text Driver (*.txt; *.csv)&#8221; driver from the list and click the Finish button.  The ODBC Text Setup screen is displayed. 
                </li>
                <li>Type &#8220;ablecommerce_worldship&#8221; in the Data Source Name box. </li>
                <li>Uncheck the &#8220;Use Current Directory&#8221; box. </li>
                <li>Click the &#8220;Select Directory&#8221; button.  The Select Directory screen is displayed. 
                </li>
                <li>Browse to the AbleCommerce subdirectory of your WorldShip installation (e.g. C:\UPS\WSTD\AbleCommerce ) created in Step 2 and Click OK.  You are returned to the ODBC Text Setup screen. 
                </li>
                <li>Verify that the &#8220;Directory:&#8221; is showing the correct subdirectory (e.g. C:\UPS\WSTD\AbleCommerce ). 
                </li>
                <li>Click OK. You are returned to the ODBC Data Source Administrator.  Verify that the &#8220;ablecommerce_worldship&#8221; data source now appears in the list. 
                </li>
                <li>Click OK to exit the ODBC Data Source Administrator.</li>
            </ol>
            <li>Configuration is complete.  You can now use the AbleCommerce Data Exchange feature to synchronize your AbleCommerce and WorldShip data.
            </li>
        </ol>
    </div>
</div>
</asp:Content>
