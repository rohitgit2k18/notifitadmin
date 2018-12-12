<%@ Control Language="C#" AutoEventWireup="True" CodeFile="GiftWrapChoices.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.GiftWrapChoices" EnableViewState="true"%>
<%--
<conlib>
<summary>Displays the gift wrapping choices dialog</summary>
</conlib>
--%>
<asp:UpdatePanel ID="GiftAjax" runat="server">
    <ContentTemplate>
        <div class="giftWrap">
            <asp:PlaceHolder ID="phWrapStyle" runat="server"></asp:PlaceHolder>
            <asp:Panel ID="GiftMessagePanel" runat="server" CssClass="message">
                <span>Gift Message:</span>
                <asp:TextBox ID="InnerGiftMessage" runat="server" TextMode="MultiLine"></asp:TextBox>
            </asp:Panel>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>