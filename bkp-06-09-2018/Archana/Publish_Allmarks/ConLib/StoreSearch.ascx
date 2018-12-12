<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StoreSearch.ascx.cs" Inherits="AbleCommerce.ConLib.StoreSearch" %>
<%--
<conlib>
<summary>Displays the store search results.</summary>
</conlib>
--%>
<div id="phContent" runat="server" class="widget storeSearchWidget">
    <div class="innerSection">
        <div class="header">
            <h2><asp:localize ID="phCaption" runat="server" Text="Search"></asp:localize></h2>
        </div>
        <div class="content">
            <div class="simpleSearchPanel">
                <asp:Panel ID="SearchPanel" runat="server" DefaultButton="SearchButton">
		            <asp:TextBox ID="SearchPhrase" runat="server" CssClass="searchPhrase" Width="120px" MaxLength="60" ValidationGroup="storeSearch"></asp:TextBox>
                    <asp:Button ID="SearchButton" runat="server" Text="GO"
			             OnClick="SearchButton_Click" CausesValidation="true" CssClass="button" ValidationGroup="storeSearch"  />
                    <asp:RequiredFieldValidator ID="SearchKeywordRequired" runat="server" Display="Dynamic" ValidationGroup="storeSearch" ErrorMessage="Keyword is required." ControlToValidate="SearchPhrase"></asp:RequiredFieldValidator> 
                </asp:Panel>
            </div>
        </div>
    </div>
</div>
