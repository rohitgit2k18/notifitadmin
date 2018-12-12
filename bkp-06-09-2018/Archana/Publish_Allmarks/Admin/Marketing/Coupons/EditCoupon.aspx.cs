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
using CommerceBuilder.Shipping;
using CommerceBuilder.Users;

namespace AbleCommerce.Admin.Marketing.Coupons
{
public partial class EditCoupon : AbleCommerceAdminPage
{
    private Coupon _Coupon;
    private int _CouponId = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        _CouponId = AlwaysConvert.ToInt(Request.QueryString["CouponId"]);
        _Coupon = CouponDataSource.Load(_CouponId);
        if (_Coupon == null) Response.Redirect("Default.aspx");
        if (!Page.IsPostBack)
        {
            Caption.Text = string.Format(Caption.Text, _Coupon.Name);
            trShipMethodRule.Visible = (_Coupon.CouponType == CouponType.Shipping);
            trProductRule.Visible = (_Coupon.CouponType != CouponType.Shipping);
            trQuantity.Visible = (_Coupon.CouponType == CouponType.Product);
            trValue.Visible = (_Coupon.CouponType != CouponType.Product);
            Name.Text = _Coupon.Name;
            CouponCode.Text = _Coupon.CouponCode;
            DiscountAmount.Text = string.Format("{0:F2}", _Coupon.DiscountAmount);
            DiscountType.SelectedIndex = (_Coupon.IsPercent ? 0 : 1);
            //QUANTITY FOR PRODUCT COUPONS
            if (_Coupon.MinQuantity > 0) Quantity.Text = string.Format("{0:F0}", _Coupon.MinQuantity);
            RepeatCoupon.Checked = (_Coupon.MaxQuantity != _Coupon.MinQuantity);
            //VALUE RESTRICTIONS FOR ORDER AND SHIPPING COUPONS
            if (_Coupon.MaxValue > 0) MaxValue.Text = string.Format("{0:F2}", _Coupon.MaxValue);
            if (_Coupon.MinPurchase > 0) MinPurchase.Text = string.Format("{0:F2}", _Coupon.MinPurchase);
            //START DATE
            StartDate.SelectedDate = _Coupon.StartDate.HasValue?_Coupon.StartDate.Value : DateTime.MinValue;
            //END DATE
            EndDate.SelectedDate = _Coupon.EndDate.HasValue ? _Coupon.EndDate.Value : DateTime.MinValue;
            //MAX USES
            if (_Coupon.MaxUsesPerCustomer > 0) MaximumUsesPerCustomer.Text = string.Format("{0:F0}", _Coupon.MaxUsesPerCustomer);
            if (_Coupon.MaxUses > 0) MaximumUses.Text = string.Format("{0:F0}", _Coupon.MaxUses);
            //COMBINE RULE
            AllowCombine.Checked = _Coupon.AllowCombine;
            //PRODUCT RULE
            ProductRule.SelectedIndex = _Coupon.ProductRuleId;
            BindProducts();
            //SHIP METHOD RULE
            ShipMethodRule.SelectedIndex = _Coupon.ProductRuleId;
            BindShipMethods();
            //GROUP RESTRICTION
            UseGroupRestriction.SelectedIndex = (_Coupon.Groups.Count > 0) ? 1 : 0;
            BindGroups();

            // SHOW SAVE CONFIRMATION NOTIFICATION IF NEEDED
            if (Request.UrlReferrer != null && Request.UrlReferrer.AbsolutePath.ToLowerInvariant().EndsWith("addcoupon.aspx"))
            {
                SavedMessage.Visible = true;
                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            }
        }
    }

    protected void ProductRule_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindProducts();
    }

    protected void BindProducts()
    {
        ProductRulePanel.Visible = (ProductRule.SelectedIndex > 0);
        if (ProductRulePanel.Visible)
        {
            ProductCount.Text = string.Format(ProductCount.Text, _Coupon.Products.Count);
        }
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
            foreach (ShipMethod shipMethod in _Coupon.ShipMethods)
            {
                ListItem listItem = ShipMethodList.Items.FindByValue(shipMethod.Id.ToString());
                if (listItem != null) listItem.Selected = true;
            }
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
            foreach (Group group in _Coupon.Groups)
            {
                ListItem listItem = GroupList.Items.FindByValue(group.Id.ToString());
                if (listItem != null) listItem.Selected = true;
            }
        }
    }

    protected void BackButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        bool result = SaveCoupon();
        if (result && ((Button)sender).ID == "SaveAndCloseButton") Response.Redirect("Default.aspx");
    }

    protected bool SaveCoupon()
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
                return false;
            }

            Coupon existingCoupon = CouponDataSource.LoadForCouponCode(CouponCode.Text);
            if (existingCoupon != null && existingCoupon.Id != _Coupon.Id)
            {
                CustomValidator codeValidator = new CustomValidator();
                codeValidator.ControlToValidate = "CouponCode";
                codeValidator.Text = "*";
                codeValidator.ErrorMessage = "The coupon code " + CouponCode.Text + " is already in use.";
                codeValidator.IsValid = false;
                phCouponCodeValidator.Controls.Add(codeValidator);
                return false;
            }

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
            else
            {
                _Coupon.Groups.Clear();
                _Coupon.Save();
            }
            _Coupon.Save();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
            return true;
        }
        return false;
    }

    protected void ManageCouponProducts_Click(object sender, EventArgs e)
    {
        if (SaveCoupon())
        {
            Response.Redirect("CouponProducts.aspx?CouponId=" + _CouponId.ToString());
        }
    }

}
}
