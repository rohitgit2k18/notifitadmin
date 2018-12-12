<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductReviewForm.ascx.cs" Inherits="AbleCommerce.Mobile.UserControls.ProductReviewForm" %>
<%--
<conlib>
<summary>Displays a form using that a customer can submit/edit a review for a product.</summary>
</conlib>
--%>
<div class="productReviewForm">
	<asp:Panel ID="RegisterPanel" runat="server" Visible="false" CssClass="innerSection registerForReview">
		<div class="info">
		<asp:Label ID="RegisterMessage" runat="server" Text="You must be logged in to write a review." EnableViewState="False" CssClass="message"></asp:Label>
		</div>
		<div class="actions">
			<asp:HyperLink ID="LoginLink"  runat="server" Text="Login" NavigateUrl="../Login.aspx" CssClass="button hyperLinkButton" EnableViewState="False"></asp:HyperLink>
			<asp:LinkButton ID="CancelLink"  runat="server" Text="Cancel" OnClick="CancelButton_Click" CssClass="button linkButton" EnableViewState="False"></asp:LinkButton>
		</div>
	</asp:Panel>
	<asp:Panel ID="ReviewPanel" runat="server" CssClass="innerSection reviewDialog">
		<div class="info">
		    <span class="instruction"><asp:Localize ID="InstructionText" runat="server" Text="Enter your review in the form below." EnableViewState="False"></asp:Localize></span>
		    <span><asp:Localize ID="reviewInstruction" runat="server" Text="By submitting your review you agree to the " EnableViewState="False"></asp:Localize></span>
            <asp:HyperLink ID="ReviewTermsLink" runat="server" NavigateUrl="#" Text="terms and conditions." EnableViewState="False"></asp:HyperLink>
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
			<div id="trEmailAddress1" runat="server" class="field">
				<span class="fieldValue">
					<hr />
					<i><asp:Localize ID="Localize1" runat="server" Text="Your email address is required to submit a review.  It is never displayed or used for any marketing purposes." EnableViewState="False"></asp:Localize></i>
				</span>
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
			    <asp:Button ID="CancelReviewButton" runat="server" Text="Cancel" EnableViewState="False" CssClass="button"  OnClick="CancelReviewButton_Click"></asp:Button>
            </div>
		</div>
	</asp:Panel>	
	<asp:Panel ID="ConfirmPanel" runat="server" Visible="false" CssClass="innerSection reviewConfirmation">
		<div class="info">
		<asp:Label ID="ConfirmMessage" runat="server" Text="Your review has been submitted." EnableViewState="False"></asp:Label>
		<asp:Label ID="ConfirmApproval" runat="server" Text="It will not be published until it has been approved." EnableViewState="False"></asp:Label>
		<asp:Label ID="ConfirmEmail" runat="server" Text="<br /><br />An email message has been sent to: {0}.<br /><br />Follow the instructions in the message to validate your email address." EnableViewState="False"></asp:Label>
		</div>
		<div class="actions">	
		<asp:Button ID="ConfirmOk" runat="server" Text="OK" OnClick="ConfirmOk_Click" EnableViewState="False" />
		</div>
	</asp:Panel>
</div>
