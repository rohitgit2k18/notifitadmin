<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SearchBox.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.SearchBox" %>
<%--
<conlib>
<summary>Displays a search box to search products.</summary>
</conlib>
--%>

<div class="searchBox">
    <div class="keywords"><asp:TextBox runat="server" ID="Keywords" CssClass="watermarkedInput" Width="100%" ValidationGroup="SearchCriteria"></asp:TextBox></div>
    <div><asp:Button runat="server" ID="SearchButton" Text="Search" CausesValidation="true" OnClick="SearchButton_Click" ValidationGroup="SearchCriteria" /></div><br />
    <cb:SearchKeywordValidator ID="SearchPhraseValidator" runat="server" ControlToValidate="Keywords" Display="None" ValidationGroup="SearchCriteria"
        Text="*" ErrorMessage="Search keyword must be at least {0} characters in length excluding spaces and wildcards." KeywordRequired="true"></cb:SearchKeywordValidator>
     <div><asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="SearchCriteria" /></div> 
</div>
