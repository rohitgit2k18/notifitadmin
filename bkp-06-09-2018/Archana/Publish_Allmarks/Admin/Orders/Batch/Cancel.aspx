<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.Batch.Cancel" Title="Invoices" CodeFile="Cancel.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Panel ID="CommentPanel" runat="server">
        <div class="pageHeader">
        	<div class="caption">
        		<h1><asp:Localize ID="Caption" runat="server" Text="Cancel Orders"></asp:Localize></h1>
    	    </div>
    	</div>
        <div class="content">
            <p>You have requested to <b>CANCEL</b> these orders: <asp:Label ID="OrderList" runat="server"></asp:Label></p>
            <asp:Label ID="CommentLabel" runat="server" Text="If desired, you can enter a comment or explanation below.  This comment will be attached to all orders."></asp:Label><br /><br />
            <asp:TextBox ID="Comment" runat="server" TextMode="MultiLine" Rows="4" Columns="50"></asp:TextBox><br />
            <asp:CheckBox ID="IsPrivate" runat="server" Text="Make comment private." /><br /><br />
            <asp:Button ID="CancelButton" runat="server" Text="Cancel OrderS" OnClick="CancelButton_Click" />
            <asp:HyperLink ID="BackButton" runat="server" Text="Back" SkinID="Button" NavigateUrl="../Default.aspx" /><br /><br />
            <asp:GridView ID="OrderGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="False"
                AllowSorting="false" AutoGenerateColumns="False" EnableViewState="false">
                <Columns>
                    <asp:TemplateField HeaderText="Order #" SortExpression="OrderNumber">
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:Label ID="OrderNumber" runat="server" Text='<%# Eval("OrderNumber") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" SortExpression="OrderStatusId">
                        <ItemStyle HorizontalAlign="center" Height="30px" />
                        <ItemTemplate>
                            <asp:Label ID="OrderStatus" runat="server" Text='<%# GetOrderStatus(Eval("OrderStatusId")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Customer" SortExpression="BillToLastName">
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:Label ID="CustomerName" runat="server" Text='<%# string.Format("{1}, {0}", Eval("BillToFirstName"), Eval("BillToLastName")) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount" SortExpression="TotalCharges">
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# ((decimal)Eval("TotalCharges")).LSCurrencyFormat("lc") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date" SortExpression="OrderDate">
                        <ItemStyle HorizontalAlign="center" />
                        <ItemTemplate>
                            <asp:Label ID="Label6" runat="server" Text='<%# Eval("OrderDate", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Payment">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phPaymentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="PaymentStatus" runat="server" Text='<%# GetPaymentStatus(Container.DataItem) %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Shipment">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        <ItemTemplate>
                            <asp:PlaceHolder ID="phShipmentStatus" runat="server"></asp:PlaceHolder>
                            <asp:Label ID="ShipmentStatus" runat="server" Text='<%# Eval("ShipmentStatus") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>
    <asp:Panel ID="ConfirmPanel" runat="server" Visible="false">
		<div class="pageHeader">
			<div class="caption">
				<h1><asp:Localize ID="Caption2" runat="server" Text="Cancel Orders"></asp:Localize></h1>
        	</div>
        </div>
        <div class="content">
            The selected orders have been cancelled: <asp:Label ID="OrderList2" runat="server"></asp:Label>
            <asp:HyperLink ID="FinishButton" runat="server" Text="Finish" SkinID="Button" NavigateUrl="../Default.aspx" /><br /><br />
        </div>
    </asp:Panel>
</asp:Content>