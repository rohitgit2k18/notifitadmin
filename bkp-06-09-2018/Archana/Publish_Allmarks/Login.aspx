<%@ Page Title="Login or Register" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="Login.aspx.cs" Inherits="AbleCommerce.Login" %>
<%@ Register src="~/ConLib/LoginDialog.ascx" tagname="LoginDialog" tagprefix="uc1" %>
<%@ Register src="~/ConLib/RegisterDialog.ascx" tagname="RegisterDialog" tagprefix="uc2" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="loginPage" class="mainContentWrapper">
		<div class="pageHeader">
			<h1>Account Sign In</h1>
		</div>
        <div class="section">
            <div class="content">
                <p>Sign in to your account to access your order history, wishlist, and other personalized features.</p>
            </div>
        </div>
        <asp:PlaceHolder ID="NormalLoginPanel" runat="server">
            <div class="columnsWrapper">
            <div class="column_1 halfColumn">
			    <uc1:LoginDialog ID="LoginDialog1" runat="server" />
            </div>
            <div class="column_2 halfColumn">
			    <uc2:RegisterDialog ID="RegisterDialog1" runat="server" />
		    </div>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="RestrictedLoginPanel" runat="server" Visible="false">
			<uc1:LoginDialog ID="LoginDialog2" runat="server" />
        </asp:PlaceHolder>
    </div>
</asp:Content>
