<%@ Control Language="C#" AutoEventWireup="true" Inherits="AbleCommerce.ConLib.SocialMediaLinksDialog" CodeFile="SocialMediaLinksDialog.ascx.cs" %>
<%--
<conlib>
<summary>Add social media links to your page as a sidebar dialog.</summary>
<param name="ShowFacebook" default="True">Indicates whether to show the Facebook like button or not</param>
<param name="ShowGoogle" default="True">Indicates whether to show the Google +1 button or not</param>
<param name="ShowTwitter" default="True">Indicates whether to show the Twitter tweet button or not</param>
<param name="ShowPinterest" default="True">Indicates whether to show the Pinterest pin button or not</param>
</conlib>
--%>
<div class="widget socialMediaLinksDialog">
    <div class="innerSection">
        <div class="header">
            <h2><asp:Localize ID="CaptionLabel" runat="server" Text="Share" /></h2>
        </div>
        <div class="content">
        <asp:PlaceHolder ID="phFacebook" runat="server">
            <iframe class="fblike" src="//www.facebook.com/plugins/like.php?href=<%=PageUrl%>&amp;send=false&amp;layout=button_count&amp;width=450&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:visible; width:110px; height:21px; background-color:transparent;"></iframe>
            <!--[if lt IE 9]><script> $(".fblike").attr("allowTransparency", "true"); </script><![endif]-->
            <br /><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phGoogle" runat="server">
            <div class="g-plusone" style="float:left;"></div>
            <script type="text/javascript" src="https://apis.google.com/js/plusone.js" defer="defer"></script>
            <br /><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phTwitter" runat="server">
            <a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
            <script type="text/javascript" defer="defer">!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
            <br /><br />
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="phPinterest" runat="server">
            <a href="<%=PinterestUrl%>" class="pin-it-button" count-layout="horizontal">Pin It</a>
            <script type="text/javascript" src="https://assets.pinterest.com/js/pinit.js" defer="defer"></script>
        </asp:PlaceHolder>
        </div>
    </div>
</div>