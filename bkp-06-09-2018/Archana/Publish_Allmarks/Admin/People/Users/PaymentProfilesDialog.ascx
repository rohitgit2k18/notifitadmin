<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PaymentProfilesDialog.ascx.cs" Inherits="AbleCommerce.Admin.People.Users.PaymentProfiles" %>
<div class="content">   
    <asp:UpdatePanel ID="PaymentProfilesAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>        
        <cb:SortedGridView ID="PaymentProfileGrid" runat="server" SkinID="PagedList" Width="100%" AllowPaging="True" PageSize="10" 
            AutoGenerateColumns="False" EnableViewState="True">
            <Columns>                
                <asp:TemplateField HeaderText="Name" SortExpression="NameOnCard">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="NameOnCard" runat="server" Text='<%# Eval("NameOnCard") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Reference #" SortExpression="ReferenceNumber">
                    <ItemStyle HorizontalAlign="center" Height="30px" />
                    <ItemTemplate>
                        <%# Eval ("InstrumentType") %> <%# Eval ("ReferenceNumber") %>
                    </ItemTemplate>
                </asp:TemplateField>                
                <asp:TemplateField HeaderText="Expiration" SortExpression="Expiry">
                    <ItemStyle HorizontalAlign="center" />
                    <ItemTemplate>
                        <asp:Label ID="Expiration" runat="server" Text='<%#GetExpirationDate(Container.DataItem)%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyMessage" runat="server" Text="No payment gateway profiles for this user."></asp:Label>
            </EmptyDataTemplate>
        </cb:SortedGridView>   
        </ContentTemplate>
    </asp:UpdatePanel>   
</div>