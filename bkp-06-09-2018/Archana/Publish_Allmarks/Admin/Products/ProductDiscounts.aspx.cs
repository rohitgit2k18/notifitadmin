namespace AbleCommerce.Admin.Products
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;
    using CommerceBuilder.Catalog;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    public partial class ProductDiscounts : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private Product _Product;

        protected void Page_Load(object sender, EventArgs e)
        {
            int productId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(productId);
            if (_Product == null) Response.Redirect("ManageProducts.aspx");
            Caption.Text = string.Format(Caption.Text, _Product.Name);
        }

        protected bool IsAttached(int discountId)
        {
            if (_Product != null)
            {
                return (_Product.VolumeDiscounts.IndexOf(discountId) > -1);
            }
            else return false;
        }

        protected string GetNames(VolumeDiscount discount)
        {
            if (discount.Groups.Count == 0) return string.Empty;
            List<string> groupNames = new List<string>();
            foreach (CommerceBuilder.Users.Group group in discount.Groups)
            {
                groupNames.Add(group.Name);
            }
            return string.Join(",", groupNames.ToArray());
        }

        protected string GetLevels(VolumeDiscount discount)
        {
            if (discount.Levels.Count == 0) return string.Empty;
            List<string> levels = new List<string>();
            string from;
            string to;
            string amount;
            foreach (VolumeDiscountLevel level in discount.Levels)
            {
                if (level.MinValue == 0) from = "any";
                else from = level.MinValue.ToString("0.##");
                if (level.MaxValue == 0) to = "any";
                else to = level.MaxValue.ToString("0.##");
                if (level.IsPercent)
                    amount = string.Format("{0:0.##}%", level.DiscountAmount);
                else amount = level.DiscountAmount.LSCurrencyFormat("lc");
                levels.Add(string.Format("from {0} to {1} - {2}", from, to, amount));
            }
            return string.Join("<br />", levels.ToArray());
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            //CLEAR OUT EXISTING ASSIGNMENTS
            foreach (GridViewRow row in DiscountGrid.Rows)
            {
                int discountId = (int)DiscountGrid.DataKeys[row.DataItemIndex].Value;
                VolumeDiscount discount = VolumeDiscountDataSource.Load(discountId);
                CheckBox attached = (CheckBox)row.FindControl("Attached");
                if ((attached != null) && attached.Checked)
                {
                    if (!discount.Products.Contains(_Product))
                        discount.Products.Add(_Product);
                }
                else
                {
                    if (discount.Products.Contains(_Product))
                        discount.Products.Remove(_Product);
                }

                discount.Save();
            }
            SavedMessage.Visible = true;
        }
    }
}