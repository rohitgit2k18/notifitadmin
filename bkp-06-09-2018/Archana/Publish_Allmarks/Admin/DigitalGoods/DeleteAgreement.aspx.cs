using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using CommerceBuilder.Common;
using CommerceBuilder.DigitalDelivery;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.DigitalGoods
{
public partial class DeleteAgreement : CommerceBuilder.UI.AbleCommerceAdminPage
{
    int _AgreementId = 0;
    LicenseAgreement _Agreement;

    protected void Page_Init(object sender, System.EventArgs e)
    {
        _AgreementId = AlwaysConvert.ToInt(Request.QueryString["AgreementId"]);
        _Agreement = LicenseAgreementDataSource.Load(_AgreementId);
        if (_Agreement == null) Response.Redirect("Default.aspx");
        Caption.Text = string.Format(Caption.Text, _Agreement.DisplayName);
        InstructionText.Text = string.Format(InstructionText.Text, _Agreement.DisplayName);
        BindAgreements();
        ProductsGrid.DataSource = _Agreement.DigitalGoods;
        ProductsGrid.DataBind();
    }

    protected void CancelButton_Click(object sender, System.EventArgs e)
    {
        Response.Redirect("Agreements.aspx");
    }

    protected void DeleteButton_Click(object sender, System.EventArgs e)
    {
        if (Page.IsValid)
        {
            _Agreement.Delete(AlwaysConvert.ToInt(AgreementList.SelectedValue));
            Response.Redirect("Agreements.aspx");
        }
    }

    private void BindAgreements()
    {
        IList<LicenseAgreement> agreements = LicenseAgreementDataSource.LoadAll("DisplayName");
        int index = agreements.IndexOf(_AgreementId);
        if (index > -1) agreements.RemoveAt(index);
        AgreementList.DataSource = agreements;
        AgreementList.DataBind();
    }
}
}
