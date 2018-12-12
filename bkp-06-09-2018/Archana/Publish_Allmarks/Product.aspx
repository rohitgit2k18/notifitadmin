<%@ Page Title="View Product" Language="C#" MasterPageFile="~/Layouts/OneColumn.Master" AutoEventWireup="true" CodeFile="Product.aspx.cs" Inherits="AbleCommerce.ProductPage" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="productPage" class="mainContentWrapper" itemtype="http://schema.org/Product" itemscope>
        <cb:HtmlContainer ID="PageContents" runat="server"></cb:HtmlContainer>
        <asp:PlaceHolder ID="PHRichSnippets" runat="server"></asp:PlaceHolder>
    </div>
</asp:Content>