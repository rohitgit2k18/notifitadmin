<%@ Page Title="Button Samples" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Buttons.aspx.cs" Inherits="AbleCommerce.Admin.Skinning.Buttons" %>
<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pageHeader">
	    <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Button Samples"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="Button1" runat="server" Text="Button" />
                <asp:Button ID="Button2" runat="server" Text="Button" />
                <asp:HyperLink ID="HyperLink1" runat="server" Text="HyperLink" SkinID="Button" NavigateUrl="#" />
                <asp:HyperLink ID="HyperLink2" runat="server" Text="HyperLink" SkinID="Button" NavigateUrl="#" />
            </div>
        </div>
    </div>
    <div class="section">
        <div class="content">
            <p><asp:Localize ID="IntroText" runat="server" Text="This page demonstrates the various types of buttons that are commonly used in the AbleCommerce admin.  All button pairs should line up horizontaly."></asp:Localize> </p>
            <asp:Button ID="Button3" runat="server" Text="Button" />
            <asp:Button ID="Button4" runat="server" Text="Button" />
            <asp:HyperLink ID="HyperLink3" runat="server" Text="HyperLink" SkinID="Button" NavigateUrl="#" />
            <asp:HyperLink ID="HyperLink4" runat="server" Text="HyperLink" SkinID="Button" NavigateUrl="#" />
            <table class="inputForm">
                <tr>
                    <th>Sample Field:</th>
                    <td><input type="text" /></td>
                </tr>
                <tr>
                    <th>Sample Field:</th>
                    <td><input type="text" /></td>
                </tr>
                <tr>
                    <th>Sample Field:</th>
                    <td><input type="text" /></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="Button5" runat="server" Text="Button" />
                        <asp:Button ID="Button6" runat="server" Text="Button" />
                        <asp:HyperLink ID="HyperLink5" runat="server" Text="HyperLink" SkinID="Button" NavigateUrl="#" />
                        <asp:HyperLink ID="HyperLink6" runat="server" Text="HyperLink" SkinID="Button" NavigateUrl="#" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>