<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.BasketShippingEstimate" EnableViewState="false" CodeFile="BasketShippingEstimate.ascx.cs" ClientIDMode="Predictable" %>
<%-- 
<conlib>
<summary>Implements the shipping estimate control for a basket.</summary>
<param name="ShowCity" default="False">If true city field is displayed</param>
<param name="Caption" default="Shipping Estimate">The caption to show for the shipping estimate section</param>
<param name="InstructionText" default="To estimate shipping charges, enter the delivery information below.">The instruction text to show for the shipping estimate section</param>
<param name="AssumeCommercialRates" default="False">If true commercial rates are assumed</param>
</conlib>
--%>
<asp:UpdatePanel ID="EstimateForm" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <asp:Panel ID="ShippingEstimatePanel" runat="server" CssClass="widget basketShippingEstimateWidget" DefaultButton="SubmitButton">
	        <div class="innerSection">
                <div class="header">
                    <h2><asp:Localize ID="phCaption" runat="server" Text="Shipping Estimate"></asp:Localize></h2>
                </div>
                <div class="content">
                    <p>
                        <asp:Localize ID="phInstructionText" runat="server" Text="To estimate shipping charges, enter the delivery information below."></asp:Localize>
                    </p>	
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Estimate" />
                    <table class="compact">
				        <tr>
                            <th>
                                <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country"></asp:Label>
                            </th>
                            <td>
                                <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" AutoPostBack="true" Width="120px" />
                            </td>
				        </tr>
                        <tr ID="phProvinceField" runat="server" Visible="false">
                            <th>
                                <asp:Label ID="ProvinceLabel" runat="server" Text="State:" AssociatedControlID="Province"></asp:Label>
                            </th>
                            <td>
                                <asp:DropDownList ID="Province" runat="server" Width="120px"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="ProvinceRequired" runat="server" Text="*"
                                    ErrorMessage="State is required." Display="Static" ControlToValidate="Province" ValidationGroup="Estimate"></asp:RequiredFieldValidator>
					        </td>
                        </tr>
                        <tr ID="phCityField" runat="server" Visible="false">
                            <th>
                                <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" CssClass="H2"></asp:Label>
                                <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                    ErrorMessage="City is required." Display="Static" ControlToValidate="City" ValidationGroup="Estimate"></asp:RequiredFieldValidator>
                            </th>
                            <td>
                                <asp:TextBox ID="City" runat="server" MaxLength="30" Width="120px"></asp:TextBox> 
					        </td>
                        </tr>
                        <tr ID="phPostalCodeField" runat="server" Visible="false">
                            <th>
                                <asp:Label ID="PostalCodeLabel" runat="server" Text="Postal:" AssociatedControlID="PostalCode" CssClass="H2"></asp:Label>
                            </th>
                            <td>
                                <asp:TextBox ID="PostalCode" runat="server" MaxLength="14" Width="100px"></asp:TextBox>
                                <asp:PlaceHolder ID="phPostalCodeValidator" runat="server"></asp:PlaceHolder>
                                <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*" ErrorMessage="ZIP code is required."
                                    ControlToValidate="PostalCode" ValidationGroup="Estimate"></asp:RequiredFieldValidator>
					        </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="SubmitButton" Text="Calculate" runat="server" OnClick="SubmitButton_Click" ValidationGroup="Estimate" CssClass="button"></asp:Button>
                            </td>
                        </tr>
                    </table>
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
                </div>
	        </div>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>