<%@ Control Language="C#" AutoEventWireup="True" CodeFile="StoreFooter.ascx.cs" Inherits="AbleCommerce.ConLib.StoreFooter" %>

<%--
<conlib>
<summary>Displays the standard store footer.</summary>
</conlib>
--%>
<%@ Register src="~/ConLib/UniversalGoogleAnalyticsWidget.ascx" tagname="UniversalGoogleAnalyticsWidget" tagprefix="uc" %>
<hr />
<div id="storeFooter">
	<div id="footerTop">
        <%--<div class="content carousel-wrapper">
            <div class="carousel-title"><h2>What do our customers think?</h2></div>
            <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <!--<ol class="carousel-indicators">
                    <li data-target="#carousel-example-generic" data-slide-to="0" class=""></li>
                    <li data-target="#carousel-example-generic" data-slide-to="1" class=""></li>
                    <li data-target="#carousel-example-generic" data-slide-to="2" class=""></li>
                    <li data-target="#carousel-example-generic" data-slide-to="3" class="active"></li>
                </ol>-->

                <!-- Wrapper for slides -->
                <div class="carousel-inner" role="listbox">
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"I received the name plate this morning - wow!  Well done!  An amazing job with not much to work from. Thank you so much."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Sharron Kent
                            </div>
                            <div class="carousel-company-name">
                                City of South Perth
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"Thank you very much for the plaque - the quality is impeccable and the UV printed logos are mint!"</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Tom Davies
                            </div>
                            <div class="carousel-company-name">
                                Signhere Signs
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"Thank you so very much for your fast and efficient service we are very happy."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Belinda Palmer
                            </div>
                            <div class="carousel-company-name">
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"I would just like to thank your crew for processing and delivering my label order so quickly. The labels arrived on the day I requested."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Maria Goldston
                            </div>
                            <div class="carousel-company-name">
                                Ecolab
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"I just wanted to send a big THANK YOU to you all, for your service and help with getting a small plaque done for me recently. I am very much appreciative, as I know it was only a small order, but your service was excellent and efficient within a very short time frame!"</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Penny Rennison
                            </div>
                            <div class="carousel-company-name">
                                Geraldton WA
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"A big thank you for the Honour Board.
                                    Your design team was very patient with our changes and the end result is awesome!
                                    Please pass on a big thank you from the College to all J"</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Carleen Schoch
                            </div>
                            <div class="carousel-company-name">
                                Woodvale Secondary
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"The two Stainless Steel signs look fantastic, I really appreciate that you could do this job for me so quickly and at such short notice.
                                    Cheers & thanks once again for a great job"</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Steve Groen
                            </div>
                            <div class="carousel-company-name">
                                <p>Project Manager (Exploration), Growth & Innovation</p>
                                <p>Rio Tinto</p>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"Hi Allmark, Please pass on our thanks to everyone involved. Super happy with our product. Cheers from Allure welding."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Meryn Bussell
                            </div>
                            <div class="carousel-company-name"></div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"Great service all round, will be in touch again for future work."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Bill Currans
                            </div>
                            <div class="carousel-company-name">
                                Executive Officer - Carnarvon Rangelands Biosecurity Association (CRBA) Inc.
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"I have been using Allmark for 3 years for a large range of products I require for my small business. I have only ever found the team to be exceptional in service, friendliness, quality and timeliness. Allmark are in a class of their own, meeting my high requirements time and time again. I have the upmost respect for the Allmark team and would recommend them to anyone looking for a quality product and service."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~Taryn
                            </div>
                            <div class="carousel-company-name">Excel Trophies</div>
                        </div>
                    </div>
                    <div class="item active">
                        <div class="carousel-content-container">
                            <div class="carousel-inner-container">
                                <p>"I have been using Allmark for some years for a multiple of jobs including engraving, labels, promotional caps, stubby holders and other miscellaneous projects. They have always been very accommodating and reliable with very competent staff and modern equipment that ensures a quality result every time."</p>
                            </div>
                            <div class="carousel-person-name">
                                ~John Chapman
                            </div>
                            <div class="carousel-company-name">Gemetrix</div>
                        </div>
                    </div>
                </div>
                <!-- Left and right controls -->
                <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
                </a>
            </div>
        </div>--%>
        
	</div>
	<div id="footerMiddle">
        <div class="content">
            <div class="shortcuts">
                <asp:UpdatePanel ID="FooterLinksAjax" runat="server">
                    <ContentTemplate>
                        <asp:HyperLink ID="AdminLink" runat="server" NavigateUrl="~/Admin/Default.aspx" CssClass="admin" Text="Admin" />
		                <asp:HyperLink ID="BasketLink" runat="server" NavigateUrl="~/Basket.aspx" class="basket" Text="Cart" />
		                <asp:HyperLink ID="WishlistLink" runat="server" NavigateUrl="~/Members/MyWishlist.aspx" class="wishlist" Text="Wishlist" />
		                <asp:HyperLink ID="AccountLink" runat="server" NavigateUrl="~/Members/MyAccount.aspx" class="acct" Text="Account" />
		                <asp:PlaceHolder ID="AnonymousPH1" runat="server">
				            <asp:HyperLink ID="LoginLink" runat="server" NavigateUrl="~/Login.aspx" class="login" Text="Login" />
			            </asp:PlaceHolder>
                        <asp:PlaceHolder ID="LoggedInPH1" runat="server">
				            <asp:HyperLink ID="LogoutLink" runat="server" NavigateUrl="~/Logout.aspx" class="login" Text="Logout" />
			            </asp:PlaceHolder>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <%--<div class="rss-links-footer">
                <ul class="list-unstyled rss-footer-list">
                    <li class="rss-header-title">QUICK LINKS</li>
                    <li><a href="/">Home</a></li>
                    <li><a href="/FAQ-W16.aspx">FAQ</a></li>
                    <li><a href="/AboutUs-W18.aspx">About Allmark</a></li>
                    <li><a href="/ContactUs.aspx">Contact Us</a></li>
                    <li><a href="/TermsConditions-W17.aspx">Terms & Conditions</a></li>
                </ul>
                <ul class="list-unstyled rss-footer-list">
                    <li class="rss-header-title"><a href="/Search.aspx">PRODUCTS</a></li>
                    <li><a href="/Industrial-Engraving-C12.aspx">Industrial Engraving</a></li>
                    <li><a href="/Promotional-Products-C14.aspx">Promotional Merchandise</a></li>
                    <li><a href="/Plaques-Awards-C13.aspx">Plaques and Awards</a></li>
                    <li><a href="/Signage-C17.aspx">Signage</a></li>
                </ul>
                <ul class="list-unstyled rss-footer-list">
                    <li class="rss-header-title no-title">&nbsp;</li>
                    <li><a href="/Printing-C4.aspx">Printing</a></li>
                    <li><a href="/Identification-C132.aspx">Identification</a></li>
                    <li><a href="/Badges-C7.aspx">Badges</a></li>
                    <li><a href="/Stamps-C152.aspx">Stamps</a></li>
                </ul>
                <ul class="list-unstyled rss-footer-list">
                    <li class="rss-header-title"><a href="/ContactUs.aspx">CONTACT US</a></li>
                    <li class="rss-header-title">
                        <a href="/"><img src="/App_Themes/Bootstrap_Responsive/images/logo.png" alt="Allmark"></a>
                    </li>
                    <li class="rss-list-text">
                        <div>
                            314 Charles Street, North Perth
                        </div>
                        <div>
                            WA 6006, Australia
                        </div>
                    </li>
                    <li class="rss-list-text">
                        info@allmark.com.au
                    </li>
                    <li class="rss-list-text">
                        <div>
                            Phone: <span class="phone-text">08 9328 3977</span>
                        </div>
                    </li>
                </ul>
            </div>--%>
            <!-- Contact Us Part Start from here ADDED By Rahul-->


