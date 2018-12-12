<%@ Page Language="C#" MasterPageFile="../Admin.master" Inherits="AbleCommerce.Admin._Payment.AddGateway" Title="Add Gateway"  CodeFile="AddGateway.aspx.cs" %>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Add Payment Gateway"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <asp:GridView ID="ProviderList" runat="server" SkinID="PagedList" 
            AutoGenerateColumns="false" Width="100%" OnRowCommand="ProviderList_RowCommand">
            <Columns>
                <asp:TemplateField>
                    <ItemStyle Width="50px" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:ImageButton ID="AddLink" runat="server" SkinID="AddIcon" CommandName="Add" CommandArgument='<%# Eval("ClassId") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Name" DataField="Name" HeaderStyle-HorizontalAlign="Left" />
                <asp:BoundField HeaderText="Supported Transactions" DataField="SupportedTransactions" HeaderStyle-HorizontalAlign="Left" />
            </Columns>
            <EmptyDataTemplate>
                <asp:Localize ID="EmptyDataMessage" runat="server" Text="There are no gateways available to be added."></asp:Localize>
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:HyperLink ID="CancelLink" runat="server" NavigateUrl="Gateways.aspx" Text="Cancel" SkinID="CancelButton"></asp:HyperLink>
    </div>
</asp:Content>