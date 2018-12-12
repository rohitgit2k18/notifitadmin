<%@ Page Title="Currencies" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="Currencies.aspx.cs" Inherits="AbleCommerce.Currencies" %>
<asp:Content ID="CurrenciesContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="currenciesPage" class="mainContentWrapper">
    <div class="section">
        <div class="header">
            <h2 class="preference">Select your preferred currency.</h2>
        </div>
        <div class="contentArea">
            <p><asp:Localize ID="StoreName" runat="server" EnableViewState="false"></asp:Localize> uses the currency <asp:Localize ID="StoreBaseCurrency" runat="server" EnableViewState="false"></asp:Localize></p>
            <p>For your convenience, you can view prices in your choice of the currencies below. The additional currencies are given as an estimate only and may not reflect the exact amount charged.</p>
			<table class="inputForm">
                <tr>
                    <th class="rowHeader">
                        Preferred Currency:
                    </th>
                    <td>
                        <asp:DropDownList ID="UserCurrency" runat="server" DataSourceID="CurrencyDs" DataTextField="Name" DataValueField="CurrencyId" AutoPostBack="true" OnSelectedIndexChanged="UserCurrency_SelectedIndexChanged" AppendDataBoundItems="true" OnDataBound="UserCurrency_DataBound">
	                        <asp:ListItem Value="" Text=""></asp:ListItem>
                        </asp:DropDownList>
                        <div class="info">
                        <asp:Label ID="UpdateMessage" runat="server" Visible="false" CssClass="goodCondition" Text="Currency Updated to {0}."></asp:Label> 
                        </div>

                        <asp:ObjectDataSource ID="CurrencyDs" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="LoadAll" TypeName="CommerceBuilder.Stores.CurrencyDataSource" DataObjectTypeName="CommerceBuilder.Stores.Currency"
                            DeleteMethod="Delete" UpdateMethod="Update" SortParameterName="sortExpression" InsertMethod="Insert">
                        </asp:ObjectDataSource>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
</asp:Content>
