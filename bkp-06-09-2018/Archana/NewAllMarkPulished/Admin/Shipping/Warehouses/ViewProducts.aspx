<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Shipping.Warehouses.ViewProducts" Title="Warehouse Products"  Debug="true" CodeFile="ViewProducts.aspx.cs" %>
<%@ Register src="../../UserControls/FindAssignProducts.ascx" tagname="FindAssignProducts" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Products in {0}" EnableViewState="False"></asp:Localize></h1>
    	</div>
    </div>
    <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_Warehouses" AssignmentStatus="AssignedProducts" />
    <asp:UpdatePanel ID="AssignAjax" runat="server">
        <ContentTemplate>
        <div class="searchPanel">
            <p><asp:Label ID="InstructionText" runat="server" Text="Any products in this warehouse are displayed in the grid above.  You may move selected products to another warehouse." EnableViewState="false"></asp:Label></p>
            <table class="inputForm">
                <tr>
                    <th>
                        <asp:Label ID="NewWarehouseLabel" runat="server" Text="Move selected to:" AssociatedControlID="NewWarehouse"></asp:Label>
                    </th>
                    <td>
                        <asp:DropDownList ID="NewWarehouse" runat="server" AppendDataBoundItems="true" DataTextField="Name" DataValueField="WarehouseId">
                            <asp:ListItem Value="" Text=""></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:Button ID="NewWarehouseUpdateButton" runat="server" Text="Update" OnClick="NewWarehouseUpdateButton_Click" />
                        <asp:Button ID="BackButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="BackButton_Click" />
                    </td>
                </tr>
            </table>
        </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>