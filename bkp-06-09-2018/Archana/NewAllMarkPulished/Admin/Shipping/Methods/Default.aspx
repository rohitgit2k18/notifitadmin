<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Shipping.Methods._Default" Title="Shipping Methods" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel runat="server" ID="ShipMethodPanel" UpdateMode="Conditional">
        <ContentTemplate>
			<div class="pageHeader">
				<div class="caption">
					<h1><asp:Localize ID="Caption" runat="server" Text="Shipping Methods" EnableViewState="false"></asp:Localize></h1>
					<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/shipping" />
				</div>
			</div>
            <div class="content">
                <cb:SortedGridView ID="ShipMethodGrid" runat="server" AllowPaging="False" AllowSorting="False" DefaultSortExpression="OrderBy"
                    AutoGenerateColumns="False" DataKeyNames="ShipMethodId" DataSourceID="ShipMethodDs" 
                    ShowFooter="False" SkinID="PagedList" Width="100%" EnableViewState="false" OnRowCommand="ShipMethodGrid_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Select">
        					<ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="DeleteCheckbox" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sort">
                            <HeaderStyle HorizontalAlign="center" Width="54px" />
                            <ItemStyle Width="78px" HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:LinkButton ID="MU" runat="server" CommandName="Do_Up" ToolTip="Move Up" CommandArgument='<%#Eval("ShipMethodId")%>'><img src="<%# GetIconUrl("arrow_up.gif") %>" border="0" alt="Move Up" /></asp:LinkButton>
                                <asp:LinkButton ID="MD" runat="server" CommandName="Do_Down" ToolTip="Move Down"  CommandArgument='<%#Eval("ShipMethodId")%>'><img src="<%# GetIconUrl("arrow_down.gif") %>" border="0" alt="Move Down" /></asp:LinkButton>                                        
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%# Eval("Name") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#AbleCommerce.Code.StoreDataHelper.GetFriendlyShipMethodType((ShipMethod)Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Warehouses">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#GetWarehouseNames(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Zones">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#GetZoneNames(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Groups">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <%#GetNames(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Min">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#GetMinPurchase(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Max">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#GetMaxPurchase(Container.DataItem)%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False">
                            <ItemStyle Wrap="false" HorizontalAlign="center" />
                            <ItemTemplate>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#GetEditUrl(Container.DataItem)%>' EnableViewState="false"><asp:Image ID="EditIcon" SkinID="Editicon" runat="server" EnableViewState="false" /></asp:HyperLink>
                                <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# GetConfirmDelete(Eval("Name")) %>' EnableViewState="false"><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" EnableViewState="false" /></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No shipping methods are defined for your store.
                    </EmptyDataTemplate>
                </cb:SortedGridView>
                <asp:Button ID="MultipleRowDelete" runat="server" Text="Remove Selected" OnClick="MultipleRowDelete_Click" OnClientClick="return confirm('Are you sure you want to delete the selected ship methods?')" />                        
            </div>
            <div class="grid_4 alpha">
                <div class="leftColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="AddCustomMethodCaption" runat="server" Text="Add Custom Method" EnableViewState="false"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="CustomMethod" EnableViewState="false" />
                            <table cellpadding="3" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:Label ID="AddShipMethodTypeLabel" runat="server" Text="Type: " SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                    </td>
                                    <td colspan="2">
                                        <asp:DropDownList ID="AddShipMethodType" runat="server" EnableViewState="false">
                                            <asp:ListItem Value="0">Fixed Rate</asp:ListItem>
                                            <asp:ListItem Value="1">Vary by Weight</asp:ListItem>
                                            <asp:ListItem Value="2">Vary by Cost</asp:ListItem>
                                            <asp:ListItem Value="3">Vary by Quantity</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="AddShipMethodNameLabel" runat="server" Text="Name: " SkinID="FieldHeader" EnableViewState="false"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="AddShipMethodName" runat="server" ValidationGroup="CustomMethod" EnableViewState="false" MaxLength="255"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="AddShipMethodNameValidator" runat="server" ErrorMessage="Maximum length for ShipMethod Name is 255 characters." Text="*" ControlToValidate="AddShipMethodName" ValidationExpression=".{0,255}" ValidationGroup="CustomMethod" ></asp:RegularExpressionValidator>
                                        <asp:RequiredFieldValidator ID="AddShipMethodNameRequired" runat="server" ControlToValidate="AddShipMethodName"
                                            Display="Static" ErrorMessage="Ship method name is required." ValidationGroup="CustomMethod">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <asp:Button ID="AddShipMethodButton" runat="server" Text="Add" SkinID="AddButton" OnClick="AddShipMethodButton_Click" ValidationGroup="CustomMethod"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_8 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2 class="commonicon"><asp:Localize ID="AddRealTimeMethodCaption" runat="server" Text="Add Integrated Carrier Method" EnableViewState="false"></asp:Localize></h2>
                        </div>
                        <div class="content">
                            <asp:Label ID="NoShipProviderMessage" runat="server" Text="You have not yet configured any of the integrated shipping providers.  Shipping providers allow you to have real-time shipping esitmates applied to your orders and can give customers access to tracking details from your store. To get started, visit the <a href='../Providers/Default.aspx'>Integrated Carriers</a> menu."></asp:Label>
                            <asp:UpdatePanel ID="IntegratedProviderAjax" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Panel ID="IntegratedProviderPanel" runat="server">
                                        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="ProviderMethod" />
                                        <table class="inputForm">
                                            <tr>
                                                <th>
                                                    <asp:Label ID="ProviderLabel" runat="server" Text="Provider:" AssociatedControlID="Provider"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="Provider" runat="server" DataTextField="Name" DataValueField="ShipGatewayId" AutoPostBack="true" OnSelectedIndexChanged="Provider_SelectedIndexChanged" AppendDataBoundItems="true">
                                                        <asp:ListItem Value="" Text=""></asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="ProviderRequiredValidator" runat="server" ControlToValidate="Provider"
                                                    Display="Static" ErrorMessage="Provider is required." ValidationGroup="ProviderMethod">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>
                                                    <asp:Label ID="ServiceCodeLabel" runat="server" Text="Service:" AssociatedControlID="ServiceCode"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ServiceCode" runat="server" DataTextField="Name" DataValueField="ShipGatewayId" />
                                                    <asp:RequiredFieldValidator ID="ServiceCodeValidator" runat="server" ControlToValidate="ServiceCode"
                                                    Display="Static" ErrorMessage="Service is required." ValidationGroup="ProviderMethod">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>
                                                    <asp:Button ID="AddProviderMethod" runat="server" Text="Add" SkinID="AddButton" OnClick="AddProviderMethod_Click" ValidationGroup="ProviderMethod" />
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="ShipMethodDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Shipping.ShipMethodDataSource" 
        SelectCountMethod="CountForStore" SortParameterName="sortExpression" 
        DataObjectTypeName="CommerceBuilder.Shipping.ShipMethod" DeleteMethod="Delete" 
        InsertMethod="Insert" UpdateMethod="Update" EnableViewState="false">
    </asp:ObjectDataSource>
</asp:Content>