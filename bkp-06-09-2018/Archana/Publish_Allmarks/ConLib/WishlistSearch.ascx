<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.WishlistSearch" EnableViewState="false" CodeFile="WishlistSearch.ascx.cs" %>
<%--
<conlib>
<summary>A search form to find wishlists of other customers.</summary>
</conlib>
--%>
<div id="WishListSearchPanel" runat="server" class="widget wishlistSearchWidget">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Find Wishlist" /></h2>
        </div>
		<div class="content">
            <p>Enter the full name or email address for the wishlist you want to locate:</p>
            <asp:UpdatePanel ID="WishlistAjax" runat="server">
                <ContentTemplate>
                    <asp:TextBox ID="Name" Width="120px" runat="server" onfocus="this.select()"></asp:TextBox>
                    <asp:LinkButton ID="FindButton" runat="server" Text="Search" CssClass="button linkButton" OnClick="FindButton_Click"></asp:LinkButton>
                </ContentTemplate>
            </asp:UpdatePanel>
		</div>
    </div>
</div>