<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.Batch.Ship" CodeFile="Ship.aspx.cs" %>
<%@ Register Namespace="Westwind.Web.Controls" assembly="wwhoverpanel" TagPrefix="wwh" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:Panel ID="UpdatePanel" runat="server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Ship Orders"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        You have requested to ship these orders: <asp:Label ID="OrderList" runat="server"></asp:Label>
        <asp:Panel ID="InvalidOrdersPanel" runat="server">
            WARNING: These orders do not currently have unshipped shipments: <asp:Label ID="InvalidOrderList" runat="server"></asp:Label>
        </asp:Panel>
        <asp:GridView ID="ShipmentGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="False"
            AllowSorting="false" AutoGenerateColumns="False" DataKeyNames="Id" EnableViewState="false">
            <Columns>
                <asp:TemplateField HeaderText="Order #">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="OrderNumber" runat="server" Text='<%# Eval("Order.OrderNumber") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Shipment #">
                    <ItemStyle HorizontalAlign="center" Height="30px" />
                    <ItemTemplate>
                        <asp:HyperLink ID="ShipmentNumber" runat="server" Text='<%# Eval("ShipmentNumber") %>' SkinID="Link" NavigateUrl="#" OnMouseOver='<%# Eval("OrderShipmentId", "ShipmentHoverLookupPanel.startCallback(event, \"OrderShipmentId={0}\", null, null);")%>' OnMouseOut="ShipmentHoverLookupPanel.hide();"></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Bill To">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="BillToName" runat="server" Text='<%# string.Format("{1}, {0}", Eval("Order.BillToFirstName"), Eval("Order.BillToLastName")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Ship To">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="ShipToName" runat="server" Text='<%# string.Format("{1}, {0}", Eval("ShipToFirstName"), Eval("ShipToLastName")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Ship Date">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:TextBox ID="ShipDate" runat="server" MaxLength="10" Text='<%# LocaleHelper.LocalNow.ToString("MM/dd/yyyy") %>' Width="80px"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Tracking #">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:DropDownList ID="ShipGateway" runat="server" DataTextField="Name" DataValueField="ShipGatewayId" AppendDataBoundItems="true" DataSourceID="ShipGatewayDs">
                            <asp:ListItem Value="" Text=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="TrackingNumber" runat="server" MaxLength="50" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:ObjectDataSource ID="ShipGatewayDs" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.ShipGatewayDataSource">
        </asp:ObjectDataSource>
        <asp:Button ID="ShipButton" runat="server" Text="Ship Orders" OnClick="ShipButton_Click" />
        <asp:HyperLink ID="BackButton" runat="server" Text="Back" SkinID="Button" NavigateUrl="../Default.aspx" />
    </div>
</asp:Panel>
<asp:Panel ID="ConfirmPanel" runat="server" Visible="false">
	<div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption2" runat="server" Text="Ship Orders"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <p>The selected orders have been shipped.</p>
        <asp:HyperLink ID="FinishButton" runat="server" Text="Finish" SkinID="Button" NavigateUrl="../Default.aspx" /><br /><br />
    </div>
</asp:Panel>
<wwh:wwHoverPanel ID="ShipmentHoverLookupPanel"
    runat="server" 
    serverurl="~/Admin/Orders/ShipmentSummary.ashx"
    Navigatedelay="100"
    scriptlocation="WebResource"
    style="display: none; background: white;"
    panelopacity="0.89"
    shadowoffset="8"
    shadowopacity="0.18"
    PostBackMode="None"
    Closable="false"
    AdjustWindowPosition="true">
</wwh:wwHoverPanel>
</asp:Content>