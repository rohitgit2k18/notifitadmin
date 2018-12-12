namespace AbleCommerce.Code
{
    using System;
    using System.Data;
    using System.Configuration;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;

    /// <summary>
    /// Summary description for HtmlMetaWraper
    /// </summary>
    public class HtmlMetaWraper
    {
        private HtmlMeta _MetaTag;

        public HtmlMeta MetaTag
        {
            get { return _MetaTag; }
            set { _MetaTag = value; }
        }
        private string _MetaTagHtml;

        public string MetaTagHtml
        {
            get { return _MetaTagHtml; }
            set { _MetaTagHtml = value; }
        }

        public HtmlMetaWraper(HtmlMeta metaTag, string metaTagHtml)
        {
            _MetaTag = metaTag;
            _MetaTagHtml = metaTagHtml;
        }
    }
}