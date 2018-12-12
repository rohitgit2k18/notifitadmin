<%@ Page Title="Find Wishlist" Language="C#" MasterPageFile="~/Layouts/Fixed/RightSidebar.Master" AutoEventWireup="True" CodeFile="FindWishlist.aspx.cs" Inherits="AbleCommerce.FindWishlist" %>
<%@ Register src="~/ConLib/MiniBasket.ascx" tagname="MiniBasket" tagprefix="uc2" %>
<asp:Content ID="MainContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="findWishlistPage" class="mainContentWrapper">
	<div class="section">
		<div class="pageHeader">
			<h1>Find a Wish List</h1>
		</div>
		<div class="content">
	        <asp:UpdatePanel ID="Searchajax" runat="server">
                <ContentTemplate>
                    <asp:Panel ID="SearchPanel" runat="server" EnableViewState="false" DefaultButton="SearchButton">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" EnableViewState="false" />
                        <table class="inputForm">
	                        <tr>
		                        <th class="rowHeader">
                                    <asp:Label ID="SearchNameLabel" runat="server" Text="Name or E-mail:" AssociatedControlID="SearchName" EnableViewState="false"></asp:Label>
                                </th>
                                <td>
			                        <asp:Textbox id="SearchName" runat="server" onfocus="this.select()" Width="200px" EnableViewState="false"></asp:Textbox>
			                        <asp:RequiredFieldValidator ID="SearchNameValdiator" runat="server" ControlToValidate="SearchName"
			                             Text="*" ErrorMessage="Name or email address is required." EnableViewState="false"></asp:RequiredFieldValidator>
		                        </td>
	                        </tr>
	                        <tr>
		                        <th class="rowHeader">
                                    <asp:Label ID="SearchLocationLabel" runat="server" Text="City or State (optional):" EnableViewState="false"></asp:Label>
                                </th>
		                        <td>
			                        <asp:TextBox id="SearchLocation" runat="server" onfocus="this.select()" Width="140px" EnableViewState="false"></asp:TextBox>
			                        <asp:LinkButton ID="SearchButton" runat="server" CssClass="button linkButton" Text="Search" OnClick="SearchButton_Click" EnableViewState="false" />
		                        </td>
	                        </tr>
                        </table><br />
                        <asp:GridView ID="WishlistGrid" runat="server" AllowPaging="True" 
                            AutoGenerateColumns="False" ShowHeader="true" 
                            DataKeyNames="WishlistId" SkinID="PagedList" DataSourceID="SearchDs"
                            Visible="false" EnableViewState="false">
                            <Columns>
                                <asp:TemplateField HeaderText="Name">
                                    <HeaderStyle CssClass="wishlistName" />
                                    <ItemStyle CssClass="wishlistName" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="WishlistLink" runat="server" NavigateUrl='<%# Eval("ViewCode", "~/ViewWishlist.aspx?ViewCode={0}")%>'>
                                            <%#GetUserName(Eval("User"))%>
                                        </asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Location">
                                    <HeaderStyle CssClass="wishlistLocation" />
                                    <ItemStyle CssClass="wishlistLocation" />
                                    <ItemTemplate> 
                                        <asp:Label ID="Location" runat="server" Text='<%#GetLocation(Eval("User.PrimaryAddress"))%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Localize ID="EmptySearchResult" runat="server" Text="There were no wishlists matching your search criteria."></asp:Localize>
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <asp:ObjectDataSource ID="SearchDs" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="Search" TypeName="CommerceBuilder.Users.WishlistDataSource" EnableViewState="false">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="SearchName" Name="name" PropertyName="Text" Type="String" />
                                <asp:ControlParameter ControlID="SearchLocation" Name="location" PropertyName="Text" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </asp:Panel>
                </ContentTemplate>
		    </asp:UpdatePanel>
		</div>
	</div>
</div>
</asp:Content>
<asp:Content ID="RightSidebar" runat="server" contentplaceholderid="RightSidebar">
	<uc2:MiniBasket ID="MiniBasket1" runat="server" />
</asp:Content>