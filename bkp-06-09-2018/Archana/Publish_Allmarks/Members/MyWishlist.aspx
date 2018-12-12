<%@ Page Title="View Wishlist" Language="C#" MasterPageFile="~/Layouts/Fixed/Account.master" AutoEventWireup="True" CodeFile="MyWishlist.aspx.cs" Inherits="AbleCommerce.Members.MyWishlist" ViewStateMode="Disabled" %>
<%@ Register Src="~/ConLib/Account/AccountTabMenu.ascx" TagName="AccountTabMenu" TagPrefix="uc" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="PageContent" Runat="Server">
    <div id="accountPage">
        <div id="account_wishlistPage" class="mainContentWrapper">
		    <div class="warnings">
			    <asp:DataList ID="WarningMessageList" runat="server" EnableViewState="false" CssClass="warnCondition">
				    <HeaderTemplate><ul></HeaderTemplate>
				    <ItemTemplate>
					    <li><%# Container.DataItem %></li>
				    </ItemTemplate>
				    <FooterTemplate></ul></FooterTemplate>
			    </asp:DataList>
		    </div>
            <uc:AccountTabMenu ID="AccountTabMenu1" runat="server" />
            <asp:Panel ID="WishlistPanel" runat="server" CssClass="tabpane" DefaultButton="UpdateButton">
                <asp:UpdatePanel ID="WishlistAjax" runat="server">
                    <ContentTemplate>
                        <cb:Notification ID="WishlistUpdatedMessage" runat="server" Text="Your wishlist has been updated." SkinID="Success" Visible="false"></cb:Notification>
                        <cb:ExGridView ID="WishlistGrid" runat="server" AutoGenerateColumns="False" ShowHeader="true"
                            ShowFooter="False" DataKeyNames="WishlistItemId" OnRowCommand="WishlistGrid_RowCommand"
                            OnDataBound="WishlistGrid_DataBound" Width="100%" SkinID="Basket" 
                            onrowcreated="WishlistGrid_RowCreated" FixedColIndexes="0,2">
                            <Columns>
					            <asp:TemplateField HeaderText="Item">
						            <HeaderStyle CssClass="thumbnail" />
						            <ItemStyle CssClass="thumbnail" />
						            <ItemTemplate>
							            <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
									        <asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("Product.ThumbnailAltText") %>' ImageUrl='<%# AbleCommerce.Code.ProductHelper.GetThumbnailUrl(Container.DataItem) %>' Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
                                            <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
							            </asp:PlaceHolder>
						            </ItemTemplate>
					            </asp:TemplateField>
						        <asp:TemplateField>
							        <HeaderStyle CssClass="item" />
							        <ItemStyle CssClass="item" />
							        <ItemTemplate>
                                        <div class="itemDetail wishlistItemDetail">
                                            <asp:HyperLink ID="ProductLink" runat="Server" NavigateUrl='<%#GetProductUrl(Container.DataItem)%>'><asp:Label ID="NameLabel" runat="server" Text='<%# Eval("Product.Name") %>'></asp:Label><asp:Label ID="OptionNames" runat="Server" Text='<%#Eval("ProductVariant.VariantName", " ({0})")%>' Visible='<%#(Eval("ProductVariant") != null)%>'></asp:Label></asp:HyperLink>
                                            <asp:Panel ID="InputPanel" runat="server" Visible='<%#((int)Eval("WishlistItemInputs.Count") > 0)%>'>
                                                <br />
                                                <asp:DataList ID="InputList" runat="server" DataSource='<%#Eval("WishlistItemInputs") %>'>
                                                    <ItemTemplate>
                                                        <asp:Label ID="InputName" Runat="server" Text='<%#Eval("InputField.Name", "{0}:")%>' CssClass="fieldHeader"></asp:Label>
                                                        <asp:Label ID="InputValue" Runat="server" Text='<%#Eval("InputValue")%>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:DataList>
                                            </asp:Panel>
                                        <%--<asp:Repeater ID="KitProductRepeater" runat="server" DataSource='<%# GetKitProducts(Container.DataItem) %>' Visible='<%# HasKitProducts(Container.DataItem) %>'>
                                                <HeaderTemplate><br /><ul></HeaderTemplate>
                                                <ItemTemplate>
                                                    <li><%#Eval("DisplayName")%></li>
                                                </ItemTemplate>
                                                <FooterTemplate></ul></FooterTemplate>
                                            </asp:Repeater>--%>
                                            <asp:PlaceHolder ID="SubscriptionPanel" runat="server" Visible="false">
                                                <br /><asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal>
                                            </asp:PlaceHolder>
                                        </div>
                                        <%--<div class="itemDate">
                                            <asp:Localize ID="LastModifiedDateLabel" runat="server" Text="Last modified on "></asp:Localize><asp:Localize ID="LastModifiedDate" runat="server" text='<%# Eval("LastModifiedDate", "{0:d}") %>'></asp:Localize>
                                        </div>--%>
                                        <div class="itemActions">
                                            <asp:LinkButton ID="AddToBasketButton" runat="Server" CssClass="button add-btn" CommandName="Basket" CommandArgument='<%#Container.DataItemIndex%>' Text="Add to Cart" Visible='<%# ((bool)Eval("Product.DisablePurchase") != true)%>' />
                                            <asp:LinkButton ID="DeleteItemButton" runat="server" CssClass="button remove-btn" CommandName="DeleteItem" CommandArgument='<%#Container.DataItemIndex%>' OnClientClick="return confirm('Are you sure you want to delete this item from your wishlist?')" Text="x"></asp:LinkButton>
                                        </div>
							        </ItemTemplate>
						        </asp:TemplateField>
                                <asp:TemplateField HeaderText="Price">
							        <HeaderStyle CssClass="price" />
							        <ItemStyle CssClass="price" />
							        <ItemTemplate>
								        <%# GetPrice(Container.DataItem) %>
							        </ItemTemplate>
						        </asp:TemplateField>
                                <asp:TemplateField HeaderText="Desired">
							        <HeaderStyle CssClass="quantity quantityDesired" />
							        <ItemStyle CssClass="quantity quantityDesired" />
							        <ItemTemplate>
								        <asp:TextBox ID="Desired" runat="server" Text='<%#Eval("Desired")%>' Width="60px"></asp:TextBox>
							        </ItemTemplate>
						        </asp:TemplateField>
                               <asp:TemplateField HeaderText="">
							        <HeaderStyle CssClass="filler" />
							        <ItemStyle CssClass="" />
							        <ItemTemplate></ItemTemplate>
						        </asp:TemplateField>
