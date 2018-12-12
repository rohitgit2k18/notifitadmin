<%@ Page Language="C#" MasterPageFile="../Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Kits.EditComponent" Title="Edit Component" CodeFile="EditComponent.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Component: {0}"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Label ID="InstructionText" runat="server" Text="Change the component name or input type below."></asp:Label></p>
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Component Name:" ToolTip="Name of the component." AssociatedControlID="Name"></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" Columns="50" width="200px" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="InputTypeLabel" runat="server" Text="Input Type:" ToolTip="Determines the type of input control that will be used for the products in this component." AssociatedControlID="InputTypeId"></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:DropDownList ID="InputTypeId" runat="server" AutoPostBack="true" OnSelectedIndexChanged="InputTypeChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trHeaderOption" runat="server">
                        <th valign="top">
                            <cb:ToolTipLabel ID="HeaderOptionLabel" runat="server" Text="Header Option:" ToolTip="If you wish to have an option that indicates 'no selection', enter the text of the option here." AssociatedControlID="HeaderOption"></cb:ToolTipLabel>
                        </th>
                        <td valign="top">
                            <asp:TextBox ID="HeaderOption" runat="server" Width="200px" MaxLength="100"></asp:TextBox><br />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>                
                            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
				            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>