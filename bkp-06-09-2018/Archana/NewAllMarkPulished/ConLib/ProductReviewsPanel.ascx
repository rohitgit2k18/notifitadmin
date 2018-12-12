<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.ProductReviewsPanel" CodeFile="ProductReviewsPanel.ascx.cs" EnableViewState="true" %>
<%@ Register Src="~/ConLib/ProductReviewForm.ascx" TagName="ProductReviewForm" TagPrefix="uc" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%--
<conlib>
<summary>Displays all reviews for a product.</summary>
</conlib>
--%>
<asp:PlaceHolder ID="Widget" runat="server">
    <div class="widget productReviewsPanel">
	    <a name="reviews"></a>
	    <div class="innerSection">
            <div class="header"><h2>Reviews</h2></div>	 
            <div class="content">
    	        <asp:UpdatePanel ID="ReviewsPanelAjax" runat="server">
                    <ContentTemplate>
                        <asp:PlaceHolder ID="ShowReviewsPanel" runat="server">
                            <table class="reviewsTable">
                                <tr>
                                    <td>
                                        <asp:Panel ID="AverageRatingPanel" runat="server">
                                            <asp:Label ID="RatingImageLabel" runat="server" Text="Average Rating:" CssClass="fieldHeader"></asp:Label>
                                            <uc1:ProductRatingStars ID="ProductRating" runat="server" />
                                            <asp:Label ID="ReviewCount" runat="server" Text=" (based on {0} review{1})" EnableViewState="false"></asp:Label>
                                            <div itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating">
                                                <meta itemprop="worstRating" content="1" />
                                                <meta itemprop="bestRating" content="10" />
                                                <asp:PlaceHolder ID="PHRichSnippets" runat="server"></asp:PlaceHolder>
                                            </div>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Panel ID="ReviewsCaptionPanel" runat="server">
                                            <h2>
                                                <asp:Localize ID="ReviewsCaption" runat="server" Text="Showing {0} Review{1}:" EnableViewState="false"/>
                                                <asp:Localize ID="PagedReviewsCaption" runat="server" Text="Showing {0} - {1} of {2} Reviews:" EnableViewState="false"/>
                                            </h2>
                                        </asp:Panel>
                                        <cb:ExGridView ID="ReviewsGrid" runat="server" DataSourceID="ReviewDs" AutoGenerateColumns="False" 
                                            ShowHeader="true" AllowPaging="True" PageSize="5" SkinID="PagedList" CellPadding="4" CellSpacing="0" Width="100%" DefaultSortExpression="ReviewDate"  DefaultSortDirection="Descending"  >
                                            <Columns>
                                                <asp:TemplateField HeaderText="Rating" SortExpression="Rating">
                                                    <ItemStyle HorizontalAlign="Center" Width="60px" VerticalAlign="Top"/>
                                                    <ItemTemplate>
                                                        <uc1:ProductRatingStars ID="ReviewRating" runat="server" Rating='<%# GetRating(Container.DataItem) %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Reviewer">
                                                    <ItemStyle Width="150px" VerticalAlign="Top"/>
                                                    <ItemTemplate>
                                                        <asp:Label ID="ReviewerName" runat="server" Text='<%#Eval("ReviewerProfile.DisplayName", "by {0}")%>'></asp:Label><br /> 
                                                        <asp:Label ID="ReviewDate" runat="server" Text='<%# Eval("ReviewDate", "on {0:d}") %>'></asp:Label><br />
                                                        <asp:Label ID="ReviewerLocation" runat="server" Text='<%# Eval("ReviewerProfile.Location", "from {0}") %>' Visible='<%# !string.IsNullOrEmpty((string)Eval("ReviewerProfile.Location")) %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Review">
                                                    <ItemStyle Width="450px" VerticalAlign="Top"/>
                                                    <ItemTemplate>
                                                        <asp:Label ID="ReviewTitleLabel" Text='<%#Eval("ReviewTitle")%>' runat="server" CssClass="fieldHeader"></asp:Label><br />
                                                        <div class="productReviewContent"><pre class="reviewBody"><%#Eval("ReviewBody")%></pre></div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <asp:Label ID="NoReviewsMessage" runat="server" Text="Be the first to submit a review on this product!"></asp:Label>
                                            </EmptyDataTemplate>
                                        </cb:ExGridView>
                                        <asp:ObjectDataSource ID="ReviewDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
                                            SelectCountMethod="SearchCount" SelectMethod="Search" SortParameterName="sortExpression"
                                            TypeName="CommerceBuilder.Products.ProductReviewDataSource">
                                            <SelectParameters>
                                                <asp:QueryStringParameter Name="productId" QueryStringField="ProductId" Type="Int32" />
                                                <asp:Parameter Name="approved" Type="Object" DefaultValue="True" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>    
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:LinkButton ID="ReviewLink" runat="server" Text="Review and Rate this Item" OnClick="ReviewLink_Click"></asp:LinkButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="ReviewProductPanel" runat="server" Visible="false">
                            <uc:ProductReviewForm ID="ProductReviewForm1" runat="server" />
                        </asp:PlaceHolder>	  
                    </ContentTemplate>
	            </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:PlaceHolder>