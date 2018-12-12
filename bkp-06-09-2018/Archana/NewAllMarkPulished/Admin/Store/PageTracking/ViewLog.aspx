<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.PageTracking.ViewLog" Title="View Page Tracking Log"  CodeFile="ViewLog.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="View Page Tracking Log"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <cb:SortedGridView ID="PageViewsGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" 
            DataKeyNames="PageViewId" DataSourceID="PageViewDs" PageSize="20" 
            DefaultSortExpression="ActivityDate DESC" OnRowDataBound="PageViewsGrid_RowDataBound" SkinID="PagedList" Width="100%">
            <Columns>
                <asp:BoundField DataField="ActivityDate" HeaderText="Date" SortExpression="ActivityDate" />
                <asp:BoundField DataField="RemoteIP" HeaderText="IP" SortExpression="RemoteIP" />
                <asp:BoundField DataField="RequestMethod" HeaderText="Method" SortExpression="RequestMethod" />
                <asp:TemplateField HeaderText="Page" >                            
                    <ItemTemplate>                            
                        <div style="width:250px;height:40px;overflow:auto;vertical-align:middle;"><asp:Label ID="UriStem" runat="server" Text='<%#Eval("UriStem")%>'></asp:Label><wbr /><asp:Label ID="UriQuery" runat="server" Text='<%#GetQueryString(Eval("UriQuery"))%>'></asp:Label></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Time">
                    <ItemTemplate>
                        <asp:Label ID="TimeTaken" runat="server" Text='<%#Eval("TimeTaken", "{0}ms")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Referrer" HeaderText="Referrer" SortExpression="Referrer" />
                <asp:TemplateField HeaderText="Browser">
                    <ItemTemplate>
                        <asp:Label ID="Browser" runat="server" Text='<%#Eval("Browser")%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="User">
                    <ItemTemplate>
                        <asp:PlaceHolder ID="phUser" runat="server"></asp:PlaceHolder>
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
            OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" 
            TypeName="CommerceBuilder.Reporting.PageViewDataSource" SortParameterName="sortExpression"
            EnablePaging="true"></asp:ObjectDataSource>
    </div>
</asp:Content>