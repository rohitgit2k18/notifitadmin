<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Taxes.TaxCodeTaxRules" Title="Tax Code Rules" CodeFile="TaxCodeTaxRules.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="PageAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1><asp:Localize ID="Caption" runat="server" Text="{0}: Linked Tax Rules"></asp:Localize></h1>
                    <div class="links">
                        <asp:HyperLink ID="AddTaxRuleLink" runat="server" Text="Add Tax Rule" NavigateUrl="AddTaxRule.aspx" SkinID="AddButton"></asp:HyperLink>
                        <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click"></asp:Button>
                        <asp:HyperLink ID="BackLink" runat="server" Text="Cancel" SkinID="CancelButton" NavigateUrl="TaxCodes.aspx"></asp:HyperLink>
                    </div>
            	</div>
            </div>
            <div class="content">
                <cb:Notification ID="SavedMessage" runat="server" Text="Tax rule associations updated at {0:t}." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <cb:SortedGridView ID="TaxRuleGrid" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="Id" DataSourceID="TaxRuleDs" Width="100%" SkinID="PagedList" AllowPaging="False"
                    AllowSorting="true" DefaultSortExpression="Name">
                    <Columns>
                        <asp:TemplateField HeaderText="Linked">
                            <HeaderStyle Width="60px" />
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="Linked" runat="server" Checked='<%#IsLinked(Container.DataItem)%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" SortExpression="Name">
                            <HeaderStyle HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:HyperLink ID="NameLink" runat="server" Text='<%# Eval("Name") %>' NavigateUrl='<%#String.Format("EditTaxRule.aspx?TaxRuleId={0}&TaxCodeId={1}", Eval("TaxRuleId"),Request.QueryString["TaxCodeId"] )%>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Label ID="EmptyDataMessage" runat="server" Text="There are no tax rules defined for your store."></asp:Label>
                    </EmptyDataTemplate>
                </cb:SortedGridView>
            </div>
        </ContentTemplate>                        
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="TaxRuleDs" runat="server" EnablePaging="False" OldValuesParameterFormatString="original_{0}"
        SelectCountMethod="CountAll" SelectMethod="LoadAll" SortParameterName="sortExpression"
        TypeName="CommerceBuilder.Taxes.TaxRuleDataSource">
    </asp:ObjectDataSource>
</asp:Content>

