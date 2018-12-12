<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BillingAddress.ascx.cs" Inherits="AbleCommerce.ConLib.Account.BillingAddress" %>
<%--
<conlib>
<summary>Displays the user billing address for a specific order.</summary> 
</conlib>
--%>
<div class="widget billingAddressWidget">
    <div class="header">
	    <h2><asp:Localize ID="BillingAddressCaption" runat="server" Text="Billing Address"></asp:Localize></h2>
    </div>
    <div class="content">
        <div class="billingAddress">
            <span class="editLink">
                <asp:LinkButton ID="EditAddressLink" runat="server" Text="Edit" EnableViewState="false" OnClick="EditAddressButton_Click"></asp:LinkButton>
            </span>
            <asp:Literal ID="AddressData" runat="server"></asp:Literal>
        </div>
    </div>
</div>
<asp:Panel ID="EditBillInfoDialog" runat="server" Style="display:none; width:500px;" CssClass="modalPopup">
    <asp:Panel ID="EditBillInfoDialogHeader" runat="server" CssClass="modalPopupHeader" EnableViewState="false">
        <asp:Label ID="EditBillInfoDialogCaption" runat="server" Text="Edit Order Billing Address" EnableViewState="false"></asp:Label>
    </asp:Panel>
    <asp:PlaceHolder ID="EditBillAddressPanel" runat="server" Visible="false">
        <table class="inputForm" cellpadding="3">
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToFirstNameLabel" runat="server" Text="First Name:" AssociatedControlID="BillToFirstName" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToFirstName" runat="server" EnableViewState="false" Width="120px" MaxLength="20" ValidationGroup="EditBillAddress"></asp:TextBox> 
				    <asp:RequiredFieldValidator ID="BillToFirstNameRequired" runat="server" Text="*"
					    ErrorMessage="First name is required." Display="Static" ControlToValidate="BillToFirstName"
					    EnableViewState="False" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
		    <tr>                        
			    <th class="rowHeader">
				    <asp:Label ID="BillToLastNameLabel" runat="server" Text="Last Name:" AssociatedControlID="BillToLastName" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToLastName" runat="server" EnableViewState="false" Width="120px" MaxLength="30" ValidationGroup="EditBillAddress"></asp:TextBox> 
				    <asp:RequiredFieldValidator ID="BillToLastNameRequired" runat="server" Text="*"
					    ErrorMessage="Last name is required." Display="Static" ControlToValidate="BillToLastName"
					    EnableViewState="False" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToCountryLabel" runat="server" Text="Country:" AssociatedControlID="BillToCountry" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:DropDownList ID="BillToCountry" runat="server" DataTextField="Name" DataValueField="CountryCode" 
					    AutoPostBack="true" Width="200px" OnSelectedIndexChanged="BillToCountry_Changed"></asp:DropDownList>
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToCompanyLabel" runat="server" Text="Company:" AssociatedControlID="BillToCompany" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToCompany" runat="server" EnableViewState="false" Width="200px" MaxLength="50"></asp:TextBox> 
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToAddress1Label" runat="server" Text="Address 1:" AssociatedControlID="BillToAddress1" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToAddress1" runat="server" EnableViewState="false" Width="200px" MaxLength="100" ValidationGroup="EditBillAddress"></asp:TextBox> 
				    <asp:RequiredFieldValidator ID="BillToAddress1Required" runat="server" Text="*"
					    ErrorMessage="Billing address is required." Display="Static" ControlToValidate="BillToAddress1"
					    EnableViewState="false" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToAddress2Label" runat="server" Text="Address 2:" AssociatedControlID="BillToAddress2" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToAddress2" runat="server" EnableViewState="false" Width="200px" MaxLength="100"></asp:TextBox> 
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToCityLabel" runat="server" Text="City:" AssociatedControlID="BillToCity" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToCity" runat="server" EnableViewState="false" Width="200px" MaxLength="50" ValidationGroup="EditBillAddress"></asp:TextBox> 
				    <asp:RequiredFieldValidator ID="BillToCityRequired" runat="server" Text="*"
					    ErrorMessage="Billing city is required." Display="Static" ControlToValidate="BillToCity"
					    EnableViewState="false" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToProvinceLabel" runat="server" Text="State / Province:" AssociatedControlID="BillToProvince" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToProvince" runat="server" Visible="false" EnableViewState="false" MaxLength="50" Width="200px"></asp:TextBox> 
				    <asp:DropDownList ID="BillToProvinceList" runat="server" Width="200px"></asp:DropDownList>
				    <asp:RequiredFieldValidator ID="BillToProvinceRequired" runat="server" Text="*"
					    ErrorMessage="Billing state or province is required." Display="Static" ControlToValidate="BillToProvinceList" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToPostalCodeLabel" runat="server" Text="ZIP / Postal Code:" AssociatedControlID="BillToPostalCode" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToPostalCode" runat="server" EnableViewState="false" Width="90px" MaxLength="10" ValidationGroup="EditBillAddress"></asp:TextBox> 
				    <asp:RequiredFieldValidator ID="BillToPostalCodeRequired" runat="server" Text="*"
					    ErrorMessage="Billing ZIP or Postal Code is required." Display="Static" ControlToValidate="BillToPostalCode"
					    EnableViewState="False" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
		    <tr>
			    <th class="rowHeader">
				    <asp:Label ID="BillToPhoneLabel" runat="server" Text="Phone:" AssociatedControlID="BillToPhone" EnableViewState="false"></asp:Label>
			    </th>
			    <td>
				    <asp:TextBox ID="BillToPhone" runat="server" EnableViewState="false" Width="200px" MaxLength="30"></asp:TextBox> 
				    <asp:RequiredFieldValidator ID="BillToPhoneRequired" runat="server" Text="*"
					    ErrorMessage="Phone number number is required." Display="Static" ControlToValidate="BillToPhone"
					    EnableViewState="False" SetFocusOnError="false" ValidationGroup="EditBillAddress"></asp:RequiredFieldValidator>
			    </td>
		    </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:ValidationSummary ID="EditValidationSummary" runat="server" EnableViewState="false" ValidationGroup="EditBillAddress"/>
                    <asp:Button ID="UpdateBillInfoButton" runat="server" Text="Update" OnClick="UpdateBillInfoButton_Click" ValidationGroup="EditBillAddress" />
                    <asp:Button ID="CancelBillInfoButton" runat="server" Text="Cancel" CausesValidation="false" EnableViewState="false"></asp:Button>
                </td>
            </tr>
	    </table>
    </asp:PlaceHolder>
</asp:Panel>
<asp:LinkButton ID="DummyLink" runat="server" EnableViewState="false" />
<asp:LinkButton ID="DummyCancelBillAddressLink" runat="server" EnableViewState="false" />
<ajaxToolkit:ModalPopupExtender ID="EditBillInfoPopup" runat="server"
    TargetControlID="DummyLink"
    PopupControlID="EditBillInfoDialog" 
    BackgroundCssClass="modalBackground"                         
    CancelControlID="CancelBillInfoButton" 
    DropShadow="false"
    PopupDragHandleControlID="EditBillInfoDialogHeader" />