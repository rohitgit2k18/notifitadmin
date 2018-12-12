<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Orders.Print.ShippingLabels" Title="Shipping Labels" CodeFile="ShippingLabels.aspx.cs" %>
<%@ Register Src="OrderItemDetail.ascx" TagName="OrderItemDetail" TagPrefix="uc" %>
<%@ Register Src="~/Admin/UserControls/PrintableLogo.ascx" TagName="PrintableLogo" TagPrefix="uc" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader noPrint">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Shipping Labels"></asp:Localize></h1>
            <div class="links">
                <asp:Button ID="Print" runat="server" Text="Print" OnClick="Print_Click" />
                <asp:HyperLink ID="Back" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="~/Admin/Orders/Default.aspx" />
            </div>
        </div>
    </div>
    <div class="content noPrint">
        <p><asp:Label ID="OrderListLabel" runat="server" Text="Order Number(s): " SkinID="FieldHeader"></asp:Label><asp:Label ID="OrderList" runat="server" Text=""></asp:Label></p>
        <p><asp:Localize ID="PrintInstructions" runat="server" Text="This page contains a printable stylesheet. Your browser will print with appropriate styles and page breaks if needed. Website headers and footers (along with this message) will not be printed."></asp:Localize></p>
    </div>
    <div class="content">
        <asp:Repeater ID="ShipmentRepeater" runat="server" >
            <ItemTemplate>
                <div>
                    <div style="vertical-align:middle;overflow:auto;">
                        <asp:Repeater ID="LabelImageRepeater" runat="server" DataSource='<%#Eval("LabelImages")%>'>
                            <ItemTemplate>
                                <asp:Image ID="LabelImage" runat="server" ImageUrl='<%#string.Format("data:image/png;base64,{0}", Eval("LabelImageData"))%>' Height="392" Width="651" />
                            </ItemTemplate>
                            <SeparatorTemplate><br/> </SeparatorTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>