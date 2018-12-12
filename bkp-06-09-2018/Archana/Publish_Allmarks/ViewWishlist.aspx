<%@ Page Title="View Wishlist" Language="C#" MasterPageFile="~/Layouts/Fixed/RightSidebar.Master" AutoEventWireup="True" CodeFile="ViewWishlist.aspx.cs" Inherits="AbleCommerce.ViewWishlist" %>
<%@ Register src="~/ConLib/MiniBasket.ascx" tagname="MiniBasket" tagprefix="uc" %>
<%@ Register src="~/ConLib/WishlistSearch.ascx" tagname="WishlistSearch" tagprefix="uc" %>
<asp:Content ID="PageContent" runat="server" ContentPlaceHolderID="PageContent">
<div id="viewWishlistPage" class="mainContentWrapper">
	<div class="section">
		<div class="pageHeader">
			<h1><asp:Localize runat="server" ID="WishlistCaption" Text="{0}'s Wishlist"></asp:Localize></h1>
		</div>
		<div class="content">
		    <asp:MultiView ID="WishlistMultiView" runat="server" ActiveViewIndex="0">
			    <asp:View ID="WishlistView" runat="server">
				    <cb:ExGridView ID="WishlistGrid" runat="server" AutoGenerateColumns="False" ShowHeader="true"
					    ShowFooter="False" DataKeyNames="WishlistItemId" OnRowCommand="WishlistGrid_RowCommand"
					    Width="100%" EnableViewState="false" SkinID="Basket" onrowcreated="WishlistMultiView_RowCreated">
					    <Columns>
						    <asp:TemplateField HeaderText="Item">
							    <HeaderStyle CssClass="thumbnail" />
							    <ItemStyle CssClass="thumbnail" />
							    <ItemTemplate>
								    <asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("Product.ThumbnailAltText") %>' ImageUrl='<%# Eval("Product.ThumbnailUrl") %>' Visible='<%# !string.IsNullOrEmpty(Eval("Product.ThumbnailUrl").ToString()) %>' EnableViewState="false" />
                                    <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
							    </ItemTemplate>
						    </asp:TemplateField>
						    <asp:TemplateField>
                                <HeaderStyle CssClass="item" />
							    <ItemStyle CssClass="item" />
							    <ItemTemplate>
                                    <div class="itemDetail">
								        <asp:HyperLink ID="ProductLink" runat="Server" NavigateUrl='<%# UrlGenerator.GetBrowseUrl((int)Eval("ProductId"), CatalogNodeType.Product, Eval("Product.Name").ToString()) %>'><asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Product.Name") %>'></asp:Label><asp:Label ID="OptionNames" runat="Server" Text='<%#Eval("ProductVariant.VariantName", " ({0})")%>' Visible='<%#(Eval("ProductVariant") != null)%>'></asp:Label></asp:HyperLink><br />
								        <asp:Label ID="PriceLabel" runat="server" Text="Price:" CssClass="fieldHeader"></asp:Label> <asp:Label ID="Price" runat="server" Text='<%# GetPrice(Container.DataItem).LSCurrencyFormat("ulc") %>'></asp:Label>
								        <asp:Panel ID="InputPanel" runat="server" Visible='<%#((int)Eval("WishlistItemInputs.Count") > 0)%>'>
                                            <br />
									        <asp:DataList ID="InputList" runat="server" DataSource='<%#Eval("WishlistItemInputs") %>'>
										        <ItemTemplate>
											        <asp:Label ID="InputName" Runat="server" Text='<%#Eval("InputField.Name", "{0}:")%>' CssClass="fieldHeader"></asp:Label>
											        <%#Eval("InputValue")%>
										        </ItemTemplate>
									        </asp:DataList>
								        </asp:Panel>
								        <asp:Panel ID="WishlistItemPanel" runat="server" Visible='<%# HasKitProducts(Container.DataItem) %>'>
									        <ul>
									        <asp:Repeater ID="KitProductRepeater" runat="server" DataSource='<%# GetKitProducts(Container.DataItem) %>'>
										        <ItemTemplate>
											        <li><%#Eval("Name")%></li>
										        </ItemTemplate>
									        </asp:Repeater>
									        </ul>
								        </asp:Panel>
                                        <asp:PlaceHolder ID="SubscriptionPanel" runat="server" Visible="false">
                                            <br /><asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal>
                                        </asp:PlaceHolder>
                                    </div>
                                    <asp:Panel ID="CommentPanel" runat="server" Class="itemComment" Visible='<%# !string.IsNullOrEmpty((string)Eval("Comment")) %>'>
								        <%# Eval("Comment") %>
                                    </asp:Panel>
                                    <div class="itemDate">
								        Last Modified on <%# Eval("LastModifiedDate", "{0:d}") %>
                                    </div>
                                    <asp:Panel ID="ItemActionsPanel" runat="server" Visible='<%# AllowPurchase(Container.DataItem) %>' CssClass="itemActions">
								        <asp:LinkButton ID="AddToBasketButton" runat="Server" CssClass="link" CommandName="Basket" CommandArgument='<%#Eval("WishlistItemId")%>' Text="Add to Cart" />
                                    </asp:Panel>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="Desired">
							    <HeaderStyle CssClass="quantity quantityDesired" />
							    <ItemStyle CssClass="quantity quantityDesired" />
							    <ItemTemplate>
								    <%#Eval("Desired")%>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="Received">
							    <HeaderStyle CssClass="quantity quantityReceived" />
							    <ItemStyle CssClass="quantity quantityReceived" />
							    <ItemTemplate>
								    <%#Eval("Received")%>
							    </ItemTemplate>
						    </asp:TemplateField>
                            <asp:TemplateField HeaderText="Priority">
							    <HeaderStyle CssClass="priority" />
							    <ItemStyle CssClass="priority" />
							    <ItemTemplate>
                                    <%# GetPriorityString(Eval("Priority")) %>
							    </ItemTemplate>
						    </asp:TemplateField>
					    </Columns>
					    <EmptyDataTemplate>
						    <asp:Localize ID="EmptyWishlistMessage" runat="server" Text="The wishlist is empty."></asp:Localize>
					    </EmptyDataTemplate>
				    </cb:ExGridView>
			    </asp:View>
			    <asp:View ID="PasswordView" runat="server">
				    <div class="wishlistPasswordPanel">
					    <p><asp:Label ID="InvalidPasswordLabel" runat="server" Text="The wishlist password you provided is incorrect.  Enter the correct password to view the list:" CssClass="errorCondition" Visible=false></asp:Label>
					    <asp:Label ID="PasswordLabel" runat="server" Text="This wishlist is password protected.  Enter the password to view the list:"></asp:Label></p>
					    <asp:TextBox ID="Password" runat="server" Text=""></asp:TextBox>
					    <asp:LinkButton ID="CheckPasswordButton" runat="server" Text="View" CssClass="button linkButton" OnClick="CheckPasswordButton_Click" />
				    </div>
			    </asp:View>
                <asp:View ID="WishlistDisabledView" runat="server">
                    <asp:Localize ID="WishlistDisabledMessage" runat="server" Text="Wishlist feature is currently disabled."></asp:Localize>
                </asp:View>
		    </asp:MultiView>
		</div>
	</div>
</div>
</asp:Content>
<asp:Content ID="RightSidebar" runat="server" contentplaceholderid="RightSidebar">
	<uc:MiniBasket ID="MiniBasket1" runat="server" />
	<uc:WishlistSearch ID="WishlistSearch1" runat="server" />
</asp:Content>