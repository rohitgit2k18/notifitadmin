namespace AbleCommerce.Admin.Dashboard
{
    using System;
    using System.Collections.Generic;
    using System.Xml;
    using CommerceBuilder.Utility;

    public partial class NewsReader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RssList.DataSource = GetNewsItems();
            RssList.DataBind();
        }

        protected IList<RssNewsItem> GetNewsItems()
        {
            List<RssNewsItem> newsItems;
            CacheWrapper cacheWrapper = Cache["AbleRssNews"] as CacheWrapper;
            if (cacheWrapper == null)
            {
                XmlDocument AbleRssXml = new XmlDocument();
                try
                {
                    AbleRssXml.Load("http://www.ablecommerce.com/rss/acgold.xml");
                }
                catch
                {
                    AbleRssXml.LoadXml("<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss></rss>");
                }
                newsItems = new List<RssNewsItem>();
                XmlNodeList nodes = AbleRssXml.SelectNodes("rss/channel/item");
                int itemsCount = 0;
                foreach(XmlNode node in nodes)
                {
                    XmlElement ele = (XmlElement)node;
                    RssNewsItem newsItem = new RssNewsItem();
                    newsItem.PubDate = AlwaysConvert.ToDateTime(XmlUtility.GetElementValue(ele, "pubDate"), DateTime.UtcNow);
                    newsItem.Link = XmlUtility.GetElementValue(ele, "link");
                    newsItem.Title = XmlUtility.GetElementValue(ele, "title");
                    newsItem.Description = XmlUtility.GetElementValue(ele, "description");
                    newsItems.Add(newsItem);

                    if (++itemsCount > 2) break;
                }
                cacheWrapper = new CacheWrapper(newsItems);
                Cache.Remove("AbleRssNews");
                Cache.Add("AbleRssNews", cacheWrapper, null, DateTime.UtcNow.AddDays(1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.Normal, null);
            }
            else
            {
                newsItems = cacheWrapper.CacheValue as List<RssNewsItem>;
            }
            return newsItems;
        }

        public class RssNewsItem
        {
            private DateTime _PubDate;
            private string _Link;
            private string _Title;
            private string _Description;
            public DateTime PubDate
            {
                get { return _PubDate; }
                set { _PubDate = value; }
            }
            public string Link
            {
                get { return _Link; }
                set { _Link = value; }
            }
            public string Title
            {
                get { return _Title; }
                set { _Title = value; }
            }
            public string Description
            {
                get { return _Description; }
                set { _Description = value; }
            }
        }
    }
}