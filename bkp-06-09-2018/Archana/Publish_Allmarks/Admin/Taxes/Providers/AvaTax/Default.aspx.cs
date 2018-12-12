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
using CommerceBuilder.Taxes.Providers.AvaTax;
using CommerceBuilder.Taxes.Providers.AvaTax.TaxService;
using CommerceBuilder.Taxes;
using CommerceBuilder.Utility;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Taxes.Providers.AvaTax
{
    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _TaxGatewayId;
        private TaxGateway _TaxGateway;
        private AvaTaxProvider _TaxProvider;

        protected void Page_Load(object sender, EventArgs e)
        {
            _TaxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(AvaTaxProvider)));
            if (_TaxGatewayId > 0) _TaxGateway = TaxGatewayDataSource.Load(_TaxGatewayId);
            if (_TaxGateway != null) _TaxProvider = _TaxGateway.GetProviderInstance() as AvaTaxProvider;
            if (_TaxProvider == null) _TaxProvider = new AvaTaxProvider();

            if (_TaxGateway == null)
            {
                _TaxGateway = new TaxGateway();

                _TaxGateway.ClassId = Misc.GetClassId(typeof(AvaTaxProvider));
                _TaxGateway.Name = _TaxProvider.Name;
                _TaxGateway.Store = AbleContext.Current.Store;
            }

            if (!Page.IsPostBack)
            {
                AccountNumber.Text = _TaxProvider.AccountNumber;
                CompanyCode.Text = _TaxProvider.CompanyCode;
                TaxServiceUrl.Text = _TaxProvider.TaxServiceUrl;
                EnableTaxCalculation.Checked = _TaxProvider.EnableTaxCalculation;
                TaxableProvinces.Text = _TaxProvider.TaxableProvinces;
                AddressServiceUrl.Text = _TaxProvider.AddressServiceUrl;
                EnableAddressValidation.Checked = _TaxProvider.EnableAddressValidation;
                AddressValidationCountries.Text = _TaxProvider.AddressValidationCountries;
                TaxReportMode_Breakdown.Checked = _TaxProvider.RecordTaxBreakdown;
                TaxReportMode_Summary.Checked = !_TaxProvider.RecordTaxBreakdown;
                SummaryTaxName.Text = _TaxProvider.SummaryTaxName;
                DebugMode.Checked = _TaxProvider.UseDebugMode;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            LicenseKey.Attributes.Add("value", _TaxProvider.License);
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                _TaxProvider.AccountNumber = AccountNumber.Text;
                _TaxProvider.License = LicenseKey.Text;
                _TaxProvider.CompanyCode = CompanyCode.Text;
                _TaxProvider.TaxServiceUrl = TaxServiceUrl.Text;
                _TaxProvider.EnableTaxCalculation = EnableTaxCalculation.Checked;
                _TaxProvider.TaxableProvinces = TaxableProvinces.Text.Replace(" ", string.Empty);
                _TaxProvider.AddressServiceUrl = AddressServiceUrl.Text;
                _TaxProvider.EnableAddressValidation = EnableAddressValidation.Checked;
                _TaxProvider.AddressValidationCountries = AddressValidationCountries.Text.Replace(" ", string.Empty);
                _TaxProvider.SummaryTaxName = SummaryTaxName.Text;
                _TaxProvider.RecordTaxBreakdown = TaxReportMode_Breakdown.Checked;
                _TaxProvider.UseDebugMode = DebugMode.Checked;
                _TaxGateway.UpdateConfigData(_TaxProvider.GetConfigData());
                _TaxGateway.Save();
                _TaxGatewayId = _TaxGateway.Id;

                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                SavedMessage.Visible = true;
            }
        }

        protected void TestButton_Click(object sender, EventArgs e)
        {
            AvaTaxProvider provider = (AvaTaxProvider)_TaxGateway.GetProviderInstance();
            PingResult result = provider.Ping();
            TestResultPanel.Visible = true;
            TestResultCode.Text = result.ResultCode.ToString();
            if (!string.IsNullOrEmpty(result.Version))
            {
                ServiceVersionLine.Visible = true;
                ServiceVersion.Text = result.Version;
            }
            if (result.Messages != null && result.Messages.Length > 0)
            {
                TestResultMessageLine.Visible = true;
                TestResultMessage.Text = result.Messages[0].Summary;
            }
        }
    }
}