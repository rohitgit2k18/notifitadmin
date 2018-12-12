<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.DigitalGoods.DeleteAgreement" Title="Delete Agreement" CodeFile="DeleteAgreement.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Delete {0}" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="grid_6 alpha">
        <div class="mainColumn">
            <div class="content">
                <asp:Localize ID="InstructionText" runat="server" Text="This agreement has one or more associated digital goods.  Indicate what agreement should be assigned to these items when {0} is deleted." EnableViewState="false"></asp:Localize><br /><br />
                <asp:Label ID="NameLabel" runat="server" Text="Change to Agreement:" AssociatedControlID="AgreementList" ToolTip="New agreement for associated products" SkinID="FieldHeader"></asp:Label>&nbsp;
                <asp:DropDownList ID="AgreementList" runat="server" DataTextField="DisplayName" DataValueField="LicenseAgreementId" AppendDataBoundItems="True">
                    <asp:ListItem Value="" Text="-- none --"></asp:ListItem>
                </asp:DropDownList><br /><br />
                <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClick="DeleteButton_Click" />
                <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false" />
            </div>
        </div>
    </div>
    <div class="grid_6 alpha">
        <div class="rightColumn">
            <div class="section">
                <div class="header">
                    <h2><asp:Localize ID="ProductsCaption" runat="server" Text="Associated Digital Goods"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:GridView ID="ProductsGrid" runat="server" AllowPaging="False" 
                        AllowSorting="False" AutoGenerateColumns="False" SkinID="PagedList"
                        Width="100%" EnableViewState="false" ShowHeader="false">
                        <Columns>
                            <asp:TemplateField HeaderText="Name" SortExpression="DisplayName">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="DisplayName" runat="server" NavigateUrl='<%# string.Format("EditDigitalGood.aspx?DigitalGoodId={0}", Eval("DigitalGoodId")) %>' Text='<%#Eval("Name")%>'></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>                                
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyMessage" runat="server" Text="There are no digital goods associated with this agreement."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
