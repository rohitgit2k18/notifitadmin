<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.ViewSubscriptions" Title="View Subscriptions" CodeFile="ViewSubscriptions.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar2" TagPrefix="uc1" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Subscriptions - Order #{0}"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <cb:SortedGridView ID="SubscriptionGrid" runat="server" AutoGenerateColumns="False" SkinID="PagedList" AllowSorting="False" ShowWhenEmpty="False" AllowPaging="false" OnRowCommand="SubscriptionGrid_RowCommand" Width="100%" OnRowUpdating="SubscriptionGrid_RowUpdating"
            OnRowEditing="SubscriptionGrid_RowEditing" OnRowCancelingEdit="SubscriptionGrid_RowCancelingEdit" DataKeyNames="Id" >
            <Columns>
                <asp:TemplateField HeaderText="Plan">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:HyperLink ID="SubscriptionPlan" runat="server" text='<%# String.Format("{0} of: {1}", Eval("Quantity"), Eval("Name")) %>' NavigateUrl='<%#string.Format("../Products/EditSubscription.aspx?ProductId={0}", Eval("SubscriptionPlan.ProductId"))%>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Group">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="Group" runat="server" text='<%#GetGroupName(Eval("GroupId"))%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Active">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:CheckBox ID="Active" runat="server" Checked='<%#Eval("IsActive")%>' Enabled="False" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Next Payment">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="NextPayment" runat="server" text='<%#GetNextPayment(Container.DataItem)%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expiration">
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Label ID="Expiration" runat="server" text='<%#GetExpiration(Container.DataItem)%>'></asp:Label>
                        <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Visible='<%#((short)Eval("NumberOfPayments")) == 1 || ((bool)Eval("IsLegacy"))%>' ><span style="padding-left:10px; font-weight:bold;">EDIT</span></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <uc1:PickerAndCalendar2 ID="EditExpiration" runat="server" SelectedDate='<%# Bind("ExpirationDate") %>' /> 
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>                    
                    <ItemStyle HorizontalAlign="center" Width="150" />
                    <ItemTemplate>
                        <asp:LinkButton ID="ActivateLink" runat="server" visible='<%#(!(bool)Eval("IsActive"))%>' text="activate" SkinID="Button" CommandName="Activate" CommandArgument='<%#Eval("SubscriptionId")%>' />
                        <asp:LinkButton ID="DeactivateButton" runat="server" visible='<%#((bool)Eval("IsActive"))%>' text="Deactivate" SkinID="Button" CommandName="Deactivate" CommandArgument='<%#Eval("SubscriptionId")%>' />
                        <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#GetEditSubscriptionUrl(Container.DataItem) %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" /></asp:HyperLink>
                        <asp:LinkButton ID="CancelLink" runat="server"  SkinID="Link" CommandName="CancelSubscription" CommandArgument='<%#Eval("SubscriptionId")%>' OnClientClick='javascript:return confirm("Are you sure you want to cancel the subscription?")'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" /></asp:LinkButton>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:ImageButton ID="EditSaveButton" runat="server" CommandName="Update" SkinID="SaveIcon" ToolTip="Save"></asp:ImageButton>
                        <asp:ImageButton ID="EditCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" SkinID="CancelIcon" ToolTip="Cancel Editing"></asp:ImageButton>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyMessage" runat="server" Text="There are no subscriptions associated with this order."></asp:Label> 
            </EmptyDataTemplate>
        </cb:SortedGridView>
    </div>
</asp:Content>