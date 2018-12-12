<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="AbleCommerce.Mobile.Login" %>
<%@ Register src="~/Mobile/UserControls/LoginDialog.ascx" tagname="LoginDialog" tagprefix="uc1" %>
<%@ Register src="UserControls/StoreHeader.ascx" tagname="StoreHeader" tagprefix="uc1" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="loginPage" class="mainContentWrapper">
		<div class="header">
			<h2>Sign In</h2>
		</div>
        <div class="section">
            <div class="content">
            <div class="inputForm">
                <div class="field">
                    <p class="fieldHeader">Don't have an account? <a href="Registration.aspx">Register Here</a></p>
                </div>
            </div>
            </div>
        </div>
        <div class="column_1 halfColumn">
			<uc1:LoginDialog ID="LoginDialog1" runat="server" />
        </div>
    </div>
</asp:Content>
<asp:Content ID="PageHeader" runat="server" contentplaceholderid="PageHeader">    
    <uc1:StoreHeader ID="StoreHeader1" runat="server" />
</asp:Content>
