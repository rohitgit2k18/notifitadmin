<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomHTML.ascx.cs" Inherits="AbleCommerce.ConLib.CustomHTML" %>
<%--
<conlib>
<summary>This control helps you place custom HTML in sidebar.</summary>
<param name="Caption" default="Sample Header Text">Caption / Title of the control.</param>
<param name="WebPageId" default="-1">The id of the web page to load custom HTML in sidebar panel.</param>
</conlib>
--%>
<div class="widget customHtml">
    <div class="innerSection">
 	  <div class="header">
 	    <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Sample Header Text"></asp:Localize></h2>
 	  </div>
 	  <div class="content">
 	    <asp:PlaceHolder ID="CustomHTMLPanel" runat="server">
             Edit the control and replace this with your custom HTML or create a new Webpage with your custom HTML as content and use the Webpage Id as a parameter for this control.
 	    </asp:PlaceHolder>
 	  </div>
    </div>
</div> 
