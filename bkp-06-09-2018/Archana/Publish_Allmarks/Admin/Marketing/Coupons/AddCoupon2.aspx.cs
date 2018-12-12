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
using CommerceBuilder.Shipping;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Marketing.Coupons
{
public partial class AddCoupon2 : AbleCommerceAdminPage
{
    protected CouponType CouponType
    {
        get
        {
            int couponType = AlwaysConvert.ToInt(Request.QueryString["CouponType"]);
            if ((couponType < 0) || (couponType > 2)) couponType = 0;
            return (CouponType)couponType;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Caption.Text = string.Format(Caption.Text, this.CouponType.ToString());
            trShipMethodRule.Visible = (this.CouponType == CouponType.Shipping);
            trProductRule.Visible = (this.CouponType != CouponType.Shipping);
            trQuantity.Visible = (this.CouponType == CouponType.Product);
            trValue.Visible = (this.CouponType != CouponType.Product);
        }
    }

    protected void ProductRule_SelectedIndexChanged(object sender, EventArgs e)
    {
        ProductRuleHelpText.Visible = (ProductRule.SelectedIndex > 0);
    }

    protected void ShipMethodRule_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindShipMethods();
    }

    protected void BindShipMethods()
    {
        ShipMethodList.Visible = (ShipMethodRule.SelectedIndex > 0);
        if (ShipMethodList.Visible)
        {
            ShipMethodList.DataSource = ShipMethodDataSource.LoadAll("Name");
            ShipMethodList.DataBind();
        }
    }

    protected void UseGroupRestriction_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGroups();
    }

    protected void BindGroups()
    {
        GroupListPanel.Visible = (UseGroupRestriction.SelectedIndex > 0);
        if (GroupListPanel.Visible)
        {
            GroupList.DataSource = GroupDataSource.LoadAll("Name");
            GroupList.DataBind();
        }
    }

    protected void BackButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddCoupon.aspx");
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        int couponId = SaveCoupon();
        if (couponId != 0) Response.Redirect("EditCoupon.aspx?CouponId=" + couponId.ToString());
    }

    protected int SaveCoupon()
    {
        if (Page.IsValid)
        {
            // VALIDATE IF A PROPER END DATE IS SELECTED           
            if (EndDate.SelectedEndDate != DateTime.MinValue && DateTime.Compare(EndDate.SelectedEndDate, StartDate.SelectedEndDate) < 0)
            {
                CustomValidator dateValidator = new CustomValidator();
                dateValidator.ControlToValidate = "Name"; // THIS SHOULD BE "EndDate" CONTROL, BUT THAT CANNOT BE VALIDATED
                dateValidator.Text = "*";
                dateValidator.ErrorMessage = "End date can not be earlier than start date.";
                dateValidator.IsValid = false;
                phEndDateValidator.Controls.Add(dateValidator);
                return 0;
            }

            Coupon existingCoupon = CouponDataSource.LoadForCouponCode(CouponCode.Text);
            if (existingCoupon != null)
            {
                CustomValidator codeValidator = new CustomValidator();
                codeValidator.ControlToValidate = "CouponCode";
                codeValidator.Text = "*";
                codeValidator.ErrorMessage = "The coupon code " + CouponCode.Text + " is already in use.";
                codeValidator.IsValid = false;
                phCouponCodeValidator.Controls.Add(codeValidator);
                return 0;
            }

            Coupon _Coupon = new Coupon();
            _Coupon.CouponType = this.CouponType;
            _Coupon.Name = Name.Text;
            _Coupon.CouponCode = CouponCode.Text;
            _Coupon.DiscountAmount = AlwaysConvert.ToDecimal(DiscountAmount.Text);
            _Coupon.IsPercent = (DiscountType.SelectedIndex == 0);
            //QUANTITY SETTINGS (PRODUCT COUPON)
            if (_Coupon.CouponType == CouponType.Product)
            {
                _Coupon.MinQuantity = AlwaysConvert.ToInt16(Quantity.Text);
                if (RepeatCoupon.Checked)
                {
                    _Coupon.MaxQuantity = 0;
                    _Coupon.QuantityInterval = _Coupon.MinQuantity;
                }
                else
                {
                    _Coupon.MaxQuantity = _Coupon.MinQuantity;
                    _Coupon.QuantityInterval = 0;
                }
                _Coupon.MaxValue = 0;
                _Coupon.MinPurchase = 0;
            }
            //PURCHASE RESTRICTIONS (ORDER AND SHIPPING COUPONS)
            else
            {
                _Coupon.MaxValue = AlwaysConvert.ToDecimal(MaxValue.Text);
                _Coupon.MinPurchase = AlwaysConvert.ToDecimal(MinPurchase.Text);
                _Coupon.MinQuantity = 0;
                _Coupon.MaxQuantity = 0;
                _Coupon.QuantityInterval = 0;
            }
            //SET START DATE
            _Coupon.StartDate = StartDate.SelectedDate;
            //SET END DATE
            _Coupon.EndDate = EndDate.SelectedEndDate;
            //MAX USES
            _Coupon.MaxUsesPerCustomer = AlwaysConvert.ToInt16(MaximumUsesPerCustomer.Text);
            _Coupon.MaxUses = AlwaysConvert.ToInt16(MaximumUses.Text);
            //COMBINE RULE
            _Coupon.AllowCombine = AllowCombine.Checked;
            //PRODUCT (OR SHIPPING) RULE
            if (_Coupon.CouponType != CouponType.Shipping) _Coupon.ProductRule = (CouponRule)ProductRule.SelectedIndex;
            else
            {
                _Coupon.ProductRule = (CouponRule)ShipMethodRule.SelectedIndex;
                _Coupon.ShipMethods.Clear();
                _Coupon.Save();
                if (_Coupon.ProductRule != CouponRule.All)
                {
                    foreach (ListItem item in ShipMethodList.Items)
                    {
                        ShipMethod shipMethod = ShipMethodDataSource.Load(AlwaysConvert.ToInt(item.Value));
                        if (item.Selected) _Coupon.ShipMethods.Add(shipMethod);
                    }
                }
            }
            //GROUP RESTRICTION
            if (UseGroupRestriction.SelectedIndex > 0)
            {
                _Coupon.Groups.Clear();
                _Coupon.Save();
                foreach (ListItem item in GroupList.Items)
                {
                    Group group = GroupDataSource.Load(AlwaysConvert.ToInt(item.Value));
                    if (item.Selected) _Coupon.Groups.Add(group);
                }
            }
            _Coupon.Save();
            return _Coupon.Id;
        }
        return 0;
    }
}
}
