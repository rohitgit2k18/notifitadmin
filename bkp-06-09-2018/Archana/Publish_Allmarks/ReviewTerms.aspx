<%@ Page Title="Product Review Terms and Conditions" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="true" CodeFile="ReviewTerms.aspx.cs" Inherits="AbleCommerce.ReviewTerms" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="reviewTermsPage" class="mainContentWrapper">
		<div class="section">
			<div class="content">
		        <asp:Literal ID="TermsAndConditions" runat="Server"></asp:Literal>
			</div>
		</div>
    </div>
</asp:Content>
