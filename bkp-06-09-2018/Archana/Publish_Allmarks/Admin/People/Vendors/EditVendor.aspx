<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Vendors.EditVendor" Title="Edit Vendor"  CodeFile="EditVendor.aspx.cs" %>
<%@ Register src="../../UserControls/FindAssignProducts.ascx" tagname="FindAssignProducts" tagprefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="{0} : Assigned Products"></asp:Localize></h1>
        </div>
    </div>
    <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_Vendors" AssignmentStatus="AssignedProducts" />
</asp:Content>