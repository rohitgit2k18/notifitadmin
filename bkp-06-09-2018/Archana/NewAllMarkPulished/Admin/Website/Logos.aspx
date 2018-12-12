<%@ Page Title="Store Logos" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeFile="Logos.aspx.cs" Inherits="AbleCommerce.Admin.Website.Logos" ViewStateMode="Disabled" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <script language="javascript" type="text/javascript">
        function verifyUploadFile() {
            var fileUpload = document.getElementById('<%=NewWebsiteLogo.ClientID %>');
            if (!verifyFileExtension(fileUpload.value)) return false;
            fileUpload = document.getElementById('<%=NewPrintableLogo.ClientID %>');
            return verifyFileExtension(fileUpload.value);
        }

        function verifyFileExtension(fileName) {
            // ignore empty fields
            if (fileName == '') { return true; }

            // get the file name
            while (fileName.indexOf("\\") != -1)
                fileName = fileName.slice(fileName.indexOf("\\") + 1);

            // get the file extension                      
            var ext = fileName.slice(fileName.indexOf(".")).toLowerCase();
            if (ext == ".gif" || ext == ".jpg" || ext == ".png") {  return true; }
            else
            {
                alert("You can only upload '.gif', '.jpg' or '.png' files for logos.");
                return false;
            }
        }
</script>
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Store Logos"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="website" />
    	</div>
    </div>
    <div class="content">
        <p><asp:Literal ID="LogoHelpText" runat="server" Text="Use the form below to change your logo image on the store website. You may upload any gif, png, or jpg file to use for the logo.  Logos are theme specific so if you use multiple themes in your site be sure to update them for all themes in use."></asp:Literal></p>
        <table class="inputForm">
            <tr>                                
                <th valign="top">
                    <cb:ToolTipLabel ID="ActiveThemeLabel" runat="server" Text="Theme:" ToolTip="Select the theme to view and update logos for." AssociatedControlID="ActiveTheme"></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="ActiveTheme" runat="server" DataTextField="DisplayName" DataValueField="Name" AutoPostBack="True"></asp:DropDownList>
                </td>
            </tr>
            <tr>                                
                <th valign="top">
                    <cb:ToolTipLabel ID="WebsiteLogoLabel" runat="server" Text="Website Logo:" ToolTip="The website logo is used for display in the store header."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:PlaceHolder ID="WebsiteLogo" runat="server"></asp:PlaceHolder>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NewWebsiteLogoLabel" runat="server" Text="Replace:" ToolTip="Choose a file to replace the website logo." AssociatedControlID="NewWebsiteLogo"></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:FileUpload ID="NewWebsiteLogo" runat="server" Width="300" CssClass="fileUpload" Size="50" /><br />                                    
                </td>
            </tr>
            <tr>                                
                <th valign="top">
                    <cb:ToolTipLabel ID="PrintableLogoLabel" runat="server" Text="Printable Logo:" ToolTip="If provided, the printable logo will be displayed on invoices and packing slips printed via the admin."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:PlaceHolder ID="PrintableLogo" runat="server"></asp:PlaceHolder>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NewPrintableLogoLabel" runat="server" Text="Replace:" ToolTip="Choose a file to replace the printable logo." AssociatedControlID="NewPrintableLogo"></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:FileUpload ID="NewPrintableLogo" runat="server" Width="300" CssClass="fileUpload" Size="50" /><br />                                    
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="UpdateButton" runat="server" Text="Update" OnClick="UpdateButton_Click" OnClientClick="return verifyUploadFile();" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
