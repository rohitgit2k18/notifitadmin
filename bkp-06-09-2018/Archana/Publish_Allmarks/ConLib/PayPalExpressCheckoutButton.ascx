<%@ Control Language="C#" Inherits="AbleCommerce.ConLib.PayPalExpressCheckoutButton" EnableViewState="false" CodeFile="~/ConLib/PayPalExpressCheckoutButton.ascx.cs" %>
<%--
<conlib>
<summary>Displays Paypal Exress Checkout Button</summary>
<param name="ShowHeader" default="True">Indicates whether header will be shown or not.</param>
<param name="ShowDescription" default="True">Indicates whether description will be shown or not.</param>
</conlib>
--%>
<asp:UpdatePanel ID="PayPalPanel" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <asp:Panel id="ExpressCheckoutPanel" runat="server" Visible="false" CssClass="widget ppExpressCheckoutBtn">
			<div class="innerSection">
				<asp:PlaceHolder ID="phHeader" runat="server">
				<div class="header">
					<h2><asp:Localize ID="Caption" runat="server" Text="Express Checkout"></asp:Localize></h2>
				</div>
				</asp:PlaceHolder>
				<div class="content">
					<div align="center" class="contentArea noBottomPadding">
						<asp:LinkButton ID="ExpressCheckoutLink" runat="server" OnClick="ExpressCheckoutLink_Click">
							<asp:Image ID="ExpressCheckoutLinkImage" runat="server" ImageUrl="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif" AlternateText="PayPal Express Checkout" />
						</asp:LinkButton>
					</div>
                    <asp:PlaceHolder ID="phBillMeLaterBtn" runat="server">
                        <span style="text-align:center; display:block;">-OR-</span>
                        <div align="center" class="contentArea noBottomPadding">
					        <asp:LinkButton ID="BMLCheckoutCheckoutLink" runat="server" OnClick="BMLCheckoutLink_Click">
						        <asp:Image ID="BMLCheckoutLinkImage" runat="server" ImageUrl="https://www.paypalobjects.com/webstatic/en_US/btn/btn_bml_SM.png" AlternateText="PayPal Credit Checkout" />
                                <asp:Image ID="BMLCheckoutLinkDescImage" runat="server" ImageUrl="https://www.paypalobjects.com/webstatic/en_US/btn/btn_bml_text.png" AlternateText="PayPal Credit Checkout" />
					        </asp:LinkButton>
                        </div>
                    </asp:PlaceHolder>
					<asp:PlaceHolder ID="phDescription" runat="server">
					    <div class="contentArea noTopPadding">
						    Save time. Check out securely. Click the PayPal button to use the shipping and 
						    billing information you have stored with PayPal.
					    </div>
					</asp:PlaceHolder>
				</div>
			</div>
        </asp:Panel>    
    </ContentTemplate>
</asp:UpdatePanel>