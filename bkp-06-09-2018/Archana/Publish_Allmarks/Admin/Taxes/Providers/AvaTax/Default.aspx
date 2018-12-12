<%@ Page Language="C#" MasterPageFile="../../../Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Taxes.Providers.AvaTax._Default" Title="Configure Avalara - AvaTax on Demand" CodeFile="Default.aspx.cs" ViewStateMode="Disabled" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Avalara - AvaTax on Demand"></asp:Localize></h1>
    	</div>
    </div>
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="content">
                <cb:Notification ID="SavedMessage" runat="server" Text="The configuration has been saved at {0}." SkinID="GoodCondition" Visible="false"></cb:Notification>
                <p><asp:Label ID="InstructionText" runat="server" Text="This provider will use the Avalara tax service to calculate tax liability for orders placed in your store.  Configure the settings for your account below:"></asp:Label></p>
                <table class="inputForm">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="AccountNumberLabel" runat="server" Text="Account Number:" AssociatedControlID="AccountNumber" CssClass="toolTip" ToolTip="Your AvaTax account number."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="AccountNumber" runat="server" Width="100px"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="AccountNumberRequired" runat="server" ControlToValidate="AccountNumber"
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="LicenseKeyLabel" runat="server" Text="License:" AssociatedControlID="LicenseKey" CssClass="toolTip" ToolTip="The license code associated with your AvaTax account."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="LicenseKey" runat="server" Width="200px" TextMode="password"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="LicenseKeyRequired" runat="server" ControlToValidate="LicenseKey"
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CompanyCodeLabel" runat="server" Text="Company Code:" AssociatedControlID="CompanyCode" CssClass="toolTip" ToolTip="This is the company code you have defined in your Avalara AvaTax dashboard.  If not provided, your default company will be used."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="CompanyCode" runat="server" Width="100px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TaxServiceUrlLabel" runat="server" Text="Tax Service URL:" AssociatedControlID="TaxServiceUrl" CssClass="toolTip" ToolTip="The tax service URL used to connect to the Avalara tax gateway; provided with your AvaTax account details."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="TaxServiceUrl" runat="server" Width="500px"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="ServiceUrlRequired" runat="server" ControlToValidate="TaxServiceUrl"
                                Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="EnableTaxCalculationlabel" runat="server" Text="Enable Tax Calculation:" AssociatedControlID="EnableTaxCalculation" CssClass="toolTip" ToolTip="Indicate whether tax calculation services will be used."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:CheckBox ID="EnableTaxCalculation" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="TaxableProvincesLabel" runat="server" Text="Taxable States:" AssociatedControlID="TaxableProvinces" CssClass="toolTip" ToolTip="If you want tax calculation to only be enabled for specific states or provinces enter them here.  The values should be entered as a comma delimited list of two letter state or province codes, e.g. WA,CA for Washington and California.  Leave this entry blank to enable tax calculation for all supported states and/or provinces"></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="TaxableProvinces" runat="server" Width="300px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="AddressServiceUrlLabel" runat="server" Text="Address Service URL:" AssociatedControlID="AddressServiceUrl" CssClass="toolTip" ToolTip="The address service URL used to connect to the Avalara tax gateway; provided with your AvaTax account details."></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="AddressServiceUrl" runat="server" Width="500px"></asp:TextBox><span class="requiredField">*</span> 
                            <asp:RequiredFieldValidator ID="AddressServiceUrlRequired" runat="server" ControlToValidate="AddressServiceUrl"
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
                            <cb:ToolTipLabel ID="AddressValidationCountriesLabel" runat="server" Text="Validation Countries:" AssociatedControlID="EnableAddressValidation" CssClass="toolTip" ToolTip="If you want address validation to only be enabled for specific countries, enter them here.  The values should be entered as a comma delimited list of two letter country codes, e.g. US,CA for the United States and Canada.  Leave this entry blank to enable address validation for all supported countries"></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="AddressValidationCountries" runat="server" Width="300px"></asp:TextBox>
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
                                                In this mode, tax line items are broken down by jurisdiction and recorded using the tax name provided by the AvaTax service.
                                            </asp:Localize>
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
                            <cb:ToolTipLabel ID="DebugModeLabel" runat="server" Text="Debug Mode:" CssClass="toolTip" ToolTip="When debug mode is enabled, messages sent and received between your store and the Avalara tax gateway are saved to the file App_Data/Logs/AvaTax.log."></cb:ToolTipLabel>
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