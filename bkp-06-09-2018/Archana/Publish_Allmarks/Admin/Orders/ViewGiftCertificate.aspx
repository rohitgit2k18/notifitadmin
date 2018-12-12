<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.ViewGiftCertificate" Title="View/Print Gift Certificate" CodeFile="ViewGiftCertificate.aspx.cs" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader noPrint">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="View/Print Gift Certificate - {0}"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="Print" runat="server" Text="Print" OnClientClick="window.print();return false;" />
                <asp:Button ID="Back" runat="server" Text="Back" OnClientClick="window.history.go(-1);return false;" />
            </div>
        </div>
    </div>
    <div class="content">
        <p class="noPrint"><asp:Localize ID="PrintInstructions" runat="server" Text="This document includes a printable stylesheet.  If you are using a modern browser (such as IE7, FF2, or Opera 7) this page will print with appropriate styles and page breaks if needed.  Website headers, footers, and this message will not be printed."></asp:Localize></p>
        <table cellspacing="0" class="report">
            <tr>
                <th colspan="2">
                    <asp:Localize ID="GiftCertificateSummaryCaption" runat="server" Text="GIFT CERTIFICATE"></asp:Localize>
                </th>
            </tr>
            <tr>
                <th>Certificate Number:</th>
                <td><asp:Literal runat="server" ID="Serial"></asp:Literal></td>
            </tr>
            <tr>
                <th>Balance:</th>
                <td><asp:Literal runat="server" ID="Balance"></asp:Literal></td>
            </tr>
            <tr>
                <th>Expiration Date:</th>
                <td><asp:Literal runat="server" ID="Expires"></asp:Literal></td>
            </tr>
            <tr>
                <th>Status Description:</th>
                <td><asp:Literal runat="server" ID="Description"></asp:Literal></td>
            </tr>
            <tr>
                <th>Comment:</th>
                <td><asp:Literal runat="server" ID="Name"></asp:Literal></td>
            </tr>
        </table>    
    </div>
</asp:Content>