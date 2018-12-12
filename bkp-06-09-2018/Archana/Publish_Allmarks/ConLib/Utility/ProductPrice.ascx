<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.ProductPrice" EnableViewState="false" CodeFile="ProductPrice.ascx.cs" %>
<%--
<conlib>
<summary>Control to display product price</summary>
<param name="HideZeroPrice" default="True">If true zero price value isn't displayed</param>
<param name="ShowPriceLinkText" default="Click to see price">The text to use for show price link in the instance when price display is hidden</param>
<param name="ShowRetailPrice" default="False">If true retail price is displayed</param>
<param name="RetailPriceFormat" default="<span class="msrp">{0}</span> ">The format text for retail price.</param>
<param name="PriceFormat" default="{0}">The format text for standard price.</param>
<param name="BasePriceFormat" default="<span class="msrp">{0}</span> ">The format text for base price.</param>
<param name="SpecialPriceFormat" default="{0} ends {1:d}">The format text for special price.</param>
<param name="SpecialPriceFormat2" default="{0}">The format text for special price without end date specified.</param>
<param name="ShowPopupRetailPrice" default="True">If true retail price is displayed in the popup price dialog</param>
<param name="PopupRetailPriceLabel" default="<b>List Price:</b>">The label for retail price in popup price dialog</param>
<param name="PopupRetailPriceFormat" default="{0}">The format for retail price in popup price dialog</param>
<param name="PopupPriceLabel" default="<b>Our Price:</b>">The label for price in popup price dialog</param>
<param name="PopupPriceFormat" default="{0}">The format for price in popup price dialog</param>
<param name="PopupBasePriceLabel" default="<b>Regular Price:</b>">The label for base price in popup price dialog</param>
<param name="PopupBasePriceFormat" default="{0}">The format for base price in popup price dialog</param>
<param name="PopupSpecialPriceLabel" default="<b>Sale Price:</b>">The label for special price in popup price dialog</param>
<param name="PopupSpecialPriceFormat" default="{0} ends {1:d}">The format for special price in popup price dialog</param>
<param name="PopupSpecialPriceFormat2" default="{0}">The format for special price without end date specified in popup price dialog</param>
<param name="PopupAmountSavedLabel" default="<b>You Save:</b>">The label for amount saved value in popup price dialog</param>
<param name="PopupAmountSavedFormat" default="{0} ({1:F0}%)">The format for amount saved value in popup price dialog</param>
<param name="CalculateOneTimePrice" default="False">Indicates if we need to calculate one time price for the subscription product.</param>
</conlib>
--%>
<asp:PlaceHolder ID="phFixedPrice" runat="server">
<asp:Literal ID="RetailPrice1" runat="server"></asp:Literal>
<%if (IncludeRichSnippetsWraper)
  { %>
  <span itemprop="price">
<%} %>
<asp:Literal ID="Price" runat="server"></asp:Literal>
<%if (IncludeRichSnippetsWraper)
  { %>
  </span>
  <meta itemprop="priceCurrency" content="<%=UserCurrencyCode%>" />
<%} %>
</asp:PlaceHolder>
<asp:PlaceHolder ID="phPricePopup" runat="server">
<asp:LinkButton ID="ShowPriceLink" runat="server" Text="Click to see price"></asp:LinkButton>
<asp:Panel ID="PricePopup" runat="server" Style="display:none" CssClass="pricePopup">
    <asp:Panel ID="PricePopupHeader" runat="server" CssClass="header">
        <b><asp:Literal ID="ProductName" runat="server"></asp:Literal></b>
    </asp:Panel>
    <div class="content">
        <asp:PlaceHolder ID="trRetailPrice" runat="server">
			<div class="hiddenRetailPrice">
            <span class="fieldHeader"><asp:Literal ID="HiddenRetailPriceLabel" runat="server" Text=""></asp:Literal></span>
            <span class="fieldValue"><asp:Literal ID="HiddenRetailPrice" runat="server"></asp:Literal></span><br />
			</div>
        </asp:PlaceHolder>
		<div class="hiddenPrice">
        <span class="fieldHeader"><asp:Literal ID="HiddenPriceLabel" runat="server" Text=""></asp:Literal></span>
        <span class="fieldValue"><asp:Literal ID="HiddenPrice" runat="server"></asp:Literal></span>
		</div>
        <asp:PlaceHolder ID="trSpecialPrice" runat="server" Visible="false">
			<div class="specialPrice">
            <span class="fieldHeader"><asp:Literal ID="SpecialPriceLabel" runat="server" Text=""></asp:Literal></span>
            <span class="fieldValue"><asp:Literal ID="SpecialPrice" runat="server"></asp:Literal></span>
			</div>
        </asp:PlaceHolder>        
        <asp:PlaceHolder ID="trAmountSaved" runat="server">
			<div class="amountSaved">
            <span class="fieldHeader"><asp:Literal ID="AmountSavedLabel" runat="server" Text=""></asp:Literal></span>
            <span class="fieldValue"><asp:Literal ID="AmountSaved" runat="server"></asp:Literal></span>
			</div>
        </asp:PlaceHolder>
        <div class="actions">			
            <asp:LinkButton ID="ClosePopUpLink" runat="server" Text="Close" CssClass="button linkButton"></asp:LinkButton>
        </div>
    </div>
</asp:Panel>
</asp:PlaceHolder>
<asp:HiddenField ID="VS" runat="server" EnableViewState="false" />
