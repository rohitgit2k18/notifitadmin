<%@ WebHandler Language="C#" Class="AbleCommerce.Install.BuildCatalog" %>
namespace AbleCommerce.Install
{
    using System;
    using System.Collections.Generic;
    using System.Web;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Shipping;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Utility;
    using NHibernate;

    public class BuildCatalog : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            // ADD SOME SAMPLE MANUFACTURERS
            ManufacturerDataSource.LoadForName("Gadgets Ltd.", true);
            ManufacturerDataSource.LoadForName("Stuff, Inc.", true);
            ManufacturerDataSource.LoadForName("Things Intl", true);
            ManufacturerDataSource.LoadForName("Trinkets Tech", true);
            ManufacturerDataSource.LoadForName("Widget Works", true);

            // CALCULATE CATALOG TO BUILD
            int firstLevelCategories = AlwaysConvert.ToInt(request.QueryString["C1"]);
            if (firstLevelCategories < 1) firstLevelCategories = 1;
            int secondLevelCategories = AlwaysConvert.ToInt(request.QueryString["C2"]);
            if (secondLevelCategories < 1) secondLevelCategories = 1;
            int thirdLevelCategories = AlwaysConvert.ToInt(request.QueryString["C3"]);
            if (thirdLevelCategories < 1) thirdLevelCategories = 1;
            int products = AlwaysConvert.ToInt(request.QueryString["P"]);
            if (products < 1) products = 1;
            int totalProductCount = firstLevelCategories * secondLevelCategories * thirdLevelCategories * products;

            response.Write("Building " + totalProductCount.ToString() + " products:");
            response.Flush();

            // PREPARE FOR CREATE
            int defaultWarehouseId = AbleContext.Current.Store.DefaultWarehouse.Id;
            ISession session = AbleContext.Current.Database.GetSession();
            string itemName;
            int productCount = 0;

            // LOOP AND CREATE CATALOG
            for (int i = 1; i <= firstLevelCategories; i++)
            {
                Category category1 = new Category();
                category1.Name = "Category C" + i.ToString();
                category1.Visibility = CatalogVisibility.Public;
                category1.ParentId = 0;
                category1.Save();
                session.Evict(category1);
                for (int j = 1; j <= secondLevelCategories; j++)
                {
                    itemName = "C" + i.ToString() + "-C" + j.ToString();
                    Category category2 = new Category();
                    category2.Name = "Subcategory " + itemName;
                    category2.Visibility = CatalogVisibility.Public;
                    category2.ParentId = category1.Id;
                    category2.Save();
                    session.Evict(category2);
                    for (int k = 1; k <= thirdLevelCategories; k++)
                    {
                        itemName = "C" + i.ToString() + "-C" + j.ToString() + "-C" + k.ToString();
                        Category category3 = new Category();
                        category3.Name = "Sub Subcategory " + k;
                        category3.Visibility = CatalogVisibility.Public;
                        category3.ParentId = category2.Id;
                        category3.Save();
                        session.Evict(category3);
                        for (int l = 1; l <= products; l++)
                        {
                            response.Write(" .");
                            if (productCount > 0 && productCount % 100 == 0)
                            {
                                response.Write(" " + productCount.ToString());
                            }
                            response.Flush();
                            productCount++;
                            itemName = "C" + i.ToString() + "-C" + j.ToString() + "-C" + k.ToString() + "-P" + l.ToString();
                            Product product = new Product();
                            product.Visibility = CatalogVisibility.Public;
                            product.WarehouseId = defaultWarehouseId;
                            product.Manufacturer = GetRandomManufacturer();
                            product.Name = "Product " + itemName;
                            product.Price = (decimal)l;
                            product.Sku = "SKU" + itemName;
                            product.ModelNumber = "MN" + itemName;
                            product.Summary = "This is a sample product summary.";
                            product.Description = "This is a sample product description.";
                            product.Shippable = Shippable.Yes;
                            product.Weight = 1;
                            product.Categories.Add(category3.Id);
                            product.Save();
                            session.Evict(product);
                        }
                    }
                }
            }
            response.Write(" DONE!");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        private Manufacturer GetRandomManufacturer()
        {
            Random rand = new Random();
            IList<Manufacturer> manufacturers = AbleContext.Current.Store.Manufacturers;
            int index = rand.Next(manufacturers.Count);
            return manufacturers[index];
        }
    }
}