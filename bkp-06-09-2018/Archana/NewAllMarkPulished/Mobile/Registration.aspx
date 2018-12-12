<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="Registration.aspx.cs" Inherits="AbleCommerce.Mobile.Registration" %>
<%@ Register src="~/Mobile/UserControls/RegisterDialog.ascx" tagname="RegisterDialog" tagprefix="uc2" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" runat="server">
    <div id="loginPage" class="mainContentWrapper">
		<div class="header">
			<h2>Registration</h2>
		</div>
        <div class="section">
            <div class="content">
                <div class="inputForm">
                    <div class="field">
                        <p class="fieldHeader">Already have an account? <a href="Login.aspx">Login Here</a></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="column_2 halfColumn">
			<uc2:RegisterDialog ID="RegisterDialog1" runat="server" />
		</div>
    </div>
</asp:Content>
