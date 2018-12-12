<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Email.SendMail" Title="Send Message to Email List" CodeFile="SendMail.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/SendEmail.ascx" TagName="SendEmail" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <uc1:SendEmail id="SendEmail1" runat="server">
    </uc1:SendEmail>
</asp:Content>