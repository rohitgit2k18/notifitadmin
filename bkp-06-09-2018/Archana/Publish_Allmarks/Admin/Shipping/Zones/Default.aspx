<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Shipping.Zones._Default" Title="Zones" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel runat="server" ID="ShipZonePanel" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1><asp:Localize ID="Caption" runat="server" Text="Zones"></asp:Localize></h1>
                    	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/regions" />
            	</div>
            </div>
            <div class="grid_12 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <table class="inputForm">
                            <tr>
                                <th style="width:100px">
                                    <cb:ToolTipLabel ID="AddShipZoneNameLabel" runat="server" Text="Zone Name: " SkinId="FieldHeader" ToolTip="Name of the zone for merchant reference.  This value is not displayed to customers." />
                                </th>
                                <td>
                                    <asp:TextBox ID="AddShipZoneName" runat="server" Width="200" MaxLength="100"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="AddShipZoneNameRequired" runat="server" ControlToValidate="AddShipZoneName"
                                        Display="Dynamic" Text="*" ValidationGroup="Add"></asp:RequiredFieldValidator>
                                    <asp:Button ID="AddShipZoneButton" runat="server" Text="Add Zone" SkinID="AddButton" OnClick="AddShipZoneButton_Click" ValidationGroup="Add" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="content">
                        <cb:SortedGridView ID="ShipZoneGrid" runat="server" AllowPaging="False" AllowSorting="True"
                            AutoGenerateColumns="False" DataKeyNames="ShipZoneId" DataSourceID="ShipZoneDs" 
                            ShowFooter="False" Width="100%" SkinID="PagedList" DefaultSortExpression="Name" OnRowCommand="ShipZoneGrid_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                    <HeaderStyle HorizontalAlign="left" width="120px" />
                                    <ItemStyle VerticalAlign="top" width="120px" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="NameLink" runat="server" NavigateUrl='<%#Eval("ShipZoneId", "EditShipZone.aspx?ShipZoneId={0}")%>' Text='<%# Eval("Name") %>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Countries">
                                    <HeaderStyle HorizontalAlign="left" width="100px" />
                                    <ItemStyle VerticalAlign="top" width="100px" />
                                    <ItemTemplate>
                                        <asp:Label ID="CountriesLabel" runat="server" Text='<%#GetCountryNames(Container.DataItem)%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="States">
                                    <HeaderStyle HorizontalAlign="left" Width="200px" />
                                    <ItemStyle Width="200px" VerticalAlign="top" />
                                    <ItemTemplate>
                                        <asp:Label ID="ProvincesLabel" runat="server" Text='<%#GetProvinceNames(Container.DataItem)%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Postal Codes">
                                    <HeaderStyle HorizontalAlign="left" Width="100px" />
                                    <ItemStyle VerticalAlign="top" Width="100px" />
                                    <ItemTemplate>
                                        <asp:Label ID="PostalCodesLabel" runat="server" Text='<%#GetPostalCodes(Container.DataItem)%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tax Rules">
                                    <HeaderStyle HorizontalAlign="left" Width="60px" />
                                    <ItemStyle VerticalAlign="top"  HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="TaxRulesLink" runat="server" NavigateUrl="~/Admin/Taxes/TaxRules.aspx">
                                            <asp:Label ID="TaxRulesLabel" runat="server" Text='<%#GetTaxRules(Container.DataItem)%>'></asp:Label>
                                        </asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Shipping Methods">
                                    <HeaderStyle HorizontalAlign="left" Width="100px" />
                                    <ItemStyle VerticalAlign="top"  HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="ShipMethodsLink" runat="server" NavigateUrl="~/Admin/Shipping/Methods/Default.aspx">
                                            <asp:Label ID="ShipMethodsLabel" runat="server" Text='<%#GetShipMethods(Container.DataItem)%>'></asp:Label>
                                        </asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ShowHeader="False" >
                                    <ItemStyle Width="90px" VerticalAlign="top" />
                                    <ItemTemplate>
                                        <div align="center">
                                            <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#Eval("ShipZoneId", "EditShipZone.aspx?ShipZoneId={0}")%>'><asp:Image ID="EditIcon" SkinID="Editicon" runat="server" AlternateText="Edit" /></asp:HyperLink>
                                            <asp:ImageButton ID="CopyButton" runat="server" AlternateText="Copy" SkinID="CopyIcon" CommandName="Copy" ToolTip="Copy" CommandArgument='<%#Container.DataItemIndex%>' />
                                            <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                No shipping zones are defined for your store.
                            </EmptyDataTemplate>
                        </cb:SortedGridView>
                        <p><asp:Localize ID="InstructionText" runat="server" Text="Zones are custom defined regions that may include, or exclude, countries, states and postal codes."></asp:Localize></p>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="ShipZoneDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.ShipZoneDataSource" SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Shipping.ShipZone" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
    </asp:ObjectDataSource>
</asp:Content>