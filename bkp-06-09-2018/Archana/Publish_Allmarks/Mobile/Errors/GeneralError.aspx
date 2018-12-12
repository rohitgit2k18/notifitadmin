<%@ Page language="c#" AutoEventWireup="false" MasterPageFile="~/Layouts/Mobile.Master" Inherits="AbleCommerce.Mobile.Errors.GeneralError" CodeFile="GeneralError.aspx.cs" Title="Server error" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="errorPage" class="mainContentWrapper">
		<div class="section">
            <div class="header">
                <h2>Server error</h2>
            </div>
			<div class="content">
			    <p>We are sorry, but the page you are trying to access has experienced an error.</p>    
                <p>Please contact <b><%=GetContact()%></b> to report this problem.</p>
			</div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageFooter" />