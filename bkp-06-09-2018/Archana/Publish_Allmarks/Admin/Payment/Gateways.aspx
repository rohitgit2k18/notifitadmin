<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Payment.Gateways" Title="Payment Gateways"  CodeFile="Gateways.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Payment Gateways"></asp:Localize></h1>
	        <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/payments" />
    	</div>
    </div>
    <div class="content">
        <asp:HyperLink ID="AddGateway" runat="server" Text="Add Payment Gateway" NavigateUrl="AddGateway.aspx" SkinId="AddButton"></asp:HyperLink>
        <p><asp:Localize ID="InstructionText" runat="server" Text="A payment gateway is required to accept real-time credit card transactions."></asp:Localize></p>
        <asp:GridView ID="GatewayGrid" runat="server" DataKeyNames="Id" AutoGenerateColumns="false"
                    Width="100%" SkinID="PagedList"
                    OnRowDeleting="GatewayGrid_RowDeleting">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="Name" HeaderStyle-HorizontalAlign="left" ReadOnly="true" ItemStyle-HorizontalAlign="left" />
                <asp:TemplateField HeaderText="Payment Methods">
                    <HeaderStyle HorizontalAlign="left" />
                    <ItemStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <asp:Label ID="PaymentMethods" runat="server" Text='<%#GetPaymentMethods(Container.DataItem)%>'></asp:Label><br />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle HorizontalAlign="Center" Width="54px" Wrap="false" />
                    <ItemTemplate>
                        <asp:HyperLink ID="EditButton" runat="server" NavigateUrl='<%#Eval("PaymentGatewayId", "EditGateway.aspx?PaymentGatewayId={0}") %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
                        <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyMessage" runat="server" Text="No payment gateways are defined for your store."></asp:Label>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>