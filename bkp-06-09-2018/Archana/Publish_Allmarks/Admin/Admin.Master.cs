using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AbleCommerce.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            // insert necessary javascripts
            string scriptTag = "<script src=\"{0}\" type=\"text/javascript\"></script>\r\n";
            string jquery = Page.ResolveUrl("~/Scripts/jquery-1.10.2.min.js");
            string jqueryUI = Page.ResolveUrl("~/Scripts/jquery-ui.min.js");
            string jqueryUIi18n = Page.ResolveUrl("~/Scripts/jquery-ui-i18n.min.js");
            string superfishUrl = Page.ResolveUrl("~/Scripts/superfish.js");
            string hoverIntentUrl = Page.ResolveUrl("~/Scripts/hoverIntent.js");
            string equalHeightsUrl = Page.ResolveUrl("~/Scripts/jquery.equalheights.js");
            string jquerySticky = Page.ResolveUrl("~/Scripts/jquery.sticky.js");
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, jquery)));
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, jqueryUI)));
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, jqueryUIi18n)));
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, superfishUrl)));
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, hoverIntentUrl)));
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, equalHeightsUrl)));
            head1.Controls.Add(new LiteralControl(string.Format(scriptTag, jquerySticky)));

            // admin pages can be cached for browser history
            Response.Cache.SetCacheability(HttpCacheability.Private);
        }
    }
}