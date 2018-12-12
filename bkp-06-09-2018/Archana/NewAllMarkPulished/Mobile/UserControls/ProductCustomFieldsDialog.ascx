<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductCustomFieldsDialog.ascx.cs" EnableViewState="false" Inherits="AbleCommerce.Mobile.UserControls.ProductCustomFieldsDialog" %>
<%--
<UserControls>
<summary>Display a list of custom fields of a product.</summary>
</UserControls>
--%>
<div class="widget customFieldsDisplay">
<div class="header">
    <h2>
        <asp:Literal ID="Literal1" runat="server" Text="Other Attributes" EnableViewState="false"></asp:Literal>
    </h2>
</div>
<div class="content">
<div class="inputForm">
<asp:ListView ID="ProductTemplateFieldsList" runat="server">
    <ItemTemplate>
        <div class="field">
            <span class="fieldHeaderInline">
             <%#Eval("InputField.Name")%>: 
            </span>
           <span class="fieldValueInline">
              <%#Eval("InputValue")%>
           </span>
        </div>
    </ItemTemplate>
</asp:ListView>
<asp:ListView ID="ProductCustomFieldsList" runat="server">
    <ItemTemplate>
        <div class="field">
            <span class="fieldHeaderInline">
              <%#Eval("FieldName")%>: 
            </span>
           <span class="fieldValueInline">
               <%#Eval("FieldValue")%>
           </span>
        </div>
    </ItemTemplate>
</asp:ListView>
</div>
</div>
</div>
