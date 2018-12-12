namespace AbleCommerce
{
    using System;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    public partial class WebpagePage : CommerceBuilder.UI.AbleCommercePage
    {
        Webpage _webpage = null;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            _webpage = WebpageDataSource.Load(PageHelper.GetWebpageId());
            if (_webpage != null)
            {
                if ((_webpage.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    if (!IsHomePage())
                    {
                        Response.Redirect(NavigationHelper.GetHomeUrl());
                    }
                    else
                    {
                        Server.Transfer(NavigationHelper.GetHomeUrl());
                    }
                }
            }
            else NavigationHelper.Trigger404(Response, "Invalid Webpage");

            // INITIALIZE TO DEFAULT LAYOUT
            string layout = AbleContext.Current.Store.Settings.WebpagesDefaultLayout;

            // CHECK FOR LAYOUT OVERRIDE
            if (_webpage.Layout != null) layout = _webpage.Layout.FilePath;

            // CHECK FOR THEME OVERRIDE
            if (!string.IsNullOrEmpty(_webpage.Theme) && CommerceBuilder.UI.Theme.Exists(_webpage.Theme))
            {
                this.Theme = _webpage.Theme;
            }

            // SET THE LAYOUT
            if (!string.IsNullOrEmpty(layout)) this.MasterPageFile = layout;
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // REGISTER THE PAGEVISIT
            AbleCommerce.Code.PageVisitHelper.RegisterPageVisit(_webpage.Id, CatalogNodeType.Webpage, _webpage.Name);
            AbleCommerce.Code.PageHelper.BindMetaTags(this, _webpage);
            Page.Title = string.IsNullOrEmpty(_webpage.Title) ? _webpage.Name : _webpage.Title;
            PageContents.Value = _webpage.Description;

            if (_webpage.PublishDate == DateTime.MinValue && string.IsNullOrWhiteSpace(_webpage.PublishedBy))
            {
                PublishInfo.Visible = false;
            }
            else
            {
                string publishedBy = string.IsNullOrWhiteSpace(_webpage.PublishedBy) ? string.Empty : " by " + _webpage.PublishedBy;
                string publishedDate = _webpage.PublishDate == DateTime.MinValue ? string.Empty : " " + string.Format("{0:D}", _webpage.PublishDate);
                PublishInfoLabel.Text = string.Format(PublishInfoLabel.Text, publishedDate, publishedBy);
            }

            if (PublishInfo.Visible)
            {
                BlogDescription.Value = _webpage.Description;
                articleListingPanel.Visible = true;
                PageContents.Visible = false;

                ItemName.Text = _webpage.Name;
                string target = "_self";

                ItemThumbnailLink.NavigateUrl = _webpage.NavigateUrl;
                ItemThumbnailLink.Target = target;

                if (!string.IsNullOrEmpty(_webpage.ThumbnailUrl))
                {
                    ItemThumbnail.ImageUrl = _webpage.ThumbnailUrl;
                    ItemThumbnail.AlternateText = string.IsNullOrEmpty(_webpage.ThumbnailAltText) ? _webpage.Name : _webpage.ThumbnailAltText;
                }
                else
                {
                    ThumbnailPanel.Visible = false;
                }
            }
            else
            {
                articleListingPanel.Visible = false;
                PageContents.Visible = true;
            }
        }

        private bool IsHomePage()
        {
            if (_webpage == null) return false;
            string homePageUrl = NavigationHelper.GetHomeUrl();
            string webpageUrl = _webpage.CustomUrl;
            if (!webpageUrl.StartsWith("~/"))
                webpageUrl = "~/" + webpageUrl;
            return string.Compare(webpageUrl, homePageUrl) == 0;
        }
    }
}