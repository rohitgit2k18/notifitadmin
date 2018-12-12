<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" Inherits="AbleCommerce.Admin.Products.ProductTemplates.EditInputField" Title="Edit Field"  CodeFile="EditInputField.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:UpdatePanel ID="InputFieldAjax" runat="server">
        <ContentTemplate>
            <div class="pageHeader">
    	        <div class="caption">
    		        <h1><asp:Localize ID="Caption" runat="server" Text="{0}: Edit {1} Field '{2}'" EnableViewState="false"></asp:Localize></h1>
    	        </div>
            </div>
            <div class="content">
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                <cb:Notification ID="SavedMessage" runat="server" Text="Field has been saved at {0:d}." SkinID="GoodCondition" Visible="false" EnableViewState="false"></cb:Notification>
                <table class="inputForm compact">
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
                        <th valign="top">
                            <asp:Label ID="ChoicesLabel" runat="server" Text="Choices:" SkinID="FieldHeader"></asp:Label><br />
                        </th>
                        <td>
                            <asp:GridView ID="ChoicesGrid" runat="server" AutoGenerateColumns="false" 
                                OnRowDeleting="ChoicesGrid_RowDeleting" OnRowCommand="ChoicesGrid_RowCommand" SkinID="PagedList" EnableViewState="true">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sort">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="MU" runat="server" SkinID="UpIcon" CommandName="MoveUp" ToolTip="Move Up" CommandArgument='<%#Eval("Id")%>' />
                                            <asp:ImageButton ID="MD" runat="server" SkinID="DownIcon" CommandName="MoveDown" ToolTip="Move Down" CommandArgument='<%#Eval("Id")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="ChoiceText" runat="server" Columns="30" Text='<%#Eval("ChoiceText")%>' MaxLength="100"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="ChoiceTextValidator" runat="server" ErrorMessage="Maximum length for Choice Text is 100 characters." Text="*" ControlToValidate="ChoiceText" ValidationExpression=".{0,100}"  ></asp:RegularExpressionValidator>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Value (optional)">
                                        <ItemTemplate>
                                            <asp:TextBox ID="ChoiceValue" runat="server" Columns="30" Text='<%#Eval("ChoiceValue")%>' MaxLength="100"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="ChoiceValueValidator" runat="server" ErrorMessage="Maximum length for Choice Value is 100 characters." Text="*" ControlToValidate="ChoiceValue" ValidationExpression=".{0,100}"  ></asp:RegularExpressionValidator>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Selected">
                                        <ItemStyle HorizontalAlign="center" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="IsSelected" runat="server" Checked='<%#Eval("IsSelected")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:LinkButton id="AddChoiceButton" runat="server" Text="Add Choice" OnClick="AddChoiceButton_Click" SkinID="AddButton" CausesValidation="true"></asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click"></asp:Button>
                            <asp:Button ID="BackButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="BackButton_Click" CausesValidation="false" />
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>