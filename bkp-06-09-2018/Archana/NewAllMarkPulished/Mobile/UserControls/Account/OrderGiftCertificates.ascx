<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderGiftCertificates.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.Account.OrderGiftCertificates" %>
<%--
<UserControls>
<summary>Displays gift certificate details for an order.</summary>
</UserControls>
--%>
<asp:Panel ID="GiftCertificatesPanel" runat="server" CssClass="widget orderGiftCertificatesWidget" Visible="false">
	<div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Gift Certificates"></asp:Localize></h2>
    </div>
	<div class="content">
        <asp:Repeater ID="GiftCertificatesGrid" runat="server">
            <ItemTemplate>
                <div class="giftCertificate <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                <div class="inputForm">
                    <div class="inlineField">
                        <span class="fieldHeader">Name:</span>
                        <span class="fieldValue">
                            <asp:HyperLink ID="Name" runat="server" Text='<%#Eval("Name")%>' NavigateUrl='<%# AbleCommerce.Code.NavigationHelper.GetMobileStoreUrl(Eval("GiftCertificateId", "~/Members/MyGiftCertificate.aspx?GiftCertificateId={0}").ToString())%>'></asp:HyperLink>
                        </span>
                    </div>
                    <div class="inlineField">
                        <span class="fieldHeader">Status:</span>
                        <span class="fieldValue">
                            <%#GetGCDescription(Container.DataItem)%>
                        </span>
                    </div>
                    <asp:PlaceHolder ID="ExpiryPlaceHolder" runat="server" visible='<%# ((DateTime)Eval("ExpirationDate") != DateTime.MinValue) %>'>
                        <div class="inlineField">
                            <span class="fieldHeader">Expiration Date:</span>
                            <span class="fieldValue">
                                <asp:Literal ID="ExpirationDate" runat="server" Text='<%#Eval("ExpirationDate", "{0:d}")%>'></asp:Literal>
                            </span>
                        </div>
                    </asp:PlaceHolder>
                </div>
            </ItemTemplate>
        </asp:Repeater>
	</div>
</asp:Panel>