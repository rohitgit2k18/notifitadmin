<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Taxes.TaxCodeProducts" Title="Tax Code Products"  CodeFile="TaxCodeProducts.aspx.cs" AutoEventWireup="True" %>
<%@ Register src="../UserControls/FindAssignProducts.ascx" tagname="FindAssignProducts" tagprefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Products assigned to '{0}'"></asp:Localize></h1>
    	</div>
    </div>
    <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_TaxCodes" AssignmentStatus="AssignedProducts" />
</asp:Content>