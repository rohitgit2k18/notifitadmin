namespace AbleCommerce
{
    using System;
    using System.Web.UI;
    using AbleCommerce.Code;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Users;

    public partial class LinkPage : CommerceBuilder.UI.AbleCommercePage
    {
        Link _link = null;

        protected void Page_PreInit(object sender, EventArgs e)
        {
            _link = LinkDataSource.Load(PageHelper.GetLinkId());
            if (_link != null)
            {
                if ((_link.Visibility == CatalogVisibility.Private) &&
                    (!AbleContext.Current.User.IsInRole(Role.CatalogAdminRoles)))
                {
                    Response.Redirect(NavigationHelper.GetHomeUrl());
                }
            }
            else NavigationHelper.Trigger404(Response, "Invalid Link");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (_link != null)
            {
                //REGISTER THE PAGEVISIT
                PageVisitHelper.RegisterPageVisit(_link.Id, CatalogNodeType.Link, _link.Name);
                PageHelper.BindMetaTags(this, _link);
                Page.Title = _link.Name;
                LinkName.Text = _link.Name;
                if (!string.IsNullOrEmpty(_link.Description))
                {
                    LinkDescriptionPanel.Visible = true;
                    LinkDescription.Text = _link.Description;
                }
                else
                {
                    LinkDescriptionPanel.Visible = false;
                }
                LinkTarget.NavigateUrl = _link.TargetUrl;
                LinkTarget.Text = _link.TargetUrl;
                LinkTarget.Target = _link.TargetWindow;
            }
        }
    }
}