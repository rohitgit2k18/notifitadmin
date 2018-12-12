<%@ Page Title="View Link" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="Link.aspx.cs" Inherits="AbleCommerce.LinkPage" %>
<%@ Register src="~/ConLib/CategoryBreadCrumbs.ascx" tagname="CategoryBreadCrumbs" tagprefix="uc1" %>
<%-- 
<DisplayPage>
    <Name>Basic Link</Name>
    <NodeType>Link</NodeType>
    <Description>A basic display handler for links.  It shows the description with a link to the specified URL.</Description>
</DisplayPage>
--%>
<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" runat="server">
    <div id="linkPage" class="mainContentWrapper">
        <uc1:CategoryBreadCrumbs ID="CategoryBreadCrumbs1" runat="server" />
		<div class="section">
			<div class="pageHeader">
				<h1><asp:Literal ID="LinkName" runat="server"></asp:Literal></h1>
			</div>
			
			<div class="content">
				<asp:PlaceHolder ID="LinkDescriptionPanel" runat="server">
				<p><asp:Literal ID="LinkDescription" runat="server"></asp:Literal></p>
				</asp:PlaceHolder>
				<asp:HyperLink ID="LinkTarget" runat="server"></asp:HyperLink>
			</div>
		</div>
    </div>
</asp:Content>
