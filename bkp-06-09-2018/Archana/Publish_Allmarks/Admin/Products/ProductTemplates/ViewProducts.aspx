<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Products.ProductTemplates.ViewProducts"
    Title="Assigned Products" CodeFile="ViewProducts.aspx.cs" %>

<%@ Register src="../../UserControls/FindAssignProducts.ascx" tagname="FindAssignProducts" tagprefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="{0}: Assigned Products"></asp:Localize></h1>
        </div>
    </div>
   <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_ProductProductTemplates" AssignmentStatus="AssignedProducts" />
</asp:Content>
