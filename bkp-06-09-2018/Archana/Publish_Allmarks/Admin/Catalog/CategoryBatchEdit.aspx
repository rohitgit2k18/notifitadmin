<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Catalog.CategoryBatchEdit" Title="Category Batch Editing" EnableViewState="false" CodeFile="CategoryBatchEdit.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="pageHeader">
	<div class="caption">
		<h1><asp:Localize ID="Caption" runat="server" Text="Batch Edit Categories"></asp:Localize></h1>
        <div class="links">
            <cb:NavigationLink ID="CategoryLink" runat="server" Text="Browse Catalog" SkinID="Button" NavigateUrl="../Catalog/Browse.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="ProductsLink" runat="server" Text="Manage Products" SkinID="Button" NavigateUrl="../Products/ManageProducts.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="BatcheditLinkProd" runat="server" Text="Batch Edit Products" SkinID="Button" NavigateUrl="../Products/BatchEdit.aspx"></cb:NavigationLink>
            <cb:NavigationLink ID="BatcheditLinkCat" runat="server" Text="Batch Edit Categories" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
        </div>
	</div>
</div>
<asp:UpdatePanel ID="EditAjax" runat="server">
    <Triggers>
        <asp:PostBackTrigger ControlID="SearchButton" />
        <asp:PostBackTrigger ControlID="SaveButton" />
        <asp:PostBackTrigger ControlID="NewSearchButton" />
    </Triggers>
    <ContentTemplate>
        <asp:PlaceHolder ID="SearchPanel" runat="server">
            <div class="searchPanel">
                <table width="100%">
                    <tr>
                        <td valign="top" width="350px">
                            <p>
                                <asp:Label ID="SearchHelpText" runat="server" SkinID="FieldHeader" Text="Search for the categories to edit:"></asp:Label>
                            </p>
                            <table class="inputForm" cellpadding="2" width="100%">
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="NameFilterLabel" runat="server" Text="Name:" AssociatedControlID="NameFilter" ToolTip="Enter all or part of a category name to search for.  You can use the * and ? wildcards."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="NameFilter" runat="server" MaxLength="50" Width="180px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="CategoryFilterLabel" runat="server" Text="Category:" AssociatedControlID="CategoryFilter" ToolTip="Select the category to limit your search."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="CategoryFilter" runat="server" AppendDataBoundItems="True" DataTextField="Name" DataValueField="CategoryId" Width="180px">
                                            <asp:ListItem Text="- Any Category -" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:TextBox ID="CategoryAutoComplete" runat="server" ClientIDMode="Static" Visible="false" AutoCompleteType="Disabled"/>
                                        <asp:HiddenField ID="HiddenSelectedCategoryId" runat="server" ClientIDMode="Static" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="MaximumRowsLabel" runat="server" Text="Max Results:" AssociatedControlID="MaximumRows" ToolTip="Select the maximum number of matches to return."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:DropDownList ID="MaximumRows" runat="server" Width="180px">
                                            <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                            <asp:ListItem Text="20" Value="20" Selected="true"></asp:ListItem>
                                            <asp:ListItem Text="50" Value="50"></asp:ListItem>
                                            <asp:ListItem Text="100" Value="100"></asp:ListItem>
                                            <asp:ListItem Text="200" Value="200"></asp:ListItem>
                                            <asp:ListItem Text="500" Value="500"></asp:ListItem>
                                            <asp:ListItem Text="1000" Value="1000"></asp:ListItem>
                                            <asp:ListItem Text="All" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <cb:ToolTipLabel ID="EnableScrollingLabel" runat="server" Text="Enable Scrolling:" AssociatedControlID="EnableScrolling" ToolTip="If you select a large number of fields, checking this box will keep the editing grid within the bounds of the screen and use scrollbars.  If unchecked, the grid will stretch out as far as necessary."></cb:ToolTipLabel>
                                    </th>
                                    <td>
                                        <asp:CheckBox ID="EnableScrolling" runat="server" Checked="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:LinkButton ID="SearchButton" runat="server" Text="Search" SkinID="Button" />
                                        <asp:HyperLink ID="ResetSearchButton" runat="server" Text="Reset" SkinID="CancelButton" NavigateUrl="CategoryBatchEdit.aspx"></asp:HyperLink>
                                    </td>
                                </tr>
                            </table>
                            <asp:Localize ID="NoResultsMessage" runat="server" Text="There were no results for the search." Visible="false"></asp:Localize>
                        </td>
                        <td valign="top">
                            <p>
                                <asp:Label ID="SelectedFieldsHelpText" runat="server" SkinID="FieldHeader" Text="Indicate the field(s) to be edited:"></asp:Label>
                            </p>
                            <table class="inputForm" cellpadding="0" cellspacing="0">
                                <tr>
                                    <th style="text-align:left" width="240px">
                                        <cb:ToolTipLabel ID="AvailableFieldsLabel" runat="server" Text="Available Fields:" AssociatedControlID="AvailableFields" ToolTip="These fields will not be displayed in the grid for editing.  You can double click a field name to move it to the selected fields box."></cb:ToolTipLabel>
                                    </th>
                                    <td width="46px">&nbsp;</td>
                                    <th style="text-align:left" width="240px">
                                        <cb:ToolTipLabel ID="SelectedFieldsLabel" runat="server" Text="Selected Fields:" AssociatedControlID="SelectedFields" ToolTip="These fields will be displayed in the grid for editing.  You can double click a field name to move it to the unselected fields box."></cb:ToolTipLabel>
                                    </th>
                                </tr>
                                <tr>
                                    <td align="center" valign="top" width="240px">
                                        <asp:ListBox ID="AvailableFields" runat="server" Rows="10" SelectionMode="multiple" Width="250px"></asp:ListBox>
                                    </td>
                                    <td align="center" valign="middle" width="46px">
                                        <asp:Button ID="SelectAllFields" runat="server" Text=" >> " /><br />
                                        <asp:Button ID="SelectField" runat="server" Text=" > " /><br />
                                        <asp:Button ID="UnselectField" runat="server" Text=" < " /><br />
                                        <asp:Button ID="UnselectAllFields" runat="server" Text=" << " /><br />
                                    </td>
                                    <td align="center" valign="top" width="240px">
                                        <asp:ListBox ID="SelectedFields" runat="server" Rows="10" SelectionMode="multiple" Width="250px"></asp:ListBox>
                                        <asp:HiddenField ID="HiddenSelectedFields" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="EditPanel" runat="server">
            <div class="content">
                <asp:PlaceHolder ID="WarningPanel" runat="server" Visible="false">
                    <p><asp:Localize ID="MaxFieldLimitWarning" runat="server" Text="WARNING: The page may unable to process this very large data set because of security restrictions enforced by ASP.NET. You should reduce the number of columns or rows in your result set before making changes.  Alternatively you can ease the restriction by increasing the value of 'aspnet:MaxHttpCollectionKeys' setting in your web.config file."></asp:Localize></p>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="BatchEditGrid" runat="server"></asp:PlaceHolder>
                <asp:LinkButton ID="NewSearchButton" runat="server" Text="New Search" SkinID="Button" />
                <asp:LinkButton ID="SaveButton" runat="server" Text="Save" SkinID="Button" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Data updated at {0}." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
            </div>
        </asp:PlaceHolder>
        <asp:Panel ID="EditHtmlDialog" runat="server" Style="display:none;width:800px" CssClass="modalPopup">
            <asp:Panel ID="EditHtmlDialogHeader" runat="server" CssClass="modalPopupHeader">
                Edit HTML
            </asp:Panel>
            <div style="padding-top:5px;text-align:center;">
                <asp:TextBox ID="EditDescription" runat="server" TextMode="MultiLine" Width="760px" Height="400px"></asp:TextBox><br />
                <div style="text-align:center">
                    <asp:Button ID="EditHtmlSaveButton" runat="server" Text="OK" style="width:70px" CausesValidation="false" OnClientClick="return SaveEditHtmlDialog()" />
                    <asp:Button ID="EditHtmlCancelButton" runat="server" Text="Cancel" style="width:70px" CausesValidation="false" OnClientClick="return HideEditHtmlDialog()" />
                </div>
            </div>
        </asp:Panel>
        <asp:HiddenField ID="EditHtmlTarget" runat="server" />
        <asp:HiddenField ID="EditHtmlCancelTarget" runat="server" />
        <ajaxToolkit:ModalPopupExtender ID="EditHtmlPopup" runat="server" 
            TargetControlID="EditHtmlTarget"
            PopupControlID="EditHtmlDialog" 
            BackgroundCssClass="modalBackground"                         
            CancelControlID="EditHtmlCancelTarget" 
            DropShadow="true"
            PopupDragHandleControlID="EditHtmlDialogHeader" />
        <asp:Panel ID="EditLongTextDialog" runat="server" Style="display:none;width:800px" CssClass="modalPopup">
            <asp:Panel ID="EditLongTextDialogHeader" runat="server" CssClass="modalPopupHeader">
                Edit Text
            </asp:Panel>
            <div style="padding-top:5px;text-align:center;">
                <asp:TextBox ID="EditLongText" runat="server" TextMode="MultiLine" Width="760px" Height="400px"></asp:TextBox><br />
                <asp:Button ID="EditLongTextSaveButton" runat="server" Text="OK" style="width:70px" CausesValidation="false" OnClientClick="return SaveEditLongTextDialog()" />
                <asp:Button ID="EditLongTextCancelButton" runat="server" Text="Cancel" style="width:70px" CausesValidation="false" OnClientClick="return HideEditLongTextDialog()" />
            </div>
        </asp:Panel>
        <asp:HiddenField ID="EditLongTextTarget" runat="server" />
        <asp:HiddenField ID="EditLongTextCancelTarget" runat="server" />
        <ajaxToolkit:ModalPopupExtender ID="EditLongTextPopup" runat="server" 
            TargetControlID="EditLongTextTarget"
            PopupControlID="EditLongTextDialog" 
            BackgroundCssClass="modalBackground"                         
            CancelControlID="EditLongTextCancelTarget" 
            DropShadow="true"
            PopupDragHandleControlID="EditLongTextDialogHeader" />
        <asp:HiddenField ID="VS" runat="server" />
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

