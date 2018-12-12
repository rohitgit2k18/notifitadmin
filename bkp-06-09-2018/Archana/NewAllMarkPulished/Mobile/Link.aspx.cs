using System;
using System.Web.UI;
using AbleCommerce.Code;
using CommerceBuilder.Catalog;
using CommerceBuilder.Common;
using CommerceBuilder.Users;

namespace AbleCommerce.Mobile
{
    public partial class LinkPage : CommerceBuilder.UI.AbleCommercePage
    {
        Link _Link = null;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            _Link = LinkDataSource.Load(AbleCommerce.Code.PageHelper.GetLinkId());
            if (_Link != null)
            {
                if ((_Link.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    Response.Redirect(AbleCommerce.Code.NavigationHelper.GetHomeUrl());
                }
            }
            else AbleCommerce.Code.NavigationHelper.Trigger404(Response, "Invalid Link");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (_Link != null)
            {
                //REGISTER THE PAGEVISIT
                PageVisitHelper.RegisterPageVisit(_Link.Id, CatalogNodeType.Link, _Link.Name);
                AbleCommerce.Code.PageHelper.BindMetaTags(this, _Link);
                Page.Title = _Link.Name;
                LinkName.Text = _Link.Name;
                if (!string.IsNullOrEmpty(_Link.Description))
                {
                    LinkDescriptionPanel.Visible = true;
                    LinkDescription.Text = _Link.Description;
                }
                else
                {
                    LinkDescriptionPanel.Visible = false;
                }
                LinkTarget.NavigateUrl = _Link.TargetUrl;
                LinkTarget.Text = _Link.TargetUrl;
                LinkTarget.Target = _Link.TargetWindow;
            }
        }
    }
}