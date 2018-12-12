<%@ Page Title="Product Images" Language="C#" AutoEventWireup="true" CodeFile="ProductImages.aspx.cs" Inherits="AbleCommerce.Mobile.ProductImages" %>

<%@ Register src="~/Mobile/UserControls/NavBar.ascx" tagname="NavBar" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head id="Head1" runat="server">
	<title>Image Gallery</title>
    <cb:StylePlaceHolder ID="StylePlaceHolder1" runat="server"></cb:StylePlaceHolder>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
    <link href="../Scripts/Mobile/photoswipe/photoswipe.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="../Scripts/Mobile/photoswipe/lib/klass.min.js"></script>
	<script type="text/javascript" src="../Scripts/Mobile/photoswipe/jquery-1.6.4.min.js"></script>	
	<script type="text/javascript" src="../Scripts/Mobile/photoswipe/code.photoswipe.jquery-3.0.5.min.js"></script>	
	<script type="text/javascript">

	    (function (window, $, PhotoSwipe) {
	        $(document).ready(function () {
	            var options = {};
	            $("#gallery a").photoSwipe(options);
	        });
	    } (window, window.jQuery, window.Code.PhotoSwipe));
		
	</script>
</head>
<body>
<div id="productImagesPage" class="mainContentWrapper">
    <uc1:NavBar ID="NavBar" runat="server" />
    <div class="pageHeader">
		<h1><asp:Localize ID="GalleryCaption" runat="server" Text="Images of {0}"></asp:Localize></h1>
	</div>
    <div class="section">
        <div class="content">
            <div id="gallery">
                <asp:Repeater ID="MoreImagesList" runat="server">
                    <HeaderTemplate>
                        <ul>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li>
                            <a ID="ThumbnailLink" runat="server" href='<%#GetLargeImageUrl(Eval("ImageUrl").ToString())%>' rel="external">
                                <img runat="server" alt='<%#Eval("ImageAltText")%>' src='<%#GetThumbnailUrl(Eval("ImageUrl").ToString())%>' />
                            </a>
                        </li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</div>
</body>
</html>
