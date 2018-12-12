namespace AbleCommerce.ConLib.Utility
{
    using System;
    using System.ComponentModel;
    using CommerceBuilder.Extensions;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Utility;

    [Description("Displays price with tax")]
    public partial class PriceWithTax : System.Web.UI.UserControl
    {
        private decimal _Price = 0;
        private int _TaxCodeId = 0;
        
        public decimal Price
        {
            set { _Price = AlwaysConvert.ToDecimal(value); }
        }

        public int TaxCodeId
        {
            set { _TaxCodeId = AlwaysConvert.ToInt(value); }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            PriceLiteral.Text = TaxHelper.GetShopPrice(_Price, _TaxCodeId).LSCurrencyFormat("ulc");
        }
    }
}