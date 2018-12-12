<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Taxes.TaxCodes" CodeFile="TaxCodes.aspx.cs" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="ContentAjax" runat="server" UpdateMode="conditional">
        <ContentTemplate>
			<div class="pageHeader">
				<div class="caption">
					<h1><asp:Localize ID="Caption" runat="server" Text="Tax Codes"></asp:Localize></h1>
					<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/taxes" />
				</div>
			</div>
            <div class="grid_8 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <p><asp:Localize ID="InstructionText" runat="server" Text="Tax codes can be assigned to items in your store.  The tax code rules will determine the amount to be taxed."></asp:Localize></p>
                        <asp:GridView ID="TaxCodeGrid" runat="server" AutoGenerateColumns="False" 
                            DataKeyNames="TaxCodeId" DataSourceId="TaxCodeDs" 
                            OnRowUpdating="TaxCodeGrid_RowUpdating" SkinID="PagedList" Width="100%">
                            <Columns>
                                <asp:TemplateField HeaderText="Name">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemTemplate>
                                        <asp:Label ID="Name" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="Name" runat="server" Text='<%#Eval("Name")%>' Width="110px" MaxLength="100" ValidationGroup="Edit" CausesValidation="true"></asp:TextBox><span class="requiredField">*</span>
                                        <asp:PlaceHolder ID="phGridNameValidator" runat="server" EnableViewState="false"></asp:PlaceHolder>
										<cb:RequiredRegularExpressionValidator ID="EditTaxCodeNameValidator" runat="server" ControlToValidate="Name"
                                                Display="Dynamic" SetFocusOnError="true" Enabled="true" ErrorMessage="Tax code name must be between 1 and 100 characters in length." 
                                                Text="*" ValidationGroup="Edit" ValidationExpression=".{1,100}" Required="true">
                                        </cb:RequiredRegularExpressionValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Products">
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="ProductsLink" runat="server" Text='<%#Eval("Products.Count")%>' NavigateUrl='<%# Eval("TaxCodeId", "TaxCodeProducts.aspx?TaxCodeId={0}")%>' SkinID="GridLink"></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Tax Rules">
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="TaxRulesLink" runat="server" Text='<%#Eval("TaxRules.Count")%>' NavigateUrl='<%# Eval("TaxCodeId", "TaxCodeTaxRules.aspx?TaxCodeId={0}")%>' SkinID="GridLink"></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Center" Width="20%" />
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="SaveLinkButton" runat="server" CausesValidation="True" CommandName="Update" ValidationGroup="Edit"><asp:Image ID="SaveIcon" runat="server" SkinID="SaveIcon" /></asp:LinkButton>
                                        <asp:LinkButton ID="CancelLinkButton" runat="server" CausesValidation="False" CommandName="Cancel"><asp:Image ID="CancelIcon" runat="server" SkinID="CancelIcon" /></asp:LinkButton>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditLinkButton" runat="server" CausesValidation="False" CommandName="Edit"><asp:Image ID="EditIcon" runat="server" SkinID="EditIcon" /></asp:LinkButton>
                                        <asp:LinkButton ID="DeleteLinkButton" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick='<%# Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>'><asp:Image ID="DeleteIcon" runat="server" SkinID="DeleteIcon" /></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="emptyData">
                                    <asp:Label ID="TaxCodesInstructionText" runat="server" Text="There are no tax codes available in the store."></asp:Label><br /><br />
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>                        
                    </div>
                </div>
            </div>
            <div class="grid_4 omega">
                <div class="rightColumn">
                    <div class="section">
                        <div class="header">
                            <h2><asp:Localize ID="AddCaption" runat="server" Text="Add Tax Code" /></h2>
                        </div>
                        <div class="content">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Add" />
                            <table class="inputForm">
                                <tr>
                                    <th>
                                        <asp:Label ID="AddTaxCodeNameLabel" runat="server" Text="Name:" AssociatedControlID="AddTaxCodeName" ToolTip="Tax code name"></asp:Label>
                                    </th>
                                    <td>
                                        <asp:TextBox ID="AddTaxCodeName" runat="server" Columns="20" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                                        <cb:RequiredRegularExpressionValidator ID="AddTaxCodeNameValidator" runat="server" ControlToValidate="AddTaxCodeName"
                                            Display="Dynamic" ErrorMessage="Tax code name must be between 1 and 100 characters in length." Text="*"
                                            ValidationGroup="Add" ValidationExpression=".{1,100}" Required="true">
                                        </cb:RequiredRegularExpressionValidator>
                                        <asp:PlaceHolder ID="phNameValidator" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                        <asp:Button ID="AddButton" runat="server" Text="Add" OnClick="AddButton_Click" ValidationGroup="Add" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="TaxCodeDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Taxes.TaxCodeDataSource" SelectCountMethod="CountForStore"
        SortParameterName="sortExpression" DataObjectTypeName="CommerceBuilder.Taxes.TaxCode"
        DeleteMethod="Delete">
    </asp:ObjectDataSource>
</asp:Content>