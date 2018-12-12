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
using CommerceBuilder.UI;
using System.Collections.Generic;
using CommerceBuilder.Utility;
using CommerceBuilder.Marketing;
using CommerceBuilder.Users;
using CommerceBuilder.Common;

namespace AbleCommerce.Admin.Marketing.Discounts
{
public partial class _Default : AbleCommerceAdminPage
{
    protected string GetNames(VolumeDiscount item)
    {
        List<string> groupNames = new List<string>();
        foreach (Group group in item.Groups)
        {
            groupNames.Add(group.Name);
        }
        return string.Join(", ", groupNames.ToArray());
    }

    protected void VolumeDiscountGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("Copy"))
        {
            int volumeDiscountId = AlwaysConvert.ToInt(e.CommandArgument);
            VolumeDiscount volumeDiscount = VolumeDiscountDataSource.Load(volumeDiscountId);
            VolumeDiscount copy = volumeDiscount.Copy(true);
            if (copy != null)
            {
                copy.Name = "Copy of " + copy.Name;
                copy.Save();
            }
            VolumeDiscountGrid.DataBind();
        }
    }

    protected void AddButton_Click(object sender, EventArgs e)
    {
        VolumeDiscount newDiscount = new VolumeDiscount();
        newDiscount.Store = AbleContext.Current.Store;
        newDiscount.Name = "New Discount";
        newDiscount.Save();

        VolumeDiscountLevel newDiscountLevel = new VolumeDiscountLevel(newDiscount, 0, 0, 0, true);
        newDiscount.Levels.Add(newDiscountLevel);
        newDiscount.Save();
        Response.Redirect("EditDiscount.aspx?VolumeDiscountId=" + newDiscount.Id.ToString() + "&IsAdd=1");
    }

}
}
