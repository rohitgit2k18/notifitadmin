<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderGiftCertificates.ascx.cs" Inherits="AbleCommerce.ConLib.Account.OrderGiftCertificates" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays gift certificates for an order</summary>
</conlib>
--%>
<asp:Panel ID="GiftCertificatesPanel" runat="server" CssClass="widget orderGiftCertificatesWidget" Visible="false">
	<div class="header">
        <h2><asp:Localize ID="Caption" runat="server" Text="Gift Certificates"></asp:Localize></h2>
    </div>
	<div class="content">
        <cb:ExGridView ID="GiftCertificatesGrid" runat="server" Width="100%" AutoGenerateColumns="False" SkinID="ItemList">
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <HeaderStyle CssClass="giftCertificate" />
                    <ItemStyle CssClass="giftCertificate" />
                    <ItemTemplate>
                        <asp:HyperLink ID="Name" runat="server" Text='<%#Eval("Name")%>' NavigateUrl='<%# Eval("GiftCertificateId", "~/Members/MyGiftCertificate.aspx?GiftCertificateId={0}")%>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Status">
                    <HeaderStyle CssClass="giftCertificateStatus" />
                    <ItemStyle CssClass="giftCertificateStatus" />
                    <ItemTemplate>
                        <%#GetGCDescription(Container.DataItem)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expiration Date">
                    <HeaderStyle CssClass="giftCertificateExpiration" />
                    <ItemStyle CssClass="giftCertificateExpiration" />
                    <ItemTemplate>
                        <asp:Literal ID="ExpirationDate" runat="server" Text='<%#Eval("ExpirationDate", "{0:d}")%>' visible='<%# ((DateTime)Eval("ExpirationDate") != DateTime.MinValue) %>'></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>                          
            </Columns>
        </cb:ExGridView>
	</div>
</asp:Panel>