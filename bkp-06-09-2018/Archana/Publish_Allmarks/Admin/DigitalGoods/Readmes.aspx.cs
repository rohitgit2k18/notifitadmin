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
public partial class Readmes : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected void AddReadmeButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            Readme readme = new Readme();
            readme.DisplayName = AddReadmeName.Text;
            readme.ReadmeText = string.Empty;
            readme.Save();
            Response.Redirect("EditReadme.aspx?ReadmeId=" + readme.Id);
        }
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        AbleCommerce.Code.PageHelper.SetDefaultButton(AddReadmeName, AddReadmeButton.ClientID);
        AddReadmeName.Focus();
    }

    private Dictionary<int, int> _ProductCounts = new Dictionary<int, int>();
    protected int GetProductCount(object dataItem)
    {
        Readme m = (Readme)dataItem;
        if (_ProductCounts.ContainsKey(m.Id)) return _ProductCounts[m.Id];
        int count = DigitalGoodDataSource.CountForReadme(m.Id);
        _ProductCounts[m.Id] = count;
        return count;
    }

    protected bool HasProducts(object dataItem)
    {
        return (GetProductCount(dataItem) > 0);
    }
}
}
