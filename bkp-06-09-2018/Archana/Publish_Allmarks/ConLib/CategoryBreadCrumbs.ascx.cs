namespace AbleCommerce.ConLib
{
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using CommerceBuilder.Catalog;
    
    [Description("Displays bread crumbs for the current category")]
    public partial class CategoryBreadCrumbs : System.Web.UI.UserControl
    {
        int _CategoryId = 0;
        bool _HideLastNode = false;

        public int CategoryId
        {
            get { return _CategoryId; }
            set { _CategoryId = value; }
        }

        [Browsable(true), DefaultValue(true)]
        [Description("If true last node is hidden")]
        public bool HideLastNode
        {
            get { return _HideLastNode; }
            set { _HideLastNode = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            HomeLink.NavigateUrl = AbleCommerce.Code.NavigationHelper.GetHomeUrl();
            if (this.CategoryId != 0)
            {
                IList<CatalogPathNode> path = CatalogDataSource.GetPath(CategoryId, false);
                BreadCrumbsRepeater.DataSource = path;
                BreadCrumbsRepeater.DataBind();
                if ((HideLastNode) && (BreadCrumbsRepeater.Controls.Count > 0))
                {
                    BreadCrumbsRepeater.Controls[(BreadCrumbsRepeater.Controls.Count - 1)].Visible = false;
                }
            }
            else BreadCrumbsRepeater.Visible = false;
        }
    }
}