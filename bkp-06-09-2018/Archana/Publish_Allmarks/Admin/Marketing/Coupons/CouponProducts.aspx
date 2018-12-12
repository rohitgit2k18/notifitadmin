<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true"
    Inherits="AbleCommerce.Admin.Marketing.Coupons.CouponProducts" Title="Products Linked to Coupon"
    CodeFile="CouponProducts.aspx.cs" %>

<%@ Register Src="../../UserControls/FindAssignProducts.ascx" TagName="FindAssignProducts"
    TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="{0}: Linked Products"></asp:Localize></h1>
        </div>
    </div>
    <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_CouponProducts" AssignmentStatus="AssignedProducts" />
</asp:Content>
