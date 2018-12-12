namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using NHibernate;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Common;

    [Description("Displays other products in the same category.")]
    public partial class MoreCategoryItems : System.Web.UI.UserControl
    {
        private string _Caption = "Also in Category";
        private int _MaxItems = 3;
        private string _DisplayMode = "SEQUENTIAL";        
        private int _Columns = -1;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Also in Category")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(3)]
        [Description("The maximum number of products that can be shown.")]
        public int MaxItems
        {
            get
            {
                if (_MaxItems < 1) _MaxItems = 1;
                return _MaxItems;
            }
            set { _MaxItems = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("SEQUENTIAL")]
        [Description("Possible values are 'SEQUENTIAL' or 'RANDOM'. Indicates whether the contents will be selected randomly or in sequence.")]
        public string DisplayMode
        {
            get
            {
                return _DisplayMode;
            }
            set
            {
                _DisplayMode = value.ToUpperInvariant();
                if ((_DisplayMode != "SEQUENTIAL") && (_DisplayMode != "RANDOM")) _DisplayMode = "SEQUENTIAL";
            }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(3)]
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

        protected void Page_Load(object sender, EventArgs e)
        {
            IList<CatalogNode> productNodes = new List<CatalogNode>();            

            int _CategoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
            Category _Category = CategoryDataSource.Load(_CategoryId);

            var user = AbleContext.Current.User;
            string groups = string.Join(",", (from ug in user.UserGroups select ug.GroupId).ToList<int>().ToArray());

            if (_Category != null)
            {
                int productId = AbleCommerce.Code.PageHelper.GetProductId();
                if (productId > 0)
                {
                    //load products near the current product
                    short currentOrderBy = 0;
                    String sqlquery = @"SELECT TOP 1 CN.OrderBy FROM ac_CatalogNodes AS CN INNER JOIN ac_Products AS P
                                      ON CN.CatalogNodeId = P.ProductId WHERE CN.CategoryId = :categoryId AND CN.CatalogNodeTypeId = :nodeType 
                                      AND CN.CatalogNodeId = :nodeId AND P.VisibilityId = :visibilityId ";
                    if (!user.IsAdmin)
                    {
                        if (user.UserGroups.Count > 0)
                        {
                            sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId) OR EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId AND PG.GroupId IN (" + groups + "))) ";
                        }
                        else
                        {
                            sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId)) ";
                        }
                    }

                    ISQLQuery query = NHibernateHelper.CreateSQLQuery(sqlquery);
                    query.SetParameter("categoryId", _CategoryId);
                    query.SetParameter("nodeType", CatalogNodeType.Product);
                    query.SetParameter("nodeId", productId);
                    query.SetParameter("visibilityId", (byte)CatalogVisibility.Public);
                    currentOrderBy = query.UniqueResult<short>();
                    
                    int minOrderBy = currentOrderBy - 2*MaxItems;
                    int maxOrderBy = currentOrderBy + 2*MaxItems;

                    if (DisplayMode == "RANDOM")
                    {
                        // this query is MS SQL Server specific because it uses NEWID() function. 
                        sqlquery = "SELECT TOP " + (MaxItems + 1) + @" CN.* FROM ac_CatalogNodes AS CN INNER JOIN ac_Products AS P
                                      ON CN.CatalogNodeId = P.ProductId WHERE CN.CategoryId = :categoryId AND CN.CatalogNodeTypeId = :nodeType 
                                      AND CN.OrderBy > :minOrderBy AND CN.OrderBy < :maxOrderBy AND P.VisibilityId = :visibilityId ";
                        if (!user.IsAdmin)
                        {
                            if (user.UserGroups.Count > 0)
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId) OR EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId AND PG.GroupId IN (" + groups + "))) ";
                            }
                            else
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId)) ";
                            }
                        }
                        
                        sqlquery += " ORDER BY NEWID() ";
                    }
                    else
                    {
                        sqlquery = "SELECT TOP " + (MaxItems + 1) + @" CN.* FROM ac_CatalogNodes AS CN INNER JOIN ac_Products AS P
                                      ON CN.CatalogNodeId = P.ProductId WHERE CN.CategoryId = :categoryId AND CN.CatalogNodeTypeId = :nodeType 
                                      AND CN.OrderBy > :minOrderBy AND CN.OrderBy < :maxOrderBy AND P.VisibilityId = :visibilityId ";

                        if (!user.IsAdmin)
                        {
                            if (user.UserGroups.Count > 0)
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId) OR EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId AND PG.GroupId IN (" + groups + "))) ";
                            }
                            else
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId)) ";
                            }
                        }

                        sqlquery += " ORDER BY ABS (CN.OrderBy - " + currentOrderBy + ") ";
                    }

                    query = NHibernateHelper.CreateSQLQuery(sqlquery);                    
                    query.SetParameter("categoryId", _CategoryId);
                    query.SetParameter("nodeType", CatalogNodeType.Product);
                    query.SetParameter("minOrderBy", minOrderBy);
                    query.SetParameter("maxOrderBy", maxOrderBy);                    
                    query.SetParameter("visibilityId", (byte)CatalogVisibility.Public);
                    query.AddEntity(typeof(CatalogNode));
                    productNodes = query.List<CatalogNode>();
                }
                else
                {
                    //load products without any product preference
                    String sqlquery = string.Empty;
                    if (DisplayMode == "RANDOM")
                    {                        
                        //load products randomly. This query is SQL Server specific because of the use of NEWID() function
                        sqlquery = "SELECT TOP " + (MaxItems + 1) + @" CN.* FROM ac_CatalogNodes AS CN INNER JOIN ac_Products AS P
                                      ON CN.CatalogNodeId = P.ProductId WHERE CN.CategoryId = :categoryId AND CN.CatalogNodeTypeId = :nodeType 
                                      AND P.VisibilityId = :visibilityId ";

                        if (!user.IsAdmin)
                        {
                            if (user.UserGroups.Count > 0)
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId) OR EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId AND PG.GroupId IN (" + groups + "))) ";
                            }
                            else
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId)) ";
                            }
                        }

                        sqlquery += " ORDER BY NEWID() ";
                    }
                    else
                    {
                        //load products sequentially
                        sqlquery = "SELECT TOP " + (MaxItems + 1) + @" CN.* FROM ac_CatalogNodes AS CN INNER JOIN ac_Products AS P
                                      ON CN.CatalogNodeId = P.ProductId WHERE CN.CategoryId = :categoryId AND CN.CatalogNodeTypeId = :nodeType 
                                      AND P.VisibilityId = :visibilityId ";

                        if (!user.IsAdmin)
                        {
                            if (user.UserGroups.Count > 0)
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId) OR EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId AND PG.GroupId IN (" + groups + "))) ";
                            }
                            else
                            {
                                sqlquery += " AND (NOT EXISTS(SELECT PG.GroupId FROM ac_ProductGroups AS PG WHERE PG.ProductId = P.ProductId)) ";
                            }
                        }

                        sqlquery += " ORDER BY CN.OrderBy ";
                    }

                    ISQLQuery query = NHibernateHelper.CreateSQLQuery(sqlquery);                    
                    query.SetParameter("categoryId", _CategoryId);
                    query.SetParameter("nodeType", CatalogNodeType.Product);
                    query.SetParameter("visibilityId", (byte)CatalogVisibility.Public);
                    query.AddEntity(typeof(CatalogNode));
                    productNodes = query.List<CatalogNode>();
                }

                // remove the current product
                int productIndex = productNodes.IndexOf(_CategoryId, productId, (byte)CatalogNodeType.Product);
                if (productIndex >= 0)
                {
                    productNodes.RemoveAt(productIndex);
                }
                else if (productNodes.Count > MaxItems)
                {
                    //remove the last item
                    productNodes.RemoveAt(productNodes.Count - 1);
                }

                //MAKE SURE WE HAVE SOMETHING TO SHOW
                if (productNodes.Count > 0)
                {
                    List<Product> showProducts = new List<Product>();
                    List<int> ids = productNodes.Select(n => n.CatalogNodeId).ToList<int>();

                    // FETCH THE PRODUCTS INTO ORM OBJECT GRAPH AND DISCARD RESULTS 
                    // THIS IS ESSENTIALLY FOR PERFORMANCE BOOST BY MINIMIZING NUMBER OF QUERIES
                    NHibernateHelper.QueryOver<Product>()
                        .AndRestrictionOn(p => p.Id).IsIn(ids)
                        .List<Product>();

                    // LOAD PRODUCTS FROM OBJECT GRAPH ONE BY ONE TO MAINTAIN SORT ORDER
                    foreach (int id in ids)
                    {
                        Product p = ProductDataSource.Load(id);
                        showProducts.Add(p);
                    }

                    // DELAYED QUERIES TO EAGER LOAD RELATED DATA
                    if (ids.Count > 0)
                    {
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

                        futureQuery.ToList();
                    }

                    //BIND THE PRODUCTS
                    ProductList.RepeatColumns = this.Columns;
                    ProductList.DataSource = showProducts;
                    ProductList.DataBind();
                }
                else
                {
                    //THERE ARE NOT ANY ITEMS TO DISPLAY
                    this.Visible = false;
                }
            }
        }
    }
}
