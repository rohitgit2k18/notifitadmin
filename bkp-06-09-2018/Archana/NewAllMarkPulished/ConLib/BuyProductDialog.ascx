<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.BuyProductDialog" CodeFile="BuyProductDialog.ascx.cs" %>
<%--
<conlib>
<summary>Displays product basic details and add-to-cart button to allow the produt to be added to cart.</summary>
<param name="ShowSku" default="True">If true SKU is displayed</param>
<param name="ShowPrice" default="True">If true price is displayed</param>
<param name="ShowSubscription" default="True">If true subscription details are displayed</param>
<param name="ShowMSRP" default="True">If true MRSP is displayed</param>
<param name="ShowPartNumber" default="False">If true Part/Model number is displayed</param>
<param name="ShowAllOptions" default="False">If true all product options are displayed</param>
<param name="IgnoreInventory" default="False">If true inventory is ignored</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<%@ Register Src="~/ConLib/Utility/SocialMediaLinks.ascx" TagName="SocialMediaLinks" TagPrefix="uc2" %>

<script type="text/javascript">
    function OptionSelectionChanged(dropDownId)
    {
        var optDropDown = document.getElementById(dropDownId);        
		if(optDropDown != undefined)
		{
			var opt_index  = optDropDown.selectedIndex;
			var optid = optDropDown.options[opt_index].value;

			var images = eval(dropDownId + '_Images');
			var pImage = document.getElementById('ProductImage');

			// determine the resized and large image url's and update
            if (pImage != undefined) 
            {
                if ((images != undefined) && (images[optid] != undefined)) pImage.src = images[optid];
                // image will be force updated to the default image when swatch image is absent
                else if (_DefaultImageUrl != undefined) pImage.src = _DefaultImageUrl;

                // update the large image url used by fancybox, so it show correct image for selected option choice
                var pathRegexp = /.*GetImage\.ashx\?Path=(~|%7e)(.*?)&.*/im;
                match = pathRegexp.exec(pImage.src);
                if (match != null) {
                    var pImageUrl = document.getElementById('ProductImageUrl');
                    if (pImageUrl != undefined) {
                        pImageUrl.href = match[2];
                    }
                }
            }
		}
        return true;
    }

    //Show Message When Adding To cart
    function DisplayToastMessage() {
        // Get the DIV
        var x = $('#<%= ToastMessage.ClientID %>');

        // Add the "show" class to DIV
        x.addClass('show');

        // After 3 seconds, remove the show class from DIV
        setTimeout(function () { x.removeClass('show'); }, 3000);
    }

    // CLEAR CACHED __EVENTTARGET AND __EVENTARGUMENT VALUES UPON DOM READY
    $(function () {
        var addToCartExp = new RegExp('\\$AddToCart_([0-9]+)$');
        var eventtarget = $('#__EVENTTARGET').val();
        if (addToCartExp.test(eventtarget)) {
            $('#__EVENTTARGET').val('');
            $('#__EVENTARGUMENT').val('');
        }
    });
</script>
<asp:LinkButton ID="AddToWishlistButton" runat="server" Visible="true" OnClick="AddToWishlistButton_Click" EnableViewState="false" ValidationGroup="AddToBasket">
    <span class="glyphicon glyphicon-heart"></span>
