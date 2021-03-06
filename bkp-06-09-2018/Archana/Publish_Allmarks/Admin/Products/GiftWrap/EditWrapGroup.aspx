<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Products.GiftWrap.EditWrapGroup" Title="Edit Gift Wrap" CodeFile="EditWrapGroup.aspx.cs" %>
<%@ Register Src="AddWrapStyleDialog.ascx" TagName="AddWrapStyleDialog" TagPrefix="uc1" %>
<%@ Register Src="EditWrapStyleDialog.ascx" TagName="EditWrapStyleDialog" TagPrefix="uc2" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Edit Wrap Group '{0}'"></asp:Localize></h1>
    	</div>
    </div>
    <asp:UpdatePanel ID="WrapStylesAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="content">
                <cb:Notification ID="SavedMessage" runat="server" Text="Wrap group name has been updated." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <cb:Notification ID="SavedWrapStyleMessage" runat="server" Text="Wrap style {0} has been saved." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm">                    
                    <tr>
                        <th> 
                            <asp:Label ID="NameLabel" runat="server" Text="Name:"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" MaxLength="50" ></asp:TextBox>
                            <asp:RegularExpressionValidator ID="NameValidator" runat="server" ErrorMessage="Maximum length for Name is 50 characters." Text="*" ControlToValidate="Name" ValidationExpression=".{0,50}"  ></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ID="NameRequiredValidator" runat="server" ControlToValidate="Name"
                                ErrorMessage="Name is Required." ToolTip="Name is Required." Display="Dynamic"
                                Text="*"></asp:RequiredFieldValidator>
                           <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                           <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                           <asp:HyperLink ID="FinishLink" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" EnableViewState="false"></asp:HyperLink>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="grid_6 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Label ID="WrapStylesCaption" runat="server" Text="Gift Wrap Styles"></asp:Label></h2>
                        </div>
                        <div class="content">
                            <asp:GridView ID="WrapStylesGrid" runat="server" AllowPaging="False" AllowSorting="False"
                                AutoGenerateColumns="False" DataSourceID="WrapStyleDs" DataKeyNames="WrapStyleId" Width="100%"
                                OnRowCommand="WrapStylesGrid_RowCommand" OnRowEditing="WrapStylesGrid_RowEditing" 
                                OnRowCancelingEdit="WrapStylesGrid_RowCancelingEdit" SkinID="PagedList">
                                <Columns>
                                    <asp:TemplateField HeaderText="Order">
                                        <ItemStyle HorizontalAlign="center" Width="60px" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="UpButton" runat="server" SkinID="UpIcon" CommandName="MoveUp" CommandArgument='<%#Container.DataItemIndex%>' AlternateText="Move Up" ToolTip="Move Up" />
                                            <asp:ImageButton ID="DownButton" runat="server" SkinID="DownIcon" CommandName="MoveDown" CommandArgument='<%#Container.DataItemIndex%>' AlternateText="Move Down" ToolTip="Move Down" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name">
                                        <ItemStyle HorizontalAlign="center" />
                                        <ItemTemplate>
                                            <asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Price">
                                        <ItemStyle HorizontalAlign="center" />
                                        <ItemTemplate>
                                            <asp:Label ID="PriceLabel" runat="server" Text='<%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Image">
                                        <ItemStyle HorizontalAlign="center" />
                                        <ItemTemplate>
                                            <asp:Image ID="Thumbnail" runat="server" Visible='<%# !string.IsNullOrEmpty((string)Eval("ThumbnailUrl")) %>' ImageUrl='<%# Eval("Thumbnailurl") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False" ItemStyle-Width="60px">
                                        <ItemStyle HorizontalAlign="center" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" SkinID="EditIcon" AlternateText="Edit" ToolTip="Edit" />
                                            <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" AlternateText="Delete" ToolTip="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:ImageButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" SkinID="CancelIcon" AlternateText="Cancel" ToolTip="Cancel" />
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:Label ID="EmptyDataText" runat="server" Text="No wrap styles are defined for this group."></asp:Label>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <div class="section">
                        <asp:Panel ID="AddPanel" runat="server">
                            <div class="header">
                                <h2 class="addwrapgroup"><asp:Localize ID="AddCaption" runat="server" Text="Add Wrap Style" /></h2>
                            </div>
                            <div class="content">
                                <uc1:AddWrapStyleDialog ID="AddWrapStyleDialog1" runat="server"></uc1:AddWrapStyleDialog>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="EditPanel" runat="server" Visible="false">
                            <div class="header">
                                <h2><asp:Localize ID="EditCaption" runat="server" Text="Edit {0}" /></h2>
                            </div>
                            <div class="content">
                                <uc2:EditWrapStyleDialog ID="EditWrapStyleDialog1" runat="server"></uc2:EditWrapStyleDialog>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="WrapStyleDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadForWrapGroup" TypeName="CommerceBuilder.Products.WrapStyleDataSource" SortParameterName="sortExpression" SelectCountMethod="CountForWrapGroup" DataObjectTypeName="CommerceBuilder.Products.WrapStyle" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
        <SelectParameters>
            <asp:QueryStringParameter Name="WrapGroupId" QueryStringField="WrapGroupId" Type="Object" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="TaxCodeDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Taxes.TaxCodeDataSource">
    </asp:ObjectDataSource>
</asp:Content>