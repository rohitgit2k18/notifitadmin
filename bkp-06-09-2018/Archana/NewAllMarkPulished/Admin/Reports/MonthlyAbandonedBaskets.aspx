<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Reports.MonthlyAbandonedBaskets" Title="Abandoned Baskets" CodeFile="MonthlyAbandonedBaskets.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ReportAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Abandoned Baskets"></asp:Localize></h1>
                    <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="reports/customers" />
                </div>
            </div>
            <div class="searchPanel">
                <div class="reportNav">
                    <asp:Button ID="PreviousButton" runat="server" Text="&laquo; Previous" OnClick="PreviousButton_Click" />
                    &nbsp;
                    <asp:Label ID="MonthLabel" runat="server" Text="Month: " SkinID="FieldHeader"></asp:Label>
                    <asp:DropDownList ID="MonthList" runat="server" AutoPostBack="true">
                        <asp:ListItem Value="1" Text="January"></asp:ListItem>
                        <asp:ListItem Value="2" Text="February"></asp:ListItem>
                        <asp:ListItem Value="3" Text="March"></asp:ListItem>
                        <asp:ListItem Value="4" Text="April"></asp:ListItem>
                        <asp:ListItem Value="5" Text="May"></asp:ListItem>
                        <asp:ListItem Value="6" Text="June"></asp:ListItem>
                        <asp:ListItem Value="7" Text="July"></asp:ListItem>
                        <asp:ListItem Value="8" Text="August"></asp:ListItem>
                        <asp:ListItem Value="9" Text="September"></asp:ListItem>
                        <asp:ListItem Value="10" Text="October"></asp:ListItem>
                        <asp:ListItem Value="11" Text="November"></asp:ListItem>
                        <asp:ListItem Value="12" Text="December"></asp:ListItem>
                    </asp:DropDownList>&nbsp;
                    <asp:Label ID="YearLabel" runat="server" Text="Year: " SkinID="FieldHeader"></asp:Label>
                    <asp:DropDownList ID="YearList" runat="server" AutoPostBack="true">
                    </asp:DropDownList>
                    &nbsp;
                    <asp:Button ID="NextButton" runat="server" Text="Next &raquo;" OnClick="NextButton_Click" />
                </div>
            </div>
            <div class="content">
                <asp:Chart ID="BasketChart" runat="server" ImageLocation="~/webcharts/abandonedbaskets" SkinID="Report" Width="900" Height="270">
                    <Series>
                        <asp:Series Name="Baskets" ChartArea="MainChartArea" 
                        Color="#A0B340"
                        BackGradientStyle="TopBottom"
                        BackSecondaryColor="#69665F"
                        Font="Arial, 7pt"
                        BorderColor="#000000"
                        ChartType="Column"
                        YValueType="Int32"
                        XValueType="String"
                        IsValueShownAsLabel="True">
                        </asp:Series>
                    </Series>
                </asp:Chart>
                <asp:GridView ID="AbandonedBasketGrid" runat="server" AutoGenerateColumns="False" Width="900" ShowFooter="False"
                    SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="Date" SortExpression="StartDate">
                            <ItemTemplate>
                                <asp:Label ID="DateLabel" runat="server" Text='<%# Eval("StartDate", "{0:d}") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="No. of Baskets">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("BasketCount") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Amount">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# ((decimal)Eval("Total")).LSCurrencyFormat("lc") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>                                                                
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:HyperLink ID="DetailsLink" runat="server" Text="Details" SkinID="Button" NavigateUrl='<%#Eval("StartDate", "DailyAbandonedBaskets.aspx?Date={0:yyyy-MMM-dd}")%>' Visible='<%# ((int)Eval("BasketCount")) > 0 %>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>