<%--                                <asp:TemplateField HeaderText="Received">
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
                                        <asp:DropDownList ID="Priority" runat="server" SelectedValue='<%#Eval("Priority")%>'>
                                            <asp:ListItem Value="4">highest</asp:ListItem>
                                            <asp:ListItem Value="3">high</asp:ListItem>
                                            <asp:ListItem Value="2">medium</asp:ListItem>
                                            <asp:ListItem Value="1">low</asp:ListItem>
                                            <asp:ListItem Value="0">lowest</asp:ListItem>
                                        </asp:DropDownList>
							        </ItemTemplate>
						        </asp:TemplateField>
                                <asp:TemplateField HeaderText="Comment">
							        <HeaderStyle CssClass="comment" />
							        <ItemStyle CssClass="comment" />
							        <ItemTemplate>
                                        <asp:TextBox ID="Comment" runat="server" Text='<%#Eval("Comment")%>' TextMode="MultiLine" Width="200px" Height="60px"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>--%>
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Localize ID="EmptyWishlistMessage" runat="server" Text="Your wishlist is empty."></asp:Localize>
                            </EmptyDataTemplate>
                        </cb:ExGridView>
                        <div class="actions">
                            <span class="clear-btn">
                                <asp:Button ID="ClearWishlistButton" runat="server" Text="Clear Wishlist" OnClientClick="return confirm('Are you sure you want to clear your wishlist?')" OnClick="ClearWishlistButton_Click"></asp:Button>
                            </span>
                            <asp:Button ID="KeepShoppingButton" runat="server" Text="KEEP SHOPPING" OnClick="KeepShoppingButton_Click"></asp:Button>
                            <asp:Button ID="UpdateButton" runat="server" Text="UPDATE" OnClick="UpdateButton_Click" OnClientClick="this.value='Updating...'"></asp:Button>
                            <asp:Button ID="EmailWishlistButton" runat="server" Text="EMAIL" OnClick="EmailWishlistButton_Click"></asp:Button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:Panel>
            <asp:Panel ID="LoggedInPanel" runat="server" Visible="false" CssClass="widget wishlistPasswordWidget">
                <div class="header">      
                    <h2>Wishlist Settings</h2>
                </div>
                <div class="content">
                    <p>
                        You can share your wishlist with others by providing them this link:
                        <br /><br />
                        <asp:HyperLink ID="WishlistLink" runat="server" EnableViewState="false" />
                    </p>
				    <p>For security purposes you can enter a password below. This will be required from anyone attempting to view your wishlist.</p>
                    <asp:UpdatePanel ID="SetPasswordAjax" runat="server">
                        <ContentTemplate>
                            <cb:Notification ID="WishlistPasswordUpdatedMessage" runat="server" Text="Your wishlist settings have been updated." SkinID="Success" Visible="false"></cb:Notification>
				            <table class="inputForm compact">
                                <tr>
                                    <th style="width:40px">Password:</th>
                                    <td>
                                        <asp:TextBox ID="WishlistPasswordValue" runat="server" Columns="5" Width="90px" onfocus="this.select()" MaxLength="30"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr id="trWishlistIsPublic" runat="server">
                                    <td colspan="2">
                                        <asp:CheckBox ID="WishlistIsPublic" runat="server" Checked="false" Text="Check here to make your wishlist public. This will allow other customers to find and view your wishlist by searching your name or email address." />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:Button ID="SaveButton" runat="server" Text="Update" OnClick="SaveButton_Click" OnClientClick="this.value='Updating...'"></asp:Button>
                                    </td>
                                </tr>
                            </table>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </asp:Panel>
            <asp:Panel ID="AnonymousPanel" runat="server" Visible="false" CssClass="widget wishlistRegisterWidget">
                <div class="header">      
                    <h2>Register Now!</h2>
                </div>
                <div class="content">
                    <p>To preserve your wishlist for future visits and for additional features you should <asp:HyperLink ID="RegisterLink" runat="server" NavigateUrl="~/Login.aspx" Text="login or register" CssClass="link"></asp:HyperLink> now.</p>
                </div>
            </asp:Panel>
	    </div>
    </div>
</asp:Content>