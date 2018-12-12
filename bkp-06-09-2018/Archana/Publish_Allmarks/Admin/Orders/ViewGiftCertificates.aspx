<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.ViewGiftCertificates" Title="Gift Certificates" CodeFile="ViewGiftCertificates.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Gift Certificates"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <asp:GridView ID="GiftCertificatesGrid" runat="server" AutoGenerateColumns="false" AllowPaging="false" 
            AllowSorting="false" DataKeyNames="Id" OnRowCommand="GiftCertificatesGrid_RowCommand" 
            OnRowDeleting="GiftCertificatesGrid_RowDeleting" SkinID="PagedList" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Serial Number" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="SerialNumber" runat="server" Text='<%#Eval("SerialNumber")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Balance" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="Balance" runat="server" Text='<%# ((decimal)Eval("Balance")).LSCurrencyFormat("lc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Created" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Label ID="CreateDate" runat="server" Text='<%# Eval("CreateDate", "{0:d}") %>' Visible='<%#(DateTime)Eval("CreateDate") != System.DateTime.MinValue%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expires" ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
				    <asp:Label ID="ExpirationDate" runat="server" Text='<%# Eval("ExpirationDate", "{0:d}") %>' Visible='<%#(DateTime)Eval("ExpirationDate") != System.DateTime.MinValue%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Comment" HeaderStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <%#Eval("Name")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:Button ID="Activate" runat="Server" Text="Activate" CommandName="Activate" CommandArgument='<%#Container.DataItemIndex%>' Visible='<%#!HasSerialKey(Container.DataItem)%>' />
                        <asp:Button ID="Deactivate" runat="Server" Text="Deactivate" CommandName="Deactivate" CommandArgument='<%#Container.DataItemIndex%>' Visible='<%#HasSerialKey(Container.DataItem)%>' />
					    <asp:HyperLink ID="EditButton" runat="server" NavigateUrl='<%# GetEditUrl(Container.DataItem) %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
					    <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" />
					    <asp:HyperLink ID="ViewGiftCertLink" runat="server" NavigateUrl='<%# Eval("GiftCertificateId", "ViewGiftCertificate.aspx?GiftCertificateId={0}") %>'><asp:Image ID="GiftCertIcon" runat="server" SkinID="GiftCertIcon" AlternateText="Gift Certificate" /></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyDataMessage" runat="server" Text="There are no Gift Certificates associated with this order."></asp:Label>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>