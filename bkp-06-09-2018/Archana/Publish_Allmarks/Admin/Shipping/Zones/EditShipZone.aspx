<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Shipping.Zones.EditShipZone" Title="Edit Zone" CodeFile="EditShipZone.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Edit Zone '{0}'" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <asp:UpdatePanel ID="ShipZoneAjax" runat="server">
        <ContentTemplate>
            <div class="content">
            <cb:Notification ID="SavedMessage" runat="server" Text="Ship Zone saved at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <table class="inputForm" cellspacing="0">
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="Name of the zone for merchant reference.  This value is not displayed to customers."></cb:ToolTipLabel>
                        </th>
                        <td valign="top">
                            <asp:TextBox ID="Name" runat="server" Width="200px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="NameRequired" runat="server" ControlToValidate="Name"
                                Display="Static" ErrorMessage="Zone name is required.">*</asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="CountryRuleLabel" runat="server" Text="Country Filter:" ToolTip="Indicate how countries are filtered for this zone." AssociatedControlId="CountryRule"></cb:ToolTipLabel>
                        </th>
                        <td valign="top">
                            <asp:DropDownList ID="CountryRule" runat="server" AutoPostBack="True" OnSelectedIndexChanged="CountryRule_SelectedIndexChanged">
                                <asp:ListItem Text="Include All Countries" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Include Selected Countries" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Exclude Selected Countries" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trCountryList" runat="server">
                        <th valign="top">
                            <cb:ToolTipLabel ID="CountryListLabel" runat="server" Text="Selected&nbsp;Countries:" ToolTip="The list of countries to use in conjunction with the country filter." AssociatedControlId="CountryList" />
                        </th>
                        <td valign="top">
                            <asp:Literal ID="CountryList" runat="server"></asp:Literal>
                            <asp:HiddenField ID="HiddenSelectedCountries" runat="server" />
                            <asp:LinkButton ID="ChangeCountryListButton" runat="server" Text="Change Countries"></asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ProvinceRuleLabel" runat="server" Text="State Filter:" ToolTip="Indicate how states are filtered for this zone." AssociatedControlId="ProvinceRule"></cb:ToolTipLabel>
                        </th>
                        <td valign="top">
                            <asp:DropDownList ID="ProvinceRule" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ProvinceRule_SelectedIndexChanged">
                                <asp:ListItem Text="Include All States" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Include Selected States" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Exclude Selected States" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="trProvinceList" runat="server">
                        <th valign="top">
                            <cb:ToolTipLabel ID="ProvinceListLabel" runat="server" Text="Selected&nbsp;States:" ToolTip="The list of provinces to use in conjunction with the province filter." AssociatedControlId="ProvinceList" />
                        </th>
                        <td valign="top">
                            <asp:Literal ID="ProvinceList" runat="server"></asp:Literal>
                            <asp:HiddenField ID="HiddenSelectedProvinces" runat="server" />
                            <asp:LinkButton ID="ChangeProvinceListButton" runat="server" Text="Change States"></asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="PostalCodeFilterLabel" runat="server" Text="Postal Code(s):" ToolTip='Any ZIP or postal code matching this filer will be included in the zone.  You may enter multiple codes separated by a comma.  You may also use regular expressoins - see help for details.'></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="PostalCodeFilter" runat="server" Text="" Width="700px" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <cb:ToolTipLabel ID="ExcludePostalCodeFilterLabel" runat="server" Text="Exclude&nbsp;Postal&nbsp;Code(s):" ToolTip='ZIP or postal code matching this filter will be excluded from the zone.  You may enter multiple codes separated by a comma.  You may also use regular expressions - see help for details.'></cb:ToolTipLabel>
                        </th>
                        <td>
                            <asp:TextBox ID="ExcludePostalCodeFilter" runat="server" Text="" Width="700px" MaxLength="255"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Label ID="WikiTopicLabel" runat="server" Text="You can learn more about how to configure postal code filters"></asp:Label>
                            <asp:HyperLink ID="WikiTopicLink" runat="server" Text="here" NavigateUrl="http://wiki.ablecommerce.com/index.php/Postal_Code_Filter_Pattern_Matching" Target="_blank"></asp:HyperLink>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" />
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
				            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <asp:Panel ID="ChangeCountryListDialog" runat="server" Style="display: none" CssClass="modalPopup" Width="600px">
                <asp:Panel ID="ChangeCountryListDialogHeader" runat="server" CssClass="modalPopupHeader">
                    Change Selected Countries
                </asp:Panel>
                <div align="center">
                    <br />
                    Hold CTRL to select multiple countries.  Double click to move a country to the other list.
                    <br /><br />
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="center" valign="top" width="42%">
                                <b>Available Countries</b><br />
                                <asp:ListBox ID="AvailableCountries" runat="server" Rows="12" SelectionMode="multiple" Width="220"></asp:ListBox>
                            </td>
                            <td align="center" valign="middle" align="center" width="6%">
                                <asp:Button ID="SelectAllCountries" runat="server" Text=" >> " /><br />
                                <asp:Button ID="SelectCountry" runat="server" Text=" > " /><br />
                                <asp:Button ID="UnselectCountry" runat="server" Text=" < " /><br />
                                <asp:Button ID="UnselectAllCountries" runat="server" Text=" << " /><br />
                            </td>
                            <td align="center" valign="top" width="42%">
                                <b>Selected Countries</b><br />
                                <asp:ListBox ID="SelectedCountries" runat="server" Rows="12" SelectionMode="multiple" Width="220"></asp:ListBox>
                            </td>
                        </tr>
                    </table><br />
                    <asp:Button ID="ChangeCountryListOKButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="ChangeCountryListOKButton_Click" />
                    <asp:Button ID="ChangeCountryListCancelButton" runat="server" SkinID="CancelButton" Text="Cancel" />
                    <br /><br />
                </div>
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender" runat="server" 
                TargetControlID="ChangeCountryListButton"
                PopupControlID="ChangeCountryListDialog" 
                BackgroundCssClass="modalBackground" 
                CancelControlID="ChangeCountryListCancelButton" 
                DropShadow="true"
                PopupDragHandleControlID="ChangeCountryListDialogHeader" />
            <asp:Panel ID="ChangeProvinceListDialog" runat="server" Style="display: none" CssClass="modalPopup" Width="600px">
                <asp:Panel ID="ChangeProvinceListDialogHeader" runat="server" CssClass="modalPopupHeader">
                    Change Selected States
                </asp:Panel>
                <div align="center">
                    <br />
                    Hold CTRL to select multiple states.  Double click to move a state to the other list.
                    <br /><br />
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="center" valign="top" width="42%">
                                <b>Available States</b><br />
                                <asp:ListBox ID="AvailableProvinces" runat="server" Rows="12" SelectionMode="multiple" Width="220"></asp:ListBox>
                            </td>
                            <td align="center" valign="middle" width="6%">
                                <asp:Button ID="SelectAllProvinces" runat="server" Text=" >> " /><br />
                                <asp:Button ID="SelectProvince" runat="server" Text=" > " /><br />
                                <asp:Button ID="UnselectProvince" runat="server" Text=" < " /><br />
                                <asp:Button ID="UnselectAllProvinces" runat="server" Text=" << " /><br />
                            </td>
                            <td align="center" valign="top" width="42%">
                                <b>Selected States</b><br />
                                <asp:ListBox ID="SelectedProvinces" runat="server" Rows="12" SelectionMode="multiple" Width="220"></asp:ListBox>
                            </td>
                        </tr>
                    </table><br />
                    <asp:Button ID="ChangeProvinceListOKButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="ChangeProvinceListOKButton_Click" />  
                    <asp:Button ID="ChangeProvinceListCancelButton" runat="server" SkinID="CancelButton" Text="Cancel" />
                    <br /><br />
                </div>
            </asp:Panel>
            <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" 
                TargetControlID="ChangeProvinceListButton"
                PopupControlID="ChangeProvinceListDialog" 
                BackgroundCssClass="modalBackground" 
                CancelControlID="ChangeProvinceListCancelButton" 
                DropShadow="true"
                PopupDragHandleControlID="ChangeProvinceListDialogHeader" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>