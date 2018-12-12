<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Products.ProductTemplates._Default" Title="Product Templates"  CodeFile="Default.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Product Templates"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="ImagesLink" runat="server" Text="Images and Assets" SkinID="Button" NavigateUrl="../Assets/AssetManager.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="ProductTemplates" runat="server" Text="Product Templates" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
                <cb:NavigationLink ID="GiftWrap" runat="server" Text="Gift Wrap" SkinID="Button" NavigateUrl="../GiftWrap/Default.aspx"></cb:NavigationLink>
            </div>
    	</div>
    </div>
    <div class="grid_8 alpha">
        <div class="mainColumn">
            <div class="content">
                <asp:UpdatePanel ID="ProductTemplateAjax" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:GridView ID="ProductTemplateGrid" runat="server" AutoGenerateColumns="False" DataSourceID="ProductTemplateDs" 
                            DataKeyNames="ProductTemplateId" AllowPaging="True" OnRowCommand="ProductTemplateGrid_RowCommand"
                            SkinID="PagedList" width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="Template Name">
                                    <ItemTemplate>
                                        <asp:Label ID="Name" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Merchant Fields">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="MerchantFields" runat="server" Text='<%# CountMerchantFields(Container.DataItem) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Customer Fields">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="CustomerFields" runat="server" Text='<%# CountCustomerFields(Container.DataItem) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Products">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="Products" runat="server" Text='<%# CountProducts(Container.DataItem) %>' NavigateUrl='<%#Eval("ProductTemplateId", "ViewProducts.aspx?ProductTemplateId={0}")%>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-Wrap="false">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="EditLink" runat="server" NavigateUrl='<%#Eval("ProductTemplateId", "EditProductTemplate.aspx?ProductTemplateId={0}")%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" /></asp:HyperLink>
                                        <asp:ImageButton ID="CopyButton" runat="server" AlternateText="Copy" SkinID="CopyIcon" CommandName="Copy" CommandArgument='<%#Eval("ProductTemplateId")%>' />
                                        <asp:ImageButton ID="DeleteButton" runat="server" AlternateText="Delete" SkinID="DeleteIcon" CommandName="Delete" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div style="text-align:center;margin-top:10px;margin-bottom:10px;padding-left:10px;padding-right:10px">
                                <asp:Label ID="NoProductTemplatesText" runat="server" Text="<i>There are no product templates defined.</i>"></asp:Label>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <p class="intro"><asp:Localize ID="Localize1" runat="server" Text="Use Product Templates to create fields for the merchant and/or customer."></asp:Localize></p>
            </div>
        </div>
    </div>
    <div class="grid_4 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2 class="addtemplate"><asp:Localize ID="AddCaption" runat="server" Text="Add Template" /></h2>
                </div>
                <div class="content">
                    <asp:UpdatePanel ID="AddAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Add" />
                            <asp:Label ID="AddNameLabel" runat="server" Text="Name:" SkinID="FieldHeader"></asp:Label>
                            <asp:TextBox ID="AddName" runat="server" MaxLength="100"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="AddNameValidator" runat="server" ErrorMessage="Maximum length for Name is 100 characters." Text="*" ControlToValidate="AddName" ValidationExpression=".{1,100}"  ValidationGroup="Add" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ID="AddNameRequired" runat="server" ControlToValidate="AddName" ValidationGroup="Add" Text="*" ErrorMessage="Name is required." Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:Button ID="AddButton" runat="server" Text="Add" OnClick="AddButton_Click" ValidationGroup="Add" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <asp:ObjectDataSource ID="ProductTemplateDs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="LoadAll" TypeName="CommerceBuilder.Products.ProductTemplateDataSource" DataObjectTypeName="CommerceBuilder.Products.ProductTemplate" DeleteMethod="Delete"></asp:ObjectDataSource>
</asp:Content>