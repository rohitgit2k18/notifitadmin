<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.Utility.SocialMediaLinks" CodeFile="SocialMediaLinks.ascx.cs" %>
<%--
<conlib>
<summary>Displays social media icon-links</summary>
<param name="ShowFacebook" default="False">If true facebook icon-link is displayed</param>
<param name="ShowGoogle" default="False">If true google icon-link is displayed</param>
<param name="ShowTwitter" default="False">If true twitter icon-link is displayed</param>
<param name="ShowPinterest" default="False">If true pinterest icon-link is displayed</param>
</conlib>
--%>
<div class="socialMediaLinks">
    <asp:PlaceHolder ID="phFacebook" runat="server">
        <div class="mediaLink facebookLike">
            <%--<iframe class="fblike" src="//www.facebook.com/plugins/like.php?href=<%=PageUrl%>&amp;send=false&amp;layout=button_count&amp;width=450&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:visible; width:110px; height:21px; background-color:transparent;"></iframe>--%>
            <!--[if lt IE 9]><script> $(".fblike").attr("allowTransparency", "true"); </script><![endif]-->
                <a href="http://www.facebook.com/sharer/sharer.php?u=<%=PageUrl%>&title=<%=PageTitle%>" onclick="window.open(this.href, 'mywin','left=20,top=20,width=500,height=500,toolbar=1,resizable=0'); return false;"></a>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="phGoogle" runat="server">
        <div class="mediaLink google">
        <%--<script type="text/javascript" src="https://apis.google.com/js/plusone.js" defer="defer"></script>
            <div class="g-plusone" style="float:left;"></div> --%>
            <a href="https://plus.google.com/share?url=<%=PageUrl%>" onclick="window.open(this.href, 'mywin','left=20,top=20,width=500,height=500,toolbar=1,resizable=0'); return false;"></a>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="phTwitter" runat="server">
        <div class="mediaLink twitter">
            <%--<a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
            <script type="text/javascript" defer="defer">!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>--%>
            <a href="http://twitter.com/intent/tweet?status=<%=PageUrl%>+<%=PageTitle%>" onclick="window.open(this.href, 'mywin','left=20,top=20,width=500,height=500,toolbar=1,resizable=0'); return false;"></a>
        </div>
    </asp:PlaceHolder>
    <asp:PlaceHolder ID="phPinterest" runat="server">
        <div class="mediaLink pinterest">
            <%--<a href="<%=PinterestUrl%>" class="pin-it-button" count-layout="horizontal">Pin It</a>
            <script type="text/javascript" src="https://assets.pinterest.com/js/pinit.js" defer="defer"></script>--%>
            <a href="http://pinterest.com/pin/create/bookmarklet/?media=<%=ProductImage%>&url=<%=PageUrl%>&is_video=false&description=<%=PageTitle%>" onclick="window.open(this.href, 'mywin','left=20,top=20,width=500,height=500,toolbar=1,resizable=0'); return false;"></a>

        </div>
    </asp:PlaceHolder>
</div>
<div class="clear"></div>