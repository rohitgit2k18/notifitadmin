namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using System.ComponentModel;
    using CommerceBuilder.Utility;
    using CommerceBuilder.UI;
    using AbleCommerce.Code;

    [Description("A sidebar control that list webpages of a category in a row format.")]
    public partial class ArticleListingSidebar : System.Web.UI.UserControl, ISidebarControl
    {
        private string _DefaultCaption = "Blog";
        private int _categoryId;
        private int _maxItems = 10;
        private string _defaultSortOrder = "PublishDate DESC";

        /// <summary>
        /// Name that will be shown as caption when root category will be browsed
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Blog")]
        [Description("Caption text that will be shown as caption when root category will be browsed.")]
        public string DefaultCaption
        {
            get { return _DefaultCaption; }
            set { _DefaultCaption = value; }
        }

        /// <summary>
        /// Gets or sets the Category Id from where blog pages will be displayed.
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(0)]
        [Description("Category Id from where blog pages will be displayed.")]
        public int CategoryId
        {
            get { return _categoryId; }
            set { _categoryId = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(10)]
        [Description("The maximum number of blog posts that can be shown.")]
        public int MaxItems
        {
            get { return _maxItems; }
            set { _maxItems = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("PublishDate DESC")]
        [Description("The default sort order for the blog posts to be shown.")]
        public string DefaultSortOrder
        {
            get { return _defaultSortOrder; }
            set { _defaultSortOrder = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Caption.Text = this.DefaultCaption;
            int categoryId = this.CategoryId;
            if (categoryId <= 0)
                categoryId = PageHelper.GetCategoryId();

            if (categoryId > 0)
            {
                IList<Webpage> webpage = WebpageDataSource.LoadForCategory(categoryId, true, true, DefaultSortOrder, MaxItems, 0);
                BlogRepeater.DataSource = webpage;
                BlogRepeater.DataBind();
            }
            else
                this.Visible = false;

            NoArticlesMessage.Visible = BlogRepeater.Items.Count == 0;
        }
    }
}