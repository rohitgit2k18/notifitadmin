<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Configure.ascx.cs" Inherits="AbleCommerce.Admin.Dashboard.Configure" %>
<%@ Register src="NavagationSection.ascx" tagname="NavagationSection" tagprefix="uc1" %>
<div class="navigationOptions">
    <div class="helpLink"><a href="http://help.ablecommerce.com/acgold/guide/" target="_blank">Launch Online Merchant Guide</a></div>
    <div class="instructions">Hover any menu item to view a description of the feature.</div>
</div>
 <div class="grid_6 alpha">
    <div class="leftColumn">
        <uc1:NavagationSection ID="Store" runat="server" Path="configure/store" CssClass="store" />
        <uc1:NavagationSection ID="Regions" runat="server" Path="configure/regions" CssClass="regions" />
        <uc1:NavagationSection ID="Shipping" runat="server" Path="configure/shipping" CssClass="shipping" />
        <uc1:NavagationSection ID="Payments" runat="server" Path="configure/payments" CssClass="payments" />
    </div>
</div>
<div class="grid_6 omega">
    <div class="rightColumn">
        <uc1:NavagationSection ID="Security" runat="server" Path="configure/security" CssClass="security" />
        <uc1:NavagationSection ID="Email" runat="server" Path="configure/email" CssClass="email" />
        <uc1:NavagationSection ID="Taxes" runat="server" Path="configure/taxes" CssClass="taxes" />
        <uc1:NavagationSection ID="SEO" runat="server" Path="configure/seo" CssClass="seo" />
    </div>
</div>
    
