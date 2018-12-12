<%@ Page Title="Edit Billing Address" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="EditBillingAddress.aspx.cs" Inherits="AbleCommerce.Mobile.Members.EditBillingAddress" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" runat="server">
<div id="accountPage">
<div id="account_editAddressPage" class="mainContentWrapper">
    <div class="section">
        <div class="header">
            <h2>Edit Address</h2>
        </div>
<div class="content">
    <asp:Panel ID="EditAddressPanel" runat="server" DefaultButton="EditSaveButton" CssClass="tabpane">
        <asp:UpdatePanel ID="EditAddressAjax" runat="server">
            <ContentTemplate>
                <h2>
                    <asp:Localize ID="EditAddressCaption" runat="server" Text="Edit Billing Address for Order # {0}"></asp:Localize></h2>
                <div class="inputForm">
                    <div class="field">
                        <asp:Label ID="BillToFirstNameLabel" runat="server" Text="First Name:" CssClass="fieldHeader" AssociatedControlID="BillToFirstName" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToFirstName" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span>
                            <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                ErrorMessage="First name is required." Display="Static" ControlToValidate="BillToFirstName" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToLastNameLabel" runat="server" Text="Last Name:" CssClass="fieldHeader" AssociatedControlID="BillToLastName" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToLastName" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox><span class="requiredField">(R)</span>
                            <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                ErrorMessage="Last name is required." Display="Static" ControlToValidate="BillToLastName"
                                EnableViewState="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToCountryLabel" runat="server" Text="Country:" CssClass="fieldHeader" AssociatedControlID="BillToCountry" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:DropDownList ID="BillToCountry" runat="server" DataTextField="Name" DataValueField="CountryCode"
                                OnSelectedIndexChanged="BillToCountry_Changed" AutoPostBack="true">
                            </asp:DropDownList>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToCompanyLabel" runat="server" Text="Company:" CssClass="fieldHeader" AssociatedControlID="BillToCompany" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToCompany" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToAddress1Label" runat="server" Text="Address 1:" CssClass="fieldHeader" AssociatedControlID="BillToAddress1" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToAddress1" runat="server" EnableViewState="false" MaxLength="100"></asp:TextBox><span class="requiredField">(R)</span>
                            <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                ErrorMessage="Address is required." Display="Static" ControlToValidate="BillToAddress1"
                                EnableViewState="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToAddress2Label" runat="server" Text="Address 2:" CssClass="fieldHeader" AssociatedControlID="BillToAddress2" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToAddress2" runat="server" EnableViewState="false" MaxLength="100"></asp:TextBox>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToCityLabel" runat="server" Text="City:" AssociatedControlID="BillToCity" CssClass="fieldHeader" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToCity" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox><span class="requiredField">(R)</span>
                            <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                ErrorMessage="City is required." Display="Static" ControlToValidate="BillToCity"
                                EnableViewState="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToProvinceLabel" runat="server" Text="State / Province:" CssClass="fieldHeader" AssociatedControlID="BillToProvinceList" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToProvince" runat="server" Visible="false" EnableViewState="false" MaxLength="50" Width="200px"></asp:TextBox>
                            <asp:DropDownList ID="BillToProvinceList" runat="server"></asp:DropDownList><span class="requiredField">(R)</span>
                            <asp:CustomValidator ID="BillToProvinceInvalid" runat="server" Text="*"
                                ErrorMessage="The state or province you entered was not recognized.  Please choose from the list." Display="Dynamic" ControlToValidate="BillToProvinceList" ValidationGroup="EditBillAddress"></asp:CustomValidator>
                            <asp:RequiredFieldValidator ID="BillToProvinceRequired" runat="server" Text="*"
                                ErrorMessage="State or province is required." Display="Static" ControlToValidate="BillToProvinceList" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToPostalCodeLabel" runat="server" Text="ZIP / Postal Code:" CssClass="fieldHeader" AssociatedControlID="BillToPostalCode" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToPostalCode" runat="server" EnableViewState="false" MaxLength="10"></asp:TextBox><span class="requiredField">(R)</span>
                            <asp:RequiredFieldValidator ID="BillToPostalCodeRequired" runat="server" Text="*"
                                ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="BillToPostalCode" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="field">
                        <asp:Label ID="BillToPhoneLabel" runat="server" Text="Phone:" CssClass="fieldHeader" AssociatedControlID="BillToPhone" EnableViewState="false"></asp:Label>
                        <span class="fieldValue">
                            <asp:TextBox ID="BillToPhone" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span>
                            <asp:RequiredFieldValidator ID="BillToPhoneRequired" runat="server" Text="*" ErrorMessage="Phone number is required." Display="Static" ControlToValidate="BillToPhone"
                                EnableViewState="False" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
                        </span>
                    </div>
                    <div class="validationSummary">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" EnableViewState="false" ValidationGroup="EditBillAddress" />
                    </div>
                    <div class="buttons">
                        <asp:Button ID="EditSaveButton" runat="server" Text="Save" OnClick="EditSaveButton_Click" ValidationGroup="EditBillAddress"></asp:Button>
                        <asp:Button ID="EditCancelButton" runat="server" Text="Cancel" OnClick="EditCancelButton_Click" CausesValidation="false" EnableViewState="false"></asp:Button>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>
    </div>
</div>
</div>
</div>
</asp:Content>






