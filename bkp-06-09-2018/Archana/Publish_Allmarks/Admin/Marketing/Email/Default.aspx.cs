using System;
using System.Web.UI.WebControls;
using AbleCommerce.Code;
using CommerceBuilder.Marketing;
using CommerceBuilder.Utility;

namespace AbleCommerce.Admin.Marketing.Email
{
public partial class _Default : CommerceBuilder.UI.AbleCommerceAdminPage
{
    protected int GetUserCount(object dataItem)
    {
        EmailList m = (EmailList)dataItem;
        return EmailListUserDataSource.CountForEmailList(m.Id);
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        AddEmailListDialog1.ItemAdded += new PersistentItemEventHandler(AddEmailListDialog1_ItemAdded);
    }

    protected void AddEmailListDialog1_ItemAdded(object sender, PersistentItemEventArgs e)
    {
        EmailListGrid.DataBind();
        MainContentAjax.Update();
    }

    protected void EmailListGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("Delete"))
        {
            EmailListDataSource.Delete(AlwaysConvert.ToInt(e.CommandArgument.ToString()));
        }
    }
}}
