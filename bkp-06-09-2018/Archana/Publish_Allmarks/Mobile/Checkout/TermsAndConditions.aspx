<%@ Page Title="Terms And Conditions" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="TermsAndConditions.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.TermsAndConditions" %>
<asp:Content ID="Content4" ContentPlaceHolderID="PageContent" runat="server">
<div id="checkoutTermsPage" class="mainContentWrapper">
<div class="section">
    <div class="header">
        <h2>Order Terms & Conditions</h2>
    </div>
    <div class="content">
        <p>
            <asp:PlaceHolder ID="PHContents" runat="server"></asp:PlaceHolder>
        </p>
    </div>
    <div class="actions">
        <asp:HyperLink ID="BackLink" runat="server" Text="Back" CssClass="button" NavigateUrl="Payment.aspx"></asp:HyperLink>
    </div>
</div>
</div>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="PageFooter"></asp:Content>
<asp:Content ID="Content3" runat="server" contentplaceholderid="PageHeader"></asp:Content>