namespace AbleCommerce.Layouts
{
    using System;
    using System.Web.UI;

    public partial class Base : System.Web.UI.MasterPage
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (ScriptsPh != null)
            {
                // insert necessary javascripts
                string scriptTag = "<script src=\"{0}\" type=\"text/javascript\"></script>";
                string jquery = Page.ResolveUrl("~/Scripts/jquery-1.10.2.min.js");
                string jqueryUI = Page.ResolveUrl("~/Scripts/jquery-ui.min.js");
                string equalHeightsUrl = Page.ResolveUrl("~/Scripts/jquery.equalheights.js");
                string dropzone = Page.ResolveUrl("~/Scripts/dropzone.js");
                string hoverDisplay = Page.ResolveUrl("~/Scripts/hoverItemDisplay.js");
                ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, jquery)));
                ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, jqueryUI)));
                ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, equalHeightsUrl)));
                ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, dropzone)));
                ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, hoverDisplay)));

                if (AbleCommerce.Code.PageHelper.IsResponsiveTheme(this.Page))
                {
                    string footable = Page.ResolveUrl("~/Scripts/footable.js");
                    string bootstrap = Page.ResolveUrl("~/Scripts/bootstrap.min.js");
                    ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, footable)));
                    ScriptsPh.Controls.Add(new LiteralControl(string.Format(scriptTag, bootstrap)));
                }
            }
        }
    }
}