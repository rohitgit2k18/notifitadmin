<%@ Page Language="C#" MasterPageFile="Product.master" Inherits="AbleCommerce.Admin.Products.EditProductCategories" Title="Edit Product Categories"  CodeFile="EditProductCategories.aspx.cs" %>
<%@ Register src="~/Admin/ConLib/CategoryTree.ascx" tagname="CategoryTree" tagprefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="pageHeader">
                <div class="caption">
                    <h1><asp:Localize ID="Caption" runat="server" Text="Categories for {0}"></asp:Localize></h1>
                </div>
            </div>
            <div class="content">
                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="this.value = 'Saving...'; this.enabled= false;" />
                <p><asp:Localize ID="InstructionText" runat="server" Text="Place a check next to the categories that this product belongs to."></asp:Localize></p>
                <cb:Notification ID="SuccessMessage" runat="server" Text="" SkinID="GoodCondition" Visible="false"></cb:Notification>
                <cb:Notification ID="FailureMessage" runat="server" Text="" SkinID="ErrorCondition" Visible="false"></cb:Notification>
                <uc:CategoryTree ID="CategoryTree" runat="server"></uc:CategoryTree>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>