<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.SubscribeToEmailList" CodeFile="SubscribeToEmailList.ascx.cs" %>
<%--
<conlib>
<summary>Displays a simple email list signup form. This form can be added to side bars.</summary>
<param name="Caption" default="Subscribe To Email List">The Caption / Title of the control</param>
<param name="EmailListId" default="0">This is the ID of the Email List to be subscribed to. If no email list is specified the store's default email list is used.</param>
</conlib>
--%>
<div class="widget emailListWidget">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Subscribe To Email List" /></h2>
        </div>
        <div class="content">
            <div class="info">
                <span class="instruction"><asp:Literal ID="InstructionsText" runat="server" Text="Enter your email address below to subscribe to {0}." /></span>
            </div>
            <asp:UpdatePanel ID="SubscribeToEmailListAjax" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="SubscribePanel" runat="server" DefaultButton="SubscribeButton">
				    <div class="dialogSection">
                        <table cellspacing="0" class="compactleft">
                            <tr>            
                                <td>
                                    <asp:Label ID="SubscribedMessage" runat="server" CssClass="goodCondition" EnableViewState="false" Visible="false" Text="Your email '{0}' is now subscribed to '{1}'."></asp:Label>
                                    <asp:Label ID="VerificationRequiredMessage" runat="server" CssClass="goodCondition" EnableViewState="false" Visible="false" Text="An email has been sent to {0}. Please follow the instructions to complete the signup process."></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>
                                     <asp:Label ID="UserEmailLabel" runat="server" Text="Your Email:" AssociatedControlID="UserEmail" ></asp:Label>
                                     <cb:EmailAddressValidator ID="EmailAddressValidator1" runat="server" ControlToValidate="UserEmail" ValidationGroup="SubscribeEmailList" Display="Dynamic" Required="true" ErrorMessage="From email address should be in the format of name@domain.tld." Text="*" EnableViewState="False"></cb:EmailAddressValidator>                             
                                </th>
                            </tr>    
                            <tr>
                                <td>
                                    <asp:TextBox ID="UserEmail" runat="server" Text="" Width="150px" MaxLength="200"></asp:TextBox>
                                </td>                        
                            </tr>
                            <tr>                
                                <td >
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="SubscribeEmailList" />
                                </td>
                            </tr>                    
                            <tr>                
                                <td>
                                    <asp:Button ID="SubscribeButton" runat="server" Text="Subscribe Now" OnClick="SubscribeButton_Click" ValidationGroup="SubscribeEmailList"></asp:Button>
                                </td>
                            </tr>
                        </table>
			        </div>
                   </asp:Panel>
                 </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</div>