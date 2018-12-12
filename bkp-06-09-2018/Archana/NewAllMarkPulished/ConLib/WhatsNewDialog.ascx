<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.WhatsNewDialog" CodeFile="WhatsNewDialog.ascx.cs" %>
<%--
<conlib>
<summary>Display new products.</summary>
<param name="Columns" default="1">The number of columns to display.</param>
<param name="Caption" default="What's New">Caption / Title of the control</param>.
<param name="MaxItems" default="3">The maximum number of products that can be shown.</param>
<param name="Days" default="30">Possible value can be any integer greater then zero. Indicates the number of days to take into consideration for deciding newness of products.</param>
<param name="UseDays" default="true">Possible values can be 'true' or 'false'. Indicates whether to use days for deciding the newness of products.</param>
 </conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc1" %>
<div id="phContent" runat="server" class="widget whatsNewDialog">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="What's New" /></h2>
        </div>   
        <div class="content"> 
            <div class="whatsNewListing">
		        <div class="itemListingContainer">
                    <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="1" RepeatDirection="Horizontal" Width="100%" CssClass="itemListing" SkinID="ItemList" >
                        <ItemStyle HorizontalAlign="center" CssClass="tableNode" />
                        <ItemTemplate>
                            <div class="itemContainer">
					            <uc1:ProductItemDisplay ID="WhatsNewItem" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="true" ShowSku="false" ShowManufacturer="true" ShowRating="true" ShowAddToCart="true" />
				            </div>   
                        </ItemTemplate>
                    </cb:ExDataList>
                </div>
            </div>
       </div>
    </div>
</div>
