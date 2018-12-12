<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Taxes.Providers.WATax._Default" Title="Configure WA DOR" CodeFile="Default.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Department of Revenue WA State Sales Tax"></asp:Localize></h1>
    	</div>
    </div>
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="content">
                <cb:Notification ID="SavedMessage" runat="server" Text="Tax configuration has been saved at {0}." SkinID="GoodCondition" Visible="False" EnableViewState="false"></cb:Notification>
                <p><asp:Label ID="InstructionText" runat="server" Text="This provider will use the Washington Department of Revenue's web service to calculate tax liability for items shipping to a Washington address.  Use the form below to specify the configuration for this provider."></asp:Label></p>
                <table class="inputForm"> 
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TaxNameLabel" runat="server" Text="TaxName:" AssociatedControlID="TaxName" CssClass="toolTip" ToolTip="Name of the tax that will be displayed for tax line items."></cb:ToolTipLabel>
                        </th>
                        <td >
                            <asp:TextBox ID="TaxName" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="TaxNameValidator" runat="server" ControlToValidate="TaxName"
                                    Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>                   
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="DebugModeLabel" runat="server" Text="Debug Mode:" CssClass="toolTip" ToolTip="When debug mode is enabled, messages sent and received between your store and the DOR tax gateway are saved to the file App_Data/Logs/WA_DOR.Log."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="DebugMode" runat="server"/>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <cb:ToolTipLabel ID="TaxCodesLabel" runat="server" Text="Apply to Tax Codes:" CssClass="toolTip" ToolTip="Products can be assigned tax codes.  Select all tax codes that this tax should apply to."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBoxList ID="TaxCodes" runat="server" DataTextField="Name" DataValueField="TaxCodeId" AppendDataBoundItems="true"> </asp:CheckBoxList>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
		                    <asp:HyperLink ID="CancelButton" runat="server" SkinID="Button" Text="Close"   NavigateUrl="../Default.aspx"/>
		                    <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClick="DeleteButton_Click" CausesValidation="false" OnClientClick="javascript:return confirm('Are you sure you wish to delete WA Sales Tax provider?')" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>