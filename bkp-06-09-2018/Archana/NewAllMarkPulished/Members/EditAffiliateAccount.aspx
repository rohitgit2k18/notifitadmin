<%@ Page Title="Edit Affiliate Account" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="EditAffiliateAccount.aspx.cs" Inherits="AbleCommerce.Members.EditAffiliateAccount" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/AffiliateForm.ascx" TagName="AffiliateForm" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_editAffiliatePage" class="mainContentWrapper">
		<div class="section">
            <div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <div class="tabpane">
			        <uc:AffiliateForm ID="AffiliateForm" runat="server" />
		        </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>