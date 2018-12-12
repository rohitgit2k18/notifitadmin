<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderSummary.ascx.cs" Inherits="AbleCommerce.Admin.Dashboard.OrderSummary" EnableViewState="false" %>
<asp:UpdatePanel ID="OrderSummaryAjax" runat="server">
    <ContentTemplate>
        <div class="section orderSummary">
            <div class="header">
                <h2>Order Summary</h2>
                <div class="options">
                    <asp:DropDownList ID="DateRageList" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DateRageList_SelectedIndexChanged">
                        <asp:ListItem Text ="Today" Value="0" Selected="True" />
                        <asp:ListItem Text ="Last 7 Days" Value="7" />
                        <asp:ListItem Text ="Last 14 Days" Value="14" />
                        <asp:ListItem Text ="Last 30 Days" Value="30" />
                        <asp:ListItem Text ="Last 60 Days" Value="60" />
                        <asp:ListItem Text ="Last 90 Days" Value="90" />
                        <asp:ListItem Text ="Last 120 Days" Value="120" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="content">
        
                <asp:GridView ID="OrderSummaryGrid" runat="server" AutoGenerateColumns="false" ShowHeader="True" 
                    Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:HyperLink Id="StatusLink" runat="server" NavigateUrl='<%#string.Format("~/Admin/Orders/Default.aspx?OrderStatusId={0}&DateFilter={1}", Eval("StatusId"), GetSelectedDateFilter()) %>'  EnableViewState="false"><%#Eval("Status") %></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="No. Orders" ItemStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:HyperLink Id="NumbersLink" runat="server" NavigateUrl='<%#string.Format("~/Admin/Orders/Default.aspx?OrderStatusId={0}&DateFilter={1}", Eval("StatusId"), GetSelectedDateFilter()) %>'  EnableViewState="false"><%#Eval("Count")%></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Amount">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#((decimal)Eval("Total")).LSCurrencyFormat("lc")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate><asp:Localize ID="NoOrdersMessage" runat="server">No orders for specified dates.</asp:Localize></EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>