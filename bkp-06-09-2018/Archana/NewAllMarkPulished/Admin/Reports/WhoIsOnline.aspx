<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Reports.WhoIsOnline" Title="Who Is Online?" CodeFile="WhoIsOnline.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1><asp:Localize ID="Caption" runat="server" Text="Who Is Online?"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/system" />
	    </div>
    </div>
    <asp:UpdatePanel ID="ReportPanel" runat="server">
        <ContentTemplate>
            <div class="searchPanel">
                <div class="reportNav">
		            <asp:Label ID="ActivityThresholdLabel" runat="server" SkinID="FieldHeader" EnableViewState="false" Text="Activity Threshold"></asp:Label>
		            <asp:TextBox ID="ActivityThreshold" runat="server" Text="30" Width="30px"></asp:TextBox>
		            <asp:Label ID="MinutesLabel" runat="server" EnableViewState="false" Text="minutes"></asp:Label>
		            <asp:Button ID="ApplyButton" runat="server" OnClick="ApplyButton_Click" Text="Apply" />
                </div>
            </div>
            <div class="content">
                <cb:SortedGridView ID="OnlineUserGrid" runat="server" AutoGenerateColumns="False" DataSourceID="OnlineUserDs"
                    DefaultSortExpression="LastActivityDate" DefaultSortDirection="Descending" AllowSorting="true"
                    Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="User" SortExpression="UserName">
                            <ItemTemplate>
                                <asp:HyperLink ID="UserLink" runat="server" Text='<%# ((User)Container.DataItem).IsAnonymous?"anonymous":Eval("UserName") %>' NavigateUrl='<%#Eval("UserId", "../People/Users/EditUser.aspx?UserId={0}")%>'></asp:HyperLink>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Email" SortExpression="Email">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="EmailLabel" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last Activity" SortExpression="LastActivityDate">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="LastActivityDateLable" runat="server" Text='<%# Eval("LastActivityDate") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IP Address" >
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="IpAddressLabel" runat="server" Text='<%# GetIpAddress(Container.DataItem) %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no results for the selected time period."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="OnlineUserDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveUsers" 
        TypeName="CommerceBuilder.Reporting.ReportDataSource" SortParameterName="sortExpression" EnablePaging="false" 
        SelectCountMethod="GetActiveUsersCount">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActivityThreshold" Name="activityThreshold" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>