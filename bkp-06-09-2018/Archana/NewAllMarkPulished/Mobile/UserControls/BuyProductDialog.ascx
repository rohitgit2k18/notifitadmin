<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BuyProductDialog.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.BuyProductDialog" %>
<%--
<UserControls>
<summary>Displays product details and buy now button to add it to cart.</summary>
<param name="ShowSku" default="true">Possible values are true or false.  Indicates whether the SKU will be shown or not.</param>
<param name="ShowPrice" default="true">Possible values are true or false.  Indicates whether the price details will be shown or not.</param>
<param name="ShowSubscription" default="true">Possible values are true or false.  Indicates whether the subscription details will be shown or not.</param>
<param name="ShowMSRP" default="true">Possible values are true or false.  Indicates whether the MSPR will be shown or not.</param>
<param name="ShowPartNumber" default="false">Possible values are true or false.  Indicates whether the Part/Model Number will be shown or not.</param>
</UserControls>
--%>
<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>

<script type="text/javascript">
    function OptionSelectionChanged(dropDownId) {
        var optDropDown = document.getElementById(dropDownId);
        if (optDropDown != undefined) {
            var opt_index = optDropDown.selectedIndex;
            var optid = optDropDown.options[opt_index].value;
            var images = eval(dropDownId + '_Images');
            var pImage = document.getElementById('ProductImage');
            if ((images != undefined) && (images[optid] != undefined)) {
                if (pImage != undefined) pImage.src = images[optid];
            } 
            else if (_imageUrl != undefined && pImage != undefined) pImage.src = _imageUrl;
        }
        return true;
    }
</script>

