<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StoreHeader.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.StoreHeader" %>
<div id="storeHeader">
    <div class="headerTop">
        <span class="logo">
            <asp:HyperLink ID="LogoLink" runat="server" NavigateUrl="#"></asp:HyperLink>
        </span>
        <div class="loginStatus">
            <asp:LoginView ID="HeadLoginView" runat="server" EnableViewState="false">
			    <AnonymousTemplate>
				    <asp:HyperLink ID="LoginLink" runat="server" NavigateUrl="#" class="login" Text="Login" />
			    </AnonymousTemplate>
			    <LoggedInTemplate>
                    <asp:HyperLink ID="AccountLink" runat="server" NavigateUrl="#" Text="Account" />
				    <asp:HyperLink ID="LogoutLink" runat="server" NavigateUrl="#" class="login" Text="Logout" />
			    </LoggedInTemplate>
		    </asp:LoginView>
        </div>
    </div>
</div>