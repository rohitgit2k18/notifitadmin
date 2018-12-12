<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Security.AuditLog" Title="View Audit Log"  CodeFile="AuditLog.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
	<div class="pageHeader">
		<div class="caption">
			<h1><asp:Localize ID="Caption" runat="server" Text="View Audit Log" EnableViewState="false"></asp:Localize></h1>
            		<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/system" />
		</div>
	</div>
    <div class="content">
        <asp:UpdatePanel ID="AuditEventAjax" runat="server">
            <ContentTemplate>
                <cb:SortedGridView ID="AuditEventGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" 
                    DataKeyNames="AuditEventId" DataSourceID="AuditEventDs" PageSize="40" DefaultSortExpression="EventDate" 
                    SkinID="PagedList" AllowSorting="True" DefaultSortDirection="Descending" ShowWhenEmpty="False" 
                    Width="100%" EnableViewState="false" OnRowDataBound="AuditEventGrid_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="EventDate" HeaderText="Date" SortExpression="EventDate">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle Width="150px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Event" SortExpression="EventTypeId">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle Width="120px" />
                            <ItemTemplate>
                                <%# StringHelper.SpaceName(Eval("EventType").ToString()) %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Success" SortExpression="Successful">
                            <ItemStyle Width="80px" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Literal ID="Successful" runat="server" Text="X" Visible='<%# Eval("Successful") %>' EnableViewState="False"></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle Width="200px" />
                            <ItemTemplate>
                                <asp:HyperLink ID="UserLink" runat="server" NavigateUrl='<%#Eval("UserId", "../../People/Users/EditUser.aspx?UserId={0}")%>' Text='<%# Eval("User.UserName") %>' Visible='<%# ((int)Eval("UserId") > 0) %>' EnableViewState="false"></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Re">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemStyle Width="110px" />
                            <ItemTemplate>
                                <asp:PlaceHolder ID="phRe" runat="server" EnableViewState="false"></asp:PlaceHolder>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="RemoteIP" HeaderText="IP" SortExpression="RemoteIP" >
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Comment" HeaderText="Comment" SortExpression="Comment" >
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Localize ID="EmptyMessage" runat="server" Text="There are no entries in the audit log." EnableViewState="false"></asp:Localize>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                <asp:ObjectDataSource ID="AuditEventDs" runat="server" 
                    OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" 
                    TypeName="CommerceBuilder.Stores.AuditEventDataSource" SortParameterName="sortExpression"
                    EnablePaging="True" DataObjectTypeName="CommerceBuilder.Stores.AuditEvent" DeleteMethod="Delete"></asp:ObjectDataSource>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>