<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.VerifyEmail" EnableViewState="false" CodeFile="VerifyEmail.ascx.cs" %>
<%--
<conlib>
<summary>Displays an email verification page.</summary>
<param name="SuccessMessage" default="Your email address has been verified!">Message to display on success</param>
<param name="FailureMessage" default="Your email address could not be verified. Check that you have opened the link exactly as it appeared in the verification notice.">Message to display on failure</param>
</conlib>
--%>
<div class="innerSection">
<div class="info">
<asp:Label ID="SuccessText" Text="Your email address has been verified!" runat="server" CssClass="goodCondition"></asp:Label>
<asp:Label ID="FailureText" Text="Your email address could not be verified.  Check that you have opened the link exactly as it appeared in the verification notice." runat="server" CssClass="errorCondition"></asp:Label>
</div>
</div>
