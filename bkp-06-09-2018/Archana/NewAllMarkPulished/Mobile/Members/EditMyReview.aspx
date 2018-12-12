<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="EditMyReview.aspx.cs" Inherits="AbleCommerce.Mobile.Members.EditMyReview" %>
<%@ Register Src="~/Mobile/UserControls/ProductReviewForm.ascx" TagName="ProductReviewForm" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_editReviewPage" class="mainContentWrapper">
		<div class="section">
        <div class="pageHeader">
             <h1><asp:Literal ID="ProductName" runat="server"></asp:Literal></h1>
        </div>
        <div class="header">
		    <h2>Edit Review</h2>
		</div>
			<div class="content">
                <div class="tabpane">                    
					<uc:ProductReviewForm ID="ProductReviewForm1" runat="server"></uc:ProductReviewForm>
				</div>
			</div>
		</div>
    </div>
</div>
</asp:Content>
