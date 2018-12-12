<%@ Page Language="C#" MasterPageFile="~/Admin/Products/Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Variants.EditChoices" Title="Option Choices" CodeFile="EditChoices.aspx.cs" %>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="javascript" type="text/javascript">
        function ValidateMaxOneSelected() {
            var gridview = $("#<%=OptionChoicesGrid.ClientID%>");
            var checked = $(gridview).find("input:checkbox:checked");
            if (checked.length > 1) alert("You can not set more then one choices as 'Selected'.");
            return checked.length <= 1;
        }
    </script>
    <div class="pageHeader">
        <div class="caption">
            <h1><asp:Localize ID="Caption" runat="server" Text="Option Choices for {0}" EnableViewState="false"></asp:Localize></h1>
        </div>
    </div>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="content">
                <cb:Notification ID="UpdateMessage" runat="server" Text="Option Choice(s) saved at {0:t}" SkinID="GoodCondition" EnableViewState="False" Visible="false"></cb:Notification>
                <p><asp:Label ID="InstructionText" runat="server" Text="Edit the choices for this option below.  If all variants associated with a particular choice share a common modifier to price, weight, or SKU, you can enter the modifier here so that the values can be automatically calculated.  For example if you are selling a T-Shirt with options for color and size, and all Extra Large sizes are a dollar extra, you can enter the cost here. Then all colors will be an extra dollar when purchased in extra large size.  Use the manage variants feature to see and override your calculated values." EnableViewState="false"></asp:Label></p>
                <asp:GridView ID="OptionChoicesGrid" runat="server" AutoGenerateColumns="False"
                    ShowFooter="False" SkinID="PagedList" OnRowDataBound="OptionChoicesGrid_RowDataBound" DataKeyNames="OptionChoiceId"
                    OnRowCommand="OptionChoicesGrid_RowCommand" OnRowDeleting="OptionChoicesGrid_RowDeleting"
                    Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="Order">
                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="UpButton" runat="server" SkinID="UpIcon" CommandName="MoveUp" CommandArgument='<%#Container.DataItemIndex%>' CausesValidation="false" AlternateText="Move Up" />
                                <asp:ImageButton ID="DownButton" runat="server" SkinID="DownIcon" CommandName="MoveDown" CommandArgument='<%#Container.DataItemIndex%>' CausesValidation="false" AlternateText="Move Down" />
                            </ItemTemplate>
                        </asp:TemplateField>                
                        <asp:TemplateField HeaderText="Name">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="Name" runat="server" Text='<%# Eval("Name") %>' Width="95px"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Price">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="PriceMod" runat="server" Text='<%# ZeroAsEmpty(Eval("PriceModifier")) %>' Width="60px" MaxLength="8"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Retail">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="RetailMod" runat="server" Text='<%# ZeroAsEmpty(Eval("MsrpModifier")) %>' Width="60px" MaxLength="8"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Weight">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="WeightMod" runat="server" Text='<%# ZeroAsEmpty(Eval("WeightModifier")) %>' Width="60px" MaxLength="8"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sku">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="SkuMod" runat="server" Text='<%# Eval("SkuModifier") %>' Width="60px" MaxLength="8"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Thumbnail">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="ThumbnailUrl" runat="server" Text='<%# Eval("ThumbnailUrl") %>' Width="133px"></asp:TextBox>
                                <asp:ImageButton ID="BrowseThumbnailUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Image">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:TextBox ID="ImageUrl" runat="server" Text='<%# Eval("ImageUrl") %>' Width="133px"></asp:TextBox>
                                <asp:ImageButton ID="BrowseImageUrl" runat="server" SkinID="FindIcon" AlternateText="Browse" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Selected">
                            <ItemStyle HorizontalAlign="Center" />
                            <ItemTemplate>
                                <asp:CheckBox ID="Selected" runat="server" Checked='<%# Eval("Selected") %>'></asp:CheckBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="40px" ItemStyle-HorizontalAlign="Center" ShowHeader="False">
                            <ItemTemplate>
                                <asp:ImageButton ID="DeleteButton" runat="server" SkinID="DeleteIcon" CommandName="Delete" OnClientClick="javascript:return confirmDel()" CausesValidation="false" AlternateText="Delete" />
                            </ItemTemplate>
                        </asp:TemplateField>                    
                    </Columns>
                    <EmptyDataTemplate>
                        <asp:Localize ID="NoChoiceMessage" runat="server" Text="There are no choices for this option. Use 'Add Option Choice' dialog to add choices."></asp:Localize>
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" CausesValidation="false" OnClientClick="return ValidateMaxOneSelected();" />
                <asp:Button ID="SaveCloseButton" runat="server" Text="Save And Close" SkinID="SaveButton" OnClick="SaveCloseButton_Click" CausesValidation="false" OnClientClick="return ValidateMaxOneSelected();"/>
			    <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click" CausesValidation="false" />
            </div>
            <asp:Panel ID="AddChoicePanel" runat="server" CssClass="section" DefaultButton="AddChoiceButton">
                <div class="header">
                    <h2><asp:Localize ID="AddChoiceCaption" runat="server" Text="Add Option Choice"></asp:Localize></h2>
                </div>
                <div class="content">
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" />
                    <cb:Notification ID="SavedMessage" runat="server" Text="Your choice has been added." SkinID="GoodCondition" EnableViewState="false" Visible="false"></cb:Notification>
                    <table class="inputForm">
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddChoiceNameLabel" runat="server" Text="Name:" AssociatedControlID="AddChoiceName" ToolTip="The name of the option as it will be displayed to the customer." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoiceName" runat="server" Width="160px"></asp:TextBox><span class="requiredField">*</span>
                                <asp:RequiredFieldValidator ID="OptionsRequired" runat="server" ErrorMessage="At least one option name must be specified." Text="*" Display="Dynamic" ControlToValidate="AddChoiceName"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddChoicePriceModLabel" runat="server" Text="Price Modifier:" ToolTip="If the price of the product is changed when this choice is selected enter the amount it is changed by.  Values can be positive or negative." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoicePriceMod" runat="server" width="60px" MaxLength="8"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddChoiceRetialModLabel" runat="server" Text="Retail Modifier:" ToolTip="If the retail price of the product is changed when this choice is selected enter the amount it is changed by.  Values can be positive or negative." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoiceRetialMod" runat="server" width="60px" MaxLength="8"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddChoiceWeightModLabel" runat="server" Text="Weight Modifier:" ToolTip="If the weight of the product is changed when this choice is selected enter the amount it is changed by.  Values can be positive or negative." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoiceWeightMod" runat="server" width="60px" MaxLength="8"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="AddChoiceSkuModLabel" runat="server" Text="Sku Modifier:" ToolTip="If the SKU of the product is changed when this choice is selected enter the text to append to the product sku.  SKU modifiers are applied according the sort order of the options." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoiceSkuMod" runat="server" width="60px" MaxLength="8"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trAddChoiceThumbnail" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="AddChoiceThumbnailLabel" runat="server" Text="Thumbnail:" ToolTip="Select the thumbnail image that will be shown for this option." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoiceThumbnail" runat="server" width="300px"></asp:TextBox><span class="requiredField">*</span>
                                <asp:ImageButton ID="BrowseThumbnail" runat="server" SkinID="FindIcon" />
                                <asp:RequiredFieldValidator ID="AddChoiceThumbnailRequried" Enabled="false" runat="server" ErrorMessage="Thumbnail is required because this option is set to show thumbnails." Text="*" Display="Dynamic" ControlToValidate="AddChoiceThumbnail"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr id="trAddChoiceImage" runat="server">
                            <th>
                                <cb:ToolTipLabel ID="AddChoiceImageLabel" runat="server" Text="Image:" ToolTip="Select the full sized image for this choice.  The regular product image will be swapped for this image when a customer selects this choice.  Full sized images are optional." />
                            </th>
                            <td>
                                <asp:TextBox ID="AddChoiceImage" runat="server" width="300px"></asp:TextBox>
                                <asp:ImageButton ID="BrowseImage" runat="server" SkinID="FindIcon" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <cb:ToolTipLabel ID="SelectedLabel" runat="server" Text="Selected:" ToolTip="Helps you mark the default selection." />
                            </th>
                            <td>
                                <asp:CheckBox ID="Selected" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><asp:Button ID="AddChoiceButton" runat="server" SkinID="AddButton" Text="Add Option Choice" OnClick="AddChoiceButton_Click" /></td>
                        </tr>
                    </table>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>