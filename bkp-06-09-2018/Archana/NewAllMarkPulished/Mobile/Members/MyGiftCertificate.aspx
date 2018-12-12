<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="MyGiftCertificate.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MyGiftCertificate" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_giftCertificatePage" class="mainContentWrapper">
		<div class="section">
        <div class="header">
		    <h2>My Gift Certificate</h2>
		</div>
			<div class="pageHeader noPrint">
				<h1><asp:Localize ID="Caption" runat="server" Text="Gift Certificate - {0}, Order #{1}"></asp:Localize></h1>        
			</div>
			<div class="actions noPrint">
				<asp:LinkButton ID="BackButton" runat="server" Text="Back" CssClass="button linkButton" OnClick="BackButton_Click" />     
			</div>

			<div class="content">
			<div class="inputForm">            
				<div class="field">
                    <span class="fieldHeader">
						<asp:Localize ID="GiftCertificateSummayCaption" runat="server" Text="GIFT CERTIFICATE DETAILS"></asp:Localize>
                    </span>
				</div>
				<div class="field">
					<span class="fieldHeader">Name:</span>
					<span class="fieldValue"><asp:Label runat="server" ID="Name" ></asp:Label></span>
				</div>
				<div class="field">
					<span class="fieldHeader">Status Description:</span>
					<span class="fieldValue"><asp:Label runat="server" ID="Description" ></asp:Label></span>
				</div>
				<div class="field">
					<span class="fieldHeader">Certificate Number:</span>
					<span class="fieldValue"><asp:Label runat="server" ID="Serial" ></asp:Label></span>
				</div>
				 <div class="field">
					<span class="fieldHeader">Balance:</span>
					<span class="fieldValue"><asp:Label runat="server" ID="Balance" ></asp:Label></span>
				</div>
				<div class="field">
					<span class="fieldHeader">Expiration Date:</span>
					<span class="fieldValue"><asp:Label runat="server" ID="Expires" ></asp:Label></span>
				</div>
			</div>
			</div>
		</div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>