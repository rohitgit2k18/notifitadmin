<%@ Page Title="UPS OnLine&reg; Tools Licensing &amp; Registration" Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._UPS.License" CodeFile="License.aspx.cs" EnableViewState="false" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader noPrint">
    	<div class="caption">
    		<h1>
                <asp:Label ID="Caption" runat="server" Text="UPS OnLine&reg; Tools Licensing &amp; Registration"></asp:Label>
            </h1>
    	</div>
    </div>
    <div class="grid_2 noPrint">
        <div class="content" style="text-align:center">
            <img src="shield.jpg" hspace="20" vspace="20" alt="UPS Shield" />
        </div>
    </div>
    <div class="grid_10">
        <div class="content">
            <div class="noPrint">
            <asp:Localize ID="InstructionText" runat="server">
            <p>With UPS OnLine&reg; Tools, customers can get real-time shipping rates based on their shipping addresses and order weights. Customers can also view UPS tracking information for their packages right from your store website!</p>
            <p>In order to enable UPS OnLine&reg; Tools, you must register with UPS. Registering with UPS makes sure you stay up-to-date with their latest services, updates, and enhancements. Please note that this registration is designed to establish a relationship between your company and UPS.</p>
            <p>If you do not wish to use any of the functions that utilize the UPS OnLine&reg; Tools, click 'Cancel' to return to the main menu. If, at a later time, you wish to use the UPS OnLine&reg; Tools, return to this section and complete the UPS OnLine&reg; Tools licensing and registration process.</p>
            <p>Please review the licensing agreement and print a copy for your records:</p>
            </asp:Localize>
            </div>
            <div class="license" style="white-space:pre-line;"><asp:Literal ID="LicenseAgreement" runat="server"></asp:Literal></div>
            <div class="noPrint">
                <table class="inputForm compact">
                    <tr>
                        <td>
                            <asp:RadioButton ID="YesButton" runat="server" GroupName="Agree" />
                        </td>
                        <td>
                            Yes, I Do Agree
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButton ID="NoButton" runat="server" GroupName="Agree" />
                        </td>
                        <td>
                            No, I Do Not Agree
                        </td>
                    </tr>
                </table>
                <asp:Button ID="NextButton" runat="server" Text="Next" OnClick="NextButton_Click" />
                <asp:Button ID="PrintButton" runat="server" Text="Print" CausesValidation="false" OnClientClick="window.print();return false;" />
                <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                <br /><br />
                <p><asp:Label ID="UPSCopyRight" runat="server" Text="UPS brandmark, and the Color Brown are trademarks of United Parcel Service of America, Inc. All Rights Reserved." SkinID="Copyright"></asp:Label></p>
            </div>
        </div>
    </div>
</asp:Content>