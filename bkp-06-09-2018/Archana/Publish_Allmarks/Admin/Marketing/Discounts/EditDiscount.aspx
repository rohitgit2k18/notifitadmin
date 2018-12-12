<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Marketing.Discounts.EditDiscount" Title="Add/Edit Discount" CodeFile="EditDiscount.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type = "text/javascript">
        function Confirm() {
            var confirmValue = document.createElement("INPUT");
            var selectedValue = $('#<%=UseGlobalScope.ClientID %> input[type=radio]:checked').val();
            var hdnScopeValue = $('#<%=hdnScope.ClientID %>').val();
            confirmValue.type = "hidden";
            confirmValue.name = "confirmValue";
            if (selectedValue == "Global" && hdnScopeValue != "0 Categories and 0 Product(s) selected" && hdnScopeValue != "{0} Categories and {1} Product(s) selected") {
                if (confirm("Changing Discount scope to Global will remove any category and/or product assignments to the Specific Discount scope. Are you sure you want to proceed?")) {
                    confirmValue.value = "Yes";
                } else {
                    confirmValue.value = "No";
                }
            }
            document.forms[0].appendChild(confirmValue);
        }
    </script>
    <div class="pageHeader">
    	<div class="caption">
    		<h1>
                <asp:Localize ID="AddCaption" runat="server" Text="Add Volume Discount"></asp:Localize>
                <asp:Localize ID="EditCaption" runat="server" Text="Edit '{0}'"></asp:Localize>
            </h1>
    	</div>
    </div>
    <div class="content">
    <cb:Notification ID="SavedMessage" runat="server" Text="Discounts saved at {0:t}" SkinID="GoodCondition" Visible="false"></cb:Notification>
        <asp:ValidationSummary ID="DetailValidationSummary" runat="server" />
        <table cellspacing="0" class="inputForm">
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="NameLabel" runat="server" Text="Name:" ToolTip="The name of the discount as it will appear in the merchant admin."></cb:ToolTipLabel>
                </th>
                <td valign="top">
                    <asp:TextBox ID="Name" runat="server" Text="" Width="250px" MaxLength="100"></asp:TextBox><span class="requiredField">*</span>
                    <asp:RequiredFieldValidator ID="NameRequired" runat="server" Text="*" Display="Static" ErrorMessage="Name is required." ControlToValidate="Name"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="NameValidator" runat="server" ErrorMessage="Maximum length for Name is 100 characters." Text="*" ControlToValidate="Name" ValidationExpression=".{0,100}"  ></asp:RegularExpressionValidator>
                </td>
                <th valign="top">
                    <cb:ToolTipLabel ID="DiscountBasisLabel" runat="server" Text="Base Discount On:" ToolTip="Indicate whether the discount is based on the quantity or the total value of items purchased."></cb:ToolTipLabel>
                </th>
                <td>
                    <asp:DropDownList ID="IsValueBased" runat="server">
                        <asp:ListItem Text="Quantity of Line Item"></asp:ListItem>
                        <asp:ListItem Text="Total Price of Line Item"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="DiscountLevelsLabel" runat="server" Text="Discount Levels:" ToolTip="Configure the amount of discount based on the minimum and maximum values.  The value ranges are based on either quantity or value purchased as configured above."></cb:ToolTipLabel><br />
                </th>
                <td colspan="3">
                    <asp:UpdatePanel ID="DiscountGridAjax" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:GridView ID="DiscountLevelGrid" runat="server" AutoGenerateColumns="false" HorizontalAlign="Left" Width="80%" SkinID="PagedList" OnPreRender="DiscountLevelGrid_PreRender" OnRowDataBound="DiscountLevelGrid_RowDataBound" OnRowDeleting="DiscountLevelGrid_OnRowDeleting">
                                <Columns>
                                    <asp:TemplateField HeaderText="Minimum">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MinValue" runat="server" Text='<%#GetLevelValue(((VolumeDiscountLevel)Container.DataItem).MinValue)%>' Width="75" MaxLength="10"></asp:TextBox>                                                    
                                            <asp:RangeValidator ID="MinValueRangeValidator" runat="server" Text="*" Type="currency" ErrorMessage="Minimum value should be between 0 and 99999999.99" ControlToValidate="MinValue" MinimumValue="0" MaximumValue="99999999.99" >
                                            </asp:RangeValidator>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Maximum">
                                        <ItemTemplate>
                                            <asp:TextBox ID="MaxValue" runat="server" Text='<%#GetLevelValue(((VolumeDiscountLevel)Container.DataItem).MaxValue)%>' Width="75" MaxLength="10"></asp:TextBox>
                                            <asp:RangeValidator ID="MaxValueRangeValidator1" runat="server" Text="*" Type="currency" ErrorMessage="Maximum value should be between 0 and 99999999.99" ControlToValidate="MaxValue" MinimumValue="1" MaximumValue="99999999.99"/>
                                            <asp:CompareValidator ID="MinMaxCompareValidator" runat="server" Text="*"  ControlToValidate="MaxValue" ControlToCompare="MinValue" 
                                                ErrorMessage="Maximum value can not be less then minimum value" Operator="GreaterThanEqual" Type="currency"></asp:CompareValidator>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Discount" ItemStyle-Wrap="false" HeaderStyle-HorizontalAlign="Left">
                                        <ItemTemplate>
                                            <asp:TextBox ID="DiscountAmount" runat="server" Text='<%#Eval("DiscountAmount", "{0:0.##}")%>' Width="75" MaxLength="10"></asp:TextBox>
                                            <asp:RangeValidator ID="DiscountAmountValidator" runat="server" Text="*" Type="currency" ErrorMessage="Discount amount should be between 0 and 99999999.99" ControlToValidate="DiscountAmount" MinimumValue="0" MaximumValue="99999999.99" />
                                            <asp:DropDownList ID="IsPercent" runat="server" >
                                                <asp:ListItem Text="Percent (%)" ></asp:ListItem>
                                                <asp:ListItem Text="Fixed Amount" ></asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DeleteRowButton" runat="server" AlternateText="Delete Row" SkinID="DeleteIcon" CommandName="Delete"  OnClientClick="return confirm('Are you sure you want to delete this row?')"/>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <br clear="left" />                  
                            <asp:Button id="AddRowButton" runat="server" Text="Add Row" SkinID="AddButton" OnClick="AddRowButton_Click" CausesValidation="true"></asp:Button>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="ScopeLabel" runat="server" Text="Discount Scope:" ToolTip="Manage the categories and products that the discount applies to."></cb:ToolTipLabel>
                </th>
                <td colspan="3">
                    <asp:UpdatePanel ID="ScopeAjax" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:RadioButtonList ID="UseGlobalScope" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UseGlobalScope_SelectedIndexChanged">
                                <asp:ListItem Text="Global"></asp:ListItem>
                                <asp:ListItem Text="Specific" Selected="true"></asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:Panel ID="ScopePanel" runat="server">
                                <div style="padding-left:20px">
                                    <cb:ToolTipLabel ID="Scope" runat="server" Text="{0} Categories and {1} Product(s) selected"></cb:ToolTipLabel>
                                    <br />
                                    <asp:LinkButton ID="EditDiscountScope" runat="server" Text="Change" SkinID="Link" OnClick="EditDiscountScope_Click"></asp:LinkButton>
                                </div>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <asp:HiddenField ID="hdnScope" runat="server" />
                </td>
            </tr>
            <tr>
                <th valign="top">
                    <cb:ToolTipLabel ID="GroupsLabel" runat="server" Text="Groups:" ToolTip="Indicate whether only users that belong to specific groups can have this discount applied." />
                </th>
                <td colspan="3">
                    <asp:UpdatePanel ID="GroupRestrictionAjax" runat="server" UpdateMode="conditional">
                        <ContentTemplate>
                            <asp:RadioButtonList ID="UseGroupRestriction" runat="server" AutoPostBack="true" OnSelectedIndexChanged="UseGroupRestriction_SelectedIndexChanged">
                                <asp:ListItem Text="All Groups" Selected="true"></asp:ListItem>
                                <asp:ListItem Text="Selected Groups"></asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:Panel ID="GroupListPanel" runat="server" Visible="false">
                                <div style="padding-left:20px">
                                    <asp:CheckBoxList ID="GroupList" runat="server" DataTextField="Name" DataValueField="GroupId" RepeatColumns="3"></asp:CheckBoxList>
                                </div>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td colspan="3">
                    <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="Confirm();" />
                    <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click" OnClientClick="Confirm();"></asp:Button>
					<asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="False" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>