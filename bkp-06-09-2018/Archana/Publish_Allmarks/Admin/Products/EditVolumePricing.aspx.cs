namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Data;
    using System.Configuration;
    using System.Collections;
    using System.Collections.Generic;
    using System.Web;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.WebControls.WebParts;
    using System.Web.UI.HtmlControls;
    using CommerceBuilder.UI;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Utility;
    using CommerceBuilder.Users;
    using CommerceBuilder.Common;
    using CommerceBuilder.Products;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.DomainModel;
    using CommerceBuilder.Extensions;

    public partial class EditVolumePricing : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private VolumeDiscount _VolumeDiscount;
        private int _VolumeDiscountId = 0;

        private Product _Product;
        private int _ProductId = 0;
        private Boolean _IsAdd = false;

        protected void Page_Init(object sender, EventArgs e)
        {

            _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
            if (_Product != null)
            {
                if (_Product.VolumeDiscounts.Count > 0)
                {
                    _VolumeDiscountId = _Product.VolumeDiscounts[0].Id;
                    _VolumeDiscount = _Product.VolumeDiscounts[0];
                    _IsAdd = false;
                }
                else
                {
                    _IsAdd = true;
                    _VolumeDiscount = new VolumeDiscount();
                    _VolumeDiscount.Name = _Product.Name;
                    _VolumeDiscount.Products.Add(_Product);
                    _VolumeDiscount.Save();
                    _VolumeDiscountId = _VolumeDiscount.Id;
                    VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel();
                    _VolumeDiscount.Levels.Add(newDiscountLevel);
                }

                DiscountLevelGrid.DataSource = _VolumeDiscount.Levels;
                DiscountLevelGrid.DataBind();
            }
        }

        protected string GetLevelValue(decimal levelValue)
        {
            if (levelValue == 0) return string.Empty;
            return string.Format("{0:0.##}", levelValue);
        }

        protected void AddRowButton_Click(object sender, EventArgs e)
        {
            SaveDiscount();
            VolumeDiscount discount = _VolumeDiscount;
            VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel();
            discount.Levels.Add(newDiscountLevel);
            discount.Save();
            DiscountLevelGrid.DataSource = discount.Levels;
            DiscountLevelGrid.DataBind();
        }

        protected void DiscountLevelGrid_PreRender(object sender, EventArgs e)
        {
            VolumeDiscount discount = _VolumeDiscount;
            if (discount != null)
            {
                if (discount.Levels.Count == 0)
                {
                    VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel();
                    discount.Levels.Add(newDiscountLevel);
                }
            }

            //Moved DataBind to Page_Init
        }

        private void SaveDiscount()
        {
            VolumeDiscount discount = _VolumeDiscount;
            discount.Name = _Product.Name;
            //LOOP THROUGH GRID ROWS AND SET MATRIX
            int rowIndex = 0;
            foreach (GridViewRow row in DiscountLevelGrid.Rows)
            {
                if (discount.Levels.Count < (rowIndex + 1))
                {
                    // ADD A NEW DISCOUNT LEVEL FOR NEW ROWS
                    VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel();
                    newDiscountLevel.VolumeDiscountId = _VolumeDiscountId;
                    discount.Levels.Add(newDiscountLevel);
                }
                decimal minValue = AlwaysConvert.ToDecimal(((TextBox)row.FindControl("MinValue")).Text);
                decimal maxValue = AlwaysConvert.ToDecimal(((TextBox)row.FindControl("MaxValue")).Text);
                decimal discountAmount = AlwaysConvert.ToDecimal(((TextBox)row.FindControl("DiscountAmount")).Text);
                bool isPercent = false;
                VolumeDiscountLevel thisLevel = discount.Levels[rowIndex];
                thisLevel.MinValue = minValue;
                thisLevel.MaxValue = maxValue;
                thisLevel.DiscountAmount =  discountAmount;
                thisLevel.IsPercent = isPercent;
                rowIndex++;

            }
            //SCOPE
            discount.IsGlobal = false;
            discount.Save();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                SaveDiscount();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            _VolumeDiscount = VolumeDiscountDataSource.Load(_VolumeDiscountId);

            //Removed '!Page.IsPostBack check
            AddCaption.Visible = _IsAdd;
            EditCaption.Visible = !AddCaption.Visible;
            if (EditCaption.Visible)
            {
                if(_VolumeDiscount != null)
                    EditCaption.Text = string.Format(EditCaption.Text, _VolumeDiscount.Name);
            }
        }

        protected void UseGlobalScope_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void DiscountLevelGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            DropDownList IsPercent = (DropDownList)e.Row.FindControl("IsPercent");
            if (IsPercent != null)
            {
                IsPercent.SelectedIndex = ((VolumeDiscountLevel)e.Row.DataItem).IsPercent ? 0 : 1;
            }
        }

        protected void DiscountLevelGrid_OnRowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int index = e.RowIndex;
            SaveDiscount();
            VolumeDiscount discount = _VolumeDiscount;
            if (discount.Levels.Count >= (index + 1))
            {
                discount.Levels.DeleteAt(index);
                discount.Save();
            }

            DiscountLevelGrid.DataSource = discount.Levels;
            DiscountLevelGrid.DataBind();
        }
    }
}