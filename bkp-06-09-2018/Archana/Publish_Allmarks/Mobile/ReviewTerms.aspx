<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="ReviewTerms.aspx.cs" Inherits="AbleCommerce.Mobile.ReviewTerms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
<div id="reviewTermsPage" class="mainContentWrapper">
    <div class="section">
    <div class="header">
		<h2>Product Review - Terms & Conditions</h2>
	</div>
    <div class="content">
        <p>
        <asp:Label ID="reviewTermsText" runat="server" EnableViewState="false"></asp:Label>
        </p>
    </div>
    <div class="actions">
      <a ID="BackToReviewsLink" runat="server" class="button" enableviewstate="false">Back to Product Reviews</a>
    </div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="PageFooter"></asp:Content>
<asp:Content ID="Content3" runat="server" contentplaceholderid="PageHeader"></asp:Content>

