<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.DailyAbandonedBaskets" Title="Daily Abandoned Baskets" CodeFile="DailyAbandonedBaskets.aspx.cs" %>
<%@ Register Src="~/Admin/UserControls/PickerAndCalendar.ascx" TagName="PickerAndCalendar" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Abandoned Baskets for "></asp:Localize><asp:Localize ID="ReportCaption" runat="server" Text="{0:d}" Visible="False" EnableViewState="False"></asp:Localize>
            </h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
        </div>
    </div>
    <div class="searchPanel">
        <div class="reportNav">
            <asp:Label ID="ReportLabel" runat="server" Text="Abandoned Baskets for: " SkinID="FieldHeader"></asp:Label>
            <uc1:PickerAndCalendar ID="ReportDate" runat="server" />    
            <asp:Button ID="ProcessButton" runat="server" Text="Generate Report" OnClick="ProcessButton_Click" />
        </div>
    </div>
    <div class="content">
        <cb:AbleGridView ID="DailyAbandonedBasketsGrid" runat="server" AutoGenerateColumns="False" DataSourceID="BasketsDs"
	        TotalMatchedFormatString="<span id='searchCount'>{0}</span> matching results" 
	        Width="100%" ShowFooter="False" SkinID="PagedList" AllowPaging="true" PageSize="100">
            <Columns>
                <asp:TemplateField HeaderText="Customer">
                    <ItemTemplate>
                        <asp:HyperLink ID="UserLink" runat="server" Text='<%# GetCustomerName(Container.DataItem) %>' NavigateUrl='<%#GetEditUserUrl(Container.DataItem)%>'></asp:HyperLink>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Items in Basket">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%# GetBasketItems(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Basket Total">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%# ((decimal)Eval("BasketTotal")).LSCurrencyFormat("lc") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Last Activity">
                    <HeaderStyle HorizontalAlign="Left" />
                    <ItemTemplate>
                        <%# Eval("LastActivity") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="CreateOrderButton" runat="server" Text="+ Create Order" SkinID="Button" NavigateUrl='<%#GetCreateOrderUrl(Container.DataItem)%>'></asp:HyperLink>
                        <asp:HyperLink ID="SendAlertLink" runat="server" Text="Send Alert" SkinID="Button" NavigateUrl='<%#Eval("BasketId", "SendAbandonedBasketAlert.aspx?BasketId={0}")%>' Visible='<%# HasEmail(Eval("BasketId")) %>'></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <asp:Label ID="EmptyResultsMessage" runat="server" Text="There are no abandoned baskets for the selected date."></asp:Label>
            </EmptyDataTemplate>
        </cb:AbleGridView>
        <asp:ObjectDataSource ID="BasketsDs" runat="server" OldValuesParameterFormatString="original_{0}" EnablePaging="true"
            SelectMethod="GetDailyAbandonedBaskets" TypeName="CommerceBuilder.Reporting.ReportDataSource" OnSelecting="BasketsDs_Selecting">
            <SelectParameters>
                <asp:Parameter Name="year" Type="Int32" DefaultValue="0" />
                <asp:Parameter Name="month" Type="Int32" DefaultValue="0" />
                <asp:Parameter Name="day" Type="Int32" DefaultValue="0"/>
            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
</asp:Content>