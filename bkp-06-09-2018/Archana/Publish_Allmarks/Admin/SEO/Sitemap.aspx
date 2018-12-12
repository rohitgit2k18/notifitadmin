<%@ Page Title="XML Sitemap" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Sitemap.aspx.cs" Inherits="AbleCommerce.Admin.SEO.Sitemap" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
	    <div class="caption">
		<h1>XML Sitemap</h1>
		<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/seo" />
	    </div>
    </div>
    <div class="content">
		<p>The sitemap is a specially constructed XML file that contains a list of all URLs for your site along with additional metadata about each URL (when it was last updated, how often it usually changes, and how important it is, relative to other URLs in the site) so that search engines can more intelligently crawl the site. Most popular search engines can make use of this sitemap file, including Google, Microsoft, and Yahoo!.</p>
		<p>Your sitemap file is generated in the home directory for your store.  If the sitemap grows beyond 50,000 URLs, then multiple sitemap files are created along with a sitemap index file.  Once you have created your sitemap, <a href="http://www.sitemaps.org/protocol.php#informing" target="_blank">let search engines know</a> about it by submitting directly to them, pinging them, or adding the sitemap location to your robots.txt file.</p>
        <cb:Notification ID="SuccessMessage" runat="server" Text="" SkinID="GoodCondition" Visible="false"></cb:Notification>
        <cb:Notification ID="FailureMessage" runat="server" Text="" SkinID="ErrorCondition" Visible="false"></cb:Notification>
        <asp:ValidationSummary ID="ValidationSummary1"  runat="server" />
        <table class="inputForm">
            <tr> 
                <th> 
                    <cb:ToolTipLabel ID="IndexItemsLabel" runat="server" Text="Index:" ToolTip="Select the types of objects to include in your sitemap index.  It is recommended to include all items." AssociatedControlID="IndexItems" />
                </th>
                <td>
                    <asp:CheckBoxList ID="IndexItems" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal" CssClass="checkboxList">
                        <asp:ListItem Text="Categories"></asp:ListItem>
                        <asp:ListItem Text="Products"></asp:ListItem>
                        <asp:ListItem Text="Webpages"></asp:ListItem>
                    </asp:CheckBoxList>
                </td>
            </tr>
            <tr> 
                <th> 
                    <cb:ToolTipLabel ID="ChangeFrequencyLabel" runat="server" Text="Change Frequency:" ToolTip="Approximately how often are your URLs likely to change?  Note that this setting is a guide for crawlers only and will not determine how often your site is crawled." AssociatedControlID="ChangeFrequency" />
                </th>
                <td>
                    <asp:DropDownList ID="ChangeFrequency" runat="server">                         
                    </asp:DropDownList>
                </td>
            </tr>
            <tr> 
                <th> 
                    <cb:ToolTipLabel ID="UseCompressionLabel" runat="server" Text="Use Compression:" ToolTip="When selected the generated index will be compressed.  This can reduce bandwidth when crawlers request your sitemap." AssociatedControlID="UseCompression" />
                </th>
                <td>
                    <asp:CheckBox ID="UseCompression" runat="server" />
                </td>
            </tr>
            <tr> 
                <th> 
                    <cb:ToolTipLabel ID="SitemapDataPath" runat="server" Text="Sitemap Data Path:" ToolTip="Provides ability to edit sitemap location. By default, sitemap is generated in the website root directory if left blank." AssociatedControlID="SitemapPath" />
                </th>
                <td>
                    <asp:TextBox ID="SitemapPath" runat="server" Width="180px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="GenerateButton" runat="server" Text="Generate Sitemap" OnClick="GenerateButton_Click" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>