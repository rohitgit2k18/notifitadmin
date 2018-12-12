<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StoreFooter.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.StoreFooter" %>
<%@ Register src="~/Mobile/UserControls/Utility/SocialMediaLinks.ascx" tagname="SocialMediaLinks" tagprefix="uc1" %>
<%@ Register src="~/ConLib/UniversalGoogleAnalyticsWidget.ascx" tagname="UniversalGoogleAnalyticsWidget" tagprefix="uc" %>
<div id="storeFooter">
    <div class="footerLinks">
        <asp:HyperLink ID="ftrHomeLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Home" />
        <asp:HyperLink ID="ftrAccLink" runat="server" NavigateUrl="#" CssClass="tab" Text="My Account" />
        <asp:HyperLink ID="ftrCartLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Cart" />
        <asp:HyperLink ID="ftrWishlistLInk" runat="server" NavigateUrl="#" CssClass="tab" Text="Wishlist" />
        <asp:HyperLink ID="ftrFullSiteLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Full Store View" />
        <asp:LoginView ID="HeadLoginView" runat="server" EnableViewState="false">
			<AnonymousTemplate>
				<asp:HyperLink ID="ftrLoginLink" runat="server" NavigateUrl="#" class="login" Text="Login" />
			</AnonymousTemplate>
			<LoggedInTemplate>
                <asp:HyperLink ID="ftrLogoutLink" runat="server" NavigateUrl="#" CssClass="tab" Text="Logout" />
			</LoggedInTemplate>
		</asp:LoginView>
    </div>
	<uc1:SocialMediaLinks ID="SocialMediaLinks1" runat="server" />
    <p class="copyright">
	    <a href="http://www.ablecommerce.com" class="linked" target="_blank">Shopping Cart Software by AbleCommerce</a>.
    </p>
    <uc:UniversalGoogleAnalyticsWidget ID="UniversalGoogleAnalyticsWidget1" runat="server" />
</div>
