<%@ Page Title="Return Items" Language="C#" MasterPageFile="~/Admin/Orders/Order.master" AutoEventWireup="true" CodeFile="ReturnItems.aspx.cs" Inherits="AbleCommerce.Admin.Orders.Edit.ReturnItems" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Order #{0}: Return Items" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <asp:UpdatePanel ID="OrderItemsAjax" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <cb:Notification ID="ReturnedMessage" runat="server" Text="Your return request was successfully processed." Visible="false" SkinID="GoodCondition" EnableViewState="false"></cb:Notification>
                <asp:PlaceHolder ID="ReturnPanel" runat="server">
                    <p><asp:Localize ID="InstructionText" runat="server" Text="Indicate the quantity of each item to be returned.  You may also elect to add a note to the order."></asp:Localize></p>
                    <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                    <table cellspacing="0" class="inputForm">
                        <tr>
                            <th valign="top">
                                <cb:ToolTipLabel ID="ItemsToReturnLabel" runat="server" Text="Items to Return:" ToolTip="Indicate the quantity of each item to be returned." />
                            </th>
                            <td>
                                <asp:GridView ID="ReturnableItems" runat="server" ShowHeader="true" AutoGenerateColumns="false" 
                                    Width="100%" SkinID="PagedList" DataKeyNames="OrderItemId">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Return">
                                            <HeaderStyle CssClass="quantity" />
                                            <ItemStyle CssClass="quantity" />
                                            <ItemTemplate>
                                                <asp:TextBox ID="ReturnQuantity" runat="server" width="50px" MaxLength="3"></asp:TextBox>
                                                <asp:RangeValidator ID="ReturnQuantityRangeValidator" runat="server" ControlToValidate="ReturnQuantity"
                                                    ErrorMessage="Quantity to return is invalid." Type="Integer" MinimumValue="1" MaximumValue='<%#Eval("Quantity")%>'>*</asp:RangeValidator>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Quantity">
                                            <HeaderStyle CssClass="quantity" />
                                            <ItemStyle CssClass="quantity" />
                                            <ItemTemplate>
                                                <%#Eval("Quantity")%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Item">
                                            <HeaderStyle CssClass="item" />
                                            <ItemTemplate>
                                                <%#Eval("Name")%>
                                                <asp:Literal ID="VariantName" runat="Server" Text='<%#Eval("VariantName", " ({0})")%>' Visible='<%#!String.IsNullOrEmpty((string)Eval("VariantName"))%>'></asp:Literal><br />
                                                <asp:Panel ID="InputPanel" runat="server" Visible='<%#(((ICollection)Eval("Inputs")).Count > 0)%>'>
                                                    <asp:DataList ID="InputList" runat="server" DataSource='<%#Eval("Inputs") %>'>
                                                        <ItemTemplate>
                                                            <asp:Label ID="InputName" Runat="server" Text='<%#Eval("Name") + ":"%>' SkinID="fieldheader"></asp:Label>
                                                            <asp:Label ID="InputValue" Runat="server" Text='<%#Eval("InputValue")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:DataList>
                                                </asp:Panel>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Sku">
                                            <HeaderStyle CssClass="sku" />
                                            <ItemStyle CssClass="sku" />
                                            <ItemTemplate>
                                                <%#Eval("Sku")%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Net Price">
                                            <HeaderStyle CssClass="price" />
                                            <ItemStyle CssClass="price" />
                                            <ItemTemplate>
                                                <%# Eval("NetPrice", "{0:F2}") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr id="trInventory" runat="server">
                            <th>
                                <cb:ToolTiplabel ID="ReturnToInventoryLabel" runat="server" Text="Return to Inventory:" AssociatedControlID="ReturnToInventory" ToolTip="Indicate whether the items indicated should be returned to inventory (if applicable)." />
                            </th>
                            <td>
                                <asp:CheckBox ID="ReturnToInventory" runat="server" Checked="true" />
                            </td>
                        </tr>
                        <tr>
                            <th valign="top">
                               <cb:ToolTipLabel ID="OrderNoteLabel" runat="server" Text="Add Note To Order:" AssociatedControlID="OrderNote" ToolTip="Add a note to the order about the return." />
                            </th>
                            <td>
                                <asp:TextBox ID="OrderNote" runat="server" TextMode="MultiLine" Columns="60" Rows="5">
                                </asp:TextBox><br />
                                <asp:CheckBox ID="OrderNoteIsPrivate" runat="server" Text="Make comment private." Checked="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Button ID="ReturnButton" runat="server" Text="Return" OnClick="ReturnButton_Click" />
                                <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="EditOrderItems.aspx?OrderNumber=" SkinID="CancelButton" EnableViewState="false" />
                            </td>
                        </tr>
                    </table>
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="NoReturnsPanel" runat="server" Visible="false">
                    <p>There are no items in the order eligible for return.</p>
                </asp:PlaceHolder>
            </ContentTemplate>
        </asp:UpdatePanel>    
    </div>
</asp:Content>
