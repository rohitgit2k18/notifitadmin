<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.UserCurrencyMenuDropDown" CodeFile="UserCurrencyMenuDropDown.ascx.cs" %>
<%--
<conlib>
<summary>A simple dropdown menu control to select a preferred currency.</summary>
</conlib>
--%>
<div class="widget currencyMenuDD">
<div class="innerSection">
	<asp:DropDownList ID="UserCurrency" runat="server" DataSourceID="CurrencyDs" DataTextField="Name" DataValueField="CurrencyId" AutoPostBack="true" OnSelectedIndexChanged="UserCurrency_SelectedIndexChanged" AppendDataBoundItems="true" OnDataBound="UserCurrency_DataBound">
		<asp:ListItem Value="" Text=""></asp:ListItem>
	</asp:DropDownList>
	<div class="info">
		<asp:Label ID="UpdateMessage" runat="server" Visible="false" CssClass="goodCondition" Text="Currency Updated to {0}."></asp:Label> 
	</div>
</div>
</div>
<asp:ObjectDataSource ID="CurrencyDs" runat="server" OldValuesParameterFormatString="original_{0}"
	SelectMethod="LoadAll" TypeName="CommerceBuilder.Stores.CurrencyDataSource" DataObjectTypeName="CommerceBuilder.Stores.Currency"
	DeleteMethod="Delete" UpdateMethod="Update" SortParameterName="sortExpression" InsertMethod="Insert">
</asp:ObjectDataSource>
