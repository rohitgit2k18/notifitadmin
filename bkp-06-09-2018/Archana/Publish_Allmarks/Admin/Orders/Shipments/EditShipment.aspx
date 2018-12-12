<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.EditShipment" Title="Edit Shipment" CodeFile="EditShipment.aspx.cs" EnableViewState="false" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Edit Shipment for Order #{0}"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="section">
        <div class="header">
            <asp:Localize ID="EditShipmentCaption" runat="server" Text="Edit Shipment #{0}"></asp:Localize>
        </div>
        <div class="content">
            <table cellspacing="0" class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="ShipToFirstNameLabel" runat="server" Text="First Name:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToFirstName" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="ShipToFirstNameValidator" runat="server" ControlToValidate="ShipToFirstName" ErrorMessage="First name is required." Text="*"></asp:RequiredFieldValidator>
                    </td>
                    <th>
                        <asp:Label ID="ShipToLastNameLabel" runat="server" Text="Last Name:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToLastName" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="ShipToLastNameValidator" runat="server" ControlToValidate="ShipToLastName" ErrorMessage="Last name is required." Text="*"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ShipToCompanyLabel" runat="server" Text="Company:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToCompany" runat="server" Width="200px"></asp:TextBox>
                    </td>
            
                    <th>
                        <asp:Label ID="ShipToPhoneLabel" runat="server" Text="Phone:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToPhone" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ShipToAddress1Label" runat="server" Text="Street Address 1:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToAddress1" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="ShipToAddress1Validator" runat="server" ControlToValidate="ShipToAddress1" ErrorMessage="First line of street address is required." Text="*"></asp:RequiredFieldValidator>
                    </td>
                    <th>
                        <asp:Label ID="ShipToAddress2Label" runat="server" Text="Street Address 2:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToAddress2" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ShipToCityLabel" runat="server" Text="City:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToCity" runat="server" Width="200px"></asp:TextBox><span class="requiredField">*</span>
                        <asp:RequiredFieldValidator ID="ShipToCityValidator" runat="server" ControlToValidate="ShipToCity" ErrorMessage="City is required." Text="*"></asp:RequiredFieldValidator>
                    </td>
                    <th>
                        <asp:Label ID="ShipToProvinceLabel" runat="server" Text="State / Province:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToProvince" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ShipToPostalCodeLabel" runat="server" Text="ZIP / Postal Code:"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToPostalCode"  Width="200px" runat="server"></asp:TextBox>
                    </td>
            
                    <th>
                        <asp:Label ID="ShipToCountryCodeLabel" runat="server" Text="Country:"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="ShipToCountryCode" runat="server" DataTextField="Name" DataValueField="CountryCode"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="ShipToFaxLabel" runat="server" Text="Fax:" AssociatedControlID="ShipToFax" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:TextBox ID="ShipToFax" runat="server" Width="200px" MaxLength="30"></asp:TextBox> 
                    </td>
                    <th>
                        <asp:Label ID="ShipToResidenceLabel" runat="server" Text="Type:" AssociatedControlID="ShipToResidence" EnableViewState="false"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="ShipToResidence" runat="server" >
                            <asp:ListItem Text="This is a residence" Value="1" Selected="true"></asp:ListItem>
                            <asp:ListItem Text="This is a business" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr>
                    <th>
                        <asp:Label ID="ShipFromLabel" runat="server" Text="Ship From:"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:DropDownList ID="ShipFrom" runat="server" DataTextField="Name" DataValueField="Id" AppendDataBoundItems="true">
                            <asp:ListItem Text=""></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th valign="top">
                        <asp:Label ID="ShipMessageLabel" runat="server" Text="Customer Comment:"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:TextBox ID="ShipMessage" runat="server" Height="25px" Rows="3" Width="500px" MaxLength="255" TextMode="multiLine" Wrap="true" onKeyUp="javascript:Check(this, 255);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="TrackingNumbersLabel" runat="server" Text="Tracking Number:"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:GridView ID="TrackingGrid" DataSourceID="TrackingNumberDs" runat="server" AutoGenerateColumns="false" DataKeyNames="Id" ShowHeader="false" ShowFooter="false" BorderWidth="0" GridLines="None">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:TextBox ID="TrackingNumberData"  Width="300px" runat="server" Text='<%#Eval("TrackingNumberData")%>'></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr id="trAddTrackingNumber" runat="server" visible="false">
                    <th>
                        <asp:Label ID="AddTrackingNumberLabel" runat="server" Text="Tracking Number: " ></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:DropDownList ID="ShipGateway" runat="server" DataTextField="Name" DataValueField="ShipGatewayId" AppendDataBoundItems="true">
                            <asp:ListItem Value="" Text=""></asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="TrackingNumber"  Width="300px" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td colspan="3">
                        <asp:Button ID="SaveButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveButton_Click" />
                        <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="Default.aspx" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <asp:ObjectDataSource ID="TrackingNumberDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadForOrderShipment" 
        TypeName="CommerceBuilder.Orders.TrackingNumberDataSource" SortParameterName="sortExpression" EnablePaging="true" 
        SelectCountMethod="CountForOrderShipment">
        <SelectParameters>
        <asp:QueryStringParameter Name="orderShipmentId" QueryStringField="OrderShipmentId" DefaultValue="0" />
        </SelectParameters>
    </asp:ObjectDataSource>

<script type="text/javascript">
    function Check(textBox, maxLength) {
        if (textBox.value.length > maxLength) {
            alert("Please enter a maximum of " + maxLength + " characters.");
            textBox.value = textBox.value.substr(0, maxLength);
        }
    }
</script>
</asp:Content>
