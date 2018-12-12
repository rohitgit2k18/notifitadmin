namespace AbleCommerce.ConLib
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Text;
    using System.Web.UI.WebControls.WebParts;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Marketing;
    using CommerceBuilder.Products;
    using CommerceBuilder.Utility;

    [Description("Displays all discounts applicable on a given product.")]
    public partial class ProductDiscountsDialog : System.Web.UI.UserControl
    {
        private string _Caption = "Available Discounts";
        private bool _ShowCustomFields = true;
        private Product _Product = null;

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue("Available Discounts")]
        [Description("Caption / Title of the control")]
        public string Caption
        {
            get { return _Caption; }
            set { _Caption = value; }
        }

        [Personalizable(), WebBrowsable()]
        [Browsable(true), DefaultValue(true)]
        [Description("If true custom fields will be shown")]
        public bool ShowCustomFields
        {
            get { return _ShowCustomFields; }
            set { _ShowCustomFields = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            CustomFields.Visible = this.ShowCustomFields;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool discountsFound = false;
            int _ProductId = AlwaysConvert.ToInt(Request.QueryString["ProductId"]);
            _Product = ProductDataSource.Load(_ProductId);
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
                        DiscountGrid.DataSource = availableDiscounts;
                        DiscountGrid.DataBind();
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
            StringBuilder levelPrice= new StringBuilder();
            levelList.Append("<tbody><tr><td class='header-qty'>Qty</td>");
            levelPrice.Append("<tr><td class='header-price'>Price</td>");
            VolumeDiscount discount = (VolumeDiscount)dataItem;
            foreach (VolumeDiscountLevel level in discount.Levels)
            {
                levelList.Append("<td>");
                levelPrice.Append("<td>");
                if (level.MinValue != 0)
                {
                    if (level.MaxValue != 0)
                    {
                        if (discount.IsValueBased) levelList.Append(string.Format("{0} - {1}", level.MinValue.LSCurrencyFormat("ulc"), level.MaxValue.LSCurrencyFormat("ulc")));
                        else levelList.Append(string.Format("{0:F0} - {1:F0}", level.MinValue, level.MaxValue));
                    }
                    else
                    {
                        //Was "at least {number}"
                        if (discount.IsValueBased) levelList.Append(string.Format("{0}+", level.MinValue.LSCurrencyFormat("ulc")));
                        else levelList.Append(string.Format("{0:F0}+", level.MinValue));
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
                if (level.IsPercent) levelPrice.Append(string.Format("{0:0.##}%", level.DiscountAmount));
                else
                    levelPrice.Append(string.Format("{0}", level.DiscountAmount.LSCurrencyFormat("ulc")));

                levelPrice.Append("</td>");
                levelList.Append("</td>");

            }

            levelList.Append("</tr>").Append(levelPrice.Append("</tr></tbody>"));
            return levelList.ToString();
        }
    }
}