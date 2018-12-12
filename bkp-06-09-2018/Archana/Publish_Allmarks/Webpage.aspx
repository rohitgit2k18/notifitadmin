<%@ Page Title="View Webpage" Language="C#" MasterPageFile="~/Layouts/LeftSidebar.Master" AutoEventWireup="True" CodeFile="Webpage.aspx.cs" Inherits="AbleCommerce.WebpagePage" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="articleListingPanel" runat="server" class="categoryDetailsListing">
    <div class="articlesListing">
        <div class="itemContainer">
            <div class="itemDisplay" style="padding:10px;">
                <asp:Panel ID="ThumbnailPanel" runat="server" CssClass="thumbnailArea">
                    <div class="thumbnailWrapper"> 
                        <div class="thumbnail">
                        <asp:HyperLink ID="ItemThumbnailLink" runat="server" NavigateUrl="#">
                            <asp:Image ID="ItemThumbnail" runat="server" />
                        </asp:HyperLink>
                        </div> 
                    </div> 
                </asp:Panel>
                <div class="detailsArea" style="text-align:left;"> 
                    <div class="features"> 
                        <asp:Panel ID="NamePanel" runat="server" CssClass="itemName">
                            <asp:HyperLink ID="ItemName" runat="server"></asp:HyperLink>
                        </asp:Panel>
                        <asp:Panel ID="PublishInfo" runat="server" CssClass="publishInfo">
                            <asp:Label ID="PublishInfoLabel" runat="server" Text="PUBLISHED: {0}{1}" EnableViewState="false"></asp:Label>
                        </asp:Panel>
                        <br />
                        <asp:Panel ID="SummaryPanel" runat="server" CssClass="summary">
                            <asp:Label ID="ItemSummary" runat="server"></asp:Label>
                        </asp:Panel> 
                        <asp:Panel ID="DescriptionPanel" runat="server" CssClass="summary">
                            <asp:Label ID="ItemDescription" runat="server"></asp:Label>
                        </asp:Panel> 
                    </div>
                    <div id="webpagePager" class="mainContentWrapperee" runat="server">
                        <cb:HtmlContainer ID="BlogDescription" runat="server"></cb:HtmlContainer>
                    </div>
                </div> 
            </div>
        </div>
    </div>
</div>
<div id="webpagePage" class="mainContentWrapper" runat="server">
    <cb:HtmlContainer ID="PageContents" runat="server"></cb:HtmlContainer>
</div>
</asp:Content>
