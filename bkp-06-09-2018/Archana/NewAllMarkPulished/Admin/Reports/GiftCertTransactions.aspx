<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master"  Title="View Gift Certificate Transactions" Inherits="AbleCommerce.Admin.Reports.GiftCertTransactions" CodeFile="GiftCertTransactions.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Gift Certificate Transactions for '{0}'"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
	    <cb:SortedGridView ID="TransactionGrid" runat="server" DataKeyNames="GiftCertificateTransactionId"  Width="100%" SkinID="PagedList" AutoGenerateColumns="false">
		    <Columns>
			    <asp:TemplateField HeaderText="Transaction Date">
				    <ItemStyle VerticalAlign="Top" HorizontalAlign="Center"/>
				    <ItemTemplate>
					    <asp:Label ID="TransactionDate" runat="server" Text='<%# Eval("TransactionDate", "{0:g}") %>'></asp:Label>
				    </ItemTemplate>
			    </asp:TemplateField>
			    <asp:TemplateField HeaderText="Amount">
				    <ItemStyle VerticalAlign="Top" HorizontalAlign="Center"/>
				    <ItemTemplate>
					    <asp:Label ID="Amount" runat="server" Text='<%#((decimal)Eval("Amount")).LSCurrencyFormat("lc")%>'></asp:Label>
				    </ItemTemplate>
			    </asp:TemplateField>
			    <asp:TemplateField HeaderText="Order #">
				    <ItemStyle VerticalAlign="Top" HorizontalAlign="Center"/>
				    <ItemTemplate>
					    <asp:HyperLink ID="OrderLink" runat="server" Text='<%# GetOrderNumber(Container.DataItem)%>' NavigateUrl='<%# GetOrderLink(Container.DataItem)%>' Visible="<%# HasOrder(Container.DataItem) %>" >
					    </asp:HyperLink>
					    <asp:Label ID="OrderLinkNA" runat="server" Text='-' Visible="<%# !HasOrder(Container.DataItem) %>"></asp:Label>
				    </ItemTemplate>
			    </asp:TemplateField>
			    <asp:TemplateField HeaderText="Description">
                    <HeaderStyle HorizontalAlign="Left" />
				    <ItemStyle VerticalAlign="Top" HorizontalAlign="Left"/>
				    <ItemTemplate>
					    <asp:Label ID="Description" runat="server" Text='<%#Eval("Description")%>'></asp:Label>
				    </ItemTemplate>
			    </asp:TemplateField>
		    </Columns>
		    <EmptyDataTemplate>
			    <asp:Label ID="EmptyMessage" runat="server" Text="No transactions are associated with gift certificate."></asp:Label>
		    </EmptyDataTemplate>
	    </cb:SortedGridView>  
    </div>
</asp:Content>