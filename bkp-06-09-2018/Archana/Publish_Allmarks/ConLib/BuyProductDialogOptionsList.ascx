<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.BuyProductDialogOptionsList" CodeFile="BuyProductDialogOptionsList.ascx.cs" %>
<%--
<conlib>
<summary>Displays product basic details and add-to-cart buttons for each variant combination. This control should not be used with products having more than 8 options.</summary>
<param name="ShowSku" default="True">If true SKU is displayed</param>
<param name="ShowPartNumber" default="False">If true Part/Model number is displayed</param>
<param name="ShowPrice" default="True">If true Price is displayed</param>
<param name="ShowSubscription" default="True">If true product description is displayed</param>
<param name="ShowMSRP" default="True">If true MSRP is displayed</param>
</conlib>
--%>

<%@ Register Src="~/ConLib/Utility/ProductPrice.ascx" TagName="ProductPrice" TagPrefix="uc" %>
<script type="text/javascript">
    function ShowNotification(link)
    {
        $(link).siblings('table').css('display', 'block');
        $(link).css('display', 'none');
        return false;
    }
</script>
<asp:UpdatePanel ID="BuyProductPanel" runat="server" UpdateMode="Always">
<ContentTemplate>
    <asp:Button ID="DummyButtonForEnterSupress" runat="server" Text="" OnClientClick="return false;" style="display:none;" />
    <asp:Panel ID="ContentPanel" runat="server" DefaultButton="DummyButtonForEnterSupress">
        <asp:Label ID="SavedMessage" runat="server" Text="Data saved at {0:g}" EnableViewState="false" Visible="false" CssClass="goodCondition"></asp:Label>
            <div id="BuyProductOptionsList">
            <cb:ExGridView ID="VariantGrid" runat="server" AutoGenerateColumns="False" Width="100%" SkinID="PagedList" DataKeyNames="OptionList" OnRowCommand="VariantGrid_RowCommand" OnRowCreated="VariantGrid_RowCreated" OnRowDataBound="VariantGrid_RowDataBound">
                <Columns>			
                </Columns>
            </cb:ExGridView>
        </div>
    </asp:Panel>
</ContentTemplate>
</asp:UpdatePanel>