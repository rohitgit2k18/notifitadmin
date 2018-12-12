<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Search" Title="Admin Search"  CodeFile="Search.aspx.cs" ViewStateMode="Disabled" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
         <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="You searched '{0}':"></asp:Localize></h1>
        </div>
    </div>
    <div class="section">
        <div class="content">
            <asp:Repeater ID="SearchAreasRepeater" runat="server">
                <ItemTemplate>       
                    <h2><%#Eval("SearchArea")%>: <%#Eval("TotalMatches")%> Matches</h2>
                    <asp:ListView ID="ResultLinksList" runat="server" DataSource='<%#Eval("SearchResults")%>'>
                        <LayoutTemplate>
                            <ul class="adminSearchResults">
                                <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                            </ul>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <li><a href="<%#GetLinkUrl(Eval("Entity"))%>"><%# Eval("Name") %></a></li>
                        </ItemTemplate>
                    </asp:Listview>
                    <asp:Panel ID="MoreMatchesPanel" runat="server" CssClass="moreMatches" Visible='<%# ShowMoreMatches(Container.DataItem) %>'>
                        <asp:Localize ID="MoreMatches" runat="server" Text="(more than 100 results)"></asp:Localize>
                    </asp:Panel>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>