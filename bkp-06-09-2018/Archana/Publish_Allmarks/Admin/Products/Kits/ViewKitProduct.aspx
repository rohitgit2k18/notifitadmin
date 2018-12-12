<%@ Page Language="C#" MasterPageFile="../Product.master" Inherits="AbleCommerce.Admin.Products.Kits.ViewKitProduct" Title="View Kit Part"  CodeFile="ViewKitProduct.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Kitting for {0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="Server" Text="This product is a member of the kits listed below.  Kit members may not have kitting options set."></asp:Localize></p>
        <asp:ListView ID="KitMembershipList" runat="server">
            <ItemTemplate>
                <li><a href="EditKit.aspx?ProductId=<%#Eval("ProductId")%>"><%#Eval("ProductName")%> : <%#Eval("ComponentName")%></a></li>
            </ItemTemplate>
            <LayoutTemplate>
                <ul>
                    <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                </ul>
            </LayoutTemplate>
        </asp:ListView>
    </div>
</asp:Content>