<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Indexing.aspx.cs" Inherits="AbleCommerce.Admin._Store.Indexing" ViewStateMode="Disabled" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="pageHeader">
    <div class="caption">
        <h1><asp:Localize ID="Caption" runat="server" Text="Full Text Indexing"></asp:Localize></h1>
        <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="website" />
    </div>
</div>
<div class="content">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:PlaceHolder ID="NoFTSPanel" runat="server" Visible="false">
                <p>Index maintenance is not necessary when you are using the SQL search provider.</p>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="FTSPanel" runat="server">
                <asp:Localize ID="FullTextIndexHelpText" runat="server">
                    <p>AbleCommerce creates and maintains an index of the database.  This helps improve performance when searching.  The indexes are automatically updated when a merchant makes changes through the administration.  In some cases, such as a direct database update, the index may need to be run manually.</p>
                    <p>If your product or order searches are not returning expected results, or if results do not seem to be properly sorting according to relevance, the search index may need to be rebuilt.  This process can be time consuming if you have a lot of products, users, and/or orders so this should be done at an off-peak time.</p>
                </asp:Localize>
                <asp:Panel ID="ProgressPanel" runat="server" Visible="false">
                    <p><asp:Image ID="ProgressImage" runat="server" SkinID="Progress" /></p>
                    <p><asp:Localize ID="ProgressLabel" runat="server" Text="An index rebuild was started and has been running for {0} minutes and {1} seconds."></asp:Localize></p>
                    <p>Be patient while the process completes. If you believe the rebuild has crashed <asp:LinkButton ID="ResetLink" runat="server" Text="click here" OnClick="ResetLink_Click"></asp:LinkButton> to abort / reset the process.</p>
                </asp:Panel>
                <asp:Panel ID="LastRebuildPanel" runat="server" Visible="false">
                    <p>The index was last rebuilt manually on <asp:Literal ID="LastRebuildDate" runat="server" Text="{0:g}"></asp:Literal>.</p>
                </asp:Panel>
                <asp:Button ID="RebuildIndexButton" runat="server" Text="Rebuild Index" OnClick="RebuildIndexButton_Click" />
                <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
            </asp:PlaceHolder>
            <asp:PlaceHolder ID="SQLFtsPanel" runat="server" Visible="false">
                <asp:Localize ID="Localize1" runat="server">
                <p>If your product searches are not returning expected results or if results do not seem to be properly sorting according to relevance, the search index may need to be rebuilt.  This process can be time consuming if you have a large product catalog, so this should be done at an off-peak time.</p>
                </asp:Localize>
                <asp:Panel ID="ProgressPanelSQLFts" runat="server" Visible="false">
                    <p><asp:Image ID="ProgressImageSQLFts" runat="server" SkinID="Progress" /></p>
                    <p><asp:Localize ID="ProgressLabelSQLFts" runat="server" Text="An index rebuild was started and has been running for {0} minutes and {1} seconds."></asp:Localize></p>
                    <p>Be patient while the process completes. If you believe the rebuild has crashed <asp:LinkButton ID="ResetLinkSQLFts" runat="server" Text="click here" OnClick="ResetLinkSQLFts_Click"></asp:LinkButton> to abort / reset the process.</p>
                </asp:Panel>
                <asp:Panel ID="LastRebuildPanelSQLFts" runat="server" Visible="false">
                    <p>The index was last rebuilt manually on <asp:Literal ID="LastRebuildDateSQLFts" runat="server" Text="{0:g}"></asp:Literal>.</p>
                </asp:Panel>
                <asp:Button ID="RebuildSQLIndexButton" runat="server" Text="Rebuild Index" OnClick="RebuildSQLIndexButton_Click" />
                <asp:Timer ID="Timer2" runat="server" Enabled="False" Interval="5000" OnTick="Timer2_Tick"></asp:Timer>
            </asp:PlaceHolder>
        </ContentTemplate>
	</asp:UpdatePanel>
</div>
</asp:Content>