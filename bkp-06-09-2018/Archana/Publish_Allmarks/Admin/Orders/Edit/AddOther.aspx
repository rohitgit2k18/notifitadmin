<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Edit.AddOther" Title="Add Item to Order" CodeFile="AddOther.aspx.cs" %>
<%@ Register Src="AddOther.ascx" TagName="AddOther" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption"><h1><asp:Localize ID="Caption" runat="server" Text="Add Item to Order #{0}"></asp:Localize></h1></div>
    </div>
    <div class="content">
        <uc1:AddOther id="AddOther1" runat="server"></uc1:AddOther>
    </div>
</asp:Content>