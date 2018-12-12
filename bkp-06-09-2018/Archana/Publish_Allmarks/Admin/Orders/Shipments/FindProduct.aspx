<%@ Page Title="Find Product" Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.FindProduct" CodeFile="FindProduct.aspx.cs" %>
<%@ Register Src="~/Admin/Orders/Edit/FindProduct.ascx" TagName="FindProduct" TagPrefix="uc1" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Add Product to Shipment #{0}"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="Locate the product to add to this shipment:"></asp:Localize></p>
        <uc1:FindProduct ID="FindProduct1" runat="server" />
    </div>
</asp:Content>