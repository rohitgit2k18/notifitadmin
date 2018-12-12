<%@ Page Title="Import Products" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" CodeFile="ProductImport.aspx.cs" Inherits="AbleCommerce.Admin.DataExchange.ProductImport" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Import Products"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="data/import" />
        </div>
    </div>
    <div class="inputForm">
        <div style="text-align:center;color: red;">
            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
            <div align="left">
                <asp:ValidationSummary ID="ValidationSummary1"  runat="server" ValidationGroup="ProductCSV" />
            </div>
        </div>
        <div class="section">
            <asp:Wizard ID="ImportWizard" runat="server" DisplaySideBar="false"
                Width="100%" FinishCompleteButtonText="Start Import" 
                onfinishbuttonclick="ImportWizard_FinishButtonClick" 
                onnextbuttonclick="ImportWizard_NextButtonClick" 
                onpreviousbuttonclick="ImportWizard_PreviousButtonClick" 
                StartNextButtonText="Next &gt;&gt;"
                >
                <FinishCompleteButtonStyle CssClass="button" />
                <NavigationStyle HorizontalAlign="Center"/>
                <StartNextButtonStyle CssClass="button" />
                <NavigationButtonStyle CssClass="button" />
                <HeaderTemplate>
                    <div class="sectionHeader">
                        <h2><%=GetStepTitle()%></h2>
                    </div>
                </HeaderTemplate>
                <StartNavigationTemplate>
                    <br />
                    <asp:Button ID="NextButton" runat="server" CssClass="button" CommandName="MoveNext" Text="Next &gt;&gt;" CausesValidation="true" ValidationGroup="ProductCSV" />
                </StartNavigationTemplate>
                <StepNavigationTemplate >
                    <br />
                    <asp:Button ID="PreviousButton" runat="server" CssClass="button" Text="&lt;&lt; Previous" CommandName="MovePrevious"  />
                    <asp:Button ID="NextButton" runat="server" CssClass="button" CommandName="MoveNext" Text="Next &gt;&gt;" CausesValidation="true" ValidationGroup="ProductCSV" />
                </StepNavigationTemplate>
                <FinishNavigationTemplate>
                    <br />
                    <asp:Button ID="PreviousButton" runat="server" CssClass="button" Text="&lt;&lt; Previous" CommandName="MovePrevious"  />
                    <asp:Button ID="StartImportButton" runat="server" CssClass="button" CommandName="MoveComplete" Text="Start Import" CausesValidation="true" ValidationGroup="ProductCSV" />
                </FinishNavigationTemplate>
                <WizardSteps>
                    <asp:WizardStep ID="ImportModeStep" runat="server" title="Select Import Mode">
                        <table cellpadding="5" cellspacing="10" class="innerLayout" width="100%">
                            <tr>
                                <th valign="top" style="width:30%"><asp:Label ID="ImportModeLabel" runat="server" Text="Import Data Contains:" CssClass="fieldHeader" EnableViewState="False" /></th>
                                <td>
                                    <asp:RadioButtonList ID="SelectedImportMode" runat="server">
                                        <asp:ListItem Text="New products only." Value="Insert" Selected="true"/>
                                        <asp:ListItem Text="Existing products to update." Value="Update" />
                                        <asp:ListItem Text="Both new and existing products." Value="Mix" />
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                    </asp:WizardStep>
                    <asp:WizardStep ID="InsertOptionsStep" runat="server" title="Importing New Products">
                        <table cellpadding="5" cellspacing="10" class="innerLayout" width="100%">
                            <tr>
                                <th valign="top" style="width:30%">
                                    <asp:Label ID="NewCategoryUpdateMode" runat="server" Text="Category Update Options:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                </th>
                                <td>
                                    <asp:RadioButtonList ID="CategoryAddMode" runat="server">
                                        <asp:ListItem Text="Add to categories specified in uploaded data." Value="0" Selected="true"/>
                                        <asp:ListItem Text="Add to categories specified below." Value="1" />
                                    </asp:RadioButtonList>
                                    <br />
                                    <asp:ListBox ID="InsertCategories" runat="server" SelectionMode="Multiple" Rows="8" Width="400" />
                                </td>
                            </tr>
                            <tr>
                                <th valign="top">
                                    <asp:Label ID="InsertMatchFieldsLabel" runat="server" Text="Field Matching Options:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                </th>
                                <td>
                                    <asp:RadioButtonList ID="InsertMatchMode" runat="server">
                                    <asp:ListItem Text="Do not match fields." Value="0" Selected="true"/>
                                    <asp:ListItem Text="Ignore products matching on following fields." Value="1" />
                                    </asp:RadioButtonList>
                                    <br />
                                    <asp:ListBox ID="InsertMatchFields" runat="server" SelectionMode="Multiple" Rows="8" Width="400"></asp:ListBox>
                                    <asp:CustomValidator ID="InsertMatchFieldsValidator" runat="server" ControlToValidate="InsertMatchFields" Text="*" ErrorMessage="Please select at least one match field." ValidationGroup="ProductCSV" />
                                </td>
                            </tr>
                        </table>
                    </asp:WizardStep>
                    <asp:WizardStep ID="UpdateOptionsStep" runat="server" Title="Updating Existing Products">
                        <table cellpadding="5" cellspacing="10" class="innerLayout" width="100%">
                            <tr>
                                <th valign="top" style="width:30%">
                                    <asp:Label ID="CategoryUpdateLabel" runat="server" Text="Category Update Options:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                </th>
                                <td>
                                    <asp:RadioButtonList ID="UpdateCategoryUpdateMode" runat="server">
                                        <asp:ListItem Text="Do not update categories." Value="0" Selected="true"/>
                                        <asp:ListItem Text="Update to categories specified in uploaded data." Value="1" />
                                        <asp:ListItem Text="Update to categories specified below." Value="2" />
                                    </asp:RadioButtonList>
                                    <br />
                                    <asp:ListBox ID="UpdateCategories" runat="server" SelectionMode="Multiple" Rows="8" Width="400"/>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" align="center">
                                    <asp:Label ID="Label3" runat="server" Text="Field Matching Options:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                    <br />
                                    <asp:Label ID="HelpText" runat="server" Text="(Only matching products will be updated)" EnableViewState="false"></asp:Label>
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="UpdateMatchMode" runat="server">
                                        <asp:ListItem Text="Match using ProductId only." Value="0" Selected="true"/>
                                        <asp:ListItem Text="Match using the following fields." Value="1" />
                                    </asp:RadioButtonList>
                                    <br />
                                    <asp:ListBox ID="UpdateMatchFields" runat="server" SelectionMode="Multiple" Rows="8" Width="400"></asp:ListBox>
                                    <asp:CustomValidator ID="UpdateMatchFieldsValidator" runat="server" ControlToValidate="UpdateMatchFields" Text="*" ErrorMessage="Please select at least one match field." ValidationGroup="ProductCSV" />
                                </td>
                            </tr>
                        </table>
                    </asp:WizardStep>
                    <asp:WizardStep ID="MixOptionsStep" runat="server" Title="Importing New Products and Updating Existing">
                        <table class="innerLayout" cellpadding="5" cellspacing="10" width="100%">
                            <tr>
                                <th valign="top" style="width:30%">
                                    <asp:Label ID="CategoryUpdateLabel2" runat="server" Text="Category Update Options:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                </th>
                                <td>
                                    <table cellpadding="2" cellspacing="0" class="innerLayout" width="100%">
                                        <tr>
                                            <td>
                                                <asp:Label ID="NewProductsLabel" runat="server" Text="For New Products:" EnableViewState="false" CssClass="fieldHeader"/>
                                            </td>
                                            <td>
                                                <asp:Label ID="ExistingProductsLabel" runat="server" Text="For Existing Products:" EnableViewState="false" CssClass="fieldHeader"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:RadioButtonList ID="MixCategoryInsertMode" runat="server" >
                                                    <asp:ListItem Text="Add to categories specified in uploaded data." Value="0" Selected="true"/>
                                                    <asp:ListItem Text="Add to categories specified below." Value="1" />
                                                </asp:RadioButtonList>
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="MixCategoryUpdateMode" runat="server" >
                                                    <asp:ListItem Text="Do not update categories." Value="0" Selected="true"/>
                                                    <asp:ListItem Text="Update to categories specified in uploaded data." Value="1" />
                                                    <asp:ListItem Text="Update to categories specified below." Value="2" />
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <asp:ListBox ID="MixCategories" runat="server" SelectionMode="Multiple" Rows="8" Width="400"/>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" align="center">
                                    <asp:Label ID="MixMatchingFieldsLabel" runat="server" Text="Field Matching Options:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                    <br />
                                    <asp:Label ID="Label2" runat="server" Text="(Matching products will be updated, Others will be added)" EnableViewState="false"></asp:Label>
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="MixMatchMode" runat="server">
                                        <asp:ListItem Text="Match using ProductId only." Value="0" Selected="true"/>
                                        <asp:ListItem Text="Match using the following fields." Value="1" />
                                    </asp:RadioButtonList>
                                    <asp:ListBox ID="MixMatchFields" runat="server" SelectionMode="Multiple" Rows="8" Width="400"></asp:ListBox>
                                    <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="MixMatchFields" Text="*" ErrorMessage="Please select at least one match field." ValidationGroup="ProductCSV" />
                                </td>
                            </tr>
                        </table>
                    </asp:WizardStep>
                    <asp:WizardStep ID="FileSelect" runat="server" Title="Data File" StepType="Finish">
                        <table class="innerLayout" cellpadding="5" cellspacing="10" width="100%">
                            <tr>
                                <th valign="top" style="width:30%">
                                    <asp:Label ID="DataFileLabel" runat="server" Text="DataFile" EnableViewState="false"/>
                                </th>
                                <td>
                                    <p>Select the file that contains the product data. Simple text CSV files and CSV files compressed as zip are accepted. For files larger then <asp:Literal ID="UploadMaxSize" runat="server" Text="{0}KB" EnableViewState="false" /> use FTP to upload them to server.</p>
                                    <asp:UpdatePanel ID="FileSelectionAjax" runat="server">
                                        <ContentTemplate>                                
                                            <asp:RadioButton ID="FileUpload" runat="server" Checked="true" Text="Upload CSV File:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" GroupName="FileSelect" AutoPostBack="true" OnCheckedChanged="FileSeletionModeChanged" />
                                            <asp:FileUpload ID="DataFile" runat="server" EnableViewState="true" Width="300" CssClass="fileUpload" Size="50" />
                                            <asp:PlaceHolder ID="phFileUpload" runat="server" EnableViewState="false">
						<span class="requiredField">*</span><asp:RequiredFieldValidator ID="DataFileValidator" runat="server" ControlToValidate="DataFile"
                                                    ErrorMessage="Please select a valid csv data file." ValidationGroup="ProductCSV">*</asp:RequiredFieldValidator>
                                            </asp:PlaceHolder>
                                            <br />
                                            <asp:RadioButton ID="FileSelectExisting" runat="server" EnableViewState="false" Text="Select From Server:" GroupName="FileSelect" AutoPostBack="true" OnCheckedChanged="FileSeletionModeChanged"/>
                                            <asp:TextBox runat="server" ID="SelectedFileName" Width="315" ReadOnly="true" />
                                            <asp:PlaceHolder ID="phFileSelect" runat="server" EnableViewState="false" Visible="false">
                                                <asp:ImageButton ID="BrowseFileButton" runat="server" SkinID="FindIcon" AlternateText="Browse" EnableViewState="false" />
                                                <span class="requiredField">*</span><asp:RequiredFieldValidator ID="FilePathValidator" runat="server" ControlToValidate="SelectedFileName"
                                                    ErrorMessage="Please select a file from server." ValidationGroup="ProductCSV">*</asp:RequiredFieldValidator>
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
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="DataFormatLabel" runat="server" Text="Data Format:" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                                </th>
                                <td>
                                    <table cellpadding="2" cellspacing="0" class="innerLayout">
                                        <tr>
                                            <td align="left" colspan="2">
                                                Ensure that the delimiter and text qualifier are the correct settings for your file. For guidelines on how to format the CSV data, please review the merchant documentation.
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="rowHeader" valign="top">
                                                <asp:Label ID="TextDelimiterLabel" runat="Server" EnableViewState="false" Text="Text Delimiter:"></asp:Label>
                                            </th>
                                            <td >
                                                <asp:DropDownList ID="TextDelimiter" runat="server" EnableViewState="false">
                                                    <asp:ListItem Text=", (comma)" Value="," Selected="true"/>
                                                    <asp:ListItem Text="; (semicolon)" Value=";" />
                                                    <asp:ListItem Text="	(tab)" Value="" />
                                                    <asp:ListItem Text="| (pipe)" Value="|" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="rowHeader" valign="top">
                                                <asp:Label ID="TextQualifierLabel" runat="Server" EnableViewState="false" Text="Text Qualifier:"></asp:Label>
                                            </th>
                                            <td >
                                                <asp:DropDownList ID="TextQualifier" runat="server" EnableViewState="false">
                                                    <asp:ListItem Text="&quot; (quote)" Value="&quot;" Selected="true"/>
                                                    <asp:ListItem Text="' (apostrophe)" Value="'" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </asp:WizardStep>
                    <asp:WizardStep ID="ProgressStep" runat="server" Title="Progress" StepType="Complete">
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
                    </asp:WizardStep>
                    <asp:WizardStep ID="MessagesStep" runat="server" StepType="Complete" Title="Complete">
                        <asp:BulletedList ID="Messages" runat="server" style="color: red">
                        </asp:BulletedList>
                        <asp:Button ID="FinishButton" runat="server" Text="Finish" OnClick="FinishButton_Click" />
                    </asp:WizardStep>
                </WizardSteps>
            </asp:Wizard>
        </div>
    </div>
</asp:Content>
