<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Taxes.Settings" Title="Tax Settings" CodeFile="Settings.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="SettingsCaption" runat="server" Text="Tax Settings"></asp:Localize></h1>
            <uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/taxes" />
        </div>
    </div>
    <asp:UpdatePanel ID="TaxAjax" runat="server">
        <ContentTemplate>
            <cb:Notification ID="SavedMessage" runat="server" Text="The configuration has been saved at {0}." SkinID="GoodCondition" Visible="False" EnableViewState="false"></cb:Notification>
            <div class="grid_6 alpha">
                <div class="mainColumn">    
                    <div class="content">
                        <asp:PlaceHolder ID="TaxesDisabledPanel" runat="server" EnableViewState="false" Visible="false">
                            <p>
                            <asp:Localize ID="TaxesDisabledMessage" runat="server" EnableViewState="false">
                                WARNING: Taxes are currently disabled and configured tax rules will have no effect.
                            </asp:Localize>
                            </p>
                        </asp:PlaceHolder>
                        <table cellspacing="0" class="inputForm" border="0">
                            <tr>
                                <th valign="top" width="150px">
                                    <cb:ToolTipLabel ID="EnabledLabel" runat="Server" Text="Enable Taxes:" AssociatedControlID="EnabledCheckBox" ToolTip="Indicates whether tax processing is enabled for the entire store.  However, taxes cannot be calculated until the taxable items are assigned a tax code and tax rules are created." />
                                </th>
                                <td valign="top">
                                    <asp:CheckBox ID="EnabledCheckBox" runat="server" AutoPostBack="true" OnCheckedChanged="Enabled_OnCheckedChanged" />
                                </td>
                            </tr>
                            <tr id="trShowShopPriceWithTax" runat="server">
                                <th valign="top">
                                    <cb:ToolTipLabel ID="ShoppingDisplayLabel" runat="Server" Text="Shopping Display:" AssociatedControlID="ShoppingDisplay"
                                        ToolTip="On the general shopping and basket pages, you may show item prices with tax included, or itemized in the basket.  The default, and most common option is 'None', unless you are required to display taxes to the user while they are shopping." />
                                </th>
                                <td valign="top">
                                    <asp:Localize ID="ShoppingDisplayHelpText" runat="server">
                                    </asp:Localize>
                                    <asp:DropDownList ID="ShoppingDisplay" runat="server" AutoPostBack="true">
                                        <asp:ListItem Text="None" Value="Hide" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Show Tax Separately" Value="LineItem"></asp:ListItem>
                                        <asp:ListItem Text="Include Tax in Price" Value="Included"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trInvoiceDisplay" runat="server">
                                <th valign="top">
                                    <cb:ToolTipLabel ID="InvoiceDisplayLabel" runat="Server" Text="Invoice Display:" AssociatedControlID="InvoiceDisplay" 
                                        ToolTip="This setting determines how the taxes are shown on the invoice pages and during final checkout." />
                                </th>
                                <td valign="top">
                                    <asp:Localize ID="InvoiceDisplayHelpText" runat="server">                            
                                    </asp:Localize>
                                    <asp:DropDownList ID="InvoiceDisplay" runat="server">
                                        <asp:ListItem Text="Summary" Value="Summary" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Show Tax Separately" Value="LineItem"></asp:ListItem>
                                        <asp:ListItem Text="Include Tax in Price" Value="Included"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="trShowTaxColumn" runat="server">
                                <th valign="top">
                                    <cb:ToolTipLabel ID="ShowTaxColumnLabel" runat="Server" Text="Tax Column:" AssociatedControlID="ShowTaxColumn"
                                        ToolTip="When checked, a new column will appear in the shopping basket and/or checkout and invoice pages.  The information shown here will be the tax rate for each item." />
                                </th>
                                <td valign="top">
                                    <asp:CheckBox ID="ShowTaxColumn" runat="server" Text="Show Tax Column"/><br />
                                </td>
                            </tr>
                            <tr id="trTaxColumnHeader" runat="server">
                                <th valign="top">
                                    <cb:ToolTipLabel ID="TaxColumnHeaderLabel" runat="Server" Text="Tax Column Header:" AssociatedControlID="TaxColumnHeader"
                                        ToolTip="Set the header text for the tax column." />
                                </th>
                                <td valign="top">
                                    <asp:TextBox ID="TaxColumnHeader" runat="server" MaxLength="15" Width="80px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;
                                </td>
                                <td>
                                    <asp:Button ID="SaveButton" runat="server" Text="Save" ClassID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="grid_6 omega">
                <div class="rightColumn">
                    <asp:Panel ID="IncludeAnonPanel" runat="server" CssClass="section" Visible="false">
                        <div class="header">
                            <h2>Anonymous Customers</h2>
                        </div>
                        <div class="content">
                            <p>
                                <asp:Localize ID="InstructionLabel" runat="server" Text="Anonymous Users browsing your store have not given address details necessary for tax calculations. Check below to calculate taxes for anonymous users based on the store address."></asp:Localize>
                            </p>
                            <asp:CheckBox ID="IncludeAnon" runat="server" Text="Calculate Tax for Anonymous Users" Checked="false" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>