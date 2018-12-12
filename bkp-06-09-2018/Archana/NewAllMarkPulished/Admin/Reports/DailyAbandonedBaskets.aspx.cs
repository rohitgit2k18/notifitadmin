using System;
using System.Collections;
using System.Collections.Generic;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Messaging;
using CommerceBuilder.Orders;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Reports
{
    public partial class DailyAbandonedBaskets : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = true;
        }

        protected void Page_SaveStateComplete(object sender, EventArgs e)
        {
            // END READ ONLY SESSION
            AbleContext.Current.Database.GetSession().DefaultReadOnly = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                DateTime tempDate = AlwaysConvert.ToDateTime(Request.QueryString["Date"], System.DateTime.MinValue);
                if (tempDate == System.DateTime.MinValue) tempDate = LocaleHelper.LocalNow;
                ViewState["ReportDate"] = tempDate;
                ReportDate.SelectedDate = tempDate;
                BindReport();
            }
        }

        protected void BindReport()
        {
            DateTime reportDate = AlwaysConvert.ToDateTime(ViewState["ReportDate"], DateTime.MinValue);            
            ReportCaption.Visible = true;
            ReportCaption.Text = string.Format(ReportCaption.Text, ReportDate.SelectedDate);
        }

        protected int GetUserId(int basketId)
        {
            Basket basket = BasketDataSource.Load(basketId);
            if (basket != null)
            {
                return basket.User.Id;
            }
            return basketId;
        }

        protected void ProcessButton_Click(Object sender, EventArgs e)
        {
            DateTime newReportDate = ReportDate.SelectedDate;
            ViewState["ReportDate"] = newReportDate;
            BindReport();
        }

        protected bool HasEmail(Object value)
        {
            int basketId = AlwaysConvert.ToInt(value);
            Basket basket = BasketDataSource.Load(basketId);
            if (basket.User.IsAnonymous)
            {
                if (basket.User.PrimaryAddress != null && !string.IsNullOrEmpty(basket.User.PrimaryAddress.Email))
                    return true;
                return false;
            }
            return true;
        }

        protected string GetBasketItems(object dataItem)
        {
            List<string> basketItems = new List<string>();
            CommerceBuilder.Reporting.BasketSummary summary = (CommerceBuilder.Reporting.BasketSummary)dataItem;
            Basket basket = BasketDataSource.Load(summary.BasketId);
            foreach (BasketItem basketItem in basket.Items)
            {
                if (basketItem.OrderItemType == OrderItemType.Product)
                {
                    basketItems.Add("[" + basketItem.Quantity + "]&nbsp;" + basketItem.Name);
                }
            }
            return string.Join(", ", basketItems.ToArray());
        }

        protected string GetCreateOrderUrl(object dataItem)
        {
            CommerceBuilder.Reporting.BasketSummary summary = (CommerceBuilder.Reporting.BasketSummary)dataItem;
            Basket basket = BasketDataSource.Load(summary.BasketId);
            return "~/admin/orders/create/createorder2.aspx?UID=" + basket.UserId;
        }

        protected string GetEditUserUrl(object dataItem)
        {
            CommerceBuilder.Reporting.BasketSummary summary = (CommerceBuilder.Reporting.BasketSummary)dataItem;
            Basket basket = BasketDataSource.Load(summary.BasketId);
            return "~/admin/people/users/edituser.aspx?UserId=" + basket.UserId;
        }

        protected string GetCustomerName(object dataItem)
        {
            CommerceBuilder.Reporting.BasketSummary summary = (CommerceBuilder.Reporting.BasketSummary)dataItem;
            Basket basket = BasketDataSource.Load(summary.BasketId);
            User user = basket.User;
            string fullName = user.PrimaryAddress.FullName;
            if (!string.IsNullOrEmpty(fullName)) return fullName;
            if (!string.IsNullOrEmpty(user.Email)) return user.Email;
            if (user.UserName.StartsWith("zz_anonymous_") ||
                AlwaysConvert.ToGuid(user.UserName) != Guid.Empty)
            {
                return "Anonymous";
            }
            return user.UserName;
        }

        protected void BasketsDs_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            DateTime reportDate = AlwaysConvert.ToDateTime(ViewState["ReportDate"], DateTime.MinValue);            
            e.InputParameters["year"] = reportDate.Year.ToString();
            e.InputParameters["month"] = reportDate.Month.ToString();
            e.InputParameters["day"] = reportDate.Day.ToString();
        }
    }
}