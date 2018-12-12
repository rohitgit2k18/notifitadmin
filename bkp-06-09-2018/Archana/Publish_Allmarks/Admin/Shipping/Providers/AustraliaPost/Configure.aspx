<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Providers._AustraliaPost.Configure" title="Configure AustraliaPost&reg;" CodeFile="Configure.aspx.cs" %>
<%@ Register Src="../ProviderShipMethods.ascx" TagName="ShipMethods" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
	    <div class="caption">
		    <h1>Configure Australia Post</h1>
	    </div>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="content">
                <p><asp:Localize ID="InstructionText" runat="server" Text="Specify the AustraliaPost configuration options below."></asp:Localize></p>
                <cb:Notification ID="SavedMessage" runat="server" Text="Configuration has been saved at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EnablePackagingLabel" runat="server" Text="Enable Packaging:" ToolTip="If the weight of an order exceeds the specified maximum weight, should it be broken into multiple packages so that rates can be calculated?" AssociatedControlID="EnablePackaging" />
                        </th>
                        <td>
                            <asp:CheckBox ID="EnablePackaging" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="MaxWeightLabel" runat="server" Text="Maximum Weight:" ToolTip="Maximum package weight to use when requesting rates from the carrier." AssociatedControlID="MaxWeight" />
                        </th>
                        <td>
				            <asp:TextBox ID="MaxWeight" runat="server" Width="60"></asp:TextBox> kgs
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="MinWeightLabel" runat="server" Text="Minimum Weight:" ToolTip="Minimum package weight to use when requesting rates from the carrier." AssociatedControlID="MinWeight" />
                        </th>
                        <td>
					        <asp:TextBox ID="MinWeight" runat="server" Width="60"></asp:TextBox> kgs
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <cb:ToolTipLabel ID="UseDebugModeLabel" runat="server" Text="Debug Mode:" ToolTip="When debug mode is enabled, all messages sent to and received from the shipping gateway are logged. This should only be enabled at the direction of qualified support personnel." AssociatedControlID="UseDebugMode" />
                        </th>
                        <td>
                            <asp:CheckBox ID="UseDebugMode" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click"/>
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
					        <asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" OnClick="CancelButton_Click" />
                        </td>
                    </tr>         
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="section">
        <uc:ShipMethods id="ShipMethods" runat="server"></uc:ShipMethods>
    </div>
</asp:Content>