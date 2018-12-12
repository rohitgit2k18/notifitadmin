<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="EditShipAddress.aspx.cs" Inherits="AbleCommerce.Mobile.Checkout.EditShipAddress" %>
<%@ Register src="~/Mobile/UserControls/CheckoutNavBar.ascx" tagname="CheckoutNavBar" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="server">
    <uc1:CheckoutNavBar ID="CheckoutNavBar" runat="server" />
    <div id="checkoutPage">
        <div id="checkout_editShipAddrPage" class="mainContentWrapper">
            <div class="pageHeader">
                <h1><asp:Localize ID="Caption" runat="server" Text="Shipping Address"></asp:Localize></h1>
            </div>
            <div class="section">
                <div class="content">
                    <div class="inputForm">
                        <div class="validationSummary">
                            <asp:ValidationSummary ID="AddValidationSummary" runat="server" ShowSummary="true" ValidationGroup="AddrBook" />
                        </div>
                        <div class="field">
                            <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="FirstName" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="FirstName" runat="server" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*" ErrorMessage="First name is required." Display="Static" ControlToValidate="FirstName" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="LastName" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="LastName" runat="server" MaxLength="50"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*" ErrorMessage="Last name is required." Display="Static" ControlToValidate="LastName" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="CompanyLabel" runat="server" Text="Company:" AssociatedControlID="Company" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Company" runat="server" MaxLength="50"></asp:TextBox>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" AssociatedControlID="Address1" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Address1" runat="server" MaxLength="100"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*" ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" AssociatedControlID="Address2" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Address2" runat="server" MaxLength="100"></asp:TextBox>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="City" runat="server" MaxLength="50"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*" ErrorMessage="City is required."
                                    Display="Static" ControlToValidate="City" ValidationGroup="AddrBook"></asp:RequiredFieldValidator>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="CountryLabel" runat="server" Text="Country:" AssociatedControlID="Country" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode"
                                    OnSelectedIndexChanged="Country_Changed" AutoPostBack="true" AppendDataBoundItems="false">
                                    <%-- provide a default to prevent validation errors on initial load --%>
                                    <asp:ListItem Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="Province" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Province" runat="server" MaxLength="30"></asp:TextBox> 
                                <asp:DropDownList ID="Province2" runat="server"></asp:DropDownList>
                                <span class="requiredField">(R)</span>
                                <asp:CustomValidator ID="Province2Invalid" runat="server" Text="*"
                                    ErrorMessage="The state or province you entered was not recognized.  Please choose from the list." Display="Dynamic" ControlToValidate="Province2"></asp:CustomValidator>
                                <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                    ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2"></asp:RequiredFieldValidator>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="PostalCode" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="PostalCode" runat="server" MaxLength="10"></asp:TextBox><span class="requiredField">(R)</span>
                                <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                            ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
                           </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="PhoneLabel" runat="server" Text="Telephone:" AssociatedControlID="Phone" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Phone" runat="server" MaxLength="30"></asp:TextBox>
                            </span>
                        </div>
                        <div class="field">
                            <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax" CssClass="fieldHeader"></asp:Label>
                            <span class="fieldValue">
                                <asp:TextBox ID="Fax" runat="server" MaxLength="30"></asp:TextBox>
                            </span>
                        </div>
                        <div class="field">
                            <span class="fieldValue">
                                <asp:CheckBox ID="IsBusiness" runat="server" Text="Check box if this is a business address." />
                            </span>
                        </div>
                        <div class="buttons">
                            <asp:Button ID="SaveButton" runat="server" Text="Save Address" ValidationGroup="AddrBook" CssClass="button" OnClick="EditSaveButton_Click"></asp:Button>
                            <asp:Button ID="CancelButton" runat="server" Text="Cancel" CausesValidation="false" CssClass="button" OnClick="EditCancelButton_Click"></asp:Button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
