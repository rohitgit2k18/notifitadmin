<%@ Control Language="C#" AutoEventWireup="True" Inherits="AbleCommerce.ConLib.CategorySearchSidebar" CodeFile="CategorySearchSidebar.ascx.cs" %>
<%--
<conlib>
<summary>An ajax enabled search bar that displays products in a grid format. Allows customers to narrow and expand by category, manufacturer, and keyword in a search style interface.  This search bar must be used in conjunction with the Category Grid control.</summary>
<param name="EnableShopBy" default="True">If true any shop by template fields will listed to narrow products listings</param>
</conlib>
--%>
<asp:PlaceHolder ID="BootstrapCollaspe" runat="server" Visible="false">
<script>
    var cachedWidth = 0;
    $(window).bind('load', function () {
        initAccordian();
        cachedWidth = $(window).width();
    });

    $(window).bind('resize', function () {
        var newWidth = $(window).width();
        if (newWidth !== cachedWidth) {
            initAccordian();
            cachedWidth = newWidth;
        }
    });

    function initAccordian() {
        if ($(this).width() < 769) {
            $('.header').attr({ "data-toggle": "collapse", "data-target": "#collapseExample", "aria-expanded": "false", "aria-controls": "collapseExample" });
            $('.header').addClass("collapsed");
            $('#collapseExample').removeClass('collapse in');
            $('#collapseExample').addClass('collapse out');
            if (!$('#colexp').length)
                $('.header h2').append("<i id='colexp' class='colexpIcon'></i>");
        }
        else {
            $('.header').removeAttr("data-toggle data-target aria-expanded aria-controls");
            $('.header').removeClass("collapsed");
            $('#colexp').remove();
            $('#collapseExample').removeAttr('style');
            $('#collapseExample').removeClass('collapse in out');
        }
    }
