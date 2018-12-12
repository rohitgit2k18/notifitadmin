<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Products.Reviews.EditReview" Title="Edit Review"  CodeFile="EditReview.aspx.cs" %>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="pageHeader">
        	    <div class="caption">
        		    <h1><asp:Localize ID="Caption" runat="server" Text="Edit Review"></asp:Localize></h1>
        	    </div>
            </div>
            <div class="content">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SuccessMessage" runat="server" Text="Review updated at {0:t}" SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                <table cellspacing="0" class="inputForm" width="100%">
                    <tr>
                        <th>
                            <asp:Label ID="ProductNameLabel" runat="server" Text="Product:" AssociatedControlID="ProductLink" ToolTip="The product that was reviewed"></asp:Label>
                        </th>
                        <td>
                            <asp:HyperLink ID="ProductLink" runat="server" NavigateUrl="../EditProduct.aspx?ProductId={0}"></asp:HyperLink>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ReviewDateLabel" runat="server" Text="Date:" AssociatedControlID="ReviewDate" ToolTip="Date of the review"></asp:Label>
                        </th>
                        <td>
                            <asp:Label ID="ReviewDate" runat="Server" Text="{0:d}"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ApprovedLabel" runat="server" Text="Approved:" AssociatedControlID="Approved" ToolTip="Whether the review is approved for publication"></asp:Label>
                        </th>
                        <td>
                            <asp:CheckBox ID="Approved" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ReviewerEmailLabel" runat="server" Text="Reviewer:" AssociatedControlID="ReviewerEmail" ToolTip="Email of the reviewer"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="ReviewerEmail" runat="server" MaxLength="200" Width="200"></asp:TextBox>
                            <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="ReviewerEmail" Required="true" ErrorMessage="Email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ReviewerNameLabel" runat="server" Text="Name:" AssociatedControlID="ReviewerName" ToolTip="Name of the reviewer"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="ReviewerName" runat="server" MaxLength="50" Width="200"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ReviewerLocationLabel" runat="server" Text="Location:" AssociatedControlID="ReviewerLocation" ToolTip="Location of the reviewer"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="ReviewerLocation" runat="server" MaxLength="50" Width="200"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="RatingLabel" runat="server" Text="Rating:" AssociatedControlID="Rating" ToolTip="Rating given for the review"></asp:Label>
                        </th>
                        <td>
                            <asp:Label ID="Rating" runat="server" Text="{0:00}/10" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="ReviewTitleLabel" runat="server" Text="Title:" AssociatedControlID="ReviewTitle" ToolTip="Title of the review"></asp:Label>
                        </th>
                        <td>
                            <asp:TextBox ID="ReviewTitle" runat="server" MaxLength="100" Width="600"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="ReviewTitleValidator" runat="server" ControlToValidate="ReviewTitle"
                                    ErrorMessage="Please provide a title for the review." Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <th valign="top">
                            <asp:Label ID="ReviewBodyLabel" runat="server" Text="Review:" AssociatedControlID="ReviewBody" ToolTip="Content of the review"></asp:Label>
                            <br />
                            <asp:ImageButton ID="ReviewBodyHtml" runat="server" SkinID="HtmlIcon" />
                        </th>
                        <td>
                            <asp:TextBox ID="ReviewBody" runat="Server" Text="" Width="600" style="height:150px" TextMode="MultiLine" /><span class="requiredField">*</span>                            
                            <asp:RequiredFieldValidator ID="ReviewBodyValidator" runat="server" ControlToValidate="ReviewBody"
                                    ErrorMessage="Review content is required." Text="*"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button Id="SaveButon" runat="server" Text="Save" OnClick="SaveButton_Click" SkinID="Button" />
                            <asp:Button Id="SaveAndCloseButton" runat="server" Text="Save and Close" OnClick="SaveAndCloseButton_Click" SkinID="Button" />
							<asp:Button Id="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" SkinID="CancelButton" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>