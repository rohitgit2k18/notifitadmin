<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductRatingStars.ascx.cs" Inherits="AbleCommerce.ConLib.Utitlity.ProductRatingStars" %>
<%--
<conlib>
<summary>Displays product rating stars</summary>
<param name="ShowRatingText" default="False">If true rating text is displayed</param>
<param name="Product">The product to display the rating for.</param>
</conlib>
--%>
<div class="aggregateRating">
    <span class="<%=GetRatingClass()%>">
    </span> 
    <asp:Label ID="TotalReviewsLabel" runat="server" Text="({0} review{1})" EnableViewState="false"></asp:Label>
    <asp:Label ID="RatingText" Text="(Rating {0}/10)" runat="server" EnableViewState="false" CssClass="ratingText"></asp:Label>
    <asp:Label ID="NoRatingText" Text="Not Rated" runat="server" Visible="false" EnableViewState="false" CssClass="ratingText"></asp:Label>
</div> 