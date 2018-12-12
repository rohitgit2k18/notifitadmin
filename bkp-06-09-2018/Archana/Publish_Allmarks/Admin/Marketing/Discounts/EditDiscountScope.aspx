<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true"
    Inherits="AbleCommerce.Admin.Marketing.Discounts.EditDiscountScope" Title="Discount Scope"
    CodeFile="EditDiscountScope.aspx.cs" %>

<%@ Register Src="~/Admin/ConLib/CategoryTree.ascx" TagName="CategoryTree" TagPrefix="uc" %>
<%@ Register src="../../UserControls/FindAssignProducts.ascx" tagname="FindAssignProducts" tagprefix="uc1" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="pageHeader">
        <div class="caption">
            <h1>
                <asp:Localize ID="Caption" runat="server" Text="Manage Scope for '{0}'"></asp:Localize></h1>
        </div>
    </div>
    <div class="content">
        <asp:Label ID="InstructionText" runat="server" Text="This discount will be applied to all of the assigned categories and/or products.  Use the tree on the left to navigate your categories and check the ones to be assigned to this discount.  You can also use the search form below to locate the specific products to be assigned.  Click close button when you are done managing the categories and products for this discount."></asp:Label>
    </div>
    <asp:UpdatePanel ID="MainContentAjax" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="section">
                <div class="header">
                    <h2>
                        Assigned Categories</h2>
                </div>
                <div class="content">
                    <cb:Notification ID="CategoriesSavedMessage" runat="server" Text="Categories restrictions updated at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
                    <uc:CategoryTree ID="CategoryTree" runat="server"></uc:CategoryTree>
                    <p><asp:Button ID="SaveCategoriesButton" runat="server" Text="Save" OnClick="SaveCategoriesButton_Click" />
                    <asp:Button ID="SaveAndCloseButton" runat="server" Text="Close" CssClass="button" OnClick="SaveAndCloseButton_Click" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="section">
        <div class="header">
            <h2>
                Find And Assign Products</h2>
        </div>
    </div>
    <uc1:FindAssignProducts ID="FindAssignProducts1" runat="server" AssignmentTable="ac_productvolumediscounts" AssignmentStatus="AssignedProducts" />
</asp:Content>
