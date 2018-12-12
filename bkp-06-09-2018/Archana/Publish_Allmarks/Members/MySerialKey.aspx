<%@ Page Title="View Serial Key" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MySerialKey.aspx.cs" Inherits="AbleCommerce.Members.MySerialKey" %>
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
