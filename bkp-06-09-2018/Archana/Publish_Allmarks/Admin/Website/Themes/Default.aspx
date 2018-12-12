<%@ Page Title="Theme Manager" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AbleCommerce.Admin.Website.Themes.Default" EnableViewState="false" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="ContentAjax" runat="server" UpdateMode="Always">
        <Triggers>
            <asp:PostBackTrigger ControlID="ImportThemeButton" />
            <asp:PostBackTrigger ControlID="CreateThemeButton" />
        </Triggers>
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Manage Themes"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="website" />
                </div>
            </div>
            <div class="content">
                <asp:Button ID="AddButton" runat="server" Text="Add Theme" SkinID="AddButton" />
                <asp:Button ID="ChangeButton" runat="server" Text="Change Default" />
                <asp:Button ID="ImportButton" runat="server" Text="Import Theme" />
                <asp:Button ID="ChangeAdminTheme" runat="server" Text="Admin Theme" />
                <p><asp:Localize ID="IntroText" runat="server" Text="Themes are a collection of CSS, skin files, and images that help to control the look and feel of your store.  Themes installed for your store are listed below."></asp:Localize></p>
                <cb:AbleGridView ID="ThemesGrid" DataSourceID="ThemesDS" runat="server" AutoGenerateColumns="False"
                    AllowPaging="true" AllowSorting="true" Width="100%" SkinID="PagedList" OnRowCommand="ThemesGrid_RowCommand"
                    PagerSettings-Position="TopAndBottom" PageSize="25" TotalMatchedFormatString=" {0} themes matched">
                    <Columns>
                        <asp:TemplateField HeaderText="Default">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                            <ItemTemplate>
                                <asp:Image ID="IsDefault" runat="server" SkinID="AcceptIcon" Visible='<%# IsDefault(Container.DataItem) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" Width="150px" />
                            <ItemTemplate>
                                <a href="csseditor.aspx?t=<%# Eval("Name") %>">
                                    <%# Eval("Name") %></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#Eval("Description")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Download">
                        <HeaderStyle HorizontalAlign="Center" Width="50px" />
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <a href="ThemeDownloader.ashx?Theme=<%#Eval("Name") %>">
                                    <asp:Image ID="DownloadIcon" runat="server" SkinID="DownloadIcon" AlternateText="Download" ToolTip="Download" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="File Manager">
                        <HeaderStyle HorizontalAlign="Center" Width="80px" />
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <a href="<%# "FileManager.aspx?t="+Eval("Name") %>" target="_blank">
                                    <asp:Image ID="FileIcon" runat="server" SkinID="FileIcon" AlternateText="File Manager" ToolTip="File Manager" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemStyle HorizontalAlign="Right" Width="100px" />
                            <ItemTemplate>
                                <a href="<%# GetPreviewUrl(Container.DataItem) %>" target="_blank">
                                    <asp:Image ID="PreviewIcon" runat="server" SkinID="PreviewIcon" AlternateText="Preview" ToolTip="Preview" /></a>
                                <a href="csseditor.aspx?t=<%# Eval("Name") %>">
                                    <asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit Theme" ToolTip="Edit" /></a>

                                <asp:ImageButton ID="DeleteThemeButton" runat="server" ToolTip="Delete Theme" CommandName="Do_Delete"
                                    CommandArgument='<%#Eval("Name")%>' SkinID="DeleteIcon" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'
                                    Visible='<%# ShowDeleteButton(Container.DataItem)  %>'></asp:ImageButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Localize ID="EmptyListMessage" runat="server" Text="There are no themes to list."></asp:Localize>
                    </EmptyDataTemplate>
                </cb:AbleGridView>                
                <asp:ObjectDataSource ID="ThemesDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.ThemeDataSource"
                    SortParameterName="sortExpression" OnSelecting="ThemesDS_Selecting">
                    <SelectParameters>
                        <asp:Parameter Name="isAdmin" Type="Object" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <ajaxToolkit:ModalPopupExtender ID="AddThemePopup" runat="server" TargetControlID="AddButton"
                    PopupControlID="AddThemeDialog" BackgroundCssClass="modalBackground" CancelControlID="CancelAddButton"
                    DropShadow="true" PopupDragHandleControlID="AddDialogHeader" />
                <ajaxToolkit:ModalPopupExtender ID="ImportThemePopup" runat="server" TargetControlID="ImportButton"
                    PopupControlID="ImportThemeDialog" BackgroundCssClass="modalBackground" CancelControlID="CancelImportButton"
                    DropShadow="true" PopupDragHandleControlID="ImportDialogHeader" />
                <ajaxToolkit:ModalPopupExtender ID="ChangeDefaultPopup" runat="server" TargetControlID="ChangeButton"
                    PopupControlID="ChangeDefaultDialog" BackgroundCssClass="modalBackground" CancelControlID="ChangeDefaultCancel"
                    DropShadow="true" PopupDragHandleControlID="ChangeDefaultHeader" />
                <ajaxToolkit:ModalPopupExtender ID="AdminThemePopup" runat="server" TargetControlID="ChangeAdminTheme"
                    PopupControlID="ChangeAdminDialog" BackgroundCssClass="modalBackground" CancelControlID="ChangeAdminCancel"
                    DropShadow="true" PopupDragHandleControlID="ChangeDefaultHeader" />
            </div>
            <asp:Panel ID="AddThemeDialog" runat="server" Style="display: none; width: 650px"
                CssClass="modalPopup">
                <asp:Panel ID="AddThemeDialogHeader" runat="server" CssClass="modalPopupHeader">
                    <h2>
                        <asp:Localize ID="AddThemeCaption" runat="server" Text="Add Theme"></asp:Localize></h2>
                </asp:Panel>
                <div class="content">
                    <p>
                        <asp:Localize ID="AddThemeHelpText" runat="server" Text="Create a new theme by using the form below.  You may choose an existing theme to use as a template or start with a new blank theme."></asp:Localize></p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Localize ID="NameLabel" runat="server" Text="Name:"></asp:Localize>
                            </th>
                            <td>
                                <asp:TextBox ID="Name" runat="server" MaxLength="50"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" ErrorMessage="Name is required"
                                    ControlToValidate="Name" ValidationGroup="AddThemeGroup"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="NameCustomValidator" runat="server" ValidationExpression="^[a-zA-Z0-9_-]+$"
                                    ValidationGroup="AddThemeGroup" Text="*" ErrorMessage="Theme Name is not valid."
                                    ControlToValidate="Name"></asp:RegularExpressionValidator>
                                <asp:CustomValidator ID="UniqueNameValidator" runat="server" ControlToValidate="Name"
                                    ValidationGroup="AddThemeGroup" Text="*" ErrorMessage="Another theme with same name already exists. Please provide a unique name."
                                    EnableClientScript="False" OnServerValidate="UniqueNameValidator_ServerValidate"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Localize ID="TemplateLabel" runat="server" Text="Copy Theme:"></asp:Localize>
                            </th>
                            <td>
                                <asp:DropDownList ID="Template" DataSourceID="TemplateDS" runat="server" DataTextField="DisplayName"
                                    DataValueField="Name" OnDataBound="Template_DataBound">
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="TemplateDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.ThemeDataSource"
                                    SortParameterName="sortExpression" OnSelecting="ThemesDS_Selecting">
                                    <SelectParameters>
                                        <asp:Parameter Name="isAdmin" Type="Object" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:Button ID="CreateThemeButton" runat="server" Text="Ok" ValidationGroup="AddThemeGroup"
                                    OnClick="CreateThemeButton_Click" />
                                <asp:Button ID="CancelAddButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                                <asp:ValidationSummary ID="AddThemeValidationSummary" runat="server" ValidationGroup="AddThemeGroup" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <asp:Panel ID="ImportThemeDialog" runat="server" Style="display: none; width: 650px"
                CssClass="modalPopup">
                <asp:Panel ID="ImportDialogHeader" runat="server" CssClass="modalPopupHeader">
                    <h2>
                        <asp:Localize ID="ImportThemeCaption" runat="server" Text="Import Theme"></asp:Localize></h2>
                </asp:Panel>
                <div class="content">
                    <p>
                        <asp:Localize ID="ImportThemeHelpText" runat="server" Text="You can import a theme using the form below.  Choose a name for the new theme to create and the zip file that contains the theme source."></asp:Localize></p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Localize ID="ImportAsNameLocalize" runat="server" Text="Name: "></asp:Localize>
                            </th>
                            <td>
                                <asp:TextBox ID="ImportAsName" runat="server"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Text="*"
                                    ErrorMessage="Name is required" ControlToValidate="ImportAsName" ValidationGroup="ImportThemeGroup"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="ImportAsName"
                                    ValidationGroup="ImportThemeGroup" Text="*" ErrorMessage="Another theme with same name already exists. Please provide a unique name."
                                    EnableClientScript="False" OnServerValidate="UniqueNameValidator2_ServerValidate"></asp:CustomValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <asp:Localize ID="TemplateUploadLabel" runat="server" Text="Source Zip:"></asp:Localize>
                            </th>
                            <td>
                                <asp:FileUpload ID="TemplateUpload" runat="server" ValidationGroup="ImportThemeGroup" /><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Text="*"
                                    ErrorMessage="You must choose some theme archive to upload" ControlToValidate="TemplateUpload"
                                    ValidationGroup="ImportThemeGroup"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Selected file is not of valid type."
                                    Text="*" ValidationExpression="^.*\.(zip)$" ControlToValidate="TemplateUpload"
                                    ValidationGroup="ImportThemeGroup"></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                            </th>
                            <td>
                                <asp:Button ID="ImportThemeButton" runat="server" Text="Ok" OnClick="ImportThemeButton_Click"
                                    ValidationGroup="ImportThemeGroup" />
                                <asp:Button ID="CancelImportButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                                <br />
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ImportThemeGroup" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <asp:Panel ID="ChangeDefaultDialog" runat="server" Style="display: none; width: 650px"
                CssClass="modalPopup">
                <asp:Panel ID="ChangeDefaultHeader" runat="server" CssClass="modalPopupHeader">
                    <h2>
                        <asp:Localize ID="DefaultThemesCaption" runat="server" Text="Change Default Theme"></asp:Localize></h2>
                </asp:Panel>
                <div class="content">
                    <p>
                        <asp:Localize ID="DefaultThemesHelpText" runat="server" Text="Any item(s) that do not have a theme otherwise specified will use the default theme for display."></asp:Localize></p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="StoreThemeLabel" runat="server" Text="Default:" AssociatedControlID="StoreTheme" />
                            </th>
                            <td>
                                <asp:DropDownList ID="StoreTheme" DataSourceID="StoreThemeDS" runat="server" DataTextField="DisplayName"
                                    DataValueField="Name" OnDataBound="StoreTheme_DataBound">
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="StoreThemeDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.ThemeDataSource"
                                    SortParameterName="sortExpression" OnSelecting="ThemesDS_Selecting">
                                    <SelectParameters>
                                        <asp:Parameter Name="isAdmin" Type="Object" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:Button ID="UpdateDefaultThemesButton" runat="server" Text="Ok" OnClick="UpdateDefaultThemesButton_Click" />
                                <asp:Button ID="ChangeDefaultCancel" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
            <asp:Panel ID="ChangeAdminDialog" runat="server" Style="display: none; width: 650px"
                CssClass="modalPopup">
                <asp:Panel ID="Panel2" runat="server" CssClass="modalPopupHeader">
                    <h2>
                        <asp:Localize ID="AdminThemesCaption" runat="server" Text="Change Admin Theme"></asp:Localize></h2>
                </asp:Panel>
                <div class="content">
                    <p>
                        <asp:Localize ID="AdminThemesHelpText" runat="server" Text="Any item(s) that do not have a theme otherwise specified will use the default theme for display."></asp:Localize></p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="AdminThemeLabel" runat="server" Text="Default:" AssociatedControlID="AdminTheme" />
                            </th>
                            <td>
                               <asp:DropDownList ID="AdminTheme" runat="server" DataSourceID="AdminThemeDS" DataTextField="DisplayName" DataValueField="Name" EnableViewState="false" AppendDataBoundItems="true" OnDataBound="AdminTheme_DataBound">
                               <asp:ListItem Text="web.config" Value=""></asp:ListItem>
                               </asp:DropDownList>
                                <asp:ObjectDataSource ID="AdminThemeDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.ThemeDataSource">
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="True" Name="isAdmin" Type="Object" />
                                        <asp:Parameter DefaultValue="Name" Name="sortExpression" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <asp:Button ID="UpdateAdminThemesButton" runat="server" Text="Ok" OnClick="UpdateAdminThemesButton_Click" />
                                <asp:Button ID="ChangeAdminCancel" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>