<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Edit.AddProduct" Title="Add Product" EnableViewState="false" CodeFile="AddProduct.aspx.cs" %>
<%@ Register Src="AddProductDialog.ascx" TagName="AddProductDialog" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption"><h1><asp:Localize ID="Caption" runat="server" Text="Add Product to Order #{0}"></asp:Localize></h1></div>
    </div>
    <div class="content">
        <uc1:AddProductDialog ID="AddProductDialog1" runat="server" />
    </div>
</asp:Content>