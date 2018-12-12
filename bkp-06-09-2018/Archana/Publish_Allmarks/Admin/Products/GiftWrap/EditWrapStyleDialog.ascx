<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.GiftWrap.EditWrapStyleDialog" CodeFile="EditWrapStyleDialog.ascx.cs" %>
<cb:Notification ID="SavedMessage" runat="server" Text="Wrap Group has been updated at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
<asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EditWrapStyle" />
<table class="inputForm">
    <tr>
        <th>
            <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" AssociatedControlID="Name" ToolTip="Name of the wrapping style"></cb:ToolTipLabel>
        </th>
        <td>
            <asp:TextBox ID="Name" runat="server" MaxLength="50"></asp:TextBox>
            <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="Name" Text="*" ErrorMessage="Name is required." ValidationGroup="EditWrapStyle"></asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <th>
            <cb:ToolTipLabel ID="ThumbnailUrlLabel" runat="server" Text="Thumbnail:" AssociatedControlID="ThumbnailUrl" ToolTip="Thumbnail image of the wrapping style"></cb:ToolTipLabel>
        </th>
        <td>
            <asp:TextBox ID="ThumbnailUrl" runat="server" MaxLength="250" Width="200px"></asp:TextBox>&nbsp;
            <asp:ImageButton ID="BrowseThumbnailUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
        </td>
    </tr>
    <tr>
        <th>
            <cb:ToolTipLabel ID="ImageUrlLabel" runat="server" Text="Image:" AssociatedControlID="ImageUrl" ToolTip="Enlarged image of the wrapping style"></cb:ToolTipLabel>
        </th>
        <td>
            <asp:TextBox ID="ImageUrl" runat="server" MaxLength="250" Width="200px"></asp:TextBox>&nbsp;
           <asp:ImageButton ID="BrowseImageUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
        </td>
    </tr>
    <tr>
        <th>
            <cb:ToolTipLabel ID="PriceLabel" runat="server" Text="Price:" AssociatedControlID="Price" ToolTip="Amount charged when the wrapping style is used"></cb:ToolTipLabel>
        </th>
        <td>
            <asp:TextBox ID="Price" runat="server" Columns="6" MaxLength="8"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <th>
            <cb:ToolTipLabel ID="TaxCodeLabel" runat="server" Text="Tax Code:" AssociatedControlID="TaxCode" ToolTip="Tax code associated with the price of this wrapping style"></cb:ToolTipLabel>
        </th>
        <td>
            <asp:DropDownList ID="TaxCode" runat="server" DataTextField="Name"
                DataValueField="TaxCodeId" AppendDataBoundItems="True">
                <asp:ListItem Value="" Text=""></asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>            
            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" ValidationGroup="EditWrapStyle" />
            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
			<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
        </td>
    </tr>
</table>
