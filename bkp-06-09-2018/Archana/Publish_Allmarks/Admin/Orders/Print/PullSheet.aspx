<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.Print.PullSheet" Title="Order Pull Sheet" CodeFile="PullSheet.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader noPrint">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Order Pull Sheet"></asp:Localize></h1>
        </div>
    </div>
    <div class="content noPrint">
        <p><asp:Localize ID="PrintInstructions" runat="server" Text="This document includes a printable stylesheet. Your browser will print with appropriate styles and page breaks if needed. Website headers, footers, and this message will not be printed."></asp:Localize></p>
        <asp:Button ID="Print" runat="server" Text="Print" OnClick="Print_Click" />
        <asp:HyperLink ID="Back" runat="server" CssClass="button" Text="Back" NavigateUrl="~/Admin/Orders/Default.aspx" />
    </div>
    <div class="content">
        <p><asp:Label ID="OrderListLabel" runat="server" Text="Includes Order Numbers:" SkinID="FieldHeader"></asp:Label><asp:Label ID="OrderList" runat="server" Text=""></asp:Label></p>
        <asp:GridView ID="ItemGrid" runat="server" AutoGenerateColumns="false" CssClass="dataSheet"
            CellPadding="6" CellSpacing="0" GridLines="Both" Width="100%">
            <Columns>
                <asp:BoundField DataField="Quantity" HeaderText="Qty" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="Sku" HeaderText="Sku" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                <asp:TemplateField HeaderText="Name" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Left">
                    <ItemTemplate>
                        <%#Eval("Name")%><asp:Label ID="VariantName" runat="server" Text='<%#Eval("VariantName", " ({0})")%>' Visible='<%#(Eval("VariantName").ToString().Length > 0)%>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Pulled" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        [&nbsp;&nbsp;&nbsp;]
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>