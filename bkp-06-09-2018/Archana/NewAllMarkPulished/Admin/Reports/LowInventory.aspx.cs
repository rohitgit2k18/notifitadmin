using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using AbleCommerce.Admin.UserControls;
using CommerceBuilder.DataExchange;
using System.Collections.Generic;
using CommerceBuilder.Messaging;
using System.Net.Mail;

namespace AbleCommerce.Admin.Reports
{
public partial class LowInventory : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private string _IconPath = string.Empty;

    protected void Page_InIt(object sender, EventArgs e)
    {
        _IconPath = AbleCommerce.Code.PageHelper.GetAdminThemeIconPath(this.Page);
        Manufacturers.DataSource = ManufacturerDataSource.LoadForStore(AbleContext.Current.StoreId);
        Manufacturers.DataBind();

        Vendors.DataSource = VendorDataSource.LoadForStore(AbleContext.Current.StoreId);
        Vendors.DataBind();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        ExportButton.Visible = InventoryGrid.Rows.Count > 0;
    }

    protected string GetName(object dataItem)
    {
        ProductInventoryDetail detail = (ProductInventoryDetail)dataItem;
        if (string.IsNullOrEmpty(detail.VariantName)) return detail.Name;
        return string.Format("{0} ({1})", detail.Name, detail.VariantName);
    }

    protected int GetNotificationsCount(object dataItem)
    {
        ProductInventoryDetail detail = (ProductInventoryDetail)dataItem;
        if (detail.ProductVariantId > 0) return RestockNotifyDataSource.CountForProductVariant(detail.ProductVariantId);
        else return RestockNotifyDataSource.CountForProduct(detail.ProductId);
    }

