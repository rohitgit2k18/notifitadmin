<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Products.ProductTemplates.AddInputField" Title="Add Field"  CodeFile="AddInputField.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1><asp:Localize ID="Caption" runat="server" Text="Add {0} Field to '{1}'"></asp:Localize></h1>
    	</div>
    </div>
    <div class="content">
        <asp:UpdatePanel ID="InputFieldAjax" runat="server">
            <ContentTemplate>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <table class="inputForm">
                    <tr id="trUseShopBy" runat="server">
                        <th>
                            <asp:Label ID="UseShopByLabel" runat="server" Text="Use ShopBy:" SkinID="FieldHeader"></asp:Label>
                        </th>
                        <td>
                            <asp:CheckBox ID="UseShopBy" runat="server" AutoPostBack="true" OnCheckedChanged="UseShopBy_CheckedChanged" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="InputTypeIdLabel" runat="server" Text="Select Input Type:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:DropDownList ID="InputTypeId" runat="server" AutoPostBack="true" OnSelectedIndexChanged="InputTypeId_SelectedIndexChanged">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="NameLabel" runat="server" Text="Name:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:TextBox ID="Name" runat="server" Text="" Columns="20" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" Display="Dynamic" ErrorMessage="Name is required." ControlToValidate="Name"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="AddNameValidator" runat="server" ErrorMessage="Maximum length for Name is 100 characters." Text="*" ControlToValidate="Name" ValidationExpression=".{1,100}"  ></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <asp:Label ID="UserPromptLabel" runat="server" Text="Prompt for User:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:TextBox ID="UserPrompt" runat="server" Text="" Columns="50" MaxLength="255"></asp:TextBox><span class="requiredField">*</span>
                            <asp:RequiredFieldValidator ID="UserPromptRequired" runat="server" Text="*" Display="Dynamic" ErrorMessage="UserPrompt is required." ControlToValidate="UserPrompt"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="UserPromptValidator" runat="server" ErrorMessage="Maximum length for user prompt is 100 characters." Text="*" ControlToValidate="UserPrompt" ValidationExpression=".{1,255}"  ></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr id="trRequired" runat="server">
                        <th>
                            <asp:Label ID="RequiredLable" runat="server" Text="Required:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:CheckBox ID="Required" runat="server" />
                        </td>
                    </tr>
                    <tr id="trRows" runat="server">
                        <th>
                            <asp:Label ID="RowsLabel" runat="server" Text="Height in Rows:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:TextBox ID="Rows" runat="server" Text="" Columns="4" MaxLength="3"></asp:TextBox>
                            <asp:RangeValidator ID="RowsValidator1" runat="server" Text="*" Type="Integer" ErrorMessage="Rows value should fall between 0 and 255." ControlToValidate="Rows" MinimumValue="1" MaximumValue="255"/>
                        </td>
                    </tr>
                    <tr id="trColumns" runat="server">
                        <th>
                            <asp:Label ID="ColumnsLabel" runat="server" Text="Width in Columns:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:TextBox ID="Columns" runat="server" Text="" Columns="4" MaxLength="3"></asp:TextBox>
                            <asp:RangeValidator ID="ColumnsValidator" runat="server" Text="*" Type="Integer" ErrorMessage="Columns value should fall between 0 and 255." ControlToValidate="Columns" MinimumValue="1" MaximumValue="255"/>
                        </td>
                    </tr>
                    <tr id="trMaxLength" runat="server">
                        <th>
                            <asp:Label ID="MaxLengthLabel" runat="server" Text="Max Length of Text:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:TextBox ID="MaxLength" runat="server" Text="" Columns="4" MaxLength="4"></asp:TextBox>
                            <asp:RangeValidator ID="MaxLengthValidator1" runat="server" Text="*" Type="Integer" ErrorMessage="Max Length value should fall between 0 and 1000." ControlToValidate="MaxLength" MinimumValue="1" MaximumValue="1000"/>
                        </td>
                    </tr>
                    <tr id="trChoices" runat="server" visible="false">
                        <th>
                            <asp:Label ID="ChoicesLabel" runat="server" Text="Choices:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:Label ID="ChoicesHelpText" runat="server" Text="After you click Next, you will be able to configure the user input choices." SkinID="HelpText"></asp:Label><br />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Finish" OnClick="SaveButton_Click" />
                            <asp:Button ID="NextButton" runat="server" Text="Next" OnClick="NextButton_Click" Visible="false" />
							<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>