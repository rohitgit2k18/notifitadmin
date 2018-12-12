<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Orders.ViewOrder" Title="View Order" CodeFile="ViewOrder.aspx.cs" %>
<%@ Register Src="../UserControls/OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<%@ Register Src="../UserControls/OrderTotalSummary.ascx" TagName="OrderTotalSummary" TagPrefix="uc" %>
<%@ Register Src="OrderShipmentSummary.ascx" TagName="OrderShipmentSummary" TagPrefix="uc" %>
<%@ Register assembly="wwhoverpanel" Namespace="Westwind.Web.Controls" TagPrefix="wwh" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Summary - Order #{0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="OrderAjax" runat="server">
        <ContentTemplate>
            <cb:Notification ID="OrderStatusUpdatedMessage" runat="server" Text="Order status updated to {0}." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
            <div class="grid_4 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="BillingAddressCaption" runat="server" Text="Billing Address"></asp:Localize></h2>
                        </div>
                        <div class="content height">
                            <asp:HyperLink ID="PrintButton" runat="server" Text="Print Invoice" SkinID="Button"></asp:HyperLink>
                             <br /><br />
                            <asp:Label ID="OrderDateLabel" runat="server" Text="Order Date:" SkinID="FieldHeader"></asp:Label>
                            <asp:Label ID="OrderDate" runat="server" Text=""></asp:Label><br />
                            <asp:Label ID="OrderStatusLabel" runat="server" Text="Order Status:" SkinID="FieldHeader"></asp:Label>
                            <asp:Literal ID="OrderStatus" runat="server"></asp:Literal>&nbsp;&nbsp;&nbsp;
                            <asp:HyperLink ID="ChangeStatusButton" runat="server" Text="Change Status" NavigateUrl="#" SkinID="Link" /><br /><br />
                            <asp:Literal ID="BillingAddress" runat="server"></asp:Literal>
                            <br />
                            <asp:Localize Id="BillToEmailLabel" runat="server" Text="Email: "></asp:Localize>
                            <asp:HyperLink ID="BillToEmail" runat="server" NavigateUrl="Email/SendMail.aspx" SkinID="Link" EnableViewState="false"></asp:HyperLink><br />                            
                            <asp:Localize ID="BillToPhone" runat="server" Text="Phone: {0}<br />" />
                            <asp:Localize ID="BillToFax" runat="server" Text="Fax: {0}<br />" />
                            <asp:PlaceHolder ID="TaxExemptionPanel" runat="server" Visible="false" EnableViewState="false">
                                <br />
                                <asp:Label ID="TaxExemptionTypeLabel" runat="server" Text="Tax Exemption: " SkinID="FieldHeader"></asp:Label>
                                <asp:Literal ID="TaxExemptionType" runat="server"></asp:Literal>
                                <asp:Localize ID="TaxExemptionReference" runat="server" Text=" ({0})" Visible="false"></asp:Localize>
                            </asp:PlaceHolder>
                            <asp:HyperLink ID="MoveOrderButton" runat="server" Text="Move Order" CausesValidation="false" SkinID="Button" NavigateUrl="MoveOrder.aspx?OrderNumber={0}" EnableViewState="false" /> <br/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_4">
                <div class="middleColumn">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="ShippingAddressCaption" runat="server" Text="Shipping Information"></asp:Localize></h2>
                        </div>
                        <div class="content height">
                            <uc:OrderShipmentSummary ID="OrderShipmentSummary" runat="server"></uc:OrderShipmentSummary>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_4 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="PaymentInfoCaption" runat="server" Text="Payment Information"></asp:Localize></h2>
                        </div>
                        <div class="content height">
                            <asp:Label ID="OrderTotalLabel" runat="server" Text="Order Total:" SkinID="FieldHeader"></asp:Label>
                            <asp:Label ID="OrderTotal" runat="server"></asp:Label><br />
                            <asp:Label ID="OrderBalanceCaption" runat="server" Text="Balance:" SkinID="FieldHeader"></asp:Label>
			                <asp:Label ID="OrderBalance" runat="server" Text="{0}"></asp:Label><br />
                            <asp:Label ID="CurrentPaymentStatusLabel" runat="server" Text="Payment Status: " SkinID="FieldHeader"></asp:Label>
                            <asp:Label ID="CurrentPaymentStatus" runat="server"></asp:Label><br /><br />
                            <asp:PlaceHolder ID="LastPaymentPanel" runat="server">
                                <asp:Label ID="LastPaymentReferenceLabel" runat="server" Text="Last Payment: " SkinID="FieldHeader"></asp:Label>
                                <asp:Literal ID="LastPaymentReference" runat="server"></asp:Literal><br />
                                <asp:Label ID="LastPaymentAmountLabel" runat="server" Text="Amount: "></asp:Label><asp:Label ID="LastPaymentAmount" runat="server" Text=""></asp:Label><br />
                                <asp:Label ID="LastPaymentStatusLabel" runat="server" Text="Status: "></asp:Label><asp:Label ID="LastPaymentStatus" runat="server" Text=""></asp:Label><br />
                                <asp:PlaceHolder ID="TransactionPanel" runat="server">
                                    <asp:Label ID="LastPaymentAVSLabel" runat="server" Text="AVS: "></asp:Label><asp:Label ID="LastPaymentAVS" runat="server" Text=""></asp:Label><br />
                                    <asp:Label ID="LastPaymentCVVLabel" runat="server" Text="CVV: "></asp:Label><asp:Label ID="LastPaymentCVV" runat="server" Text=""></asp:Label><br />
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="ButtonPanel" runat="server">
                                    <asp:LinkButton ID="ReceivedButton" runat="server" Text="Received" OnClick="ReceivedButton_Click" SkinID="Button"></asp:LinkButton>
                                    <asp:HyperLink ID="CaptureLink" runat="server" SkinID="Button" Text="Capture"></asp:HyperLink>
                                    <asp:HyperLink ID="VoidLink" runat="server" SkinID="Button" Text="Void"></asp:HyperLink>
                                </asp:PlaceHolder><br />
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="TaxExemptionMessagePanel" runat="server" Visible="false">
                                <asp:Label ID="TaxExemptionMessage" runat="server" Text="NOTE: Tax exemption applied to order." CssClass="helpText"></asp:Label><br />
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="CustomerIPPanel" runat="server">
                                <asp:Label ID="CustomerIPLabel" runat="server" Text="Customer IP: " SkinID="FieldHeader"></asp:Label>
                                <asp:Label ID="CustomerIP" runat="server" Text=""></asp:Label>&nbsp;
                                <asp:Label ID="CustomerIPBlocked" runat="server" Text="BLOCKED" CssClass="errorCondition"></asp:Label>
                                <asp:ImageButton ID="BlockCustomerIP" runat="server" SkinID="BlockIcon" AlternateText="Block IP" OnClientClick="return confirm('Are you sure you want to block the IP {0}? This may take up to 30 minutes to take effect.')" OnClick="BlockCustomerIP_Click" ToolTip="Click here to block customer IP. This may take up to 30 minutes to take effect." /><br />
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="OrderReferrerPanel" runat="server">
                                <asp:Label ID="OrderReferrerLabel" runat="server" Text="Referring URL: " SkinID="FieldHeader"></asp:Label>
                                <asp:HyperLink ID="OrderReferrer" runat="server" SkinID="Link" Target="_blank"></asp:HyperLink><br />
                            </asp:PlaceHolder>
                            <asp:PlaceHolder ID="AffiliatePanel" runat="server">
                                <asp:Label ID="AffiliateLabel" runat="server" Text="Affiliate: " SkinID="FieldHeader"></asp:Label>
                                <asp:Label ID="Affiliate" runat="server"></asp:Label><br />
                            </asp:PlaceHolder>
                        </div>
                    </div>
                </div>
            </div>
            <script type="text/javascript">
                $(document).ready(function () {
                    $(".height").equalHeights();
                });
            </script>
            <div class="clear"></div>
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="OrderContentsCaption" runat="server" Text="Order Contents"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:GridView ID="OrderItemGrid" runat="server" AutoGenerateColumns="False" 
                        DataKeyNames="Id" SkinID="PagedList" CellPadding="4" CellSpacing="0"
                        Width="100%" OnDataBinding="OrderItemGrid_DataBinding">
                        <Columns>
                            <asp:TemplateField HeaderText="SKU" SortExpression="Sku">
                                <ItemStyle HorizontalAlign="center" />
                                <ItemTemplate>
                                    <asp:Label ID="Sku" runat="server" Text='<%# AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem) %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                <ItemTemplate>
					                <asp:HyperLink ID="GiftCertsLink" runat="server" Visible='<%# IsGiftCert(Container.DataItem) %>'
                                        NavigateUrl='<%# String.Format("ViewGiftCertificates.aspx?OrderNumber={0}", Eval("Order.OrderNumber")) %>'>
                                        <asp:Image ID="GiftCertIcon" runat="server" SkinID="GiftCertIcon" AlternateText="View Gift Certificates" ToolTip="View Gift Certificates" />
                                   </asp:HyperLink>
					                <asp:HyperLink ID="DigitalGoodsLink" runat="server" Visible='<%# IsDigitalGood(Container.DataItem) %>'
                                        NavigateUrl='<%# String.Format("ViewDigitalGoods.aspx?OrderNumber={0}", Eval("Order.OrderNumber")) %>'>
                                        <asp:Image ID="DigitalGoodIcon" runat="server" SkinID="DigitalGoodIcon" AlternateText="View Digital Goods" ToolTip="View Digital Goods"/>
                                   </asp:HyperLink>
                                    <uc:OrderItemDetail ID="OrderItemDetail1" runat="server" OrderItem='<%#(OrderItem)Container.DataItem%>' ShowAssets="False" LinkProducts="True" />                                    
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tax">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="40px" />
                                <ItemTemplate>
                                    <%#TaxHelper.GetTaxRate((Order)Eval("Order"), (OrderItem)Container.DataItem).ToString("0.####")%>%
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Price" SortExpression="Price" ItemStyle-HorizontalAlign="right">
                                <ItemTemplate>
                                    <asp:Label ID="Price" runat="server" Text='<%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Quantity" SortExpression="Quantity" ItemStyle-HorizontalAlign="center">
                                <ItemTemplate>
                                    <asp:Label ID="Quantity" runat="server" Text='<%# Eval("Quantity") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Total" SortExpression="ExtendedPrice" ItemStyle-HorizontalAlign="right">
                                <ItemTemplate>
                                    <asp:Label ID="ExtendedPrice" runat="server" Text='<%# ((decimal)Eval("ExtendedPrice")).LSCurrencyFormat("lc") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <uc:OrderTotalSummary ID="OrderTotalSummary1" runat="server" ShowTitle="false" />
                </div>
            </div>
            <ajaxToolkit:ModalPopupExtender ID="ChangeStatusPopup" runat="server" TargetControlID="ChangeStatusButton"
                PopupControlID="ChangeStatusDialog" BackgroundCssClass="modalBackground" CancelControlID="ChangeStatusCancelButton"
                DropShadow="true" PopupDragHandleControlID="ChangeStatusHeader" />
            <asp:Panel ID="ChangeStatusDialog" runat="server" Style="display:none; width:400px" CssClass="modalPopup">
                <asp:Panel ID="ChangeDefaultHeader" runat="server" CssClass="modalPopupHeader">
                    <h2>
                        <asp:Localize ID="ChangeStatusCaption" runat="server" Text="Change Status"></asp:Localize>
                    </h2>
                </asp:Panel>
                <div class="content">
                    <p><asp:Localize ID="ChangeStatusHelpText" runat="server" Text="Select the new status for this order:"></asp:Localize></p>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="NewStatusLabel" runat="server" Text="New Status:" AssociatedControlID="NewStatus" />
                            </th>
                            <td>
                                <asp:DropDownList ID="NewStatus" runat="server" DataTextField="Name" DataValueField="Id">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="ChangeStatusOKButton" runat="server" Text="Ok" OnClick="ChangeStatusOKButton_Click" />
                                <asp:Button ID="ChangeStatusCancelButton" runat="server" Text="Cancel" SkinID="CancelButton" CausesValidation="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

