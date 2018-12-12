<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Dashboard.NewsReader" CodeFile="NewsReader.ascx.cs" EnableViewState="false" %>
<div class="section">
    <div class="header">
        <h2>Software News Feed</h2>
    </div>
    <div class="content">
        <asp:Repeater ID="RssList" runat="server">
            <ItemTemplate>
                <asp:Label ID="DateLabel" runat="server" Text='<%# string.Format("{0:d}", ((RssNewsItem)Container.DataItem).PubDate) %>' SkinID="FieldHeader"></asp:Label><br />
                <asp:HyperLink ID="TitleLink" runat="server" Text='<%# ((RssNewsItem)Container.DataItem).Title %>' NavigateUrl='<%# ((RssNewsItem)Container.DataItem).Link %>' Target="_blank"></asp:HyperLink><br />
                <asp:Literal ID="DescriptionLabel" runat="server" Text='<%# ((RssNewsItem)Container.DataItem).Description %>'></asp:Literal>
            </ItemTemplate>
            <SeparatorTemplate>
                <hr />
            </SeparatorTemplate>
            <FooterTemplate>
                <hr />
            </FooterTemplate>
        </asp:Repeater>
        <a href="http://www.ablecommerce.com/rss/acgold.xml" target="_blank">More News</a>
    </div>
</div>