<%@ Page Title="My Digital Goods" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyDigitalGoods.aspx.cs" Inherits="AbleCommerce.Members.MyDigitalGoods" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_digitalGoodsPage" class="mainContentWrapper">
		<div class="section">
            <div class="content">
                <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
                <div class="tabpane">
                    <cb:ExGridView ID="DigitalGoodsGrid" runat="server" AutoGenerateColumns="false" AllowPaging="false" 
                        AllowSorting="false" Width="100%" SkinID="PagedList" FixedColIndexes="0,3">
                        <Columns>
                            <asp:TemplateField HeaderText="Name">
                                <ItemStyle CssClass="orderItems" />
                                <HeaderStyle CssClass="orderItems" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="Name" runat="server" Text='<%#Eval("DigitalGood.Name")%>' NavigateUrl='<%# GetDownloadUrl(Container.DataItem) %>'></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remaining">
                                <ItemStyle CssClass="downloads" />
                                <HeaderStyle CssClass="downloads" />
                                <ItemTemplate>                    
                                    <%#GetMaxDownloads(Container.DataItem)%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Serial Key">
                                <ItemStyle CssClass="serialKey" />
                                <HeaderStyle CssClass="serialKey" />
                                <ItemTemplate>
                                    <asp:Literal ID="SerialKey" runat="server" Visible='<%#ShowSerialKey(Container.DataItem)%>' Text='<%#Eval("SerialKeyData")%>'></asp:Literal>
                                    <asp:LinkButton Visible='<%#ShowSerialKeyLink(Container.DataItem)%>' runat="server" ID="SerialKeyLink" Text="view" OnClientClick="<%#GetPopUpScript(Container.DataItem)%>"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>            
                            <asp:TemplateField HeaderText="Status">
                                <ItemStyle CssClass="status" />
                                <HeaderStyle CssClass="status" />
                                <ItemTemplate>
                                    <%#Eval("DownloadStatus")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Download">
                                <ItemStyle HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="DownloadLink" runat="server" NavigateUrl='<%# GetDownloadUrl(Container.DataItem) %>' Visible='<%#GetVisible(Container.DataItem) %>'><asp:Image ID="DownloadICon" runat="server" SkinID="DownloadIcon" /></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyDataMessage" runat="server" Text="There are no digital goods."></asp:Label>
                        </EmptyDataTemplate>
                    </cb:ExGridView>
                    <br />
                        <asp:Panel ID="SubscriptionDownloads" runat="server" CssClass="innerSection">
                            <div class="header">
                                <h2><asp:Localize ID="Caption" runat="server" Text="Subscription Downloads"></asp:Localize></h2>
                            </div>
                            <div class="content">
                                <p><asp:Literal ID="DownloadsHelp" runat="server" Text="Below are the software downloads available to you via your subscriptions:" EnableViewState="false"></asp:Literal></p>
                                <asp:GridView ID="DownloadsGrid" runat="server" AutoGenerateColumns="false" AllowPaging="false" 
                                    AllowSorting="false" Width="100%" SkinID="PagedList">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Download Name">
                                            <ItemStyle CssClass="orderItems" />
                                            <HeaderStyle CssClass="orderItems" />
                                            <ItemTemplate>
                                                <asp:Label ID="DownloadName" runat="server" Text='<%#Eval("Name")%>' />
                                                <asp:PlaceHolder ID="ReadMePh" runat="server" Visible='<%# GetReadMeVisible(Container.DataItem) %>'>
                                                    <br />
                                                    <a href="#" onclick="<%# GetReadMeUrl(Container.DataItem) %>"><%#Eval("Readme.DisplayName") %></a>
                                                </asp:PlaceHolder>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Download">
                                            <ItemStyle HorizontalAlign="Center" />
                                            <ItemTemplate>
                                                <asp:HyperLink ID="DownloadLink" runat="server" NavigateUrl='<%# GetSubscriptionDGDownloadUrl(Container.DataItem) %>'><asp:Image ID="DownloadICon" runat="server" SkinID="DownloadIcon" /></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <asp:Label ID="EmptyDataMessage" runat="server" Text="There are no downloads."></asp:Label>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                    </asp:Panel>
                </div>
            </div>
		</div>
    </div>
</div>
</asp:Content>