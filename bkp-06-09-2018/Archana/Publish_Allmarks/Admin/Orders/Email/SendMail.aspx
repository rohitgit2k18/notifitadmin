<%@ Page Language="C#" MasterPageFile="../Order.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.Email.SendMail" Title="Compose a Message" CodeFile="SendMail.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/SendEmail.ascx" TagName="SendEmail" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <uc1:SendEmail id="SendEmail1" runat="server">
    </uc1:SendEmail>
</asp:Content>