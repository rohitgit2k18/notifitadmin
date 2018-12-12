<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.DigitalGoods.Agreements" Title="Manage Agreements" CodeFile="Agreements.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Manage License Agreements"></asp:Localize></h1>
            <div class="links">
                <cb:NavigationLink ID="ManageDGView" runat="server" Text="Manage Digital Goods" SkinID="Button" NavigateUrl="digitalgoods.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="FileView" runat="server" Text="Digital Files" NavigateUrl="DigitalGoodFiles.aspx" SkinID="Button" EnableViewState="false"></cb:NavigationLink>
                <cb:NavigationLink ID="ReadmesLink" runat="server" Text="Readmes" SkinID="Button" NavigateUrl="Readmes.aspx"></cb:NavigationLink>
                <cb:NavigationLink ID="AgreementsLink" runat="server" Text="Agreements" SkinID="ActiveButton" NavigateUrl="#"></cb:NavigationLink>
            </div>
    	</div>
    </div>
    <div class="grid_8 alpha">
        <div class="mainColumn">
            <div class="content">
                <asp:UpdatePanel ID="GridAjax" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <cb:SortedGridView ID="AgreementGrid" runat="server" AllowPaging="true" AllowSorting="true" PageSize="20"
                            AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="AgreementDs" 
                            ShowFooter="False" DefaultSortExpression="DisplayName" SkinID="PagedList">
                            <Columns>
                                <asp:TemplateField HeaderText="Name" SortExpression="DisplayName">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="NameLink" runat="server" NavigateUrl='<%#Eval("LicenseAgreementId", "EditAgreement.aspx?AgreementId={0}")%>' Text='<%# Eval("DisplayName") %>'></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Digital Goods">
                                    <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    <ItemTemplate>
                                        <asp:Label ID="ProductsLabel" runat="server" Text='<%#GetProductCount(Container.DataItem)%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ShowHeader="False">
                                    <ItemStyle HorizontalAlign="Center" Width="80px" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="EditLink" runat="server" CausesValidation="False" NavigateUrl='<%#Eval("LicenseAgreementId", "EditAgreement.aspx?AgreementId={0}")%>'><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" AlternateText="Edit" /></asp:HyperLink>
                                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# Eval("DisplayName", "return confirm(\"Are you sure you want to delete {0}?\");") %>' Visible='<%# !HasProducts(Container.DataItem) %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:LinkButton>
                                        <asp:HyperLink ID="DeleteLink" runat="server" CausesValidation="False" NavigateUrl='<%# Eval("LicenseAgreementId", "DeleteAgreement.aspx?AgreementId={0}")%>' Visible='<%# HasProducts(Container.DataItem) %>'><asp:Image ID="DeleteIcon2" runat="server" SkinID="DeleteIcon" AlternateText="Delete" /></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyDataText" runat="server" Text="No license agreements are defined for your store."></asp:Label>
                            </EmptyDataTemplate>
                        </cb:SortedGridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <p><asp:Localize ID="InstructionText" runat="server" Text="Create a License Agreement and assign it to a Digital Good.  The assignment settings will determine when the License Agreement must be accepted."></asp:Localize></p>
            </div>
        </div>
    </div>
    <div class="grid_4 omega">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2 class="addreadme"><asp:Localize ID="AddCaption" runat="server" Text="Add Agreement" /></h2>
                </div>
                <div class="content">
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                    <asp:Label ID="AddedMessage" runat="server" Text="{0} added.<br />" SkinID="GoodCondition" Visible="false"></asp:Label>
                    <table class="inputForm compact">
                        <tr>
                            <th>
                                <asp:Label ID="AddAgreementNameLabel" runat="server" Text="Name:" AssociatedControlID="AddAgreementName" ToolTip="Name of agreement"></asp:Label>
                            </th>
                            <td>
                                <asp:TextBox ID="AddAgreementName" runat="server" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="AddAgreementNameRequired" runat="server" ControlToValidate="AddAgreementName"
                                    Display="Static" ErrorMessage="Agreement name is required." Text="*"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:Button ID="AddAgreementButton" runat="server" Text="Add" OnClick="AddAgreementButton_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <asp:ObjectDataSource ID="AgreementDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.DigitalDelivery.LicenseAgreementDataSource" 
        SelectCountMethod="CountForStore" SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.DigitalDelivery.LicenseAgreement" 
        DeleteMethod="Delete" UpdateMethod="Update">
    </asp:ObjectDataSource>
</asp:Content>
