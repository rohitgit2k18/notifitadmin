<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.Master" AutoEventWireup="true" CodeFile="MyProductReviews.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MyProductReviews" ViewStateMode="Disabled" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="accountPage"> 
    <div id="account_productReviewsPage" class="mainContentWrapper">
        <div class="header">
		    <h2>My Product Reviews</h2>
		</div>
            <asp:Panel ID="ReviewsPanel" runat="server" CssClass="section profilePanel">
                <asp:Panel ID="ReviewsCaptionPanel" runat="server" CssClass="header">
                    <h2><asp:Localize ID="ReviewsCaption" runat="server" Text="" /></h2>
                </asp:Panel>
                <div class="content">
                <div class="tabpane">
                <div class="inputForm">
                    <asp:GridView ID="ReviewsGrid" runat="server" AutoGenerateColumns="False" Width="100%" AllowPaging="true" PageSize="6" AllowSorting="False" CssClass="orderItems" DataKeyNames="ProductReviewId" OnRowCommand="ReviewsGrid_RowCommand" OnPageIndexChanging="ReviewsGrid_PageIndexChanging">
                         <PagerStyle CssClass="pagingPanel" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate></HeaderTemplate>
                                <ItemStyle CssClass="itemDetail" />
                                <ItemTemplate>
                                <div class="inlineField">
                                <span class="fieldHeader">Product:</span>
                                    <span class="fieldValue">
                                        <asp:HyperLink ID="ProductLink" runat="server" NavigateUrl='<%# Eval("Product.NavigateUrl") %>' Text='<%# Eval("Product.Name") %>' />
                                    </span>
                                </div>
                                <div class="inlineField">
                                <span class="fieldHeader">Rating:</span>
                                    <span class="fieldValue">
                                        <uc1:ProductRatingStars ID="ReviewRating" runat="server" Rating='<%# GetRating(Container.DataItem) %>' />
                                    </span>
                                </div>

                                <div class="inlineField">
                                <span class="fieldHeader">Title:</span>
                                    <span class="fieldValue">
                                        <%#Eval("ReviewTitle")%>
                                    </span>
                                </div>
                                <div class="inlineField">
                                <span class="fieldHeader">Published:</span>
                                    <span class="fieldValue">
                                        <%# GetApprovedText(AlwaysConvert.ToBool(Eval("IsApproved"), false)) %>
                                    </span>
                                </div>
                                <div class="buttons">
                                    <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# Eval("ProductReviewId","EditMyReview.aspx?ReviewId={0}") %>' Text="Edit" CssClass="button" EnableViewState="False"></asp:HyperLink>
                                    <asp:LinkButton ID="DeleteLink" runat="server" CommandName="DoDelete" CommandArgument='<%#Eval("Id")%>' CssClass="button" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this review?')">
                                    </asp:LinkButton>
                                </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="NoReviewsMessage" runat="server" Text="You have not yet submitted any product reviews."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
               </div>
              </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
