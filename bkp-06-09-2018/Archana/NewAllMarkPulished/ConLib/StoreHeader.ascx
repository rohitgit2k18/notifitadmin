<%@ Control Language="C#" AutoEventWireup="True" CodeFile="StoreHeader.ascx.cs" Inherits="AbleCommerce.ConLib.StoreHeader" %>
<%--
<conlib>
<summary>Displays the standard store header.</summary>
</conlib>
--%>
<link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="manifest" href="/manifest.json">
<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">


<meta name="theme-color" content="#ffffff">
<%@ Register src="~/ConLib/Utility/SimpleSearch.ascx" tagname="SimpleSearch" tagprefix="uc" %>
<%@ Register src="~/ConLib/StoreLogo.ascx" tagname="StoreLogo" tagprefix="uc" %>
<% if (ShowBannerDetails) { %>
<div id="storeHeader" class="header-container">
<% } else { %>
<div id="storeHeader">
<% } %>
	<div id="headerTop" class="nav navbar-default navbar-top-fixed xs-hidden">
		<div class="column_1">
			<div class="logo">
			   <uc:StoreLogo ID="StoreLogo1" runat="server" />
			</div>
		</div>
		<div class="column_2">
			<div class="shortcuts">
                <div class="innerSection">
                <asp:UpdatePanel ID="TopHeaderLinksAjax" runat="server">
                    <ContentTemplate>
                        <div class="content">
                            
                            <%if (!IsBootstrap) { %>
                            <asp:HyperLink ID="WishlistLink" runat="server" NavigateUrl="~/Members/MyWishlist.aspx" class="wishlist" Text="Wishlist" >
                            <asp:Localize ID="WishListCount" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>
				            </asp:HyperLink>
                            <asp:HyperLink ID="BasketLink" runat="server" NavigateUrl="~/Basket.aspx" class="basket" Text="Cart">
                            <asp:Localize ID="ItemCount" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>
                            </asp:HyperLink>
                            <% } else { %>
                            <ul class="nav nav-pills xs-hidden" id="mainNav">
                                
                            <li ><a href="#home" class="active"> HOME</a></li>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#about"> About Us</a></li>
                                <%-- Edit By Rahul  --%>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#solution"> Solutions</a></li>
                                <%-- Edit By Rahul  --%>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#product"> Products</a></li>
                                <%-- Edit By Rahul  --%>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#case"> Case Studies</a></li>
                                <%-- Edit By Rahul  --%>
                                

                            <li><a href="#faq"> FAQS</a></li>

                                
                            
                                <li><a href="#contact"> CONTACT</a></li>

                             <%-- Edit By Archana  --%>
                                <asp:HyperLink ID="HomeSiteLink" runat="server" NavigateUrl="~/"></asp:HyperLink>
                                <asp:HyperLink ID="FAQLink" runat="server" NavigateUrl="~/FAQ-W16.aspx"></asp:HyperLink>
                                <asp:HyperLink ID="ContactUsLink" runat="server" NavigateUrl="~/ContactUs.aspx"></asp:HyperLink>
                                  <asp:Localize ID="BootWishListCount" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>
                                 <asp:Localize ID="BootItemCount" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>

                           <%-- <li class="basket"><asp:HyperLink ID="BootWishlistLink" runat="server" NavigateUrl="~/Members/MyWishlist.aspx">WISHLIST
                                <asp:Localize ID="BootWishListCount" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>
				            </asp:HyperLink></li>

                            <li class="basket"><asp:HyperLink ID="BootBasketLink" runat="server" NavigateUrl="~/Basket.aspx">MY CART
                                <asp:Localize ID="BootWishListCount" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>
                            </asp:HyperLink></li>--%>
                                <%-- End By Archana  --%>

                            <li><div class="phone-number" x-ms-format-detection="none">
                                <img src="Assets/Images/phone.png" alt="phone" /> </span> 08 9328 3977</div></li>
                            </ul>

                            <% } %>
                        </div>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
            <% if(!IsBootstrap) { %>
			<div class="search">
				<uc:SimpleSearch ID="SimpleSearch1" runat="server" />
			</div>
            <% } %>
		</div>
	</div>
 

	<div id="headerNavigation">
		<div class="navigation">
            <% if(!IsBootstrap) { %>
			<asp:HyperLink ID="HomeLink" runat="server" NavigateUrl="~/" CssClass="tab" Text="Home" />
			<asp:HyperLink ID="SearchLink" runat="server" NavigateUrl="~/Search.aspx" CssClass="tab" Text="Product Finder" />
			<asp:HyperLink ID="AdvSearchLink" runat="server" NavigateUrl="~/AdvancedSearch.aspx" CssClass="tab" Text="Advanced Search" />
			<asp:HyperLink ID="CurrencyLink" runat="server" NavigateUrl="~/Currencies.aspx" CssClass="tab" Text="Currencies" />
			<asp:HyperLink ID="ContactLink" runat="server" NavigateUrl="~/ContactUs.aspx" CssClass="tab" Text="Contact Us" />
            <% } else { %>
            <nav class="navbar navbar-default" role="navigation">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header visible-xs">
                    <button data-target=".navbar-ex1-collapse" data-toggle="collapse" class="navbar-toggle" type="button">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <asp:HyperLink ID="NavBasketLink" runat="server" NavigateUrl="~/Basket.aspx" class="nav-basket"></asp:HyperLink>
                    <asp:HyperLink ID="HomeButton" runat="server" NavigateUrl="~/" CssClass="navbar-brand">
                        <asp:Image ID="BrandIcon" runat="server" />
                    </asp:HyperLink>
                </div>
                
                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse navbar-ex1-collapse">
                    <ul class="nav navbar-nav">
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="/"></asp:HyperLink>
                        <%-- Edit By Rahul  --%>
                        <li><a href="#home">HOME</a></li>
                         <%-- Edit By Rahul  --%>

                        <%-- Edit By Rahul  --%>
                            <li><a href="#about">About Us</a></li>
                                <%-- Edit By Rahul  --%>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#solution">Solutions</a></li>
                                <%-- Edit By Rahul  --%>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#product">Products</a></li>
                                <%-- Edit By Rahul  --%>
                                <%-- Edit By Rahul  --%>
                            <li><a href="#case">Case Studies</a></li>
                                <%-- Edit By Rahul  --%>
                        <%-- Edit By Rahul  --%>
                        <li><a href="#faq">FAQS</a></li>
                        <%-- Edit By Rahul  --%>
                        <%-- Edit By Rahul  --%>
                        <li><a href="#contact">CONTACT US</a></li>
                        <%-- Edit By Rahul  --%>


                        <asp:HyperLink ID="BootNavFaqLink" runat="server" NavigateUrl="~/FAQ-W16.aspx"> </asp:HyperLink>
			            
                        <asp:HyperLink ID="BootNavContactLink" runat="server" NavigateUrl="~/ContactUs.aspx"></asp:HyperLink>
			            

                        <%-- Comment Wish List By Rahul --%>
                        <asp:Localize ID="BootWishListCount2" runat="server" Text=" ({0})" EnableViewState="false"></asp:Localize>

                        <%--<li><asp:HyperLink ID="BootNavWishListLink" runat="server" NavigateUrl="~/Members/MyWishlist.aspx" CssClass="tab" Text="Wishlist">WISHLIST ></asp:HyperLink></li>--%>
                        
                        <%-- Comment Wish List By Rahul --%>
                    </ul>
                    <div class="search">
				        <uc:SimpleSearch ID="SimpleSearch2" runat="server"/>
			        </div>
                </div>
            </nav>
            <% } %>
		</div>
	</div>
	<div id="headerBottom">
	</div>
