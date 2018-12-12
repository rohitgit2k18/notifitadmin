<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.OrderStatuses._Default" Title="Manage Order Statuses"  CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Order Statuses"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
    	</div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="You can configure the statuses that can be assigned to orders in your store.  Statuses can be assigned to orders automatically through the use of event rules, or they can be assigned manually.  You may also sort them but note that sort order only impacts the merchant administration.  Sort order has no bearing on what will be displayed to customers."></asp:Localize></p>
        <asp:UpdatePanel ID="GridPanel" runat="server">
            <ContentTemplate>
                <cb:SortedGridView runat="server" ID="StatusGrid" AutoGenerateColumns="False" AllowSorting="False" SkinID="PagedList"
                    DataKeyNames="OrderStatusId" width="100%" DataSourceID="OrderStatusDs" OnRowCommand="StatusGrid_RowCommand"
                    DefaultSortExpression="OrderBy">
                    <Columns>
                        <asp:TemplateField HeaderText="Sort">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:ImageButton ID="MU" runat="server" SkinID="UpIcon" CommandName="MoveUp" ToolTip="Move Up" CommandArgument='<%#Eval("Id")%>' />
                                <asp:ImageButton ID="MD" runat="server" SkinID="DownIcon" CommandName="MoveDown" ToolTip="Move Down" CommandArgument='<%#Eval("Id")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Name" DataField="Name" SortExpression="Name" HeaderStyle-HorizontalAlign="Left" />
                        <asp:TemplateField HeaderText="Report" ItemStyle-HorizontalAlign="Center" >
                            <ItemTemplate>
                                <%#GetX(Eval("IsActive"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cancelled" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <%#GetX(!(bool)Eval("IsValid"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Stock" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <%#Eval("InventoryAction")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Triggers" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <%#GetTriggers(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="center" Width="60px" />
                            <ItemTemplate>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#Eval("OrderStatusId", "EditOrderStatus.aspx?OrderStatusId={0}")%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" /></asp:HyperLink>
                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' Visible='<%# !HasOrders(Container.DataItem) %>' />
                                <asp:HyperLink ID="DeleteLink" runat="server" NavigateUrl='<%# Eval("OrderStatusId", "DeleteOrderStatus.aspx?OrderStatusId={0}")%>' Visible='<%# HasOrders(Container.DataItem) %>'><asp:Image ID="DeleteIcon2" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:label runat="server" id="NoStatusesDefinedLabel" EnableViewState="false" Text="No order statuses have been defined." />
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:HyperLink ID="AddOrderStatusLink" runat="server" Text="Add Order Status" NavigateUrl="AddOrderStatus.aspx" SkinID="Button"></asp:HyperLink>
    </div>
    <asp:ObjectDataSource ID="OrderStatusDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Orders.OrderStatusDataSource" SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Orders.OrderStatus" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
    </asp:ObjectDataSource>
</asp:Content>

