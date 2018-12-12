<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Shipping.Countries.AddCountryDialog" CodeFile="AddCountryDialog.ascx.cs" %>
<div class="section">
    <div class="header">
        <h2><asp:Localize ID="AddCaption" runat="server" Text="Add Country" /></h2>
    </div>
    <div class="content">
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="AddCountry" />
        <asp:Label ID="AddedMessage" runat="server" Text="Country {0} added." SkinID="GoodCondition" EnableViewState="false" Visible="false"></asp:Label>
        <table class="inputForm" width="100%">
            <tr>
                <th width="30%">
                    <cb:ToolTipLabel ID="CountryCodeLabel" runat="server" Text="Country Code:" ToolTip="Enter the two letter ISO country code." />
                </th>
                <td id="tdCountryCode" runat="server">
                    <asp:TextBox ID="CountryCode" runat="server" Width="40px" MaxLength="2"></asp:TextBox><span class="requiredField">*</span>
                    <cb:RequiredRegularExpressionValidator ID="CountryCodeValidator" runat="server" ControlToValidate="CountryCode"
                        Display="Static" ErrorMessage="Country code must be a two letter abbreviation.  Use the official ISO 3166 code." Text="*"
                        ValidationGroup="AddCountry" ValidationExpression="[A-Za-z]{2}" Required="true">
                    </cb:RequiredRegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <th>
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="Enter the full name of the country as it should appear." />
                </th>
                <td>
                    <asp:TextBox ID="Name" runat="server" MaxLength="50" width="90%"></asp:TextBox><span class="requiredField">*</span>
                    <cb:RequiredRegularExpressionValidator ID="RequiredRegularExpressionValidator1" runat="server" ControlToValidate="Name"
                        Display="Static" ErrorMessage="Country name must be between 1 and 50 characters in length." Text="*"
                        ValidationGroup="AddCountry" ValidationExpression=".{1,50}" Required="true">
                    </cb:RequiredRegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="AddressFormatLabel" runat="server" Text="Address Format:" ToolTip="Specify the formatting rules for addresses from this country, if different from the default (US standard) format." /><br />
                    <asp:HyperLink ID="AddressFormatHelpLink" runat="server" Text="what's this?" NavigateUrl="AddressFormat.aspx" SkinID="Link" Target="_blank"></asp:HyperLink>
                </th>
                <td valign="top">
                    <asp:TextBox ID="AddressFormat" runat="server" Text="" TextMode="MultiLine" Rows="6" Wrap="false" width="90%"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="AddressFormatValidator" runat="server" ControlToValidate="AddressFormat"
                        Display="Static" ErrorMessage="Address format cannot exceed 200 characters in length." Text="*"
                        ValidationGroup="AddCountry" ValidationExpression="[^\x00]{1,200}">
                    </asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="AddButton" runat="server" Text="Add" SkinID="AddButton" OnClick="AddButton_Click" ValidationGroup="AddCountry" />
                </td>
            </tr>
        </table>
    </div>
</div>