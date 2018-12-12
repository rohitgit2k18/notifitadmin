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
using System.Text.RegularExpressions;
using CommerceBuilder.Common;
using CommerceBuilder.Catalog;
using CommerceBuilder.Orders;
using CommerceBuilder.Products;
using CommerceBuilder.Stores;
using CommerceBuilder.Users;
using CommerceBuilder.Utility;
using CommerceBuilder.Reporting;
using System.Collections.Generic;
using CommerceBuilder.Taxes.Providers;
using CommerceBuilder.Taxes;

namespace AbleCommerce.Admin.Taxes.Providers
{
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{
    private List<ITaxProvider> _ThirdPartyProviders;
    private IList<TaxGateway> _ConfiguredGateways;

    private TaxGateway GetGateway(ITaxProvider provider)
    {
        foreach (TaxGateway gateway in _ConfiguredGateways)
        {
            ITaxProvider tempProvider = gateway.GetProviderInstance();
            if (tempProvider != null && tempProvider.GetType() == provider.GetType()) return gateway;
        }
        return null;
    }

    private List<ITaxProvider> GetThirdPartyProviders()
    {
        IList<ITaxProvider> allProviders = TaxProviderDataSource.GetTaxProviders();
        List<ITaxProvider> thirdPartyProviders = new List<ITaxProvider>();
        foreach (ITaxProvider provider in allProviders)
        {
            if (!IsBuiltInTaxProvider(provider))
                thirdPartyProviders.Add(provider);
        }
        return thirdPartyProviders;
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        _ThirdPartyProviders = GetThirdPartyProviders();
        if (_ThirdPartyProviders.Count > 0)
        {
            _ConfiguredGateways = TaxGatewayDataSource.LoadAll("Name");
            NoProvidersPanel.Visible = false;
            ProviderGrid.DataSource = _ThirdPartyProviders;
            ProviderGrid.DataBind();
        }
        else
        {
            ProviderPanel.Visible = false;
        }
    }

    protected bool IsConfigured(object dataItem)
    {
        return (GetGateway((ITaxProvider)dataItem) != null);
    }

    protected string GetConfigUrl(object dataItem)
    {
        ITaxProvider provider = (ITaxProvider)dataItem;
        TaxGateway gateway = GetGateway(provider);
        if (gateway != null)
        {
            string configUrl = provider.GetConfigUrl(Page.ClientScript);
            if (!string.IsNullOrEmpty(configUrl))
            {
                return configUrl + "?TaxGatewayId=" + gateway.Id.ToString();
            }
        }
        return string.Empty;
    }

    protected string GetClassId(object dataItem)
    {
        return Misc.GetClassId(dataItem.GetType());
    }

    protected bool HasLogo(object dataItem)
    {
        string logoUrl = GetLogoUrl(dataItem);
        return !string.IsNullOrEmpty(logoUrl);
    }

    protected bool HasConfigUrl(object dataItem)
    {
        string url = GetConfigUrl(dataItem);
        return !string.IsNullOrEmpty(url);
    }

    protected string GetLogoUrl(object dataItem)
    {
        ITaxProvider provider = (ITaxProvider)dataItem;
        return provider.GetLogoUrl(Page.ClientScript);
    }

    protected bool IsBuiltInTaxProvider(ITaxProvider provider)
    {
        return provider is CommerceBuilder.Services.Taxes.AbleCommerce.AbleCommerceTax;
    }

    private ITaxProvider GetProvider(string classId)
    {
        foreach (ITaxProvider provider in _ThirdPartyProviders)
        {
            if (GetClassId(provider) == classId) return provider;
        }
        return null;
    }

    protected void ProviderGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AddProvider")
        {
            string classId = e.CommandArgument.ToString();
            ITaxProvider provider = GetProvider(classId);
            if (provider != null)
            {
                TaxGateway gateway = new TaxGateway();
                gateway.ClassId = classId;
                gateway.Name = provider.Name;
                gateway.Store = AbleContext.Current.Store;
                //gateway.Save();
                _ConfiguredGateways.Add(gateway);
                string url = GetConfigUrl(provider);
                if (!string.IsNullOrEmpty(url)) Response.Redirect(url);
            }
        }
        else if (e.CommandName == "DeleteProvider")
        {
            string classId = e.CommandArgument.ToString();
            ITaxProvider provider = GetProvider(classId);
            if (provider != null)
            {
                TaxGateway gateway = GetGateway(provider);
                if (gateway != null) gateway.Delete();
            }
        }
        // IF WE DIDN'T REDIRECT, REBIND THE GRID
        _ConfiguredGateways = TaxGatewayDataSource.LoadAll("Name");
        ProviderGrid.DataSource = _ThirdPartyProviders;
        ProviderGrid.DataBind();
    }

    protected void ProviderGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowType == DataControlRowType.DataRow)
        {
            ITaxProvider provider = (ITaxProvider)e.Row.DataItem;
            if (provider.Name == "AbleCommerce")
            {
                e.Row.Visible = false;
            }
        }
    }
}
}
