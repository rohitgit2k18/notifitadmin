namespace AbleCommerce.Admin.ConLib
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Web.Caching;
    using System.Web.UI;
    using System.Xml;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.DigitalDelivery;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Products;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;

    public partial class AdminBreadCrumbs : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string cacheKey = "AdminBreadCrumb";
            string breadCrumbFileContent = (string)Cache[cacheKey];
            if (string.IsNullOrEmpty(breadCrumbFileContent))
            {
                // cache breadcrumb xml
                string breadCrumbFile = Server.MapPath("~/App_Data/adminbreadcrumb.xml");
                breadCrumbFileContent = File.ReadAllText(breadCrumbFile);
                Cache.Add(cacheKey, breadCrumbFileContent, new CacheDependency(breadCrumbFile), Cache.NoAbsoluteExpiration, Cache.NoSlidingExpiration, CacheItemPriority.Normal, null);
            }
            XmlDocument breadCrumbMap = new XmlDocument();
            breadCrumbMap.LoadXml(breadCrumbFileContent);
            string pagePath = Request.AppRelativeCurrentExecutionFilePath.ToLowerInvariant();
            if (pagePath.EndsWith("admin/menu.aspx") && !string.IsNullOrEmpty(Request.QueryString["path"])) pagePath += "?path=" + Request.QueryString["path"].ToLowerInvariant();
            List<BreadCrumbItem> breadCrumbList = GenerateBreadCrumbList(breadCrumbMap.DocumentElement, pagePath);
            if (breadCrumbList != null)
            {
                foreach (BreadCrumbItem item in breadCrumbList)
                {
                    ProcessRules(item);
                }
                List<BreadCrumbItem> expandedList = new List<BreadCrumbItem>();
                foreach (BreadCrumbItem item in breadCrumbList)
                {
                    expandedList.Add(item);
                    IList<BreadCrumbItem> childItems = GetChildItems(item);
                    if (childItems.Count > 0) expandedList.AddRange(childItems);
                }
                // the last link does not need to do anything
                expandedList[expandedList.Count - 1].Url = "#";
                expandedList[expandedList.Count - 1].CssClass = "current";
                BreadCrumbs.DataSource = expandedList;
                BreadCrumbs.DataBind();
            }
            else
            {
                // no breadcrumb data, hide this control
                this.Controls.Clear();
            }
        }

        private IList<BreadCrumbItem> GetChildItems(BreadCrumbItem item)
        {
            List<BreadCrumbItem> childItems = new List<BreadCrumbItem>();
            if (item.Title == "Catalog")
            {
                childItems.Add(new BreadCrumbItem("Categories", this.Page.ResolveUrl("~/admin/catalog/browse.aspx"), "root"));
                Category category = CategoryDataSource.Load(AbleCommerce.Code.PageHelper.GetCategoryId());
                if (category != null)
                {
                    string editUrl = this.Page.ResolveUrl("~/admin/catalog/browse.aspx?CategoryId=");
                    IList<CatalogPathNode> path = CatalogDataSource.GetPath(category.Id, false);
                    foreach (CatalogPathNode pathNode in path)
                    {
                        childItems.Add(new BreadCrumbItem(pathNode.Name, editUrl + pathNode.CatalogNodeId, "parent"));
                    }
                }
                /*
                Product product = ProductDataSource.Load(AbleCommerce.Code.PageHelper.GetProductId());
                if (product != null)
                {
                    string editUrl = "~/admin/products/editproduct.aspx?";
                    if (category != null) editUrl += "CategoryId=" + category.Id + "&";
                    editUrl += "ProductId=" + product.Id;
                    editUrl = this.Page.ResolveUrl(editUrl);
                    childItems.Add(new BreadCrumbItem(product.Name, editUrl, "parent"));
                }
                */
            }
            return childItems;
        }

        private List<BreadCrumbItem> GenerateBreadCrumbList(XmlNode rootNode, string pageUrl)
        {
            XmlNode targetNode = rootNode.SelectSingleNode("/breadCrumb//breadCrumb[@url='" + pageUrl + "']");
            if (targetNode != null)
            {
                List<BreadCrumbItem> breadCrumbs = new List<BreadCrumbItem>();
                breadCrumbs.Add(new BreadCrumbItem(targetNode.Attributes["title"].Value, pageUrl, "parent"));
                while (targetNode.ParentNode != rootNode)
                {
                    targetNode = targetNode.ParentNode;
                    XmlAttribute urlAttribute = targetNode.Attributes["url"];
                    string url = urlAttribute == null ? "#" : urlAttribute.Value;
                    breadCrumbs.Add(new BreadCrumbItem(targetNode.Attributes["title"].Value, url, "parent"));
                }
                breadCrumbs.Add(new BreadCrumbItem(rootNode.Attributes["title"].Value, Page.ResolveUrl(rootNode.Attributes["url"].Value), "root"));
                breadCrumbs.Reverse();
                return breadCrumbs;
            }
            return null;
        }

        private void ProcessRules(BreadCrumbItem breadCrumbItem)
        {
            int id;
            if (breadCrumbItem.Url == "#") return;
            switch (breadCrumbItem.Url.ToLowerInvariant())
            {
                case "~/admin/orders/shipments/editshipment.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["OrderShipmentId"]);
                    breadCrumbItem.Url += "?OrderShipmentId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, id);
                    break;
                case "~/admin/products/editproduct.aspx":
                case "~/admin/products/variants/variants.aspx":
                case "~/admin/products/variants/options.aspx":
                case "~/admin/products/digitalgoods/digitalgoods.aspx":
                case "~/admin/products/kits/editkit.aspx":
                case "~/admin/products/assets/images.aspx":
                case "~/admin/products/editproducttemplate.aspx":
                case "~/admin/products/specials/default.aspx":
                    int categoryId = AbleCommerce.Code.PageHelper.GetCategoryId();
                    id = AbleCommerce.Code.PageHelper.GetProductId();
                    Product product = ProductDataSource.Load(id);
                    if (categoryId > 0) breadCrumbItem.Url += "?CategoryId=" + categoryId + "&ProductId=" + id;
                    else breadCrumbItem.Url += "?ProductId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, product.Name);
                    break;
                case "~/admin/orders/vieworder.aspx":
                case "~/admin/orders/edit/editorderitems.aspx":
                case "~/admin/orders/viewdigitalgoods.aspx":
                case "~/admin/orders/payments/default.aspx":
                case "~/admin/orders/shipments/default.aspx":
                    id = AbleCommerce.Code.PageHelper.GetOrderId();
                    Order order = OrderDataSource.Load(id);
                    breadCrumbItem.Url += "?OrderNumber=" + order.OrderNumber;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, order.OrderNumber);
                    break;
                case "~/admin/marketing/coupons/editcoupon.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["CouponId"]);
                    Coupon coupon = CouponDataSource.Load(id);
                    breadCrumbItem.Url += "?CouponId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, coupon.Name);
                    break;
                case "~/admin/products/variants/editoption.aspx":
                case "~/admin/products/variants/editchoices.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["OptionId"]);
                    Option option = OptionDataSource.Load(id);
                    breadCrumbItem.Url += "?OptionId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, option.Name);
                    break;
                case "~/admin/products/giftwrap/editwrapgroup.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["WrapGroupId"]);
                    WrapGroup wrapGroup = WrapGroupDataSource.Load(id);
                    breadCrumbItem.Url += "?WrapGroupId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, wrapGroup.Name);
                    break;
                case "~/admin/marketing/email/managelist.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["EmailListId"]);
                    EmailList emailList = EmailListDataSource.Load(id);
                    if (emailList != null)
                    {
                        breadCrumbItem.Url += "?EmailListId=" + id;
                        breadCrumbItem.Title = string.Format(breadCrumbItem.Title, emailList.Name);
                    }
                    break;
                case "~/admin/marketing/discounts/editdiscount.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["VolumeDiscountId"]);
                    VolumeDiscount discount = VolumeDiscountDataSource.Load(id);
                    breadCrumbItem.Url += "?VolumeDiscountId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, discount.Name);
                    break;
                case "~/admin/catalog/editwebpage.aspx":
                    id = AbleCommerce.Code.PageHelper.GetWebpageId();
                    Webpage webpage = WebpageDataSource.Load(id);
                    breadCrumbItem.Url += "?WebpageId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, webpage.Name);
                    break;
                case "~/admin/catalog/editLink.aspx":
                    id = AbleCommerce.Code.PageHelper.GetLinkId();
                    Link link = LinkDataSource.Load(id);
                    breadCrumbItem.Url += "?LinkId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, link.Name);
                    break;
                case "~/admin/people/users/edituser.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["UserId"]);
                    User user = UserDataSource.Load(id);
                    breadCrumbItem.Url += "?UserId=" + id;
                    breadCrumbItem.Title = string.Format(breadCrumbItem.Title, user.UserName);
                    break;
                case "~/admin/digitalgoods/editdigitalgood.aspx":
                case "~/admin/digitalgoods/serialkeyproviders/defaultprovider/configure.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["DigitalGoodId"]);
                    DigitalGood dg = DigitalGoodDataSource.Load(id);
                    if (dg != null)
                    {
                        breadCrumbItem.Url += "?DigitalGoodId=" + id;
                        breadCrumbItem.Title = string.Format(breadCrumbItem.Title, dg.Name);
                    }
                    break;
                case "~/admin/products/producttemplates/editproducttemplate.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["ProductTemplateId"]);
                    ProductTemplate template = ProductTemplateDataSource.Load(id);
                    if (template == null)
                    {
                        InputField field = InputFieldDataSource.Load(AlwaysConvert.ToInt(Request.QueryString["InputFieldId"]));
                        if (field != null)
                        {
                            template = field.ProductTemplate;
                            id = template.Id;
                        }
                    }
                    if (template != null)
                    {
                        breadCrumbItem.Url += "?ProductTemplateId=" + id;
                        breadCrumbItem.Title = string.Format(breadCrumbItem.Title, template.Name);
                    }
                    else
                    {
                    }
                    break;
                case "~/admin/reports/dailyabandonedbaskets.aspx":
                    id = AlwaysConvert.ToInt(Request.QueryString["BasketId"]);
                    Basket basket = BasketDataSource.Load(id);
                    if (basket != null)
                    {
                        breadCrumbItem.Url += "?ReportDate=" + basket.User.LastActivityDate.Value.ToShortDateString();
                    }
                    break;
            }

            // resolve relative urls
            if (breadCrumbItem.Url.StartsWith("~/"))
                breadCrumbItem.Url = Page.ResolveUrl(breadCrumbItem.Url);
        }
    }

    public class BreadCrumbItem
    {
        public string Title { get; set; }
        public string Url { get; set; }
        public string CssClass { get; set; }
        public BreadCrumbItem(string title, string url, string cssClass)
        {
            this.Title = title;
            this.Url = url;
            this.CssClass = cssClass;
        }
    }
}