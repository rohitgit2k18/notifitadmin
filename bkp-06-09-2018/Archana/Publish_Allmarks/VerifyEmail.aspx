<%@ Page Title="Email Verification" Language="C#" MasterPageFile="~/Layouts/Fixed/LeftSidebar.Master" AutoEventWireup="True" CodeFile="VerifyEmail.aspx.cs" Inherits="AbleCommerce.VerifyEmail" %>
<%@ Register src="~/ConLib/VerifyEmail.ascx" tagname="VerifyEmail" tagprefix="uc1" %>
<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
    <div id="verifyEmailPage" class="mainContentWrapper">
		<div class="section">
			<div class="pageHeader">
				<h1>Email Verification</h1>
			</div>
			<div class="content">
				<uc1:VerifyEmail ID="VerifyEmail1" runat="server" SuccessMessage="Your email address has been verified!" FailureMessage="Your email address could not be verified.  Check that you have opened the link exactly as it appeared in the verification notice." />
			</div>
	    </div>
    </div>
</asp:Content>
