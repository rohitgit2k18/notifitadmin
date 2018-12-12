namespace AbleCommerce.Admin.Taxes
{
    using System;
    using System.Web.UI;
    using CommerceBuilder.Taxes;
    using CommerceBuilder.Services.Taxes.AbleCommerce;
    using CommerceBuilder.Utility;

    public partial class Settings : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private TaxGateway _TaxGateway;
        private AbleCommerceTax _TaxProvider;

        protected void Page_Load(object sender, EventArgs e)
        {
            int taxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(AbleCommerceTax)));
            if (taxGatewayId > 0) _TaxGateway = TaxGatewayDataSource.Load(taxGatewayId);
            if (_TaxGateway != null) _TaxProvider = _TaxGateway.GetProviderInstance() as AbleCommerceTax;
            if (_TaxGateway == null) _TaxGateway = new TaxGateway();
            if (_TaxProvider == null) _TaxProvider = new AbleCommerceTax();
            SavedMessage.Visible = false;

            if (!Page.IsPostBack)
            {
                EnabledCheckBox.Checked = _TaxProvider.Activated ? true : false;
                switch (_TaxProvider.ShoppingDisplay)
                {
                    case TaxShoppingDisplay.Hide:
                        ShoppingDisplay.SelectedValue = "Hide";
                        break;
                    case TaxShoppingDisplay.Included:
                    case TaxShoppingDisplay.IncludedRegistered:
                        ShoppingDisplay.SelectedValue = "Included";
                        break;
                    case TaxShoppingDisplay.LineItem:
                    case TaxShoppingDisplay.LineItemRegistered:
                        ShoppingDisplay.SelectedValue = "LineItem";
                        break;
                }
                IncludeAnon.Checked = (_TaxProvider.ShoppingDisplay == TaxShoppingDisplay.Included) ||
                    (_TaxProvider.ShoppingDisplay == TaxShoppingDisplay.LineItem);
                switch (_TaxProvider.InvoiceDisplay)
                {
                    case TaxInvoiceDisplay.Summary:
                        InvoiceDisplay.SelectedValue = "Summary";
                        break;
                    case TaxInvoiceDisplay.Included:
                        InvoiceDisplay.SelectedValue = "Included";
                        break;
                    case TaxInvoiceDisplay.LineItem:
                        InvoiceDisplay.SelectedValue = "LineItem";
                        break;
                }
                ShowTaxColumn.Checked = _TaxProvider.ShowTaxColumn;
                TaxColumnHeader.Text = _TaxProvider.TaxColumnHeader;
            }
            ToggleConfig();
        }

        protected void Enabled_OnCheckedChanged(object sender, EventArgs e)
        {
            ToggleConfig();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            _TaxGateway.Name = _TaxProvider.Name;
            _TaxGateway.ClassId = Misc.GetClassId(typeof(AbleCommerceTax));
            _TaxProvider.Enabled = (EnabledCheckBox.Checked);
            _TaxProvider.PriceIncludesTax = false;
            switch (ShoppingDisplay.SelectedValue)
            {
                case "Hide":
                    _TaxProvider.ShoppingDisplay = TaxShoppingDisplay.Hide;
                    break;
                case "Included":
                    _TaxProvider.ShoppingDisplay = (IncludeAnon.Checked) ? TaxShoppingDisplay.Included : TaxShoppingDisplay.IncludedRegistered;
                    break;
                case "LineItem":
                    _TaxProvider.ShoppingDisplay = (IncludeAnon.Checked) ? TaxShoppingDisplay.LineItem : TaxShoppingDisplay.LineItemRegistered;
                    break;
            }
            switch (InvoiceDisplay.SelectedValue)
            {
                case "Summary":
                    _TaxProvider.InvoiceDisplay = TaxInvoiceDisplay.Summary;
                    break;
                case "Included":
                    _TaxProvider.InvoiceDisplay = TaxInvoiceDisplay.Included;
                    break;
                case "LineItem":
                    _TaxProvider.InvoiceDisplay = TaxInvoiceDisplay.LineItem;
                    break;
            }
            _TaxProvider.ShowTaxColumn = ShowTaxColumn.Checked;
            _TaxProvider.TaxColumnHeader = TaxColumnHeader.Text;
            _TaxGateway.UpdateConfigData(_TaxProvider.GetConfigData());
            _TaxGateway.Save();
            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }

        private void ToggleConfig()
        {
            bool enableConfig = (EnabledCheckBox.Checked);
            trShowShopPriceWithTax.Visible = enableConfig;
            trInvoiceDisplay.Visible = enableConfig;
            trShowTaxColumn.Visible = enableConfig;
            trTaxColumnHeader.Visible = enableConfig;
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!_TaxProvider.Enabled)
            {
                int taxRuleCount = TaxRuleDataSource.CountAll();
                TaxesDisabledPanel.Visible = (taxRuleCount > 0);
            }
            IncludeAnonPanel.Visible = (ShoppingDisplay.SelectedIndex != 0 && EnabledCheckBox.Checked);
        }

        protected void CancelButton_Click(Object sender, EventArgs e)
        {
            Response.Redirect("~/admin/menu.aspx?path=configure/taxes");
        }
    }
}