<%@ Page Title="Edit My Review" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="EditMyReview.aspx.cs" Inherits="AbleCommerce.Members.EditMyReview" %>
<%@ Register Src="~/ConLib/ProductReviewForm.ascx" TagName="ProductReviewForm" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_editReviewPage" class="mainContentWrapper">
		<div class="section">
			<div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <div class="tabpane">
                    <h2><asp:Literal ID="ProductName" runat="server"></asp:Literal></h2>
					<uc:ProductReviewForm ID="ProductReviewForm1" runat="server"></uc:ProductReviewForm>
				</div>
			</div>
		</div>
    </div>
</div>
</asp:Content>