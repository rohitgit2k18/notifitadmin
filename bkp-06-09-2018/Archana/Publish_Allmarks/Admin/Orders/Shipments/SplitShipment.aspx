<%@ Page Language="C#" MasterPageFile="~/Admin/Orders/Order.master" Inherits="AbleCommerce.Admin.Orders.Shipments.SplitShipment" Title="Split Shipment" EnableViewState="false" CodeFile="SplitShipment.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" runat="server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Split Shipment for Order #{1}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server"> 
    <asp:UpdatePanel ID="MoveAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="content">
                <p><asp:Localize ID="InstructionText" runat="server" Text="To split a shipment, enter the quantity of item(s) to move, and then select a new or existing shipment."></asp:Localize></p>
                <asp:ValidationSummary ID="ValidationSummary" runat="server" />
                <asp:GridView ID="ShipmentItems" runat="server" ShowHeader="true"
                    AutoGenerateColumns="false" Width="100%" SkinID="PagedList">
                    <Columns>
                        <asp:TemplateField HeaderText="Item">
                            <HeaderStyle HorizontalAlign="Left" />
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
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#Eval("Sku")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%# ((decimal)Eval("Price")).LSCurrencyFormat("lc") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Quantity">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <%#Eval("Quantity")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Move">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:HiddenField ID="Id" runat="server" Value='<%#Eval("OrderItemId")%>' />
                                <asp:TextBox ID="MoveQty" runat="server" Text='<%#Eval("Quantity")%>' Width="30px"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Move To">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:DropDownList ID="Shipment" runat="server"></asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Button ID="UpdateButton" runat="server" Text="Move Items" SkinID="SaveButton" OnClick="UpdateButton_Click" />
                <asp:HyperLink ID="CancelLink" runat="server" Text="Cancel" NavigateUrl="Default.aspx" SkinID="CancelButton" />
                <asp:PlaceHolder ID="phQuantityValidation" runat="server"></asp:PlaceHolder>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>    
</asp:Content>