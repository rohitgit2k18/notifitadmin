<%@ Page Title="" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="EditMyAddress.aspx.cs" Inherits="AbleCommerce.Mobile.Members.EditMyAddress" %>
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
                            <h2><asp:Localize ID="EditAddressCaption" runat="server" Text="{0} {1} Address"></asp:Localize></h2>
                           <div class="inputForm">
                                <div class="field">
                                        <asp:Label ID="FirstNameLabel" runat="server" Text="First Name:" CssClass="fieldHeader" AssociatedControlID="FirstName" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="FirstName" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox><span class="requiredField">(R)</span> 
                                        <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" Text="*"
                                            ErrorMessage="First name is required." Display="Static" ControlToValidate="FirstName"></asp:RequiredFieldValidator>
                                    </span>
                                </div>
                               <div class="field">
                                        <asp:Label ID="LastNameLabel" runat="server" Text="Last Name:" CssClass="fieldHeader" AssociatedControlID="LastName" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="LastName" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox><span class="requiredField">(R)</span> 
                                        <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" Text="*"
                                            ErrorMessage="Last name is required." Display="Static" ControlToValidate="LastName"
                                            EnableViewState="false"></asp:RequiredFieldValidator>
                                    </span>
                                </div>
                                <div class="field">
                                        <asp:Label ID="CompanyLabel" runat="server" Text="Company:" CssClass="fieldHeader" AssociatedControlID="Company" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Company" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox> 
                                    </span>
                                </div>
                               <div class="field">
                                        <asp:Label ID="PhoneLabel" runat="server" Text="Phone:" CssClass="fieldHeader" AssociatedControlID="Phone" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Phone" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox> 
                                    </span>
                                </div>
                                <div class="field">
                                        <asp:Label ID="Address1Label" runat="server" Text="Street Address 1:" CssClass="fieldHeader" AssociatedControlID="Address1" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Address1" runat="server" EnableViewState="false" MaxLength="100"></asp:TextBox><span class="requiredField">(R)</span> 
                                        <asp:RequiredFieldValidator ID="Address1Required" runat="server" Text="*"
                                            ErrorMessage="Address is required." Display="Static" ControlToValidate="Address1"
                                            EnableViewState="false"></asp:RequiredFieldValidator>
                                    </span>
                                </div>
                                <div class="field">
                                        <asp:Label ID="Address2Label" runat="server" Text="Street Address 2:" CssClass="fieldHeader" AssociatedControlID="Address2" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Address2" runat="server" EnableViewState="false" MaxLength="100"></asp:TextBox> 
                                    </span>
                                </div>
                                <div class="field">
                                        <asp:Label ID="CityLabel" runat="server" Text="City:" AssociatedControlID="City" CssClass="fieldHeader" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="City" runat="server" EnableViewState="false" MaxLength="50"></asp:TextBox><span class="requiredField">(R)</span> 
                                        <asp:RequiredFieldValidator ID="CityRequired" runat="server" Text="*"
                                            ErrorMessage="City is required." Display="Static" ControlToValidate="City"
                                            EnableViewState="false"></asp:RequiredFieldValidator>
                                    </span>
                                </div>
                                <div class="field">
                                        <asp:Label ID="CountryLabel" runat="server" Text="Country:" CssClass="fieldHeader" AssociatedControlID="Country" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:DropDownList ID="Country" runat="server" DataTextField="Name" DataValueField="CountryCode"
                                            OnSelectedIndexChanged="Country_Changed" AutoPostBack="true"></asp:DropDownList>
                                    </span>                         
                                </div>
                                <div class="field">
                                        <asp:Label ID="ProvinceLabel" runat="server" Text="State / Province:" CssClass="fieldHeader" AssociatedControlID="Province" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Province" runat="server" MaxLength="30"></asp:TextBox> 
                                        <asp:DropDownList ID="Province2" runat="server"></asp:DropDownList><span class="requiredField">(R)</span>
                                        <asp:CustomValidator ID="Province2Invalid" runat="server" Text="*"
                                            ErrorMessage="The state or province you entered was not recognized.  Please choose from the list." Display="Dynamic" ControlToValidate="Province2"></asp:CustomValidator>
                                        <asp:RequiredFieldValidator ID="Province2Required" runat="server" Text="*"
                                            ErrorMessage="State or province is required." Display="Static" ControlToValidate="Province2"></asp:RequiredFieldValidator>
                                    </span>
                                 </div>
                                 <div class="field">
                                        <asp:Label ID="PostalCodeLabel" runat="server" Text="ZIP / Postal Code:" CssClass="fieldHeader" AssociatedControlID="PostalCode" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="PostalCode" runat="server" EnableViewState="false" MaxLength="10"></asp:TextBox><span class="requiredField">(R)</span> 
                                        <asp:RequiredFieldValidator ID="PostalCodeRequired" runat="server" Text="*"
                                            ErrorMessage="ZIP or Postal Code is required." Display="Static" ControlToValidate="PostalCode"></asp:RequiredFieldValidator>
                                    </span>
                                 </div>
                                <div class="field">
                                        <asp:Label ID="FaxLabel" runat="server" Text="Fax:" AssociatedControlID="Fax" CssClass="fieldHeader" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:TextBox ID="Fax" runat="server" EnableViewState="false" MaxLength="30"></asp:TextBox> 
                                    </span>
                                 </div>
                                 <div class="field">
                                        <asp:Label ID="ResidenceLabel" runat="server" Text="Type:" CssClass="fieldHeader" AssociatedControlID="Residence" EnableViewState="false"></asp:Label>
                                    <span class="fieldValue">
                                        <asp:DropDownList ID="Residence" runat="server" EnableViewState="false">
                                            <asp:ListItem Text="This is a residence" Value="1" Selected="true"></asp:ListItem>
                                            <asp:ListItem Text="This is a business" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </span>
                                 </div>
                                <div class="validationSummary">
                                        <asp:ValidationSummary ID="EditValidationSummary" runat="server" EnableViewState="false" />
                                </div>
                                <div class="buttons">
                                    <asp:Button ID="EditSaveButton" runat="server" Text="Save" OnClick="EditSaveButton_Click"></asp:Button>
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