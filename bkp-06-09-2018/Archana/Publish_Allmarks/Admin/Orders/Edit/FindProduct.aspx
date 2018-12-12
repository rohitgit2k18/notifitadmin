<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Edit.FindProduct" Title="Add Product" CodeFile="FindProduct.aspx.cs" %>
<%@ Register Src="FindProduct.ascx" TagName="FindProduct" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption"><h1><asp:Localize ID="Caption" runat="server" Text="Add Product to Order #{0}"></asp:Localize></h1></div>
    </div>
    <div class="content">
        <uc1:FindProduct ID="FindProduct1" runat="server" />    
    </div>
</asp:Content>