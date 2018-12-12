<%@ Page Title="View Wishlist" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="True" CodeFile="MyWishlist.aspx.cs" Inherits="AbleCommerce.Mobile.Members.MyWishlist" ViewStateMode="Disabled" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="accountPage">
        <div id="account_wishlistPage" class="mainContentWrapper">
            <div class="header">
		        <h2><asp:Localize ID="Caption" runat="server" Text="My Wishlist"></asp:Localize></h2>
	        </div>
		    <div class="warnings">
			    <asp:DataList ID="WarningMessageList" runat="server" EnableViewState="false" CssClass="warnCondition">
				    <HeaderTemplate><ul></HeaderTemplate>
				    <ItemTemplate>
					    <li><%# Container.DataItem %></li>
				    </ItemTemplate>
				    <FooterTemplate></ul></FooterTemplate>
			    </asp:DataList>
		    </div>
            <asp:Panel ID="WishlistPanel" runat="server" CssClass="tabpane" DefaultButton="UpdateButton">
                <asp:UpdatePanel ID="WishlistAjax" runat="server">
                    <ContentTemplate>
                        <cb:Notification ID="WishlistUpdatedMessage" runat="server" Text="Your wishlist has been updated." SkinID="Success" Visible="false"></cb:Notification>
                        <asp:GridView ID="WishlistGrid" runat="server" AutoGenerateColumns="False" ShowHeader="true"
                            ShowFooter="False" DataKeyNames="WishlistItemId" OnRowCommand="WishlistGrid_RowCommand"
                            OnDataBound="WishlistGrid_DataBound" Width="100%" CssClass="basketItems" onrowcreated="WishlistGrid_RowCreated">
                            <Columns>
					            <asp:TemplateField>
						            <HeaderTemplate></HeaderTemplate>
									<ItemStyle CssClass="thumbnail" />
									<ItemTemplate>
							            <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
									        <asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("Product.ThumbnailAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetThumbnailUrl(Container.DataItem) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
                                            <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
							            </asp:PlaceHolder>
						            </ItemTemplate>
					            </asp:TemplateField>
						        <asp:TemplateField>
							        <HeaderTemplate></HeaderTemplate>
									<ItemStyle CssClass="itemDetail" />
									<ItemTemplate>
                                        <div class="itemDetail basketItemDetail">
                                            <asp:HyperLink ID="ProductLink" runat="Server" NavigateUrl='<%#GetProductUrl(Container.DataItem)%>'><asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Product.Name") %>'></asp:Label><asp:Label ID="OptionNames" runat="Server" Text='<%#Eval("ProductVariant.VariantName", " ({0})")%>' Visible='<%#(Eval("ProductVariant") != null)%>'></asp:Label></asp:HyperLink><br />
                                            <asp:Panel ID="InputPanel" runat="server" Visible='<%#((int)Eval("WishlistItemInputs.Count") > 0)%>'>
                                                <asp:DataList ID="InputList" runat="server" DataSource='<%#Eval("WishlistItemInputs") %>'>
                                                    <ItemTemplate>
                                                        <asp:Label ID="InputName" Runat="server" Text='<%#Eval("InputField.Name", "{0}:")%>' CssClass="fieldHeader"></asp:Label>
                                                        <asp:Label ID="InputValue" Runat="server" Text='<%#Eval("InputValue")%>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:DataList>
                                            </asp:Panel>
                                            <asp:Repeater ID="KitProductRepeater" runat="server" DataSource='<%# GetKitProducts(Container.DataItem) %>' Visible='<%# HasKitProducts(Container.DataItem) %>'>
                                                <HeaderTemplate><ul class="kitInputList"></HeaderTemplate>
                                                <ItemTemplate>
                                                    <li><%#Eval("DisplayName")%></li>
                                                </ItemTemplate>
                                                <FooterTemplate></ul></FooterTemplate>
                                            </asp:Repeater>
                                            <asp:PlaceHolder ID="SubscriptionPanel" runat="server" Visible="false">
                                                <small><asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal></small><br />
                                            </asp:PlaceHolder>
                                        </div><%--
                                        <div class="itemDate">
                                            <asp:Localize ID="LastModifiedDateLabel" runat="server" Text="Last modified on "></asp:Localize><asp:Localize ID="LastModifiedDate" runat="server" text='<%# Eval("LastModifiedDate", "{0:d}") %>'></asp:Localize>
                                        </div>--%>
                                         <div class="price">
                                            <span class="label">Price: </span>
                                            <span class="value"><%# GetPrice(Container.DataItem) %></span>
							            </div>
                                        <div class="qty">
                                            <span class="label">Qty: </span>
								                <asp:TextBox ID="Desired" runat="server" Text='<%#Eval("Desired")%>' MaxLength="5" Width="40px" CssClass="value"></asp:TextBox>
							                </div>
                                        <div class="qty">
                                            <span class="label">Priority:</span>
                                            <asp:DropDownList ID="Priority" runat="server" SelectedValue='<%#Eval("Priority")%>'>
                                                <asp:ListItem Value="4">highest</asp:ListItem>
                                                <asp:ListItem Value="3">high</asp:ListItem>
                                                <asp:ListItem Value="2">medium</asp:ListItem>
                                                <asp:ListItem Value="1">low</asp:ListItem>
                                                <asp:ListItem Value="0">lowest</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div class="comment">
                                            <span class="label">Comment:</span>
                                            <asp:TextBox ID="Comment" runat="server" Text='<%#Eval("Comment")%>' Width="200px"></asp:TextBox>
                                        </div>
                                        <div class="itemActions">
                                            <asp:LinkButton ID="AddToBasketButton" runat="Server" CssClass="link button" CommandName="Basket" CommandArgument='<%#Container.DataItemIndex%>' Text="Add to Cart" Visible='<%# ((bool)Eval("Product.DisablePurchase") != true)%>' />
                                            <asp:LinkButton ID="DeleteItemButton" runat="server" CssClass="link button" CommandName="DeleteItem" CommandArgument='<%#Container.DataItemIndex%>' OnClientClick="return confirm('Are you sure you want to delete this item from your wishlist?')" Text="Delete"></asp:LinkButton>
                                        </div>
							        </ItemTemplate>
						        </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Localize ID="EmptyWishlistMessage" runat="server" Text="Your wishlist is empty."></asp:Localize>
                            </EmptyDataTemplate>
                        </asp:GridView>
                        <div class="actions">
                            <asp:Button ID="KeepShoppingButton" runat="server" Text="Keep Shopping" OnClick="KeepShoppingButton_Click"></asp:Button>
                            <asp:Button ID="ClearWishlistButton" runat="server" Text="Clear Wishlist" OnClientClick="return confirm('Are you sure you want to clear your wishlist?')" OnClick="ClearWishlistButton_Click"></asp:Button>
                            <asp:Button ID="UpdateButton" runat="server" Text="Update Wishlist" OnClick="UpdateButton_Click" OnClientClick="this.value='Updating...'"></asp:Button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Panel ID="AnonymousPanel" runat="server" Visible="false" CssClass="widget wishlistRegisterWidget">
                <div class="header">      
                    <h2>Register Now!</h2>
                </div>
                <div class="content">
                    <p>To preserve your wishlist for future visits and for additional features you should <asp:HyperLink ID="RegisterLink" runat="server" Text="login or register" CssClass="link button"></asp:HyperLink> now.</p>
                </div>
            </asp:Panel>
	    </div>
    </div>
</asp:Content>