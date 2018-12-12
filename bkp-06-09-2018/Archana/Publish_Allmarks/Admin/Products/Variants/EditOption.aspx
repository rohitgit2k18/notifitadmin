<%@ Page Language="C#" MasterPageFile="~/Admin/Products/Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Variants.EditOption" Title="Edit Option" CodeFile="EditOption.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Edit Option '{0}'" EnableViewState="false"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Option has been saved at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="OptionNameLabel" runat="server" Text="Option Name:" AssociatedControlID="OptionName" ToolTip="The name of the option." />
                        </th>
                        <td>
                            <asp:TextBox ID="OptionName" runat="server" Text="" Width="160px" MaxLength="80"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="OptionNameRequired" runat="server" Text="*" Display="Dynamic" ErrorMessage="Option name is required." ControlToValidate="OptionName"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="HeaderTextLabel" runat="server" Text="Header Text:" AssociatedControlID="HeaderText" ToolTip="The default header text to display in the option choice dropdown list." />
                        </th>
                        <td>
                            <asp:TextBox ID="HeaderText" runat="server" Text="" Width="160px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ShowThumbnailsLabel" runat="server" Text="Show Thumbnails:" AssociatedControlID="ShowThumbnails" ToolTip="If checked this option will show a clickable thumbnail interface to the customer. If unchecked customers will have a dropdown of option choices to select from." />
                        </th>
                        <td>
                            <asp:CheckBox ID="ShowThumbnails" runat="server" OnCheckChanged="ShowThumbnails_CheckedChanged" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ThumbnailColumnsLabel" runat="server" Text="Thumbnail Columns:" AssociatedControlID="ThumbnailColumns" ToolTip="The number of thumbnail columns to display for option selection." />
                        </th>
                        <td>
                            <asp:TextBox ID="ThumbnailColumns" runat="server" Text="" Width="40px" MaxLength="3"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ThumbnailHeightLabel" runat="server" Text="Thumbnail Height:" AssociatedControlID="ThumbnailHeight" ToolTip="The height of the thumbnail." />
                        </th>
                        <td>
                            <asp:TextBox ID="ThumbnailHeight" runat="server" Text="" Width="40px" MaxLength="3"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ThumbnailWidthLabel" runat="server" Text="Thumbnail Width:" AssociatedControlID="ThumbnailWidth" ToolTip="The width of the thumbnail." />
                        </th>
                        <td>
                            <asp:TextBox ID="ThumbnailWidth" runat="server" Text="" Width="40px" MaxLength="3"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                            <asp:Button ID="SaveCloseButton" runat="server" Text="Save And Close" SkinID="SaveButton" OnClick="SaveCloseButton_Click" />
			                <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>