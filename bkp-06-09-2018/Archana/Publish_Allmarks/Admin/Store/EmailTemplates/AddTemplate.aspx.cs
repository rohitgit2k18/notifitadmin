using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Messaging;
using CommerceBuilder.Stores;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin._Store.EmailTemplates
{
public partial class AddTemplate : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected void Page_Init(object sender, EventArgs e)
    {
        InitTriggerGrid();
        MailFormat.Attributes.Add("onchange", "$get('" + MessageHtml.ClientID + "').style.visibility=(this.selectedIndex==0?'visible':'hidden');");
        MessageHtml.OnClientClick = "if(/^\\s*#.*?\\n/gm.test($get('" + Message.ClientID + "').value)){if(!confirm('WARNING: HTML editor may corrupt NVelocity script if you make changes in WYSIWYG mode.  Continue?'))return false;}";
        AbleCommerce.Code.PageHelper.SetHtmlEditor(Message, MessageHtml);

        if (!Page.IsPostBack)
        {
            EmailTemplate template = EmailTemplateDataSource.Load(AlwaysConvert.ToInt(Request.QueryString["EmailTemplateId"]));
            if (template == null)
            {
                // EXPECTED CASE, NEW TEMPLATE
                FromAddress.Text = "merchant";
            }
            else
            {
                // LOAD (FOR NEW COPY)
                Name.Text = StringHelper.Truncate("Copy of " + template.Name, 100);
                FromAddress.Text = template.FromAddress;
                ToAddress.Text = template.ToAddress;
                CCAddress.Text = template.CCList;
                BCCAddress.Text = template.BCCList;
                FromAddress.Text = template.FromAddress;
                Subject.Text = template.Subject;
                Message.Text = template.Body;
                MailFormat.SelectedIndex = (template.IsHTML ? 0 : 1);
                foreach (GridViewRow row in TriggerGrid.Rows)
                {
                    int eventId = AlwaysConvert.ToInt(TriggerGrid.DataKeys[row.RowIndex].Value);
                    if (template.Triggers.IndexOf(template.Id, eventId) > -1)
                    {
                        CheckBox selected = row.FindControl("Selected") as CheckBox;
                        if (selected != null) selected.Checked = true;
                    }
                }
            }
        }
    }

    private void InitTriggerGrid()
    {
        // BUILD A LIST SUPPORTED TRIGGER DATA
        List<EventTriggerDataItem> triggers = new List<EventTriggerDataItem>();
        EventTriggerDataItem trigger;

        // ORDER EVENTS
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderPlaced, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderPlaced), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderPaid, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderPaid), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderPaidNoShipments, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderPaidNoShipments), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderPaidPartial, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderPaidPartial), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderPaidCreditBalance, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderPaidCreditBalance), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderShipped, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderShipped), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderShippedPartial, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderShippedPartial), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.ShipmentShipped, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.ShipmentShipped), "Customer, Vendor", "$customer, $order, $payments, $shipment");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderNoteAddedByMerchant, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderNoteAddedByMerchant), "Customer, Vendor", "$customer, $order, $note");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderNoteAddedByCustomer, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderNoteAddedByCustomer), "Customer, Vendor", "$customer, $order, $note");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderStatusUpdated, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderStatusUpdated), "Customer, Vendor", "$customer, $order, $oldstatusname");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.OrderCancelled, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.OrderCancelled), "Customer, Vendor", "$customer, $order, $payments");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.GiftCertificateValidated, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.GiftCertificateValidated), "Customer, Vendor", "$customer, $order, $giftcertificate");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.PaymentAuthorized, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.PaymentAuthorized), "Customer, Vendor", "$customer, $order, $payment");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.PaymentAuthorizationFailed, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.PaymentAuthorizationFailed), "Customer, Vendor", "$customer, $order, $payment");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.PaymentCaptured, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.PaymentCaptured), "Customer, Vendor", "$customer, $order, $payment");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.PaymentCapturedPartial, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.PaymentCapturedPartial), "Customer, Vendor", "$customer, $order, $payment");
        triggers.Add(trigger);
        trigger = new EventTriggerDataItem((int)StoreEvent.PaymentCaptureFailed, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.PaymentCaptureFailed), "Customer, Vendor", "$customer, $order, $payment");
        triggers.Add(trigger);

        // CUSTOMER EVENTS
        trigger = new EventTriggerDataItem((int)StoreEvent.CustomerPasswordRequest, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.CustomerPasswordRequest), "Customer", "$customer, $resetPasswordLink");
        triggers.Add(trigger);

        // INVENTORY EVENTS
        trigger = new EventTriggerDataItem((int)StoreEvent.LowInventoryItemPurchased, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.LowInventoryItemPurchased), string.Empty, "$products");
        triggers.Add(trigger);

        // SUBSCRIPTION EVENTS
        trigger = new EventTriggerDataItem((int)StoreEvent.SubscriptionActivated, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.SubscriptionActivated), "Customer", "$order, $subscription, $customer");
        triggers.Add(trigger);

        trigger = new EventTriggerDataItem((int)StoreEvent.SubscriptionDeactivated, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.SubscriptionDeactivated), "Customer", "$order, $subscription, $customer");
        triggers.Add(trigger);

        trigger = new EventTriggerDataItem((int)StoreEvent.SubscriptionCancelled, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.SubscriptionCancelled), "Customer", "$order, $subscription, $customer");
        triggers.Add(trigger);

        trigger = new EventTriggerDataItem((int)StoreEvent.SubscriptionExpired, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.SubscriptionExpired), "Customer", "$order, $subscription, $customer");
        triggers.Add(trigger);

        // REVIEW EVENTS
        trigger = new EventTriggerDataItem((int)StoreEvent.ProductReviewSubmitted, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.ProductReviewSubmitted), "Customer", "$review, $products, $customer");
        triggers.Add(trigger);

        trigger = new EventTriggerDataItem((int)StoreEvent.ProductReviewApproved, AbleCommerce.Code.StoreDataHelper.GetFriendlyStoreEventName(StoreEvent.ProductReviewApproved), "Customer", "$review, $products, $customer");
        triggers.Add(trigger);


        // BIND THE EVENT DATA
        TriggerGrid.DataSource = triggers;
        TriggerGrid.DataBind();
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        EmailTemplate template = new EmailTemplate();
        template.Name = Name.Text;
        template.ToAddress = ToAddress.Text;
        template.FromAddress = FromAddress.Text;
        template.CCList = CCAddress.Text;
        template.BCCList = BCCAddress.Text;
        template.Subject = Subject.Text;        
        string temporaryFileName = Guid.NewGuid().ToString();
        template.ContentFileName = temporaryFileName;
        template.IsHTML = (MailFormat.SelectedIndex == 0);
        foreach (GridViewRow row in TriggerGrid.Rows)
        {
            CheckBox selected = row.FindControl("Selected") as CheckBox;
            if (selected.Checked)
            {
                StoreEvent storeEvent = AlwaysConvert.ToEnum<StoreEvent>(TriggerGrid.DataKeys[row.RowIndex].Value.ToString(), StoreEvent.None);
                template.Triggers.Add(new EmailTemplateTrigger(template, storeEvent));
            }
        }
        template.Save();

        // RENAME THE FILE AND SAVE        
        template.Body = Message.Text;
        template.ContentFileName = Regex.Replace(Name.Text, "[^a-zA-Z0-9 _-]", "") + " ID" + template.Id + ".html";
        template.Save();

        // DELETE TEMPORARY CONTENT FILE
        string templatesPath = "App_Data\\EmailTemplates\\" + AbleContext.Current.StoreId;
        templatesPath = Path.Combine(FileHelper.ApplicationBasePath, templatesPath);
        string tempFilePath = Path.Combine(templatesPath, temporaryFileName);
        try
        {
            if (File.Exists(tempFilePath))
            {
                File.Delete(tempFilePath);
            }
        }
        catch(Exception ex)
        {
            Logger.Warn("Error deleting temporary email template content file '" + tempFilePath + "'.", ex);
        }

        Response.Redirect("Default.aspx");
    }

    public class EventTriggerDataItem
    {
        private int _EventId;
        private string _Name;
        private string _EmailAliases;
        private string _NVelocityVariables;
        public int EventId { get { return _EventId; } }
        public string Name { get { return _Name; } }
        public string EmailAliases { get { return _EmailAliases; } }
        public string NVelocityVariables { get { return _NVelocityVariables; } }
        private EventTriggerDataItem() { }
        public EventTriggerDataItem(int eventId, string name, string emailAliases, string nVelocityVariables)
        {
            this._EventId = eventId;
            this._Name = name;
            this._EmailAliases = emailAliases;
            this._NVelocityVariables = nVelocityVariables;
        }
    }
}}
