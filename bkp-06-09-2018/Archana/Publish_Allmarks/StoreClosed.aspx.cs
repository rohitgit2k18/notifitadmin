using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommerceBuilder.Common;
using CommerceBuilder.Stores;

namespace AbleCommerce
{
    public partial class StoreClosed : CommerceBuilder.UI.AbleCommercePage
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            if (AbleContext.Current.Store.Settings.StoreFrontClosed == StoreClosureType.Open || (AbleContext.Current.Store.Settings.StoreFrontClosed == StoreClosureType.ClosedForNonAdminUsers && AbleContext.Current.User.IsAdmin))
            {
                Response.Redirect("Default.aspx");
            }
        }

        protected void Page_Load(Object sender, EventArgs e) 
        {
            PHContent.Controls.Add(new LiteralControl(AbleContext.Current.Store.Settings.StoreFrontClosedMessage));
        }
    }
}