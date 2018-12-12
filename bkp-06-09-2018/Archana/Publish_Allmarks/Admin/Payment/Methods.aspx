<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin._Payment.Methods" Title="Payment Methods" CodeFile="Methods.aspx.cs" %>
<%@ Register Src="AddPaymentMethodDialog.ascx" TagName="AddPaymentMethodDialog" TagPrefix="uc" %>
<%@ Register Src="EditPaymentMethodDialog.ascx" TagName="EditPaymentMethodDialog" TagPrefix="uc" %>
<%@ Register Src="~/Admin/ConLib/NavagationLinks.ascx" TagName="NavagationLinks" TagPrefix="uc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="pageHeader">
            	<div class="caption">
            		<h1><asp:Localize ID="Caption" runat="server" Text="Payment Methods"></asp:Localize></h1>
                    	<uc1:NavagationLinks ID="NavigationLinks" runat="server" Path="configure/payments" />
            	</div>
            </div>
            <div class="grid_7 alpha">
                <div class="mainColumn">
                    <div class="content">
                        <cb:SortedGridView ID="PaymentMethodGrid" runat="server" DataKeyNames="Id" DataSourceID="PaymentMethodDs" AutoGenerateColumns="false" DefaultSortExpression="OrderBy"
                                width="100%" SkinID="PagedList" OnRowEditing="PaymentMethodGrid_RowEditing" OnRowCancelingEdit="PaymentMethodGrid_RowCancelingEdit"
                            OnRowCommand="PaymentMethodGrid_RowCommand" >
                            <Columns>
                                <asp:TemplateField HeaderText="Order">
                                    <ItemStyle HorizontalAlign="center" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="UpButton" runat="server" SkinID="UpIcon" CommandName="MoveUp" CommandArgument='<%#Container.DataItemIndex%>' AlternateText="Up" />
                                        <asp:ImageButton ID="DownButton" runat="server" SkinID="DownIcon" CommandName="MoveDown" CommandArgument='<%#Container.DataItemIndex%>' AlternateText="Down" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name" HeaderStyle-HorizontalAlign="left" ReadOnly="true" />
                                <asp:TemplateField HeaderText="Gateway">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="Gateway" runat="server" Text='<%#Eval("PaymentGateway.Name")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" SkinID="EditIcon" AlternateText="Edit" Visible='<%#IsPaymentMethodEditable(Container.DataItem) %>' />
                                        <asp:ImageButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" SkinID="DeleteIcon" OnClientClick='<%#Eval("Name", "return confirm(\"Are you sure you want to delete {0}?\")") %>' AlternateText="Delete" Visible='<%#IsPaymentMethodEditable(Container.DataItem) %>'/>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:ImageButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel" SkinID="CancelIcon" AlternateText="Cancel" />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </cb:SortedGridView>
                        <p><asp:Localize ID="InstructionText" runat="server" Text="Payment methods can be used with a gateway, and also for custom payment options."></asp:Localize></p>
                    </div>
                </div>
            </div>
            <div class="grid_5 omega">
                <div class="rightColumn">
                    <asp:Panel ID="AddPanel" runat="server" CssClass="section">
                        <div class="header">
                            <h2 class="addpaymentmethod"><asp:Localize ID="AddCaption" runat="server" Text="Add Payment Method" /></h2>
                        </div>
                        <div class="content">
                            <uc:AddPaymentMethodDialog ID="AddPaymentMethodDialog1" runat="server" />
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="EditPanel" runat="server" CssClass="section" Visible="false">
                        <div class="header">
                            <h2><asp:Localize ID="EditCaption" runat="server" Text="Edit '{0}'" EnableViewState="false" /></h2>
                        </div>
                        <div class="content">
                            <uc:EditPaymentMethodDialog ID="EditPaymentMethodDialog1" runat="server" OnItemUpdated="EditPaymentMethodDialog1_ItemUpdated" OnCancelled="EditPaymentMethodDialog1_Cancelled" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:ObjectDataSource ID="PaymentMethodDs" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LoadAll" TypeName="CommerceBuilder.Payments.PaymentMethodDataSource" 
        SelectCountMethod="CountAll" SortParameterName="sortExpression"
        DataObjectTypeName="CommerceBuilder.Payments.PaymentMethod" DeleteMethod="Delete">
    </asp:ObjectDataSource>
</asp:Content>