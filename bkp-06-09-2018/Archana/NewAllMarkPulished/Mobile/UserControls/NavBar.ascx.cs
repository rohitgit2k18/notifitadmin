namespace AbleCommerce.Mobile.UserControls
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using AbleCommerce.Code;
    using CommerceBuilder.Utility;
    
    public partial class NavBar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //
        }

        private void LinkToHome()
        {
            NavLinkText.Text = "Home";
            NavLink.HRef = Page.ResolveUrl(AbleCommerce.Code.NavigationHelper.GetHomeUrl());            
        }

        protected void Page_PreRender(object sender, System.EventArgs e)
        {
            NavHomeLink.HRef = ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/Default.aspx"));
            NavCartLink.HRef = ResolveUrl(NavigationHelper.GetMobileStoreUrl("~/Basket.aspx"));

            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product prod = ProductDataSource.Load(productId);
            if (prod != null)
            {
                if (IsProductSubPage())
                {
                    //this is a product sub page. link back to product main page
                    NavLinkText.Text = "Product Summary";
                    NavLink.HRef = ResolveUrl(prod.NavigateUrl);
                }
                else
                {                    
                    int catId;
                    Category cat = null;
                    if (prod.Categories.Count == 1)
                    {
                        catId = prod.Categories[0];
                        cat = CategoryDataSource.Load(catId);
                    }
                    else if (prod.Categories.Count > 1)
                    {
                        //multiple categories for this product. chose last visited category id                        
                        catId = PageVisitHelper.LastVisitedCategoryId;
                        if (prod.Categories.Contains(catId))
                        {
                            //last visited category found in product parents
                            cat = CategoryDataSource.Load(catId);
                        }
                        else
                        {
                            //no option but to chose the first parent category
                            catId = prod.Categories[0];
                            cat = CategoryDataSource.Load(catId);
                        } 
                    }

                    if (cat != null)
                    {
                        NavLinkText.Text = StringHelper.Truncate(cat.Name, 22) + "...";
                        NavLink.HRef = ResolveUrl(cat.NavigateUrl);
                    }
                    else
                    {
                        //no category found for this product
                        LinkToHome();
                    }
                }
            }
            else
            {
                //Product is null. So lets try to see if this is a category page.
                int catId = PageHelper.GetCategoryId();
                Category cat = CategoryDataSource.Load(catId);
                if (cat != null)
                {
                    //this is a category page.
                    Category parentCat = CategoryDataSource.Load(cat.ParentId);
                    if (parentCat != null)
                    {
                        NavLinkText.Text = parentCat.Name;
                        NavLink.HRef = ResolveUrl(parentCat.NavigateUrl);
                    }
                    else
                    {
                        //parent category not found. link to home
                        LinkToHome();
                    }
                }
                else
                {
                    //this is not a category page either. link to home
                    LinkToHome();
                }
            }
        }

        private bool IsProductSubPage()
        {
            string fileName = System.IO.Path.GetFileName(Request.CurrentExecutionFilePath);
            if (string.IsNullOrEmpty(fileName)) return false;
            fileName = fileName.ToLowerInvariant().Trim();
            switch (fileName)
            {
                case "productimages.aspx":
                    return true;                    
                case "productdescription.aspx":
                    return true;
                case "productreviews.aspx":
                    return true;
                default:
                    return false;
            }
        }

    }

}