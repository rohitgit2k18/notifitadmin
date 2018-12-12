<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FedExDisclaimer.ascx.cs" Inherits="AbleCommerce.ConLib.FedExDisclaimer" %>
<%--
<conlib>
<summary>Control to display FedEx disclaimer</summary>
</conlib>
--%>
<asp:UpdatePanel ID="U" runat="server" UpdateMode="Always">
<ContentTemplate>
<div class="info">
<span class="disclaimer"><asp:Literal ID="D" runat="server" Text="<br /><p>The FedEx service marks are owned by Federal Express Corporation and are used by permission.</p>" Visible="false"></asp:Literal></div>
</div>
</ContentTemplate>
</asp:UpdatePanel>