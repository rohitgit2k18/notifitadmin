<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.ProductCustomFieldsDialog" EnableViewState="false" CodeFile="ProductCustomFieldsDialog.ascx.cs" %>
<%--
<conlib>
<summary>Display a list of custom fields of a product.</summary>
</conlib>
--%>
<div class="widget customFieldsDialog">
<div class="innerSection">
<div class="content">
<table class="customFields">
<asp:ListView ID="ProductTemplateFieldsList" runat="server">
    <ItemTemplate>
        <tr>
            <th>
                <%--<%#Eval("InputField.Name")%>--%>
            </th>
            <td>
                <%#Eval("InputValue")%>
            </td>
        </tr>
    </ItemTemplate>
</asp:ListView>
<asp:ListView ID="ProductCustomFieldsList" runat="server">
    <ItemTemplate>
        <tr>
            <th>
                <%#Eval("FieldName")%>
            </th>
            <td>
                <%#Eval("FieldValue")%>
            </td>
        </tr>
    </ItemTemplate>
</asp:ListView>
</table>
</div>
</div>
</div>