<!-- Footer Section -->
<footer>
<div class="container">
  <div class="row">
    <div class="col-sm-10 col-md-10">
      <ul>
        <li>Copyright Allmark 2017</li>
        <li><a href="#"> Privacy</a></li>
        <li><a href="#"> Disclaimer </a></li>
        <li><a href="#"> Site By The Tank Studio</a></li>
        <li><a href="#"> Branding Perth</a></li>
        <li><a href="#"> Websites Perth</a></li>
        
      </ul>
    </div>
    <div class="col-sm-2 pull-left">
      <img src="Assets/Images/footer_logo.png" class="img-responsive" alt="Image">
    </div>
  </div>
</div>
</footer>
<!-- Footer Section ADDED By Rahul-->
        </div>
    </div>
	<%--<div id="footerBottom">
        <div class="content">
            <a href="/" target="_blank">&copy; 2016 Allmark and Associates. All Rights Reserved.</a>
		    <uc:UniversalGoogleAnalyticsWidget ID="UniversalGoogleAnalyticsWidget1" runat="server" />
        </div>
	</div>--%>
    <asp:Panel ID="MobileLinkPanel" runat="server" Visible="false" CssClass="mobileLinkPanel">
        <asp:HyperLink ID="MobileStoreLink" runat="server" NavigateUrl="#" Text="Go to Mobile Store" />
    </asp:Panel>
</div>
<!-- Google Code for Remarketing Tag -->
<!--------------------------------------------------
Remarketing tags may not be associated with personally identifiable information or placed on pages related to sensitive categories. See more information and instructions on how to setup the tag on: http://google.com/ads/remarketingsetup
--------------------------------------------------->
<script type="text/javascript">
    /* <![CDATA[ */
    var google_conversion_id = 941730315;
    var google_custom_params = window.google_tag_params;
    var google_remarketing_only = true;
    /* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/941730315/?value=0&amp;guid=ON&amp;script=0"/>
</div>
</noscript>