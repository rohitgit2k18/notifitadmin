<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.GiftWrapOptions" CodeFile="GiftWrapOptions.ascx.cs" %>
<%--
<conlib>
<summary>Displays gift wrapping options</summary>
<param name="GiftMessage">Possible value can be any string message. Any pre-initialized message for gift wraps that customer can modify.</param>
</conlib>
--%>
<asp:PlaceHolder ID="GiftWrapPanel" runat="server" EnableViewState="false">
    <div class="giftWrap">
        <%-- display this panel when only no gift wrap choice is available --%>
        <asp:PlaceHolder ID="NoGiftWrapPanel" runat="server" EnableViewState="false">
            <div class="noGiftWrap">
                <asp:Literal ID="NoGiftWrapMessage" runat="server" Text="Gift wrapping is not available for this item." EnableViewState="false"></asp:Literal>
            </div>
        </asp:PlaceHolder>
        <%-- display this panel when only one gift wrap choice is available --%>
        <asp:PlaceHolder ID="OneGiftWrapPanel" runat="server" EnableViewState="false">
            <div class="oneGiftWrap">
            <table cellpadding="2" cellspacing="0">
                <tr>
                    <td valign="top" align="center">
                    <asp:CheckBox ID="AddGiftWrap" runat="server" EnableViewState="false" />
                    <span class="name"><asp:Literal ID="AddGiftWrapLabel" runat="server" Text="{0}" EnableViewState="false"></asp:Literal></span>
                    <span class="price"><asp:Literal ID="AddGiftWrapPrice" runat="server" Text=" ({0})" EnableViewState="false"></asp:Literal></span>
                    </td>
                </tr>
                <tr id="trGiftWrapImage" runat="server">
                    <td valign="top" align="center">
                        <span>
                            <asp:Literal ID="AddGiftWrapHtml" runat="server" Text="{0}" EnableViewState="false"></asp:Literal>
                            <asp:HyperLink ID="OneGiftWrapThumbnailLink" runat="server" NavigateUrl="#">
                                <asp:Image ID="OneGiftWrapThumbnail" runat="server" />
                            </asp:HyperLink>
                        </span>
                    </td>
                </tr>
            </table>
            <asp:HiddenField ID="AddGiftWrapStyleId" runat="server" EnableViewState="false" />
            </div>
        </asp:PlaceHolder>
        <%-- display this panel when more than one gift wrap choice is available --%>
        <asp:PlaceHolder ID="MultiGiftWrapPanel" runat="server" EnableViewState="false">
            <div class="multiGiftWrap">
                <span class="title"><asp:Literal ID="GiftWrapCaption" runat="server" Text="Gift Wrap: " EnableViewState="false"></asp:Literal></span>
                <div>
                    <input type="radio" name='<%=this.UniqueID %>_Wrap<%=this.BasketItemId %>' value="0" checked='<%#GetCheckedStatus(0) %>' />
                    <asp:Localize ID="NoneWrapStyleLocalize" runat="server" Text="None"></asp:Localize>
                </div>
                <asp:Repeater ID="WrapStyleRepeater" runat="server" OnItemCreated="WrapStyleRepeater_ItemCreated">
                    <ItemTemplate>
                        <div class="wrapStyle">
                            <div class="details">
                                <input type="radio" name='<%=this.UniqueID %>_Wrap<%=this.BasketItemId %>' value='<%#Eval("Id") %>' checked='<%#GetCheckedStatus((int)Eval("Id")) %>' />
                                <span><%#GetStyleName(Container.DataItem) %></span>
                            </div>
                            <div class="thumbnail">
                                <asp:HyperLink ID="WrapStyleImageLink" runat="server" NavigateUrl="#" Visible='<%#HasThumbnail(Container.DataItem) %>'>
                                    <asp:Image ID="WrapStyleImage" runat="server" ImageUrl='<%#Eval("ThumbnailUrl") %>' AlternateText='<%#GetStyleName(Container.DataItem) %>' Visible='<%#HasThumbnail(Container.DataItem) %>' />
                                </asp:HyperLink>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:PlaceHolder ID="phWrapStyle" runat="server"></asp:PlaceHolder>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:PlaceHolder>
<asp:PlaceHolder ID="GiftMessagePanel" runat="server" EnableViewState="false">
    <span class="title"><asp:Literal ID="GiftMessageCaption" runat="server" Text="Gift Message" EnableViewState="false"></asp:Literal></span>
    <span class="price"><asp:Literal ID="GiftMessagePriceLabel" runat="server" Text="(no additional fee)" EnableViewState="false"></asp:Literal></span><br />
    <asp:TextBox ID="GiftMessageText" runat="server" TextMode="MultiLine" Wrap="True" MaxLength="100" EnableViewState="false" Width="400px" Height="60px"></asp:TextBox><br />
    <asp:Label ID="GiftMessageCharCount" runat="server" Text="100" EnableViewState="false" CssClass="count"></asp:Label>
    <span class="countText"><asp:Literal ID="GiftMessageCharCountLabel" runat="server" Text="characters remaining" EnableViewState="false"></asp:Literal></span>
</asp:PlaceHolder>