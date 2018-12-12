<%@ Page Language="C#" MasterPageFile="Order.master" Inherits="AbleCommerce.Admin.Orders.CancelOrder" Title="Cancel Order" CodeFile="CancelOrder.aspx.cs" %>
<asp:Content ID="PageHeader" ContentPlaceHolderID="PageHeader" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Cancel Order"></asp:Localize></h1>
        </div>
    </div>
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content">
        <asp:PlaceHolder ID="PHActiveGCs" runat="server" Visible="false">
            <asp:Label ID="ActiveGCsLabel"  runat="server" Text="This order has {0} active gift certificate(s), which will be deactivated."></asp:Label><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="PHActiveDGs" runat="server" Visible="false">
            <asp:Label ID="ActiveDGsLabel"  runat="server" Text="This order has {0} active digital good(s), which will be deactivated."></asp:Label><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="PHActiveSubscriptions" runat="server" Visible="false">
            <asp:Label ID="ActiveSubscriptionsLabel"  runat="server" Text="This order has {0} active subscription(s), which will be deactivated."></asp:Label><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="PendingPaymentsPH" runat="server" Visible="false">
            <asp:Label ID="PendingPaymentsLabel"  runat="server" Text="This order has {0} pending payment authorization(s)."></asp:Label><br />
            <asp:CheckBox ID="CancelPaymentsCheckBox" runat="server" Checked="true" Text="Cancel Pending Payments." /><br />
        </asp:PlaceHolder>
        <asp:Label ID="CommentLabel" runat="server" Text="Enter a comment or explanation for the order cancellation:"></asp:Label><br />
        <asp:TextBox ID="Comment" runat="server" TextMode="MultiLine" Rows="4" Columns="50"></asp:TextBox><br />
        <asp:CheckBox ID="IsPrivate" runat="server" Text="Make comment private." /><br />
        <asp:Button ID="CancelButton" runat="server" Text="Cancel Order" OnClick="CancelButton_Click" />
        <asp:HyperLink ID="BackButton" runat="server" Text="Back" SkinID="Button" />
    </div>
</asp:Content>