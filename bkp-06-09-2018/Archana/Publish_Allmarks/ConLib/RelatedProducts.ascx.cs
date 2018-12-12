namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using CommerceBuilder.UI;
    using System.Linq;
    using CommerceBuilder.Common;
    using CommerceBuilder.DomainModel;

    [Description("Displays products related to a given product.")]
    public partial class RelatedProducts : System.Web.UI.UserControl, ISidebarControl
    {
        private string _Caption = "Related Products";
        private int _MaxItems = 5;
        private int _Columns = -1;
        private bool _Randomize = false;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(1)]
        [Description("The number of columns to display in the grid.")]
        public int Columns
        {
            get
            {
                if (_Columns < 0) return ProductList.RepeatColumns;
                return _Columns;
            }
            set
            {
                _Columns = value;
                ProductList.RepeatColumns = Columns;
            }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Related Products")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(5)]
        [Description("The maximum number of products that can be shown.")]
        public int MaxItems
        {
            get { return _MaxItems; }
            set { _MaxItems = value; }
        }

        /// <summary>
        /// Gets or sets a value indication whether to randomly select items for display if the count of related products exceeds the ‘MaxItem’ limit or display first items.
        /// </summary>
        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(false)]
        [Description("If true items are randomly selected for display if the count of related products exceeds the ‘MaxItem’ limit. If false items are selected sequentially.")]
        public bool Randomize
        {
            get { return _Randomize; }
            set { _Randomize = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {   
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                IList<RelatedProduct> relatedProducts = NHibernateHelper.QueryOver<RelatedProduct>()
                    .Fetch(rp => rp.Product).Eager
                    .Where(rp => rp.ProductId == productId)
                    .TransformUsing(NHibernate.Transform.Transformers.DistinctRootEntity)
                    .List<RelatedProduct>();

                List<int> ids = relatedProducts.Select(rp => rp.ChildProductId).ToList<int>();
                if (ids.Count > 0)
                {
                    // DELAYED QUERIES TO EAGER LOAD RELATED DATA, THIS IS FOR PERFORMANCE BOOST
                    var futureQuery = NHibernateHelper.QueryOver<Product>()
                    .AndRestrictionOn(p => p.Id).IsIn(ids)
                    .Fetch(p => p.Specials).Eager
                    .Future<Product>();

                    NHibernateHelper.QueryOver<Product>()
                    .AndRestrictionOn(p => p.Id).IsIn(ids)
                    .Fetch(p => p.ProductOptions).Eager
                    .Future<Product>();

                    NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .Fetch(p => p.ProductKitComponents).Eager
                        .Future<Product>();

                    NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .Fetch(p => p.ProductTemplates).Eager
                        .Future<Product>();

                    futureQuery.ToList<Product>();
                }

                IList<Product> products = new List<Product>();
                var user = AbleContext.Current.User;
                List<int> groups = (from ug in user.UserGroups select ug.GroupId).ToList<int>();

                // GET ALL CHILD PRODUCTS AND ADD TO THE COLLECTION
                foreach (RelatedProduct relatedProduct in relatedProducts)
                {
                    if (relatedProduct.ChildProduct.Visibility == CatalogVisibility.Public
                        && ((!this.Randomize && products.Count < this.MaxItems) || this.Randomize))
                    {
                        Product childProduct = relatedProduct.ChildProduct;
                        if (!user.IsAdmin)
                        {
                            if (childProduct.EnableGroups)
                            {
                                if (groups.Count > 0)
                                {
                                    bool isInGroup = childProduct.ProductGroups.Any<ProductGroup>(pg => groups.Contains(pg.Group.Id));
                                    if (!isInGroup)
                                    {
                                        continue;
                                    }
                                }
                                else
                                {
                                    continue;
                                }
                            }
                        }

                        products.Add(childProduct);
                    }
                }

                // ENSURE COUNT TO MATCH MaxItems PROPERTY
                if (this.Randomize && products.Count > MaxItems)
                {
                    // REMOVE EXTRA ITEMS RANDOMLY TO MATCH THE COUNT
                    int itemsToRemove = products.Count - MaxItems;
                    Random rand = new Random();
                    for (int i = 0; i < itemsToRemove; i++)
                    {
                        int index = rand.Next(products.Count - 1);
                        products.RemoveAt(index);
                    }
                }

                if (products.Count > 0)
                {
                    phCaption.Text = this.Caption;
                    if (this.Columns > products.Count) this.Columns = products.Count;
                    
                    if (products.Count > 0)
                    {
                        ProductList.RepeatColumns = Columns;
                        ProductList.DataSource = products;
                        ProductList.DataBind();
                    }
                    else phContent.Visible = false;
                }
                else phContent.Visible = false; 
            }
            else phContent.Visible = false;
        }
    }
}