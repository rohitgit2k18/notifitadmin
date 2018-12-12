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
using System.Collections.Generic;
using CommerceBuilder.DigitalDelivery;

namespace AbleCommerce.Admin.DigitalGoods
{
public partial class Agreements : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected void AddAgreementButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            LicenseAgreement agreement = new LicenseAgreement();
            agreement.DisplayName = AddAgreementName.Text;
            agreement.AgreementText = string.Empty;
            agreement.Save();
            Response.Redirect("EditAgreement.aspx?AgreementId=" + agreement.Id);
        }
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetDefaultButton(AddAgreementName, AddAgreementButton.ClientID);
        AddAgreementName.Focus();
    }

    private Dictionary<int, int> _ProductCounts = new Dictionary<int, int>();
    protected int GetProductCount(object dataItem)
    {
        LicenseAgreement m = (LicenseAgreement)dataItem;
        if (_ProductCounts.ContainsKey(m.Id)) return _ProductCounts[m.Id];
        int count = DigitalGoodDataSource.CountForLicenseAgreement(m.Id);
        _ProductCounts[m.Id] = count;
        return count;
    }

    protected bool HasProducts(object dataItem)
    {
        return (GetProductCount(dataItem) > 0);
    }
}
}
