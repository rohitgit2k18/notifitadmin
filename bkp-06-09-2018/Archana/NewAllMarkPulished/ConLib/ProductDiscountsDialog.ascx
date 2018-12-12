<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.ProductDiscountsDialog" EnableViewState="false" CodeFile="ProductDiscountsDialog.ascx.cs" %>
<%--
<conlib>
<summary>Displays all discounts applicable on a given product.</summary>
<param name="Caption" default="Available Discounts">Caption / Title of the control</param>
</conlib>
--%>
<%@ Register Src="~/ConLib/ProductCustomFieldsDialog.ascx" TagName="CustomFields" TagPrefix="uc" %>
<div id="price-levels" class="innerSection">
    <div class="content">
        <asp:GridView ID="DiscountGrid" runat="server" AutoGenerateColumns="false" 
            Width="100%" ShowHeader="false" SkinID="PagedList">
            <Columns>
                <asp:TemplateField>
                    <ItemTemplate>
                            <%# GetLevels(Container.DataItem) %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <!-- Placeholder: Make editable rich text area on admin page -->
        <div class="text-left">
            <div class="customFieldsWrapper">
                <uc:CustomFields ID="CustomFields" runat="server" />
            </div>
        </div>
    </div>
</div>
