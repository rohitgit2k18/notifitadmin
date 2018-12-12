using System;
using CommerceBuilder.Taxes;
using CommerceBuilder.Taxes.Providers.TaxCloud;
using CommerceBuilder.Utility;
using CommerceBuilder.Taxes.Providers.TaxCloud.TaxCloudService;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Taxes.Providers.TaxCloud
{
    public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
    {
        private int _TaxGatewayId;
        private TaxGateway _TaxGateway;
        private TaxCloudProvider _TaxProvider;

        protected void Page_Load(object sender, EventArgs e)
        {
            _TaxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(TaxCloudProvider)));
            if (_TaxGatewayId > 0) _TaxGateway = TaxGatewayDataSource.Load(_TaxGatewayId);
            if (_TaxGateway != null) _TaxProvider = _TaxGateway.GetProviderInstance() as TaxCloudProvider;            
            if (_TaxProvider == null) _TaxProvider = new TaxCloudProvider();

            if (_TaxGateway == null)
            {
                _TaxGateway = new TaxGateway();

                _TaxGateway.ClassId = Misc.GetClassId(typeof(TaxCloudProvider));
                _TaxGateway.Name = _TaxProvider.Name;
                _TaxGateway.Store = AbleContext.Current.Store;
            }

            if (!Page.IsPostBack)
            {
                EnableTaxCloud.Checked = _TaxProvider.EnableTaxCloud;
                ApiId.Text = _TaxProvider.ApiId;
                ApiKey.Text = _TaxProvider.ApiKey;
                
                DefaultTIC.Text = _TaxProvider.DefaultTIC;
                ShippingTIC.Text = _TaxProvider.ShippingTIC;
                HandlingTIC.Text = _TaxProvider.HandlingTIC;
                GiftwrapTIC.Text = _TaxProvider.GiftwrapTIC;

                USPSUserId.Text = _TaxProvider.USPSUserId;
                TaxServiceUrl.Text = _TaxProvider.TaxServiceUrl;
                DebugMode.Checked = _TaxProvider.UseDebugMode;
                EnableAddressValidation.Checked = _TaxProvider.EnableAddressValidation;
                TaxName.Text = _TaxProvider.TaxName;
                UseTaxExemption.Checked = _TaxProvider.UseTaxExemption;
                TaxReportMode_Summary.Checked = !_TaxProvider.RecordTaxBreakdown;
                TaxReportMode_Breakdown.Checked = !TaxReportMode_Summary.Checked;
                SummaryTaxName.Text = _TaxProvider.SummaryTaxName;
            }
        }

        protected void TestButton_Click(object sender, EventArgs e)
        {
            TaxCloudProvider provider = (TaxCloudProvider)_TaxGateway.GetProviderInstance();
            PingRsp result = provider.Ping(_TaxProvider.ApiId, _TaxProvider.ApiKey);
            TestResultPanel.Visible = true;
            TestResultCode.Text = result.ResponseType.ToString();
            if (result.Messages != null && result.Messages.Length > 0)
            {
                TestResultMessageLine.Visible = true;
                TestResultMessage.Text = result.Messages[0].Message;
            }
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                _TaxProvider.EnableTaxCloud = EnableTaxCloud.Checked;
                _TaxProvider.ApiId = ApiId.Text;
                _TaxProvider.ApiKey = ApiKey.Text;
                _TaxProvider.DefaultTIC = DefaultTIC.Text;
                _TaxProvider.ShippingTIC = ShippingTIC.Text;
                _TaxProvider.HandlingTIC = HandlingTIC.Text;
                _TaxProvider.GiftwrapTIC = GiftwrapTIC.Text;


                _TaxProvider.USPSUserId = USPSUserId.Text;
                _TaxProvider.UseDebugMode = DebugMode.Checked;
                _TaxProvider.TaxServiceUrl = TaxServiceUrl.Text;
                _TaxProvider.EnableAddressValidation = EnableAddressValidation.Checked;
                _TaxProvider.TaxName = string.IsNullOrEmpty(TaxName.Text.Trim()) ? "Tax" : TaxName.Text.Trim();
                _TaxProvider.SummaryTaxName = string.IsNullOrEmpty(SummaryTaxName.Text.Trim()) ? "Tax" : SummaryTaxName.Text.Trim();
                _TaxProvider.RecordTaxBreakdown = TaxReportMode_Breakdown.Checked;
                _TaxProvider.UseTaxExemption = UseTaxExemption.Checked;
                _TaxGateway.UpdateConfigData(_TaxProvider.GetConfigData());
                _TaxGateway.Save();
                _TaxGatewayId = _TaxGateway.Id;

                SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
                SavedMessage.Visible = true;
            }
        }
    }
}