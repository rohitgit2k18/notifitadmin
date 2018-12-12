<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="MySerialKey.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MySerialKey" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_serialKeyPage" class="mainContentWrapper">
		<div class="section">
			<div class="pageHeader">
				<h1><asp:Localize ID="Caption" runat="server" Text="Serial Key for Digital Good {0}"></asp:Localize></h1>        
			</div>
			<div class="content">				
				<asp:Literal ID="SerialKeyData" runat="server" Text=""></asp:Literal>
			</div>
		</div>
    </div>
</div>
</asp:Content>
<asp:Content ID="Content1" runat="server" contentplaceholderid="PageHeader"></asp:Content>