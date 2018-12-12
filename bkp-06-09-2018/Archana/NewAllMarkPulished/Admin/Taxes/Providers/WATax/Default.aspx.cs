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
using CommerceBuilder.Taxes.Providers.WATax;
using CommerceBuilder.Taxes;
using CommerceBuilder.Utility;
using System.Collections.Generic;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Taxes.Providers.WATax
{
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private int _TaxGatewayId;
    private TaxGateway _TaxGateway;
    private WATaxProvider _TaxProvider;

    protected void Page_Load(object sender, EventArgs e)
    {
        _TaxGatewayId = TaxGatewayDataSource.GetTaxGatewayIdByClassId(Misc.GetClassId(typeof(WATaxProvider)));
        if (_TaxGatewayId > 0) _TaxGateway = TaxGatewayDataSource.Load(_TaxGatewayId);
        if (_TaxGateway != null) _TaxProvider = _TaxGateway.GetProviderInstance() as WATaxProvider;        
        if (_TaxProvider == null) _TaxProvider = new WATaxProvider();

        if (_TaxGateway == null)
        {
            _TaxGateway = new TaxGateway();

            _TaxGateway.ClassId = Misc.GetClassId(typeof(WATaxProvider));
            _TaxGateway.Name = _TaxProvider.Name;
            _TaxGateway.Store = AbleContext.Current.Store;
        }
        
        if (!Page.IsPostBack)
        {
            TaxName.Text = _TaxProvider.TaxName;
            DebugMode.Checked = _TaxProvider.UseDebugMode;

            // INITIALIZE TAX CODES LIST
            IList<TaxCode> taxCodes = TaxCodeDataSource.LoadAll();
            TaxCodes.DataSource = taxCodes;
            TaxCodes.DataBind();


            // SELECT THE CONFIGURED TAX CODES
            foreach (ListItem taxCodeItem in this.TaxCodes.Items)
            {
                taxCodeItem.Selected = (_TaxProvider.TaxCodes.Contains(AlwaysConvert.ToInt(taxCodeItem.Value)));
            }
        }
    }
    protected void DeleteButton_Click(object sender, EventArgs e)
    {
        if (_TaxGateway != null) _TaxGateway.Delete();
        Response.Redirect("~/Admin/Taxes/Providers/Default.aspx");
    }
    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            _TaxProvider.TaxName = TaxName.Text;
            _TaxProvider.UseDebugMode = DebugMode.Checked;
            List<int> taxCodes = new List<int>();
            foreach (ListItem taxCodeItem in TaxCodes.Items)
            {
                if (taxCodeItem.Selected) taxCodes.Add(AlwaysConvert.ToInt(taxCodeItem.Value));
            }
            _TaxProvider.TaxCodes.Clear();
            _TaxProvider.TaxCodes.AddRange(taxCodes);
            _TaxGateway.UpdateConfigData(_TaxProvider.GetConfigData());
            _TaxGateway.Save();
            _TaxGatewayId = _TaxGateway.Id;

            SavedMessage.Visible = true;
            SavedMessage.Text = string.Format(SavedMessage.Text, LocaleHelper.LocalNow);
        }
    }
    
}
}
