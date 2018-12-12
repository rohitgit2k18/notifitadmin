<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.Account.AffiliateForm" CodeFile="AffiliateForm.ascx.cs" ViewStateMode="Disabled" %>
<%--
<conlib>
<summary>Implements the affiliate data input form</summary>
</conlib>
--%>
<asp:UpdatePanel ID="AffiliateRegAjax" runat="server">
    <ContentTemplate>   
         <asp:Panel ID="AffiliateRegPanel" runat="server" DefaultButton="SaveButton" CssClass="affiliateForm">
            <p>Registered affiliates can obtain credit for referring customers to the store.  AbleCommerce can automatically calculate the amount of commission earned for a particular month, based on the rates configured for the affiliate.  Registered affiliates can also view a report on their sales.  To register as an affiliate, fill out all required fields on the form below and submit.</p>
            <asp:ValidationSummary ID="RegisterValidationSummary" runat="server" ValidationGroup="RegisterAffiliate" />                    
            <cb:Notification ID="SavedMessage" runat="server" Text="Saved successfully." Visible="false" SkinID="Success"></cb:Notification>
            <cb:Notification ID="FailureText" runat="server" Visible="false" SkinID="Error"></cb:Notification>
            <table class="inputForm compact">
                <tr>
                    <th>
                        <asp:Label ID="AffiliatNameLabel" runat="server" Text="Affiliate Name:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Name" runat="server" Width="200px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="Name"
                            Display="Static" ErrorMessage="Affiliate name is required." Text="*" ValidationGroup="RegisterAffiliate"></asp:RequiredFieldValidator>
                    </td>
                    <th>
                        <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="FirstName" runat="server" MaxLength="30" Width="200px"></asp:TextBox>
                    </td> 
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="LastName" runat="server" MaxLength="50" Width="200px"></asp:TextBox>
                    </td>
                    <th>
                        <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email" Text="Email:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Email" runat="server" MaxLength="255" ValidationGroup="RegisterAffiliate" Width="200px"></asp:TextBox>
                        <cb:EmailAddressValidator ID="EmailValidator" runat="server" ControlToValidate="Email" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" ValidationGroup="RegisterAffiliate"></cb:EmailAddressValidator>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="NameLabel" runat="server" Text="Company Name:" />
                    </th>
                    <td>
                        <asp:TextBox ID="Company" runat="server" MaxLength="100" ValidationGroup="RegisterAffiliate" Width="200px"></asp:TextBox>    
                    </td>
                    <th>
                        <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Address1" runat="server" EnableViewState="false" MaxLength="100" ValidationGroup="RegisterAffiliate" Width="200px"></asp:TextBox> 
                        <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                            ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1" ValidationGroup="RegisterAffiliate"
                            EnableViewState="false"></asp:RequiredFieldValidator>
                    </td>   
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Address2" runat="server" EnableViewState="false" MaxLength="100" Width="200px"></asp:TextBox> 
                    </td> 
                    <th>
                        <asp:Label ID="WebsiteUrlLabel" runat="server" Text="Website Url:" AssociatedControlID="WebsiteUrl"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="WebsiteUrl" runat="server" MaxLength="255" Width="280px"></asp:TextBox>
                    </td>     
                </tr> 
                <tr>
                    <th>
                        <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="City" runat="server" EnableViewState="false" MaxLength="30" ValidationGroup="RegisterAffiliate" Width="200px"></asp:TextBox> 
                        <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*" ValidationGroup="RegisterAffiliate"
                            ErrorMessage="City is required." Display="Static" ControlToValidate="City"
                            EnableViewState="false"></asp:RequiredFieldValidator>
                    </td>
                    <th>
                        <asp:Label ID="CountryLabel" runat="server" AssociatedControlID="Country" Text="Country:"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode" 
                        OnSelectedIndexChanged="Country_Changed" AutoPostBack="true" EnableViewState="false"></asp:DropDownList>                     
                    </td>                  
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Province" runat="server" MaxLength="50" ValidationGroup="RegisterAffiliate"></asp:TextBox> 
                        <asp:DropDownList ID="Province2" runat="server"></asp:DropDownList>
                        <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*" ValidationGroup="RegisterAffiliate"
                            ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2"></asp:RequiredFieldValidator>
                    </td>  
                    <th>
                        <asp:Label ID="PostalCodeLabel" runat="server" AssociatedControlID="PostalCode" Text="Zip/Postal Code:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="PostalCode" runat="server" EnableViewState="false" MaxLength="10" ValidationGroup="RegisterAffiliate" Width="80px"></asp:TextBox> 
                        <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*" ValidationGroup="RegisterAffiliate"
                            ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="PhoneLabel" runat="server" AssociatedControlID="Phone" Text="Phone:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="Phone" runat="server" MaxLength="255" ValidationGroup="RegisterAffiliate" Width="200px"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="PhoneRequired" runat="server" ControlToValidate="Phone"
                            ErrorMessage="Phone number is required" Text="*" ValidationGroup="RegisterAffiliate"></asp:RequiredFieldValidator>
                    </td>
                    <th>
                        <asp:Label ID="FaxNumberLabel" runat="server" Text="Fax Number:" AssociatedControlID="FaxNumber"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="FaxNumber" runat="server" Width="200px" MaxLength="20"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="MobileNumberLabel" runat="server" Text="Mobile Number:" AssociatedControlID="MobileNumber"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="MobileNumber" runat="server" MaxLength="20" Width="200px"></asp:TextBox>
                    </td>
                    <th>
                        <asp:Label ID="TaxIdLabel" runat="server" Text="Tax ID:" AssociatedControlID="TaxId" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="TaxId" runat="server" MaxLength="250" Width="200" ValidationGroup="RegisterAffiliate"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="TaxIDRequired" runat="server" Text="*"
                            ErrorMessage="Tax Id is required." ControlToValidate="TaxId"
                            EnableViewState="False" SetFocusOnError="false" Display="Dynamic" ValidationGroup="RegisterAffiliate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="TaxIdNumberValidator" runat="server" 
                            ErrorMessage="Tax Id must be a 9 digit number (without hyphen)." 
                            ControlToValidate="TaxId" Display="Dynamic" CssClass="requiredField" Text="*" 
                            ValidationExpression="^[0-9]{9}$" ValidationGroup="RegisterAffiliate"></asp:RegularExpressionValidator>
                    </td>
               </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="SaveButton" runat="server" Text="Save" ValidationGroup="RegisterAffiliate" OnClick="SaveButton_Click" />
                        <asp:Button ID="SaveAndClose" runat="server" Text="Save and Close" ValidationGroup="RegisterAffiliate" OnClick="SaveAndClose_Click" />
                        <asp:Button ID="CancelButon" runat="server" Text="Cancel" CausesValidation="false" OnClick="CancelButton_Click" />
                    </td>
                </tr>
           </table>
        </asp:Panel>
    </ContentTemplate>        
</asp:UpdatePanel>