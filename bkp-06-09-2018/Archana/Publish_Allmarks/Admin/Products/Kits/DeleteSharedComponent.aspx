<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Kits.DeleteSharedComponent" Title="Delete Shared Component"  CodeFile="DeleteSharedComponent.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Delete Component"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Label ID="InstructionText" runat="server" Text="The component you want to delete is attached to more than one kit.  Please select the appropriate action below, or click Cancel if you change your mind."></asp:Label></p>
        <p><asp:RadioButton ID="Detach" runat="server" GroupName="DeleteAction" Text="Remove the component from the current kit only.  Leave the other kits alone." Checked="true" /></p>
        <p><asp:RadioButton ID="Delete" runat="server" GroupName="DeleteAction" Text="Delete this component completely from all kits:" /></p>
        <asp:Repeater ID="KitList" runat="server">
            <HeaderTemplate><ul></HeaderTemplate>
            <ItemTemplate>
                <li><asp:Literal ID="Name" runat="server" Text='<%#Eval("Name")%>'></asp:Literal></li>
            </ItemTemplate>
            <FooterTemplate></ul></FooterTemplate>
        </asp:Repeater>
        <asp:Button ID="DeleteButton" runat="server" Text="OK" OnClick="DeleteButton_Click" />
        <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" />
    </div>
</asp:Content>