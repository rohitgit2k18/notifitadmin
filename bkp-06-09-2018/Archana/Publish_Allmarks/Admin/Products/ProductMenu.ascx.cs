namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections.Specialized;
    using System.Text;
    using System.Web.UI;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class ProductMenu : System.Web.UI.UserControl
    {
        protected void Page_PreRender(object sender, EventArgs e)
        {
            int productId = AbleCommerce.Code.PageHelper.GetProductId();
            Product product = ProductDataSource.Load(productId);
            if (product != null)
            {
                NameValueCollection menuLinks = new NameValueCollection();
                menuLinks.Add("Product", "EditProduct.aspx");
                menuLinks.Add("Images", "Assets/Images.aspx");
                menuLinks.Add("Options", "Variants/Options.aspx");
                menuLinks.Add("Digital Goods", "DigitalGoods/DigitalGoods.aspx");
                menuLinks.Add("Kitting", "Kits/EditKit.aspx");
                menuLinks.Add("Volume Pricing", "EditVolumePricing.aspx");
                //menuLinks.Add("Discounts", "ProductDiscounts.aspx");
                menuLinks.Add("Specials", "Specials/Default.aspx");
                menuLinks.Add("Similar Products", "EditSimilarProducts.aspx");
                menuLinks.Add("Upsell", "EditProductAccessories.aspx");
                menuLinks.Add("Categories", "EditProductCategories.aspx");
                menuLinks.Add("Templates", "EditProductTemplate.aspx");
                menuLinks.Add("Subscriptions", "EditSubscription.aspx");

                string suffix = "?ProductId=" + product.Id.ToString();
                int categoryId = AlwaysConvert.ToInt(Request.QueryString["CategoryId"]);
                if (categoryId > 0) suffix += "&CategoryId=" + categoryId.ToString();
                string activeMenu = GetActiveMenu(Request.Url);
                StringBuilder menu = new StringBuilder();
                menu.AppendLine("<div class=\"secondaryMenu\">");
                menu.AppendLine("<ul>");
                foreach (string key in menuLinks.AllKeys)
                {
                    if (key == activeMenu)
                    {
                        menu.Append("<li class=\"active\">");
                    }
                    else
                    {
                        menu.Append("<li>");
                    }
                    menu.AppendLine("<a href=\"" + Page.ResolveUrl("~/Admin/Products/" + menuLinks[key]) + suffix + "\">" + key + "</a></li>");
                }

                // preview link can never be active
                string pUrl = UrlGenerator.GetBrowseUrl(categoryId, productId, CatalogNodeType.Product, product.Name);
                if (pUrl.StartsWith("~/"))
                    pUrl = ResolveClientUrl(pUrl);
                
                menu.AppendLine("<li><a href=\"" +pUrl + "\" target=\"_blank\">Preview</a></li>");

                menu.AppendLine("</ul>");
                menu.AppendLine("</div>");
                MenuContent.Text = menu.ToString();

            }
            else
            {
                // no order, do not display menu
                this.Controls.Clear();
            }
        }

        private string GetActiveMenu(Uri url)
        {
            string fileName = url.Segments[url.Segments.Length - 1].ToLowerInvariant();
            switch (fileName)
            {
                case "editproduct.aspx":
                    return "Product";
                case "images.aspx":
                case "uploadimage.aspx":
                case "additionalimages.aspx":
                case "uploadadditionalimage.aspx":
                case "advancedimages.aspx":
                case "assetmanager.aspx":
                case "uploadpresizedimage.aspx":
                    return "Images";
                case "options.aspx":
                case "editchoices.aspx":
                case "editoption.aspx":
                case "variants.aspx":
                    return "Options";
                case "digitalgoods.aspx":
                case "attachdigitalgood.aspx":
                case "selectvariant.aspx":
                    return "Digital Goods";
                case "addkitproducts.aspx":
                case "attachcomponent.aspx":
                case "deletesharedcomponent.aspx":
                case "editcomponent.aspx":
                case "editkit.aspx":
                case "editkitproduct.aspx":
                case "sortcomponents.aspx":
                case "sortkitproducts.aspx":
                case "viewcomponent.aspx":
                case "viewkitproduct.aspx":
                    return "Kitting";
                //case "productdiscounts.aspx":
                //    return "Discounts";
                case "editvolumepricing.aspx":
                    return "Volume Pricing";
                case "addspecial.aspx":
                case "editspecial.aspx":
                    return "Specials";
                case "editsimilarproducts.aspx":
                    return "Similar Products";
                case "editproductaccessories.aspx":
                    return "Upsell";
                case "editproductcategories.aspx":
                    return "Categories";
                case "editsubscription.aspx":
                    return "Subscriptions";
                case "editproducttemplate.aspx":
                    return "Templates";
                case "default.aspx":
                    string filePath = Request.Url.AbsolutePath.ToString().ToLowerInvariant();
                    if (filePath.EndsWith("specials/default.aspx")) return "Specials";
                    else if (filePath.EndsWith("kits/default.aspx")) return "Kitting";
                    break;
            }

            // default case
            return "Product";
        }
    }
}