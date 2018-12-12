<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="Link.aspx.cs" Inherits="AbleCommerce.Mobile.LinkPage" %>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" runat="server">
    <div id="linkPage" class="mainContentWrapper">
		<div class="section">
			<div class="header">
				<h2><asp:Literal ID="LinkName" runat="server"></asp:Literal></h2>
			</div>		
			<div class="content">
				<asp:PlaceHolder ID="LinkDescriptionPanel" runat="server">
				<p><asp:Literal ID="LinkDescription" runat="server"></asp:Literal></p>
				</asp:PlaceHolder>
				<asp:HyperLink ID="LinkTarget" runat="server"></asp:HyperLink>
			</div>
		</div>
    </div>
</asp:Content>

