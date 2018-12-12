<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.People.Users.ViewHistoryDialog" CodeFile="ViewHistoryDialog.ascx.cs" %>
<div class="content"> 
    <asp:GridView ID="ViewsGrid" runat="server" SkinID="PagedList" AutoGenerateColumns="false" Width="100%">
        <Columns>
            <asp:TemplateField HeaderText="Date">
                <ItemStyle Width="150" />
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <%#Eval("ActivityDate")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Page">
                <HeaderStyle HorizontalAlign="Left" />
                <ItemTemplate>
                    <%#GetUri(Container.DataItem)%>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <asp:Label ID="NoRecordedPageViewsMessage" runat="server" Text="No recorded page views."></asp:Label>
        </EmptyDataTemplate>
    </asp:GridView>       
    <asp:HyperLink ID="CompleteHistoryLink" runat="server" Text="See All &raquo;"></asp:HyperLink>
</div>