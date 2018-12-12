<%@ Page Title="Product Variants Import" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="VariantsImport.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.VariantsImport" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Variants Import"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/import" />
        </div>
    </div>
    <div class="inputForm">
        <div style="text-align:center;color: red;">
            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
            <div align="left">
                <asp:ValidationSummary ID="ValidationSummary1"  runat="server" ValidationGroup="UpsWsCSV" />
            </div>
        </div>
        <div class="section">
            <asp:Panel ID="OptionsPanel" runat="server" >
                <asp:UpdatePanel ID="FileSelectionAjax" runat="server">
                <Triggers>
                    <asp:PostBackTrigger ControlID="StartButton" />
                </Triggers>
                <ContentTemplate>
                    
                    <table class="innerLayout" cellpadding="5" cellspacing="10" width="100%">
                        <tr>
                            <td colspan="2">
                                <p>Select the file that contains the product variants data. Simple text CSV files and CSV files compressed as zip are accepted. For files larger then <asp:Literal ID="UploadMaxSize" runat="server" Text="{0}KB" EnableViewState="false" /> use FTP to upload them to server. <a href="http://help.ablecommerce.com/mergedProjects/ablecommerceGold/index.htm#catalog/data_exchange/import_product_variants.htm" target="_blank">Click here</a> for help about formatting CSV data.</p>
                                <p>
                                    <ol>
                                        <li>To Import new products specify 'ProductId' value as zero.</li>
                                        <li>Required CSV fields include 'ProductId' and 'ProductOptions', however if your CSV data contains new products then 'ProductName' and 'ProductCategories' fields will also be required.</li>
                                        <li>For product specific fields like 'ProductName', 'ProductSku' etc. only first CSV record for that product will be used, data for all subsequent records for these fields will be ignored.</li>
                                    </ol>
                                </p>
                            </td>
                        </tr>
                            <tr>
                                <th valign="top" style="width:30%"><asp:Label ID="ImportModeLabel" runat="server" Text="Import Data Contains:" EnableViewState="False" /></th>
                                <td>
                                    <asp:RadioButtonList ID="SelectedImportMode" runat="server">
                                        <asp:ListItem Text="New products only." Value="Insert"/>
                                        <asp:ListItem Text="Existing products to update." Value="Update" />
                                        <asp:ListItem Text="Both new and existing products." Value="Mix" Selected="true"/>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        <tr>
                            <th valign="top">
                                <asp:Label ID="SelectFileLabel" runat="server" Text="Select File:" EnableViewState="False" />
                            </th>
                            <td>
                                <asp:RadioButton ID="FileUpload" runat="server" Checked="true" Text="Upload CSV File:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" GroupName="FileSelect" AutoPostBack="true" OnCheckedChanged="FileSeletionModeChanged" />
                                <asp:FileUpload ID="DataFile" runat="server" EnableViewState="true" Width="300" CssClass="fileUpload" Size="50" />
                                <asp:PlaceHolder ID="phFileUpload" runat="server" EnableViewState="false">
                                <asp:RequiredFieldValidator ID="DataFileValidator" runat="server" ControlToValidate="DataFile"
                                        ErrorMessage="Please select a valid csv data file." ValidationGroup="UpsWsCSV">*</asp:RequiredFieldValidator>
                                </asp:PlaceHolder>
                                <br />
                                <asp:RadioButton ID="FileSelectExisting" runat="server" EnableViewState="false" Text="Select From Server:" GroupName="FileSelect" AutoPostBack="true" OnCheckedChanged="FileSeletionModeChanged"/>
                                <asp:TextBox runat="server" ID="SelectedFileName" Width="315" ReadOnly="true" />
                                <asp:PlaceHolder ID="phFileSelect" runat="server" EnableViewState="false" Visible="false">
                                    <asp:ImageButton ID="BrowseFileButton" runat="server" SkinID="FindIcon" AlternateText="Browse" EnableViewState="false" />
                                    <asp:RequiredFieldValidator ID="FilePathValidator" runat="server" ControlToValidate="SelectedFileName"
                                        ErrorMessage="Please select a file from server." ValidationGroup="UpsWsCSV">*</asp:RequiredFieldValidator>
                                    <asp:Panel ID="FileSelectDialog" runat="server" Style="display:none;width:450px" CssClass="modalPopup">
                                        <asp:Panel ID="FileSelectDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
                                            <asp:Localize ID="FileSelectDialogCaption" runat="server" Text="Select From Server (~/App_Data/DataExchange/Upload/)" EnableViewState="false"></asp:Localize>
                                        </asp:Panel>
                                        <div style="padding-top:5px;" class="inputForm">
                                            <div style="max-height:500px;overflow:scroll;">
                                                <asp:RadioButtonList ID="FileList" runat="server" />
                                                <asp:PlaceHolder ID="NoFileFound" runat="server" Visible="false">
                                                    <p>No file found to list.</p>
                                                    <p> You can upload CSV files compressed as zip to the following folder in your store and select them here for import. <br /><b>App_Data/DataExchange/Upload</b></p>
                                                </asp:PlaceHolder>
                                            </div>
                                            <asp:RequiredFieldValidator ID="FileSelectionValidator" runat="server" ControlToValidate="FileList"
                                                    ErrorMessage="Please select a file from list." ValidationGroup="FileSelect" ForeColor="Red" >Please select a file from list.</asp:RequiredFieldValidator><br />
                                            <asp:Button ID="SelectButton" runat="server" Text="Select" EnableViewState="false" ValidationGroup="FileSelect" OnClick="SelectButton_Click"/>
                                            <asp:Button ID="CancelSelectButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                                        </div>
                                    </asp:Panel>
                                    <ajaxToolkit:ModalPopupExtender ID="SelectFilePopup" runat="server" 
                                        TargetControlID="BrowseFileButton"
                                        PopupControlID="FileSelectDialog" 
                                        BackgroundCssClass="modalBackground"                         
                                        CancelControlID="CancelSelectButton" 
                                        DropShadow="false"
                                        PopupDragHandleControlID="FileSelectDialogHeader" />
                                </asp:PlaceHolder>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:Button ID="StartButton" runat="server" Text="Start Import" OnClick="StartButton_Click" ValidationGroup="UpsWsCSV" />   
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Panel ID="ProgressPanel" runat="server" Visible="false">
                <asp:UpdatePanel ID="ProgressUpdate" runat="server">
                <ContentTemplate>
                    <p>An import operation is in progress, please be patient while the import process completes.</p>
                    <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
                    <p><asp:Localize ID="ProgressLabel" runat="server" Text="Total Records: {0} , Processed: {1}" EnableViewState="false"></asp:Localize></p>        
                    <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
                    <br />
                    <asp:Button ID="CancelImportButton" runat="server" Text="Stop Import Process" EnableViewState="false" OnClick="CancelImportButton_Click" />
                </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Panel ID="MessagesPanel" runat="server" Visible="false">
                <asp:BulletedList ID="Messages" runat="server" style="color: red">
                </asp:BulletedList>
                <asp:Button ID="FinishButton" runat="server" Text="Finish" OnClick="FinishButton_Click" />
            </asp:Panel>
        </div>
    </div>
</asp:Content>
