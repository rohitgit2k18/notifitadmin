<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Discounts._Default" Title="Discounts" CodeFile="Default.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Discounts"></asp:Localize></h1>
		<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="marketing" />
    	</div>
    </div>
    <div class="content">
        <asp:Button ID="AddButton" runat="server" Text="Add Discount" SkinID="AddButton" OnClick="AddButton_Click"></asp:Button>
        <p><asp:Label ID="InstructionText" runat="server" Text="Volume discounts are applied to purchases automatically when all criteria are met.  You can apply discounts to categories or products, and discount by quantity or value."></asp:Label></p>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <cb:SortedGridView ID="VolumeDiscountGrid" runat="server" AutoGenerateColumns="False" DataSourceID="VolumeDiscountDs" 
                    DataKeyNames="Id" AllowPaging="True" OnRowCommand="VolumeDiscountGrid_RowCommand" SkinID="PagedList" 
                    Width="100%" AllowSorting="true" DefaultSortExpression="Name">
                    <Columns>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="NameLink" runat="server" Text='<%# Eval("Name") %>' NavigateUrl='<%# Eval("VolumeDiscountId", "EditDiscount.aspx?VolumeDiscountId={0}") %>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Basis">
                            <ItemStyle HorizontalAlign="center" />
                            <ItemTemplate>
                                <asp:Label ID="Basis" runat="server" Text='<%# (bool)Eval("IsValueBased") ? "Value" : "Quantity" %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Scope">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Panel ID="LinksPanel" runat="server" Visible='<%#!((bool)Eval("IsGlobal"))%>'>
                                    <asp:Label ID="Categories" runat="server" Text='<%#Eval("Categories.Count")%>'></asp:Label>
                                    <asp:Label ID="CategoriesLabel" runat="server" text=" categories"></asp:Label>, 
                                    <asp:Label ID="Products" runat="server" Text='<%#Eval("Products.Count")%>' />
                                    <asp:Label ID="ProductsLabel" runat="server" text=" products"></asp:Label>
                                </asp:Panel>
                                <asp:Label ID="IsGlobalLabel" runat="server" Text="Global" Visible='<%#Eval("IsGlobal")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemStyle HorizontalAlign="Center" Width="81px" Wrap="false" />
                            <ItemTemplate>
                                <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%# Eval("VolumeDiscountId", "EditDiscount.aspx?VolumeDiscountId={0}") %>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit"></asp:Image></asp:HyperLink>
                                <asp:ImageButton ID="CopyButton" runat="server" AlternateText="Copy" ToolTip="Copy" SkinID="CopyIcon" CommandName="Copy" CommandArgument='<%# Eval("VolumeDiscountId")%>' />
                                <asp:ImageButton ID="DeleteButton" runat="server" AlternateText="Delete" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="NoVolumeDiscountsText" runat="server" Text="<i>There are no volume discounts defined.</i>"></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <asp:ObjectDataSource ID="VolumeDiscountDs" runat="server" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Marketing.VolumeDiscountDataSource" 
        DataObjectTypeName="CommerceBuilder.Marketing.VolumeDiscount" DeleteMethod="Delete" SortParameterName="sortExpression">
    </asp:ObjectDataSource>
</asp:Content>