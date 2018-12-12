namespace AbleCommerce.Admin.SEO
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Seo.SiteMap;
    using CommerceBuilder.UI;
    using System.IO;
    using System.Text.RegularExpressions;
    
    public partial class Sitemap : AbleCommerceAdminPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            BindChangeFrequency();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // initialize form
                SiteMapOptions options = new SiteMapOptions();
                options.Load(new CommonSiteMapOptionKeys());
                if (!string.IsNullOrEmpty(options.SiteMapDataPath))
                {
                    SitemapPath.Text = options.SiteMapDataPath;
                }
                UseCompression.Checked = true;
                IndexItems.Items[0].Selected = options.IncludeCategories;
                IndexItems.Items[1].Selected = options.IncludeProducts;
                IndexItems.Items[2].Selected = options.IncludeWebpages;
                string changeFrequency = options.DefaultChangeFrequency.ToString();
                ListItem selectedItem = ChangeFrequency.Items.FindByText(changeFrequency);
                if (selectedItem != null) selectedItem.Selected = true;
            }
        }

        protected void GenerateButton_Click(object sender, EventArgs e)
        {
            // save the configured options
            SiteMapOptions options = new SiteMapOptions();
            options.Load(new CommonSiteMapOptionKeys());
            string sitemapPath = SitemapPath.Text;
            if (!string.IsNullOrEmpty(sitemapPath))
            {
                string newPath = Path.Combine(Request.MapPath("~/"), sitemapPath);
                if (!Directory.Exists(newPath))
                    Directory.CreateDirectory(newPath);
                options.SiteMapDataPath = newPath;
            }
            else
            {
                options.SiteMapDataPath = Request.MapPath("~/");
            }  
            options.SiteMapFileName = "SiteMap.xml";
            options.OverwriteSiteMapFile = true;
            options.IncludeCategories = IndexItems.Items[0].Selected;
            options.IncludeProducts = IndexItems.Items[1].Selected;
            options.IncludeWebpages = IndexItems.Items[2].Selected;
            options.CompressedSiteMapFileName = "SiteMap.xml.gz";
            options.OverwriteCompressedFile = true;
            options.DefaultUrlPriority = 0.5M;
            options.DefaultChangeFrequency = (changefreq)Enum.Parse(typeof(changefreq), ChangeFrequency.SelectedValue);
            options.Save(new CommonSiteMapOptionKeys());

            // generate the map
            List<string> messages = new List<string>();
            CommonSiteMapProvider provider = new CommonSiteMapProvider();
            bool success;
            if (UseCompression.Checked)
            {
                success = provider.CreateAndCompressSiteMap(options, ref messages);
            }
            else
            {
                success = provider.CreateSiteMap(options, ref messages);
            }

            // report the outcome
            if (success)
            {
                SuccessMessage.Visible = true;
                SuccessMessage.Text = GetMessageLiteral(messages);
            }
            else
            {
                FailureMessage.Visible = true;
                FailureMessage.Text = GetMessageLiteral(messages);
            }
        }

        private void BindChangeFrequency()
        {
            ChangeFrequency.Items.Clear();
            foreach (changefreq fqType in Enum.GetValues(typeof(changefreq)))
            {
                ListItem newItem = new ListItem(fqType.ToString());
                ChangeFrequency.Items.Add(newItem);
            }
        }

        private string GetMessageLiteral(IList<string> messages)
        {
            if (messages.Count == 0) return string.Empty;
            if (messages.Count == 1) return messages[0];
            StringBuilder sb = new StringBuilder();
            sb.Append("<ul>");
            foreach (string message in messages)
            {
                sb.Append("<li>" + message + "</li>");
            }
            sb.Append("</ul>");
            return sb.ToString();
        }
    }
}