<%@ Page Language="C#" MasterPageFile="~/Admin/Products/Product.master" AutoEventWireup="True" CodeFile="EditVolumePricing.aspx.cs" Inherits="AbleCommerce.Admin.Products.EditVolumePricing" Title="Add/Edit Volume Pricing" EnableViewState="true" ViewStateMode="Disabled" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="pageHeader">
    	<div class="caption">
    		<h1>
                <asp:Localize ID="AddCaption" runat="server" Text="Add Volume Pricing"></asp:Localize>
                <asp:Localize ID="EditCaption" runat="server" Text="Edit '{0}'"></asp:Localize>
            </h1>
    	</div>
    </div>
    <table cellpadding="2" cellspacing="0" class="innerLayout">
        <tr>
            <td align="center">
                <asp:ValidationSummary ID="DetailValidationSummary" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <table cellpadding="4" cellspacing="0" class="inputForm">
                    <tr>
                        <th class="rowHeader" valign="top">
                            <cb:ToolTipLabel ID="DiscountLevelsLabel" runat="server" Text="Discount Levels:" ToolTip="Configure volume based pricing for this product."></cb:ToolTipLabel><br />
                        </th>
                        <td colspan="3">
                            <asp:UpdatePanel ID="DiscountGridAjax" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Gridview ID="DiscountLevelGrid" runat="server" AutoGenerateColumns="false" Width="100%" SkinID="Summary" OnPreRender="DiscountLevelGrid_PreRender" OnRowDataBound="DiscountLevelGrid_RowDataBound" OnRowDeleting="DiscountLevelGrid_OnRowDeleting">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Minimum">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="MinValue" runat="server" Text='<%#GetLevelValue(((VolumeDiscountLevel)Container.DataItem).MinValue)%>' Columns="8" MaxLength="10"></asp:TextBox>                                                    
                                                    <asp:RangeValidator ID="MinValueRangeValidator" runat="server" Text="*" Type="currency" ErrorMessage="Minimum value should be between 0 and 99999999.99" ControlToValidate="MinValue" MinimumValue="0" MaximumValue="99999999.99" >
                                                    </asp:RangeValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Maximum">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="MaxValue" runat="server" Text='<%#GetLevelValue(((VolumeDiscountLevel)Container.DataItem).MaxValue)%>' Columns="8" MaxLength="10"></asp:TextBox>
                                                    <asp:RangeValidator ID="MaxValueRangeValidator1" runat="server" Text="*" Type="currency" ErrorMessage="Maximum value should be between 0 and 99999999.99" ControlToValidate="MaxValue" MinimumValue="1" MaximumValue="99999999.99"/>
                                                    <asp:CompareValidator ID="MinMaxCompareValidator" runat="server" Text="*"  ControlToValidate="MaxValue" ControlToCompare="MinValue" 
                                                        ErrorMessage="Maximum value can not be less then minimum value" Operator="GreaterThanEqual" Type="currency"></asp:CompareValidator>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Unit Price (ex GST)" ItemStyle-Wrap="false" HeaderStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:TextBox ID="DiscountAmount" runat="server" Text='<%#Eval("DiscountAmount", "{0:0.##}")%>' Columns="8" MaxLength="10"></asp:TextBox>
                                                    <asp:RangeValidator ID="DiscountAmountValidator" runat="server" Text="*" Type="currency" ErrorMessage="Price should be between 0 and 99999999.99" ControlToValidate="DiscountAmount" MinimumValue="0" MaximumValue="99999999.99" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="DeleteRowButton" runat="server" AlternateText="Delete Row" SkinID="DeleteIcon" CommandName="Delete"  OnClientClick="return confirm('Are you sure you want to delete this row?')"/>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:Gridview><br />
                                    <asp:Button id="AddRowButton" runat="server" Text="Add Row" OnClick="AddRowButton_Click" CausesValidation="true"></asp:Button>                                    
                                </ContentTemplate>
                            </asp:UpdatePanel>
                       </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="submit">                            
                            <asp:Button ID="SaveButton" runat="server" Text="Save" OnClick="SaveButton_Click" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</asp:Content>