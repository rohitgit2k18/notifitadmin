<%@ Control Language="C#" AutoEventWireup="true" CodeFile="WebpageItemDisplay.ascx.cs" Inherits="AbleCommerce.ConLib.Utility.WebpageItemDisplay" EnableViewState="true" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays a web page item</summary>
<param name="ShowImage" default="True">If true image for the webpage item is displayed</param>
<param name="ShowSummary" default="False">If true summary text is displayed</param>
<param name="Item" default="Null">Webpage item to display</param>
</conlib>
--%>
<div class="webpageItemDisplay"> 
   <asp:Panel ID="ThumbnailPanel" runat="server" CssClass="thumbnailArea">
       <div class="thumbnailWrapper"> 
         <div class="thumbnail">
            <asp:HyperLink ID="WebpageThumbnailLink" runat="server" NavigateUrl="#">
                <asp:Image ID="WebpageThumbnail" runat="server" />
            </asp:HyperLink>
         </div> 
      </div> 
   </asp:Panel>
   <div class="detailsArea"> 
     <div class="details">
        <asp:Panel ID="NamePanel" runat="server" CssClass="itemName">
            <asp:HyperLink ID="WebpageName" runat="server"></asp:HyperLink>
        </asp:Panel>
        <asp:Panel ID="SummaryPanel" runat="server" CssClass="summary">
            <asp:Label ID="WebpageSummary" runat="server"></asp:Label>
        </asp:Panel> 
     </div> 
  </div> 
</div>
