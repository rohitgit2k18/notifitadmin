<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CategoryItemDisplay.ascx.cs" Inherits="AbleCommerce.ConLib.Utility.CategoryItemDisplay" EnableViewState="true" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays a category item</summary>
<param name="ShowImage" default="True">If true category image will be displayed</param>
<param name="ShowSummary" default="False">If true summary text will be displayed</param>
<param name="MaxSummaryLength" default="-1">Maximum number of characters to display for summary. Value of 0 or less means no restriction.</param>
<param name="Item" default="Null">Category item to display</param>
</conlib>
--%>
<div class="categoryItemDisplay"> 
   <asp:Panel ID="ThumbnailPanel" runat="server" CssClass="thumbnailArea">
       <div class="thumbnailWrapper"> 
         <div class="thumbnail">
            <asp:HyperLink ID="CategoryThumbnailLink" runat="server" NavigateUrl="#">
                <asp:Image ID="CategoryThumbnail" runat="server" />
            </asp:HyperLink>
         </div> 
      </div> 
   </asp:Panel>
   <div class="detailsArea"> 
     <div class="details">
        <asp:Panel ID="NamePanel" runat="server" CssClass="itemName">
            <asp:HyperLink ID="CategoryName" runat="server"></asp:HyperLink>
        </asp:Panel>
        <asp:Panel ID="SummaryPanel" runat="server" CssClass="summary">
            <asp:Label ID="CategorySummary" runat="server"></asp:Label>
        </asp:Panel> 
     </div> 
  </div> 
</div>
