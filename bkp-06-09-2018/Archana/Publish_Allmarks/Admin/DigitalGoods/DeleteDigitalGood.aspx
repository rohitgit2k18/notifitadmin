<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.DigitalGoods.DeleteDigitalGood" Title="Delete Digital Good" CodeFile="DeleteDigitalGood.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Delete {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="grid_6 alpha">   
        <div class="mainColumn">
            <div class="content">
                <asp:Localize ID="InstructionText" runat="server" Text="<p>WARNING: When you delete a digital good, it can no longer be downloaded by customers who have purchased it.  Serial keys assigned to existing orders will be preserved and can still be viewed, but any serial keys NOT assigned will be deleted.</p>" EnableViewState="false"></asp:Localize>
                <asp:PlaceHolder ID="DeleteAllowedPanel" runat="server">
                    <asp:Localize ID="DeleteFileText" runat="server" Text="<p>To also delete the physical file associated with this digital good, check the box below.</p>" EnableViewState="false"></asp:Localize>
                    <asp:CheckBox ID="DeleteFile" runat="server" Text="Delete File {0}" /><br /><br />
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="DeletePreventedPanel" runat="server" EnableViewState="false">
                    <asp:Localize ID="NoDeleteFileText" runat="server" Text="<p>NOTE: The physical file ({0}) linked to digital good will be preserved because it is also linked to other digital goods.</p>" EnableViewState="false"></asp:Localize>
                </asp:PlaceHolder>
                <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClick="DeleteButton_Click" />
                <asp:HyperLink ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="DigitalGoods.aspx" />
            </div>
        </div>
    </div>
    <div class="grid_6 omega">   
        <div class="leftColumn">
            <div class="section">
                <div class="header">
                    <h2 class="commonicon"><asp:Localize ID="ProductsCaption" runat="server" Text="Associated Products"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:GridView ID="ProductsGrid" runat="server" AllowPaging="False" 
                        AllowSorting="False" AutoGenerateColumns="False" SkinID="PagedList"
                        Width="100%" EnableViewState="false" ShowHeader="false">
                        <Columns>
                            <asp:TemplateField HeaderText="Product" SortExpression="Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <a href="../Products/DigitalGoods/DigitalGoods.aspx?ProductId=<%#Eval("ProductId")%>"><%#Eval("Product.Name")%></a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyMessage" runat="server" Text="There are no products associated with this readme."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
            <div class="section">
                <div class="header">
                    <h2 class="commonicon"><asp:Localize ID="OrdersCaption" runat="server" Text="Associated Orders"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:GridView ID="OrderGrid" runat="server" AutoGenerateColumns="False"
                        SkinID="PagedList" AllowPaging="False" AllowSorting="false" Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="Order #">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <a href="../Orders/ViewDigitalGoods.aspx?OrderNumber=<%#Eval("OrderNumber")%>"><%# Eval("OrderNumber") %></a>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="OrderDate" HeaderText="Order Date" ItemStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="Customer">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <%# Eval("BillToLastName") %>, <%# Eval("BillToFirstName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyDataMessage" runat="server" Text="There are no orders associated with this digital good."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

