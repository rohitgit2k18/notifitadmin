<%@ Page Language="C#" AutoEventWireup="True" CodeFile="ProductImages.aspx.cs" Inherits="AbleCommerce.ProductImages" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" >
<head id="Head1" runat="server">
	<title>Image Gallery</title>
	<script type="text/javascript" src="Scripts/mootools-for-gallery.js"></script>
	<script type="text/javascript" src="Scripts/UvumiGallery-compressed.js"></script>	
	<script type="text/javascript">
	    new UvumiGallery({ container: 'gallery' });
	</script>
</head>
<body>

<div id="OuterPageContainer" class="contentOnlyLayout"> 
   <div id="InnerPageContainer" class="contentOnlyLayout"> 
      <div id="mainColumn" class="contentOnlyLayout"> 
        <div class="Zone"> 
          <div id="productImages" class="mainContentWrapper">
			<div class="section">
			  <div class="content">
               <div id="gallery"> 
	                <asp:Localize ID="GalleryCaption" runat="server" Text="Images of {0}:"></asp:Localize>
                    <asp:Repeater ID="ProductImageRepeater" runat="server">
                        <HeaderTemplate>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <a href="<%#GetSafeUrl(Eval("ImageUrl").ToString())%>"><img src="<%#GetSafeUrl(Eval("ImageUrl").ToString())%>" alt="<%#Eval("ImageAltText")%>" /></a>
                        </ItemTemplate>
                        <FooterTemplate>
                        </FooterTemplate>
                    </asp:Repeater>
	            </div>
			  </div>
			</div>
          </div> 
        </div> 
      </div> 
    </div> 
</div> 
</body>
</html>