</div>
<%--<% if (ShowBannerDetails) { %>
<div class="banner-details">
    <div class="col-lg-12 col-md-12 col-xs-12 text-center uspar">
      <p>
        <span class="usp">
          <span class="bock glyphicon glyphicon-ok"></span> Local Manufacturer
        </span>
        <span class="usp">
          <span class="bock glyphicon glyphicon-ok"></span> Fast Service
        </span>
        <span class="usp">
          <span class="bock glyphicon glyphicon-ok"></span> Quality Workmanship
        </span>
      </p>        
    </div>
</div>
<% } %>--%>
    <style>
        .phone-number {
    margin-top: 10px;
    color: #38bfb8;
    font-weight: normal;
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    padding-top: 25px;
}
        .phone-number img {
    width: 47px;
    display: inline-block;
    margin-top: -12px;
    margin-right: 7px;
}
.nav>li>a {
    padding-top: 60px;
    margin-top: -50px;
    padding-bottom: 40px;
    border-radius: 0px;
    padding-left: 6px;
    padding-right:6px;
    text-transform: uppercase;
    margin-bottom: 10px;
}

.nav>li>a:hover, .nav>li>a:focus{
            background: -webkit-linear-gradient(rgba(229, 237, 255, 0.09), #8aadd5);
        background-color: ;
        background-image: ;
        background-repeat: ;
        background-attachment: ;
        background-position: ;
        background-clip: ;
        background-origin: ;
        background-size: ;
    color: #fff;
    background: -moz-linear-gradient(rgba(229, 237, 255, 0.09), #8aadd5);

}
    #storeHeader.header-container{margin-bottom:0px;}

        @media (max-width: 991px) {

            .nav-pills > li {
                float: left;
                margin-top: 24px;
                margin-bottom: -20px;
            }
        }
        @media (min-width: 768px) {

            .phone-number{
                    margin-top: -21px;
            }

            .nav-pills > li {
                float: left;
                margin-top: 24px;
                margin-bottom: -20px;
            }
        }
    </style>

    <script>
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
         
    </script>
