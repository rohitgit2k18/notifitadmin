<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AccountDataViewport.ascx.cs" Inherits="AbleCommerce.Admin.UserControls.AccountDataViewport" %>
<asp:UpdatePanel ID="AccountDataAjax" runat="server">
    <ContentTemplate>
        <asp:LinkButton ID="ShowAccountData" runat="server" Text="View account information" OnClick="ShowAccountData_Click" EnableViewState="false" />
        <asp:Repeater ID="AccountData" runat="server" Visible="false" EnableViewState="false">
            <ItemTemplate>
                <asp:Literal ID="K" runat="server" Text='<%#string.Format("{0}: ", StringHelper.SpaceName(Eval("Key").ToString()))%>'></asp:Literal>
                <asp:Literal ID="V" runat="server" Text='<%#Eval("Value")%>'></asp:Literal><br />
            </ItemTemplate>
        </asp:Repeater>
        <asp:Localize ID="UnavailableMessage" runat="server" Text="n/a" Visible="false" EnableViewState="false"></asp:Localize>
        <asp:Localize ID="SSLRequiredMessage" runat="server" Text="Detailed account data is available, but you must enable SSL in order to view it." Visible="false" EnableViewState="false"></asp:Localize>
    </ContentTemplate>
</asp:UpdatePanel>