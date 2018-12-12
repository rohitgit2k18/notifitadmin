<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.FeaturedProductsGrid" EnableViewState="false" CodeFile="FeaturedProductsGrid.ascx.cs" %>
<%@ Register src="~/ConLib/Utility/ProductRatingStars.ascx" tagname="ProductRatingStars" tagprefix="uc1" %>
<%--
<conlib>
<summary>Displays featured products</summary>
<param name="IncludeOutOfStockItems" default="False">If true out of stock items are also included for display</param>
<param name="Caption" default="Featured Products">The caption / title of the control</param>
<param name="Size" default="4">Same as MaxItems</param>
<param name="MaxItems" default="4">The maximum number of featured products that can be shown.</param>
<param name="Columns" default="2">The number of columns to display in the grid.</param>
</conlib>
--%>
<%@ Register src="~/ConLib/Utility/ProductItemDisplay.ascx" tagname="ProductItemDisplay" tagprefix="uc2" %>

<div id="product" class="widget featuredProductsGrid">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Featured Products"></asp:Localize></h2>
        </div>
        <div class="content">
          <div class="featuredProductListing">
			<div class="itemListingContainer">			
                <cb:ExDataList ID="ProductList" runat="server" RepeatColumns="2" RepeatDirection="Horizontal" Width="100%" DataKeyField="ProductId" SkinID="ItemGrid">
                    <ItemTemplate>
	                    <div class="itemContainer">
                            <uc2:ProductItemDisplay ID="FeaturedItem" runat="server" Item='<%#(CommerceBuilder.Products.Product)Container.DataItem%>' ShowImage="true" ImageType="THUMBNAIL" ShowPrice="true" ShowSku="false" ShowManufacturer="true" ShowRating="true" ShowAddToCart="true"  />
					    </div>
                    </ItemTemplate>
                </cb:ExDataList>
            </div>
        </div>
    </div>
</div>
</div>



<div id="outerPageContainer">
<div id="innerPageContainer">
<div id="header">
<div class="zone">
<div class="section">
<div class="content">
<div id="storeHeader" class="header-container">
<div id="headerTop" class="nav navbar-default navbar-top-fixed xs-hidden">
<div class="column_1">
<div class="logo">
<div class="storeLogo"><a id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_StoreLogo1_LogoLink" href="./"><img id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_StoreLogo1_Logo" src="App_Themes/Bootstrap_Responsive/images/logo.png" alt="Arrow  Logo" /></a></div>
</div>
</div>
<div class="column_2">
<div class="shortcuts">
<div class="innerSection">
<div id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_TopHeaderLinksAjax">
<div class="content">
<ul id="mainNav" class="nav nav-pills xs-hidden">
<li><a class="active" href="#home"> HOME</a></li>
<li><a href="#about"> About Us</a></li>
<li><a href="#solution"> Solutions</a></li>
<li><a href="#product"> Products</a></li>
<li><a href="#case"> Case Studies</a></li>
<li><a href="#faq"> FAQS</a></li>
<li><a href="#contact"> CONTACT</a></li>
<li>
<div class="phone-number"><img src="Assets/Images/phone.png" alt="phone" /> 08 9328 3977</div>
</li>
</ul>
</div>
</div>
</div>
</div>
</div>
</div>
<div id="headerNavigation">
<div class="navigation"><!-- Brand and toggle get grouped for better mobile display -->
<div class="navbar-header visible-xs"><button class="navbar-toggle" type="button" data-target=".navbar-ex1-collapse" data-toggle="collapse"> <span class="sr-only">Toggle navigation</span> </button> <a id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_HomeButton" class="navbar-brand" href="./"><img id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_BrandIcon" src="App_Themes/Bootstrap_Responsive/images/logo.png" alt="" /></a></div>
<!-- Collect the nav links, forms, and other content for toggling -->
<div class="collapse navbar-collapse navbar-ex1-collapse">
<ul class="nav navbar-nav">
<li><a href="#home">HOME</a></li>
<li><a href="#about">About Us</a></li>
<li><a href="#solution">Solutions</a></li>
<li><a href="#product">Products</a></li>
<li><a href="#case">Case Studies</a></li>
<li><a href="#faq">FAQS</a></li>
<li><a href="#contact">CONTACT US</a></li>
</ul>
<div class="search">
<script type="text/javascript">// <![CDATA[
    $(function () {
        $(".searchPhrase").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "Search.aspx/Suggest",
                    data: "{ 'term': '" + request.term + "' }",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataFilter: function (data) { return data; },
                    success: function (data) {
                        response($.map(data.d, function (item) {
                            return {
                                value: item
                            }
                        }))
                    }
                });
            },
            minLength: 2
        });
    });
    // ]]></script>
<div class="simpleSearchPanel">
<div id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_SimpleSearch2_SearchPanel" class="innerSection">
<div style="display: none;">&nbsp;</div>
<div class="input-group"><input id="ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_SimpleSearch2_SearchPhrase" class="form-control-inline" style="width: 100%;" onkeydown="if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('ctl00_ctl00_NestedMaster_PageHeader_StoreHeader_H_SimpleSearch2_SearchLink').click();return false;}} else {return true}; " type="text" name="ctl00$ctl00$NestedMaster$PageHeader$StoreHeader_H$SimpleSearch2$SearchPhrase" maxlength="60" /></div>
</div>
</div>
</div>
</div>
</div>
</div>
<div id="headerBottom">&nbsp;</div>
</div>
<script type="text/javascript">// <![CDATA[
    $(document).ready(function () {
        $(document).on("scroll", onScroll);

        //smoothscroll
        $('.nav-pills li a[href^="#"]').on('click', function (e) {
            e.preventDefault();
            $(document).off("scroll");

            $('.nav-pills li a').each(function () {
                $(this).removeClass('active');
            })
            $(this).addClass('active');

            var target = this.hash,
                menu = target;
            $target = $(target);
            $('html, body').stop().animate({
                'scrollTop': $target.offset().top + 2
            }, 500, 'swing', function () {
                window.location.hash = target;
                $(document).on("scroll", onScroll);
            });
        });
    });

    function onScroll(event) {

        var scrollPos = $(document).scrollTop();
        $('.nav-pills li a').each(function () {
            var currLink = $(this);
            var refElement = $(currLink.attr("href"));
            if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
                $('.nav-pills li a').removeClass("active");
                currLink.addClass("active");
            }
            else {
                currLink.removeClass("active");
            }
        });
    }
    // ]]></script>
</div>
</div>
</div>
</div>
</div>
</div>


























