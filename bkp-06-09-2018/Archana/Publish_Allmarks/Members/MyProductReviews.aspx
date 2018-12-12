<%@ Page Title="My Product Reviews" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.Master" AutoEventWireup="True" CodeFile="MyProductReviews.aspx.cs" Inherits="AbleCommerce.Members.MyProductReviews" ViewStateMode="Disabled" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_productReviewsPage" class="mainContentWrapper">
        <uc:AccountTabMenu ID="AccountTabMenu" runat="server" />
        <div class="tabpane">
            <asp:Panel ID="ReviewsPanel" runat="server" CssClass="section profilePanel">
                <asp:Panel ID="ReviewsCaptionPanel" runat="server" CssClass="header">
                    <h2><asp:Localize ID="ReviewsCaption" runat="server" Text="" /></h2>
                </asp:Panel>
                <div class="content">
                    <cb:ExGridView ID="ReviewsGrid" runat="server" AutoGenerateColumns="False" Width="100%" AllowPaging="False" AllowSorting="False" 
                        SkinID="PagedList" DataKeyNames="ProductReviewId" OnRowCommand="ReviewsGrid_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="Product">
                                <HeaderStyle CssClass="orderItems" />
                                <ItemStyle CssClass="orderItems" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="ProductLink" runat="server" NavigateUrl='<%# Eval("Product.NavigateUrl") %>' Text='<%# Eval("Product.Name") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rating" SortExpression="Rating">
                                <HeaderStyle CssClass="rating" />
                                <ItemStyle CssClass="rating" />
                                <ItemTemplate>
                                    <uc1:ProductRatingStars ID="ReviewRating" runat="server" Rating='<%# GetRating(Container.DataItem) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Title" SortExpression="ReviewTitle">
                                <HeaderStyle CssClass="orderItems" />
                                <ItemStyle CssClass="orderItems" />
                                <ItemTemplate>
                                    <%#Eval("ReviewTitle")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Published" SortExpression="IsApproved">
                                <HeaderStyle CssClass="reviewPublished" />
                                <ItemStyle CssClass="reviewPublished" />
                                <ItemTemplate>
                                    <%# GetApprovedText(AlwaysConvert.ToBool(Eval("IsApproved"), false)) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <a href="<%# Page.ResolveUrl(Eval("ProductReviewId", "EditMyReview.aspx?ReviewId={0}"))%>"><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></a>
                                    <asp:LinkButton ID="DeleteLink" runat="server" CommandName="DoDelete" CommandArgument='<%#Eval("Id")%>' OnClientClick="return confirm('Are you sure you want to delete this review?')">
                                        <asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" AlternateText="Delete" />
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="NoReviewsMessage" runat="server" Text="You have not yet submitted any product reviews."></asp:Label>
                        </EmptyDataTemplate>
                    </cb:ExGridView>
                </div>
            </asp:Panel>
        </div>
    </div>
</div>
</asp:Content>