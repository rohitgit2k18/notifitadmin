namespace AbleCommerce
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using AbleCommerce.Code;
    using CommerceBuilder.Common;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Orders;
    using CommerceBuilder.Services.Checkout;
    using CommerceBuilder.Stores;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Users;
    using CommerceBuilder.Utility;
    using System.Web.UI;
    using System.Collections.Specialized;
    using System.Linq;
    using System.Web;
    using System.IO;
    using System.Web.Services;

    public partial class BasketPage : CommerceBuilder.UI.AbleCommercePage
    {
        private OrderItemType[] displayItemTypes = { OrderItemType.Product, OrderItemType.Discount, OrderItemType.Coupon, OrderItemType.GiftWrap };
        DataControlField _TaxColumn = null;
        DataControlField _ItemPrice = null;
        DataControlField _GST = null;
        DataControlField _TOTAL = null;
        IList<BasketItem> _DisplayedBasketItems;
        private bool _isBootstrapEnabled = false;
        private bool _volumeDiscountError = false;
        public bool showQuoteButton = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            showQuoteButton = CheckQuoteBasketItems();

            //TOGGLE VAT COLUMN
            _TaxColumn = BasketGrid.Columns[3];
            _TaxColumn.Visible = TaxHelper.ShowTaxColumn;
            _TaxColumn.HeaderText = TaxHelper.TaxColumnHeader;

            //TOGGLE PRICE COLUMNS
            _ItemPrice = BasketGrid.Columns[5];
            _ItemPrice.Visible = !showQuoteButton;
            _GST = BasketGrid.Columns[6];
            _GST.Visible = !showQuoteButton;
            _TOTAL = BasketGrid.Columns[7];
            _TOTAL.Visible = !showQuoteButton;

            _isBootstrapEnabled = PageHelper.IsResponsiveTheme(this);
        }

        private void BindBasketGrid()
        {
            //BIND THE GRID
            IList<BasketItem> items = GetBasketItems();
            items = ValidateVolumeOrder(items);
            BasketGrid.DataSource = items;
            BasketGrid.DataBind();
            bool showShippingEstimate = items.Count > 0;
            //BasketShippingEstimate1.Visible = showShippingEstimate;
            //PopularProductsDialog1.Visible = !showShippingEstimate;
            //ShippingEstimateUpdatePanel.Update();
        }

        private IList<BasketItem> GetBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Combine(basket);
            _DisplayedBasketItems = BasketHelper.GetDisplayItems(basket, false);
            return _DisplayedBasketItems;
        }

        protected void BasketGrid_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            //COMBINE FOOTER CELLS FOR SUBTOTAL
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                if (e.Row.Cells.Count > 2 && !_isBootstrapEnabled)
                {
                    int colspan = e.Row.Cells.Count - 1;
                    if (_TaxColumn == null || !_TaxColumn.Visible) colspan -= 1;
                    int iterations = e.Row.Cells.Count - 3;
                    for (int i = 0; i <= iterations; i++)
                    {
                        e.Row.Cells.RemoveAt(0);
                    }
                    e.Row.Cells[0].ColumnSpan = colspan;
                }
            }
        }

        protected void BasketGrid_DataBound(object sender, EventArgs e)
        {
            if (BasketGrid.Rows.Count > 0)
            {
                CheckoutButton.Visible = !AbleContext.Current.Store.Settings.ProductPurchasingDisabled;
                ClearBasketButton.Visible = true;
                UpdateButton.Visible = true;
                EmptyBasketPanel.Visible = false;
            }
            else
            {
                CheckoutButton.Visible = false;
                ClearBasketButton.Visible = false;
                UpdateButton.Visible = false;
                EmptyBasketPanel.Visible = true;
            }
        }

        private IList<BasketItem> ValidateVolumeOrder(IList<BasketItem> items)
        {
            IList<BasketItem> newBasketItems = new List<BasketItem>();
            List<string> warningMessages = new List<string>();
            foreach(var rec in items)
            {
                if (rec.OrderItemType == OrderItemType.Product)
                {
                    decimal MinQuantity = 0;

                    if (rec.Product.VolumeDiscounts.Any() && rec.Product.VolumeDiscounts[0].Levels.Any())
                    {
                        VolumeDiscount VolumeDiscount = rec.Product.VolumeDiscounts[0];
                        MinQuantity = VolumeDiscount.Levels.First().MinValue;
                    }
                    else
                    {
                        MinQuantity = rec.Product.MinQuantity;
                    }

                    if (rec.Quantity < MinQuantity)
                    {
                        _volumeDiscountError = true;
                        warningMessages.Add(String.Format("Cannot order '{0}' below the minumum quantity amount of '{1}'.", rec.Name, MinQuantity.ToString("0")));
                    }
                }
                //Remove Discount row from Basket
                if (rec.OrderItemType != OrderItemType.Discount)
                    newBasketItems.Add(rec);
            }

            OrderVolumeAmountMessageList.DataSource = warningMessages;
            OrderVolumeAmountMessageList.DataBind();

            return newBasketItems;
        }

        protected void BasketGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            Basket basket;
            int index;
            switch (e.CommandName)
            {
                case "SaveItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        basket.Items.MoveToWishlist(index, AbleContext.Current.User.PrimaryWishlist);
                    }
                    break;
                case "DeleteItem":
                    basket = AbleContext.Current.User.Basket;
                    index = basket.Items.IndexOf(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
                    if ((index > -1))
                    {
                        basket.Items.DeleteAt(index);
                    }
                    break;
                case "DeleteCoupon":
                    // get coupon to be deleted
                    string couponCode = e.CommandArgument.ToString();

                    // delete the coupon
                    basket = AbleContext.Current.User.Basket;
                    for (int i = basket.BasketCoupons.Count - 1; i >= 0; i--)
                    {
                        BasketCoupon cpn = basket.BasketCoupons[i];
                        if (cpn.Coupon.CouponCode == couponCode)
                        {
                            basket.BasketCoupons.DeleteAt(i);
                            break;
                        }
                    }

                    // delete items associated with the coupon
                    for (int i = basket.Items.Count - 1; i >= 0; i--)
                    {
                        BasketItem bitem = basket.Items[i];
                        if (bitem.OrderItemType == OrderItemType.Coupon && bitem.Sku == couponCode)
                        {
                            basket.Items.RemoveAt(i);
                        }
                    }
                    basket.Save();
                    break;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //GET ANY MESSAGES FROM SESSION
            IList<string> sessionMessages = Session["BasketMessage"] as IList<string>;
            //GET THE BASKET AND RECALCULATE
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            foreach (var rec in basket.Items) {
                rec.Price = Math.Abs(rec.Price);
            }
            //VALIDATE THE BASKET
            ValidationResponse response = preCheckoutService.Validate(basket);
            //DISPLAY ANY WARNING MESSAGES
            if ((!response.Success) || (sessionMessages != null))
            {
                if (sessionMessages != null)
                {
                    Session.Remove("BasketMessage");
                    sessionMessages.AddRange(response.WarningMessages);
                    WarningMessageList.DataSource = sessionMessages;
                }
                else
                {
                    WarningMessageList.DataSource = response.WarningMessages;
                }
                WarningMessageList.DataBind();
            }
            BindBasketGrid();
        }

        protected void ClearBasketButton_Click(object sender, EventArgs e)
        {
            IBasketService basketService = AbleContext.Resolve<IBasketService>();
            basketService.Clear(AbleContext.Current.User.Basket);
            BindBasketGrid();
        }

        protected void KeepShoppingButton_Click(object sender, EventArgs e)
        {
            Response.Redirect(AbleCommerce.Code.NavigationHelper.GetLastShoppingUrl());
        }

        protected void UpdateButton_Click(object sender, EventArgs e)
        {
            AbleCommerce.Code.BasketHelper.SaveBasket(BasketGrid);
            BindBasketGrid();
        }

        protected void CheckoutButton_Click(object sender, EventArgs e)
        {
            AbleCommerce.Code.BasketHelper.SaveBasket(BasketGrid);
            IBasketService service = AbleContext.Resolve<IBasketService>();
            ValidationResponse response = service.Validate(AbleContext.Current.User.Basket);
            if (response.Success) Response.Redirect(AbleCommerce.Code.NavigationHelper.GetCheckoutUrl());
            else Session["BasketMessage"] = response.WarningMessages;
        }

        protected decimal GetBasketSubtotal()
        {
            decimal basketTotal = 0;
            foreach (BasketItem bi in _DisplayedBasketItems)
            {
                basketTotal += (InvoiceHelper.GetInvoiceExtendedPrice(bi));
            }

            return basketTotal;
        }

        protected decimal GetBasketGrandtotal()
        {
            decimal grandTotal = 0;
            foreach (BasketItem bi in _DisplayedBasketItems)
            {
                grandTotal += (InvoiceHelper.GetInvoiceExtendedPrice(bi) * (decimal)1.1);
            }

            return grandTotal;
        }

        protected decimal GetBasketGSTtotal()
        {
            decimal gstTotal = 0;
            foreach (BasketItem bi in _DisplayedBasketItems)
            {
                gstTotal += (InvoiceHelper.GetGSTPrice(bi));
            }

            return gstTotal;
        }

        protected bool ShowProductImagePanel(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return ((item.OrderItemType == OrderItemType.Product));
        }

        protected bool IsProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return item.OrderItemType == OrderItemType.Product;
        }

        protected string GetProductUrl(object dataItem)
        {          
            BasketItem item = (BasketItem)dataItem;
            if (item.OrderItemType == OrderItemType.Product && item.Product != null)
            {
                NameValueCollection nvc = new NameValueCollection();
                nvc.Add("ItemId", item.Id.ToString());
                if (!string.IsNullOrEmpty(item.OptionList) && !string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Kits", item.KitList);
                    nvc.Add("Options", item.OptionList.Replace(",0", string.Empty));
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                else if (!string.IsNullOrEmpty(item.OptionList) && string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Options", item.OptionList.Replace(",0", string.Empty));
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                else if (string.IsNullOrEmpty(item.OptionList) && !string.IsNullOrEmpty(item.KitList))
                {
                    nvc.Add("Kits", item.KitList);
                    return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
                }
                
                return item.Product.NavigateUrl + UrlHelper.ToQueryString(nvc);
            }
            else return string.Empty;
        }

        protected bool IsParentProduct(object dataItem)
        {
            BasketItem item = (BasketItem)dataItem;
            return (item.OrderItemType == OrderItemType.Product && !item.IsChildItem);
        }

        [WebMethod]
        public static void RemoveFile(string name)
        {
            var originalDirectory = new DirectoryInfo(string.Format("{0}", HttpContext.Current.Server.MapPath(@"\")));
            string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "upload");
            var path = string.Format("{0}\\{1}", pathString, name);
            FileInfo TheFile = new FileInfo(path);
            if (TheFile.Exists)
            {
                // File found so delete it.
                TheFile.Delete();
            }

        }

        public void SaveUploadedFile(HttpFileCollection httpFileCollection)
        {
            // Clear Session data if no file uploades are made (IsPostBack does not work, need to clear session data on page re-load)
            List<FileAttachment> fileAttachments = new List<FileAttachment>();
            if (httpFileCollection.Count == 0)
            {
                // Delete previously uploaded files in SESSION to be erased
                fileAttachments = (List<FileAttachment>)Session["UPLOADED_BASKET"];
                if (fileAttachments != null && fileAttachments.Count > 0)
                {
                    foreach (var file in fileAttachments)
                    {
                        FileInfo TheFile = new FileInfo(file.path);
                        if (TheFile.Exists)
                        {
                            // File found so delete it.
                            TheFile.Delete();
                        }
                    }
                }

                Session["UPLOADED_BASKET"] = null;
            }
            fileAttachments = (List<FileAttachment>)Session["UPLOADED_BASKET"];

            string fName = "";
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                //Save file content goes here
                fName = file.FileName;
                if (file != null && file.ContentLength > 0)
                {

                    var originalDirectory = new DirectoryInfo(string.Format("{0}", Server.MapPath(@"\")));

                    string pathString = System.IO.Path.Combine(originalDirectory.ToString(), "upload");

                    var fileName1 = Path.GetFileName(file.FileName);


                    bool isExists = System.IO.Directory.Exists(pathString);

                    if (!isExists)
                        System.IO.Directory.CreateDirectory(pathString);

                    var path = string.Format("{0}\\{1}", pathString, file.FileName);

                    // Get file attachments
                    if (fileAttachments == null)
                    {
                        fileAttachments = new List<FileAttachment>();
                    }

                    fileAttachments.Add(new FileAttachment() { name = fileName1,  target_name = fileName1,  size = file.ContentLength, path = path });
                    Session["UPLOADED_BASKET"] = fileAttachments;
                    file.SaveAs(path);
                }

            }
        }

        public Boolean CheckQuoteBasketItems()
        {
            Basket basket = AbleContext.Current.User.Basket;
            IBasketService preCheckoutService = AbleContext.Resolve<IBasketService>();
            preCheckoutService.Recalculate(basket);
            return basket.Items.Any(item => item.OrderItemType == OrderItemType.Product && (item.Price <= 0 || !(item.Product.VolumeDiscounts.Any() && item.Product.VolumeDiscounts[0].Levels.Any())));
        }
    }
}