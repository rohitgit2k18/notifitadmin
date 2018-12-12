<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AmazonCheckoutDialog.ascx.cs" Inherits="AbleCommerce.ConLib.Checkout.AmazonCheckoutDialog" EnableViewState="false" %>
<%@ Register src="AmazonCheckoutButton.ascx" tagname="AmazonCheckoutButton" tagprefix="uc1" %>
<%--
<conlib>
<summary>Displays amazon checkout dialog</summary>
</conlib>
--%>
<asp:UpdatePanel ID="AmazonPanel" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <asp:Panel id="AmazonCheckoutWidget" runat="server" Visible="false" CssClass="widget amazonCheckoutWidget">
			<div class="innerSection">
				<asp:PlaceHolder ID="phHeader" runat="server">
				    <div class="header">
					    <h2><asp:Localize ID="Caption" runat="server" Text="Amazon Checkout"></asp:Localize></h2>
				    </div>
				</asp:PlaceHolder>
				<div class="content">
					<div class="contentArea">
						Save time and check out securely! Click here to checkout using your Amazon account.
					</div>
					<div align="center" class="contentArea">
						<uc1:AmazonCheckoutButton ID="AmazonCheckoutButton1" runat="server" />
                    </div>
				</div>
			</div>
        </asp:Panel>    
    </ContentTemplate>
</asp:UpdatePanel>