<%@ Page Title="Quote Items" Language="C#" MasterPageFile="~/Layouts/Fixed/OneColumn.Master" AutoEventWireup="True" CodeFile="Quote.aspx.cs" Inherits="AbleCommerce.BasketPage" %>
<%@ Register Src="~/ConLib/Utility/BasketItemDetail.ascx" TagName="BasketItemDetail" TagPrefix="uc" %>

<asp:Content ID="PageContent" ContentPlaceHolderID="PageContent" Runat="Server">
<div id="basketPage" class="mainContentWrapper">
	<div class="pageHeader">
		<h1>QUOTE REQUEST</h1>
	</div>
    <div class="section">
        <asp:UpdatePanel ID="AjaxContactPanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Panel ID="ContactFormPanel" runat="server" CssClass="ContactFormPanel">
                    <div id="contactPage" class="row">
                        <div class="col-xs-12  contact-col">
                            <div class="col-md-12">
                                <h2>Enquiry Form</h2>
                                <div>
                                    If you need any assistance with the online quote process, or would rather place your order by phone, please give us a call during regular business hours.
                                </div>
                            </div>
                            <table class="inputForm">
                                <tr>
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td class="col-md-12">
                                        <div class="col-md-6 nopadding">
                                            <asp:TextBox ID="FirstName" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="First Name"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="FirstNameRequired" runat="server" ControlToValidate="FirstName" Display="Dynamic" Required="true" 
                                                ErrorMessage="First name is required" Text="*" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-md-6 nopadding">
                                            <asp:TextBox ID="LastName" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Last Name"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="LastNameRequired" runat="server" ControlToValidate="LastName" Display="Dynamic" Required="true" 
                                                ErrorMessage="Last name is required" Text="*" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col-md-12">
                                        <asp:TextBox ID="Company" runat="server" ValidationGroup="ContactUs" CssClass="form-control" placeholder="Company (optional)"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col-md-12">
                                        <div class="col-md-6 nopadding">
                                            <asp:TextBox ID="Email" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Email"></asp:TextBox>
                                            <cb:EmailAddressValidator ID="EmailAddressValid" runat="server" ControlToValidate="Email" Display="Dynamic" Required="true" 
                                                ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" ValidationGroup="ContactUs"></cb:EmailAddressValidator>
                                        </div>
                                        <div class="col-md-6 nopadding">
                                            <asp:TextBox ID="Phone" runat="server" CssClass="form-control contact-field" ValidationGroup="ContactUs" placeholder="Phone Number"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PhoneRequired" runat="server" ControlToValidate="Phone"
                                                ErrorMessage="Phone is Required" ValidationGroup="ContactUs">*</asp:RequiredFieldValidator>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="col-md-12">
                                       <asp:TextBox ID="Comments" runat="server" Height="170px" TextMode="MultiLine" CssClass="form-control"
                                            ValidationGroup="ContactUs" placeholder="Comment"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="CommentsValidator" runat="server" ControlToValidate="Comments"
                                            ErrorMessage="Message is required" ToolTip="Message is required" Display="Dynamic"
                                            Text="*" EnableViewState="False" ValidationGroup="ContactUs"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Panel ID="CaptchaPanel" runat="server">
                                            <table class="inputForm">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox ID="CaptchaInput" runat="server" CssClass="form-control" EnableViewState="False"
                                                            ValidationGroup="ContactUs"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="CaptchaRequired" runat="server" ControlToValidate="CaptchaInput"
                                                            ErrorMessage="You must enter the verification number" ToolTip="You must enter the number in the image."
                                                            Display="Dynamic" Text="*" EnableViewState="False" ValidationGroup="ContactUs"></asp:RequiredFieldValidator><br />
                                                        <asp:PlaceHolder ID="phCaptchaValidators" runat="server" EnableViewState="false"></asp:PlaceHolder>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:PlaceHolder ID="trCaptchaImage" runat="server">
                                                            <div align="center">
                                                                <div align="left" style="width: 300px">
                                                                    <asp:Label ID="CaptchaImageLabel" runat="server" Text="Verification Number:" AssociatedControlID="CaptchaImage"
                                                                        SkinID="FieldHeader" CssClass="rowHeader" EnableViewState="False"></asp:Label><br />
                                                                    <cb:CaptchaImage ID="CaptchaImage" runat="server" Height="70px" Width="250px" EnableViewState="False" /><br />
                                                                    <asp:LinkButton ID="ChangeImageLink" runat="server" Text="different image" CausesValidation="false"
                                                                        OnClick="ChangeImageLink_Click" EnableViewState="False"></asp:LinkButton><br />
                                                                </div>
                                                            </div>
                                                        </asp:PlaceHolder>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <script type="text/javascript">
                                            //File Upload response from the server
                                            //File Upload response from the server
                                            Dropzone.options.dropzoneForm = {
                                                maxFiles: null,
                                                maxFilesize: 9, // MB
                                                url: "Quote.aspx",
                                                init: function () {
                                                    this.on("maxfilesexceeded", function (data) {
                                                        var res = eval('(' + data.xhr.responseText + ')');
                                                    });
                                                    this.on("addedfile", function (file) {
                                                        // Create the remove button
                                                        var removeButton = Dropzone.createElement("<button>Remove file</button>");
                                                        // Capture the Dropzone instance as closure.
                                                        var _this = this;
                                                        // Listen to the click event
                                                        removeButton.addEventListener("click", function (e) {
                                                            // Make sure the button click doesn't submit the form:
                                                            e.preventDefault();
                                                            e.stopPropagation();
                                                            // Remove the file preview.
                                                            _this.removeFile(file);
                                                            // If you want to the delete the file on the server as well,
                                                            // you can do the AJAX request here.
                                                            $.ajax({
                                                                type: "POST",
                                                                url: "Quote.aspx/RemoveFile",
                                                                data: JSON.stringify({ 'name': file.name }),
                                                                contentType: "application/json; charset=utf-8",
                                                                dataType: "json",
                                                                success: function (msg) {
                                                                }
                                                            });
                                                        });
                                                        // Add the button to the file preview element.
                                                        file.previewElement.appendChild(removeButton);
                                                    });
                                                }
                                            };
   
                                        </script>
                                        Max Fileupload size: 9mb
                                        <div  class="dropzone" id="dropzoneForm">
                                            <div class="fallback">
                                                <input name="file" type="file" multiple />
                                                <input type="submit" value="Upload" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="Submit" runat="server" Text="SEND QUOTE" OnClick="Submit_Click" ValidationGroup="ContactUs"  CssClass="checkoutbutton"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ValidationSummary ID="ContactValidationSummary" runat="server" EnableViewState="false"
                                            ValidationGroup="ContactUs" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </asp:Panel>
                <asp:Panel runat="server" ID="MessagePanel" Visible="false" CssClass="confirmationMessageStatus">
                    <asp:Label runat="server" ID="SuccessMessage" CssClass="goodCondition" Text="Thank you. Your enquiry has been submitted.<br />We will process your request as quickly as possible. If you require prices urgently, please contact our team to speed up your quote request."></asp:Label>
                    <asp:Label runat="server" ID="FailureMessage" CssClass="errorCondition" Text="We are experiencing some problems at this time and can not process your request. Please try again later after some time."></asp:Label>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
	<div class="section">
		<div class="content">
			<asp:UpdatePanel ID="BasketPanel" runat="server" UpdateMode="Always">
				<ContentTemplate>
					<div class="warnings">
					    <asp:Repeater ID="OrderVolumeAmountMessageList" runat="server" EnableViewState="false">
                            <HeaderTemplate><ul></HeaderTemplate>
						    <ItemTemplate><li class="errorCondition"><%# Container.DataItem %></li></ItemTemplate>
					    </asp:Repeater>
                        <asp:Repeater ID="WarningMessageList" runat="server" EnableViewState="false">
						    <HeaderTemplate><ul></HeaderTemplate>
						    <ItemTemplate><li class="errorCondition"><%# Container.DataItem %></li></ItemTemplate>
					    </asp:Repeater>
					</div>
					<asp:Panel ID="BasketGridPanel" runat="server" DefaultButton="UpdateButton" CssClass="basketContainer">
						<div class="basketItems">
						    <cb:ExGridView ID="BasketGrid" runat="server" AutoGenerateColumns="False" ShowFooter="True" DataKeyNames="BasketItemId" OnRowCommand="BasketGrid_RowCommand" OnDataBound="BasketGrid_DataBound" SkinID="Basket" FixedColIndexes="0,6,7">
							    <Columns>
								    <asp:TemplateField HeaderText="CART ITEMS">
									    <HeaderStyle CssClass="thumbnail" />
									    <ItemStyle CssClass="thumbnail" />
									    <ItemTemplate>
										    <asp:PlaceHolder ID="ProductImagePanel" runat="server" Visible='<%#ShowProductImagePanel(Container.DataItem)%>' EnableViewState="false">
											    <asp:HyperLink ID="ThumbnailLink" runat="server" NavigateUrl='<%#GetProductUrl(Container.DataItem)%>' EnableViewState="false">
												    <asp:Image ID="Thumbnail" runat="server" AlternateText='<%# Eval("Product.ThumbnailAltText") %>' ImageUrl='<%#AbleCommerce.Code.ProductHelper.GetThumbnailUrl(Container.DataItem)%>' EnableViewState="false" Visible='<%#!string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' />
                                                    <asp:Image ID="NoThumbnail" runat="server" SkinID="NoThumbnail" Visible='<%#string.IsNullOrEmpty((string)Eval("Product.ThumbnailUrl")) %>' EnableViewState="false" />
											    </asp:HyperLink>
										    </asp:PlaceHolder>
									    </ItemTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField>
									    <HeaderStyle CssClass="item" />
									    <ItemStyle CssClass="item" />
									    <ItemTemplate>
										    <asp:PlaceHolder ID="ProductPanel" runat="server" Visible='<%#IsProduct(Container.DataItem)%>'>
											    <uc:BasketItemDetail id="BasketItemDetail1" runat="server" BasketItemId='<%#Eval("Id")%>' ShowAssets="true" ShowSubscription="true" LinkProducts="True" />
										    </asp:PlaceHolder>
                                            <asp:Panel ID="ItemActionsPanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>' CssClass="itemActions">
											    <asp:LinkButton ID="DeleteItemButton" runat="server" CssClass="button remove-btn" CommandName="DeleteItem" CommandArgument='<%# Eval("BasketItemId") %>' Text="x" OnClientClick="return confirm('Are you sure you want to remove this item from your cart?')"></asp:LinkButton>
										    </asp:Panel>
										    <asp:PlaceHolder ID="OtherPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") != OrderItemType.Product)%>' EnableViewState="false">
											    <%#Eval("Name")%>
										    </asp:PlaceHolder>
										    <asp:PlaceHolder ID="CouponPanel" runat="server" Visible='<%#((OrderItemType)Eval("OrderItemType") == OrderItemType.Coupon)%>' EnableViewState="true">
											    <br/>
											    <asp:LinkButton ID="DeleteCouponItemButton" runat="server" CommandName="DeleteCoupon" CommandArgument='<%# Eval("Sku") %>' Text="delete" OnClientClick="return confirm('Are you sure you want to remove this coupon from your cart?')" EnableViewState="true" CssClass="link"></asp:LinkButton>
										    </asp:PlaceHolder>
									    </ItemTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField Visible="false" HeaderText="SKU">
									    <HeaderStyle CssClass="sku" />
									    <ItemStyle CssClass="sku" />
									    <ItemTemplate>
										    <%#AbleCommerce.Code.ProductHelper.GetSKU(Container.DataItem)%>
									    </ItemTemplate>
								    </asp:TemplateField>
                                    <asp:TemplateField Visible="false" HeaderText="TAX">
									    <HeaderStyle CssClass="tax" />
									    <ItemStyle CssClass="tax" />
									    <ItemStyle HorizontalAlign="Center" Width="40px" />
									    <ItemTemplate></ItemTemplate>
								    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="QTY">
									    <HeaderStyle CssClass="quantity" />
									    <ItemStyle CssClass="quantity" />
									    <ItemTemplate>
										    <asp:PlaceHolder ID="ProductQuantityPanel" runat="server" Visible='<%#IsParentProduct(Container.DataItem)%>'>
											    <asp:TextBox ID="Quantity" runat="server" MaxLength="5" Text='<%# Eval("Quantity") %>' Width="50px"></asp:TextBox>
										    </asp:PlaceHolder>
										    <asp:PlaceHolder ID="OtherQuantityPanel" runat="server" Visible='<%#!IsParentProduct(Container.DataItem)%>' EnableViewState="false">
											    <%#Eval("Quantity")%>
										    </asp:PlaceHolder>							
									    </ItemTemplate>
								    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="ITEM PRICE ex.gst" Visible="false">
									    <HeaderStyle CssClass="price" />
									    <ItemStyle CssClass="price" />
									    <ItemTemplate></ItemTemplate>
								    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="GST" Visible="false">
									    <HeaderStyle CssClass="price" />
									    <ItemStyle CssClass="price" />
									    <ItemTemplate></ItemTemplate>
                                        <FooterStyle CssClass="footerSubtotalLabel" />
 									    <FooterTemplate></FooterTemplate>
								    </asp:TemplateField>
								    <asp:TemplateField HeaderText="ITEM TOTAL ex.gst" Visible="false">
									    <HeaderStyle CssClass="total" />
									    <ItemStyle CssClass="total" />
                                        <ItemTemplate></ItemTemplate>
                                        <FooterStyle CssClass="footerSubtotal" />
 									    <FooterTemplate></FooterTemplate>
								    </asp:TemplateField>
							    </Columns>
						    </cb:ExGridView>
						</div>
						<asp:Panel ID="EmptyBasketPanel" runat="server" CssClass="emptyBasketPanel" EnableViewState="false">
							<asp:Label ID="EmptyBasketMessage" runat="server" Text="Your cart is empty." CssClass="message" EnableViewState="false"></asp:Label>
						</asp:Panel>
						<div class="actions">
							<span class="basket">
                                <div class="clear-btn btn-wrapper">
                                    <asp:Button ID="ClearBasketButton" runat="server" OnClientClick="return confirm('Are you sure you want to clear your cart?')" Text="Clear Cart" OnClick="ClearBasketButton_Click" EnableViewState="false" CssClass="button"></asp:Button>
                                </div>
                                <div class="btn-wrapper">
                                    <asp:Button ID="KeepShoppingButton" runat="server" OnClick="KeepShoppingButton_Click" Text="KEEP BROWSING" EnableViewState="false" CssClass="button"></asp:Button>
                                </div>
                                <div class="btn-wrapper">
                                    <asp:Button ID="UpdateButton" runat="server" OnClick="UpdateButton_Click" Text="UPDATE" EnableViewState="false" CssClass="button"></asp:Button>
                                </div>
							</span>
							<span class="checkout">
								<asp:Button ID="CheckoutButton" runat="server" OnClick="Submit_Click" Text="SEND QUOTE" EnableViewState="false" CssClass="checkoutbutton"></asp:Button>
							</span>
						</div>
					</asp:Panel>
				</ContentTemplate>
			</asp:UpdatePanel>
		</div>
	</div>
</div>
    <!-- Google Code for Lead Conversion Page -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 941730315;
var google_conversion_language = "en";
var google_conversion_format = "3";
var google_conversion_color = "ffffff";
var google_conversion_label = "WAfKCPDgnGAQi9SGwQM";
var google_remarketing_only = false;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/941730315/?label=WAfKCPDgnGAQi9SGwQM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>

</asp:Content>