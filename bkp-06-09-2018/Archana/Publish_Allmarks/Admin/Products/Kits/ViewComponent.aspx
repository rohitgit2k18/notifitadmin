<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Kits.ViewComponent" Title="Kits Using Component"  EnableViewState="false" CodeFile="ViewComponent.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Sharing Details for {0}"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Label ID="InstructionText" runat="server" Text="Below is a list of kits that have this component attached."></asp:Label></p>
        <asp:Repeater ID="KitList" runat="server">
            <HeaderTemplate>
                <ul>
            </HeaderTemplate>
            <ItemTemplate>
                <li><asp:HyperLink ID="Name" runat="server" Text='<%#Eval("Name")%>' NavigateUrl='<%# Eval("ProductId", "../EditProduct.aspx?ProductId={0}") %>'></asp:HyperLink></li>
            </ItemTemplate>
            <FooterTemplate>
                </ul>
            </FooterTemplate>
        </asp:Repeater>
        <asp:Button ID="BackButton" runat="server" Text="Finish" OnClick="BackButton_Click" />
    </div>
</asp:Content>