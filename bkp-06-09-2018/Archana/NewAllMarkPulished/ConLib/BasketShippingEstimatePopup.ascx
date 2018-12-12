<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.BasketShippingEstimatePopup" EnableViewState="false" CodeFile="BasketShippingEstimatePopup.ascx.cs" %>
<%-- 
<conlib>
<summary>Implements a pop-up shipping estimate control for a basket.</summary>
<param name="ShowCity" default="False">If true city field is displayed</param>
<param name="Caption" default="Shipping Estimate">The caption to show for the shipping estimate dialog</param>
<param name="InstructionText" default="To estimate shipping charges for this order, enter the delivery address below.">The instruction text to show in the shipping estimate dialog</param>
<param name="AssumeCommercialRates" default="False">If true commercial rates are assumed</param>
</conlib>
--%>

<div class="basketShippingEstimatePopup">
<div class="launchArea">
 <span class="label"><asp:Localize ID="ShippingLocalize" runat="server" Text="Shipping:"></asp:Localize></span>
 <span class="link"><asp:HyperLink ID="ShippingEstimateLink" runat="server" Text="Estimate" CssClass="button hyperLinkButton"></asp:HyperLink></span>
</div>

<div class="popupOuterWrapper">
<asp:Panel ID="ShippingEstimateDialog" runat="server" Style="display:none;" CssClass="modalPopup shipEstimatePopup">
	<asp:Panel ID="ShippingEstimateDialogHeader" runat="server" CssClass="header" EnableViewState="false">
		<asp:Localize ID="ShippingEstimateDialogCaption" runat="server" Text="Shipping Estimate" EnableViewState="false"></asp:Localize>
	</asp:Panel>
	<div class="popupContent">
		<asp:Panel ID="ShippingEstimatePanel" runat="server" CssClass="innerSection" DefaultButton="SubmitButton">
			<div class="content">
				<asp:Localize ID="phInstructionText" runat="server" Text="To estimate shipping charges for this order, enter the delivery address below."></asp:Localize><br />
				<asp:UpdatePanel ID="EstimateForm" runat="server" UpdateMode="Conditional">
					<ContentTemplate>
						<div class="validation">
						<asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Estimate" />
						</div>
						<div class="inputFieldRow">
						<asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country" CssClass="H2"></asp:Label>					
						<asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" AutoPostBack="true" Width="150px" />
						</div>
						<asp:PlaceHolder ID="phProvinceField" runat="server" Visible="false">
							<div class="inputFieldRow">
							<asp:Label ID="ProvinceLabel" runat="server" Text="State:" AssociatedControlID="Province" CssClass="H2"></asp:Label>
							<asp:RequiredFieldValidator ID="ProvinceRequired" runat="server" Text="*"
								ErrorMessage="State is required." Display="Static" ControlToValidate="Province" ValidationGroup="Estimate"></asp:RequiredFieldValidator>
							<asp:DropDownList ID="Province" runat="server" Width="150px"></asp:DropDownList>
							</div>
						</asp:PlaceHolder>
						<asp:PlaceHolder ID="phCityField" runat="server" Visible="false">
							<div class="inputFieldRow">
							<asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" CssClass="H2"></asp:Label>
							<asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
								ErrorMessage="City is required." Display="Static" ControlToValidate="City" ValidationGroup="Estimate"></asp:RequiredFieldValidator>
								<asp:TextBox ID="City" runat="server" MaxLength="30" Width="150px" ></asp:TextBox> 
							</div>
						</asp:PlaceHolder>
						<asp:PlaceHolder ID="phPostalCodeField" runat="server" Visible="false">
							<div class="inputFieldRow">
							<asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP Code:" AssociatedControlID="PostalCode" CssClass="H2"></asp:Label>
							<asp:PlaceHolder ID="phPostalCodeValidator" runat="server"></asp:PlaceHolder>
							<asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*" ErrorMessage="ZIP code is required."
								ControlToValidate="PostalCode" ValidationGroup="Estimate"></asp:RequiredFieldValidator>
							<asp:TextBox ID="PostalCode" runat="server" MaxLength="14" Width="150px"></asp:TextBox>
							</div>
						</asp:PlaceHolder>
						<div class="actions">
						<asp:Button ID="SubmitButton" Text="Go" runat="server" OnClick="SubmitButton_Click" ValidationGroup="Estimate"></asp:Button>
						<asp:Button ID="CancelButton" Text="Cancel" runat="server" CausesValidation="false"></asp:Button>
						</div>
						
						<asp:PlaceHolder ID="phResultPanel" runat="server" Visible="false">
							<div class="results">                        
							<asp:PlaceHolder ID="MultipleShipmentsMessage" runat="server" Visible="false">
								Your order contains items that must be sent in more than one shipment.<br />
							</asp:PlaceHolder>
							<asp:Repeater ID="ShipmentList" runat="server" OnItemDataBound="ShipmentList_ItemDataBound">
								<ItemTemplate>
									<asp:PlaceHolder ID="MultiShipmentHeader" runat="server" Visible="false">
										<b>Shipment <%# (Container.ItemIndex + 1) %>:</b><br />
										<asp:Label ID="ItemsCaption" runat="server" Text="Items" CssClass="fieldHeader"></asp:Label>
										<asp:Repeater ID="ItemsRepeater" runat="server" DataSource='<%#GetShipmentProducts(Container.DataItem)%>'>
											<HeaderTemplate><ul class="orderItemsList"></HeaderTemplate>
											<ItemTemplate><li><%#Eval("Quantity")%> of: <%#Eval("Name")%></li></ItemTemplate>
											<FooterTemplate></ul></FooterTemplate>
										</asp:Repeater>
									</asp:PlaceHolder>
									<asp:GridView ID="ShipRateGrid" runat="server" AutoGenerateColumns="false" Width="100%" GridLines="none">
										<Columns>
											<asp:BoundField DataField="Name" HeaderText="Method" HeaderStyle-HorizontalAlign="Left" />
											<asp:TemplateField HeaderText="Rate">
												<HeaderStyle HorizontalAlign="Right" />
												<ItemStyle HorizontalAlign="Right" />
												<ItemTemplate><%# ((decimal)Eval("TotalRate")).LSCurrencyFormat("ulc") %></ItemTemplate>
											</asp:TemplateField>
										</Columns>
										<EmptyDataTemplate>
											<asp:Label ID="NoShipRatesMessage" runat="server" Text="No shipping methods are available for the current items and/or the given destination."></asp:Label>
										</EmptyDataTemplate>
									</asp:GridView>
								</ItemTemplate>
							</asp:Repeater>
							</div>
						</asp:PlaceHolder>
					</ContentTemplate>
				</asp:UpdatePanel>
			</div>
		</asp:Panel>
	</div>
</asp:Panel>
</div>
<ajaxToolkit:ModalPopupExtender ID="ShippingEstimatePopup" runat="server" 
    TargetControlID="ShippingEstimateLink"
    CancelControlID="CancelButton"
    PopupControlID="ShippingEstimateDialog"
    BackgroundCssClass="modalBackground"                         
    DropShadow="false"
    PopupDragHandleControlID="ShippingEstimateHeader" />

</div>
