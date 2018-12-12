<%@ Page Language="C#" MasterPageFile="~/Admin/Products/Product.master" AutoEventWireup="true" Inherits="AbleCommerce.Admin.Products.Variants._Variants" Title="Product Variants" CodeFile="Variants.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<script type="text/javascript">
    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function (evt, args) { $.datepicker.setDefaults($.datepicker.regional['<%=(System.Threading.Thread.CurrentThread.CurrentCulture.Name == "en-US" ? "" : System.Threading.Thread.CurrentThread.CurrentCulture.Name) %>']); $(".pickerAndCalendar").datepicker(); });

    function toggleSelected(checkState) {
        $(".fieldNamesList input[type=checkbox]").each(function () {
            if (typeof this.checked != "undefined") {
                if (checkState == null)
                    this.checked = (!this.checked);
                else
                    this.checked = checkState;
            }
        });
    }
</script>
<asp:UpdatePanel runat="server" ID="VariantPanel" UpdateMode="Always">
    <ContentTemplate>
        <div class="pageHeader">
            <div class="caption">
                <h1><asp:Localize ID="Caption" runat="server" Text="Variants for {0}" EnableViewState="false"></asp:Localize></h1>
            </div>
        </div>
        <div class="content">
            <p><asp:Label ID="InstructionText" runat="server" Text="All the possible combinations of this product are displayed in the table below.  You can set the values such as SKU, Price, and Weight specifically for each variant if it is different from the default calculated value." EnableViewState="false"></asp:Label></p>
            <asp:PlaceHolder ID="TooManyVariantsPanel" runat="server" Visible="false" EnableViewState="false">
                <p><asp:Label ID="TooManyVariantsMessage" runat="server" Text="WARNING: The product {0} has more than {1} options.  The variant grid below is limited to the first {1} options only." EnableViewState="false"></asp:Label></p>
            </asp:PlaceHolder>
        </div>
        <asp:Panel ID="FieldSelectionPanel" runat="server">
            <table class="inputForm">
                <tr id="trFieldList" runat="server">
                    <td colspan="2">
                        <p>
                            Please select the fields to be included in variants grid for editing.
                        </p>
                        <asp:CheckBoxList ID="FieldNamesList" runat="server" CssClass="fieldNamesList" OnSelectedIndexChanged="FieldList_SelectedIndexChanged" RepeatLayout="Table" RepeatColumns="10">
                            <asp:ListItem Value="SKU">SKU</asp:ListItem>
                            <asp:ListItem Value="GTIN">GTIN</asp:ListItem>
                            <asp:ListItem Value="Price">Price</asp:ListItem>
                            <asp:ListItem Value="Retail">Retail</asp:ListItem>
                            <asp:ListItem Value="Model">Model #</asp:ListItem>
                            <asp:ListItem Value="Dimensions">Dimensions</asp:ListItem>
                            <asp:ListItem Value="Weight">Weight</asp:ListItem>
                            <asp:ListItem Value="COGS">COGS</asp:ListItem>                 
                            <asp:ListItem Value="Available">Available</asp:ListItem>
                            <asp:ListItem Value="InStock">In Stock</asp:ListItem>
                            <asp:ListItem Value="Availability">Availability Date</asp:ListItem>
                            <asp:ListItem Value="LowStock">Low Stock</asp:ListItem>
                            <asp:ListItem Value="Image">Image</asp:ListItem>
                            <asp:ListItem Value="Thumbnail">Thumbnail</asp:ListItem>
                            <asp:ListItem Value="Icon">Icon</asp:ListItem>
                            <asp:ListItem Value="HandlingCharges">Special Handling Charges</asp:ListItem>
                        </asp:CheckBoxList>
                        <br />
                        <asp:Label ID="SelectLabel" runat="server" Text="Select :" EnableViewState="false" SkinID="fieldHeader"/>
                        <a href="javascript:toggleSelected(true);">All</a>&nbsp;
                        <a href="javascript:toggleSelected(false);">None</a>                        
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="UpdateButton" runat="server" Text="Update Columns" OnClick="UpdateSelected_Click" ValidationGroup="Variant" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="PagerPanel" runat="server" EnableViewState="false" CssClass="searchPanel">
            <p><asp:Localize runat="server" ID="DisplayRangeLabel" EnableViewState="false" Text="Displaying {0:#,###} through {1:#,###} out of {2:#,###} unique variants" /></p>
            <table cellpadding="4">
                <tr>
                    <td>
                        <b>Page:</b>
                    </td>
                    <td>
                        <asp:LinkButton runat="server" ID="FirstLink" Text="&laquo; First" onclick="ChangePage" />
                        &nbsp;&nbsp;
                        <asp:LinkButton runat="server" ID="PreviousLink" Text="&laquo; Previous" onclick="ChangePage" />
                    </td>
                    <td>
                        <asp:DropDownList runat="server" ID="JumpPage" AutoPostBack="true" OnSelectedIndexChanged="ChangePage"  />
                            / <asp:Label runat="server" ID="PageCountLabel" Style="font-size:10pt" EnableViewState="true" />&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>
                        <asp:LinkButton runat="server" ID="NextLink" Text="Next &raquo;" onclick="ChangePage" />
                        &nbsp;&nbsp;
                        <asp:LinkButton runat="server" ID="LastLink" Text="Last &raquo;" onclick="ChangePage" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <div class="content">
        <div class="enableScrolling">        
            <asp:Repeater ID="VariantGrid" Runat="server" OnItemCreated="VariantGrid_ItemCreated">
            <HeaderTemplate>
	        <table cellspacing="0" class="pagedList" width="100%">
	            <tr class="header">
	                <asp:PlaceHolder ID="phVariantHeader" runat="server">
                        <th align="left"><asp:Localize ID="RowHeader" runat="server" Text="Row" EnableViewState="False"></asp:Localize></th>
	                    <th align="left"><asp:Localize ID="VariantHeader" runat="server" Text="Variant" EnableViewState="False"></asp:Localize></th>
	                </asp:PlaceHolder>
                    <asp:PlaceHolder ID="phGoogleFeedColumns" runat="server"></asp:PlaceHolder>	                    
	            </tr>
	        </HeaderTemplate>
	        <ItemTemplate>
	            <asp:PlaceHolder ID="phVariantRow" runat="server"></asp:PlaceHolder>
	        </ItemTemplate>
	        <FooterTemplate>
	        </table>
	        </FooterTemplate>
          </asp:Repeater>
      </div>
            <asp:Button ID="SaveButton" runat="server" Text="Save" SkinID="SaveButton" OnClick="SaveButton_Click" OnClientClick="this.value='Saving...';" />
            <asp:Button ID="SaveAndCloseButton" runat="server" Text="Save and Close" SkinID="SaveButton" OnClick="SaveAndCloseButton_Click" OnClientClick="this.value='Saving...';" />
            <asp:Button ID="CancelButton" runat="server" Text="Cancel" SkinID="CancelButton" OnClick="CancelButton_Click"></asp:Button>
            <cb:Notification ID="SavedMessage" runat="server" Text="Variant data saved at {0:t}" EnableViewState="false" Visible="false" SkinID="GoodCondition"></cb:Notification>
            <asp:HiddenField ID="VS_CustomState" runat="server" EnableViewState="false" />
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>