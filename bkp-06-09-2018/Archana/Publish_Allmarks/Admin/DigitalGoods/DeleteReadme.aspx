<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.DigitalGoods.DeleteReadme" Title="Delete Readme" CodeFile="DeleteReadme.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Delete '{0}'" EnableViewState="false"></asp:Localize></h1>
    	</div>
    </div>
    <div class="grid_6 alpha">   
        <div class="mainColumn">
            <div class="content">
                <asp:Localize ID="InstructionText" runat="server" Text="This readme has one or more associated digital goods.  Indicate what readme should be assigned to these items when {0} is deleted." EnableViewState="false"></asp:Localize><br /><br />
                <asp:Label ID="NameLabel" runat="server" Text="Change to Readme:" AssociatedControlID="ReadmeList" ToolTip="New readme for associated products" SkinID="FieldHeader"></asp:Label>&nbsp;
                <asp:DropDownList ID="ReadmeList" runat="server" DataTextField="DisplayName" DataValueField="ReadmeId" AppendDataBoundItems="True">
                    <asp:ListItem Value="" Text="-- none --"></asp:ListItem>
                </asp:DropDownList><br /><br />
                <asp:Button ID="DeleteButton" runat="server" Text="Delete" OnClick="DeleteButton_Click" />
                <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" CausesValidation="false" />
            </div>
        </div>
    </div>
    <div class="grid_6 omega">   
        <div class="leftColumn">
            <div class="section">
                <div class="header">
                    <h2 class="commonicon"><asp:Localize ID="ProductsCaption" runat="server" Text="Associated Digital Goods"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:GridView ID="ProductsGrid" runat="server" AllowPaging="False" 
                        AllowSorting="False" AutoGenerateColumns="False" SkinID="PagedList"
                        Width="100%" EnableViewState="false">
                        <Columns>
                            <asp:TemplateField HeaderText="DigitalGood" SortExpression="Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemTemplate>
                                    <asp:HyperLink ID="DisplayName" runat="server" NavigateUrl='<%# string.Format("../Products/DigitalGoods/EditDigitalGood.aspx?DigitalGoodId={0}", Eval("DigitalGoodId")) %>' Text='<%#Eval("Name")%>'></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <asp:Label ID="EmptyMessage" runat="server" Text="There are no digital goods associated with this readme."></asp:Label>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>