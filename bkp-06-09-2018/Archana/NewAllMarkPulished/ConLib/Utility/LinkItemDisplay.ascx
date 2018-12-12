<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LinkItemDisplay.ascx.cs" Inherits="AbleCommerce.ConLib.Utility.LinkItemDisplay" EnableViewState="true" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Displays a link item</summary>
<param name="ShowImage" default="True">If true link image will be displayed</param>
<param name="ShowSummary" default="False">If true summary text will be displayed</param>
<param name="Item" default="Null">Link item to display</param>
</conlib>
--%>
<div class="linkItemDisplay"> 
   <asp:Panel ID="ThumbnailPanel" runat="server" CssClass="thumbnailArea">
       <div class="thumbnailWrapper"> 
         <div class="thumbnail">
            <asp:HyperLink ID="LinkThumbnailLink" runat="server" NavigateUrl="#">
                <asp:Image ID="LinkThumbnail" runat="server" />
            </asp:HyperLink>
         </div> 
      </div> 
   </asp:Panel>
   <div class="detailsArea"> 
     <div class="details">
        <asp:Panel ID="NamePanel" runat="server" CssClass="itemName">
            <asp:HyperLink ID="LinkName" runat="server"></asp:HyperLink>
        </asp:Panel>
        <asp:Panel ID="SummaryPanel" runat="server" CssClass="summary">
            <asp:Label ID="LinkSummary" runat="server"></asp:Label>
        </asp:Panel> 
     </div> 
  </div> 
</div>
