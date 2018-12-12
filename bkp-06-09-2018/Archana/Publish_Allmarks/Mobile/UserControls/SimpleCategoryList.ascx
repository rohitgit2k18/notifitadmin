<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SimpleCategoryList.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.SimpleCategoryList" EnableViewState="false" %>
<%--
<UserControls>
<summary>A simple category list which shows the nested categories under a specific category.</summary>
<param name="CssClass" default="section">Css style sheet class.</param>
<param name="HeaderCssClass" default="header">Css style sheet class.</param>
<param name="HeaderText" default="Categories">Title Text for the header.</param>
<param name="ContentCssClass" default="content">Css style sheet class.</param>
</UserControls>
--%>
<div class="simpleCategoryList">
    <asp:Panel ID="MainPanel" runat="server" CssClass="section">
        <asp:Panel ID="HeaderPanel" runat="server" CssClass="header">
	        <h2><asp:Localize ID="HeaderTextLabel" runat="server" Text="Categories"></asp:Localize></h2>
        </asp:Panel>
        <ajaxToolkit:Accordion ID="CategoryAccordian" runat="server" RequireOpenedPane="false" SelectedIndex="-1" HeaderSelectedCssClass="headerSelected" >
            <HeaderTemplate>
                <div id="Expandable" runat="server" class="categoryMain expandPanel" visible='<%#Eval("IsExpandable")%>'>
                    <span class="name"><%#Eval("Name") %></span>
                    <span class="arrowDown"></span>
                </div>
                <div runat="server" class="categoryMain" visible='<%#!(bool)Eval("IsExpandable") %>'>
                    <a runat="server" href='<%# Page.ResolveUrl((string)Eval("NavigateUrl")) %>' class="mainCatLink">
                    <span class="name"><%#Eval("Name") %></span>                    
                    <span class="arrowRight"></span>
                    </a>
                </div>
            </HeaderTemplate>
            <ContentTemplate>
                <asp:Repeater ID="SubCategoriesRepeater" runat="server" DataSource='<%#Eval("Subcategories")%>'>
                    <ItemTemplate>
                        <div class="categorySub" runat="server">
                        <a runat="server" href='<%# Page.ResolveUrl((string)Eval("NavigateUrl")) %>' class="subCatLink" >
                           <span class="arrowRightSub"></span> <span class="name"><%#Eval("Name") %></span>                            
                        </a>
                        </div>
                    </ItemTemplate>                 
                </asp:Repeater>
            </ContentTemplate>
        </ajaxToolkit:Accordion>
    </asp:Panel>
</div>
