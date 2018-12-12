<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Store.Currencies._Default" Title="User Currencies"  CodeFile="Default.aspx.cs" AutoEventWireup="True" %>
<%@ Register Src="AddCurrencyDialog.ascx" TagName="AddCurrencyDialog" TagPrefix="uc1" %>
<%@ Register Src="EditCurrencyDialog.ascx" TagName="EditCurrencyDialog" TagPrefix="uc1" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Currencies"></asp:Localize></h1>
            	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/store" />
    	</div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="CurrencyAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:SortedGridView ID="CurrencyGrid" runat="server" AutoGenerateColumns="False" DataKeyNames="CurrencyId" DataSourceID="CurrencyDs" 
                    width="100%" SkinID="PagedList" AllowSorting="True" DefaultSortExpression="Name" DefaultSortDirection="Ascending" 
                    ShowWhenEmpty="False"  OnRowEditing="CurrencyGrid_RowEditing" OnRowCommand="CurrencyGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Currency" SortExpression="Name">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="Currency" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ISOCode" HeaderText="ISO" SortExpression="ISOCode" ReadOnly="True">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>                                
                        <asp:TemplateField HeaderText="Exchange Rate" SortExpression="ExchangeRate">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                            <ItemTemplate>
                                <asp:Label ID="ExchangeRate" runat="server" Text='<%# Eval("ExchangeRate", "{0:#.####}") %>' Visible='<%#!(bool)Eval("IsBaseCurrency")%>'></asp:Label>
                                <asp:Label ID="BaseCurrency" runat="server" Text="*" Visible='<%#Eval("IsBaseCurrency")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Last Update" SortExpression="LastUpdate">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#GetLastUpdateDate(Eval("LastUpdate"))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="AutoUpdate" HeaderText="Auto Update" SortExpression="AutoUpdate" ReadOnly="True">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:CheckBoxField>                                
                        <asp:TemplateField HeaderText="Sample">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:Label ID="SampleFormat" runat="server" Text='<%#GetSample(Container.DataItem)%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>                                    
                            <ItemStyle HorizontalAlign="Center" Width="90px" Wrap="false" />
                            <ItemTemplate>
                                <asp:ImageButton ID="UpdateButton" runat="server" SkinID="UpdateRate" CommandName="UpdateRate" AlternateText="Update Rate" CommandArgument='<%#Eval("CurrencyId")%>' />
                                <asp:ImageButton ID="EditButton" runat="server" SkinID="EditIcon" CommandName="Edit" AlternateText="Edit" />
                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" Visible='<%#!AlwaysConvert.ToBool(Eval("IsBaseCurrency"),false)%>'/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Localize ID="EmptyMessage" runat="server" Text="You have no currencies defined for your store."></asp:Localize>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
				<p><asp:Localize ID="BaseCurrencyMessage" runat="server" Text="* {0} is the base currency for your store" EnableViewState="false"></asp:Localize></p>
                <p><asp:Label ID="ChangingBaseCurrencyMessage" runat="server" SkinId="GoodCondition" Text="Note : You can change the base currency of your store by simply editing the current base currency and changing its name and ISO code." EnableViewState="false"></asp:Label></p>
				<uc1:AddCurrencyDialog ID="AddCurrencyDialog1" runat="server"></uc1:AddCurrencyDialog>
                <uc1:EditCurrencyDialog ID="EditCurrencyDialog1" runat="server"></uc1:EditCurrencyDialog>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:ObjectDataSource ID="CurrencyDs" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="LoadAll" TypeName="CommerceBuilder.Stores.CurrencyDataSource" DataObjectTypeName="CommerceBuilder.Stores.Currency"
            DeleteMethod="Delete" UpdateMethod="Update" SortParameterName="sortExpression" InsertMethod="Insert">
        </asp:ObjectDataSource>
    </div>
    <asp:UpdatePanel ID="ForexProviderAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="section">
                <div class="header">
                    <h2 class="automaticexchangerates"><asp:Localize ID="ForexProviderCaption" runat="server" Text="Automatic Exchange Rates" /></h2>
                </div>
                <div class="content">
                    <asp:Label ID="ForexProviderHelpText" runat="server" Text="When automatic exchange rate updates are enabled, select the rate provider that should be used.  If no provider is selected, automatic updates will not be successful."></asp:Label>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <asp:Label ID="ForexProviderLabel" runat="server" AssociatedControlID="ForexProvider" Text="Provider:"></asp:Label>
                            </th>
                            <td>
                                <asp:DropDownList ID="ForexProvider" runat="server" AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="ForexProviderDs" DataTextField="Name" DataValueField="ClassId" OnSelectedIndexChanged="ForexProvider_SelectedIndexChanged" OnDataBound="ForexProvider_DataBound">
                                    <asp:ListItem></asp:ListItem>
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="ForexProviderDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetProviders" TypeName="CommerceBuilder.Stores.ForexProviderDataSource"></asp:ObjectDataSource>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>