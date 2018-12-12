using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls.WebParts;
using CommerceBuilder.Extensions;
using CommerceBuilder.Marketing;
using CommerceBuilder.Products;
using CommerceBuilder.Utility;

namespace AbleCommerce.Mobile.UserControls
{
    public partial class ProductDiscountsDialog : System.Web.UI.UserControl
    {
        private string _Caption = "Available Discounts";

        [Personalizable(), WebBrowsable()]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool discountsFound = false;
            int _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            Product _Product = ProductDataSource.Load(_ProductId);
            if (_Product != null)
            {
                IList<VolumeDiscount> availableDiscounts = VolumeDiscountDataSource.GetAvailableDiscounts(_ProductId);
                if (availableDiscounts.Count > 0)
                {
                    //SEE WHETHER THERE IS ONE DISCOUNT
                    //AND IT ALWAYS HAS NO VALUE
                    bool show = true;
                    if (availableDiscounts.Count == 1)
                    {
                        VolumeDiscount testDiscount = availableDiscounts[0];
                        if (testDiscount.Levels.Count == 1)
                        {
                            VolumeDiscountLevel testLevel = testDiscount.Levels[0];
                            show = ((testLevel.MinValue > 1) || (testLevel.DiscountAmount > 0));
                        }
                    }
                    if (show)
                    {
                        phCaption.Text = this.Caption;
                        DiscountsGrid.DataSource = availableDiscounts;
                        DiscountsGrid.DataBind();
                        discountsFound = true;
                    }
                }
            }
            //DO NOT DISPLAY THIS CONTROL IF NO DISCOUNTS AVAILABLE
            if (!discountsFound) this.Controls.Clear();
        }

        protected string GetLevels(object dataItem)
        {
            StringBuilder levelList = new StringBuilder();
            levelList.Append("<ul>");
            VolumeDiscount discount = (VolumeDiscount)dataItem;
            foreach (VolumeDiscountLevel level in discount.Levels)
            {
                levelList.Append("<li>buy ");
                if (level.MinValue != 0)
                {
                    if (level.MaxValue != 0)
                    {
                        if (discount.IsValueBased) levelList.Append(string.Format("{0} to {1}", level.MinValue.LSCurrencyFormat("ulc"), level.MaxValue.LSCurrencyFormat("ulc")));
                        else levelList.Append(string.Format("{0:F0} to {1:F0}", level.MinValue, level.MaxValue));
                    }
                    else
                    {
                        if (discount.IsValueBased) levelList.Append(string.Format("at least {0}", level.MinValue.LSCurrencyFormat("ulc")));
                        else levelList.Append(string.Format("at least {0:F0}", level.MinValue));
                    }
                }
                else if (level.MaxValue != 0)
                {
                    if (discount.IsValueBased) levelList.Append(string.Format("up to {0}", level.MaxValue.LSCurrencyFormat("ulc")));
                    else levelList.Append(string.Format("up to {0:F0}", level.MaxValue));
                }
                else
                {
                    levelList.Append("any");
                }
                levelList.Append(", save ");
                if (level.IsPercent) levelList.Append(string.Format("{0:0.##}%", level.DiscountAmount));
                else levelList.Append(string.Format("{0} each", level.DiscountAmount.LSCurrencyFormat("ulc")));
                levelList.Append("</li>");
            }
            levelList.Append("</ul>");
            return levelList.ToString();
        }
    }
}