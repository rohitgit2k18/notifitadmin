<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="True" Inherits="AbleCommerce.Admin.Website.ContentPages.CategoryPages.EditCategoryPage" Title="Edit Category Page" CodeFile="EditCategoryPage.aspx.cs" %>
<%@ Register src="~/Admin/ConLib/CategoryTree.ascx" tagname="CategoryTree" tagprefix="uc" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit '{0}'"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                <asp:Button ID="FinishButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="FinishButton_Click" />            
                <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" />
            </div>
        </div>
    </div>
    <cb:Notification ID="SavedMessage" runat="server" Text="Category display page saved at {0:t}" SkinID="GoodCondition" EnableViewState="False" Visible="false"></cb:Notification>
    <asp:ValidationSummary ID="ErrorSummary" runat="server" />
        <div class="content">
                <table class="inputForm" border="0">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Display Name:" ToolTip="The display name of the page.">
                            </cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" Text="" Width="300" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="NameValidator" runat="server" Text="*" Display="Dynamic"
                                ErrorMessage="Name is required." ControlToValidate="Name"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="LocalThemeLabel" runat="server" Text="Theme:" AssociatedControlId="LocalTheme" ToolTip="Specifies the theme that will be used to display this item."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="LocalTheme" runat="server" AppendDataBoundItems="true" DataTextField="DisplayName" DataValueField="Name">
                                <asp:ListItem Text="Use store default" Value="" ></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="DisplayPageLabel" runat="server" Text="Layout:" AssociatedControlID="LayoutList"
                                ToolTip="Specifies the script that will handle the display of this item."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="LayoutList" runat="server" DataSourceID="LayoutDS" DataTextField="DisplayName"
                                DataValueField="FilePath" AppendDataBoundItems="true">
                                <asp:ListItem Text="Use store default" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:ObjectDataSource ID="LayoutDS" runat="server" SelectMethod="LoadAll" TypeName="CommerceBuilder.UI.LayoutDataSource">
                            </asp:ObjectDataSource>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <cb:ToolTipLabel ID="SummaryLabel" runat="server" Text="Description:" ToolTip="Enter a description for this page.">
                            </cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="Summary" runat="server" Text="" TextMode="multiLine"
                                Rows="3" Columns="50" Width="100%" MaxLength="256"></asp:TextBox>
                            <br />
                            <asp:Label ID="SummaryCharCount" runat="server" Text="256"></asp:Label>
                            <asp:Label ID="SummaryCharCountLabel" runat="server" Text="characters remaining"></asp:Label>
                            <span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="SummaryRequired" runat="server" Text="*" Display="Dynamic"
                                ErrorMessage="Description is required." ControlToValidate="Summary"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:TextBox ID="WebpageContent" runat="server" Height="300px" Width="100%" TextMode="MultiLine"></asp:TextBox> 
                        </td>
                    </tr>
                </table>
                <div class="links">
                    <asp:Button ID="SaveButton2" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                    <asp:Button ID="FinishButton2" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="FinishButton_Click" />            
                    <asp:HyperLink ID="CancelButton2" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" />
                </div>
            </div>
</asp:Content>