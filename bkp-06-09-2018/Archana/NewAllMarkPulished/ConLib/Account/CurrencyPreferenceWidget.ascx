<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CurrencyPreferenceWidget.ascx.cs" Inherits="AbleCommerce.ConLib.Account.CurrencyPreferenceWidget" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>User's currency preferences widget</summary>
</conlib>
--%>
<asp:Panel ID="WidgetPanel" runat="server" class="widget currencyPreferenceWidget">
    <div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Preferred Currency"></asp:Localize></h2>
    </div>
    <div class="content">
        <asp:Localize ID="HelpText" runat="server" Text="{0} conducts all transactions in {1}.  For your convenience, you can view prices in your choice of the currencies below.  Additional currencies are given as an estimate only and may not reflect the exact amount charged."></asp:Localize>
        <asp:UpdatePanel ID="WidgetAjax" runat="server">
            <ContentTemplate>
                <table class="inputForm compact">
                    <tr>
                        <th>
                            <asp:Label ID="UserCurrencyLabel" runat="server" Text="Select Currency:" AssociatedControlID="UserCurrency"></asp:Label>
                        </th>
                        <td>
                            <asp:DropDownList ID="UserCurrency" runat="server" DataTextField="Name" DataValueField="CurrencyId" AutoPostBack="true" OnSelectedIndexChanged="UserCurrency_SelectedIndexChanged" AppendDataBoundItems="true" OnDataBound="UserCurrency_DataBound">
                                <asp:ListItem Value="" Text=""></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Panel>