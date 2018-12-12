<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true"
    Inherits="AbleCommerce.Admin.Products.GiftWrap.ViewProducts" Title="Gift Wrap: View assigned products"
    CodeFile="ViewProducts.aspx.cs" %>

<%@ Register src="../../UserControls/FindAssignProducts.ascx" tagname="FindAssignProducts" tagprefix="uc1" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="{0}: Assigned Products"></asp:Localize></h1>
        </div>
    </div>
    <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_WrapGroups" AssignmentStatus="AssignedProducts" />
</asp:Content>