</script>
</asp:PlaceHolder>
<div class="widget categorySearchSidebarWidget">
	<div class="innerSection">
		<div class="header">
			<h2><asp:Localize ID="SearchFilterHeader" runat="server" Text="Refine Results"></asp:Localize></h2>
		</div>
        <div class="content" id="collapseExample">
            <asp:Panel ID="ExpandResultPanel" runat="server" CssClass="criteriaPanel">
			    <h3 class="searchCriteria">Expand Your Result</h3>
                <ul class="expandCategoryLinks">
			        <asp:Repeater ID="ExpandCategoryLinks" runat="server" OnItemDataBound="ExpandCategoryLinks_ItemCreated" EnableViewState="false">
				        <ItemTemplate>
                            <li class="expandCategory">
                                <asp:HyperLink ID="ExpandByCategoryLink" runat="server" CssClass="searchCriteria"><%#Eval("Name")%> (X)</asp:HyperLink>
                            </li>
				        </ItemTemplate>
			        </asp:Repeater>
			        <li id="ExpandManufacturerListItem" runat="server" class="expandManufacturer" visible="false"><asp:HyperLink ID="ExpandManufacturerLink" runat="server" Text="" Cssclass="searchCriteria"></asp:HyperLink></li>
                    <li id="ExpandKeywordListItem" runat="server" class="expandKeyword" Visible="false"><asp:HyperLink ID="ExpandKeywordLink" runat="server" Text="" Cssclass="searchCriteria"></asp:HyperLink></li>
                    <asp:Repeater ID="ExpandShopByLinks" runat="server" OnItemDataBound="ExpandShopByLinks_ItemDataBound" EnableViewState="false">
				        <ItemTemplate>
                            <li class="expandCategory">
                                <asp:HyperLink ID="ExpandShopByLink" runat="server" CssClass="searchCriteria"><%# String.Format("{0}: {1}", Eval("FieldName"), Eval("Text")) %> (X)</asp:HyperLink>
                            </li>
				        </ItemTemplate>
			        </asp:Repeater>
                </ul>
            </asp:Panel>
            <asp:Panel ID="NarrowByCategoryPanel" runat="server" CssClass="criteriaPanel">
		        <h3 class="searchCriteria">Narrow by Category</h3>
		        <asp:DataList ID="NarrowByCategoryLinks" runat="server" DataKeyField="CategoryId" OnItemCreated="NarrowByCategoryLinks_ItemCreated">
			        <ItemTemplate>
				        <asp:HyperLink ID="NarrowByCategoryLink" runat="server" CssClass="searchCriteria">
                            <span class="itemName"><%# Eval("Name")%></span>
                            <asp:PlaceHolder ID="PHCounts" runat="server" Visible='<%#ShowProductCount %>'>
                                <span class="count">(<%#Eval("ProductCount")%>)</span>
                            </asp:PlaceHolder>
                        </asp:HyperLink>
			        </ItemTemplate>
		        </asp:DataList>
            </asp:Panel>
	        <asp:Panel ID="NarrowByManufacturerPanel" runat="server" CssClass="criteriaPanel">
	            <h3 class="searchCriteria">Narrow by Brand</h3>
		        <asp:DataList ID="ManufacturerList" runat="server" DataKeyField="ManufacturerId"  OnItemCreated="ManufacturerList_ItemCreated" EnableViewState="false">
			        <ItemTemplate>
				        <asp:HyperLink ID="NarrowByManufacturerLink" runat="server" CssClass="searchCriteria">
                            <span class="itemName"><%# Eval("Name")%></span>
                            <asp:PlaceHolder ID="PHCounts" runat="server" Visible='<%#ShowProductCount %>'>
                                <span class="count">(<%#Eval("ProductCount")%>)</span>
                            </asp:PlaceHolder>
                        </asp:HyperLink>
			        </ItemTemplate>
		        </asp:DataList>		
	            <asp:LinkButton ID="ShowAllManufacturers" runat="server" Text="See All &raquo;" CssClass="showAll" EnableViewState="false"></asp:LinkButton>
            </asp:Panel>
            <asp:Panel ID="ShopByPanel" runat="server" CssClass="criteriaPanel">
                <asp:Repeater ID="MerchantFieldRepeater" runat="server">
                    <ItemTemplate>
                        <h3><%#Eval("Name") %></h3>
                        <asp:Repeater ID="FieldChoicesRepeater" runat="server" DataSource='<%#Eval("Choices") %>' OnItemCreated="FieldChoicesRepeater_ItemCreated">
                            <HeaderTemplate>
                                <ul>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li>
                                    <asp:HyperLink ID="ChoiceLink" runat="server">
                                        <span class="itemName"><%# Eval("Text")%></span>
                                        <asp:PlaceHolder ID="PHCounts" runat="server" Visible='<%#ShowProductCount %>'>
                                            <span class="count">(<%#Eval("ProductCount")%>)</span>
                                        </asp:PlaceHolder>
                                    </asp:HyperLink>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </asp:Repeater>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>
            <asp:Panel ID="NarrowByKeywordPanel" runat="server" CssClass="criteriaPanel" DefaultButton="KeywordButton">
	            <h3 class="searchCriteria">Narrow by Keyword</h3>
                <asp:TextBox ID="KeywordField" runat="server" Width="120px" MaxLength="60" EnableViewState="false" ValidationGroup="SearchSideBar"></asp:TextBox>
                <asp:Button ID="KeywordButton" runat="server" Text="GO" EnableViewState="false"  ValidationGroup="SearchSideBar" UseSubmitBehavior="false" />
                <asp:RequiredFieldValidator ID="KeywordRequired" runat="server" ControlToValidate="KeywordField" Text="*" ErrorMessage="Keyword is required." ValidationGroup="SearchSideBar" Display="none"></asp:RequiredFieldValidator>
                <cb:SearchKeywordValidator ID="KeywordValidator" runat="server" ControlToValidate="KeywordField" Text="*" ErrorMessage="Search keyword must be at least {0} characters in length excluding spaces and wildcards." ValidationGroup="SearchSideBar" Display="none"></cb:SearchKeywordValidator>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="SearchSideBar" />
            </asp:Panel>   
        </div>
	</div>
</div>