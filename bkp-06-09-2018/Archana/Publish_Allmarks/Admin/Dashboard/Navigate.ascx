<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Navigate.ascx.cs" Inherits="AbleCommerce.Admin.Dashboard.Navigate" %>
<%@ Register src="NavagationSection.ascx" tagname="NavagationSection" tagprefix="uc1" %>
<div class="navigationOptions">
    <div class="helpLink"><a href="http://help.ablecommerce.com/acgold/guide/">Launch Online Merchant Guide</a></div>
    <div class="instructions">Hover any menu item to view a description of the feature.</div>
</div>
 <div class="grid_6 alpha">
    <div class="leftColumn">
        <uc1:NavagationSection ID="Manage" runat="server" Path="manage" CssClass="manage" />
        <uc1:NavagationSection ID="People" runat="server" Path="people" CssClass="people" />
        <uc1:NavagationSection ID="Marketing" runat="server" Path="marketing" CssClass="marketing" />
    </div>
</div>
<div class="grid_6 omega">
    <div class="rightColumn">
        <uc1:NavagationSection ID="Catalog" runat="server" Path="catalog" CssClass="catalog" />
        <uc1:NavagationSection ID="Website" runat="server" Path="website" CssClass="website" />
        <uc1:NavagationSection ID="Help" runat="server" Path="help" CssClass="help" />
    </div>
</div>
    
