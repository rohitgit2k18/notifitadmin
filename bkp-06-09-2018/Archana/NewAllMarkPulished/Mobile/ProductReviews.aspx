<%@ Page Title="Product Reviews" Language="C#" MasterPageFile="~/Layouts/Mobile.master" AutoEventWireup="true" CodeFile="ProductReviews.aspx.cs" Inherits="AbleCommerce.Mobile.ProductReviews" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%@ Register src="~/Mobile/UserControls/NavBar.ascx" tagname="NavBar" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
<uc1:NavBar ID="NavBar" runat="server" />
<div id="productReviewsPage" class="mainContentWrapper">
    <div class="section">
         <div class="pageHeader">
            <h1><asp:Label ID="ProductName" runat="server" EnableViewState="false"></asp:Label></h1>
        </div>
        <div class="header">
			<h2>Customer Reviews</h2>
		</div>
        <div class="content">
            <asp:Repeater ID="ReviewsRepeater" runat="server" DataSourceID="ReviewDs" >
                <HeaderTemplate>
                    <div class="productReviews">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="productReview <%# Container.ItemIndex % 2 == 0 ? "even" : "odd" %>">
                        <div class="title">
                            <asp:Label ID="ReviewTitleLabel" Text='<%#Eval("ReviewTitle")%>' runat="server" CssClass="fieldHeader"></asp:Label>
                        </div>
                        <div class="info">
                            <uc1:ProductRatingStars ID="ReviewRating" runat="server" Rating='<%# ((CommerceBuilder.Products.ProductReview)Container.DataItem).Rating %>' />
                            <asp:Label ID="ReviewerName" runat="server" Text='<%#Eval("ReviewerProfile.DisplayName", "by {0}")%>' CssClass="reviwerName"></asp:Label>
                            <asp:Label ID="ReviewerLocation" runat="server" Text='{0}<br />' Visible="false" CssClass="location"></asp:Label>
                            <asp:Label ID="ReviewDate" runat="server" Text='<%# Eval("ReviewDate", "on {0:d}") %>' CssClass="reviewDate"></asp:Label>
                        </div>
                        <div class="contents">
                            <%#Eval("ReviewBody")%>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="NoReviewsPanel" runat="server" Visible="false" CssClass="noReviewsPanel">
                <asp:Label ID="NoReviewsMessage" runat="server" Text="Be the first to review this product!"></asp:Label>
            </asp:Panel>
            <asp:ObjectDataSource ID="ReviewDs" runat="server" EnablePaging="True" OldValuesParameterFormatString="original_{0}"
                SelectCountMethod="SearchCount" SelectMethod="Search" 
                TypeName="CommerceBuilder.Products.ProductReviewDataSource">
                <SelectParameters>
                    <asp:QueryStringParameter Name="productId" QueryStringField="ProductId" Type="Int32" />
                    <asp:Parameter Name="approved" Type="Object" DefaultValue="True" />
                    <asp:Parameter Name="sortExpression" Type="String" DefaultValue="ReviewDate DESC"/>
                </SelectParameters>
            </asp:ObjectDataSource>   
        </div>
    </div>
    <asp:Panel ID="PostReviewPanel" runat="server">
        <div class="section">
            <div class="header">
                <h2>Submit a review</h2>
            </div>
            <div class="content">
                <asp:Panel ID="RegisterPanel" runat="server" CssClass="registerForReview" Visible="false">
		            <asp:Label ID="RegisterMessage" runat="server" Text="You must be logged in to write a review." EnableViewState="False" CssClass="message"></asp:Label>
		            <asp:HyperLink ID="LoginLink"  runat="server" Text="Login" NavigateUrl="#" CssClass="button hyperLinkButton" EnableViewState="False"></asp:HyperLink>
	            </asp:Panel>
                <asp:Panel ID="ReviewPanel" runat="server" CssClass="reviewDialog">
		            <div class="info">
		                <span class="instruction"><asp:Localize ID="InstructionText" runat="server" Text="Enter your review in the form below." EnableViewState="False"></asp:Localize></span>
		                <span><asp:Localize ID="reviewInstruction" runat="server" Text="By submitting your review you agree to the " EnableViewState="False"></asp:Localize></span>
                        <asp:HyperLink ID="ReviewTermsLink" runat="server" NavigateUrl="#" Text="terms and conditions." EnableViewState="False" CssClass="linked"></asp:HyperLink>
		                <asp:Localize ID="InstructionText2" runat="server" Text="  Your review may be subject to approval before publication." EnableViewState="False"></asp:Localize>
		            </div>
		            <div class="inputForm">
                        <div class="validationSummary">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False" />
                        </div>
			            <div class="field">
				            <span class="fieldHeader">
					            Your Name:
				            </span>
				            <span class="fieldValue">
					            <asp:TextBox ID="Name" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:TextBox>
					            <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="Name"
						            Display="Static" ErrorMessage="Name is required" SetFocusOnError="True"
						            Text="*" ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:RequiredFieldValidator>
				            </span>
			            </div>
			            <div class="field">
				            <span class="fieldHeader">
					            Your Location:
				            </span>
				            <span class="fieldValue">
					            <asp:TextBox ID="Location" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:TextBox>
				            </span>
			            </div>
			            <div class="field">
				            <span class="fieldHeader">
					            Rating:
				            </span>
				            <span class="fieldValue">
					            <asp:DropDownList ID="Rating" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False">                    
						            <asp:ListItem Text="--Please Select--" Value=""></asp:ListItem>
						            <asp:ListItem Value="10" Text="5 (Excellent)"></asp:ListItem>
						            <asp:ListItem Value="8" Text="4 (Good)"></asp:ListItem>
						            <asp:ListItem Value="6" Text="3 (Average)"></asp:ListItem>
						            <asp:ListItem Value="4" Text="2 (Poor)"></asp:ListItem>
						            <asp:ListItem Value="2" Text="1 (Very Poor)"></asp:ListItem>                    
					            </asp:DropDownList>
					            <asp:RequiredFieldValidator ID="RatingValidator" runat="server" ControlToValidate="Rating"
						            ErrorMessage="You must select your rating." Text="*" 
						            ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:RequiredFieldValidator>
				            </span>
			            </div>
			            <div class="field">
				            <span class="fieldHeader">
					            Title:
				            </span>
				            <span class="fieldValue">
					            <asp:TextBox ID="ReviewTitle" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False" MaxLength="100"></asp:TextBox>
					            <asp:RequiredFieldValidator ID="ReviewTitleValidator" runat="server" ControlToValidate="ReviewTitle"
						            ErrorMessage="Please enter a title for your review." Text="*"
						            ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:RequiredFieldValidator>
				            </span>
			            </div>
			            <div class="field">
				            <span class="fieldHeader">
					            Review:
				            </span>
				            <span class="fieldValue">
					            <asp:TextBox ID="ReviewBody" runat="server" Rows="8" TextMode="MultiLine" ValidationGroup="ProductReviewForm" EnableViewState="False" MaxLength="1000"></asp:TextBox>
					            <br />
					            <asp:Label ID="ReviewMessageCharCount" runat="server" Text="100" EnableViewState="false" CssClass="count"></asp:Label>
					            <span class="countText"><asp:Literal ID="ReviewMessageCharCountLabel" runat="server" Text="characters remaining" EnableViewState="false"></asp:Literal></span>
				            </span>
			            </div>
                        <div id="trCaptcha" runat="server" class="field">
				            <span class="captchaWrapper">
					            <cb:CaptchaImage ID="CaptchaImage" runat="server" Height="60px" Width="200px" EnableViewState="False" AlternateText="Captcha" /><br />
					            <asp:LinkButton ID="ChangeImageLink" runat="server" Text="different image" CausesValidation="false" OnClick="ChangeImageLink_Click" EnableViewState="False"></asp:LinkButton><br /><br />
					            <asp:Label ID="CaptchaInputLabel" runat="server" Text="Type the number above:" CssClass="fieldHeader" EnableViewState="False"></asp:Label>
					            <asp:TextBox ID="CaptchaInput" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:TextBox>
					            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="CaptchaInput"
						            Display="Dynamic" ErrorMessage="You must enter the number in the image." Text="*" 
						            ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:RequiredFieldValidator>
					            <asp:PlaceHolder ID="phCaptchaValidators" runat="server" EnableViewState="False"></asp:PlaceHolder>
				            </span>
			            </div>
			            <div id="trEmailAddress1" runat="server" class="field">
					        <hr />
					        <p>
                                <i><asp:Localize ID="Localize1" runat="server" Text="Your email address is required to submit a review. It will never be displayed or used for any marketing purposes." EnableViewState="False"></asp:Localize></i>
				            </p>
			            </div>
			            <div id="trEmailAddress2" runat="server" class="field">
				            <span class="fieldHeader">
					            Email Address:
				            </span>
				            <span class="fieldValue">
					            <asp:TextBox ID="Email" runat="server" ValidationGroup="ProductReviewForm" EnableViewState="False"></asp:TextBox>
					            <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="Email" ValidationGroup="ProductReviewForm" Display="Dynamic" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
					            <asp:PlaceHolder ID="phEmailValidators" runat="server" EnableViewState="False"></asp:PlaceHolder>
				            </span>
			            </div>
			            <div class="buttons">
					        <asp:Button ID="SubmitReviewButton" runat="server" Text="Submit Review" OnClick="SubmitReviewButton_Click" ValidationGroup="ProductReviewForm" EnableViewState="False" />
					        <asp:Button ID="OverwriteReviewButton" runat="server" Text="Overwrite Previous Review" OnClick="SubmitReviewButton_Click" ValidationGroup="ProductReviewForm" EnableViewState="False" Visible="false" />
			            </div>
		            </div>
		        </asp:Panel>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="ConfirmPanel" runat="server" Visible="false" CssClass="reviewConfirmation">
		<div class="info">
		    <asp:Label ID="ConfirmMessage" runat="server" Text="Your review has been submitted." EnableViewState="False"></asp:Label>
		    <asp:Label ID="ConfirmApproval" runat="server" Text="It will not be published until it has been approved." EnableViewState="False"></asp:Label>
		    <asp:Label ID="ConfirmEmail" runat="server" Text="<br /><br />An email message has been sent to: {0}.<br /><br />Follow the instructions in the message to validate your email address." EnableViewState="False"></asp:Label>
		</div>
		<asp:Button ID="ConfirmOk" runat="server" Text="OK" OnClick="ConfirmOk_Click" EnableViewState="False" />
	</asp:Panel>
</div>
</asp:Content>
<asp:Content ID="Content2" runat="server" contentplaceholderid="PageFooter"></asp:Content>
<asp:Content ID="Content3" runat="server" contentplaceholderid="PageHeader"></asp:Content>