    protected string GetSendEmailLink(object dataItem)
    {        
        ProductInventoryDetail detail = (ProductInventoryDetail)dataItem;
        return string.Format("~/Admin/Reports/SendRestockAlert.aspx?ProductId={0}&ProductVariantId={1}&ReturnUrl={2}", detail.ProductId, detail.ProductVariantId, Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("~/Admin/Reports/LowInventory.aspx")));
    }

    protected string GetLastSent(object dataItem)
    {
        ProductInventoryDetail detail = (ProductInventoryDetail)dataItem;
        IList<RestockNotify> list = RestockNotifyDataSource.LoadForProduct(detail.ProductId);

        if (list != null)
        {
            DateTime lastDate = DateTime.MinValue;
            foreach (RestockNotify notify in list)
            {
                if (notify.LastSentDate > DateTime.MinValue && notify.LastSentDate > lastDate)
                    lastDate = notify.LastSentDate;
            }

            if (lastDate > DateTime.MinValue) return lastDate.ToShortDateString();
        }
        
        return string.Empty;
    }

    protected void InventoryGrid_DataBound(object sender, EventArgs e)
    {
        SaveButton.Visible = (InventoryGrid.Rows.Count > 0);
        SaveAndNotifyButton.Visible = SaveButton.Visible;
        InventoryGrid.GridLines = (SaveButton.Visible) ? GridLines.Both : GridLines.None;
        
    }

    private int GetControlValue(GridViewRow row, string controlId)
    {
        TextBox tb = row.FindControl(controlId) as TextBox;
        if (tb != null)
        {
            return AlwaysConvert.ToInt(tb.Text);
        }
        return 0;
    }    

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        UpdateInventory(false);
    }

    private void UpdateInventory(bool sendEmails)
    {
        foreach (GridViewRow row in InventoryGrid.Rows)
        {
            int dataItemIndex = row.DataItemIndex;
            dataItemIndex = (dataItemIndex - (InventoryGrid.PageSize * InventoryGrid.PageIndex));
            int productId = (int)InventoryGrid.DataKeys[dataItemIndex].Values[0];
            int productVariantId = AlwaysConvert.ToInt(InventoryGrid.DataKeys[dataItemIndex].Values[1].ToString());
            int inStock = GetControlValue(row, "InStock");
            int lowStock = GetControlValue(row, "LowStock");
            TextBox availDate = (TextBox)row.FindControl("AvailabilityDate");
            Product product = ProductDataSource.Load(productId);

            if (productVariantId.Equals(0))
            {
                product.InStock = inStock;
                product.InStockWarningLevel = lowStock;
                product.AvailabilityDate = LocaleHelper.ToLocalTime(AlwaysConvert.ToDateTime(availDate.Text, DateTime.MinValue));
                product.Save();

                if (sendEmails && product.InStock > 0)
                {
                    RestockNotify(sendEmails, product, null);
                }
            }
            else
            {
                ProductVariant variant = ProductVariantDataSource.Load(productVariantId);
                variant.InStock = inStock;
                variant.InStockWarningLevel = lowStock;
                variant.AvailabilityDate = LocaleHelper.ToLocalTime(AlwaysConvert.ToDateTime(availDate.Text, DateTime.MinValue));
                variant.Save();

                if (sendEmails && variant.InStock > 0)
                {
                    RestockNotify(sendEmails, product, variant);
                }
            }

        }
        SavedMessage.Text = string.Format(SavedMessage.Text, DateTime.Now);
        SavedMessage.Visible = true;
        InventoryGrid.DataBind();
    }

    private static void RestockNotify(bool sendEmails, Product product, ProductVariant variant)
    {
        // send emails
        try
        {
            IList<RestockNotify> list = null;
            if(variant != null) list = RestockNotifyDataSource.LoadForProductVariant(variant.Id);
            else list = RestockNotifyDataSource.LoadForProduct(product.Id);

            foreach (RestockNotify notification in list)
            {
                // load email template and send
                EmailTemplate emailTemplate = EmailTemplateDataSource.Load(AbleContext.Current.Store.Settings.InventoryRestockNotificationEmailTemplateId);
                if (emailTemplate != null)
                {
                    emailTemplate.Parameters["recipient"] = notification.Email;
                    emailTemplate.Parameters["product"] = product;
                    emailTemplate.Parameters["variant"] = variant;
                    emailTemplate.Parameters["store"] = AbleContext.Current.Store;

                    emailTemplate.Send(true);
                }

            }

            // remove records
            list.DeleteAll();
        }
        catch (Exception ex)
        {
            Logger.Error("Error sending restock notification email", ex);
        }
    }

    protected void SaveAndNotifyButton_Click(object sender, EventArgs e)
    {
        UpdateInventory(true);

    }

    protected string GetDate(Object value)
    {
        DateTime dateTime = (DateTime)value;
        if (dateTime != DateTime.MinValue)
            return dateTime.ToShortDateString();
        return string.Empty;
    }

    protected void ExportButton_Click(Object sender, EventArgs e)
    {
        GenericExportManager<InventorySummary> exportManager = GenericExportManager<InventorySummary>.Instance;
        GenericExportOptions<InventorySummary> options = new GenericExportOptions<InventorySummary>();
        options.CsvFields = new string[] { "Name", "InStock", "InStockWarningLevel", "AvailabilityDate", "VisibilityId" };

        IList<ProductInventoryDetail> inventoryDetail = ProductInventoryDataSource.GetLowProductInventory((InventoryLevel)AlwaysConvert.ToByte(InventoryLevel.SelectedValue), AlwaysConvert.ToInt(Manufacturers.SelectedValue), AlwaysConvert.ToInt(Vendors.SelectedValue));
        IList<InventorySummary> inventorySummaries = new List<InventorySummary>();
        foreach (ProductInventoryDetail detailItem in inventoryDetail)
            inventorySummaries.Add(new InventorySummary(GetName(detailItem), detailItem.InStock, detailItem.InStockWarningLevel, detailItem.AvailabilityDate, detailItem.VisibilityId));

        options.ExportData = inventorySummaries;
        options.FileTag = string.Format("PRODUCT_LOW_INVENTORY({0})", LocaleHelper.LocalNow.ToShortDateString());
        exportManager.BeginExport(options);
    }

    protected string GetVisibilityIconUrl(object dataItem)
    {
        return _IconPath + "Cms" + (((ProductInventoryDetail)dataItem).Visibility) + ".gif";
    }

    protected void InventoryGrid_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        if (e.CommandName.StartsWith("Do_"))
        {   
            switch (e.CommandName)
            {   
                case "Do_Pub":
                    // TOGGLE VISIBILITY
                    int productId = AlwaysConvert.ToInt(e.CommandArgument);
                    Product product = ProductDataSource.Load(productId);
                    switch (product.Visibility)
                    {
                        case CatalogVisibility.Public:
                            product.Visibility = CatalogVisibility.Hidden;
                            break;
                        case CatalogVisibility.Hidden:
                            product.Visibility = CatalogVisibility.Private;
                            break;
                        default:
                            product.Visibility = CatalogVisibility.Public;
                            break;
                    }
                    product.Save();
                    InventoryGrid.DataBind();
                    break;
            }
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        InventoryGrid.DataBind();
    }

    private class InventorySummary
    {
        public InventorySummary(string name, int inStock, int inStockWarningLevel, DateTime? availabilityDate, byte visibilityId)
        {
            this.Name = name;
            this.InStock = inStock;
            this.InStockWarningLevel = inStockWarningLevel;
            this.AvailabilityDate = availabilityDate;
            this.VisibilityId = visibilityId;
        }

        public string Name {get; set;}
        public int InStock {get; set;}
        public int InStockWarningLevel {get; set;}
        public DateTime? AvailabilityDate { get; set; }
        public byte VisibilityId { get; set; }
    }

}
}