<div class="buyProductDialog">
    <asp:UpdatePanel ID="BuyProductPanel" runat="server" UpdateMode="Always">       
        <ContentTemplate>
            <asp:Panel ID="BuyProudctPanel" runat="server" DefaultButton="AddToBasketButton">
		    <div class="content">
            <div class="inputForm">
                <div class="infoFields">
                    <div class="field" id="trSku" runat="server" enableviewstate="false">
                        <span class="fieldHeaderInline">
                           <asp:Localize ID="SkuLocalize" runat="server" Text="Item #:" EnableViewState="false"></asp:Localize>
                        </span>
                        <span class="fieldValueInline">
                            <asp:Literal ID="Sku" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="field" id="trPartNumber" runat="server" enableviewstate="false">
                        <span class="fieldHeaderInline">
                            <asp:Localize ID="PartNumberLocalize" runat="server" Text="Part #:" EnableViewState="false"></asp:Localize>
                        </span>
                        <span class="fieldValueInline">
                            <asp:Literal ID="PartNumber" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="field" id="trRegPrice" runat="server" enableviewstate="false">
                        <span class="fieldHeaderInline regPriceLbl">
                            <asp:Localize ID="RegPriceLocalize" runat="server" Text="Reg. Price:" EnableViewState="false"></asp:Localize>
                        </span> 
                        <div class="fieldValueInline regPriceVal">
                            <asp:Label ID="RegPrice" runat="server" SkinID="MSRP" EnableViewState="false" CssClass="fieldHeader"></asp:Label>
                        </div>
                    </div>
                    <div class="field" id="trOurPrice" runat="server" EnableViewState="false">
                        <span class="fieldHeaderInline ourPriceLbl">
                            <asp:Localize ID="OurPriceLocalize" runat="server" Text="Our Price:" EnableViewState="false"></asp:Localize>
                        </span>        
                        <span class="fieldValueInline ourPriceVal">
                            <uc:ProductPrice ID="OurPrice" runat="server" EnableDefaultKitProducts="false" HideZeroPrice="false" />                    
                        </span>
                    </div>
                </div>
			
			    <div class="inputFields">
                    <asp:Repeater ID="OptionsList" runat="server">
			          <ItemTemplate>
				        <div class="field">
                            <span class="fieldHeader">
						         <%#GetOptionName(Container.DataItem)%>
                            </span>
					        <span class="fieldValue" id="Td1" runat="server" Visible='<%#!((ProductOption)Container.DataItem).Option.ShowThumbnails%>' >
						        <asp:DropDownList ID="OptionChoices" runat="server" DataTextField="ChoiceName" DataValueField="ChoiceId" AutoPostBack="true" DataSource='<%#GetOptionChoices(Container.DataItem, Container.ItemIndex)%>' EnableViewState="true"  OnDataBound="OptionChoices_DataBound" ClientIDMode="AutoID" ></asp:DropDownList><span class="requiredField">(R)</span>
						        <asp:RequiredFieldValidator ID="BPDOptionRequiredValidator1" runat="server" ControlToValidate="OptionChoices" Text="*" ValidationGroup="AddToBasket" ErrorMessage='<%#string.Format("Please make your selection for {0}.", GetOptionName(Container.DataItem))%>' ClientIDMode="Predictable"/>
                                <asp:HiddenField ID="OptionID" runat="server" Value='<%#Eval("OptionId")%>' />
					        </span>
					        <span class="fieldValue" id="Td2" runat="server" Visible='<%#((ProductOption)Container.DataItem).Option.ShowThumbnails%>'>
						        <cb:OptionPicker ID="OptionPicker" runat="server" CssClass="optionPicker" AutoPostBack="true" OptionId='<%#Eval("OptionId")%>' ForceToLoadAllChoices='<%#ShowAllOptions%>' SelectedChoices='<%#_SelectedOptionChoices%>' OnLoad="OptionPicker_Load" ClientIDMode="AutoID" />
						        <cb:OptionPickerValidator ID="OptionPickerValidator" runat="server" ControlToValidate="OptionPicker"  Text="*" ValidationGroup="AddToBasket" ErrorMessage='<%#string.Format("Please make your selection for {0}.", GetOptionName(Container.DataItem))%>' CssClass="inline" />
					        </span>
				        </div>
			          </ItemTemplate>
			        </asp:Repeater>

			        <asp:Repeater ID="TemplatesList" runat="server" OnItemDataBound="TemplatesList_ItemDataBound">
			          <ItemTemplate>
				        <div class="field">
						    <span class="fieldHeader">
                              <%#GetUserPrompt(Container.DataItem)%>
                            </span>
					        <span class="fieldValue" id="Td3" runat="server">
						          <asp:PlaceHolder runat="server" ID="phControl" />
					        </span>
                        </div>
			          </ItemTemplate>
			        </asp:Repeater>

			        <asp:Repeater ID="KitsList" runat="server" OnItemDataBound="KitsList_ItemDataBound">
                        <ItemTemplate>
                            <div class="field" id="Tr1" runat="server" Visible='<%#((ProductKitComponent)Container.DataItem).KitComponent.InputType != KitInputType.IncludedHidden%>'>
                                <span class="fieldHeader">
                                 <%#GetKitComponentName(Container.DataItem)%>
                                </span>
                                <span class="fieldValue" id="Td1" runat="server">
                                    <asp:PlaceHolder runat="server" ID="phControl" />
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                                
                   <div class="field" id="trVariablePrice" runat="server" enableviewstate="false">
                        <span class="fieldHeader">
                            <asp:Localize ID="VariablePriceLabel" runat="server" Text="Enter Price:" EnableViewState="false"></asp:Localize>
                        </span>
                        <span class="fieldValue">
                            <asp:TextBox ID="VariablePrice" runat="server" MaxLength="8" Width="60px" ValidationGroup="AddToBasket"></asp:TextBox>
                            <asp:PlaceHolder ID="phVariablePrice" runat="server"></asp:PlaceHolder>
                        </span>
                    </div>
                    <div id="rowSubscription" runat="server" enableviewstate="false" Visible="false">
                        <span class="fieldHeader">
                            <asp:Localize ID="OurSubscriptionPriceLabel" runat="server" Text="Our Price:" EnableViewState="false"></asp:Localize>        
                        </span>
                        <span class="fieldValue">
                            <asp:Literal ID="RecurringPaymentMessage" runat="server"></asp:Literal>
                            <asp:Panel ID="OptionalSubscriptionPanel" runat="server" Width="210">
                                <asp:RadioButton ID="OneTimeDeliveryRadio" runat="server" Text="One-time delivery" GroupName="OptionalDelivery" AutoPostBack="true" />
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
                                <%--<blockquote style="white-space:nowrap">--%>
                                    <asp:Literal ID="AutoDeliveryOptionText1" runat="server" EnableViewState="false" Text="Delivery every " />
                                    <asp:DropDownList ID="AutoDeliveryInterval" runat="server" AutoPostBack="true"></asp:DropDownList>
                                <%--</blockquote>--%>
                            </asp:PlaceHolder>
                        </span>
                    </div>
                    <div class="field" id="rowQuantity" runat="server" enableviewstate="false">
                        <span class="fieldHeaderInline qtyLbl">
                            <asp:Localize ID="QuantityLocalize" runat="server" Text="Qty:"></asp:Localize>
                        </span>        
                        <span class="fieldValueInline">
                            <asp:TextBox Width="30" ID="Quantity" runat="server" CssClass="quantityInput" Text="1" ValidationGroup="AddToBasket"></asp:TextBox>
                            <asp:PlaceHolder ID="QuantityLimitsPanel" runat="server" EnableViewState="false"></asp:PlaceHolder>
                            <asp:CustomValidator ID="QuantityValidaor" runat="server" ValidationGroup="AddToBasket" ErrorMessage="Quantity can not exceed the available stock of {0}." ControlToValidate="Quantity">*</asp:CustomValidator>
                        </span>
                    </div>
                </div>
                
                <asp:PlaceHolder ID="InventoryDetailsPanel" runat="server" EnableViewState="false"></asp:PlaceHolder>

			    <asp:PlaceHolder ID="phAddToBasketWarningOpt" runat="server" EnableViewState="false" Visible="false">
                    <asp:Label ID="AddToBasketWarningOpt" runat="server" CssClass="fieldHeader" EnableViewState="false"  SkinID="ErrorCondition" Text="Please make your selections above."></asp:Label>
			    </asp:PlaceHolder>
                			    
                <asp:PlaceHolder ID="phAddToBasketWarningKit" runat="server" EnableViewState="false" Visible="false">			    
                    <asp:Label ID="AddToBasketWarningKit" runat="server" EnableViewState="false" CssClass="fieldHeader"  SkinID="ErrorCondition" Text="Please make your selections above."></asp:Label>
			    </asp:PlaceHolder>                

                <div class="validationSummary">
                    <asp:ValidationSummary ID="ValidationSummary" runat="server" ValidationGroup="AddToBasket" />
                </div>

                <div class="actions">					
                    <asp:Button ID="AddToBasketButton" runat="server" Visible="true" OnClick="AddToBasketButton_Click" Text="+ Add to Cart" EnableViewState="false" ValidationGroup="AddToBasket" CssClass="button"></asp:Button>
                    <asp:Button ID="UpdateBasketButton" runat="server" Visible="false" OnClick="UpdateBasketButton_Click" Text="Update Cart" EnableViewState="false"></asp:Button>
                    <asp:Button ID="AddToWishlistButton" runat="server" Visible="true" OnClick="AddToWishlistButton_Click" Text="Add to Wishlist" EnableViewState="false" ValidationGroup="AddToBasket" CssClass="button"></asp:Button>
                </div>

            </div>
		    </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>