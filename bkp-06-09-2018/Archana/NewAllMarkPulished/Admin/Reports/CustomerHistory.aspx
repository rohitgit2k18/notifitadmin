<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.CustomerHistory" Title="Customers History"  CodeFile="CustomerHistory.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
	<div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption" runat="server" Text="Navigation History for {0}"></asp:Localize></h1>
		</div>
	</div>
    <div class="content">
        <cb:SortedGridView ID="PageViewsGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" DataKeyNames="PageViewId" 
            DataSourceID="PageViewDs" PageSize="20" DefaultSortExpression="ActivityDate DESC" OnRowDataBound="PageViewsGrid_RowDataBound" SkinID="PagedList" Width="100%">
            <Columns>
                <asp:BoundField DataField="ActivityDate" HeaderText="Date" SortExpression="ActivityDate" />
                <asp:BoundField DataField="RemoteIP" HeaderText="IP" SortExpression="RemoteIP" />
                <asp:BoundField DataField="RequestMethod" HeaderText="Method" SortExpression="RequestMethod" />
                <asp:TemplateField HeaderText="Page">
                    <ItemTemplate>
                        <%#GetUri(Container.DataItem)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Time">
                    <ItemTemplate>
                        <%#Eval("TimeTaken", "{0}ms")%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Referrer" HeaderText="Referrer" SortExpression="Referrer" />
                <asp:TemplateField HeaderText="Browser">
                    <ItemTemplate>
                        <%#Eval("Browser")%>
                    </ItemTemplate>
                </asp:TemplateField>                        
                <asp:TemplateField HeaderText="Item">
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phCatalogNode" runat="server"></asp:PlaceHolder>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </cb:SortedGridView>
        <asp:ObjectDataSource ID="PageViewDs" runat="server" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="LoadForUser" SelectCountMethod="CountForUser"
            TypeName="CommerceBuilder.Reporting.PageViewDataSource" SortParameterName="sortExpression"
            EnablePaging="True">
            <SelectParameters>
                <asp:QueryStringParameter Name="userId" QueryStringField="UserId" Type="Object" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
</asp:Content>