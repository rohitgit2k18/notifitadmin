<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Admin.Master" CodeFile="Resources.aspx.cs" Inherits="AbleCommerce.Admin.Localization.Resources" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Manage resources for language '{0}'"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel ID="ResourcesAjaxPanel" runat="server" UpdateMode="Conditional">
        <Triggers>
            <asp:PostBackTrigger ControlID="ExportXmlButton" />
            <asp:PostBackTrigger ControlID="ExportCsvButton" />
        </Triggers>
        <ContentTemplate>
            <table cellpadding="2" cellspacing="0" class="innerLayout">
                <tr>
                    <td class="searchPanel" style="width:40%" valign="top">                
                        <div class="inputForm">
                            <table cellpadding="4" cellspacing="0" class="inputForm">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="NameFilterLabel" runat="server" Text="Resource Name:" ToolTip="Filter resources by name/key." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="NameFilter" runat="server" Text="" Width="200px"></asp:TextBox>
                                    </td>
                                    <th>
                                        <cb:ToolTipLabel ID="TranslationFilterLabel" runat="server" Text="Translation:" ToolTip="Filter resources by translation/value." />
                                    </th>
                                    <td>
                                        <asp:TextBox ID="TranslationFilter" runat="server" Text="" Width="200px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Button ID="SearchButton" runat="server" Text="Filter" OnClick="SearchButton_Click" CausesValidation="false" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="itemlist" valign="top">
                        <div class="section">
                            <asp:Panel ID="Panel1" runat="server">
                                <div class="content">
                                    <asp:Label ID="UploadCompleteMessage" runat="server" SkinID="GoodCondition" Text="Upload and import of resources completed with message '{0}'." Visible="false" EnableViewState="false"></asp:Label>
                                    <cb:SortedGridView ID="ResourcesGrid" runat="server" AutoGenerateColumns="False" DataSourceID="ResourcesDs" 
                                        DataKeyNames="Id" SkinID="PagedList" Width="100%" ShowHeaderWhenEmpty="false" PageSize="20" AllowPaging="true" AllowSorting="true" DefaultSortExpression="ResourceName"  OnRowUpdating="ResourcesGrid_RowUpdating" OnRowCommand="ResourcesGrid_OnRowCommand">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Resource Name" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="350" SortExpression="ResourceName">
                                                <HeaderStyle HorizontalAlign="Left" />
                                                <FooterTemplate>
                                                    <asp:TextBox ID="Name" runat="Server" Text='<%# Eval("ResourceName") %>' MaxLength="255" Columns="50"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name" ErrorMessage="required"></asp:RequiredFieldValidator>
                                                </FooterTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="Name" runat="Server" Text='<%# Eval("ResourceName") %>' MaxLength="255" Columns="50"></asp:TextBox><span class="requiredField">*</span>
                                                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name" ErrorMessage="required"></asp:RequiredFieldValidator>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Name" runat="server" Text='<%#Eval("ResourceName")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Translation" SortExpression="Translation" HeaderStyle-HorizontalAlign="Left">
                                                <ItemStyle HorizontalAlign="left"/>
                                                 <FooterTemplate>
                                                    <asp:TextBox ID="Translation" runat="Server" Text='<%# Eval("Translation") %>' MaxLength="255" Columns="50"></asp:TextBox>
                                                </FooterTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="Translation" runat="Server" Text='<%# Eval("Translation") %>' MaxLength="255" Columns="50"></asp:TextBox>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label ID="Translation" runat="server" Text='<%#Eval("Translation")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Edit">
                                                <ItemStyle HorizontalAlign="Right" Width="120px" Wrap="false" />
                                                <FooterStyle  Width="120px" HorizontalAlign="Right"/>
                                                <FooterTemplate>
                                                    <asp:Button ID="InsertButton" runat="server" Text="Add New" CommandName="Insert" CausesValidation="True" />
                                                    <asp:ImageButton ID="CancelButton" runat="server" SkinID="CancelIcon" CommandName="Cancel" CausesValidation="false" />
                                                </FooterTemplate>
                                                <EditItemTemplate>
                                                    <asp:ImageButton ID="SaveButton" runat="server" SkinID="SaveIcon" CommandName="Update" CausesValidation="True" />
                                                    <asp:ImageButton ID="CancelButton" runat="server" SkinID="CancelIcon" CommandName="Cancel" CausesValidation="false" />
                                                </EditItemTemplate>
                                                <ItemTemplate>                                
                                                    <asp:ImageButton ID="EditButton" runat="server" SkinID="EditIcon" CommandName="Edit" AlternateText="Edit"/>
                                                    <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("ResourceName", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No resources found for selected filters, please add a new record:
                                            <br />                        
                                            Resource Name:<asp:TextBox ID="Name" runat="Server" MaxLength="255" Columns="40"></asp:TextBox><span class="requiredField">*</span>
                                            <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name" ErrorMessage="required"></asp:RequiredFieldValidator>&nbsp;&nbsp;
                                            Translation:<asp:TextBox ID="Translation" runat="Server" MaxLength="255" Columns="40"></asp:TextBox>&nbsp;&nbsp;
                                            <asp:Button ID="InsertButton" runat="server" Text="Add" CommandName="EmptyInsert" />
                                        </EmptyDataTemplate>
                                    </cb:SortedGridView>
                                    <div>
                                        <asp:Button ID="AddtButton" runat="server" AlternateText="Add New Record" Text="Add New Record" OnClick="AddButton_Click"/>
                                        <asp:Button ID="ExportXmlButton" runat="server" AlternateText="Export Resources as Xml" Text="Export Resources As Xml" OnClick="ExportXmlButton_Click"/>
                                        <asp:Button ID="ExportCsvButton" runat="server" AlternateText="Export Resources as CSV" Text="Export Resources As CSV" OnClick="ExportCsvButton_Click"/>
                                        <asp:HyperLink ID="UploadLink" runat="server" SkinID="Button" Text="Import Resources" EnableViewState="false" ></asp:HyperLink>
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>
                    </td>
                </tr>
            </table>
            <asp:ObjectDataSource ID="ResourcesDs" runat="server" OldValuesParameterFormatString="original_{0}"
                SelectMethod="Search" TypeName="CommerceBuilder.Localization.LanguageStringDataSource" SelectCountMethod="SearchCount" DataObjectTypeName="CommerceBuilder.Localization.LanguageString" DeleteMethod="Delete" SortParameterName="sortExpression">
                <SelectParameters>
                    <asp:QueryStringParameter Name="languageId" QueryStringField="LanguageId" Type="Int32"  DefaultValue="0" />
                    <asp:ControlParameter Name="resourceName" ControlID="NameFilter" Type="String" DefaultValue=""/>
                    <asp:ControlParameter Name="translation" ControlID="TranslationFilter" Type="String" DefaultValue=""/>
                </SelectParameters>
            </asp:ObjectDataSource>
            <ajaxToolkit:ModalPopupExtender ID="UploadPopup" runat="server" 
                TargetControlID="UploadLink"
                PopupControlID="UploadDialog" 
                BackgroundCssClass="modalBackground"                         
                CancelControlID="CancelUploadButton" 
                DropShadow="true"
                PopupDragHandleControlID="UploadDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Panel ID="UploadDialog" runat="server" Style="display:none;width:600px" CssClass="modalPopup">
        <asp:Panel ID="UploadDialogHeader" runat="server" CssClass="modalPopupHeader">
            Upload and Import Resources
        </asp:Panel>
        <div style="padding-top:5px;">
            <table class="inputForm" cellpadding="3">
                <tr>
                    <td colspan="2">
                        <asp:ValidationSummary ID="AddDigitalGoodValidationSummary" runat="server" ValidationGroup="Upload" />
                    </td>
                </tr>   
                <tr>
                    <th nowrap>
                        <cb:ToolTipLabel ID="UploadFileTypesLabel" runat="server" Text="Valid Files:" AssociatedControlID="UploadFileTypes" ToolTip="A list of file extensions that are valid for uploaded files."></cb:ToolTipLabel>
                    </th>
                    <td>
                        <asp:Literal ID="UploadFileTypes" runat="server" EnableViewState="false">csv, xml</asp:Literal>
                        <asp:PlaceHolder ID="phUploadFileTypes" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <th valign="top" nowrap>
                        <cb:ToolTipLabel ID="UploadFileLabel" runat="server" Text="Upload:" AssociatedControlID="UploadFile" ToolTip="Select the file to upload to the server."></cb:ToolTipLabel>
                    </th>
                    <td valign="top">
                        <asp:FileUpload ID="UploadFile" runat="server" /><span class="requiredField">*</span> 
                        <asp:RequiredFieldValidator ID="UploadFileRequired" runat="server" ControlToValidate="UploadFile"
                            Display="Static" ErrorMessage="You must select a file to upload." Text="*" ValidationGroup="Upload"></asp:RequiredFieldValidator>
                    </td>
                </tr><tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="UploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click" ValidationGroup="Upload" OnClientClick="this.value='Upload In Progress'; this.enabled = false;" />
                        <asp:Button ID="CancelUploadButton" runat="server" Text="Cancel" CausesValidation="false" /><br />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
</asp:Content>