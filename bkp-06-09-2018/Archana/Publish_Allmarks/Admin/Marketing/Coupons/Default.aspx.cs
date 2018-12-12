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
using CommerceBuilder.UI;
using CommerceBuilder.Marketing;
using CommerceBuilder.Utility;
using System.Collections.Generic;
using CommerceBuilder.Users;
using CommerceBuilder.Extensions;
using System.Web.Services;
using CommerceBuilder.Common;
using System.Web.Script.Serialization;

namespace AbleCommerce.Admin.Marketing.Coupons
{
public partial class _Default : AbleCommerceAdminPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SearchFilter filter = Session["CouponSearchFilter"] as SearchFilter;
        if (filter == null) filter = new SearchFilter();
        var serializer = new JavaScriptSerializer();
        var result = serializer.Serialize(filter);
        ScriptManager.RegisterClientScriptBlock(Page, typeof(Page), "searchQueryJson", "var searchFilter = " + result + ";", true);
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        gridFooter.Visible = CouponGrid.Rows.Count > 0;
    }

    protected string GetDiscount(Coupon item)
    {
        if (item.IsPercent) return string.Format("{0:f2}%", item.DiscountAmount);
        return item.DiscountAmount.LSCurrencyFormat("lc");
    }

    protected string GetNames(Coupon item)
    {
        List<string> groupNames = new List<string>();
        foreach (Group link in item.Groups)
        {
            groupNames.Add(link.Name);
        }
        return string.Join(", ", groupNames.ToArray());
    }

    protected int GetUseCount(string couponCode)
    {
        return CouponDataSource.CountUses(couponCode);
    }

    protected void CouponGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Coupon coupon = (Coupon)e.Row.DataItem;
            Panel maximumValuePanel = (Panel)e.Row.FindControl("MaxValuePanel");
            if (maximumValuePanel != null) maximumValuePanel.Visible = (coupon.MaxValue > 0);
            Panel minimumPurchasePanel = (Panel)e.Row.FindControl("MinPurchasePanel");
            if (minimumPurchasePanel != null) minimumPurchasePanel.Visible = (coupon.MinPurchase > 0);
            Panel startDatePanel = (Panel)e.Row.FindControl("StartDatePanel");
            if (startDatePanel != null) startDatePanel.Visible = (coupon.StartDate > DateTime.MinValue);
            Panel endDatePanel = (Panel)e.Row.FindControl("EndDatePanel");
            if (endDatePanel != null) endDatePanel.Visible = (coupon.EndDate > DateTime.MinValue);
            Panel maximumUsesPanel = (Panel)e.Row.FindControl("MaximumUsesPanel");
            if (maximumUsesPanel != null) maximumUsesPanel.Visible = (coupon.MaxUses > 0);
            Panel maximumUsesPerCustomerPanel = (Panel)e.Row.FindControl("MaximumUsesPerCustomerPanel");
            if (maximumUsesPerCustomerPanel != null) maximumUsesPerCustomerPanel.Visible = (coupon.MaxUsesPerCustomer > 0);
            Panel groupsPanel = (Panel)e.Row.FindControl("GroupsPanel");
            if (groupsPanel != null) groupsPanel.Visible = (coupon.Groups.Count > 0);
        }
    }

    protected void CouponGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("Copy"))
        {
            int couponId = AlwaysConvert.ToInt(e.CommandArgument);
            Coupon coupon = CouponDataSource.Load(couponId);
            if (coupon != null)
            {
                Coupon newCoupon = coupon.Clone(true);
                // THE NAME SHOULD NOT EXCEED THE MAX 100 CHARS
                String newName = "Copy of " + newCoupon.Name;
                if (newName.Length > 100)
                {
                    newName = newName.Substring(0, 97) + "...";
                }
                newCoupon.Name = newName;
                newCoupon.CouponCode = StringHelper.RandomString(12);
                newCoupon.Save();
            }
            CouponGrid.DataBind();
        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        CouponGrid.DataBind();
        Session["CouponSearchFilter"] = new SearchFilter(CouponCode.Text.Trim(), AlwaysConvert.ToEnum<CouponUsageFilter>(UsageFilter.SelectedValue, CouponUsageFilter.Any));
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        CouponCode.Text = string.Empty;
        UsageFilter.SelectedIndex = 0;

        Session.Remove("CouponSearchFilter");
    }

    [WebMethod()]
    public static bool DeleteCoupons(int[] couponIds)
    {
        List<string> ids = new List<string>();
        IDatabaseSessionManager database = AbleContext.Current.Database;
        database.BeginTransaction();
        foreach (int cid in couponIds)
        {
            CouponDataSource.Delete(cid);
        }
        database.CommitTransaction();
        return true;
    }

    [WebMethod()]
    public static bool DeleteAllCoupons(SearchFilter filter)
    {
        IList<Coupon> coupons = CouponDataSource.Search(filter.CouponCode, filter.UsageFilter);
        if (coupons != null)
        {
            IDatabaseSessionManager database = AbleContext.Current.Database;
            database.BeginTransaction();
            coupons.DeleteAll();
            database.CommitTransaction();
            return true;
        }
        else return false;
    }

    public class SearchFilter
    {
        public SearchFilter()
        {
            this.CouponCode = string.Empty;
            this.UsageFilter = CouponUsageFilter.Any;
        }

        public SearchFilter(string couponCode, CouponUsageFilter usageFilter)
        {
            this.CouponCode = couponCode;
            this.UsageFilter = usageFilter;
        }

        public string CouponCode { get; set; }
        public CouponUsageFilter UsageFilter { get; set; }
    }
}
}
