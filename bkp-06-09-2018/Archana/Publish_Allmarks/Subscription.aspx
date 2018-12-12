<%@ Page Language="C#" MasterPageFile="~/Layouts/Fixed/LeftSidebar.master" AutoEventWireup="true" Inherits="AbleCommerce._Subscription" Title="Subscription Confirmation" CodeFile="Subscription.aspx.cs" %>
<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
    <div id="subscriptionPage" class="mainContentWrapper">
		<div class="section">
			<div class="content">
				<asp:PlaceHolder ID="phMessage" runat="server"></asp:PlaceHolder>
			</div>
		</div>
    </div>
</asp:Content>
