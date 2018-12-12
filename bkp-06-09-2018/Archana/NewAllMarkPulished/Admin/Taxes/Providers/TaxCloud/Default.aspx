<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Title="Tax Cloud Provider" Inherits="AbleCommerce.Admin.Taxes.Providers.TaxCloud._Default" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="TaxCloud Tax Provider"></asp:Localize></h1>
    	</div>
    </div>
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="content">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="The configuration has been saved at {0}." SkinID="GoodCondition" Visible="false"></cb:Notification>
                <p><asp:Label ID="InstructionText" runat="server" Text="This provider will use the TaxCloud tax service to calculate tax liability for orders placed in your store.  Configure the settings for your account below:"></asp:Label></p>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TaxCloudLabel" runat="server" Text="Enable TaxCloud:" AssociatedControlID="EnableTaxCloud" CssClass="toolTip" ToolTip="Indicate whether tax calculation services will be used."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="EnableTaxCloud" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ApiIdLabel" runat="server" Text="Api ID:" AssociatedControlID="ApiId" CssClass="toolTip" ToolTip="The Api ID associated with your TaxCloud account."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="ApiId" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="ApiIdRequired" runat="server" ControlToValidate="ApiId"
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ApiKeyLabel" runat="server" Text="Api Key:" AssociatedControlID="ApiKey" CssClass="toolTip" ToolTip="The Api Key associated with your TaxCloud account."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="ApiKey" runat="server" Width="320px"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="ApiKeyRequired" runat="server" ControlToValidate="ApiKey" ErrorMessage="API Key is required."
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="DefaultTICLabel" runat="server" Text="Default Product TIC:" AssociatedControlID="DefaultTIC" CssClass="toolTip" ToolTip="This default Tax Information Code will be used when it is not specified for some product."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="DefaultTIC" runat="server" Width="200px" MaxLength="10"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="DefaultTICRequired" runat="server" ControlToValidate="DefaultTIC" ErrorMessage="Default TIC is required."
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ShippingTICLabel" runat="server" Text="Shipping TIC:" AssociatedControlID="ShippingTIC" CssClass="toolTip" ToolTip="This Tax Information Code will be used for shipping line items."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="ShippingTIC" runat="server" Width="200px" MaxLength="10"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="ShippingTICValidator" runat="server" ControlToValidate="ShippingTIC" ErrorMessage="Shipping TIC is required."
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="HandlingTICLabel" runat="server" Text="Handling TIC:" AssociatedControlID="DefaultTIC" CssClass="toolTip" ToolTip="This Tax Information Code will be used for handling line items."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="HandlingTIC" runat="server" Width="200px" MaxLength="10"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="HandlingTICValidator" runat="server" ControlToValidate="HandlingTIC" ErrorMessage="Handling TIC is required."
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="GiftwrapTICLabel" runat="server" Text="Giftwrap TIC:" AssociatedControlID="DefaultTIC" CssClass="toolTip" ToolTip="This Tax Information Code will be used for giftwrap line items."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="GiftwrapTIC" runat="server" Width="200px" MaxLength="10"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="GiftwrapTICValidator" runat="server" ControlToValidate="GiftwrapTIC" ErrorMessage="Giftwrap TIC is required."
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <cb:ToolTipLabel ID="TaxExemptionLabel" runat="server" Text="Use Exemption Certificates:" CssClass="toolTip" ToolTip="Enables use of tax exemption certificates."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="UseTaxExemption" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <cb:ToolTipLabel ID="TaxReportModeLabel" runat="server" Text="Reporting Mode:" CssClass="toolTip" ToolTip="Indicate how taxes calculated by Avalara will be recorded in AbleCommerce."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <table cellspacing="2" cellpadding="0">
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="TaxReportMode_Breakdown" runat="server" GroupName="TaxReportMode" Text="Breakdown" /><br />
                                        <div style="padding-left:20px;padding-top:5px;">
                                            <asp:Localize ID="TaxReportMode_BreakdownHelpText" runat="server">
                                                In this mode, tax line items are broken down by taxable items and recorded using the tax name by product.
                                            </asp:Localize><br />
                                            <cb:ToolTipLabel ID="TaxNameLabel" runat="server" Text="Tax Name:" SkinID="fieldHeader" AssociatedControlID="TaxName" CssClass="toolTip" ToolTip="The tax name to display with the calculated tax amounts."></cb:ToolTipLabel>
                                            <asp:TextBox ID="TaxName" runat="server" Width="200px"></asp:TextBox>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="TaxReportMode_Summary" runat="server" GroupName="TaxReportMode" Text="Summary" /><br />
                                        <div style="padding-left:20px;padding-top:5px;">
                                            <asp:Localize ID="TaxReportMode_SummaryHelpText" runat="server">
                                                In this mode, the total calculated tax is created in a single summary line item, using the tax name specified in the field below.
                                            </asp:Localize><br />
                                            <asp:Label ID="SummaryTaxNameLabel" runat="server" Text="Summary Tax Name:" SkinID="fieldHeader" AssociatedControlID="SummaryTaxName"></asp:Label>
                                            <asp:TextBox ID="SummaryTaxName" runat="server" Width="100px"></asp:TextBox>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TaxServiceUrlLabel" runat="server" Text="Tax Service URL:" AssociatedControlID="TaxServiceUrl" CssClass="toolTip" ToolTip="The tax service URL used to connect to the TaxCloud gateway; provided with your TaxCloud account details."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="TaxServiceUrl" runat="server" Width="320px"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="ServiceUrlRequired" runat="server" ControlToValidate="TaxServiceUrl"
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EnableAddressValidationLabel" runat="server" Text="Enable Address Validation:" AssociatedControlID="EnableAddressValidation" CssClass="toolTip" ToolTip="Indicate whether address validation services will be used."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="EnableAddressValidation" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="USPSUserIdLabel" runat="server" Text="USPS User ID:" AssociatedControlID="USPSUserId" CssClass="toolTip" ToolTip="USPS User Id is needed to validate the customer address information before querying for tax."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="USPSUserId" runat="server" Width="200px"></asp:TextBox>
                            <br /><asp:Label ID="USPSIDHelpText" runat="server" Text="You can create a USPS user ID by filling out the form at " EnableViewState="false"></asp:Label>
                            <asp:HyperLink ID="USPSRegisterLink" runat="server" Text="https://secure.shippingapis.com/registration/" NavigateUrl="https://secure.shippingapis.com/registration/" Target="_blank"></asp:HyperLink>
                        </td>
                    </tr> 
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="DebugModeLabel" runat="server" Text="Debug Mode:" CssClass="toolTip" ToolTip="When debug mode is enabled, messages sent and received between your store and the TaxCloud tax gateway are saved to the file App_Data/Logs/TaxCloud.log."></cb:ToolTipLabel>
                        </th>
                        <td><asp:CheckBox ID="DebugMode" runat="server" /></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:PlaceHolder ID="TestResultPanel" runat="server" Visible="false">
                                <ul>
                                    <li>Test Result: <asp:Literal ID="TestResultCode" runat="server"></asp:Literal></li>
                                    <li id="TestResultMessageLine" runat="server" visible="false">Message: <asp:Literal ID="TestResultMessage" runat="server"></asp:Literal></li>
                                    <li id="ServiceVersionLine" runat="server" visible="false">Tax Service Version: <asp:Literal ID="ServiceVersion" runat="server"></asp:Literal></li>
                                </ul>
                            </asp:PlaceHolder>
                            <asp:Button ID="TestButton" runat="server" Text="Test Connection" OnClick="TestButton_Click" />
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                            <asp:HyperLink ID="CancelButton" runat="server" SkinID="Button" Text="Cancel" NavigateUrl="../Default.aspx" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

