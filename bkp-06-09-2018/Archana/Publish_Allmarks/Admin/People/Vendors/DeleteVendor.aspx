<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.People.Vendors.DeleteVendor" Title="Delete Vendor"  CodeFile="DeleteVendor.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Delete {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="grid_6 alpha">
        <div class="mainColumn">
            <div class="content">
                <p><asp:Label ID="InstructionText" runat="server" Text="This vendor has one or more associated products.  Indicate what vendor these products should be changed to when {0} is deleted." EnableViewState="false"></asp:Label></p>
                <table class="inputForm">
                    <tr>
                        <th>
                            <asp:Label ID="NameLabel" runat="server" Text="Move to Vendor:" AssociatedControlID="VendorList" ToolTip="New vendor for associated products"></asp:Label><br />
                        </th>
                        <td>
                            <asp:DropDownList ID="VendorList" runat="server" DataTextField="Name" DataValueField="VendorId" AppendDataBoundItems="True">
                                <asp:ListItem Value="" Text="-- none --"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClick="DeleteButton_Click" />
							<asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="grid_6 alpha">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="ProductsCaption" runat="server" Text="Assigned Products"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="PagingAjax" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <cb:SortedGridView ID="ProductsGrid" runat="server" DataSourceID="ProductsDs" AllowPaging="True" 
                                AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="ProductId" PageSize="20" 
                                SkinID="PagedList" DefaultSortExpression="Name" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="Product" SortExpression="Name">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemTemplate>
                                            <asp:HyperLink ID="ProductName" runat="server" Text='<%# Eval("Name") %>' NavigateUrl='<%#Eval("ProductId", "../../Products/EditProduct.aspx?ProductId={0}") %>'></asp:HyperLink>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <asp:Label ID="EmptyMessage" runat="server" Text="There are no products associated with this vendor."></asp:Label>
                                </EmptyDataTemplate>
                            </cb:SortedGridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <asp:ObjectDataSource ID="ProductsDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}" 
                SelectCountMethod="CountForVendor" SelectMethod="LoadForVendor" 
                SortParameterName="sortExpression" TypeName="CommerceBuilder.Products.ProductDataSource">
                <SelectParameters>
                    <asp:QueryStringParameter Name="vendorId" QueryStringField="VendorId"
                        Type="Object" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </div>
</asp:Content>