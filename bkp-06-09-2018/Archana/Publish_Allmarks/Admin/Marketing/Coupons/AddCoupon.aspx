<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Coupons.AddCoupon" Title="Add Coupon : Select Coupon Type" CodeFile="AddCoupon.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Add Coupon (Select Coupon Type)"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <p><asp:Localize ID="InstructionText" runat="server" Text="Select the type of the coupon to add:"></asp:Localize></p>
        <p>
            <asp:RadioButton ID="OrderCoupon" runat="server" GroupName="CouponType" Checked="true" />
            <asp:Label ID="OrderCouponLabel" runat="server" Text="Order Coupon" SkinID="FieldHeader"></asp:Label><br />
            <asp:Label ID="OrderCouponHelpText" runat="server" Text="Provide a discount on the entire order.  For example, 10% off the entire order." SkinID="HelpText"></asp:Label>
        </p>
        <p>
            <asp:RadioButton ID="ProductCoupon" runat="server" GroupName="CouponType" />
            <asp:Label ID="ProductCouponLabel" runat="server" Text="Product Coupon" SkinID="FieldHeader"></asp:Label><br />
            <asp:Label ID="ProductCouponHelpText" runat="server" Text="Provide a discount for a specific line item.  For example, buy one get one free." SkinID="HelpText"></asp:Label>
        </p>
        <p>
            <asp:RadioButton ID="ShippingCoupon" runat="server" GroupName="CouponType" />
            <asp:Label ID="ShippingCouponLabel" runat="server" Text="Shipping Coupon" SkinID="FieldHeader"></asp:Label><br />
            <asp:Label ID="ShippingCouponHelpText" runat="server" Text="Provides a discount on shipping charges for an order.  For example, a free shipping coupon." SkinID="HelpText"></asp:Label>
        </p>
        <asp:Button ID="NextButton" runat="server" Text="Next" OnClick="NextButton_Click" />
        <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
    </div>
</asp:Content>