</asp:LinkButton>
<div class="buyProductDialog">
    <asp:UpdatePanel ID="BuyProductPanel" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <asp:Panel ID="BuyProudctPanel" runat="server" DefaultButton="AddToBasketButton" CssClass="innerSection">
		    <div class="content">		
            <table class="buyProductForm">                
                <tr id="trSku" runat="server" enableviewstate="false">
                    <td>
                        <div class="product-option"><asp:Localize ID="SkuLocalize" runat="server" Text="Item #" EnableViewState="false"></asp:Localize></div>
                        <span itemprop="sku"><asp:Literal ID="Sku" runat="server"></asp:Literal></span>
                    </td>
                </tr>
                <tr id="trPartNumber" runat="server" enableviewstate="false">
                    <td>
                        <div class="product-option"><asp:Localize ID="PartNumberLocalize" runat="server" Text="Part #" EnableViewState="false"></asp:Localize></div>
                        <span itemprop="mpn"><asp:Literal ID="PartNumber" runat="server"></asp:Literal></span>
                    </td>
                </tr>
                <tr id="trGTINNumber" runat="server" enableviewstate="false">
                    <td>
                        <div class="product-option"><asp:Localize ID="GTINNumberLocalize" runat="server" Text="{0}" EnableViewState="false"></asp:Localize></div>
                        <asp:PlaceHolder ID="GTINNumber" runat="server" />
                    </td>
                </tr>
                <tr id="trRegPrice" runat="server" enableviewstate="false">
                    <td>
                        <div class="product-option"><asp:Localize ID="RegPriceLocalize" runat="server" Text="Reg. Price" EnableViewState="false"></asp:Localize></div>
                        <asp:Label ID="RegPrice" runat="server" SkinID="MSRP" EnableViewState="false"></asp:Label>
                    </td>
                </tr>
                <tr id="trOurPrice" runat="server" EnableViewState="false" class="priceLabel">
                    <td>
                        <div class="product-option"><asp:Localize Visible='<%#trOurPrice.Visible%>' ID="OurPriceLocalize" runat="server" Text="Our Price" EnableViewState="false"></asp:Localize></div>
                        <span itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                            <uc:ProductPrice ID="OurPrice" runat="server" EnableDefaultKitProducts="false" ShowQuoteOnZeroPrice="true" HideZeroPrice="false" IncludeRichSnippetsWraper="True" />
                            <meta itemprop="availability" content="<%=ProductAvailabilityStatus%>" />
                        </span>
                    </td>
                </tr>
                <tr id="trVariablePrice" runat="server" enableviewstate="false">
                    <td>
                        <div class="product-option"><asp:Localize ID="VariablePriceLabel" runat="server" Text="Enter Price" EnableViewState="false"></asp:Localize></div>
                        <asp:TextBox ID="VariablePrice" runat="server" MaxLength="8" Width="80px" ValidationGroup="AddToBasket"></asp:TextBox>
                        <asp:PlaceHolder ID="phVariablePrice" runat="server"></asp:PlaceHolder>
                    </td>
                </tr>
                <tr id="rowSubscription" runat="server" enableviewstate="false" Visible="false" class="subscriptionRow">
                    <td>
                        <div class="product-option"><asp:Localize ID="OurSubscriptionPriceLabel" runat="server" Text="Our Price" EnableViewState="false"></asp:Localize></div>
                        <asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal>
                        <asp:Panel ID="OptionalSubscriptionPanel" runat="server" Width="210" CssClass="optionalSubscriptionPanel">
                            &nbsp;&nbsp;<asp:RadioButton ID="OneTimeDeliveryRadio" runat="server" Text="One-time delivery" GroupName="OptionalDelivery" AutoPostBack="true" />
                                 (<span itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                                    <uc:ProductPrice ID="OneTimePrice" runat="server" EnableDefaultKitProducts="false" HideZeroPrice="false" IncludeRichSnippetsWraper="True" CalculateOneTimePrice="True" />
                                </span>)
                            <br/><asp:RadioButton ID="AutoDeliveryRadio" runat="server" Text="Subscribe" GroupName="OptionalDelivery" AutoPostBack="true" Checked="true" />
                                    (<span itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                                        <uc:ProductPrice ID="SubscriptionPrice" runat="server" EnableDefaultKitProducts="false" HideZeroPrice="false" IncludeRichSnippetsWraper="True" />
                                    </span>)
                                    <p><asp:Literal ID="OptionalRecurringPaymentMessage" runat="server"></asp:Literal></p>
                        </asp:Panel>
                        <asp:PlaceHolder ID="AutoDeliveryOptionPH" runat="server">
                            <blockquote style="white-space:nowrap">
                                <asp:Literal ID="AutoDeliveryOptionText1" runat="server" EnableViewState="false" Text="Delivery every " />
                                <asp:DropDownList ID="AutoDeliveryInterval" runat="server" AutoPostBack="true"></asp:DropDownList>
                            </blockquote>
                        </asp:PlaceHolder>
                    </td>
                 </tr>
			    <asp:Repeater ID="OptionsList" runat="server">
			      <ItemTemplate>
				    <tr>
					    <td runat="server" Visible='<%#!((ProductOption)Container.DataItem).Option.ShowThumbnails%>'>
                            <div class="product-option"><%#GetOptionName(Container.DataItem)%></div>
						    <asp:DropDownList ID="OptionChoices" runat="server" DataTextField="ChoiceName" DataValueField="ChoiceId" AutoPostBack="true" DataSource='<%#GetOptionChoices(Container.DataItem, Container.ItemIndex)%>' EnableViewState="true" OnDataBinding="OptionChoices_DataBinding" OnDataBound="OptionChoices_DataBound" AppendDataBoundItems="true" ></asp:DropDownList>
						    <asp:RequiredFieldValidator ID="OptionRequiredValidator" runat="server" ControlToValidate="OptionChoices" Text="*" ValidationGroup="AddToBasket" ErrorMessage='<%#string.Format("Please make your selection for {0}.", GetOptionName(Container.DataItem))%>' />
						    <asp:HiddenField ID="OptionID" runat="server" Value='<%#Eval("OptionId")%>' />
					    </td>
					    <td runat="server" Visible='<%#((ProductOption)Container.DataItem).Option.ShowThumbnails%>'>
						    <cb:OptionPicker ID="OptionPicker" runat="server" CssClass="optionPicker" AutoPostBack="true" OptionId='<%#Eval("OptionId")%>'  ForceToLoadAllChoices='<%#ShowAllOptions%>' SelectedChoices='<%#_SelectedOptionChoices%>' OnLoad="OptionPicker_Load" RetainLargerImageAspectRatio="true" LargerImageMaxHeight="300" LargerImageMaxWidth="300" />
						    <cb:OptionPickerValidator ID="OptionPickerValidator" runat="server" ControlToValidate="OptionPicker"  Text="*" ValidationGroup="AddToBasket" ErrorMessage='<%#string.Format("Please make your selection for {0}.", GetOptionName(Container.DataItem))%>' />
					    </td>
				    </tr>
			      </ItemTemplate>
			    </asp:Repeater>

			    <asp:Repeater ID="TemplatesList" runat="server" OnItemDataBound="TemplatesList_ItemDataBound">
			      <ItemTemplate>
				    <tr>
					    <td runat="server">
                            <div class="product-option"><%#GetUserPrompt(Container.DataItem)%></div>
						    <asp:PlaceHolder runat="server" ID="phControl" />
					    </td>
				    </tr>
			      </ItemTemplate>
			    </asp:Repeater>
			
			    <asp:Repeater ID="KitsList" runat="server" OnItemDataBound="KitsList_ItemDataBound">
                    <ItemTemplate>
                        <tr id="Tr1" runat="server" Visible='<%#((ProductKitComponent)Container.DataItem).KitComponent.InputType != KitInputType.IncludedHidden%>'>
                            <td id="Td1" runat="server">
                                <div class="product-option"><%#GetKitComponentName(Container.DataItem)%></div>
                                <asp:PlaceHolder runat="server" ID="phControl" />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>


			    <asp:PlaceHolder ID="phAddToBasketWarningOpt" runat="server" EnableViewState="false" Visible="false">
			    <tr>
				    <td>&nbsp;</td>
                    <td colspan="8">          
                        <asp:Label ID="AddToBasketWarningOpt" runat="server" EnableViewState="false"  SkinID="ErrorCondition" Text="Please make your selections above."></asp:Label>
                    </td>
                </tr>
			    </asp:PlaceHolder>
			    <asp:PlaceHolder runat="server" id="phKitOptions" EnableViewState="false"></asp:PlaceHolder>
			    <asp:PlaceHolder ID="phAddToBasketWarningKit" runat="server" EnableViewState="false" Visible="false">
			    <tr>
				    <td>&nbsp;</td>
                    <td colspan="8">          
                        <asp:Label ID="AddToBasketWarningKit" runat="server" EnableViewState="false"  SkinID="ErrorCondition" Text="Please make your selections above."></asp:Label>
                    </td>
                </tr>
			    </asp:PlaceHolder>
                <tr id="rowQuantity" runat="server" enableviewstate="false">
                    <td nowrap="nowrap">
                        <div class="product-option"><asp:Localize ID="QuantityLocalize" runat="server" Text="QUANTITY"></asp:Localize></div>
                        <div class="quantity-wrapper">
                            <cb:updowncontrol Width="30" ID="Quantity" runat="server" CssClass="quantityUpDown" onfocus="this.select()"></cb:updowncontrol><asp:CustomValidator ID="QuantityValidaor" runat="server" ValidationGroup="AddToBasket" ErrorMessage="Quantity can not exceed the available stock of {0}." ControlToValidate="Quantity">*</asp:CustomValidator>
                            <asp:PlaceHolder ID="QuantityLimitsPanel" runat="server" EnableViewState="false"></asp:PlaceHolder>
                            <span class="add-update-btn">
                                <asp:Button ID="AddToBasketButton" runat="server" Visible="true" OnClick="AddToBasketButton_Click" Text="ADD TO CART" EnableViewState="false" ValidationGroup="AddToBasket" CssClass="cart-btn"></asp:Button>
                                <asp:Button ID="UpdateBasketButton" runat="server" Visible="false" OnClick="UpdateBasketButton_Click" Text="UPDATE" EnableViewState="false"></asp:Button>
                                <asp:Label ID="ToastMessage" CssClass="toastMessage" runat="server"></asp:Label>
                            </span>
                        </div>
                        <div>
                            <uc2:SocialMediaLinks ID="SocialMediaLinks1" runat="server" />
                        </div>
                        <div>
                            <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="AddToBasket" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:PlaceHolder ID="InventoryDetailsPanel" runat="server" EnableViewState="false"></asp:PlaceHolder>                        
                    </td>
                </tr>
                <tr>
                    <asp:PlaceHolder ID="InventoryRestockNotificationsPanel" runat="server" Visible="false">
                    <td>
                        <div class="product-option"><asp:Localize ID="UserEmailLabel" runat="server" Text="Email" EnableViewState="false" Visible="false"></asp:Localize></div>                      
                        <asp:LinkButton ID="NotificationsLink" runat="server" EnableViewState="false" OnClick="NotificationsLink_Click"></asp:LinkButton>
                            
                        <asp:TextBox ID="UserEmail" runat="server" CssClass="notify" MaxLength="200" Width="170" ValidationGroup="RestockNotify"></asp:TextBox>&nbsp;                            
                        <asp:Button ID="NotifySubscribeButton" runat="server" Text="Notify" ValidationGroup="RestockNotify" OnClick="NotifySubscribeButton_Click"/>
                        <cb:EmailAddressValidator ID="UserEmailValidator" runat="server" ControlToValidate="UserEmail" Display="Dynamic" Required="true" 
                            ErrorMessage="Email address should be in the format of name@domain.tld." Text="Email address should be in the format of name@domain.tld." ValidationGroup="RestockNotify" EnableViewState="False"></cb:EmailAddressValidator>                        
                    </td>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="RestockNotificationSubscribedMessagePanel" runat="server" EnableViewState="false" Visible="false">
                        <td></td>
                        <td>
                            <asp:Label ID="SubscribedMessage" runat="server" Text="Restock notification will be sent to '{0}'." EnableViewState="false"></asp:Label>
                        </td>
                    </asp:PlaceHolder>
                </tr>
            </table>	
		    </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>